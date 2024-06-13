// ignore_for_file: library_private_types_in_public_api
//import 'dart:io';
//import 'Funcoes/selecionar_imagem.dart' as Funcoes;
import 'package:flutter/material.dart';

class AlterarSenha extends StatefulWidget {
  const AlterarSenha({super.key});

  @override
  _AlterarSenhaState createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // input senha antiga
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: TextFormField(
                  //obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha antiga',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // input senha nova
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: TextFormField(
                  //obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Nova Senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Tooltip(
                message:
                    'Enviaremos para seu email a possibilidade de alterar a senha',
                child: Padding(
                  padding: const EdgeInsets.all(
                      20.0), // Adicionando padding de 8.0 em todas as direções
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.lightBlue[600],
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.lightBlue[600],
                    ),
                  ),
                ),
              ),
              // btn alterar senha -----
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    // ignore: prefer_const_literals_to_create_immutables
                    colors: [Color(0xFF48a0d4), Color(0xFF93dded)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Salvar Senha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}