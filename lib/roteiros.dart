import 'package:flutter/material.dart';
import 'componentes.dart';
import 'funcoes.dart';
//import './widgets/menu_lateral.dart';

LoadingOverlay carregamento = LoadingOverlay();

class SelecaoGenero extends StatefulWidget {
  // ignore: use_super_parameters
  const SelecaoGenero({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
    //lista de generos    
    final Map<String, String> generoTermos = {      
      'Ficção': 'fiction',
      'Fantasia': 'fantasy',
      'Mistério': 'mystery',
      'Romance': 'romance',
      'Terror': 'terror',
      'Aventura': 'adventure',
      'Drama': 'drama',
      'Ficção Científica': 'science fiction',
      'Comédia': 'comedy',
      'Poesia': 'poetry',
      'Clássico': 'classical',
      'Policial': 'police',
      'Histórico': 'historic',
      'Biografia': 'biography',
      'Religião': 'religion',
      'Infanto-Juvenil': 'juvenile',
      // Adicione os demais gêneros aqui...
    };
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
                'Do que você gosta, ${dadosBasicosUser('nome').isNotEmpty == true ? dadosBasicosUser('nome') : 'leitor(a)'}?',
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
                spacing: MediaQuery.of(context).size.height * 0.01,
                children: generoTermos.entries.map((entry) {
                  return TextoSelectBox(
                    texto: entry.key,
                    termo: entry.value,
                    onSelected: generosSelect,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            BotaoGradiente(texto: 'Confirmar',
            onPressed: () async {              
              bool sucesso = await adicionarGenero(context, dadosBasicosUser('id'),'genero');
              if (sucesso) {                
                // ignore: use_build_context_synchronously
                Navigator.pop(context);              
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
