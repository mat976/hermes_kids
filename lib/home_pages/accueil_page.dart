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
              return Center(child: Text('Une erreur s\'est produite'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
                  image: NetworkImage(imageUrl),
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
  final ImageProvider<Object> image;
  final String title;
  final String description;

  const MenuCard({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
