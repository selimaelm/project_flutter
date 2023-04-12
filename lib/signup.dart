import 'home.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
  class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

    @override
    _SignUpViewState createState() => _SignUpViewState();

    }

    class _SignUpViewState extends State<SignUpView> {

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _nomutilisateur = TextEditingController();
    final TextEditingController _confirmmdp = TextEditingController();

    @override
      void dispose() {
        _emailController.dispose();
        _nomutilisateur.dispose();
        _confirmmdp.dispose();
        _passwordController.dispose();
        super.dispose();
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:MediaQuery.of(context).size.height /6),
              Wrap(
                alignment: WrapAlignment.center,
                children: const [
                  Text(
                    "Inscription ",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 31,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: const [
                    Text(
                      "Veuillez saisir ces différentes informations,afin que vos listes soient sauvegardées.",
                      style: TextStyle(
                        fontFamily: 'ProximaNova',
                        fontSize: 17,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50.0),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextField(
                  controller: _nomutilisateur,
                  style: const TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                  ),
                  decoration: const InputDecoration(
                    hintText: "Nom d'utilisateur",
                    hintStyle: TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                    ),  // ajout d'un style de texte personnalisé
                    filled: true,
                    fillColor: Color(0xFF1E262C),  // couleur de fond grise
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),  // ajout d'un padding vertical
                    // centrage du texte
                    prefixIconConstraints: BoxConstraints(minWidth: 50),
                    prefixText: ' ',
                    suffixText: ' ',
                  ),
                  textAlign: TextAlign.center,  // centrage du texte
                ),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                    ),  // ajout d'un style de texte personnalisé
                    filled: true,
                    fillColor: Color(0xFF1E262C),  // couleur de fond grise
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),  // ajout d'un padding vertical
                    // centrage du texte
                    prefixIconConstraints: BoxConstraints(minWidth: 50),
                    prefixText: ' ',
                    suffixText: ' ',
                  ),
                  textAlign: TextAlign.center,  // centrage du texte
                ),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Mot de passe',
                    hintStyle: TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                    ),  // ajout d'un style de texte personnalisé
                    filled: true,
                    fillColor: Color(0xFF1E262C),  // couleur de fond grise
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),  // ajout d'un padding vertical
                    // centrage du texte
                    prefixIconConstraints: BoxConstraints(minWidth: 50),
                    prefixText: ' ',
                    suffixText: ' ',
                  ),
                  textAlign: TextAlign.center,  // centrage du texte
                ),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextField(
                  controller: _confirmmdp,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Verification du mot de passe',
                    hintStyle: TextStyle(color: Colors.white,    fontFamily: 'ProximaNova',
                    ),  // ajout d'un style de texte personnalisé
                    filled: true,
                    fillColor: Color(0xFF1E262C),  // couleur de fond grise
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),  // ajout d'un padding vertical
                    // centrage du texte
                    prefixIconConstraints: BoxConstraints(minWidth: 50),
                    prefixText: ' ',
                    suffixText: ' ',
                  ),
                  textAlign: TextAlign.center,  // centrage du texte
                ),
              ),
              const SizedBox(height: 50.0),
              _SubmitButton(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  nomutilisateur:_nomutilisateur,
                  confirmmdp: _confirmmdp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nomutilisateur;
  final TextEditingController confirmmdp;
  const _SubmitButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.nomutilisateur,
    required this.confirmmdp
  }) : super(key: key);

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  final AuthService _authService = FirebaseAuthService(
    authService: FirebaseAuth.instance,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final email = widget.emailController.text;
          final password = widget.passwordController.text;
          final conf = widget.confirmmdp.text;

          if(password==conf)
            {
              await _authService.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              FirebaseFirestore.instance
                  .collection('utilisateurs')
                  .add({
                "userid": FirebaseAuth.instance.currentUser?.uid.toString(),
                "pseudo" : widget.nomutilisateur.text,
                "likes" : [],
                "whished":[],
              });
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Accueil()));
            }
          else
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Les deux mot de passe ne correspondent pas"),
                ),
              );
            }
        }
        catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF636AF6)),
        fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 2, 50)),
      ),
      child: const Text("S'inscrire"),
    );
  }
}