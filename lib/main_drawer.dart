import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF3083FF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/fuelx_logo.png', height: 60),
                const SizedBox(height: 12),
                const Text(
                  'FuelX Menu',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          if (user == null) ...[
            ListTile(
              title: const Text('Sign In'),
              onTap: () => Navigator.pushNamed(context, '/signin'),
            ),
            ListTile(
              title: const Text('Sign Up'),
              onTap: () => Navigator.pushNamed(context, '/signup'),
            ),
          ] else ...[
            ListTile(
              title: const Text('Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              title: const Text('Details'),
              onTap: () => Navigator.pushNamed(context, '/detail'),
            ),
            ListTile(
              title: const Text('Search'),
              onTap: () => Navigator.pushNamed(context, '/search'),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              title: const Text('Nutrition Plan'),
              onTap: () => Navigator.pushNamed(context, '/plan'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
              },
            ),
          ],
        ],
      ),
    );
  }
}
