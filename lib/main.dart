import 'package:flutter/material.dart';
import 'package:bookflix/widgets/funcoes.dart';
import 'package:bookflix/rotas.dart'; // Importe o arquivo rotas.dart aqui

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    setAppContext(context);
    
    return MaterialApp(      
      title: 'Bookflix',
      initialRoute: Rotas.login, // Use a constante definida em Rotas
      routes: Rotas.getRoutes(), // Obtenha as rotas do arquivo rotas.dart
    );
  }
}