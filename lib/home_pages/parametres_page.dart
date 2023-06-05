import 'package:flutter/material.dart';
import '../login_page.dart';
import '../test_page.dart';

class ParametresPage extends StatelessWidget {
  const ParametresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.grey[400],
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Déconnexion',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0), // Ajout de l'espace entre les boutons
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TestPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.grey[400],
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aller à TestPage',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
