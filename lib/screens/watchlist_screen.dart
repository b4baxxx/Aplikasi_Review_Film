import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_review_film/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_review_film/models/movie.dart';
import 'package:aplikasi_review_film/data/movie_data.dart';


class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<Movie> favoriteList = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_movies') ?? [];

    setState(() {
      favoriteList = movieList
          .where((movie) => favoriteIds.contains(movie.id.toString()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Watchlist",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: favoriteList.isEmpty ? const Center(
        child: Text(
          "Watchlist tidak ditemukan",
          style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
              fontWeight: FontWeight.w200),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: favoriteList.length,
          itemBuilder: (context, index) {
            final movie = favoriteList[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    movie.imageAsset,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  movie.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  movie.type,
                  style:
                  const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final favoriteIds =
                        prefs.getStringList('favorite_movies') ?? [];
                    favoriteIds.remove(movie.id.toString());
                    await prefs.setStringList('favorite_movies', favoriteIds);

                    setState(() {
                      favoriteList.removeAt(index);
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(movie: movie),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}