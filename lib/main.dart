import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'profile.dart';
import 'food_detail.dart';
import 'search.dart';
import 'settings.dart';
import 'nutrition_plan.dart';
import 'providers/meal_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

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
    return ChangeNotifierProvider(
      create: (_) => MealProvider()..listenToMeals('default'),
      child: MaterialApp(
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
        home: const AuthGate(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/detail': (context) => const FoodDetailScreen(),
          '/search': (context) => const SearchResultsScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/plan': (context) => const NutritionPlanScreen(),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const SignInScreen();
      },
    );
  }
}
