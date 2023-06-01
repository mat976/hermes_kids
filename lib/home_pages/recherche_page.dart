import 'package:flutter/material.dart';

class RecherchePage extends StatelessWidget {
  const RecherchePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page de recherche',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
