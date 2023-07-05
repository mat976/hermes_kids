import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
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
  bool isAdmin = false;
  final List<Widget> _pages = [
    const AccueilPage(),
    const RecherchePage(),
    const FavorisPage(),
    const ParametresPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DotNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              dotIndicatorColor: Colors.white,
              items: [
                DotNavigationBarItem(
                  icon: const Icon(Icons.home),
                  selectedColor: const Color(0xFFFEB30A),
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.search),
                  selectedColor: const Color(0xFFFEB30A),
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  selectedColor: const Color(0xFFFEB30A),
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  selectedColor: const Color(0xFFFEB30A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
