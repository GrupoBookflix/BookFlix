import 'package:flutter/material.dart';
import 'componentes.dart';
import 'funcoes.dart';

class Principal extends StatefulWidget {
  // ignore: use_super_parameters
  const Principal({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

 @override
  Widget build(BuildContext context) {    
    return Scaffold(    
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,  
      body: SingleChildScrollView(
        child: Column (
          children: [ 
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            //caixa de progresso do livro atual ---------------------------------------------
            CaixaProgresso(prazoData: DateTime.now(), paginasLivro: 150, paginasLidas: 10, livroAtual: false), //implementar logica
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),          
            Container(
                alignment: Alignment.center,
                child: Text(
                  dadosBasicosUser('nome'),
                  style: const TextStyle(
                    color: Color(0xFF48a0d4),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), 
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            const ResumoUser(nivel: 1, pontos: 6, livros: 1),
            //retangulo inferior ----------------------------------------------------------------------
            Align(
              alignment: Alignment.bottomCenter,
              child: Container (            
                height: MediaQuery.of(context).size.height * 0.06, 
                decoration: const BoxDecoration(
                  gradient: LinearGradient( //cor gradiente
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // ignore: prefer_const_literals_to_create_immutables
                    colors: [Color(0xFF48a0d4),Color(0xFF93dded)],
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