// ignore_for_file: avoid_print, library_private_types_in_public_api, prefer_is_empty
import 'package:flutter/material.dart';
import 'package:bookflix/models/livro.dart';
import 'package:ionicons/ionicons.dart';
import 'widgets/funcoes.dart';
import 'widgets/componentes.dart';
import 'rotas.dart';

final Map<String, String> generoTermos = {      
  'fiction': 'FICÇÃO',
  'fantasy': 'FANTASIA',
  'mystery': 'MISTÉRIO',
  'romance': 'ROMANCE',
  'terror': 'TERROR',
  'adventure': 'AVENTURA',
  'drama': 'DRAMA',
  'science fiction': 'FICÇÃO CIENTÍFICA',
  'comedy': 'COMÉDIA',
  'poetry': 'POESIA',
  'classical': 'CLÁSSICO',
  'police': 'POLICIAL',
  'historic': 'HISTÓRICO',
  'biography': 'BIOGRAFIA',
  'religion': 'RELIGIÃO',
  'juvenile': 'INFANTO-JUVENIL',
  // adicionar mais se necessário
};

String dicionarioGenero(String chave) {
  if (generoTermos.containsKey(chave)) {
    return generoTermos[chave]!;
  } else {    
    return "Gênero desconhecido!";
  }  
}

//selecao de generos ---------------------------------------------------

class SelecaoGenero extends StatefulWidget {
  // ignore: use_super_parameters
  const SelecaoGenero({Key? key}) : super(key: key);

  @override  
  _SelecaoGenero createState() => _SelecaoGenero();
}

class _SelecaoGenero extends State<SelecaoGenero> { 

  List<String> generosSelecionados = [];

  void generosSelect(bool selected, String termo) {
    setState(() {
      if (selected) {
        generosSelecionados.add(termo);
      } else {
        generosSelecionados.remove(termo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setAppContext(context);   
    return Scaffold(  
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),  
      backgroundColor: Colors.white,  
      body: SingleChildScrollView(
        child: Column (
          children: [               
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Do que você gosta, ${dadosUser['nome'].isNotEmpty == true ? dadosUser['nome'] : 'leitor(a)'}?',
                style: const TextStyle(
                  color: Color(0xFF48a0d4),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Center(                  
              child: Text(
                'Para construir seus roteiros de leitura, selecione \n3 gêneros literários de sua preferência. \nVocê pode mudar suas preferências em seu perfil.',
                textAlign: TextAlign.center,
                style: TextStyle(                      
                  fontSize: 14,                      
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: MediaQuery.of(context).size.height * 0.005,
                children: generoTermos.entries.map((entry) {
                  return TextoSelectBox(
                    texto: entry.value,
                    termo: entry.key,
                    onSelected: generosSelect,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            BotaoGradiente(texto: 'Confirmar',
            onPressed: () async {              
              bool sucesso = await adicionarGenero(context, dadosUser['id'],generosSelecionados);
              if (sucesso) {                                
                Navigator.of(getAppContext()!).pushReplacementNamed(Rotas.principal);          
              }                            
            },
            largura: MediaQuery.of(context).size.width * 0.35,
            ligado: generosSelecionados.length == 3),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Visibility(
              visible: generosSelecionados.length > 3,
              child: const Center(                  
                child: Text(
                  'Escolha apenas 3 gêneros!',
                  textAlign: TextAlign.center,
                  style: TextStyle(                      
                    fontSize: 12,
                    color: Colors.red,                      
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );    
  }
}

//selecao de roteiros ---------------------------------------------------

List<Livro> livrosEscolhidos = [];
List<String> livrosJaExibidos = []; 
int prazoEscolhido = 0;

void terminaRoteiro(BuildContext context){  
  showDialog(
    context: context, 
    builder: (context) => const AbaFinalizacaoRoteiro()
  ); 
}

void setPrazoEscolhido(int prazo) {
  prazoEscolhido = prazo;
}

void salvarRoteiro(BuildContext context) async {    

  livrosRoteiro = livrosEscolhidos.map((livro) => livro.isbn).toList();
  bool resultado = await criarRoteiroDeLeitura(context, 'roteiro_de_${dadosUser['nome']}', livrosRoteiro, prazoEscolhido);

  if (resultado) {
    await recolherDados(dadosUser['id']); //apos as atualizacoes, carregue novamente os dados
    terminaRoteiro(getAppContext()!);
  } else {
    PopAviso aviso = PopAviso();
    aviso.aviso('Erro','Não foi possível criar seu roteiro. Tente novamente mais tarde.',
      okPressed: () {       
        voltar(context);       
      }
    );
  }
}

void voltar(BuildContext context) {
  livrosEscolhidos.clear();
  livrosJaExibidos.clear();
  Navigator.of(context).pushReplacementNamed(Rotas.principal);
}

class SelecaoRoteiroRandom extends StatefulWidget {
  
  final List<String> generosUsuario;
  
  const SelecaoRoteiroRandom({
    required this.generosUsuario,
    super.key
  });  

  @override  
  _SelecaoRoteiroRandomState createState() => _SelecaoRoteiroRandomState();
}

List<Map<String, dynamic>> livrosLidos = dadosLivrosLidos['livros_lidos'] as List<Map<String, dynamic>>;
List<String> isbns = livrosLidos.map((livro) => livro['isbn'] as String).toList();

class _SelecaoRoteiroRandomState extends State<SelecaoRoteiroRandom> {  
  
  @override
  void initState() {
    livrosEscolhidos.clear();
    livrosJaExibidos.clear();
    livrosJaExibidos = livrosLidos.map((livro) => livro['isbn'] as String).toList();
    print('LIVROS RECUPERADOS DOS JA LIDOS:$livrosJaExibidos');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    setAppContext(context);  
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
            if(livrosEscolhidos.length == 0)
            Text(
              'Escolha 9 livros para seu roteiro!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
            if(livrosEscolhidos.length < 9 && livrosEscolhidos.length >= 1)
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
                  value: livrosEscolhidos.length / 9, //porcentagem da barra
                ),
              ),
            ),
            SizedBox(height: margem*4),                    
            ExibeLivro(genero: widget.generosUsuario[0], onLivroEscolhido: () => setState(() {})),
            ExibeLivro(genero: widget.generosUsuario[1], onLivroEscolhido: () => setState(() {})),          
            ExibeLivro(genero: widget.generosUsuario[2], onLivroEscolhido: () => setState(() {})),            
          ],
        ),
      ),
    );
  }
}

class ExibeLivro extends StatefulWidget {
  final String genero;
  final VoidCallback onLivroEscolhido;  

  const ExibeLivro({super.key, 
    required this.genero,
    required this.onLivroEscolhido,    
  });

  @override  
  _ExibeLivroState createState() => _ExibeLivroState();
}

class _ExibeLivroState extends State<ExibeLivro> {  
  late String idImagem = '';
  late Livro livro;
  late String isbnAtual = '';
  bool carregando = false;  

  @override
  void initState() {
    super.initState();
    atualizarLivro();
  }

   void finalizaRoteiro() {    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AbaPrazosRoteiro(),      
    );
  }

  void atualizarLivro() async {
    setState(() {
      carregando = true; 
    });
    print('ATUALIZANDO O LIVRO');
    try {
      livro = await buscarPorGenero(widget.genero, livrosJaExibidos);      
        idImagem = livro.imageId;
        isbnAtual = livro.isbn;
        livro = livro;        
        livrosJaExibidos.add(livro.isbn);
        carregando = false; 
        print('isbnAtual: $isbnAtual');
      setState(() {
        
      });
    } catch (e) {
      print('Erro ao buscar livro: $e');      
      carregando = false;       
    }
  }

  void salvarLivro() {
    setState(() {
      if (livrosEscolhidos.length < 9) {
        livrosEscolhidos.add(livro);  
      } if (livrosEscolhidos.length == 9) {
        finalizaRoteiro();
      }
    });
    widget.onLivroEscolhido();
    atualizarLivro();
    setState(() {});
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
                  text: dicionarioGenero(widget.genero),       
                  style: TextStyle(
                    color: const Color(0xFF48a0d4),
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
                if (!carregando) {                  
                  salvarLivro();
                  atualizarLivro(); 
                }                            
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
                        imageId: idImagem,
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
                                child: AbaDadosLivro(livro: livro),
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
                        const Center (
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
                            color: const Color(0xFF48a0d4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(                      
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                      child: CapaLivro(
                      imageId: widget.livro.imageId,
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
                      '${widget.livro.ano}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                      ),
                    ),
                    Text(
                      'Páginas: ${widget.livro.paginas}',
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

class AbaPrazosRoteiro extends StatefulWidget {
  const AbaPrazosRoteiro({super.key});

  @override
  _AbaPrazosRoteiroState createState() => _AbaPrazosRoteiroState();
}

class _AbaPrazosRoteiroState extends State<AbaPrazosRoteiro> {
  int? botaoSelecionadoIndex;

  void selecionarBotao(int index) {
    setState(() {
      botaoSelecionadoIndex = index;
      prazoEscolhido = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> aviso = [
      'Você receberá 1 estrela concluindo a leitura de cada livro no prazo.',
      'Você receberá 2 estrelas concluindo a leitura de cada livro no prazo.',
      'Você receberá 3 estrelas concluindo a leitura de cada livro no prazo.',
      'Bônus: ganhe o dobro de estrelas se concluir antes da metade do prazo!'
    ];
    Map<String, Color> textoNivel = {
      'FÁCIL': Colors.blue,
      'MÉDIO': Colors.green,
      'DIFÍCIL': Colors.red,
    };
    double margem = MediaQuery.of(context).size.height * 0.02;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Excelente escolha!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.11,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: CapaLivro(
                            imageId: livrosEscolhidos[i].imageId,
                            tamanhoCapa: MediaQuery.of(context).size.width * 0.15,
                            alturaCapa: MediaQuery.of(context).size.height * 0.2,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.11,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 3; i < 6; i++)
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: CapaLivro(
                            imageId: livrosEscolhidos[i].imageId,
                            tamanhoCapa: MediaQuery.of(context).size.width * 0.15,
                            alturaCapa: MediaQuery.of(context).size.height * 0.2,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.11,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 6; i < 9; i++)
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: CapaLivro(
                            imageId: livrosEscolhidos[i].imageId,
                            tamanhoCapa: MediaQuery.of(context).size.width * 0.15,
                            alturaCapa: MediaQuery.of(context).size.height * 0.2,
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: margem),
            const Text(
              'Agora defina o prazo de leitura:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: margem*0.4),
            Row(
              children: [
                BotaoBox(
                  largura: MediaQuery.of(context).size.width * 0.2,
                  altura: MediaQuery.of(context).size.height * 0.1,
                  texto: '30 dias',
                  icone: Ionicons.star_outline,
                  selecionado: botaoSelecionadoIndex == 0,
                  onPressed: () {
                    selecionarBotao(0);
                  },
                ),
                SizedBox(width: margem * 0.5),
                BotaoBox(
                  largura: MediaQuery.of(context).size.width * 0.2,
                  altura: MediaQuery.of(context).size.height * 0.1,
                  texto: '20 dias',
                  icone: Ionicons.star_half_outline,
                  selecionado: botaoSelecionadoIndex == 1,
                  onPressed: () {
                    selecionarBotao(1);
                  },
                ),
                SizedBox(width: margem * 0.5),
                BotaoBox(
                  largura: MediaQuery.of(context).size.width * 0.2,
                  altura: MediaQuery.of(context).size.height * 0.1,
                  texto: '10 dias',
                  icone: Ionicons.star,
                  selecionado: botaoSelecionadoIndex == 2,
                  onPressed: () {
                    selecionarBotao(2);
                  },
                ),
              ],
            ),
            SizedBox(height: margem*0.4),
            if (botaoSelecionadoIndex != null)
            Text(
              botaoSelecionadoIndex != null
                ? textoNivel.keys.elementAt(botaoSelecionadoIndex!)
                : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: botaoSelecionadoIndex != null
                    ? textoNivel.values.elementAt(botaoSelecionadoIndex!)
                    : Colors.black,
              ),
              ),
            SizedBox(height: margem*0.4),
            Text(
              botaoSelecionadoIndex != null
                  ? aviso[botaoSelecionadoIndex!]
                  : 'Por favor, selecione um prazo de leitura.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14
              ),
            ),
            SizedBox(height: margem*0.4),
            Text(
              botaoSelecionadoIndex != null
                  ? aviso[3]
                  : '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13
              ),
            ),
            SizedBox(height: margem),
            BotaoGradiente(
              onPressed: () {                            
                if(botaoSelecionadoIndex != null ) {
                  if (botaoSelecionadoIndex == 0) {
                   setPrazoEscolhido(30);
                  } else if (botaoSelecionadoIndex == 1) {
                    setPrazoEscolhido(20);
                  } else {
                    setPrazoEscolhido(10);
                  }
                  Navigator.of(context).pop();                                  
                  salvarRoteiro(getAppContext()!);                  
                }
              },
              largura: MediaQuery.of(context).size.width * 0.35,
              texto: "Estou pronto!",
            ),
          ],
        ),
      ),
    );
  }
}

class AbaFinalizacaoRoteiro extends StatelessWidget {
  const AbaFinalizacaoRoteiro({super.key});

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
            const Text(
              'Seu roteiro está pronto!\nBoa leitura!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              Ionicons.checkmark_circle_outline,
              size: MediaQuery.of(context).size.width * 0.15,
              color: const Color(0xFF48a0d4),
            ), 
            const SizedBox(height: 20),           
            BotaoGradiente(
              onPressed: () {
                voltar(context);
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