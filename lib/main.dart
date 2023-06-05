import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
        apiKey: "AIzaSyDhGKB8yjbTyIXgPZXmNly7uUHL5Palu00",
        authDomain: "hermes-kids.firebaseapp.com",
        databaseURL:
            "https://hermes-kids-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "hermes-kids",
        storageBucket: "hermes-kids.appspot.com",
        messagingSenderId: "709056935190",
        appId: "1:709056935190:web:445a2117b45e8ffa844c37"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.orange,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
