import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'description.dart';

class Wish extends StatefulWidget {
  final dynamic games;
  const Wish({Key? key, required this.games}) : super(key: key);
  @override
  WishState createState() => WishState();
}

class WishState extends State<Wish> {
  List<dynamic> _gamesidds = [];
  final String _searchText = '';
  List<dynamic> wishedgames = [];

  Future<void> _checkIfGameIsFavorite() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .where('userid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get();
    setState(() {
      _gamesidds=userDoc.docs.first.data()['whished'];
      for(dynamic gam in _gamesidds)
      {
        for(dynamic gam2 in widget.games)
        {
          if(gam.toString()==gam2['appid'].toString())
          {
            wishedgames.add(gam2);
            break;
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfGameIsFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title: const Text("Ma liste de souhaits", style: TextStyle(color: Colors.white,  fontFamily: 'OpenSans',
        )),
        backgroundColor: const Color(0xFF1E262C),
        centerTitle: true,
      ),
      body: wishedgames.isEmpty
          ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn-eu.icons8.com/Es_Ocg3-i023aM6EFW-55A/9jB-KGdNNkiJP-lL5jk5uA/Shape.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Vous n’avez encore pas liké de contenu\n''Cliquez sur l’étoile pour en rajouter.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'ProximaNova',

              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: wishedgames.length,
        itemBuilder: (BuildContext context, int index) {
          final game = wishedgames[index];
          if (_searchText.isNotEmpty &&
              !game['name']
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
            return const SizedBox.shrink();
          }
          return _buildCard(game);
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
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
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
                      padding: const EdgeInsets.only(top:10,left: 10, bottom: 10),
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
                                    style: const TextStyle(fontSize: 18, color: Colors.white,fontFamily: 'ProximaNova',),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  game['publishers'][0],
                                  style: const TextStyle(fontSize: 12, color: Colors.white,    fontFamily: 'ProximaNova',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  game['price'],
                                  style: const TextStyle(fontSize: 12, color: Colors.white,    fontFamily: 'ProximaNova',
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white,    fontFamily: 'ProximaNova',
                          ),
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