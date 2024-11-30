import 'package:aplikasi_review_film/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_review_film/screens/detail_screen.dart';

class ItemCard extends StatelessWidget {
  final Movie movie;

  ItemCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(movie: movie),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(4),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  movie.imageAsset,
                  width: double.infinity, // Memastikan gambar mengisi lebar
                  height: 220,
                  fit: BoxFit.fill, // Gambar akan dipanjangkan sesuai ruang
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 6),
              child: Text(
                movie.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                movie.genre,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
