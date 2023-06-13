import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        final data = snapshot.data() as Map<String,
            dynamic>?; // Conversion du type de données en Map<String, dynamic>
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color(0xFFFEB30A), // Couleur de la barre de navigation
        height: 50,
        animationDuration: Duration(milliseconds: 200),
        index: _selectedIndex,
        items: [
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.favorite, size: 30),
          if (isAdmin) Icon(Icons.add, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
