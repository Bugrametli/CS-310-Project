import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final meals = mealProvider.allMeals;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3083FF),
        title: const Text('Food Detail'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (route) => Navigator.pushNamed(context, route),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: '/signin', child: Text('Sign In')),
              const PopupMenuItem(value: '/signup', child: Text('Sign Up')),
              const PopupMenuItem(value: '/profile', child: Text('Profile')),
              const PopupMenuItem(value: '/detail', child: Text('Details')),
              const PopupMenuItem(value: '/search', child: Text('Search')),
              const PopupMenuItem(value: '/settings', child: Text('Settings')),
              const PopupMenuItem(value: '/plan', child: Text('Nutrition Plan')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: meals.isEmpty
            ? const Center(child: Text('No meals available.'))
            : ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.mealName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Calories: ${meal.calories} kcal',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Meal Type: ${meal.mealType}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
