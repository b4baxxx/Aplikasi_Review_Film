import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  String email = '';
  String phone = '';
  int favorite = 0;



  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('Nama') ?? '';
      userName = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('notelpon') ?? '';
      favorite = prefs.getInt('favorite') ?? 0;
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
    });

  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', false);

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue,
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage('images/profile.jpg'),
                  backgroundColor: Colors.white,
                  child: isSignedIn
                      ? null
                      : const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildProfileInfoRow('Nama Lengkap', fullName, Icons.person),
            _buildProfileInfoRow('Username', userName, Icons.account_circle),
            _buildProfileInfoRow('Email', email, Icons.email),
            _buildProfileInfoRow('No Telepon', phone, Icons.phone),
            _buildProfileInfoRow('Favorit', favorite.toString(), Icons.favorite),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: isSignedIn ? signOut : signOut,
                style: TextButton.styleFrom(
                  backgroundColor: isSignedIn ? Colors.redAccent : Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text(isSignedIn ? 'Log Out' : 'Log In'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrangeAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}