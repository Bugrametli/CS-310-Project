import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'main_page.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'profile.dart';
import 'food_detail.dart';
import 'search.dart';
import 'settings.dart';
import 'nutrition_plan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FuelX App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF3083FF),
        ),
      ),
      // Use AuthGate as the home to handle auth state
      home: const AuthGate(),
      routes: {
        '/signin': (_) => const SignInScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/detail': (_) => const FoodDetailScreen(),
        '/search': (_) => const SearchResultsScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/plan': (_) => const NutritionPlanScreen(),
        '/main': (_) => const MainPage(),
      },
    );
  }
}

/// A simple widget that listens to the authentication state
/// and shows either the sign-in flow or the main app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If logged in
        if (snapshot.hasData) {
          return const MainPage();
        }
        // Not logged in
        return const SignInScreen();
      },
    );
  }
}
