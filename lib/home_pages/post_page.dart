import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? imageFile;
  String imageUrl = '';

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      return;
    }

    // Enregistrer l'image dans Firebase Storage
    final Reference storageRef = FirebaseStorage.instance.ref().child('images');
    final TaskSnapshot uploadTask = await storageRef.putFile(imageFile!);

    // Récupérer l'URL de l'image
    imageUrl = await uploadTask.ref.getDownloadURL();
  }

  Future<void> submitPost() async {
    // Récupérer les valeurs du titre et de la description
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    // Vérifier si le titre, la description et l'URL de l'image sont valides
    if (title.isEmpty || description.isEmpty || imageUrl.isEmpty) {
      // Afficher un message d'erreur à l'utilisateur
      return;
    }

    // Enregistrer les données dans Firestore
    final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');
    await postsRef.add({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    });

    // Retourner à la page précédente avec les informations de publication
    Navigator.pop(context, {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poster une nouvelle publication'),
      ),
      body: Padding(
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
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await pickImage();
              },
              child: const Text('Sélectionner une image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await uploadImage();
                await submitPost();
              },
              child: const Text('Poster'),
            ),
          ],
        ),
      ),
    );
  }
}
