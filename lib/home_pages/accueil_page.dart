import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: CarouselSlider(
        options: CarouselOptions(
          scrollDirection: Axis.vertical,
          height: double.infinity,
          viewportFraction: 1.0,
        ),
        items: [
          MenuCard(
            image: AssetImage('assets/image1.jpg'),
            title: 'Titre de la page 1',
            quote: 'Citation inspirante 1',
          ),
          MenuCard(
            image: AssetImage('assets/image2.jpg'),
            title: 'Titre de la page 2',
            quote: 'Citation inspirante 2',
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final ImageProvider<Object> image;
  final String title;
  final String quote;

  const MenuCard({
    required this.image,
    required this.title,
    required this.quote,
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
            quote,
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
