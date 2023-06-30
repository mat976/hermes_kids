import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late SharedPreferences _prefs;

  Future<void> _loginWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Erreur de connexion : $e');
      // Afficher un message d'erreur à l'utilisateur
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      await _prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacementNamed(context, '/home');

      // Vérifier si le fichier utilisateur existe déjà dans Firestore
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!userSnapshot.exists) {
        // Créer le fichier utilisateur dans Firestore avec les informations spécifiées
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .set({
          'admin': false,
          'email': user?.email,
        });
      }
    } catch (e) {
      print('Erreur de connexion avec Google : $e');
      // Afficher un message d'erreur à l'utilisateur
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: const Color(0xFFE9E7DB), // Couleur de fond
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo_ephemeride_512.jpg',
              height: 180.0, // Hauteur agrandie du logo
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Bienvenue',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  _loginWithEmail(context, email, password);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFEB30A), // Couleur du bouton
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0), // Espacement vertical du bouton
                ),
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _loginWithGoogle(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Couleur du bouton
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/Google__G__Logo.svg',
                    height: 24.0, // Hauteur de l'image
                  ),
                  const SizedBox(
                      width: 12.0), // Espacement entre l'icône et le texte
                  const Text(
                    'Connexion Google',
                    style: TextStyle(
                      color: Colors.black, // Couleur du texte
                      fontSize: 16.0, // Taille du texte
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: const Text(
                "Si vous n'avez pas de compte, cliquez ici pour vous inscrire",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
