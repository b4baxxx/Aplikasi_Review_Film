import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart'as encrypt;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _obscurePassword = true;

  void _signUp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = _nameController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorText =
        'Minimal 8 karakter, kombinasi [A-Z], [a-z], [0-9], [!@#\$%^&*(),.?":{}|<>]';
      });
      return;
    }

    if(name.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encryptedName = encrypter.encrypt(name, iv: iv);
      final encryptedUsername = encrypter.encrypt(username, iv: iv);
      final encryptedPassword = encrypter.encrypt(password, iv: iv);


      prefs.setString('fullname', encryptedName.base64);
      prefs.setString('username', encryptedUsername.base64);
      prefs.setString('password', encryptedPassword.base64);
      prefs.setString('key', key.base64);
      prefs.setString('iv', iv.base64);
    }

    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.grey,
      ),
      body: Stack(
        children: [
          // Background Gambar
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/cinema.jpg"), // Path gambar
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Efek Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // Efek blur
            child: Container(
              color: Colors.black.withOpacity(0.3), // Warna semi-transparan
            ),
          ),
          // Form Registrasi
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70, // Warna latar input
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Pengguna',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Kata Sandi',
                          errorText: _errorText.isNotEmpty ? _errorText : null,
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signUp,
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
