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
  String? imageName;
  bool isImageSelected = false;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageName = pickedFile.name;
        isImageSelected = true;
      });
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      return;
    }

    // Récupérer le titre du post
    final String title = titleController.text.trim();

    // Créer une référence personnalisée pour le fichier dans Firebase Storage
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$title.jpg');

    // Enregistrer l'image dans Firebase Storage avec la référence personnalisée
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

    // Afficher un message de succès à l'utilisateur
    // ...

    // Effacer les champs de texte et l'URL de l'image
    titleController.clear();
    descriptionController.clear();
    imageUrl = '';
    setState(() {
      imageFile = null;
      imageName = null;
      isImageSelected = false;
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
              onPressed: isImageSelected
                  ? null
                  : () async {
                      await pickImage();
                    },
              child: const Text('Sélectionner une image'),
            ),
            if (isImageSelected)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'Image sélectionnée :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.file(imageFile!),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    imageName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
