import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String profileImage =
      ''; // Variable pour stocker le chemin de l'image de profil
  String email = ''; // Variable pour stocker l'adresse email

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Fonction pour récupérer les données de l'utilisateur depuis Firestore
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
            profileImage = data['profileImage'] ??
                ''; // Récupère le chemin de l'image de profil s'il existe, sinon une chaîne vide
            email = data['email'] ??
                ''; // Récupère l'adresse email de l'utilisateur s'il existe, sinon une chaîne vide
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double paddingTop = 16.0 + MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        alignment: Alignment
            .topCenter, // Ajuste l'alignement des éléments vers le haut
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/banner_image.jpg'), // Remplacez par le chemin de votre bannière d'arrière-plan
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, top: paddingTop),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                      context); // Retour en arrière lorsque le bouton est cliqué
                },
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                  height: 100.0), // Ajuste l'espace au-dessus de la bannière
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage(profileImage),
                child: profileImage.isEmpty
                    ? const Icon(Icons
                        .person) // Utilise une icône par défaut si aucun chemin d'image de profil n'est spécifié
                    : null,
              ),
              const SizedBox(height: 16.0),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
