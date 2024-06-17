// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'widgets/funcoes.dart';
import 'widgets/componentes.dart';

class ContaUsuario extends StatefulWidget {
  const ContaUsuario({super.key});

  @override
  _ContaUsuarioState createState() => _ContaUsuarioState();
}

class _ContaUsuarioState extends State<ContaUsuario> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Opções do perfil',
                style: TextStyle(
                  color: Color(0xFF48a0d4),
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            InkWell(
              onTap: () async {
                /*
                imagemSelecionada =
                    await Funcoes.selecionarImagem(ImageSource.gallery);
                // Faça algo com a imagemSelecionada, como exibir ou processar
                // */
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.09,  // Tamanho do círculo
                    backgroundImage: const AssetImage('assets/imagens/user.png'),                 
                  ),
                  Positioned(
                    bottom: 90,
                    right: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.09,
                        decoration: const BoxDecoration(
                          color: Color(0xFF48a0d4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                    ),
                  ),
                ],                
              ),
            ),            
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),    
            Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Usuário: ${dadosUser['nome']}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(                  
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),            
            Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email: ${dadosUser['email']}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(                  
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03), 
            BotaoGradiente(
              onPressed:(){  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlterarSenha()),  
                );   
              },
              largura: MediaQuery.of(context).size.width * 0.45,
              altura: MediaQuery.of(context).size.height * 0.055,
              texto: 'Trocar a senha',
            ),
          ],
        ),
      ),     
    );
  }
}

class AlterarSenha extends StatefulWidget {
  const AlterarSenha({super.key});

  @override
  _AlterarSenhaState createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {

  final GlobalKey<FormState> _antigaSenhaFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _novaSenhaFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _repeteSenhaFormKey = GlobalKey<FormState>();

  final TextEditingController _antigaSenhaController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _repeteSenhaController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Trocar a senha',
                style: TextStyle(
                  color: Color(0xFF48a0d4),
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Usuário: ${dadosUser['nome']}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(                  
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // senha antiga
                  Form(  
                    key: _antigaSenhaFormKey,
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
                            offset: const Offset(0, 7), 
                          ),
                        ],
                      ),
                      child: TextFormField( 
                        controller: _antigaSenhaController,  
                        obscureText: true,             
                        decoration: InputDecoration(
                          hintText: 'Senha antiga',
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
                  // input senha nova
                  Form(  
                    key: _novaSenhaFormKey,
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
                            offset: const Offset(0, 7), 
                          ),
                        ],
                      ),
                      child: TextFormField( 
                        controller: _novaSenhaController,  
                        obscureText: true,             
                        decoration: InputDecoration(
                          hintText: 'Nova senha',
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
                  // repete senha
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
                            offset: const Offset(0, 7), 
                          ),
                        ],
                      ),
                      child: TextFormField( 
                        controller: _repeteSenhaController,  
                        obscureText: true,             
                        decoration: InputDecoration(
                          hintText: 'Repita a nova senha',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (repeteSenha) {
                          if (repeteSenha == null || repeteSenha.isEmpty || _repeteSenhaController.text != repeteSenha) {
                            return 'As senhas não correspondem';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: GestureDetector(
                      onTap: () {               
                        //logica para recuperar senha
                      },
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          color: Color(0xFF48a0d4), // Cor do texto como link
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 15, // Adiciona sublinhado para indicar que é um link
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  BotaoGradiente(
                    onPressed:() async {
                      bool antigaSenhaValida = _antigaSenhaFormKey.currentState!.validate();
                      bool novaSenhaValida = _novaSenhaFormKey.currentState!.validate();
                      bool repeteSenhaValida = _repeteSenhaFormKey.currentState!.validate(); 

                      PopAviso aviso = PopAviso();

                      if (antigaSenhaValida && novaSenhaValida && repeteSenhaValida) {
                        bool sucesso = await atualizaUsuario(context, senha: _antigaSenhaController.text, novaSenha: _novaSenhaController.text, mostrar: true);
                        if (sucesso) {
                        aviso.aviso('Atualização','Senha alterada com sucesso!');
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        }                   
                      }
                    },
                    largura: MediaQuery.of(context).size.width * 0.45,
                    altura: MediaQuery.of(context).size.height * 0.055,
                    texto: 'Alterar senha',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),     
    );
  }
}