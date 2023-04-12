import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter/wish.dart';
import 'description.dart';
import 'fav.dart';
import 'Search.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  AccueilState createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  final List<dynamic> _games = [];
  String _searchText = '';

  _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search(searchText: _searchText,games:_games),
      ),
    );
  }
  Future<void> _getMostPlayedGames() async {
    final response = await http.get(Uri.parse(
        'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/'));
    final data = jsonDecode(response.body);
    final appids =
        data['response']['ranks'].map((game) => game['appid']).toList();

    for (final appid in appids) {
      final appDetailsResponse = await http.get(Uri.https(
          'store.steampowered.com',
          'api/appdetails/supportedlang=french',
          {'appids': appid.toString()}));

      if (jsonDecode(appDetailsResponse.body)['$appid']['success'] == true) {
        var name =
            jsonDecode(appDetailsResponse.body)['$appid']['data']['name'];
        final images = await http.get(
            Uri.parse('https://steamcommunity.com/actions/SearchApps/$name'));
        var image = jsonDecode(images.body);
        var price = jsonDecode(images.body);
        var publishers =
            jsonDecode(appDetailsResponse.body)['$appid']['data']['publishers'];

        if (image.isEmpty) {
          image = 'no image';
        } else {
          image = jsonDecode(images.body)[0]['icon'];
        }

        if (jsonDecode(appDetailsResponse.body)['$appid']['data']['is_free'] ==
            true) {
          price = 'Free';
        } else {
          if (jsonDecode(appDetailsResponse.body)['$appid']['data']
                  ['price_overview'] !=
              null) {
            price = jsonDecode(appDetailsResponse.body)['$appid']['data']
                ['price_overview']['final_formatted'];
          } else {
            price = 'Non repertorié';
          }
        }
        setState(() {
          _games.add({
            'appid': appid,
            'name': name,
            'image': image,
            'price': price,
            'publishers': publishers,
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getMostPlayedGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(    fontFamily: 'OpenSans',
            color: Colors.white)),
        backgroundColor: const Color(0xFF1E262C),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              size: 30,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Fav(games: _games),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.star_border,
              size: 30,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Wish(games: _games),
              ),
            ),
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un jeu...',
                hintStyle: const TextStyle(    fontFamily: 'ProximaNova',
                    color: Colors.white),
                prefixIcon: IconButton(icon: const Icon(Icons.search, color: Colors.white),onPressed: _navigateToSearchPage),
                filled: true,
                fillColor: const Color(0xFF2E3B4E),
              ),
              style: const TextStyle(    fontFamily: 'ProximaNova',
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: _games.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _games.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    children: [
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(_games[0]['image']),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameDetailsScreen(game: _games[0]),
                                ),
                              ),
                              child: Card(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _games[0]['name'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(    fontFamily: 'ProximaNova',

                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12.0),
                                            const Text(
                                              "Counter Strike est le jeu le plus vendues de toute l'hisoire de Steam"
                                              "Il compte alors pres de 588274 telechargement",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(    fontFamily: 'ProximaNova',

                                                fontSize: 12.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              height: 50.0,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GameDetailsScreen(
                                                            game: _games[0]),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary:
                                                      const Color(0xFF636AF6),
                                                ),
                                                child: const Text(
                                                  'En savoir plus',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily: 'ProximaNova',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 20, right: 10, bottom: 20),
                                        child: Image.network(
                                          _games[0]['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      const Text(
                        'Les meilleures ventes',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'ProximaNova',

                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2.0,
                        ),
                      ),
                    ],
                  );
                } else {
                  final game = _games[index - 1];
                  return _buildCard(game);
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
                                        fontFamily: 'ProximaNova',
                                        fontSize: 18, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  game['publishers'][0],
                                  style: const TextStyle(
                                      fontFamily: 'ProximaNova',
                                      fontSize: 12, color: Colors.white),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  game['price'],
                                  style: const TextStyle(
                                      fontFamily: 'ProximaNova',
                                      fontSize: 12, color: Colors.white),
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
