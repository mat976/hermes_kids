import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_detail_page.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Vérifie si une erreur s'est produite lors de la récupération des données
          if (snapshot.hasError) {
            return const Center(child: Text('Une erreur s\'est produite'));
          }

          // Vérifie si les données sont en cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Obtient la liste des documents de la collection "posts" depuis Firestore
          final List<QueryDocumentSnapshot> posts = snapshot.data!.docs;

          // Affiche un carrousel vertical des publications à l'aide du widget CarouselSlider
          return CarouselSlider(
            options: CarouselOptions(
              scrollDirection: Axis.vertical,
              height: double.infinity,
              viewportFraction: 1.0,
            ),
            items: posts.map((post) {
              final String title = post['title'] ?? '';
              final String description = post['description'] ?? '';
              final String imageUrl = post['imageUrl'] ?? '';
              final String? paragraph =
                  post['paragraph']; // Paragraphe éventuel (nullable)
              return GestureDetector(
                onTap: () {
                  // Navigue vers la page de détails de la publication au clic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(
                        imageUrl: imageUrl,
                        title: title,
                        description: description,
                        paragraph: paragraph, // Passe le paragraphe éventuel
                      ),
                    ),
                  );
                },
                child: MenuCard(
                  imageUrl: imageUrl,
                  title: title,
                  description: description,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const MenuCard({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
