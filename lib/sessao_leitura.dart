// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'dart:async';
import 'funcoes.dart';
import 'componentes.dart';

PopAviso aviso = PopAviso();

class SessaoLeitura extends StatefulWidget {

  const SessaoLeitura({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SessaoLeituraState createState() => _SessaoLeituraState();

}

class _SessaoLeituraState extends State<SessaoLeitura> {

  int paginasLivro = 10;
  int paginasLidas = 5;  
  bool estadoBotao = false;
  final GlobalKey<FormState> _paginaFormKey = GlobalKey<FormState>();
  final TextEditingController _paginaController = TextEditingController(); 

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
                              dadosLivroAtual['titulo'],
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
                const Cronometro(),     
                SizedBox(height: margem * 5),
                BotaoGradiente(tamanhoFonte: 20, texto: 'Encerrar', largura: MediaQuery.of(context).size.height * 0.2,
                  onPressed: () {                    
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
                                    Container(                                      
                                      //width: MediaQuery.of(context).size.width * 0.2,
                                      child: Form(
                                        key: _paginaFormKey,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        child: TextFormField(                                      
                                          controller: _paginaController,
                                          textAlign: TextAlign.center,
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
                                    ),                                    
                                    SizedBox(height: margem * 1),
                                    BotaoGradiente(
                                      largura: MediaQuery.of(context).size.width * 0.4,
                                      altura: largura * 0.15,
                                      texto: 'Confirmar',                                                                             
                                      onPressed: () {
                                        //salvar a ultima pagina lida
                                        if (estadoBotao = true) {
                                          
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
            ),
          ),
        ],
      ),
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
    );//Text(rodando ? "Pause" : "Start"),       
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