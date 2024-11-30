import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_review_film/data/movie_data.dart';

class DetailScreen extends StatelessWidget {
  final dynamic movie;

  const DetailScreen({super.key, required this.movie});

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
                      movie.imageAsset,
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
                        movie.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite, color: Colors.red,),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
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
                      Text(': ${movie.location}'),
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
                      Text(': ${movie.built}')
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
                      Text(': ${movie.type}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.deepPurple.shade100),
                  Text(
                    'Deskripsi', style: TextStyle(
                    fontWeight: FontWeight.bold,),),
                  SizedBox(height: 10),
                  Text('${movie.description}'),
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
                      itemCount: movie.imageUrls.length,
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
                                  imageUrl: movie.imageUrls[index],
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
