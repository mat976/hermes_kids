import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class ParagraphEditorPage extends StatefulWidget {
  final String initialContent;

  const ParagraphEditorPage({super.key, required this.initialContent});

  @override
  _ParagraphEditorPageState createState() => _ParagraphEditorPageState();
}

class _ParagraphEditorPageState extends State<ParagraphEditorPage> {
  String _content = ''; // Variable pour stocker le contenu actuel de l'éditeur
  final HtmlEditorController _controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
    _content = widget
        .initialContent; // Initialise le contenu avec la valeur passée lors de l'ouverture de la page
    _controller.setText(_content); // Affiche le contenu dans l'éditeur
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Paragraph Editor'), // Titre de la barre d'applications
      ),
      body: Column(
        children: [
          Expanded(
            child: HtmlEditor(
              controller:
                  _controller, // Utilise le contrôleur HtmlEditorController
              htmlEditorOptions: const HtmlEditorOptions(
                hint:
                    'Enter your text here...', // Texte d'invite pour l'éditeur
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Lorsque le bouton est cliqué, récupère le contenu édité et revient à l'écran précédent
              final editedContent = await _controller.getText();
              Navigator.pop(context, editedContent);
            },
            child: const Text('Save and Go Back'), // Texte du bouton
          ),
        ],
      ),
    );
  }
}
