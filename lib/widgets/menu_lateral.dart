import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'perfil.dart';
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key}) ;
  @override 
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
            border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 59, 160, 207)) ,
                ),
          ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,  // Tamanho do círculo
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                SizedBox(height: 10),  // Espaçamento entre a imagem e o texto
                Text(
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
            title: const Text('Início',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Fecha o menu lateral
              Navigator.pushNamed(context, '/home'); //fechar o aplicativo
            },
          ),
          ListTile(
            title: const Text('Conta', textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Fecha o menu lateral
              Navigator.pushNamed(context, '/conta'); 
            }
          ),
          ListTile(
            title: const Text('Alterar Roteiro', textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/alterarRoteiro');
            },
          ),
          ListTile(
            title: const Text('Histórico de Leitura',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/historico');
            },
          ),
         
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ListTile(
            title: const Text('Mudar de Conta',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          ListTile(
            title: const Text('Sair',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
             SystemNavigator.pop(); // Sai do aplicativo //fechar o aplicativo
            },
          ),
          
          const Divider( // Adiciona uma linha
            color: Color.fromARGB(255, 59, 160, 207), // Cor da linha
            thickness: 2, // Espessura da linha
          ),
        ],
      ),
    );
  }
}
