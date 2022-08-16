import 'package:flutter/material.dart';
import './widgets/pages.dart';
import 'package:tmdb_api/tmdb_api.dart';
import './widgets/loading_screen.dart';

class Body extends StatefulWidget {
  final List genreNames;
  const Body(this.genreNames, {Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> categoryTitles = ['Top Rated', 'Upcoming', 'Now Playing'];
  int _selectedIndex = 0;
  final String apiKey = '2431750324dfcb3d7dce2e841ffce89b';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNDMxNzUwMzI0ZGZjYjNkN2RjZTJlODQxZmZjZTg5YiIsInN1YiI6IjYyZjIyMTNjMjNiZTQ2MDA5MWU4NzQzZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J3iCEU_j52RuYqf3GQieRHYFnfSUWqA7ly_hYvPj6hA';
  List topRated = [];
  List upcoming = [];
  List nowPlaying = [];

  Future<Map> getTopRated() async {
    final tmdb = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
    );
    final topRatedData = await tmdb.v3.movies.getTopRated();
    return topRatedData;
  }

  Future<Map> getUpcoming() async {
    final tmdb = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
    );
    final upcomingData = await tmdb.v3.movies.getUpcoming();
    return upcomingData;
  }

  Future<Map> getNowPlaying() async {
    final tmdb = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
    );
    final nowPlayingData = await tmdb.v3.movies.getNowPlaying();
    return nowPlayingData;
  }

  Widget buildPages() {
    if (_selectedIndex == 0) {
      return FutureBuilder(
        future: getTopRated(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return Pages(snapshot.data!['results'], widget.genreNames);
          } else {
            return const Expanded(child: LoadingScreen());
          }
        },
      );
    } else if (_selectedIndex == 1) {
      return FutureBuilder(
        future: getUpcoming(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return Pages(snapshot.data!['results'], widget.genreNames);
          } else {
            return const Expanded(child: LoadingScreen());
          }
        },
      );
    } else {
      return FutureBuilder(
        future: getNowPlaying(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return Pages(snapshot.data!['results'], widget.genreNames);
          } else {
            return const Expanded(child: LoadingScreen());
          }
        },
      );
    }
  }

  Widget categoryBuilder(String title, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            _selectedIndex = index;
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              title,
              style: TextStyle(
                color:
                    (index == _selectedIndex ? Colors.black : Colors.black12),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: 6,
            width: MediaQuery.of(context).size.width * 0.10,
            margin: EdgeInsets.fromLTRB(
                (MediaQuery.of(context).size.width * 0.05), 0, 0, 0),
            decoration: BoxDecoration(
              color: (index == _selectedIndex
                  ? Colors.redAccent
                  : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  categoryBuilder(categoryTitles[index], index, context),
              itemCount: categoryTitles.length,
            ),
          ),
          buildPages(),
        ],
      ),
    );
  }
}
