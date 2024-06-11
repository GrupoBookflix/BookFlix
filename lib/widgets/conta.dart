//import 'dart:io';
//import 'Funcoes/selecionar_imagem.dart' as Funcoes;
import 'package:bookflix/componentes.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

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
      appBar: AppBar(
        title: const Text('Bookflix'),
      ),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: campoNome(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: campoEmail(),
              ),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/alterarsenha');
                    },
                    child: const Text('Alterar senha'),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Widget campoNome() {
  return TextFormField(
    decoration: const InputDecoration(labelText: 'Usuário'),
  );
}

Widget campoEmail() {
  return TextFormField(
    decoration: const InputDecoration(labelText: 'E-mail'),
  );
}

void main() {
  runApp(const MaterialApp(
    home: Conta(),
  ));
}