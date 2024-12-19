import 'package:aplikasi_review_film/models/movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_review_film/data/movie_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  // bool isSignedIn = false;

  // Fungsi untuk menyimpan movie favorit ke SharedPreferences
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_movies') ?? [];

    if (isFavorite) {
      // Jika sudah di-favorite, hapus dari daftar
      favorites.remove(widget.movie.id.toString());
    } else {
      // Jika belum di-favorite, tambahkan ke daftar
      favorites.add(widget.movie.id.toString());
    }

    await prefs.setStringList('favorite_movies', favorites);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_movies') ?? [];

    setState(() {
      isFavorite = favorites.contains(widget.movie.id.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    // _checkSignInStatus();
    _loadFavoriteStatus();
  }
  // void _checkSignInStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool signedIn = prefs.getBool('IsSignedIn') ?? false;
  //   setState(() {
  //     isSignedIn = signedIn;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.movie.imageAsset,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100]?.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.movie.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          isFavorite
                              ?Icons.favorite
                              :Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,

                        ),

                      ),
                      //   icon: Icon(isSignedIn && isFavorite
                      //       ? Icons.favorite
                      //       : Icons.favorite_border,
                      //     color: isSignedIn && isFavorite ? Colors.red : null,),
                      // )
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  // Widget yg dpt digunakan untuk menempatkan widget widget lainnya secara horizontal
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.red),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: Text('Asal Film', style: TextStyle(
                            fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Text(': ${widget.movie.location}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.black),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: Text('Dirilis', style: TextStyle(
                            fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 38,),
                      Text(': ${widget.movie.built}')
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.movie, color: Colors.black),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: Text('Genre',style: TextStyle(
                            fontWeight: FontWeight.bold),),
                      ),
                      Text(': ${widget.movie.type}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.deepPurple.shade100),
                  Text(
                    'Deskripsi', style: TextStyle(
                    fontWeight: FontWeight.bold,),),
                  SizedBox(height: 10),
                  Text('${widget.movie.description}'),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.deepPurple.shade100),
                  Text('Aktor yang berperan', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.movie.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.deepPurple.shade100,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: widget.movie.imageUrls[index],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.deepPurple[50],
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Tap untuk melihat aktor lebih jelas', style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
