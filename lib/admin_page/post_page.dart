import 'dart:io' if (dart.library.html) 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:hermes_kids/admin_page/view_posts_page.dart';
import 'richtextedit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter/foundation.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

enum PageType {
  Create,
  View,
}

class _PostPageState extends State<PostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<dynamic> contentList = [];
  String?
      paragraphContent; // Variable pour stocker le contenu de l'éditeur de paragraphe
  PageType _currentPage = PageType.Create;
  String? imageUrl; // Déplacer imageUrl ici

  Future<void> pickImage() async {
    final picker.ImagePicker _picker = picker.ImagePicker();
    final picker.XFile? pickedFile =
        await _picker.pickImage(source: picker.ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // Sur le web, convertir le fichier en Uint8List
          final bytes = File(pickedFile.path).readAsBytesSync();
          contentList.add(Uint8List.fromList(bytes));
        } else {
          contentList.add(File(pickedFile.path));
        }
      });
    }
  }

  Future<void> uploadImages() async {
    if (contentList.isEmpty) {
      return;
    }

    // Réorganiser contentList pour télécharger l'image sélectionnée en dernier en premier
    if (contentList.length > 1) {
      final dynamic lastContent = contentList.removeLast();
      contentList.insert(0, lastContent);
    }

    for (var content in contentList) {
      if (content is File) {
        final String title = titleController.text.trim();
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('images/$title.jpg');
        final TaskSnapshot uploadTask = await storageRef.putFile(content);
        imageUrl = await uploadTask.ref
            .getDownloadURL(); // Mettre à jour directement l'imageUrl dans l'état
        setState(() {
          contentList[contentList.indexOf(content)] = this.imageUrl;
        });
      } else if (content is Uint8List && kIsWeb) {
        final String title = titleController.text.trim();
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('images/$title.jpg');
        final UploadTask uploadTask = storageRef.putData(content);
        final TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          contentList[contentList.indexOf(content)] = this.imageUrl;
        });
      }
    }
  }

  Future<void> submitPost() async {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        (contentList.isEmpty && paragraphContent == null)) {
      return;
    }

    final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');

    Map<String, dynamic> postData = {
      'title': title,
      'description': description,
    };

    if (contentList.isNotEmpty) {
      postData['contentList'] =
          contentList.map((content) => content.toString()).toList();
    }

    if (paragraphContent != null && paragraphContent!.isNotEmpty) {
      postData['paragraph'] = paragraphContent;
    }

    // Supprimer l'affectation null à imageUrl pour conserver la valeur obtenue après le téléchargement de l'image
    postData['imageUrl'] = imageUrl;

    await postsRef.add(postData);
    titleController.clear();
    descriptionController.clear();
    contentList.clear();
    paragraphContent = null;
    // Conserver imageUrl après la soumission de l'article
    // imageUrl = null;
  }

  Widget _buildContentItem(dynamic content, int index) {
    if (content is String && content.startsWith('<')) {
      // Si le contenu est du HTML, l'afficher à l'aide de flutter_widget_from_html_core
      return HtmlWidget(content);
    } else if (content is String && content.startsWith('http')) {
      // Si le contenu est une URL d'image, l'afficher à l'aide de Image.network
      return Image.network(
        content,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } else {
      // Si le contenu n'est pas reconnu, afficher simplement un conteneur vide
      return const SizedBox.shrink();
    }
  }

  void _openParagraphEditor() async {
    final editedContent = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ParagraphEditorPage(
          initialContent: paragraphContent ?? '',
        ),
      ),
    );

    if (editedContent != null) {
      setState(() {
        paragraphContent =
            editedContent; // Mettre à jour le contenu de l'éditeur de paragraphe
        contentList.add(editedContent); // Mettre à jour la liste de contenu
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImageSelected = contentList.any((content) =>
        (content is File && !kIsWeb) || (content is Uint8List && kIsWeb));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: _currentPage == PageType.Create
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isImageSelected ? null : pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text('Image'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _openParagraphEditor,
                          icon: const Icon(Icons.format_align_left),
                          label: const Text('Paragraphe'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    if (contentList.isNotEmpty)
                      Column(
                        children: [
                          for (var index = 0;
                              index < contentList.length;
                              index++)
                            _buildContentItem(contentList[index], index),
                        ],
                      ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        await uploadImages();
                        await submitPost();
                        setState(() {
                          _currentPage = PageType.View;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.all(16.0),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Poster'),
                    ),
                  ],
                ),
              )
            : ViewPostsPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // ... Configuration de la barre de navigation inférieure ...
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Créer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Voir',
          ),
        ],
      ),
    );
  }
}
