import 'package:aplikasi_review_film/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_review_film/data/movie_data.dart';
import 'package:aplikasi_review_film/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Movie> wishlistMovie = [];

  @override
  void initState() {
    super.initState();
    _loadWishlistMovie();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadWishlistMovie();
  }

  Future<void> _loadWishlistMovie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil ID film favorit dari SharedPreferences
    List<String> wishlistMovieIds = prefs
        .getKeys()
        .where((key) => key.startsWith('favorite_') && prefs.getBool(key) == true)
        .map((key) => key.substring('favorite_'.length))
        .toList();

    print('Wishlist IDs: $wishlistMovieIds');

    setState(() {
      wishlistMovie = movieList.where((movie) {
        return wishlistMovieIds.contains(movie.id.toString());
      }).toList();
    });
    print(prefs.getKeys()); // Debug key yang disimpan
    print(wishlistMovieIds); // Debug ID yang dimuat

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist Movie'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadWishlistMovie,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: wishlistMovie.length,
          itemBuilder: (context, index) {
            Movie movie = wishlistMovie[index];
            print('Showing movie: ${movie.name}');
            return Stack(
              children: [
                ItemCard(movie: movie),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('favorite_${movie.id}', false);
                      _loadWishlistMovie();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
