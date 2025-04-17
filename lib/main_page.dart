import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: const Color(0xFF3083FF),
        centerTitle: true,
      ),
      drawer: Drawer(
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
                  const SizedBox(height: 15),
                  const Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Sign In'),
              onTap: () => Navigator.pushNamed(context, '/signin'),
            ),
            ListTile(
              title: const Text('Sign Up'),
              onTap: () => Navigator.pushNamed(context, '/signup'),
            ),
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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/fuelx_logo.png',
                height: 150,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to FuelX',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Started', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
