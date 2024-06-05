import 'package:flutter/material.dart';

//app bar ------------------------------------------
class CustomAppBar {
  static AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Color(0xFF48a0d4),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          // menu suspenso
        },
      ),
      title: Image.asset(
        'assets/imagens/booki.png',
        height: 60,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: () {
            // ajuda
          },
        ),
      ],
      titleTextStyle: const TextStyle(
        color: Color(0xFF48a0d4),
        fontSize: 20.0,
      ),
    );
  }
}

// tela de carregamento simples ------------------------------------------
class LoadingOverlay {
  // ignore: unused_field
  late BuildContext _context;
  late OverlayEntry _overlayEntry;

  void show(BuildContext context) {
    _context = context;
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
    Overlay.of(context).insert(_overlayEntry);
  }

  void hide() {
    _overlayEntry.remove();
  }
}

//botao do tema ------------------------------------------
class BotaoGradiente extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final double largura;

  const BotaoGradiente({
    Key? key,
    required this.texto,
    required this.onPressed,
    required this.largura,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: largura * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF48a0d4), Color(0xFF93dded)],
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
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// caixa de progresso ------------------------------------------
/* Exemplo do construtor da CaixaProgresso:
 * CaixaProgresso(
 *  paginasLidas:10,
 *  paginasLivro:100,
 *  prazoData: DateTime(2024, 6, 30),
 * ),
 *  Esses valores devem ser recuperados do backend
 * */
class CaixaProgresso extends StatelessWidget {
    final DateTime prazoData;
    final int paginasLivro;    
    final int paginasLidas;
  
  const CaixaProgresso({
    Key? key,
    required this.prazoData,
    required this.paginasLivro,
    required this.paginasLidas,    
    }) : super(key: key);
  
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
    
    int paginasRestantes = paginasLivro-paginasLidas;
    double porcentagemLeitura = (paginasLidas/paginasLivro);
    final int prazo = obterPrazo(prazoData);    
    
    String plural(int valor, String tipo) {
      if (valor == 1) {
        return '';
      } else {
        return tipo;
      }     
    };      

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
                                          Icon(Icons.circle,
                                            size: 8,
                                            color: Color(0xFF48a0d4),
                                          ),
                                          SizedBox(width: margem * 0.5),
                                          Flexible(
                                            child: Text(
                                              "Leu: $paginasLidas página"+plural(paginasLidas,'s'),
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
                                              "Resta"+plural(paginasRestantes,'m')+": $paginasRestantes página"+plural(paginasRestantes,'s'),
                                              softWrap: true,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: largura * 0.03,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: margem * 0.5),
                                          Icon(Icons.circle,
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
                                "Resta"+plural(prazo,'m')+" $prazo dia"+plural(prazo,'s')+" para concluir a meta!",
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
                  SizedBox(height: margem),
                  BotaoGradiente(
                    texto: "Retomar",
                    largura: largura * 0.25,
                    onPressed: () {
                      // rota para a tela de leitura
                    },
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
