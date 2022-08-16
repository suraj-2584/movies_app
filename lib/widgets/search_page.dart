import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import './pages.dart';
import './loading_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
  List genreNames;
  SearchPage(this.genreNames, {Key? key}) : super(key: key);
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  final _controller = TextEditingController();
  final String apiKey = '2431750324dfcb3d7dce2e841ffce89b';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNDMxNzUwMzI0ZGZjYjNkN2RjZTJlODQxZmZjZTg5YiIsInN1YiI6IjYyZjIyMTNjMjNiZTQ2MDA5MWU4NzQzZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J3iCEU_j52RuYqf3GQieRHYFnfSUWqA7ly_hYvPj6hA';

  Widget noResults() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(68, 10, 0, 0),
      child: ListTile(
        leading: Icon(
          Icons.search,
          size: 26,
        ),
        title: Text(
          'No search results',
          style: TextStyle(color: Colors.black45, fontSize: 18),
        ),
      ),
    );
  }

  Future<Map> getQueryDetails(String query) async {
    final tmdb = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
    );
    Map movieDetails = await tmdb.v3.search.queryMovies(query);
    return movieDetails;
  }

  late FocusNode? myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (myFocusNode == null || !myFocusNode!.hasPrimaryFocus) {
                Navigator.of(context).pop();
              } else {
                myFocusNode!.unfocus();
              }
            },
          ),
          iconTheme: const IconThemeData(color: Colors.black54),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Container(
            height: 40,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Center(
              child: TextField(
                cursorColor: Colors.redAccent,
                focusNode: myFocusNode,
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      if (_controller.text == '') {
                        FocusManager.instance.primaryFocus?.unfocus();
                      } else {
                        _controller.clear();
                      }
                    },
                  ),
                  hintText: 'Search for movies',
                ),
                onSubmitted: (String text) {
                  setState(() {
                    query = text;
                  });
                },
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: query == ''
              ? noResults()
              : FutureBuilder(
                  future: getQueryDetails(query),
                  builder: (context, AsyncSnapshot<Map> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!['total_results'] == 0) {
                        return noResults();
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.10,
                              child: ListTile(
                                leading:
                                    const Icon(Icons.search_rounded, size: 30),
                                title: Text(
                                    'Search Results: ${snapshot.data!['total_results']} ',
                                    style: const TextStyle(fontSize: 23)),
                                subtitle: const Text(
                                    'Note that some results might not appear',
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                            Pages(snapshot.data!['results'], widget.genreNames),
                          ],
                        );
                      }
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.10),
                          const LoadingScreen(),
                        ],
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }
}
