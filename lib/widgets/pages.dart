import 'package:flutter/material.dart';
import './movie_card.dart';

class Pages extends StatelessWidget {
  final List movieDetails;
  final _pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  final List genreNames;
  Pages(this.movieDetails, this.genreNames);
  @override
  Widget build(BuildContext context) {
    movieDetails.removeWhere((movie) {
      if (movie['poster_path'] == null ||
          movie['release_date'] == null ||
          movie['overview'] == null ||
          movie['original_language'] == null ||
          movie['title'] == null ||
          movie['poster_path'] == '' ||
          movie['release_date'] == '' ||
          movie['overview'] == '' ||
          movie['original_language'] == '' ||
          movie['title'] == '') {
        return true;
      }
      return false;
    });
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            return MovieCard(movieDetails[index], genreNames);
          },
          itemCount: movieDetails.length,
        ),
      ),
    );
  }
}
