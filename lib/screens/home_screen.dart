import 'package:aplikasi_review_film/data/movie_data.dart';
import 'package:aplikasi_review_film/models/movie.dart';
import 'package:aplikasi_review_film/widgets/item_card.dart';
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
        backgroundColor: Colors.grey, // warna background grey
        title: Text('MovieScope',),),
      backgroundColor: Colors.white,
      body: GridView.builder( // parameter
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), // menentukan tata letak grid dengan jumlah kolom yang tetap (fixed)
        padding: EdgeInsets.all(8),
        itemCount: movieList.length, // total elemen pada directory data
        itemBuilder: (context, index) {
          final Movie movie = movieList[index]; // parameter direcotry models yg mengambil data dari movieList[directory data]
          return ItemCard(movie: movie); // mengambil fungsi dari ItemCard dengan import package widgets ItemCard
        },
      ),
    );
  }
 }