import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/firestore_service.dart';

class MealProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Meal> _meals = [];
  List<Meal> get meals => _meals;

  List<Meal> _allMeals = [];
  List<Meal> get allMeals => _allMeals;

  // Dinamik olarak sadece bir mealType’a özel öğünleri getirir
  void listenToMeals(String mealType) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('meals')
        .where('createdBy', isEqualTo: user.uid)
        .where('mealType', isEqualTo: mealType)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _meals = snapshot.docs
          .map((doc) => Meal.fromFirestore(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  // Tüm öğünleri (breakfast, lunch...) dinlemek için
  void listenToAllMeals() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('meals')
        .where('createdBy', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      _allMeals = snapshot.docs
          .map((doc) => Meal.fromFirestore(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  void resetMeals() {
    _meals = [];
    notifyListeners();
  }

  Future<void> addMeal(String name, int calories, String mealType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('meals').add({
      'mealName': name,
      'calories': calories,
      'createdAt': Timestamp.now(),
      'createdBy': user.uid,
      'mealType': mealType,
    });
  }

  Future<void> deleteMeal(String id) async {
    await _firestoreService.deleteMeal(id);
  }

  Future<void> updateMeal(String id, String name, int calories) async {
    await FirebaseFirestore.instance.collection('meals').doc(id).update({
      'mealName': name,
      'calories': calories,
    });
  }
}
