import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _showChangePasswordDialog() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final cred = EmailAuthProvider.credential(
                email: user!.email!,
                password: currentController.text,
              );

              try {
                await user.reauthenticateWithCredential(cred);
                await user.updatePassword(newController.text);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password updated successfully")),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to change password: $e")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About This App"),
        content: const Text(
          "This app was created as a CS310 project.\n\n"
          "Developed by:\n"
          "- Eda Nur Güler\n"
          "- Almira Aygün\n"
          "- Sarp Cankur\n"
          "- Buğra Metli",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF3083FF),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Account Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _showChangePasswordDialog,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notification Preferences'),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: _toggleNotification,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Privacy Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Gelecek geliştirme için yer tutucu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Coming soon...")),
                  );
                },
              ),
              const Divider(height: 40),
              const Text('Other', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('About App'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _showAboutDialog,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Gelecek geliştirme için yer tutucu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Coming soon...")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
