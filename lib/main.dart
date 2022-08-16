import 'package:flutter/material.dart';
import '../widgets/loading_screen.dart';
import './body.dart';
import 'package:tmdb_api/tmdb_api.dart';
import './widgets/search_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.redAccent),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
  List genreNames = [];
}

class _MyAppState extends State<MyApp> {
  String apiKey = '2431750324dfcb3d7dce2e841ffce89b';
  String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNDMxNzUwMzI0ZGZjYjNkN2RjZTJlODQxZmZjZTg5YiIsInN1YiI6IjYyZjIyMTNjMjNiZTQ2MDA5MWU4NzQzZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J3iCEU_j52RuYqf3GQieRHYFnfSUWqA7ly_hYvPj6hA';
  getGenreNames() async {
    var tmdb = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
    );
    var genreData = await tmdb.v3.genres.getMovieList();
    setState(() {
      widget.genreNames = genreData['genres'];
    });
  }

  @override
  void initState() {
    print('initstate');
    super.initState();
    getGenreNames();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: size.height,
            margin: EdgeInsets.fromLTRB(
                size.width * 0.045, size.height * 0.1, 0, 0),
            child: Column(
              children: const [
                Text(
                  'About',
                  style: TextStyle(color: Colors.black54, fontSize: 28),
                ),
                SizedBox(
                  height: 16,
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Version', style: TextStyle(fontSize: 18)),
                  subtitle: Text('1.0.0'),
                ),
                ListTile(
                  leading: Icon(Icons.movie),
                  title: Text('API ', style: TextStyle(fontSize: 18)),
                  subtitle: Text('The Movie Database (TMDB)'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Made by', style: TextStyle(fontSize: 18)),
                  subtitle: Text('Suraj P'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: IconButton(
              icon: const Icon(Icons.search_rounded),
              iconSize: 26,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SearchPage(widget.genreNames)));
              },
            ),
          ),
        ],
      ),
      body: widget.genreNames.isEmpty
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 0.1, 0, 0),
              child: const LoadingScreen(),
            )
          : Body(widget.genreNames),
    );
  }
}
