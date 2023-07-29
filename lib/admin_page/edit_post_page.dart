import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditPostPage extends StatefulWidget {
  final String postId;
  final String title;
  final String description;
  final String imageUrl;

  const EditPostPage({
    super.key,
    required this.postId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? imageFile;
  String imageUrl = '';
  String? imageName;
  bool isImageSelected = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    imageUrl = widget.imageUrl;
    imageName = imageUrl.split('/').last;
    isImageSelected = true;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageName = pickedFile.name;
        isImageSelected = true;
      });
    }
  }

  Future<void> updatePost() async {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      // Afficher un message d'erreur à l'utilisateur
      return;
    }

    final DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    final updatedData = {
      'title': title,
      'description': description,
    };

    if (imageFile != null) {
      // Mettre à jour l'image seulement si un nouveau fichier est sélectionné
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$title.jpg');
      final TaskSnapshot uploadTask = await storageRef.putFile(imageFile!);
      imageUrl = await uploadTask.ref.getDownloadURL();

      updatedData['imageUrl'] = imageUrl;
    }

    await postRef.update(updatedData);

    // Afficher un message de succès à l'utilisateur
    // ...

    Navigator.pop(context); // Revenir à la page précédente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le post'),
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
              child: const Text('Modifier l\'image'),
            ),
            if (isImageSelected)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'Image actuelle :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
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
                await updatePost();
              },
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
