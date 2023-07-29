import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Post_Detail_Page.dart'; // Importation de la page de détail du post

class RecherchePage extends StatefulWidget {
  const RecherchePage({Key? key}) : super(key: key);

  @override
  _RecherchePageState createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _searchStream;

  @override
  void initState() {
    super.initState();
    // Initialiser le flux pour afficher tous les posts (sans filtre)
    _searchStream = FirebaseFirestore.instance.collection('posts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            // Filtrez les résultats en fonction de la recherche de l'utilisateur
            setState(() {
              _searchStream = FirebaseFirestore.instance
                  .collection('posts')
                  .where('title', isGreaterThanOrEqualTo: value)
                  .where('title',
                      isLessThan:
                          '${value}z') // Permet une recherche insensible à la casse
                  .snapshots();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Recherche...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _searchStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Une erreur s\'est produite'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<QueryDocumentSnapshot<Map<String, dynamic>>> posts =
              snapshot.data!.docs;

          if (posts.isEmpty) {
            return const Center(child: Text('Aucun résultat trouvé'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 10 / 15,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data();
              final String imageUrl = post['imageUrl'] ?? '';

              return Card(
                child: InkWell(
                  onTap: () {
                    // Naviguer vers la page de détail du post au clic
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(
                          imageUrl: imageUrl,
                          title: post['title'] ?? '',
                          description: post['description'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imageUrl),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
