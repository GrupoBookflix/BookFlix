// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'componentes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/livro.dart';

/*
O objetivo deste arquivo é manter as lógicas por trás da manipulação de dados obtidos a partir de requisições ao backend;
Não serão implementadas rotas aqui, então favor consultar este contexto no repositório do BackEnd deste projeto;
Apesar disso as rotas serão usadas para facilitar a implementação.
*/

//variavel e funcoes para receber dados do contexto que é passado para a construção abstrata de widgets
BuildContext? appContext;
void setAppContext(BuildContext context) {
  appContext = context;
}
BuildContext? getAppContext() {
  return appContext;
}

//url do backend > funcoes devem iterar as rotas após a última '/'
const String apiUrl = 'https://backend-8wht.onrender.com';

//variavel temporaria para armazenar dados do usuario
Map<String, dynamic> dadosUser = {};
//variavel temporaria para armazenar dados de livros exibidos
Map<String, dynamic> dadosLivro = {};
//variavel temporaria para armazenar livros ja lidos pelo usuario
Map<String, dynamic> dadosLivrosLidos = {};
//variavel temporaria para armazenar dados do livro atual do roteiro
Map<String, dynamic> livroAtual = {};
//variavel temporaria para criacao de roteiros
List<String> livrosRoteiro = [];

//funcoes basicas ----------------------------------------

//para dados do usuario, tamanho minimo
String? dadoMinimo(String dado, String nomeCampo) {
  if (dado.length < 3) {
    return 'Informe um $nomeCampo válido';
  } else {
    return null;
  }
}

//impede char que não é 'letra', 'número', 'espaço', '@', '.', e '_'
String sanitizaEntrada(String input) {
  return input.replaceAll(RegExp(r'[^\w\s@._]'), '');
}

//valida o email para aceitar apenas o formato correto
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email é obrigatório';
  }
  // não usar '\' na expressão
  RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
  final bool isEmailValid = emailRegex.hasMatch(email);
  if (!isEmailValid) {
    return 'Informe um email válido';
  }
  return null;
}

//valida senhas para impedir SQL injection
//Atenção: isso não substitui a verificação do hash no backend!
String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'A senha é obrigatória';
  } else if (password.contains(RegExp(r"[\'\\\;\,\)\(\<\>\=\*]")) ||
      password.contains(RegExp(r'[\"\\\;\,\)\(\<\>\=\*]'))) {
    return 'Não use caracteres inválidos: " ; , ) ( < > = *';
  } else if (password.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  } else {
    return null;
  }
}

//recolher dados backend ----------------------------------------

//recolhe dados basicos do usuario do back end
Future<void> recolherDados(int userId) async { 
  print('FUNÇÃO RECOLHER DADOS');
  //na operacao de login essa funcao e chamada
  //caso seja necessario atualizar as informacoes esta funcao é usada
  final response = await http.get(
    Uri.parse('$apiUrl/usuario/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {  
    //dados do usuario    
    dadosUser.clear();
    final responseData = jsonDecode(response.body);
    final usuario = responseData['usuario'];
    final id = int.parse(responseData['id']);  
    dadosUser['id'] = id;  

    usuario.forEach((key, value) {            
      dadosUser[key] = value;      
      if (key == 'generos' && value != null) {    
        final List<String> generosUsuario = List<String>.from(usuario['generos']);
        dadosUser['generos'] = generosUsuario;
      }
    });
    
    //dados dos livros lidos
    dadosLivrosLidos.clear();
    dadosLivrosLidos = {
      'livros_lidos': List<Map<String, dynamic>>.from(usuario['livros_lidos']),
    };   
    print('DADOS DOS LIVROS LIDOS: $dadosLivrosLidos');
    
    //dados do livro atual
    if (usuario['progresso'] != null) {
        livroAtual = {
          'livro_atual': usuario['progresso']['livro_atual'],
          'data_inicio': usuario['progresso']['data_inicio'],
          'dias_prazo': usuario['progresso']['dias_prazo'],
          'data_prazo': usuario['progresso']['data_prazo'],
          'data_ultima_leitura': usuario['progresso']['data_ultima_leitura'],
          'ultima_pagina_lida': usuario['progresso']['ultima_pagina_lida'],
          'tempo_gasto': usuario['progresso']['tempo_gasto'],
          'total_paginas_lidas': usuario['progresso']['total_paginas_lidas'],
        };      
    } else {
        livroAtual.clear(); //se nao houver livro atual do roteiro
    }

    //livros do roteiro
    livrosRoteiro = List<String>.from(usuario['livros_roteiro'].map((livro) => livro['isbn']));
  
  } else {
    print("falha ao recolher os dados do servidor");
    //falha
    //chamar PopAViso
    throw Exception('Falha ao carregar dados do usuário');
  } 
}

// converte string ISO 8601 para objeto Date
DateTime? parseDataString(String? dateString) {
  if (dateString == null) return null;
  return DateTime.tryParse(dateString);
}

//enviar dados backend ----------------------------------------

//registrar usuario: Acho melhor que esta funcao fique em cadastro e login
Future<bool> registraUsuario(
    BuildContext context, String nome, String email, String senha) async {
  
  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Por favor, aguarde');
  carregamento.show(context);

  nome = sanitizaEntrada(nome);
  email = sanitizaEntrada(email);

  final response = await http.post(
    Uri.parse('$apiUrl/usuario'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
      'nivel': 1, //pois o usuario comeca no nivel 1
      'pontos': 0,
      'livro_atual': null,
      'data_criacao': DateTime.now().toIso8601String(),
    }),
  );
  
  PopAviso aviso = PopAviso();

  if (response.statusCode == 200 || response.statusCode == 201) {
    // sucesso
    carregamento.hide();    
    aviso.aviso('Sucesso', 'Usuário cadastrado com sucesso!');
    return true;
  } else if (response.statusCode == 400) {
    // falha
    carregamento.hide();
    //chamar a funcao de mostrar dialogo
    aviso.aviso('Erro', 'Já existe usuário com este email!');
    return false;
  } else {
    // falha servidor
    carregamento.hide();
    //chamar a funcao de mostrar dialogo
    aviso.aviso('Erro', 'Ocorreu um erro. Por favor tente novamente');
    return false;
  }
}

//atualizar dado do usuario
Future<bool> atualizaUsuario(
  BuildContext context, {
  String? nome,
  String? email,
  String? senha,
  String? novaSenha,
  int? nivel,
  int? pontos,
  String? livroAtual,
  bool? mostrar,
}) async {  
  final String id = dadosUser['id'].toString(); // Certifique-se de que o ID seja uma string

  print('FUNÇÃO ATUALIZAR USUÁRIO');
  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Atualizando seus dados');
  carregamento.show(context);

  // Sanitizar entradas
  nome = nome != null ? sanitizaEntrada(nome) : null;
  email = email != null ? sanitizaEntrada(email) : null;
  senha = senha != null ? validatePassword(senha) : null;
  novaSenha = novaSenha != null ? validatePassword(novaSenha) : null;

  // Corpo da requisição
  Map<String, dynamic> body = {};
  if (nome != null) body['nome'] = nome;
  if (email != null) body['email'] = email;
  if (senha != null) body['senha'] = senha;
  if (novaSenha != null) body['novaSenha'] = senha;
  if (nivel != null) body['nivel'] = nivel;
  if (pontos != null) body['pontos'] = pontos;
  if (livroAtual != null) body['livro_atual'] = livroAtual;

  try {
    final response = await http.put(
      Uri.parse('$apiUrl/usuario/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
   
    PopAviso aviso = PopAviso();

    if (response.statusCode == 200 || response.statusCode == 201) {      
      // Sucesso      
      if (mostrar != null && mostrar == true) {
        aviso.aviso('Sucesso', 'Seus dados foram atualizados');
      }
      await recolherDados(dadosUser['id']);
      carregamento.hide();
      return true;
    } else if (response.statusCode == 401) {
      carregamento.hide();
      if (mostrar != null && mostrar == true) {        
        aviso.aviso('Erro', 'Senha incorreta');
      }
      return false;
    } else if (response.statusCode == 404) {      
      // Usuário não encontrado
      carregamento.hide();
      if (mostrar != null && mostrar == true) {        
        aviso.aviso('Erro', 'Usuário não encontrado');
      }
      return false;
    } else {      
      // Falha no servidor
      carregamento.hide();
      if (mostrar != null && mostrar == true) {
        aviso.aviso('Erro', 'Ocorreu um erro inesperado. Por favor tente novamente');
      }
      return false;
    }
  } catch (error) {
    print('Erro ao atualizar usuário: $error');
    carregamento.hide();
    if (mostrar!) {
      PopAviso().aviso('Erro', 'Erro ao tentar atualizar usuário.');
    }
    return false;
  }
}

//definicao de generos literarios ----------------------------------------

//adicionar genero para o usuario
Future<bool> adicionarGenero(BuildContext context, userId, List<String> generos) async {
  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Carregando seus gêneros');
  carregamento.show(context);

  try {
    final response = await http.put(
      Uri.parse('$apiUrl/usuario/$userId/generos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'generos':generos}),
    );

    PopAviso aviso = PopAviso();   

    if (response.statusCode == 200) {
      carregamento.hide();
      return true;
      //concluir a definicao do genero
    } else if (response.statusCode == 400) {
      carregamento.hide();
      aviso.aviso('Erro', 'Devem ser escolhidos 3 gêneros');
      return false;
    } else {
      carregamento.hide();
      aviso.aviso('Erro','Ocorreu um erro inesperado. Por favor tente novamente mais tarde.');
      return false;
    }
  } catch (error) {    
    print('Erro: ao adicionar gênero: $error');
    return false;
  }
}

//remover um genero para o usuário
Future<void> removerGenero(BuildContext context, userId, String generoId) async {

  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Alterando suas preferências');
  carregamento.show(context);

  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/usuario/$userId/generos/$generoId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    PopAviso aviso = PopAviso();

    if (response.statusCode == 200) {
      carregamento.hide();
      //concluir a remoção do genero
    } else if (response.statusCode == 404) {
      carregamento.hide();
      aviso.aviso('Erro', 'Este gênero não consta nas preferências do usuário');
    } else {
      carregamento.hide();
      aviso.aviso('Erro','Ocorreu um erro inesperado. Por favor tente novamente mais tarde.');
    }
  } catch (error) {    
    print('Erro: ao adicionar gênero: $error');
  }
}

//login
Future<bool> loginUsuario(BuildContext context, String email, String senha) async {

  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Verificando seus dados');
  carregamento.show(context);

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {   
      final responseData = jsonDecode(response.body);
      final int idUsuario = responseData['usuarioId'];// obtem id do usuario
      dadosUser['id'] = idUsuario;

      // recolher demais dados do usuário
      await recolherDados(idUsuario);

      carregamento.hide();
      return true;

    } else if (response.statusCode == 404) {
      carregamento.hide();
      PopAviso().aviso('Erro', 'Usuário não encontrado');
      return false;
    } else if (response.statusCode == 401) {
     carregamento.hide();
      PopAviso().aviso('Erro', 'Credenciais inválidas');
      return false;
    } else {
      carregamento.hide();
      PopAviso().aviso('Erro', 'Erro inesperado. Por favor, tente novamente');
      return false;
    }
  } catch (error) {
    carregamento.hide();
    print('Erro ao fazer login: $error');
    PopAviso().aviso('Erro', 'Erro interno do aplicativo. Por favor, tente novamente');
    return false;
  }
}

//recolher dados API ----------------------------------------

Future<Livro> buscarPorGenero(String genero, List<String> livrosJaExibidos) async { 
  int limiteInicial = 10; //limite de resultados na busca da api
  int chamadas = 0; // quantidade de chamadas feitas na api
  bool pesquisa = false; //enquanto o livro não ter os dados essenciais, busque o próximo
  int indiceInicial = 0; //no inicio o loop de verificacao percorre todos os resultados

  while (!pesquisa) {  
    final int limiteAtual = limiteInicial + (chamadas * 5);
    final response = await http.get(Uri.parse(
      'https://openlibrary.org/search.json?subject=$genero&sort=rating&limit=$limiteAtual&fields=title,isbn,cover_i,author_name,publish_date,number_of_pages_median'
    ));

    if (response.statusCode == 200) {       
      chamadas++; //controla a quantidade de chamadas   
      final booksDataArray = json.decode(response.body)['docs'];
      
      if (booksDataArray != null && booksDataArray.isNotEmpty) {       
        for (var i = indiceInicial; i < booksDataArray.length; i++) { //so percorre o indice com novos resultados
          var book = booksDataArray[i];          

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
                genero: genero,
                autor: book['author_name'][0],
                ano: book['publish_date'][0],
                descricao: book['description'],
                paginas: book['number_of_pages_median'],              
              );                        
              pesquisa = true;
              return livro;
            }
          } 
        }
        indiceInicial = booksDataArray.length;
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

//recolher dados de livro especifico
Future<Map<String, dynamic>> buscarDadosLivro(String isbn) async {
  
  final response = await http.get(Uri.parse(
   'https://openlibrary.org/search.json?isbn=$isbn&sort=rating&limit=1fields=title,cover_i,author_name,publish_date,number_of_pages_median'
  ));

  if (response.statusCode == 200) {
    final bookData = json.decode(response.body);
    if (bookData != null && bookData['docs'] != null && bookData['docs'].isNotEmpty) {
      final bookInfo = bookData['docs'][0];      
      return {
        'isbn': isbn,
        'titulo': bookInfo['title'],
        'imagemId': bookInfo['cover_i'],
        'autor': bookInfo['author_name'],
        'data': bookInfo['publish_date'],
        'paginas': bookInfo['number_of_pages_median']
      };  
    } else {      
      throw Exception('Livro não encontrado');
    }  
  } else {   
    throw Exception('Falha ao buscar dados do livro');
  }
}

//funcoes para a logica do jogo ----------------------------------------

//atribuir pontos
Future<bool> aumentaPontos(BuildContext context, int pontos) async{  
  print('FUNÇÃO AUMENTAR PONTOS');
  dadosUser['pontos'] += pontos;
  aumentaNivel(context);
  bool resultado = await atualizaUsuario(
    getAppContext()!,
    nivel: dadosUser['nivel'],
    pontos: dadosUser['pontos']
  );
  if (resultado) {
  print('FUNÇÃO AUMENTAR PONTOS CONCLUÍDA COM SUCESSO');
  print('PONTOS CONCEDIDOS: $pontos');
  return true;
  } else {
    return false;
  }
}

//aumentar o nivel do jogador
void aumentaNivel(BuildContext context) {
  print('FUNÇÃO AUMENTAR NÍVEL');
  //a disposição do nível pode ser adequada no futuro
  const int base = 5;
  const double fator = 1.3;
  int nivelAtual = dadosUser['nivel'];
  int pontosAtuais = dadosUser['pontos'];
  int pontosNecessarios = (base * (nivelAtual * fator)).ceil();

  //para subir mais de um nível se o usuário ganhar vários pontos de uma vez
  while (pontosAtuais >= pontosNecessarios) {
    ++nivelAtual; 
    dadosUser['nivel'] = nivelAtual;
    pontosNecessarios = (base * (nivelAtual * fator)).ceil();
  }

  if (nivelAtual > dadosUser['nivel']) {   
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AvisoNivel(
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }  
}

//salva livro concluido pelo usuario ----------------------------------------------------------------
Future<bool> salvaLivroLido(BuildContext context, String isbn) async {  
  print('FUNÇÃO SALVAR LIVRO LIDO');
  final usuarioId = dadosUser['id'];
  final dataLeitura = DateTime.now();

  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Salvando sua conquista');
  carregamento.show(context);

  Map<String, dynamic> body = {
    'usuario_id': usuarioId,
    'isbn': isbn,
    'data_leitura': dataLeitura.toIso8601String(),
  };  

  int pontos = 0;
  int diasPrazo = livroAtual['dias_prazo']; 
  DateTime dataFinal = DateTime.parse(livroAtual['data_inicio']);      
  dataFinal = dataFinal.add(Duration(days: diasPrazo)); 
  DateTime dataInicial = DateTime.parse(livroAtual['data_inicio']); 

  print('DATA FINAL: $dataFinal, DATA INICIAL: $dataInicial, DIAS PRAZO: $diasPrazo');
  
  if (livroAtual['dias_prazo'] == 10) {
    print('PONTOS SERÁ 3');
    pontos = 3;
  } else if (livroAtual['dias_prazo'] == 20) {
    print('PONTOS SERÁ 2');
    pontos = 2;
  } else if (livroAtual['dias_prazo'] == 30) {
    print('PONTOS SERÁ 1');
    pontos = 1;
  } 

  if (DateTime.now().isAfter(dataFinal)) {
    pontos = 0;
  }  
  
  if (DateTime.now().isBefore(dataInicial.add(Duration(days: dataFinal.difference(dataInicial).inDays ~/ 2)))) {
    print('FUNÇÃO SALVAR LIVRO LIDO: CONCLUIU EM MENOS DA METADE DO PRAZO');
    pontos = pontos * 2;
  }
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/livros-lidos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  
    if (response.statusCode == 200) {
      print('FUNÇÃO SALVAR LIVRO LIDO: SALVO COM SUCESSO - CODIGO 200');
       // Sucesso                            
      await aumentaPontos(getAppContext()!, pontos);
      await recolherDados(usuarioId);
      carregamento.hide();
      return true;
    } else if (response.statusCode == 201) {
      print('FUNÇÃO SALVAR LIVRO LIDO: LIVRO LIDO SALVO COM SUCESSO AGORA CÓDIGO 201');
      //chamar tela de fim do roteiro
      carregamento.hide();      
      await aumentaPontos(getAppContext()!, pontos);
      carregamento.hide();
      await recolherDados(usuarioId);
      return true;
    } else {
      // Falha      
      print('FUNÇÃO SALVAR LIVRO LIDO: LIVRO NÃO SALVO ERRO $response.error');
      print('Response Body: ${response.body}');
      carregamento.hide();
      return false;
    }
  } catch (error) {
    // Erro    
    carregamento.hide();     
    print('FUNÇÃO SALVAR LIVRO LIDO: Erro ao enviar livro lido: $error');
    return false;
  }
}

//verifica livros ja lidos pelo usuario
Future<void> obterLivrosLidos(usuarioId) async {
    
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/livros-lidos/$usuarioId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {  
      final List<dynamic> data = jsonDecode(response.body);
      dadosLivrosLidos.clear(); // Limpa os dados antigos
      for (var livro in data) {
        dadosLivrosLidos[livro['isbn']] = livro;
      }       
    }
  } catch (error) {          
    print('Erro ao obter livros lidos: $error');
  }
}

//manipulacao de roteiros ----------------------------------------------------------------

// criar um roteiro para o usuario
Future<bool> criarRoteiroDeLeitura(BuildContext context, String nomeRoteiro, List<String> isbns, int prazo) async {  
  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Criando seu roteiro');
  carregamento.show(context); 
  // ve se o usuario esta logado
  if (dadosUser.isEmpty || dadosUser['id'] == null) {     
    carregamento.hide();
    return false;
  }

  print('FUNÇÃO CRIAR ROTEIRO USUARIO');

  Map<String, dynamic> body = {
    'usuario_id': dadosUser['id'],
    'nome': nomeRoteiro,
    'data_criacao': DateTime.now().toString(),
  };
  
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/roteiro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );   

    // ignore: prefer_interpolation_to_compose_strings
     String responseBody = jsonDecode(response.body).toString();
  // Imprimindo a resposta
     print('FUNÇÃO CRIAR ROTEIRO RESPOSTA DA CRIAÇÃO DO ROTEIRO: $responseBody');
    
    if (response.statusCode == 201) {      
      final responseData = jsonDecode(response.body);
      final id = responseData['id'];
      bool resultado = (
        await adicionarLivroAoRoteiro(id, isbns) &&
        await atualizaUsuario(getAppContext()!, livroAtual: isbns[0], mostrar: false)) &&
        await atualizarProgresso(diasPrazo: prazo, dataInicio: DateTime.now(), isbnLivro: isbns[0], ultimaPaginaLida: 0, tempoGasto: 0, totalPaginasLidas: 0);                    
      carregamento.hide();
      return resultado;
    } else if (response.statusCode == 409) {      
      PopAviso().aviso('Erro', 'Já existe um roteiro vigente. Termine o roteiro ou exclua o mesmo para compor outro.');
      return false;
    } else {
      //falha           
      carregamento.hide();
      return false;
    }
  } catch (error) {    
    print(' FUNÇÃO CRIAR ROTEIRO  Erro ao criar roteiro de leitura: $error');
    carregamento.hide();
    return false;
  }
}


// adicionar livro ao roteiro
Future<bool> adicionarLivroAoRoteiro(roteiroId, List<String> isbns) async {  

  List<Map<String, dynamic>> livros = [];

  for (String isbn in isbns) {
    livros.add({
      'isbn': isbn,
    });
  }

  Map<String, dynamic> body = {
    'livros':livros,
  };  
  
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/roteiro/$roteiroId/livros'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      //sucesso
      print(" FUNÇÃO AICIONAR LIVROS:  LIVROS ADICIONADOS NO BD COM SUCESSO");
      return true;          
    } else {
      print(" FUNÇÃO AICIONAR LIVROS: ERRO AO ADICIONAR LIVROS NO BD ");
      //falha
      return false;
    }
  } catch (error) {      
    print('Erro ao adicionar livro ao roteiro de leitura: $error');
    return false;
  }
}

//controle do progresso ----------------------------------------------------------------

//atualizar progresso
Future<bool> atualizarProgresso(  
  {DateTime? dataPrazo,
  int? diasPrazo,
  DateTime? dataInicio,
  DateTime? dataUltimaLeitura,
  int? ultimaPaginaLida,
  int? tempoGasto,
  String? isbnLivro,
  int? totalPaginasLidas,
  bool? concluindo}  
) async {

  TelaCarregamento carregamento = TelaCarregamento(mensagem: 'Atualizando seu progresso');
  carregamento.show(getAppContext()!);
  
  if (concluindo != null && concluindo == true) {    
    print('FUNÇÃO ATUALIZA PROGRESSO: CONCLUIU O LIVRO É VERDADEIRO');
    bool resultado = await salvaLivroLido(
      getAppContext()!,
      isbnLivro ??= dadosUser['livro_atual']
    );
    if (resultado) {
      carregamento.hide();
      return true;
    } else {
      carregamento.hide();
      return false;
    }
  } else {
  final String userId = dadosUser['id'].toString();
  isbnLivro ??= dadosUser['livro_atual'];
  String? dataPrazoStr = dataPrazo?.toIso8601String();
  String? dataInicioStr = dataInicio?.toIso8601String();
  String? dataUltimaLeituraStr = dataUltimaLeitura?.toIso8601String();

  Map<String, dynamic> body = {  
    'usuario_id' : userId,
    'livro_atual' : isbnLivro,
    if (dataPrazo != null) 'data_prazo': dataPrazoStr,
    if (diasPrazo != null) 'dias_prazo': diasPrazo,
    if (dataInicio != null) 'data_inicio': dataInicioStr,
    if (dataUltimaLeitura != null) 'data_ultima_leitura': dataUltimaLeituraStr,
    if (ultimaPaginaLida != null) 'ultima_pagina_lida': ultimaPaginaLida,
    if (tempoGasto != null) 'tempo_gasto': tempoGasto,
    if (totalPaginasLidas != null) 'total_paginas_lidas': totalPaginasLidas,  
  };

  try {
    final response = await http.put(
      Uri.parse('$apiUrl/progresso/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Sucesso
      print('Entrada de progresso atualizada com sucesso');
      carregamento.hide();
      return true;
    } else {
      // Falha
      print('Falha ao atualizar entrada de progresso: ${response.body}');
      carregamento.hide();
      return false;
    }
    
  } catch (error) {
    // Erro
    print('Erro ao atualizar entrada de progresso: $error');
    carregamento.hide();
    return false;
  }
  }
}