import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:hermes_kids/admin_page/view_posts_page.dart';
import 'richtextedit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

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
  int _selectedIndex = 0;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<dynamic> contentList = [];
  String?
      paragraphContent; // Variable to store the content of the paragraph editor
  PageType _currentPage = PageType.Create;
  String? imageUrl; // Move imageUrl here

  Future<void> pickImage() async {
    final picker.ImagePicker _picker = picker.ImagePicker();
    final picker.XFile? pickedFile =
        await _picker.pickImage(source: picker.ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        contentList.add(File(pickedFile.path));
      });
    }
  }

  Future<void> uploadImages() async {
    if (contentList.isEmpty) {
      return;
    }

    // Reorder the contentList to upload the last selected image first
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
        this.imageUrl = await uploadTask.ref
            .getDownloadURL(); // Mettre à jour directement l'imageUrl dans l'état
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

    // Remove imageUrl null assignment to retain the value obtained after image upload
    postData['imageUrl'] = imageUrl;

    await postsRef.add(postData);
    titleController.clear();
    descriptionController.clear();
    contentList.clear();
    paragraphContent = null;
    // Keep imageUrl after post submission
    // imageUrl = null;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildContentItem(dynamic content, int index) {
    if (content is String && content.startsWith('<')) {
      // If the content is HTML, display it using flutter_widget_from_html_core
      return HtmlWidget(content);
    } else if (content is String && content.startsWith('http')) {
      // If the content is an image URL, display it using Image.network
      return Image.network(
        content,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else if (content is File) {
      return Image.file(content);
    } else {
      // If the content is not recognized, just display an empty container
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
            editedContent; // Update the content of the paragraph editor
        contentList.add(editedContent); // Update the content list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImageSelected = contentList.any((content) => content is File);

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
                          icon: Icon(Icons.image),
                          label: Text('Image'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _openParagraphEditor,
                          icon: Icon(Icons.format_align_left),
                          label: Text('Paragraphe'),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        primary: Colors.blue,
                        onPrimary: Colors.white,
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
        // ... BottomNavigationBar configuration ...
        items: [
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
