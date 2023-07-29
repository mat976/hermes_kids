import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Fichier contenant les options de configuration Firebase
import 'login_page.dart'; // Page de connexion
import 'register_page.dart'; // Page d'inscription
import 'home_page.dart'; // Page d'accueil

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase avec les options de configuration par défaut
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuration du thème de l'application
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Couleur principale de l'application
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors
              .deepPurple, // Couleurs de base basées sur la couleur principale
          accentColor: Colors.orange, // Couleur d'accentuation
        ),
      ),
      initialRoute: '/', // Route initiale de l'application
      routes: {
        '/': (context) =>
            const LoginPage(), // Page de connexion associée à la route '/'
        '/register': (context) =>
            const RegisterPage(), // Page d'inscription associée à la route '/register'
        '/home': (context) =>
            const HomePage(), // Page d'accueil associée à la route '/home'
      },
    );
  }
}
