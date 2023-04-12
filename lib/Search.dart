import 'package:flutter/material.dart';
import 'description.dart';

class Search extends StatefulWidget {
  final List<dynamic> _games = [];
  dynamic _searchText = '';
  Search({Key? key, required String searchText, required List<dynamic> games})
      : super(key: key) {
    _searchText = searchText;
    _games.addAll(games);
  }  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title: const Text("Recherche", style: TextStyle(    fontFamily: 'OpenSans',
            color: Colors.white)),
        backgroundColor: const Color(0xFF1E262C),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  widget._searchText = text;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher un jeu...',
                hintStyle: TextStyle(    fontFamily: 'ProximaNova',
                    color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Color(0xFF2E3B4E),
              ),
              style: const TextStyle(    fontFamily: 'ProximaNova',
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: widget._games.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: widget._games.length,
        itemBuilder: (BuildContext context, int index) {
          final game = widget._games[index];
          if (game['name'].toLowerCase().contains(widget._searchText.toLowerCase())) {
            return _buildCard(game);
          } else {

            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildCard(dynamic game) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsScreen(game: game),
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(game['image']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.darken),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding:
                      const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(game['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    game['name'],
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white,    fontFamily: 'ProximaNova',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  game['publishers'][0],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white   , fontFamily: 'ProximaNova',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  game['price'],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white,    fontFamily: 'ProximaNova',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF636AF6),
                      ),
                      child: const Center(
                        child: Text(
                          "En savoir plus",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'ProximaNova',

                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
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
