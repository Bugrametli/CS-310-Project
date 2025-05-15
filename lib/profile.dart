import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final aimController = TextEditingController();
  final dietTypeController = TextEditingController();
  final startWeightController = TextEditingController();
  final currentWeightController = TextEditingController();
  final nutritionController = TextEditingController();

  String resultText = '';
  String savedNutrition = '';
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileFromFirestore();
  }

  Future<void> _loadProfileFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      ageController.text = data['age'] ?? '';
      aimController.text = data['aim'] ?? '';
      dietTypeController.text = data['dietType'] ?? '';
      startWeightController.text = data['startWeight'] ?? '';
      currentWeightController.text = data['currentWeight'] ?? '';
      nutritionController.text = data['nutrition'] ?? '';
      savedNutrition = nutritionController.text;
      _calculateProgress();
    }
  }

  Future<void> _saveProfileToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': nameController.text,
      'age': ageController.text,
      'aim': aimController.text,
      'dietType': dietTypeController.text,
      'startWeight': startWeightController.text,
      'currentWeight': currentWeightController.text,
      'nutrition': nutritionController.text,
    }, SetOptions(merge: true));
  }

  void _calculateProgress() {
    final start = double.tryParse(startWeightController.text);
    final current = double.tryParse(currentWeightController.text);

    if (start != null && current != null) {
      final difference = (start - current).abs();
      if (current > start) {
        resultText = "You've gained ${difference.toStringAsFixed(1)} kg!";
      } else if (current < start) {
        resultText = "You've lost ${difference.toStringAsFixed(1)} kg!";
      } else {
        resultText = "Your weight hasn't changed.";
      }
    } else {
      resultText = 'Please enter valid weights.';
    }

    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    aimController.dispose();
    dietTypeController.dispose();
    startWeightController.dispose();
    currentWeightController.dispose();
    nutritionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF3083FF),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mavi kutu
            Container(
              color: const Color(0xFF3083FF),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                    backgroundColor: Colors.purpleAccent,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(nameController, 'Name', isEditing),
                  _buildTextField(ageController, 'Age', isEditing),
                  _buildTextField(aimController, 'Aim (loss or gain)', isEditing),
                  _buildTextField(dietTypeController, 'Diet Type', isEditing),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('My Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Analysis', style: TextStyle(color: Colors.lightBlue)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    resultText.isEmpty ? 'No data yet.' : resultText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(startWeightController, 'Starting Weight', true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField(currentWeightController, 'Current Weight', true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      _calculateProgress();
                      _saveProfileToFirestore();
                    },
                    child: const Text("Calculate Progress"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Nutrition
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('My Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nutritionController,
              onChanged: (value) {
                savedNutrition = value;
                _saveProfileToFirestore();
                setState(() {});
              },
              decoration: const InputDecoration(
                labelText: "Nutrition",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (savedNutrition.isNotEmpty)
              Text("Nutrition: $savedNutrition"),

            const SizedBox(height: 30),

            // Butonlar
            isEditing
                ? ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isEditing = false;
                      });
                      await _saveProfileToFirestore();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile saved')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Save Profile', style: TextStyle(color: Colors.white)),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                  ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/signin');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
