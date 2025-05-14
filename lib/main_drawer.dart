import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF3083FF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/fuelx_logo.png', height: 60),
                const SizedBox(height: 15),
                const Text(
                  'FuelX Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: const Text('Details'),
                  onTap: () => Navigator.pushNamed(context, '/detail'),
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search'),
                  onTap: () => Navigator.pushNamed(context, '/search'),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: const Text('Nutrition Plan'),
                  onTap: () => Navigator.pushNamed(context, '/plan'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              // Firebase Auth çıkış
              await FirebaseAuth.instance.signOut();

              // Provider'daki verileri temizle
              if (context.mounted) {
                Provider.of<MealProvider>(context, listen: false).resetMeals();
              }

              // Sayfaları kapat ve SignIn'e yönlendir
              if (context.mounted) {
                Navigator.of(context).pop(); // Drawer'ı kapat
                Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
