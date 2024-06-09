import 'package:flutter/material.dart';
import 'menu_lateral.dart';
class Home extends StatelessWidget {
   const Home({super.key}) ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mascote'),
      ),
      drawer: const MenuLateral(),
      body: const Center(
        child: Text('Voce está lendo "AUTO DA COMPADECIDA"'),
      ),
    );
  }
}
