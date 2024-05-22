// lib/widgets/menu_lateral.dart
/*
import 'package:flutter/material.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 2, 43, 77),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,  // Tamanho do círculo
                  backgroundImage: AssetImage('assets/imagens/user.png'),
                 
                ),
                const SizedBox(height: 10),  // Espaçamento entre a imagem e o texto
                const Text(
                  'Nome do Usuário',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            title: const Text('Books'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/books');
            },
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
*/