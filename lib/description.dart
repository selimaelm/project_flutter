import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';

class GameDetailsScreen extends StatefulWidget {
  final dynamic game;
  const GameDetailsScreen({Key? key, required this.game}) : super(key: key);
  @override
  _GameDetailsScreenState createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  bool isLoading = true;
  bool _isDescriptionSelected = true;
  bool _isHeartFilled = false;
  bool _isStarFilled = false;

  Future<void> getGame() async {
    var appid = widget.game['appid'];
    final appDetailsResponse = await http.get(Uri.https(
        'store.steampowered.com',
        'api/appdetails/supportedlang=french',
        {'appids': appid.toString()}));

    if (jsonDecode(appDetailsResponse.body)['$appid']['success'] == true) {
      var name = jsonDecode(appDetailsResponse.body)['$appid']['data']['name'];
      final images = await http.get(
          Uri.parse('https://steamcommunity.com/actions/SearchApps/$name'));
      final REV = await http.get(
          Uri.parse('https://store.steampowered.com/appreviews/$appid?json=1'));
      // var reviews = jsonDecode(REV.body)['$appid']['reviews']['name'];
      var description = jsonDecode(appDetailsResponse.body)['$appid']['data']
          ['detailed_description'];
      var icon = jsonDecode(images.body)[0]['icon'];
      setState(() {
        widget.game['icon'] = icon;
        widget.game['description'] = description;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getGame();
    _checkIfGameIsFavorite();
  }

  Future<void> _checkIfGameIsFavorite() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .where('userid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get();

    setState(() {
      _isHeartFilled = userDoc.docs.first
              .data()['likes']
              ?.contains(widget.game['appid'].toString()) ??
          false;
      _isStarFilled = userDoc.docs.first
              .data()['whished']
              ?.contains(widget.game['appid'].toString()) ??
          false;
    });
  }

  Future<void> _toggleFavoriteGame() async {
    final userDocRef = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .where('userid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get();

    final favorites =
        Set<String>.from(userDocRef.docs.first.data()['likes'] ?? []);
    if (_isHeartFilled) {
      favorites.remove(widget.game['appid'].toString());
    } else {
      favorites.add(widget.game['appid'].toString());
    }
    await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userDocRef.docs.first.id)
        .update({'likes': favorites.toList()});

    setState(() {
      _isHeartFilled = !_isHeartFilled;
    });
  }

  Future<void> _toggleWishGame() async {
    final userDocRef = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .where('userid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get();

    final favorites =
        Set<String>.from(userDocRef.docs.first.data()['whished'] ?? []);
    if (_isStarFilled) {
      favorites.remove(widget.game['appid'].toString());
    } else {
      favorites.add(widget.game['appid'].toString());
    }
    await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userDocRef.docs.first.id)
        .update({'whished': favorites.toList()});

    setState(() {
      _isStarFilled = !_isStarFilled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title:
            const Text("Détail du jeu", style: TextStyle(    fontFamily: 'OpenSans',
                color: Colors.white)),
        backgroundColor: const Color(0xFF1E262C),
        actions: [
          IconButton(
            icon: Icon(
              _isHeartFilled ? Icons.favorite : Icons.favorite_border,
              size: 30,
            ),
            onPressed: _toggleFavoriteGame,
          ),
          IconButton(
            icon: Icon(
              _isStarFilled ? Icons.star : Icons.star_border,
              size: 30,
            ),
            onPressed: _toggleWishGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: widget.game['icon'] != null
                      ? DecorationImage(
                          image: NetworkImage(widget.game['icon']),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.game['icon'] == null
                    ? const Center(child: CircularProgressIndicator())
                    : null,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.38,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDescriptionSelected = true;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.height * 0.4,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff636af6)),
                                  color: _isDescriptionSelected
                                      ? const Color(0xff636af6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      3.0), // Ajouter cette ligne
                                ),
                                child: const Center(
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                      fontFamily: 'ProximaNova',

                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDescriptionSelected = false;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.height * 0.4,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff636af6)),
                                  color: !_isDescriptionSelected
                                      ? const Color(0xff636af6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      3.0), // Ajouter cette ligne
                                ),
                                child: const Center(
                                  child: Text(
                                    'Avis',
                                    style: TextStyle(
                                      fontFamily: 'ProximaNova',

                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isDescriptionSelected
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 16.0),
                                  widget.game['description'] != null
                                      ? Html(
                                          data: widget.game['description'],
                                          style: {
                                              'body': Style(
                                                fontSize: const FontSize(16.0),
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            })
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: const [
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Here goes the reviews of the product...',
                                    style: TextStyle(
                                        fontFamily: 'ProximaNova',

                                        fontSize: 18.0, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4 -
                MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Card(
                elevation: 1.0,
                color: const Color(0xFF1E262C), //1E262C
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: widget.game['image'] != null
                            ? Image.network(
                                widget.game['image'],
                                fit: BoxFit.contain,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.game['name'],
                              style: const TextStyle(
                                  fontFamily: 'ProximaNova',

                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'by ${widget.game['publishers'].join(', ')}',
                              style: const TextStyle(
                                  fontFamily: 'ProximaNova',

                                  fontSize: 15.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
