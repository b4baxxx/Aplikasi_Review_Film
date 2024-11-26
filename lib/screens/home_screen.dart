import 'package:flutter/material.dart';
import '../data/movie_data.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Review Film'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(
            leading: Image.asset(movie.imageUrl, width: 50, height: 50),
            title: Text(movie.title),
            subtitle: Text(movie.description),
            onTap: () {
              Navigator.pushNamed(context, '/movie-detail', arguments: movie);
            },

          );
        },
      ),
    );
  }
}
