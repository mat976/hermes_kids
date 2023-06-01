import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/accueil_page.dart';
import 'pages/recherche_page.dart';
import 'pages/favoris_page.dart';
import 'pages/parametres_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AccueilPage(),
    const RecherchePage(),
    const FavorisPage(),
    const ParametresPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Accueil',
                  gap: 8, // Augmente l'espace entre l'icône et le texte
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Recherche',
                  gap: 8, // Augmente l'espace entre l'icône et le texte
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Favoris',
                  gap: 8, // Augmente l'espace entre l'icône et le texte
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Paramètres',
                  gap: 8, // Augmente l'espace entre l'icône et le texte
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
