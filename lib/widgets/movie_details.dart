import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class MovieDetails extends StatelessWidget {
  final List genreNames;
  final Map movieData;
  static const String routeName = 'movieDetailsRoute';
  MovieDetails(this.genreNames, this.movieData, {Key? key}) : super(key: key);
  List<String> currentGenres = [];
  ImageProvider useImage = AssetImage('lib/assets/images/no_img.jpg');

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < genreNames.length; i++) {
      if (movieData['genre_ids'].contains(genreNames[i]['id'])) {
        currentGenres.add(genreNames[i]['name']);
      }
    }
    if (movieData['backdrop_path'] != null) {
      useImage = NetworkImage(
          'https://image.tmdb.org/t/p/w500' + movieData['backdrop_path']);
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.4,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.4 - 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: useImage,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_sharp,
                          color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 50,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(26, 21, 0, 0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 26,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '${movieData['vote_average'].toString()}/10',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                const Text(
                                  'Release Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  DateFormat.yMMMMd().format(
                                    DateTime.parse(
                                      movieData['release_date'],
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 6, 0, 0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Vote Count',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    movieData['vote_count'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
                  child: FittedBox(
                    child: Text(
                      movieData['title'],
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 0, 12),
                  child: Text(movieData['original_language'],
                      style:
                          const TextStyle(color: Colors.black45, fontSize: 16)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: SizedBox(
                height: 28,
                width: size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentGenres.length,
                  itemBuilder: (_, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(currentGenres[index]),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey)),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 38, 0, 9),
              child: Text(
                'Movie Overview',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: Text(
                movieData['overview'],
                style: const TextStyle(color: Colors.black54, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
