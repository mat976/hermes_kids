import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fem = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Container(
        // iphone141W99 (5:2)
        padding: EdgeInsets.fromLTRB(0 * fem, 793 * fem, 0 * fem, 0 * fem),
        width: double.infinity,
        height: 844 * fem,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1, -1),
            end: Alignment(-1, 0.896),
            colors: <Color>[Color(0xffca9319), Color(0x00beb143)],
            stops: <double>[0, 1],
          ),
        ),
        child: Container(
          // frame1iFD (5:3)
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff8b6b26),
            borderRadius: BorderRadius.circular(6 * fem),
          ),
        ),
      ),
    );
  }
}
