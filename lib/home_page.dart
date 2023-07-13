import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: null,
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: WaterDropNavBar(
                backgroundColor: Colors.white,
                onItemSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedIndex: _selectedIndex,
                barItems: [
                  BarItem(
                    filledIcon: Icons.home,
                    outlinedIcon: Icons.home_outlined,
                  ),
                  BarItem(
                    filledIcon: Icons.search,
                    outlinedIcon: Icons.search_outlined,
                  ),
                  BarItem(
                    filledIcon: Icons.favorite,
                    outlinedIcon: Icons.favorite_border,
                  ),
                  BarItem(
                    filledIcon: Icons.settings,
                    outlinedIcon: Icons.settings_outlined,
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
