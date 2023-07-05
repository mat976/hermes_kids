import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9E7DB), // Couleur de fond
      child: Scaffold(
        appBar: null,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Une erreur s\'est produite'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<QueryDocumentSnapshot> posts = snapshot.data!.docs;

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
                return MenuCard(
                  imageUrl: imageUrl,
                  title: title,
                  description: description,
                );
              }).toList(),
            );
          },
        ),
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
    return Stack(
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Positioned.fill(
          bottom: 0,
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
          ),
        ),
        Positioned(
          left: 16.0,
          bottom: 16.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
      ],
    );
  }
}
