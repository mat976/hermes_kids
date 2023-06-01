import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_pages/accueil_page.dart';
import 'home_pages/recherche_page.dart';
import 'home_pages/favoris_page.dart';
import 'home_pages/parametres_page.dart';

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
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final bool isSmallScreen = width < 360;
          final bool showText = width >= 480;
          final double fontSize = isSmallScreen ? 12.0 : 14.0;

          return Material(
            elevation: isSmallScreen ? 4.0 : 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      Icons.home,
                      'Accueil',
                      isSmallScreen,
                      showText,
                      fontSize,
                      0,
                    ),
                    _buildNavItem(
                      Icons.search,
                      'Recherche',
                      isSmallScreen,
                      showText,
                      fontSize,
                      1,
                    ),
                    _buildNavItem(
                      Icons.favorite,
                      'Favoris',
                      isSmallScreen,
                      showText,
                      fontSize,
                      2,
                    ),
                    _buildNavItem(
                      Icons.settings,
                      'Paramètres',
                      isSmallScreen,
                      showText,
                      fontSize,
                      3,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSmallScreen,
    bool showText,
    double fontSize,
    int index,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSmallScreen ? 24.0 : 28.0,
            ),
            if (showText && !isSmallScreen)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
