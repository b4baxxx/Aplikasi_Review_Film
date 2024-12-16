import 'package:aplikasi_review_film/data/movie_data.dart';
import 'package:aplikasi_review_film/models/movie.dart';
import 'package:aplikasi_review_film/screens/home_screen.dart';
import 'package:aplikasi_review_film/screens/login_screen.dart';
import 'package:aplikasi_review_film/screens/profile_screen.dart';
import 'package:aplikasi_review_film/screens/register_screen.dart';
import 'package:aplikasi_review_film/screens/search_screen.dart';
import 'package:aplikasi_review_film/screens/watchlist_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movie Scope',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: DetailScreen(),
      // home: ProfileScreen(),
      // home: HomeScreen(),
      //home: ChatScreen(),
      //home: SignInScreen(),
      //home: SignUpScreen(),
      //home: SearchScreen(),
      //home: FavoriteScreen(),
      home: MainScreen(),
      initialRoute: '/',
      routes: {
        '/home' : (context) => const MainScreen(),
        '/login' : (context) =>  LoginScreen(),
        '/register' : (context) =>  RegisterScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //deklarasi Variabel
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomeScreen(),
    const SearchScreen(),
    const WatchlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue[50],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.blue,),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_later, color: Colors.blue,),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.blue,),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blue[100],
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
