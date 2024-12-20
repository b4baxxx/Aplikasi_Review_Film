import 'package:aplikasi_review_film/data/movie_data.dart';
import 'package:aplikasi_review_film/models/movie.dart';
import 'package:aplikasi_review_film/widgets/item_card.dart';
import 'package:aplikasi_review_film/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('MovieScope'),
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: EdgeInsets.all(8),
        itemCount: movieList.length,
        itemBuilder: (context, index) {
          final Movie movie = movieList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(movie: movie),
                ),
              );
            },
            child: ItemCard(movie: movie),
          );
        },
      ),
    );
  }
}
