// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'cadastro.dart';
import 'package:get/get.dart';
import 'componentes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'principal.dart';

LoadingOverlay carregamento = LoadingOverlay();

class Login extends StatefulWidget {
  // ignore: use_super_parameters
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //logica =======================================================================================
  
  //caixa de seleção 'lembrar-me'
  bool lembrar = false;

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _senhaFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  
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

  Future<void> _loginUsuario(String email, String senha) async {

    carregamento.show(context);

    const String apiUrl = 'https://backend-8wht.onrender.com/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{      
      'email': email,
      'senha': senha,      
    }),
    );

    if (response.statusCode == 200) {
      carregamento.hide();
      Get.to(Principal());
    } else if (response.statusCode == 404) {
      carregamento.hide();
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Usuário não encontrado. Revise email e senha'),
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
    } else if (response.statusCode == 401) {
      carregamento.hide();
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Credenciais inválidas'),
              content: Text('Email ou senha inválidos. Por favor tente novamente'),
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
      carregamento.hide();
      // outra lógica para verificação de login
    }
  }

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
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.height * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset('assets/imagens/booki.png'),
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
                  hintText: 'E-mail',
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
                validator: (senha) {
                   if (senha == null || senha.isEmpty) {
                    return 'A senha é obrigatória';
                  } else if (senha.contains(RegExp(r"[\'\\\;\,\)\(\<\>\=\*]")) || 
                    senha.contains(RegExp(r'[\"\\\;\,\)\(\<\>\=\*]'))) {
                    return 'Não use caracteres inválidos: " ; , ) ( < > = *';
                  } else if (senha.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          //caixa selecao Lembrar-me ----------------------------------------------------------------------    
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1), 
            child: Row(
              children: [
                Checkbox(
                  activeColor: Color(0xFF48a0d4),
                  checkColor: Color(0xFF48a0d4),
                  shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                  value: lembrar,
                  onChanged: (value) {
                    setState(() {
                      lembrar = value!;
                    });
                  },
                ),
                Text("Lembrar-me"),
              ],
            ),
          ), 
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          //texto cadastro ----------------------------------------------------------------------
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            child: GestureDetector(
              onTap: () { //para a pagina de cadastro                                             
                //Get.to(const Cadastro(), transition: Transition.fade);                                                   
                Get.to(() => Cadastro(), transition: Transition.fade);
              },
              child: Text(
                'Não possui uma conta? Cadastrar',
                style: TextStyle(
                  color: Color(0xFF48a0d4), // Cor do texto como link
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 15, // Adiciona sublinhado para indicar que é um link
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          // botao entrar ----------------------------------------------------------------------
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
                bool emailValido = _emailFormKey.currentState!.validate();
                bool senhaValida = _senhaFormKey.currentState!.validate();                               

                if (emailValido && senhaValida) {
                  await _loginUsuario(_emailController.text, _senhaController.text);
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
                'Entrar',
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

