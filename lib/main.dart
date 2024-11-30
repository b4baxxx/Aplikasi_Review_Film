import 'package:aplikasi_review_film/data/movie_data.dart';
import 'package:aplikasi_review_film/models/movie.dart';
import 'package:aplikasi_review_film/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Populer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: DetailScreen(),
      home: HomeScreen(),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

