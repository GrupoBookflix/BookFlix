// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api
import 'package:bookflix/componentes.dart';
import 'package:flutter/material.dart';
import 'package:bookflix/models/livro.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'principal.dart';

//constroi a tela de carregamento
LoadingOverlay carregamento = LoadingOverlay();

class CapaLivro extends StatelessWidget {
  final String imageUrl;
  final double tamanhoCapa;

  const CapaLivro({super.key, 
    required this.imageUrl,
    required this.tamanhoCapa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      width: tamanhoCapa,
      height: tamanhoCapa * (23 / 15), // proporcao padrao livro
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }
}

List<String> generosUsuario = ['Horror','Romance','Adventure'];

class SelecaoRoteiroRandom extends StatefulWidget {
  @override
  _SelecaoRoteiroRandomState createState() => _SelecaoRoteiroRandomState();
}

class _SelecaoRoteiroRandomState extends State<SelecaoRoteiroRandom> {
  List<String> livrosEscolhidos = []; 

  @override
  Widget build(BuildContext context) {
    double margem = MediaQuery.of(context).size.width * 0.02;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: margem),
            if(livrosEscolhidos.isEmpty)
            Text(
              'Escolha 9 livros para seu roteiro!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
            if(livrosEscolhidos.length < 9)
            Text(
              'Faltam ${9-livrosEscolhidos.length} livros para montar seu roteiro!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
            if(livrosEscolhidos.length == 9)
            Text(
              'Tudo pronto!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: margem*4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(              
                  minHeight: MediaQuery.of(context).size.height * 0.02,
                  backgroundColor:
                      Colors.grey[300], //cor barra vazia
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF48a0d4), //cor barra cheia
                  ),
                  value: livrosEscolhidos.length / 9,   //porcentagem da barra
                ),
              ),
            ),
            SizedBox(height: margem*4),
            ExibeLivro(genero: generosUsuario[0], livrosEscolhidos: livrosEscolhidos, onLivroEscolhido: () => setState(() {})),
            ExibeLivro(genero: generosUsuario[1], livrosEscolhidos: livrosEscolhidos, onLivroEscolhido: () => setState(() {})),          
            ExibeLivro(genero: generosUsuario[2], livrosEscolhidos: livrosEscolhidos, onLivroEscolhido: () => setState(() {})),            
          ],
        ),
      ),
    );
  }
}

class ExibeLivro extends StatefulWidget {
  final String genero;
  final VoidCallback onLivroEscolhido;
  final List<String> livrosEscolhidos;

  const ExibeLivro({
    required this.genero,
    required this.onLivroEscolhido,
    required this.livrosEscolhidos,
  });

  @override
  _ExibeLivroState createState() => _ExibeLivroState();
}

class _ExibeLivroState extends State<ExibeLivro> {
  List<String> livrosJaExibidos = [];  
  late String idImagem = '';
  late Livro dadosLivro;
  late String isbnAtual = '';
  bool carregando = false;  

  @override
  void initState() {
    super.initState();
    carregandoLivro();
  }

   void finalizaRoteiro() {
    print('finalizando');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AbaFinalizacaoRoteiro(),      
    );
  }

  void carregandoLivro() async {
    setState(() {
      carregando = true; 
    });

    try {
      Livro livro = await buscarPorGenero(widget.genero, livrosJaExibidos);
      setState(() {
        idImagem = livro.imageId;
        isbnAtual = livro.isbn;
        dadosLivro = livro;
        livrosJaExibidos.add(livro.isbn);
        carregando = false; 
      });
    } catch (e) {
      print('Erro ao buscar livro: $e');
      setState(() {
        carregando = false; 
      });
    }
  }
  void atualizarLivro() {    
    setState(() {
      carregando = true;
    });
    carregandoLivro();
  }

  void salvarLivro() {
    setState(() {
      if (widget.livrosEscolhidos.length < 9) {
        widget.livrosEscolhidos.add(isbnAtual);  
      } if (widget.livrosEscolhidos.length == 9) {
        finalizaRoteiro();
      }
    });
    widget.onLivroEscolhido();
    atualizarLivro();
  }

  @override
  Widget build(BuildContext context) {
    double margem = MediaQuery.of(context).size.width * 0.02;
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,     
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: margem*2),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan (
                  text: 'Porque você gosta de ',       
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                ),
                TextSpan(
                  text: widget.genero,       
                  style: TextStyle(
                    color: Color(0xFF48a0d4),
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),            
          ),          
        ),        
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.all(margem*4),
              icon: Icon(
                Ionicons.checkmark_circle,
                size: margem*6,
                color: const Color(0xFF48a0d4),
                ),
              onPressed: () {   
                //rodar animacao livro escolhido
                salvarLivro();
                atualizarLivro();                             
              },
            ),
            Container(   
              padding: EdgeInsets.all(margem),           
              margin: EdgeInsets.all(margem/2),
              width: MediaQuery.of(context).size.width * 0.26,
              height: (MediaQuery.of(context).size.width * 0.26) * (23 / 15), //proporcao comum livro
              child: Stack(
                children: [
                  if (idImagem.isNotEmpty)//se tiver imagem
                    GestureDetector(
                      child: CapaLivro(
                        imageUrl: 'https://covers.openlibrary.org/b/id/$idImagem-M.jpg',
                        tamanhoCapa: MediaQuery.of(context).size.width * 0.26,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                margin: EdgeInsets.all(margem*5),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.6,
                                // aba de detalhes do livro
                                child: AbaDadosLivro(livro: dadosLivro),
                              ),
                            );
                          },
                        );                        
                      },
                    ),
                  if (carregando) // animação de carregamento se o livro estiver sendo buscado
                    Stack(
                      children: [
                        ModalBarrier(
                          color: Colors.white.withOpacity(0.5),
                          dismissible: false,
                        ),
                        Center (
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF48a0d4)),
                        ),
                        ),
                      ],
                    ),
                ],
              ),
            ),            
            IconButton(
              padding: EdgeInsets.all(margem*4),
              icon: Icon(
                Ionicons.refresh_circle,
                size: margem*6,
                color: const Color(0xFF48a0d4),
                ),
              onPressed: atualizarLivro,
            ),
          ],
        ),
        SizedBox(height: margem),
      ],
    );
  }
}

Future<Livro> buscarPorGenero(String genero, List<String> livrosJaExibidos) async {
  bool pesquisa = false; 
  //enquanto o livro não ter os dados essenciais, busque o próximo
  while (!pesquisa) {
  
    final response = await http.get(Uri.parse(
      'https://openlibrary.org/search.json?subject=$genero&sort=rating&limit=7&fields=title,isbn,cover_i,author_name,publish_date'
    ));
    if (response.statusCode == 200) {      
      final booksDataArray = json.decode(response.body)['docs'];
      
      if (booksDataArray != null && booksDataArray.isNotEmpty) {

        for (var book in booksDataArray) {

        if (book['isbn'] != null &&
            book['isbn'] is List &&
            book['isbn'].isNotEmpty &&
            book['cover_i'] != null) {

          String? isbn = book['isbn'][0];

          if (isbn != null && !livrosJaExibidos.contains(isbn)) {
            Livro livro = Livro(
              isbn: isbn,
              nome: book['title'],
              imageId: book['cover_i'].toString(),
              autor: book['author_name'][0],
              ano: book['publish_date'][0],
              descricao: book['description'],              
            );            
            livrosJaExibidos.add(isbn);            
            pesquisa = true;
            return livro;
          }
        } else {
          if(book['isbn'] == null) {
            print('resultado pesquisa: isbn nulo');
          }
          if(book['cover_i'] == null) {
            print('resultado pesquisa: capa nula');
          }
        }
        }
      }
    }
    else {
      print('Erro na requisição: ${response.statusCode}');
      // Imprimir o motivo do erro, se disponível
      if (response.body.isNotEmpty) {
        print('Motivo do erro: ${response.body}');
      }
    }   
  }
  throw Exception('Não foi possível encontrar um livro válido');
}

class AbaDadosLivro extends StatefulWidget {
  final Livro livro;

  const AbaDadosLivro({
    super.key,
    required this.livro,
  });

  @override  
  _AbaDadosLivroState createState() => _AbaDadosLivroState();
}

class _AbaDadosLivroState extends State<AbaDadosLivro> {   

  @override
  Widget build(BuildContext context) {        
    return Scaffold(            
      body:  Stack(
        children: [          
          SingleChildScrollView(             
            child: Center(
              child: Container (
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                alignment: Alignment.center,
                child: Column (
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text.rich(
                        TextSpan(
                          text: widget.livro.nome,
                          style: TextStyle(                          
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: Color(0xFF48a0d4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(                      
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                      child: CapaLivro(
                      imageUrl: 'https://covers.openlibrary.org/b/id/${widget.livro.imageId}-M.jpg',
                      tamanhoCapa: MediaQuery.of(context).size.width * 0.5
                    ),
                    ),
                    Text(
                      '${widget.livro.autor}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                      ),
                    ),
                    Text(
                      'Ano: ${widget.livro.ano}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                      ),
                    ),                    
                  ],
                ),
                             
              ),
            ),
          ), 
        ],         
      ),
    );
  }   
}

class AbaFinalizacaoRoteiro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,        
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seu roteiro está pronto!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Ionicons.checkmark_circle_outline,
              size: MediaQuery.of(context).size.width * 0.15,
              color: const Color(0xFF48a0d4),
            ), 
            SizedBox(height: 20),           
            BotaoGradiente(
              onPressed: () {
                Navigator.pushReplacement( // Substitui a página atual pela página principal
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const Principal()),
                );
              },
              largura: MediaQuery.of(context).size.width * 0.3,
              texto: "Voltar",
              ),            
          ],
        ),
      ),
    );
  }
}