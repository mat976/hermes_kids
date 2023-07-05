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
            profileImage = data['profileImage'] ?? '';
            email = data['email'] ?? '';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Stack(
        children: [
          // Bannière en arrière-plan
          Image.asset(
            'assets/banner_image.jpg', // Remplacez par le chemin de votre bannière d'arrière-plan
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height *
                0.3, // Hauteur de la bannière (30% de la hauteur de l'écran)
          ),
          Column(
            children: [
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Ajoutez ici les actions pour changer l'image de profil
                },
                child: const Text('Changer l\'image de profil'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
