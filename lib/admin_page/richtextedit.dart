import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class ParagraphEditorPage extends StatefulWidget {
  @override
  _ParagraphEditorPageState createState() => _ParagraphEditorPageState();
}

class _ParagraphEditorPageState extends State<ParagraphEditorPage> {
  String _content = '';
  final HtmlEditorController _controller = HtmlEditorController();

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
            onPressed: () {
              _controller.getText().then((value) {
                setState(() {
                  _content = value;
                });
              });
            },
            child: Text('Submit'),
          ),
          SizedBox(height: 16),
          Text('Content:'),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_content),
            ),
          ),
        ],
      ),
    );
  }
}
