import 'package:aniversariantes/screen/home_page.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,  // Desativa o banner de depuração
      home: HomePage(), // Usando a HomePage como tela inicial
    );
  }
}
