import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contrôleurs pour récupérer les saisies de l'utilisateur pour l'e-mail, le mot de passe et la confirmation du mot de passe
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    // Fonction pour gérer le processus d'inscription de l'utilisateur
    Future<void> registerUser(BuildContext context) async {
      // Extraction du texte saisi dans les champs et suppression des espaces supplémentaires
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();

      // Vérification si le mot de passe saisi correspond au mot de passe de confirmation
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Les mots de passe ne correspondent pas')),
        );
        return;
      }

      try {
        // Création d'un nouvel utilisateur dans Firebase Authentication en utilisant l'e-mail et le mot de passe
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Stockage de données supplémentaires de l'utilisateur dans Firestore sous la collection 'users'
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'admin':
              false, // Par défaut, l'utilisateur n'est pas un administrateur
        });

        // Affichage d'un message de succès après une inscription réussie
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie')),
        );

        // Redirection de l'utilisateur vers la page de connexion après une inscription réussie
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        // Gestion des erreurs spécifiques liées à Firebase Authentication
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le mot de passe est trop faible.')),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Cet e-mail est déjà utilisé par un autre compte.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur d\'inscription : ${e.message}')),
          );
        }
      } catch (e) {
        // Gestion des autres erreurs qui pourraient survenir lors de l'inscription
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur d\'inscription')),
        );
      }
    }

    return Scaffold(
      appBar: null,
      body: Container(
        color: const Color(0xFFE9E7DB), // Couleur de fond
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Inscription', // Titre de la page d'inscription
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText:
                        'Adresse e-mail', // Étiquette de l'entrée pour l'e-mail
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText:
                        'Mot de passe', // Étiquette de l'entrée pour le mot de passe
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true, // Masque le texte du mot de passe
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText:
                        'Confirmez le mot de passe', // Étiquette de l'entrée pour la confirmation du mot de passe
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true, // Masque le texte du mot de passe
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => registerUser(
                        context), // Appelle la fonction d'inscription
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      backgroundColor:
                          Colors.orange, // Couleur de fond du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2.0,
                    ),
                    child: const Text(
                      'Inscription', // Texte du bouton
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigue vers la page précédente
                  },
                  child: const Text("Retour"), // Texte pour le bouton "Retour"
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
