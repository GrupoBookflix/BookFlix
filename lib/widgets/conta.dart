import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './funcoes/selecionar_imagem.dart' as funcoes;

class Conta extends StatefulWidget {
  const Conta({super.key});

  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  File? imagemSelecionada;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _selecionarImagem() async {
    File? imagem = await funcoes.selecionarImagem(ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        imagemSelecionada = imagem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookflix'),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: _selecionarImagem,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imagemSelecionada != null
                          ? FileImage(imagemSelecionada!)
                          : const AssetImage('assets/images/user.png') as ImageProvider,
                    ),
                  ),
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
                child: TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Ação ao pressionar o botão
                    print('Alterar senha pressionado');
                  },
                  child: const Text('Alterar senha'),
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
