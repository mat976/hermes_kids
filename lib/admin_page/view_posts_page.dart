import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_post_page.dart';

class ViewPostsPage extends StatelessWidget {
  const ViewPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: StreamBuilder<QuerySnapshot>(
        // Utilise le StreamBuilder pour écouter les modifications de la collection "posts" dans Firestore
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Vérifie s'il y a une erreur lors de la récupération des données
          if (snapshot.hasError) {
            return const Text('Une erreur s\'est produite');
          }

          // Vérifie si les données sont en cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Obtient les documents de la collection "posts" depuis Firestore
          final posts = snapshot.data!.docs;

          // Affiche une liste de ListTile avec les détails de chaque publication
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts[index];
              final String title = post['title'];
              final String description = post['description'];
              final String imageUrl = post['imageUrl'];

              return ListTile(
                title: Text(title),
                subtitle: Text(description),
                // Affiche une miniature de l'image de la publication si elle existe
                leading: imageUrl.isNotEmpty
                    ? SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                onTap: () {
                  // Navigue vers la page EditPostPage au clic pour éditer la publication
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPostPage(
                        postId: post.id,
                        title: title,
                        description: description,
                        imageUrl: imageUrl,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
