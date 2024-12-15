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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieScope',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: DetailScreen(),
      // home: HomeScreen(),
      // home: ProfileScreen(),
      // home: SearchScreen(),
      // home: RegisterScreen(),
      // home: MainScreen(),
      // home: LoginScreen(),
      initialRoute: '/login',
      routes: {
        '/homescreen': (context) => const HomeScreen(),
        '/watchlist': (context) => WatchlistScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
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
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.black,),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_later, color: Colors.black,),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black,),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.deepPurple,
        ),
      ),
    );
  }
}

