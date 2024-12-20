import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _imageFile = '';
  final picker = ImagePicker();

  Future<void> _saveImage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', _imageFile);
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageFile = prefs.getString('imagePath') ?? '';
    });
  }

  Future<void> _getImage(ImageSource source) async {
    if (kIsWeb && source == ImageSource.camera) {
      debugPrint('Kamera tidak didukung di Web. Gunakan perangkat fisik.');
      return;
    }

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile.path;
        });
        _saveImage();
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.indigo[50],
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_enhance, color: Colors.blue),
                title: const Text('Camera'),
                onTap: () {
                  debugPrint('Kamera dipanggil');
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  String email = '';
  String phone = '';


  // Fungsi untuk mendekripsi data dari SharedPreferences
  Future<void> _loadProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? keyString = prefs.getString('key');
    final String? ivString = prefs.getString('iv');

    if (keyString != null && ivString != null) {
      final key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Dekripsi setiap data yang terenkripsi
      setState(() {
        fullName = encrypter.decrypt64(prefs.getString('name') ?? '', iv: iv);
        userName = encrypter.decrypt64(prefs.getString('username') ?? '', iv: iv);
        email = encrypter.decrypt64(prefs.getString('email') ?? '', iv: iv);
        phone = encrypter.decrypt64(prefs.getString('notelepon') ?? '', iv: iv);
        isSignedIn = fullName.isNotEmpty && userName.isNotEmpty;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  void signOut() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Navigasi ke halaman Sign In
  void signIn() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile.isNotEmpty
                          ? FileImage(File(_imageFile))
                          : const AssetImage('images/logo.jpg') as ImageProvider,
                      backgroundColor: Colors.white,
                      child: isSignedIn
                          ? null
                          : const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: _showPicker,
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildProfileInfoRow('Nama Lengkap', fullName, Icons.person),
            _buildProfileInfoRow('Username', userName, Icons.account_circle),
            _buildProfileInfoRow('Email', email, Icons.email),
            _buildProfileInfoRow('No Telepon', phone, Icons.phone),

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