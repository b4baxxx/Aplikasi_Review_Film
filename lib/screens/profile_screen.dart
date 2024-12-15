import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteMovieCount = 0;

  // Enkripsi key
  final key = encrypt.Key.fromUtf8('');
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk memuat data pengguna dari SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
      userName = prefs.getString('username') ?? '';
      fullName = _decryptName(prefs.getString('name') ?? '');
      favoriteMovieCount = prefs.getInt('favoriteMovieCount') ?? 0;
    });
  }

  // Fungsi untuk mengenkripsi nama
  String _encryptName(String name) {
    final encrypted = encrypter.encrypt(name);
    return encrypted.base64;
  }

  // Fungsi untuk mendekripsi nama
  String _decryptName(String encryptedName) {
    final decrypted = encrypter.decrypt64(encryptedName);
    return decrypted;
  }

  // Fungsi sign in
  void signIn() {
    Navigator.pushNamed(context, '/register');
  }

  // Fungsi sign out
  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mengubah nilai isSignedIn menjadi false dan menghapus data
    prefs.setBool('isSignedIn', false);
    prefs.setString('name', '');
    prefs.setString('username', '');
    prefs.setString('password', '');
    prefs.setInt('favoriteMovieCount', 0);

    setState(() {
      isSignedIn = false;
      fullName = '';
      userName = '';
      favoriteMovieCount = 0;
    });
  }

  // Fungsi untuk mengedit nama
  void editFullName() async {
    String newName = 'New User'; // Ganti dengan input pengguna

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encryptedName = _encryptName(newName);

    prefs.setString('name', encryptedName);

    setState(() {
      fullName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200, width: double.infinity, color: Colors.blue,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/profile.jpg'),
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: () {
                              editFullName(); // Mengedit nama saat icon diklik
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.blue[50],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Divider(color: Colors.blue[100]),
                SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Pengguna',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': $userName',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Divider(color: Colors.blue[100]),
                SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Nama',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': $fullName',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (isSignedIn) Icon(Icons.edit),
                  ],
                ),
                SizedBox(height: 4),
                Divider(color: Colors.blue[100]),
                SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Favorite',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': $favoriteMovieCount',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                SizedBox(height: 20),
                isSignedIn
                    ? TextButton(onPressed: signOut, child: Text('Sign Out'))
                    : TextButton(onPressed: signIn, child: Text('Sign In')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
