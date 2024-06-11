// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'componentes.dart';
import 'funcoes.dart';
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
  //caixa de seleção 'lembrar-me'
  bool lembrar = false;

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _senhaFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

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
            child: Image.asset('assets/images/booki.png'),
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
                validator: validatePassword,
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
                    lembrar = value!;               
                    //falta implementar a lógica da opção lembrar
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
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Cadastro()                    
                  ),
                );
                //ir para cadastro
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
                  bool sucesso = await loginUsuario(context, _emailController.text, _senhaController.text); 
                  if (sucesso) {
                    //ir para pagina principal
                    Navigator.pushReplacement( // Substitui a página atual pela página principal
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(builder: (context) => Principal()),
                    );
                  }
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

class Cadastro extends StatefulWidget {
  // ignore: use_super_parameters
  const Cadastro({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {     

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
                validator: validatePassword,
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
                Navigator.pop(context);
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

                PopAviso aviso = PopAviso();

                if (nomeValido && emailValido && senhaValida && repeteSenhaValida) {
                  bool sucesso = await registraUsuario(context, _nomeController.text, _emailController.text, _senhaController.text);
                  if (sucesso) {
                  aviso.aviso('Cadastro','Usuário cadastrado com sucesso!');
                   // ignore: use_build_context_synchronously
                   Navigator.pop(context);
                  }                   
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