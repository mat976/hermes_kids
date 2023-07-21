import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class ParagraphEditorPage extends StatefulWidget {
  final String initialContent;

  ParagraphEditorPage({required this.initialContent});

  @override
  _ParagraphEditorPageState createState() => _ParagraphEditorPageState();
}

class _ParagraphEditorPageState extends State<ParagraphEditorPage> {
  String _content = '';
  final HtmlEditorController _controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
    _content = widget.initialContent;
    _controller.setText(_content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paragraph Editor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: HtmlEditor(
              controller: _controller,
              htmlEditorOptions: HtmlEditorOptions(
                hint: 'Enter your text here...',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final editedContent = await _controller.getText();
              Navigator.pop(context, editedContent);
            },
            child: Text('Save and Go Back'),
          ),
        ],
      ),
    );
  }
}
