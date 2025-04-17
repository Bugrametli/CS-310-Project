import 'package:flutter/material.dart';
import 'main_page.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'profile.dart';
import 'food_detail.dart';
import 'search.dart';
import 'settings.dart';
import 'nutrition_plan.dart';

void main() {
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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/detail': (context) => const FoodDetailScreen(),
        '/search': (context) => const SearchResultsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/plan': (context) => const NutritionPlanScreen(),
      },
    );
  }
}
