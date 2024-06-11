import 'package:bookflix/funcoes.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:get/get.dart';
import './widgets/conta.dart';
import './principal.dart';
import './widgets/alterar_senha.dart';
void main() {
  runApp(const MaterialApp (
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {    
    setAppContext(context);
    // ignore: prefer_const_constructors
    return GetMaterialApp(      
      title: 'Bookflix',      
      home: const Login(),      
      routes: {
        '/home': (context) => const  Principal(), 
        '/conta': (context) => const Conta(),
        '/login': (context) => const Login(),
        '/alterarsenha' : (context) => const AlterarSenha(),
      }
    );
  }
}