// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'dart:async';
import 'funcoes.dart';
import 'componentes.dart';
import 'package:ionicons/ionicons.dart';
import 'principal.dart';

PopAviso aviso = PopAviso();

class SessaoLeitura extends StatefulWidget {

  const SessaoLeitura({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SessaoLeituraState createState() => _SessaoLeituraState();

}

class _SessaoLeituraState extends State<SessaoLeitura> {

  int paginasLivro = 100;
  int paginasLidas = 9;  
  bool estadoBotao = false;
  final GlobalKey<FormState> _paginaFormKey = GlobalKey<FormState>();
  final TextEditingController _paginaController = TextEditingController();
  final GlobalKey<_CronometroState> _cronometroKey = GlobalKey<_CronometroState>();

  @override
  Widget build(BuildContext context) {    
    final double largura = MediaQuery.of(context).size.width * 0.8; 
    final double altura = largura * 0.4;    
    double margem = MediaQuery.of(context).size.width * 0.03;
    int paginasRestantes = paginasLivro - paginasLidas;
    return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus(); // Desfoca os campos de texto
    },
    child: Scaffold(
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body:  Stack(
        children: [
          SingleChildScrollView( 
            child: Column(
              children: [                
                Container(
                  width: largura,
                  height: largura * 0.4,                  
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
                  child: Row (
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // imagem da capa
                      Container(
                        margin: EdgeInsets.only(left: margem),
                        color: Colors.green,
                        width: altura / 1.8,
                        height: altura * 0.8,
                        /*
                        decoration: const BoxDecoration(
                          // detalhes da imagem da capa
                        ),
                        */
                      ),
                      Expanded(
                        child: Column (                        
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Você está lendo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,                                
                              ),
                            ),
                            Text(                              
                              dadosLivroAtual['titulo'] ?? 'Título',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,                                
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), 
                SizedBox(height: margem * 1.5), 
                Center(                  
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: Row(
                      children: [
                        //barra de progresso
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Progresso",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: margem),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  minHeight: MediaQuery.of(context).size.width * 0.05,
                                  backgroundColor: Colors.grey[300], //cor barra vazia
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF48a0d4), //cor barra cheia
                                  ),
                                  value: (paginasLidas/paginasLivro), //porcentagem da barra
                                ),
                              ),
                              //dados da leitura
                              SizedBox(height: margem),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: Color(0xFF48a0d4),
                                        ),
                                        SizedBox(width: margem * 0.5),
                                        Expanded(
                                          child: Text(
                                            "Leu: $paginasLidas página${paginasLidas != 1 ? 's' : ''}",
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: largura * 0.045,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: margem * 2), // Espaço entre os textos
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Resta${paginasRestantes != 1 ? 'm' : ''}: $paginasRestantes página${paginasRestantes != 1 ? 's' : ''}",
                                            softWrap: true,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: largura * 0.045,
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),                      
                      ],
                    ),
                  ),
                ),
                SizedBox(height: margem * 2),
                Cronometro(key: _cronometroKey),                   
                SizedBox(height: margem * 5),
                BotaoGradiente(tamanhoFonte: 20, texto: 'Encerrar', largura: MediaQuery.of(context).size.height * 0.2,                  
                  onPressed: () {    
                    if (_cronometroKey.currentState!.tempoPassado()) {                
                      aviso.aviso('Encerrar','Tem certeza que dejesa encerrar a sessão de leitura?', textoBotao: 'Encerrar', cancelar: true,
                        okPressed: () {                      
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {                            
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(margem),
                                content: Container(
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.of(context).size.height * 0.23,
                                    maxHeight: MediaQuery.of(context).size.height * 0.23,
                                    minWidth: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.1,
                                    ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Em qual página você parou?'
                                      ),
                                      SizedBox(height: margem),
                                      Form(
                                        key: _paginaFormKey,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        child: TextFormField(                                      
                                          controller: _paginaController,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(                                        
                                            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                            border: OutlineInputBorder(),
                                            hintText: 'Página',
                                          ),                                          
                                          validator: (value) {                                                                                      
                                            int? numero = int.tryParse(value ?? '');
                                            if (numero == null) {
                                                estadoBotao = false;
                                                return 'Por favor, insira um número válido.';
                                            } else if (numero <= paginasLidas) {
                                                estadoBotao = false;
                                                return 'Você leu até a página $paginasLidas antes.';
                                            } else if (numero > paginasLivro) {                                              
                                                estadoBotao = false;
                                                return 'Este livro só tem $paginasLivro páginas.';
                                            } else { 
                                                estadoBotao = true;
                                                return null;                                                                                                                            
                                            }
                                          },                                           
                                        ),
                                      ),                                    
                                      SizedBox(height: margem * 1),
                                      BotaoGradiente(
                                        largura: MediaQuery.of(context).size.width * 0.4,
                                        altura: largura * 0.15,
                                        texto: 'Confirmar',                                                                             
                                        onPressed: () {                                        
                                          bool botaoEstado = estadoBotao;
                                          if (botaoEstado) {
                                            int ultimaPaginaLida = int.parse(_paginaController.text);
                                            int paginasLidasSessao = (ultimaPaginaLida - paginasLidas);
                                            int tempoGasto = _cronometroKey.currentState!.tempoPassadoEmMinutos();
                                            //atualizar o progresso
                                            dadosLivroAtual['ultima_pagina_lida'] = ultimaPaginaLida;
                                            dadosLivroAtual['data_da_ultima_leitura'] = DateTime.now().toIso8601String();
                                            dadosLivroAtual['pagina_totais_lidas'] += paginasLidasSessao;
                                            dadosLivroAtual['tempo_gasto'] += tempoGasto;                                            
                                            //ir para o resumo                                           
                                            Navigator.pushReplacement(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              MaterialPageRoute(builder: (context) => FimSessaoLeitura(paginas: paginasLidasSessao, tempo: tempoGasto)),
                                            );
                                          }
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          );
                        }
                      );
                    }
                  },
                ),
              ],              
            ),              
          ),
          // Retângulo inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnuncioExemplo(altura: MediaQuery.of(context).size.height * 0.1),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF48a0d4), Color(0xFF93dded)],
                    ),
                  ),
                ),
              ],
            ),/////
          ),
        ],
      ),
    ),
    );
  }   
}

class FimSessaoLeitura extends StatefulWidget {
  final int tempo;
  final int paginas;

  const FimSessaoLeitura({
    required this.tempo,
    required this.paginas,
    super.key    
  });

  @override
  // ignore: library_private_types_in_public_api
  _FimSessaoLeituraState createState() => _FimSessaoLeituraState();

}

class _FimSessaoLeituraState extends State<FimSessaoLeitura> { 

  @override
  Widget build(BuildContext context) {    
    final double largura = MediaQuery.of(context).size.width * 0.9; 
    final double altura = MediaQuery.of(context).size.height * 0.75;    
    double margem = MediaQuery.of(context).size.width * 0.05;
    final int tempo = widget.tempo;
    final int paginas = widget.paginas;
    return Scaffold(
      appBar: CustomAppBar.build(context),
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body:  Stack(
        children: [          
          SingleChildScrollView(             
            child: Center(
              child: Container (
                alignment: Alignment.center,
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
                child: Column(
                  children: [
                    SizedBox(height: margem * 2),
                    const Text.rich(
                      TextSpan(
                        text: 'Sessão de Leitura\n',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFF48a0d4),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Finalizada!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: EdgeInsets.all(margem),
                      color: Colors.green,
                      width: largura * 0.35,
                      height: altura * 0.3,
                      /*
                      decoration: const BoxDecoration(
                        // detalhes da imagem da capa
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(-2, 5),
                          ),
                        ],
                      ),
                      */
                    ),
                    Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: altura * 0.1,
                                color: const Color(0xFF48a0d4), // Defina o tamanho desejado
                              ),
                              Text(
                                tempo.toString(), 
                                style: TextStyle(
                                  fontSize: altura * 0.05,
                                ),
                              ),
                              Text(
                               'Minutos', 
                                style: TextStyle(
                                  fontSize: altura * 0.04,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [                              
                              Icon(
                                Ionicons.book_outline,
                                size: altura * 0.1,
                                color: const Color(0xFF48a0d4),
                              ),
                              Text(
                               paginas.toString(), 
                                style: TextStyle(
                                  fontSize: altura * 0.05,
                                ),
                              ),
                              Text(
                               'Páginas', 
                                style: TextStyle(
                                  fontSize: altura * 0.04,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),  
                    SizedBox(height: margem * 2),
                    BotaoGradiente(
                      largura: largura * 0.3,
                      altura: altura * 0.08,
                      tamanhoFonte: altura * 0.035,
                      texto: 'Ok',
                      onPressed: () {
                        Navigator.pushReplacement( // Substitui a página atual pela página principal
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(builder: (context) => const Principal()),
                        );
                      },                      
                    ),                     
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
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

class Cronometro extends StatefulWidget {
  const Cronometro({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _CronometroState createState() => _CronometroState();
}

class _CronometroState extends State<Cronometro> {
  late Stopwatch parar;
  late Timer temporizador;
  bool rodando = false;

  int tempoPassadoEmMinutos() {    
    return parar.elapsed.inMinutes;
  }
   bool tempoPassado() {    
    if (parar.elapsed.inSeconds > 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    parar = Stopwatch();
    temporizador = Timer.periodic(const Duration(milliseconds: 100), atualizarCronometro);
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle timerTextStyle = TextStyle(fontSize: 60.0, fontFamily: "Open Sans");
    String formattedTime = formatarTempo(parar.elapsed);
    return Column(
      children: [
        Text(formattedTime, style: timerTextStyle),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        BotaoGradiente(
          icone: Icon(rodando ? Icons.pause : Icons.play_arrow, color: Colors.white),         
          largura: MediaQuery.of(context).size.width * 0.3,
          ligado: true,
          onPressed: () {
            setState(() {
              rodando = !rodando;
              if (rodando) {
                parar.start();
              } else {
                parar.stop();
              }
            });
          },
        ),        
      ],
    );      
  }

  void atualizarCronometro(Timer timer) {
    if (rodando) {
      setState(() {});
    }
  }

  String formatarTempo(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    temporizador.cancel();
    super.dispose();
  }
}