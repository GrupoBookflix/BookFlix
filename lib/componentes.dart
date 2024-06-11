import 'package:bookflix/roteiros.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'funcoes.dart';
import 'package:flutter/services.dart';
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
        'assets/images/booki.png',
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
  final String titulo;
  final String rotaItem;

  ItemMenu(this.titulo, this.rotaItem);
}

//menu suspenso ------------------------------------------

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
           DrawerHeader(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
               border: const Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 59, 160, 207)) ,
                ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,  // Tamanho do círculo
                  backgroundImage: AssetImage('assets/images/user.png'),                 
                ),
                const SizedBox(height: 10),  // Espaçamento entre a imagem e o texto
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
          //...buildMenuItems(context),
          ListTile(
            title: const Text('Início',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Fecha o menu lateral
              Navigator.pushNamed(context, '/home'); //fechar o aplicativo
            },
          ),
          ListTile(
            title: const Text('Conta', textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Fecha o menu lateral
              Navigator.pushNamed(context, '/conta'); 
            }
          ),
          ListTile(
            title: const Text('Alterar Roteiro', textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/alterarRoteiro');
            },
          ),
          ListTile(
            title: const Text('Histórico de Leitura',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/historico');
            },
          ),
         
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          ListTile(
            title: const Text('Mudar de Conta',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
               Navigator.pop(context); // Fecha o menu lateral
              Navigator.pushNamed(context, '/login'); 
            },
          ),
          ListTile(
            title: const Text('Sair',textAlign: TextAlign.center,  style: TextStyle(color: Colors.white)),
            onTap: () {
             SystemNavigator.pop(); // Sai do aplicativo //fechar o aplicativo
            },
          ),
          
          const Divider( // Adiciona uma linha
            color: Color.fromARGB(255, 59, 160, 207), // Cor da linha
            thickness: 2, // Espessura da linha
          ),
        ],
      ),
    );
  }

/*
  // Método para construir as opções do menu
  List<Widget> buildMenuItems(BuildContext context) {
    List<ItemMenu> menuItems = [
      ItemMenu('Home', '/'),
      //adicionar outras rotas
    ];

    return menuItems.map((item) {
      return ListTile(
        title: Text(item.titulo),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(item.rotaItem);
        },
      );
    }).toList();
  }
*/
}

// pop aviso suspenso ------------------------------------------
class PopAviso  {  
 
  void aviso(String titulo, String mensagem) {   
    showDialog<void>(
      context: getAppContext()!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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

// tela de carregamento simples ------------------------------------------
class LoadingOverlay {
  // ignore: unused_field 
  late OverlayEntry? _overlayEntry;

  //mostrar carregamento
  void show(BuildContext context) {
    context = getAppContext()!;
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Stack(
        children: <Widget>[
          ModalBarrier(
            color: Colors.white.withOpacity(0.5),
            dismissible: false,
          ),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF48a0d4)),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }
  //esconder carregamento
  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

//botao do tema ------------------------------------------
class BotaoGradiente extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final double largura;  
  final bool ligado;

  const BotaoGradiente({
    super.key,
    required this.texto,
    required this.onPressed,
    required this.largura,       
    this.ligado = true,       
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: largura * 0.35,
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
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
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

    String plural(int valor, String tipo) {
      if (valor == 1) {
        return '';
      } else {
        return tipo;
      }
    }

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
                                              "Leu: $paginasLidas página${plural(paginasLidas, 's')}",
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
                                              "Resta${plural(paginasRestantes, 'm')}: $paginasRestantes página${plural(paginasRestantes, 's')}",
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
                                "Resta${plural(prazo, 'm')} $prazo dia${plural(prazo, 's')} para concluir a meta!",
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
                            /*
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(builder: (context) => Roteiros()),  
                            );
                            */
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