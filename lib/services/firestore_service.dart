import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meal.dart';

class FirestoreService {
  final CollectionReference mealsCollection = FirebaseFirestore.instance.collection('meals');

  Future<void> addMeal(String name, int calories) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await mealsCollection.add({
      'mealName': name,
      'calories': calories,
      'createdBy': uid,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> deleteMeal(String mealId) async {
    await mealsCollection.doc(mealId).delete();
  }

  Stream<List<Meal>> getMealsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return mealsCollection
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Meal.fromDocument(doc)).toList());
  }
}