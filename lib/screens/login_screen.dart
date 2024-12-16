import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorText = '';
  bool _isSignedIn = false;
  bool _obscurePassword = true;

  Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs(SharedPreferences prefs) async {
    final encryptedUsername = prefs.getString('username') ?? '';
    final encryptedPassword = prefs.getString('password') ?? '';
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';

    if (keyString.isEmpty || ivString.isEmpty || encryptedUsername.isEmpty || encryptedPassword.isEmpty) {
      return {};
    }

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    return {'username': decryptedUsername, 'password': decryptedPassword};
  }

  void _signIn() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      if (username.isNotEmpty && password.isNotEmpty) {
        final data = await _retrieveAndDecryptDataFromPrefs(prefs);
        if (data.isNotEmpty) {
          final decryptedUsername = data['username'];
          final decryptedPassword = data['password'];
          if (username == decryptedUsername && password == decryptedPassword) {
            setState(() {
              _errorText = '';
              _isSignedIn = true;
            });
            prefs.setBool('isSignedIn', true);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/mainscreen');
            });
          } else {
            setState(() {
              _errorText = 'Username atau password salah';
            });
          }
        } else {
          setState(() {
            _errorText = 'Data kredensial tidak ditemukan';
          });
        }
      } else {
        setState(() {
          _errorText = 'Username dan password tidak boleh kosong';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Form Login
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Memberikan transparansi pada background form
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 300,
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.account_box),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Masukan Password",
                            errorText: _errorText.isNotEmpty ? _errorText : null,
                            border: const OutlineInputBorder(),
                            icon: Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          obscureText: _obscurePassword,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          onPressed: _signIn,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'Belum Memiliki Akun ? ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Daftar Sekarang !',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
