import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'funcoes.dart';
import 'package:bookflix/rotas.dart';
import 'package:flutter/services.dart';

//cores tema
Color azul = const Color(0xFF48a0d4);
Color azulClaro = const Color(0xFF93dded);

//app bar ------------------------------------------
class CustomAppBar {
  static AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Color(0xFF48a0d4),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {          
            // menu suspenso
            Scaffold.of(context).openDrawer();
          },
        )
      ),
      title: Image.asset(
        'assets/imagens/booki.png',
        height: 60,
      ),
      centerTitle: true,
      actions: [
        Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.help),
          onPressed: () {          
            // ajuda            
          },
        )
      ),
      ],
      titleTextStyle: const TextStyle(
        color: Color(0xFF48a0d4),
        fontSize: 20.0,
      ),
    );
  }
}

class PopEscopo extends StatelessWidget {
  final Widget child;
  final Future<bool> Function() onSair;

  const PopEscopo({
    required this.child,
    required this.onSair,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopEscopo(
      onSair: onSair,
      child: child,
    );
  }
}

class AvisoNivel extends StatelessWidget{
  final VoidCallback onClose;

  const AvisoNivel({
    super.key,
    required this.onClose,
  });
   
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [        
                    Text.rich(
                      TextSpan(
                        text: 'Você aumentou de nível!\n',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Color(0xFF48a0d4),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'NÍVEL ${dadosUser['nivel']}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                    const Icon(
                      Icons.emoji_events,
                      size: 60,
                      color:  Color(0xFF48a0d4),
                    ),  
                    SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                    BotaoGradiente(
                      onPressed: onClose,
                      largura: MediaQuery.of(context).size.width * 0.04,
                      texto: 'Ok',
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

//construcao das rotas para os itens do menu suspenso
class ItemMenu {
  final String titulo;
  final IconData icone;
  final String rotaItem;
  ItemMenu(this.titulo, this.icone, this.rotaItem);
}

//menu suspenso ------------------------------------------
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

 @override
  Widget build(BuildContext context) {
    return Drawer(      
      child: Container(
        color: const Color.fromARGB(255, 22, 36, 46),
        width: MediaQuery.of(context).size.width * 0.6,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),          
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 22, 36, 46),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                  
                  const CircleAvatar(
                    radius: 40, // Tamanho do círculo
                    backgroundImage: AssetImage('assets/imagens/user.png'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),                 
                  Text(
                    dadosUser['nome'] ?? 'Nome do Usuário',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ...buildMenuItems(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05), 
            itemSair(context),
          ],
        ),
      ),
    );
  }
  // Método para construir as opções do menu
  List<Widget> buildMenuItems(BuildContext context) {
    List<ItemMenu> menuItems = [
      ItemMenu('Home', Icons.home,'/principal'),
      ItemMenu('Conta', Ionicons.person, '/conta'),
      ItemMenu('Roteiro', Ionicons.book ,'/roteiro'),
      ItemMenu('Histórico de Leitura', Icons.book,'/historico_leitura'),
      //adicionar outras rotas
    ];

    return menuItems.map((item) {
      return ListTile(      
        leading: Icon(
          item.icone,
          color: Colors.white,
        ),
        title: Text(
          item.titulo,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(item.rotaItem);
        },
      );
    }).toList();
  }

  Widget itemSair(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.exit_to_app, color: Colors.white),
      title: const Text(
        'Sair',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16, 
        ),
      ),
      onTap: () {        
        Navigator.of(context).pop();
        setAppContext(context);
        PopAviso aviso = PopAviso();
        aviso.aviso('Atenção','Deseja realmente sair?', cancelar: true, okPressed: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });  
      },
    );
  }
}

// pop aviso suspenso ------------------------------------------
class PopAviso  {  
 
  void aviso(
    String titulo,
    String mensagem,
    {bool? cancelar = false,
    String textoBotao = 'OK',
    VoidCallback? okPressed,
    }) {   
    showDialog<void>(
      context: getAppContext()!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: Text(textoBotao),
              onPressed: () {
                if (okPressed != null) {                  
                  okPressed;                      
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            if (cancelar ?? false)
            TextButton(
              child: const Text('Cancelar'),
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

/*
//confirmacao se o usuario usar o botao voltar nativo
Future<void> mostrarConfirmacao(BuildContext context, String titulo, String mensagem, VoidCallback onPopInvoked) {
  Completer<void> completer = Completer<void>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Retorna true se confirmado
            },
            child: const Text('Confirmar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Retorna false se cancelado
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  ).then((result) {
    completer.complete();
    if (result != null && result) {
      onPopInvoked();
    }
  });

  return completer.future;
}
*/

// tela de carregamento simples ------------------------------------------
class TelaCarregamento {
  late OverlayEntry? _overlayEntry;
  final String? mensagem;

  TelaCarregamento({
    this.mensagem,
  });

  void show(BuildContext context, {OverlayEntry? overlayEntry}) {
    _overlayEntry = overlayEntry ?? OverlayEntry(
      builder: (BuildContext overlayContext) => Builder(
        builder: (BuildContext context) => Stack(
          children: [
            ModalBarrier(
              color: Colors.white.withOpacity(0.5),
              dismissible: false,
            ),
            AlertDialog(
              backgroundColor: Colors.transparent,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (mensagem != null)
                          Text(
                            mensagem!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        if (mensagem == null)
                          Text(
                            'Aguarde, por favor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}


//botao do tema ------------------------------------------
class BotaoGradiente extends StatelessWidget {
  final String? texto;
  final double? tamanhoFonte;
  final Icon? icone;  
  final VoidCallback onPressed;
  final double? altura;
  final double largura;  
  final bool ligado;

  const BotaoGradiente({
    super.key,
    this.texto,
    this.tamanhoFonte,
    this.icone,    
    required this.onPressed,
    required this.largura,       
    this.altura,
    this.ligado = true,       
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: altura ?? largura * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: ligado ? [const Color(0xFF48a0d4), const Color(0xFF93dded)] : [Colors.grey, Colors.grey[350]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: TextButton(        
        onPressed: ligado ? onPressed : null,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(0),
        ),
        child: Center(
          child: icone ?? Text(
            texto.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: tamanhoFonte ?? 16,
            ),
          ),
        ),
      ),
    );
  }
}

class BotaoBox extends StatefulWidget {
  final double largura;
  final double altura;
  final String texto;
  final IconData? icone;
  final bool selecionado;
  final VoidCallback onPressed;

  const BotaoBox({
    super.key,
    required this.largura,
    required this.altura,
    required this.texto,
    this.icone,
    required this.selecionado,
    required this.onPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BotaoBoxState createState() => _BotaoBoxState();
}

class _BotaoBoxState extends State<BotaoBox> {
  late bool _selecionado;

  @override
  void initState() {
    super.initState();
    _selecionado = widget.selecionado;
  }

  @override
  void didUpdateWidget(BotaoBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selecionado != _selecionado) {
      setState(() {
        _selecionado = widget.selecionado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingPercent = 0.05;
    return GestureDetector(
      onTap: widget.onPressed,
      child: SizedBox(
        width: widget.largura,
        height: widget.altura,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: _selecionado ? const Color(0xFF48a0d4) : Colors.grey.withOpacity(0.2),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icone != null)
                  Padding(
                    padding: EdgeInsets.all(widget.largura * paddingPercent),
                    child: Icon(
                      widget.icone,
                      size: widget.largura * 0.25,
                      color: _selecionado ? Colors.yellow : Colors.grey[500],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(widget.largura * paddingPercent),
                  child: Text(
                    widget.texto,
                    style: TextStyle(
                      fontSize: widget.largura * 0.2,
                      color: _selecionado ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//caixas de selecao interativas ------------------------------------------
class TextoSelectBox extends StatefulWidget {
  //usado com uma Map dicionario onde texto é key e termo é value
  final String texto;
  final String termo;
  final Function(bool, String) onSelected;

  const TextoSelectBox({
    required this.texto,
    required this.termo,
    required this.onSelected,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TextoBoxState createState() => _TextoBoxState();
}

class _TextoBoxState extends State<TextoSelectBox> {
  bool selected = false;

  void toggleSelected() {
    setState(() {
      selected = !selected;
      widget.onSelected(selected, widget.termo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSelected,
      child: Container(
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF48a0d4) : Colors.grey[400],
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          widget.texto,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

// caixa de progresso ------------------------------------------
class CaixaProgresso extends StatefulWidget { 
  const CaixaProgresso({super.key});

  @override
  CaixaProgressoState createState() => CaixaProgressoState();
}

class CaixaProgressoState extends State<CaixaProgresso> {  
  late Map<String, dynamic> livroCaixa = {};

  int obterPrazo(DateTime prazoInicial) { 
    int diasPrazo = livroAtual['dias_prazo'];
    DateTime dataFinal = prazoInicial.add(Duration(days: diasPrazo));
    Duration prazo = dataFinal.difference(DateTime.now());
    int resultado = prazo.inDays;
    return resultado;
  }

  String mudaTextoBotao() {
    if (livroAtual['ultima_pagina_lida'] < 1) {
      return 'Iniciar';  
    } else {
      return 'Retomar';
    }    
  }

  Future<bool> obterDados() async {    
    if (dadosUser['livro_atual'] != null && dadosUser['livro_atual'].isNotEmpty) {      
      livroCaixa = await buscarDadosLivro(dadosUser['livro_atual']);          
      if (livroCaixa.isNotEmpty && livroCaixa.entries.isNotEmpty) {
        livroAtual['paginas'] = livroCaixa['paginas'];
        livroAtual['imagemId'] = livroCaixa['imagemId'].toString();
        livroAtual['titulo'] = livroCaixa['titulo'];
        livroAtual['autor'] = livroCaixa['autor'];
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double largura = MediaQuery.of(context).size.width * 0.9;
    final double altura = largura * 0.4;
    final double margem = largura * 0.03;

    return FutureBuilder<bool>(
      future: obterDados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              children: [
                const Text(
                  'Carregando seu livro atual...',                  
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),                
                SizedBox(height: margem),
                SizedBox(
                  height: altura * 0.2,
                  width: altura * 0.2,
                  child: const CircularProgressIndicator(color: Color(0xFF48a0d4)),
                ),                
              ],
            ),           
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        } else if (!snapshot.hasData || !snapshot.data!) {
          return Center(
            child: Container(
              width: largura,
              height: altura,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(-2, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: margem),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Você não está lendo nenhum livro no momento. Que tal começar uma nova história?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: margem),
                          BotaoGradiente(
                            texto: "Novo Roteiro",
                            onPressed: () {
                              bool possuiGenero = (dadosUser['generos'] != null && dadosUser['generos'].length >= 3);                          
                              if (possuiGenero) {                           
                                Navigator.pushNamed(context, Rotas.roteiros);                                
                              } else {
                                Navigator.pushNamed(context, Rotas.generos); 
                              }                          
                            },
                            largura: largura * 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          int paginasLidas = livroAtual['ultima_pagina_lida'];
          int paginasRestantes = livroCaixa['paginas'] - paginasLidas;
          double porcentagemLeitura = paginasLidas / livroCaixa['paginas'];
          int prazo = obterPrazo(DateTime.parse(livroAtual['data_inicio']));
          
          return Center(
            child: Container(
              width: largura,
              height: altura,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(-2, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: margem),
                    child: CapaLivro(
                      imageId: livroCaixa['imagemId'].toString(),                              
                      tamanhoCapa: altura * 0.5,                       
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Progresso",
                                    style: TextStyle(fontSize: largura * 0.04),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      minHeight: altura * 0.08,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF48a0d4)),
                                      value: porcentagemLeitura,
                                    ),
                                  ),
                                  SizedBox(height: margem),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.circle, size: 8, color: Color(0xFF48a0d4)),
                                                SizedBox(width: margem * 0.5),
                                                Flexible(
                                                  child: Text(
                                                    "Leu: $paginasLidas página${paginasLidas != 1 ? 's' : ''}",
                                                    softWrap: true,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(fontSize: largura * 0.03),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "Resta${paginasRestantes != 1 ? 'm' : ''}: $paginasRestantes página${paginasRestantes != 1 ? 's' : ''}",
                                                    softWrap: true,
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(fontSize: largura * 0.03),
                                                  ),
                                                ),
                                                SizedBox(width: margem * 0.5),
                                                Icon(Icons.circle, size: 8, color: Colors.grey[300]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: largura * 0.3,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: margem),
                                child: Column(
                                  children: [
                                    const Icon(Icons.access_alarm),
                                    SizedBox(height: margem * 0.5),
                                    Text(
                                      "Resta${prazo != 1 ? 'm' : ''} $prazo dia${prazo != 1 ? 's' : ''} para concluir a meta!",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: largura * 0.03),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: margem / 2),
                        BotaoGradiente(
                          texto: mudaTextoBotao(),
                          largura: largura * 0.3,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(Rotas.leitura);
                          },
                        ),
                        SizedBox(height: margem / 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

//apresentacao dos dados do jogador
class ResumoUser extends StatelessWidget {
  final int nivel = dadosUser['nivel'];    
  final int pontos = dadosUser['pontos'];   
  final int livros = dadosLivrosLidos['livros_lidos'].length;
  ResumoUser({super.key});  

  Widget buildResumoItem(IconData icon, int value, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: const Color(0xFF48a0d4),
          ),         
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),          
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16, 
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double largura = MediaQuery.of(context).size.width * 0.9;
    final double altura = largura * 0.4; // Aumentado um pouco a altura

    return Center(
      child: Container(
        width: largura,
        height: altura,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildResumoItem(Icons.emoji_events, nivel, 'Nível'),
            buildResumoItem(Icons.star, pontos, 'Pontos'),
            buildResumoItem(Icons.book, livros, 'Livros Lidos'),
          ],
        ),
      ),
    );
  }
}

class Medidor extends StatelessWidget{
  final int totalPaginasLidas;  
  final String? anotacao;  

  const Medidor({
    super.key,
    required this.totalPaginasLidas,    
    this.anotacao,
  });

  @override
  Widget build(BuildContext context) { 
    int ultimaPaginaLida = livroAtual['ultima_pagina_anterior'] ?? 0;
    int valor = totalPaginasLidas - ultimaPaginaLida;      
    if (ultimaPaginaLida == 0 || totalPaginasLidas == ultimaPaginaLida) {
      valor = totalPaginasLidas;
    }     
    return 
    Column(
      children: [
        Container(   
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),                         
          child: Text(
            'Você leu $valor páginas em sua última sessão!\nContinue lendo, receba pontos e aumente seu nível!',
            textAlign: TextAlign.center,
            style: const TextStyle(                      
              fontSize: 14,                      
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05), 
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.width * 0.6,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                showLabels: false,
                showTicks: false,
                startAngle: 180,
                endAngle: 0,
                axisLineStyle: const AxisLineStyle(              
                  thickness: 0.2, // 20% do raio do medidor              
                ),
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: valor.toDouble(),
                    enableAnimation: true,
                    needleColor: Colors.grey,
                    needleLength: 0.6,
                    needleStartWidth: 1,
                    needleEndWidth: 3,
                    knobStyle: const KnobStyle(knobRadius: 0.05, color: Colors.grey),
                  ),
                ],
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 10,
                    endValue: 24,
                    color: Colors.grey[300],
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.01,
                    endWidth: 0.07,
                  ),
                  GaugeRange(
                    startValue: 26,
                    endValue: 49,
                    color: const Color(0xFF93dded),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.07,
                    endWidth: 0.12,
                  ),
                  GaugeRange(
                    startValue: 51,
                    endValue: 74,
                    color: const  Color(0xFF6dbee0),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.12,
                    endWidth: 0.17,
                  ),
                  GaugeRange(
                    startValue: 76,
                    endValue: 100,
                    color: const Color(0xFF48a0d4),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.17,
                    endWidth: 0.22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnuncioExemplo extends StatelessWidget {
  final double altura;

  const AnuncioExemplo({
    required this.altura,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(  
      alignment: Alignment.center,  
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: altura,
      child: const Text(
        'anúncio',
        textAlign: TextAlign.center,
      ),
    );
  }  
}

class CapaLivro extends StatelessWidget {
  final String imageId;
  final double tamanhoCapa;
  final double? alturaCapa;

  const CapaLivro({super.key, 
    required this.imageId,
    required this.tamanhoCapa,
    this.alturaCapa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      width: tamanhoCapa,
      height: alturaCapa ?? (tamanhoCapa*(23/15)), // proporcao padrao livro
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
      child: CachedNetworkImage(
        imageUrl: 'https://covers.openlibrary.org/b/id/$imageId-M.jpg',
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFF48a0d4))),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}