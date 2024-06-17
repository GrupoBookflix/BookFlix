// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'dart:async';
import 'widgets/funcoes.dart';
import 'widgets/componentes.dart';
import 'package:ionicons/ionicons.dart';
import 'rotas.dart';

class SessaoLeitura extends StatefulWidget {

  const SessaoLeitura({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SessaoLeituraState createState() => _SessaoLeituraState();
}

void atualizaSessaoAnterior(int pagina) {
  livroAtual['ultima_pagina_sessao_anterior'] = pagina;  
}

class _SessaoLeituraState extends State<SessaoLeitura> {
  int paginasLivro = livroAtual['paginas'];
  int paginasLidas = livroAtual['ultima_pagina_lida'];   
  String idImagemLivro = livroAtual['imagemId'];  
  bool estadoBotao = false;
  final GlobalKey<FormState> _paginaFormKey = GlobalKey<FormState>();
  final TextEditingController _paginaController = TextEditingController();
  final GlobalKey<_CronometroState> _cronometroKey = GlobalKey<_CronometroState>();

  void verificaPagina() {
    showDialog(
      context: getAppContext()!,
      builder: (BuildContext context) {    
        double margem = MediaQuery.of(context).size.width * 0.03;   
        final double largura = MediaQuery.of(context).size.width * 0.8;                      
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
                      } else if (numero <= paginasLidas && paginasLidas == 0) {
                          estadoBotao = false;
                          return 'Encerre a sessão se não tiver lido.';
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
                  onPressed: () async {                                        
                    bool botaoEstado = estadoBotao;
                    if (botaoEstado) {
                      int ultimaPaginaLida = int.parse(_paginaController.text);
                      int paginasLidasSessao = (ultimaPaginaLida - paginasLidas);
                      int tempoGasto = _cronometroKey.currentState!.tempoPassadoEmMinutos();
                      int totalPaginasLidas;
                      
                      // atualizar o progresso
                      livroAtual['ultima_pagina_lida'] = ultimaPaginaLida;
                      livroAtual['data_da_ultima_leitura'] = DateTime.now();

                      // Verifica se livroAtual['pagina_totais_lidas'] é null ou não existe
                      if (livroAtual['pagina_totais_lidas'] == null) {
                        livroAtual['pagina_totais_lidas'] = paginasLidasSessao.toString();
                        totalPaginasLidas = ultimaPaginaLida;
                      } else {
                        // Converte para int antes de somar
                        totalPaginasLidas = int.parse(livroAtual['pagina_totais_lidas']!) + paginasLidasSessao;
                        livroAtual['pagina_totais_lidas'] = (totalPaginasLidas + paginasLidasSessao).toString();
                      }                     
                      // Verifica se livroAtual['tempo_gasto'] é null ou não existe
                      if (livroAtual['tempo_gasto'] == null) {
                        livroAtual['tempo_gasto'] = tempoGasto;
                      } else {
                        // Converte para int antes de somar
                        int tempoGastoAtual = livroAtual['tempo_gasto'];
                        livroAtual['tempo_gasto'] = tempoGastoAtual + tempoGasto;
                      }       
                      atualizaSessaoAnterior(ultimaPaginaLida);                                       
                      bool resultado = await atualizarProgresso(
                        concluindo: (ultimaPaginaLida == paginasLivro),
                        dataUltimaLeitura: livroAtual['data_da_ultima_leitura'],
                        ultimaPaginaLida: ultimaPaginaLida,
                        tempoGasto: tempoGasto,
                        totalPaginasLidas: totalPaginasLidas,
                      );                                                                                               
                      //ir para o resumo  
                      if (resultado) {
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(builder: (context) => FimSessaoLeitura(paginas: paginasLidasSessao, tempo: tempoGasto, idImagemLivro: livroAtual['imagemId'])),
                        );
                      } else {
                        PopAviso aviso = PopAviso();
                        aviso.aviso('Erro', 'Não foi possível atualizar seu progresso. Tente novamente mais tarde');
                      }                               
  
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

  @override
  Widget build(BuildContext context) {      
    final double largura = MediaQuery.of(context).size.width * 0.8; 
    final double altura = largura * 0.4;    
    double margem = MediaQuery.of(context).size.width * 0.03;
    int paginasRestantes = paginasLivro - paginasLidas;
    setAppContext(context);
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
                        margin: EdgeInsets.symmetric(horizontal: margem),
                        child: 
                        GestureDetector(
                          child: CapaLivro(
                            imageId: idImagemLivro,                              
                            tamanhoCapa: altura / 1.8,                       
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
                                    child: const AbaDadosLivro(),
                                  ),
                                );
                              },
                            );      
                          },
                        ),
                      ),
                      Expanded(
                        child: Column (                        
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Column (
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Você está lendo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.width * 0.25, // Define a largura máxima permitida
                                      ),
                                      child: Text(
                                        livroAtual['titulo'] ?? 'Título',
                                        textAlign: TextAlign.center,
                                        maxLines: 3, // Defina o número máximo de linhas desejado
                                        overflow: TextOverflow.ellipsis, // Adicione ellipsis se o texto for cortado
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF48a0d4),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
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
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Resta${paginasRestantes != 1 ? 'm' : ''}: $paginasRestantes página${paginasRestantes != 1 ? 's' : ''}",
                                            softWrap: false,
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
                      verificaPagina();   
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
  final String idImagemLivro;

  const FimSessaoLeitura({
    required this.tempo,
    required this.paginas,
    required this.idImagemLivro,
    super.key    
  });

  @override
  // ignore: library_private_types_in_public_api
  _FimSessaoLeituraState createState() => _FimSessaoLeituraState();

}

class _FimSessaoLeituraState extends State<FimSessaoLeitura> { 

  @override
  Widget build(BuildContext context) {   
    setAppContext(context); 
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
                    SizedBox(height: margem * 1.5),
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
                      decoration: BoxDecoration(
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
                      child: CapaLivro(
                        imageId: widget.idImagemLivro,                              
                        tamanhoCapa: altura * 0.25,                       
                      ),                      
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
                    SizedBox(height: margem),
                    BotaoGradiente(
                      largura: largura * 0.3,
                      altura: altura * 0.08,
                      tamanhoFonte: altura * 0.035,
                      texto: 'Ok',
                      onPressed: () async {
                        await recolherDados(dadosUser['id']);
                        Navigator.of(getAppContext()!).pushReplacementNamed(Rotas.principal);
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

class AbaDadosLivro extends StatefulWidget {

  const AbaDadosLivro({
    super.key,
  });

  @override  
  // ignore: library_private_types_in_public_api
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
                          text: livroAtual['titulo'],
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
                      imageId: livroAtual['imagemId'],
                      tamanhoCapa: MediaQuery.of(context).size.width * 0.5
                    ),
                    ),
                    Text(
                      livroAtual['autor'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.055,
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