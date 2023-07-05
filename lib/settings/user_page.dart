import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String email = 'test@example.com'; // Remplacez par l'email de l'utilisateur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage(
                'assets/default_avatar.png'), // Remplacez par l'image de profil de l'utilisateur
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
    );
  }
}
