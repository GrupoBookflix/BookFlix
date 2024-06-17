// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'widgets/componentes.dart';
import 'widgets/funcoes.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

 @override
  Widget build(BuildContext context) {  
    recolherDados(dadosUser['id']);          
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
                const CaixaProgresso(), // implementar lógica                
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    dadosUser['nome'],
                    style: const TextStyle(
                      color: Color(0xFF48a0d4),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ResumoUser(),                            
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Medidor(totalPaginasLidas: livroAtual['total_paginas_lidas'] ?? 0), //implementar a logica das paginas               
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

class HistoricoLeitura extends StatefulWidget {
  const HistoricoLeitura({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoricoLeituraState createState() => _HistoricoLeituraState();
}

class _HistoricoLeituraState extends State<HistoricoLeitura> {

  List<Map<String, dynamic>> livrosDados = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDadosLivros();
  }

  Future<void> carregarDadosLivros() async {

    List<Map<String, dynamic>> livrosLidos = dadosLivrosLidos['livros_lidos'] as List<Map<String, dynamic>>;
    List<String> isbns = livrosLidos.map((livro) => livro['isbn'] as String).toList();
    List<Map<String, dynamic>> dados = [];

    for (int i = 0; i < isbns.length; i++) {
      try {
        Map<String, dynamic> livro = await buscarDadosLivro(isbns[i]);
        livro['data_leitura'] = livrosLidos[i]['data_leitura'];
        dados.add(livro);
      } catch (e) {
        print('Erro ao buscar livro ISBN ${isbns[i]}: $e');
      }
    }
    setState(() {
      livrosDados = dados;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {  
    final double largura = MediaQuery.of(context).size.width * 0.9;
    final double altura = largura * 0.4;
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
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                   'Livros concluídos',
                    style: TextStyle(
                      color: Color(0xFF48a0d4),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),                  
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                if(carregando) ...[
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    const Text(
                      'Carregando seus livros'
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    SizedBox (
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const CircularProgressIndicator(
                        color: Color(0xFF48a0d4),                      
                        ),
                    ),
                  ],
                ),                
                ] else ...[
                  if(dadosLivrosLidos.isEmpty ) ...[
                  const Text(
                    'Você ainda não concluiu nenhum livro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  ] else ...[
                  GridView.builder(
                    padding: EdgeInsetsDirectional.all(MediaQuery.of(context).size.width * 0.05),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 capas por linha
                      crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                      mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
                      childAspectRatio: 2 / 3, // Proporção largura/altura da capa
                    ),
                    itemCount: livrosDados.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: CapaLivro(                      
                          imageId: livrosDados[index]['imagemId'].toString(),
                          tamanhoCapa:  altura * 0.6,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String dataLeitura = livrosDados[index]['data_leitura'];      
                              DateTime data = DateTime.parse(dataLeitura);
                              String dataFormat = '${data.day}/${data.month}/${data.year}';
                              return Center(
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
                                  margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.55,
                                  // aba de detalhes do livro
                                  child: Column(                                  
                                    children: [                                   
                                      CapaLivro(                      
                                        imageId: livrosDados[index]['imagemId'].toString(),
                                        tamanhoCapa:  altura * 1.2,
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                                      Text(
                                        'Concluído em\n$dataFormat',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),                                   
                                    ],
                                  ),
                                ),
                              );
                            },
                          );                        
                        },
                      );
                    },
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.05), 
                 ],
               ],
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