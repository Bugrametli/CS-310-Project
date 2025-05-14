import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String mealName;
  final int calories;
  final String createdBy;
  final DateTime createdAt;
  final String mealType;

  Meal({
    required this.id,
    required this.mealName,
    required this.calories,
    required this.createdBy,
    required this.createdAt,
    required this.mealType,
  });

  Map<String, dynamic> toMap() {
    return {
      'mealName': mealName,
      'calories': calories,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'mealType': mealType,
    };
  }

  factory Meal.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      mealName: data['mealName'] ?? '',
      calories: data['calories'] ?? 0,
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      mealType: data['mealType'] ?? '',
    );
  }

  // ✅ Bu methodu providerda kullanmak için:
  static Meal fromFirestore(Map<String, dynamic> data, String id) {
    return Meal(
      id: id,
      mealName: data['mealName'] ?? '',
      calories: data['calories'] ?? 0,
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      mealType: data['mealType'] ?? '',
    );
  }
}
