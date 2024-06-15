//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
//import 'Funcoes/selecionar_imagem.dart' as Funcoes;
// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'package:bookflix/componentes.dart';
import 'package:bookflix/funcoes.dart';
import 'alterar_senha.dart';
import 'package:flutter/material.dart';

class Conta extends StatefulWidget {
  const Conta({super.key});

  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  //File? imagemSelecionada;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  InkWell(
                      onTap: () async {                        
                        /*
                        imagemSelecionada =
                            await Funcoes.selecionarImagem(ImageSource.gallery);
                        // Faça algo com a imagemSelecionada, como exibir ou processar
                        // */                      
                      },
                      child:const CircleAvatar(
                        radius: 50, // Defina o tamanho desejado aqui
                        backgroundImage: AssetImage('assets/images/user.png'),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              // input usuário -----
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
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
                      readOnly: true,
                      controller: TextEditingController(text:  dadosUser['nome']),
                      decoration: InputDecoration(
                        labelText: 'Usuário',
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
              // input email -----
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
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
                  readOnly: true,
                  controller: TextEditingController(text:dadosUser['email']),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AlterarSenha()),
                    );
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Alterar senha',
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

void main() {
  runApp(const MaterialApp(
    home: Conta(),
  ));
}