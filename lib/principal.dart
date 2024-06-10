import 'package:flutter/material.dart';
import 'componentes.dart';
import 'funcoes.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // Caixa de progresso do livro atual
                CaixaProgresso(prazoData: DateTime.now(), paginasLivro: 150, paginasLidas: 10, livroAtual: true), // implementar lógica                
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
                ResumoUser(),  
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),              
                const Center(                  
                  child: Text(
                    'Você leu 0 páginas esta semana! Continue lendo para receber pontos e aumentar seu nível!',
                    textAlign: TextAlign.center,
                    style: TextStyle(                      
                      fontSize: 14,                      
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const Medidor(valor: 0), //implementar a logica das paginas               
              ],
            ),
          ),
          // Retângulo inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF48a0d4), Color(0xFF93dded)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}