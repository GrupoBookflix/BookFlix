import 'package:bookflix/roteiros.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'funcoes.dart';

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

//construcao das rotas para os itens do menu suspenso
class ItemMenu {
  final IconData icone;
  final String titulo;
  final String rotaItem;

  ItemMenu(this.icone, this.titulo, this.rotaItem);
}

//menu suspenso ------------------------------------------
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0XFF2D2C2C),
      child: Column(
        children: <Widget>[
          DrawerHeader(
            // ignore: prefer_const_constructors
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40, // Tamanho do círculo
                  backgroundImage: AssetImage('assets/imagens/user.png'),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.03),
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: buildMenuItems(context),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Color(0xFF48a0d4)),
            title: const Text(
              'Sair',
              style: TextStyle(
              color: Colors.white,
              ),
            ),
            onTap: () {              
              Navigator.of(context).pop();
              confirmaSair();
            },
          ),
        ],
      ),
    );
  }

  // Método para construir as opções do menu
  List<Widget> buildMenuItems(BuildContext context) {
    List<ItemMenu> menuItems = [
      ItemMenu(Icons.home,'Home', '/'),
      ItemMenu(Icons.book, 'Roteiro de Leitura', '/'),
      ItemMenu(Icons.settings, 'Preferências', '/'),
      ItemMenu(Icons.history, 'Histórico de Leitura', '/'),
      //adicionar outras rotas
    ];

    return menuItems.map((item) {
      return ListTile(
        leading: Icon(item.icone, color: const Color(0xFF48a0d4)),
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
}

// pop aviso suspenso ------------------------------------------
class PopAviso  {  
 
  void aviso(
    String titulo,
    String mensagem,
    {bool?
    cancelar = false,
    String textoBotao = 'OK',
    VoidCallback? okPressed
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
                  okPressed();                 
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            if (cancelar ?? false)
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
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
class LoadingOverlay {
  late OverlayEntry? _overlayEntry;
  String? _loadingText; //texto opcional

  // Mostrar carregamento
  void show(BuildContext context, {String? loadingText}) {
    _loadingText = loadingText;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context = getAppContext()!;
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Stack(
          children: <Widget>[
            ModalBarrier(
              color: Colors.white.withOpacity(0.5),
              dismissible: false,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF48a0d4)),
                  ),
                  if (_loadingText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        _loadingText!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  // Esconder carregamento
  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _loadingText = null;
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
class CaixaProgresso extends StatelessWidget {
  final DateTime prazoData;
  final int paginasLivro;
  final int paginasLidas;
  final bool livroAtual; 

  const CaixaProgresso({
    super.key,
    required this.prazoData,
    required this.paginasLivro,
    required this.paginasLidas,
    required this.livroAtual,    
  });

  int obterPrazo(DateTime prazoInicial) {
    DateTime dataAtual = DateTime.now();
    Duration resultado = prazoInicial.difference(dataAtual);
    return resultado.inDays;
  }

  @override
  Widget build(BuildContext context) {
    final double largura = MediaQuery.of(context).size.width * 0.9;
    final double altura = largura * 0.4;
    final double margem = largura * 0.03;

    if (livroAtual) {

    int paginasRestantes = paginasLivro - paginasLidas;
    double porcentagemLeitura = (paginasLidas / paginasLivro);
    final int prazo = obterPrazo(prazoData);

    return Center(
      //caixa
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
            // imagem da capa
            Container(
              margin: EdgeInsets.symmetric(horizontal: margem),
              color: Colors.green,
              width: altura / 1.8,
              height: altura * 0.8,
              /*
              decoration: const BoxDecoration(
                // detalhes da imagem da capa
              ),
              */
            ),
            //demais elementos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //linha 1
                  Row(
                    children: [
                      //barra de progresso
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Progresso",
                              style: TextStyle(
                                fontSize: largura * 0.04,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                minHeight: altura * 0.08,
                                backgroundColor:
                                    Colors.grey[300], //cor barra vazia
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF48a0d4), //cor barra cheia
                                ),
                                value:
                                    porcentagemLeitura, //porcentagem da barra
                              ),
                            ),
                            //dados da leitura
                            SizedBox(height: margem),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Color(0xFF48a0d4),
                                          ),
                                          SizedBox(width: margem * 0.5),
                                          Flexible(
                                            child: Text(
                                              "Leu: $paginasLidas página${paginasLidas != 1 ? 's' : ''}",
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: largura * 0.03,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                             "Resta${paginasRestantes != 1 ? 'm' : ''}: $paginasRestantes página${paginasRestantes != 1 ? 's' : ''}",
                                              softWrap: true,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: largura * 0.03,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: margem * 0.5),
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.grey[300],
                                          ),
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
                      // prazo
                      SizedBox(
                        width: largura * 0.3,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: margem),
                          child: Column(
                            children: [
                              const Icon(Icons.access_alarm),
                              SizedBox(height: margem * 0.5),
                              Text(
                                "Resta${prazo !=1 ? 'm': ''} $prazo dia${prazo !=1 ? 's': ''} para concluir a meta!",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: largura * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //linha 2
                  SizedBox(height: margem/2),
                  BotaoGradiente(
                    texto: "Retomar",
                    largura: largura * 0.3,
                    //altura: largura * 0.3,
                    onPressed: () {
                      // rota para a tela de leitura
                    },
                  ),
                  SizedBox(height: margem/2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
   } else {
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
                          bool possuiGenero = dadosBasicosUser('generos').isNotEmpty;
                          if (possuiGenero) {
                            // ignore: avoid_print
                            print('usuario tem generos');                            
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(builder: (context) => const SelecaoRoteiroRandom()),  
                            );                            
                          } else {
                            Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(builder: (context) => const SelecaoGenero()),
                          );
                          }                          
                        },
                        largura: largura * 0.5,
                        //altura: largura * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

//apresentacao dos dados do jogador

class ResumoUser extends StatelessWidget {
  final int nivel = dadosUser['nivel'];    
  final int pontos = dadosUser['pontos'];   
  final int livros = dadosLivrosLidos.length;
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
  final double valor; 
  final String? anotacao;

  const Medidor({
    super.key,
    required this.valor,
    this.anotacao,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                value: valor,
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