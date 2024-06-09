import 'package:flutter/material.dart';
import './widgets/home.dart';
import './widgets/conta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
     home: const Home(),
      routes: {
        '/home': (context) => const Home(), 
        '/conta': (context) => const Conta(), // Rota para a página de perfil
      }
    );
  }
}

