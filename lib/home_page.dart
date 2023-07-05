import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_pages/accueil_page.dart';
import 'home_pages/recherche_page.dart';
import 'home_pages/favoris_page.dart';
import 'home_pages/parametres_page.dart';
import 'admin_page/post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isAdmin = false;
  late SharedPreferences _prefs;
  final List<Widget> _pages = [
    const AccueilPage(),
    const RecherchePage(),
    const FavorisPage(),
    const ParametresPage(),
  ];

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    fetchAdminStatus();
  }

  Future<void> initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchAdminStatus() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            isAdmin = data['admin'] ?? false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: DotNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        dotIndicatorColor: Colors.white,
        items: [
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Color(0xFFFEB30A),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.search),
            selectedColor: Color(0xFFFEB30A),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.favorite),
            selectedColor: Color(0xFFFEB30A),
          ),
          if (isAdmin)
            DotNavigationBarItem(
              icon: Icon(Icons.settings),
              selectedColor: Color(0xFFFEB30A),
            )
          else
            DotNavigationBarItem(
              icon: Icon(Icons.settings),
              selectedColor: Color(0xFFFEB30A),
              unselectedColor: Colors.grey,
            ),
        ],
      ),
    );
  }
}
