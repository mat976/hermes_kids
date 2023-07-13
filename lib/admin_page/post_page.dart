import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'view_posts_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int _selectedIndex = 0;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<dynamic> contentList = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

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

    for (var content in contentList) {
      if (content is File) {
        // Récupérer le titre du post
        final String title = titleController.text.trim();

        // Créer une référence personnalisée pour le fichier dans Firebase Storage
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('images/$title.jpg');

        // Enregistrer l'image dans Firebase Storage avec la référence personnalisée
        final TaskSnapshot uploadTask = await storageRef.putFile(content);

        // Récupérer l'URL de l'image
        final imageUrl = await uploadTask.ref.getDownloadURL();
        setState(() {
          contentList[contentList.indexOf(content)] = imageUrl;
        });
      }
    }
  }

  Future<void> submitPost() async {
    // Récupérer les valeurs du titre et de la description
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    // Vérifier si le titre, la description et le contenu sont valides
    if (title.isEmpty || description.isEmpty || contentList.isEmpty) {
      // Afficher un message d'erreur à l'utilisateur
      return;
    }

    // Enregistrer les données dans Firestore
    final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');
    await postsRef.add({
      'title': title,
      'description': description,
      'contentList': contentList,
      'date': selectedDate,
      'time': selectedTime,
    });

    // Afficher un message de succès à l'utilisateur
    // ...

    // Effacer les champs de texte et la liste de contenu
    titleController.clear();
    descriptionController.clear();
    contentList.clear();
    setState(() {
      selectedDate = null;
      selectedTime = null;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildContentItem(dynamic content, int index) {
    if (content is String) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paragraphe ${index + 1}:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(content),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: index > 0
                      ? () {
                          setState(() {
                            final contentItem = contentList[index];
                            contentList.removeAt(index);
                            contentList.insert(index - 1, contentItem);
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: index < contentList.length - 1
                      ? () {
                          setState(() {
                            final contentItem = contentList[index];
                            contentList.removeAt(index);
                            contentList.insert(index + 1, contentItem);
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      contentList.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else if (content is File) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Image.file(content),
              );
            },
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Image ${index + 1}:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Image.file(content, width: 100, height: 100),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: index > 0
                        ? () {
                            setState(() {
                              final contentItem = contentList[index];
                              contentList.removeAt(index);
                              contentList.insert(index - 1, contentItem);
                            });
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: index < contentList.length - 1
                        ? () {
                            setState(() {
                              final contentItem = contentList[index];
                              contentList.removeAt(index);
                              contentList.insert(index + 1, contentItem);
                            });
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        contentList.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
        });
      }
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
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _selectDateTime,
                    icon: Icon(Icons.calendar_today),
                    label: Text(selectedDate != null && selectedTime != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedTime!.hour}:${selectedTime!.minute}'
                        : 'Sélectionner la date et l\'heure'),
                  ),
                  const SizedBox(height: 16.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await pickImage();
                        },
                        icon: Icon(Icons.image),
                        label: Text('Image'),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Ajouter un paragraphe'),
                                content: TextFormField(
                                  controller: descriptionController,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                    labelText: 'Texte',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      final String paragraph =
                                          descriptionController.text.trim();
                                      if (paragraph.isNotEmpty) {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          contentList.add(paragraph);
                                        });
                                        descriptionController.clear();
                                      }
                                    },
                                    child: const Text('Ajouter'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.format_align_left),
                        label: Text('Paragraphe'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (contentList.isNotEmpty)
                    Column(
                      children: [
                        for (var index = 0; index < contentList.length; index++)
                          _buildContentItem(contentList[index], index),
                      ],
                    ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await uploadImages();
                      await submitPost();
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
            ),
            ViewPostsPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFEB30A),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
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
