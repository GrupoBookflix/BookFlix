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
              TextFormField(
                decoration:const InputDecoration(labelText: 'Senha Antiga'),
              ),
              TextFormField(
                decoration:const InputDecoration(labelText: 'Nova Senha'),
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
              ElevatedButton(
                onPressed: () {
                  //print('salvar senha');
                },
                child:const Text('Salvar Senha'),
              )
            ],
          ),
        )
      )
    );
  }
}