import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';
import 'main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NutritionPlanScreen extends StatefulWidget {
  const NutritionPlanScreen({super.key});

  @override
  State<NutritionPlanScreen> createState() => _NutritionPlanScreenState();
}

class _NutritionPlanScreenState extends State<NutritionPlanScreen> {
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  bool showForm = false;
  String currentMealType = 'Breakfast';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MealProvider>(context, listen: false);
      provider.listenToAllMeals();
      provider.listenToMeals(currentMealType);
    });
  }

  void switchMealType(String type) {
    setState(() {
      currentMealType = type;
      showForm = false;
    });

    final provider = Provider.of<MealProvider>(context, listen: false);
    provider.resetMeals();
    provider.listenToMeals(currentMealType);
  }

  Widget buildMealTypeSelector(MealProvider provider) {
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    return Column(
      children: mealTypes.map((type) {
        final isActive = currentMealType == type;
        final totalCalories = provider.allMeals
            .where((meal) => meal.mealType == type)
            .fold<int>(0, (sum, meal) => sum + meal.calories);

        return ListTile(
          title: Text('$type - $totalCalories cal'),
          trailing: ElevatedButton(
            onPressed: () => switchMealType(type),
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.blue : Colors.grey[300],
              foregroundColor: isActive ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Select'),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to view your nutrition plan")),
      );
    }

    final provider = Provider.of<MealProvider>(context);

    Map<String, int> caloriesData = {
      'Breakfast': 0,
      'Lunch': 0,
      'Dinner': 0,
      'Snack': 0,
    };

    for (var meal in provider.allMeals) {
      caloriesData[meal.mealType] =
          (caloriesData[meal.mealType] ?? 0) + meal.calories;
    }

    final int totalCalories = caloriesData.values.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Nutrition Plan'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3083FF),
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (totalCalories > 0)
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sections: caloriesData.entries
                        .where((e) => e.value > 0)
                        .map((e) {
                          final color = {
                            'Breakfast': Colors.orange,
                            'Lunch': Colors.blue,
                            'Dinner': Colors.green,
                            'Snack': Colors.purple,
                          }[e.key]!;
                          final percentage =
                              ((e.value / totalCalories) * 100).toStringAsFixed(0);
                          return PieChartSectionData(
                            value: e.value.toDouble(),
                            title: '${e.key}\n$percentage%',
                            color: color,
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            if (totalCalories == 0)
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 16),
                child: Text(
                  'No meals yet to show in chart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Select Meal Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            buildMealTypeSelector(provider),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() => showForm = !showForm);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(showForm ? 'Cancel' : '+ Add $currentMealType Meal'),
            ),
            if (showForm) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _mealNameController,
                decoration: InputDecoration(
                  labelText: 'Meal Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Calories',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final name = _mealNameController.text.trim();
                  final calories = int.tryParse(_caloriesController.text.trim());
                  if (name.isNotEmpty && calories != null) {
                    provider.addMeal(name, calories, currentMealType);
                    _mealNameController.clear();
                    _caloriesController.clear();
                    setState(() => showForm = false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3083FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Submit Meal',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              'Your Meals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...provider.meals.map(
              (meal) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(meal.mealName),
                  subtitle: Text('${meal.calories} cal'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.deleteMeal(meal.id),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
