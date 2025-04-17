import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'main_drawer.dart';

class NutritionPlanScreen extends StatelessWidget {
  const NutritionPlanScreen({super.key});

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget buildAddRow(String label) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('+ Add'),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3083FF),
        title: const Text('Personalized Nutrition Plan'),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 45,
                      color: Colors.orange,
                      title: 'Carbs',
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.blue,
                      title: 'Protein',
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: Colors.green,
                      title: 'Fat',
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Scan Barcode'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Shopping List'),
                ),
              ],
            ),
            sectionTitle('Daily Meals & Recipes'),
            buildAddRow('Breakfast'),
            buildAddRow('Lunch'),
            buildAddRow('Dinner'),
            buildAddRow('Snack'),
            sectionTitle('Water & Protein Intake'),
            buildAddRow('Water: [Glass icons]'),
            buildAddRow('Protein [icon/ Value]'),
            sectionTitle('Suggested Meals (Meal Plan Sync)'),
            buildAddRow('Meal Card 1'),
            buildAddRow('Meal Card 2'),
            buildAddRow('Meal Card 3'),
          ],
        ),
      ),
    );
  }
}
