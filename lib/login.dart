import 'package:project_flutter/home.dart';

import 'signup.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final Function(int)? onLoginSuccess;
  const LoginView({Key? key, this.onLoginSuccess}) : super(key: key);
  @override
  _LoginViewState createState() => _LoginViewState(onLoginSuccess: onLoginSuccess);
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Function(int)? onLoginSuccess;
  _LoginViewState({this.onLoginSuccess});


  @override
  void dispose() {
    _emailController.dispose();
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
                      "Bienvenue !",
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
                  padding: const EdgeInsets.symmetric(horizontal: 90.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: const [
                      Text(
                        "Veuillez vous connecter ou créer un nouveau compte pour utiliser l’application.",
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
                const SizedBox(height: 30.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(    fontFamily: 'ProximaNova',
                        color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(    fontFamily: 'ProximaNova',
                          color: Colors.white),  // ajout d'un style de texte personnalisé
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
                const SizedBox(height: 30.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(    fontFamily: 'ProximaNova',
                        color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Mot de passe',
                      hintStyle: TextStyle(    fontFamily: 'ProximaNova',
                          color: Colors.white),  // ajout d'un style de texte personnalisé
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
                const SizedBox(height: 60.0),
                 _SubmitButton(
                     emailController: _emailController,
                     passwordController: _passwordController,
                     onLoginSuccess: (int result) => onLoginSuccess?.call(result)),
                const SizedBox(height: 30.0),
                const _CreateAccountButton(),
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
  final Function(int) onLoginSuccess; // Ajout de la fonction de rappel

  const _SubmitButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginSuccess, // Ajout de la fonction de rappel
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
          await _authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          widget.onLoginSuccess(0);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Accueil(),  // Remplacer HomePage par le nom de votre page d'accueil
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF636AF6)),
          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.3, 50)),
        ),
      child: const Text('Se connecter'),
    );
  }
}


class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          side: MaterialStateProperty.all(const BorderSide(color: Color(0xFF636AF6), width: 2)),
          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.3, 50)),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
        return const Color(0xFFFFFFFF);
      } )),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SignUpView(),
          ),
        );
      },
      child: const Text("Creer un nouveau compte"),
    );
  }
}