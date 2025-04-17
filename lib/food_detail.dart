import 'package:flutter/material.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://source.unsplash.com/featured/?healthyfood',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Grilled Chicken Salad',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'A delicious and healthy grilled chicken salad packed with nutrients and flavor. Perfect for lunch or dinner.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Calories: 350 kcal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Protein: 25g\nCarbs: 15g\nFat: 18g',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Add to Favorites',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
