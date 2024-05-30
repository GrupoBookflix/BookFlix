// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'componentes.dart';

LoadingOverlay carregamento = LoadingOverlay();
    
class Cadastro extends StatefulWidget {
  // ignore: use_super_parameters
  const Cadastro({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {   

  String? validateEmail(String? email) {
    
    if (email == null || email.isEmpty) {
      return 'Email é obrigatório';
    }    
    // não usar '\' na expressão
    RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    
    final bool isEmailValid = emailRegex.hasMatch(email);
    if (!isEmailValid) {
      return 'Informe um email válido';
    }
    return null;
  }

  Future<void> _registraUsuario(String nome, String email, String senha) async {

    carregamento.show(context);    

    const String apiUrl = 'https://backend-8wht.onrender.com/usuario';
    
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
      'nivel': 1,
      'pontos': 0,
      'livro_atual': null,
      'data_criacao': DateTime.now().toIso8601String(),
    }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {     
      // sucesso
      carregamento.hide();
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bem vindo!'),
            content: Text('Cadastro efetuado com sucesso!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.back();
                },
              ),
            ],
          );
        },
      );      
    } else if (response.statusCode == 400) {
        // falha
        carregamento.hide();      
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Já existe usuário com este email.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // falha
        carregamento.hide();      
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Falha no cadastro. Por favor, tente novamente mais tarde.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }    
  }

  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _senhaFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _repeteSenhaFormKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _repeteSenhaController = TextEditingController();
  
  //interface =======================================================================================
  @override
  Widget build(BuildContext context) {       
    return Scaffold(    
      backgroundColor: Colors.white,  
      body: SingleChildScrollView(
        child: Column (
        children: [      
          //retangulo superior ----------------------------------------------------------------------
          Container (
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1), //margens laterais
            height: MediaQuery.of(context).size.height * 0.06, 
            decoration: BoxDecoration(
              gradient: LinearGradient( //cor gradiente
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // ignore: prefer_const_literals_to_create_immutables
                colors: [Color(0xFF48a0d4),Color(0xFF93dded)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          //titulo ----------------------------------------------------------------------
          Container(
            width: double.infinity, // Largura do container igual à largura da tela
            alignment: Alignment.center, 
            child: Text(
              'BOOKFLIX',
              style: TextStyle(
                color: Color(0xFF48a0d4), 
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),         
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          //formulario nome ----------------------------------------------------------------------
          Form(  
            key: _nameFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,         
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 7), 
                  ),
                ],
              ),
              child: TextFormField( 
                controller: _nomeController,               
                decoration: InputDecoration(
                  hintText: 'Nome',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (name) => name!.length < 3 ? 'Informe um nome válido' : null,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          //formulario email ----------------------------------------------------------------------
          Form(          
            key: _emailFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 7), 
                  ),
                ],
              ),
              child: TextFormField(   
                controller: _emailController,             
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: validateEmail,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          //formulario senha ----------------------------------------------------------------------
          Form(
            key: _senhaFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 7), // Mudança na posição da sombra
                  ),
                ],
              ),
              child: TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (senha) => senha!.length < 6 ? 'A senha deve ter pelo menos 6 caracteres' : null,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          //formulario repete a senha ----------------------------------------------------------------------
          Form(
            key: _repeteSenhaFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 7), // Mudança na posição da sombra
                  ),
                ],
              ),
              child: TextFormField(
                controller: _repeteSenhaController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Repita a senha',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (repeteSenha) {
                  if (repeteSenha == null || repeteSenha.isEmpty || _senhaController.text != repeteSenha) {
                    return 'As senhas não correspondem';
                  } else {
                    return null;
                  }
                }
                 ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),          
          //texto voltar ----------------------------------------------------------------------
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            child: GestureDetector(
              onTap: () { //clicar, volta para a pagina de login                         
                Get.back();
              },
              child: Text(
                'Voltar',
                style: TextStyle(
                  color: Color(0xFF48a0d4), // Cor do texto como link
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold, // Adiciona sublinhado para indicar que é um link
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          // botao cadastrar ----------------------------------------------------------------------
         Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
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
                  offset: Offset(0, 7), 
                ),
              ],
            ),
            child: TextButton(
              onPressed: () async {
                bool nomeValido = _nameFormKey.currentState!.validate();
                bool emailValido = _emailFormKey.currentState!.validate();
                bool senhaValida = _senhaFormKey.currentState!.validate();
                bool repeteSenhaValida = _repeteSenhaFormKey.currentState!.validate();                

                if (nomeValido && emailValido && senhaValida && repeteSenhaValida) {
                  await _registraUsuario(_nomeController.text, _emailController.text, _senhaController.text);
                } else {
                  setState(() {
                    //Implementar estado
                  });
                }
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Cadastrar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}