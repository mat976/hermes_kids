import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'home_pages/accueil_page.dart'; // Importation de la page d'accueil
import 'home_pages/recherche_page.dart'; // Importation de la page de recherche
import 'home_pages/favoris_page.dart'; // Importation de la page des favoris
import 'home_pages/parametres_page.dart'; // Importation de la page des paramètres

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index de l'onglet sélectionné
  final List<Widget> _pages = [
    const AccueilPage(), // Page d'accueil
    const RecherchePage(), // Page de recherche
    const FavorisPage(), // Page des favoris
    const ParametresPage(), // Page des paramètres
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor:
            Colors.white, // Couleur de fond de la barre de navigation
        systemNavigationBarIconBrightness: Brightness
            .dark, // Couleur des icônes de la barre de navigation (sombres)
      ),
      child: Scaffold(
        appBar: null, // Pas de barre d'applications
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children:
                  _pages, // Affiche la page correspondant à l'index sélectionné
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: WaterDropNavBar(
                backgroundColor:
                    Colors.white, // Couleur de fond de la barre de navigation
                onItemSelected: (int index) {
                  setState(() {
                    _selectedIndex =
                        index; // Met à jour l'index de l'onglet sélectionné lorsqu'il est cliqué
                  });
                },
                selectedIndex:
                    _selectedIndex, // Index de l'onglet actuellement sélectionné
                barItems: [
                  BarItem(
                    filledIcon: Icons.home, // Icône remplie pour l'accueil
                    outlinedIcon:
                        Icons.home_outlined, // Icône non remplie pour l'accueil
                  ),
                  BarItem(
                    filledIcon: Icons.search, // Icône remplie pour la recherche
                    outlinedIcon: Icons
                        .search_outlined, // Icône non remplie pour la recherche
                  ),
                  BarItem(
                    filledIcon:
                        Icons.favorite, // Icône remplie pour les favoris
                    outlinedIcon: Icons
                        .favorite_border, // Icône non remplie pour les favoris
                  ),
                  BarItem(
                    filledIcon:
                        Icons.settings, // Icône remplie pour les paramètres
                    outlinedIcon: Icons
                        .settings_outlined, // Icône non remplie pour les paramètres
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
