import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin_page/post_page.dart'; // Importez la page PostPage
import '../settings/user_page.dart'; // Importez la page UserProfilePage

class ParametresPage extends StatefulWidget {
  const ParametresPage({Key? key}) : super(key: key);

  @override
  _ParametresPageState createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchAdminStatus();
  }

  Future<void> fetchAdminStatus() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            isAdmin = data['admin'] == true;
          });
        }
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void navigateToPostPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PostPage(),
      ),
    );
  }

  void navigateToUserProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24.0),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (isAdmin) // Afficher le bouton uniquement si l'utilisateur est un admin
            ElevatedButton(
              onPressed: () {
                navigateToPostPage(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                primary: Colors.grey[300], // Couleur de fond du bouton
                onPrimary: Colors.black, // Couleur du texte du bouton
                elevation: 0, // Supprime l'ombre du bouton
                padding: const EdgeInsets.all(16.0),
                visualDensity: VisualDensity.compact,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.settings), // Icône de paramètres
                  SizedBox(width: 16.0),
                  Text(
                    'Paramètres admin',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16.0), // Ajout de l'espace entre les boutons
          ElevatedButton(
            onPressed: () {
              navigateToUserProfilePage(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              primary: Colors.grey[300], // Couleur de fond du bouton
              onPrimary: Colors.black, // Couleur du texte du bouton
              elevation: 0, // Supprime l'ombre du bouton
              padding: const EdgeInsets.all(16.0),
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.person), // Icône de profil
                SizedBox(width: 16.0),
                Text(
                  'Mon profil',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0), // Ajout de l'espace entre les boutons
          ElevatedButton(
            onPressed: () {
              _logout(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              primary: Colors.grey[300], // Couleur de fond du bouton
              onPrimary: Colors.black, // Couleur du texte du bouton
              elevation: 0, // Supprime l'ombre du bouton
              padding: const EdgeInsets.all(16.0),
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.exit_to_app), // Icône de déconnexion
                SizedBox(width: 16.0),
                Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
