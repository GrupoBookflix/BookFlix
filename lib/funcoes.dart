import 'package:bookflix/models/livro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'componentes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

//constroi a tela de carregamento
LoadingOverlay carregamento = LoadingOverlay();

//url do backend > funcoes devem iterar as rotas após a última '/'
const String apiUrl = 'https://backend-8wht.onrender.com';

//variavel temporaria para armazenar dados do usuario
Map<String, dynamic> dadosUser = {};
//variavel temporaria para armazenar dados de livros exibidos
Map<String, dynamic> dadosLivro = {};
//variavel temporaria para armazenar livros ja lidos pelo usuario
Map<String, dynamic> dadosLivrosLidos = {};
//variavel temporaria para armazenar dados do livroAtual
Map<String, dynamic> dadosLivroAtual = {};
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
  //na operacao de login, os principais dados do usuario já são recolhidos
  //mas caso seja necessario atualizar as informacoes esta funcao pode ser usada
  final response = await http.get(
    Uri.parse('$apiUrl/usuario/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    //sucesso: armazena na variavel temporaria
    dadosUser = json.decode(response.body);
  } else {
    //falha
    //chamar PopAViso
    throw Exception('Falha ao carregar dados do usuário');
  }
}

//retornar dado especifico do usuario
String dadosBasicosUser(String dado) {
  return dadosUser[dado]?.toString() ?? '';
}

//enviar dados backend ----------------------------------------

//registrar usuario: Acho melhor que esta funcao fique em cadastro e login
Future<bool> registraUsuario(
    BuildContext context, String nome, String email, String senha) async {
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
Future<void> atualizaUsuario(
    BuildContext context,
    id,
    String? nome,
    String? email,
    String? senha,
    int? nivel,
    int? pontos,
    String? livroAtual) async {
  carregamento.show(context);

  //sanitizar entradas
  nome = nome != null ? sanitizaEntrada(nome) : null;
  email = email != null ? sanitizaEntrada(email) : null;
  senha = senha != null ? validatePassword(senha) : null;

  //corpo da requisição
  Map<String, dynamic> body = {
    if (nome != null) 'nome': nome,
    if (email != null) 'email': email,
    if (senha != null) 'senha': senha,
    if (nivel != null) 'nivel': nivel,
    if (pontos != null) 'pontos': pontos,
    if (livroAtual != null) 'livro_atual': livroAtual,
  };

  final response = await http.put(Uri.parse('$apiUrl/usuario/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body));

  PopAviso aviso = PopAviso();

  if (response.statusCode == 200 || response.statusCode == 201) {
    // sucesso
    carregamento.hide();
    aviso.aviso('Sucesso', 'Seus dados foram atualizados');
    //voltar ao menu
  } else if (response.statusCode == 404) {
    // falha
    carregamento.hide();
    aviso.aviso('Erro', 'Usuário não encontrado');
    //voltar ao menu
  } else {
    // falha servidor
    carregamento.hide();
    //chamar a funcao de mostrar dialogo
    aviso.aviso(
        'Erro', 'Ocorreu um erro inesperado. Por favor tente novamente');
  }
}

//definicao de generos literarios ----------------------------------------

//adicionar genero para o usuario
Future<void> adicionarGenero(String userId, String genero) async {
  //chamar carregamento
  try {
    final response = await http.put(
      Uri.parse('$apiUrl/usuario/$userId/generos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'genero': genero,
      }),
    );

    PopAviso aviso = PopAviso();

    if (response.statusCode == 200) {
      carregamento.hide();
      //concluir a definicao do genero
    } else if (response.statusCode == 400) {
      carregamento.hide();
      aviso.aviso('Erro', 'Este gênero já foi escolhido pelo usuário');
    } else {
      carregamento.hide();
      aviso.aviso('Erro',
          'Ocorreu um erro inesperado. Por favor tente novamente mais tarde.');
    }
  } catch (error) {
    // ignore: avoid_print
    print('Erro: ao adicionar gênero: $error');
  }
}

//remover um genero para o usuário
Future<void> removerGenero(String userId, String generoId) async {
  //chamar tela de carregamento
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
      aviso.aviso('Erro',
          'Ocorreu um erro inesperado. Por favor tente novamente mais tarde.');
    }
  } catch (error) {
    // ignore: avoid_print
    print('Erro: ao adicionar gênero: $error');
  }
}

//login
Future<bool> loginUsuario(
    BuildContext context, String email, String senha) async {
  carregamento.show(context);

  final response = await http.post(
    Uri.parse('$apiUrl/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
      'senha': senha,
    }),
  );

  PopAviso aviso = PopAviso();

  if (response.statusCode == 200) {
    //salva os dados do usuario logado em dadosUser
    carregamento.hide();
    final responseData = jsonDecode(response.body);
    final usuario = responseData['usuario'];
    usuario.forEach((key, value) {
      dadosUser[key] = value;
    });
    await obterLivrosLidos(dadosUser['id']);
    carregamento.hide();
    return true;
    //ir para a pagina principal
  } else if (response.statusCode == 404) {
    carregamento.hide();
    aviso.aviso('Erro', 'Não foi encontrado usuário com este email');
    return false;
  } else if (response.statusCode == 401) {
    carregamento.hide();
    aviso.aviso('Erro', 'Email ou senha incorretos');
    return false;
  } else {
    carregamento.hide();
    aviso.aviso('Erro', 'Erro inesperado. Por favor tente novamente');
    return false;
  }
}

//recolher dados API ----------------------------------------

//recolher dados de livro openLibrary
Future<void> buscarDadosLivro(String isbn, Map<String, dynamic> destino) async {
  final response = await http.get(Uri.parse(
      'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&jscmd=data&format=json'));

  if (response.statusCode == 200) {
    final bookData = json.decode(response.body)['ISBN:$isbn'];
    //salva dados do livro recebido na Map definida
    if (bookData != null) {
      destino['isbn'] = isbn;
      destino['titulo'] = bookData['title'];
      destino['autor'] =
          (bookData['authors'] != null && bookData['authors'].isNotEmpty)
              ? bookData['authors'][0]['name']
              : 'Desconhecido';
      destino['paginas'] = bookData['number_of_pages'] ?? 0;
      destino['ano'] = bookData['publish_date'] ?? 'Desconhecido';
      destino['sinopse'] = bookData['description'] ?? 'Sinopse não disponível';
      destino['genero'] =
          (bookData['subjects'] != null && bookData['subjects'].isNotEmpty)
              ? bookData['subjects'][0]['name']
              : 'Gênero não disponível';
    } else {
      throw Exception('Livro não encontrado');
    }
  } else {
    throw Exception('Falha ao buscar dados do livro');
  }
}

/*
Future<void> buscarIsbnPorGenero(String genero) async {
  final response = await http.get(Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=subject:$genero&maxResults=40&fields=items(volumeInfo/industryIdentifiers)&key=YOUR_API_KEY'));

  if (response.statusCode == 200) {
    final booksData = json.decode(response.body);
    final items = booksData['items'] ?? [];

    for (var item in items) {
      var industryIdentifiers = item['volumeInfo']['industryIdentifiers'] ?? [];
      for (var identifier in industryIdentifiers) {
        if (identifier['type'] == 'ISBN_13' || identifier['type'] == 'ISBN_10') {
          String isbn = identifier['identifier'];
          if (!isbnsEscolhidos.contains(isbn)) {
            isbnsEscolhidos.add(isbn);
            print('ISBN encontrado e adicionado: $isbn');
            return; // Para após encontrar e adicionar um ISBN
          }
        }
      }
    }
    print('Nenhum ISBN novo encontrado para o gênero: $genero');
  } else {
    throw Exception('Falha ao buscar livros do gênero $genero');
  }
}

*/

Future<List<Livro>> buscarLivrosPorGenero(String genero, int limite) async {
  List<Livro> livros = [];

  final response = await http.get(Uri.parse(
      'https://openlibrary.org/search.json?subject=$genero&sort=random&limit=$limite'));

  if (response.statusCode == 200) {
    print('BUSCOU--->' + genero);

    final booksDataArray = json.decode(response.body)['docs'];

    if (booksDataArray != null) {
      for (var book in booksDataArray) {
        livros.add(
            Livro(isbn: book['isbn'][0],
                nome: book['title'],
                genero: genero,
                imageId: book['cover_i'] == null ? "7010041" : book['cover_i'].toString()
            )
        );
      }
    } else {
      print('ERRO1');
      throw Exception('Livros não encontrados');
    }
  } else {
    print('ERRO2');
    throw Exception('Falha ao buscar livros');
  }
  return livros;
}

Future<List<Map<String, dynamic>>> montaRoteiros(BuildContext context) async {
  print("---------------------START-----------------------");

  //carregamento.show(context);
  List<String> generos = ['horror', 'romance', 'adventure']; // pegar generos favoritos do usuario
  List<Map<String, dynamic>> scriptList = [];

  Map<String, dynamic> roteiro1 = {};
  Map<String, dynamic> roteiro2 = {};
  Map<String, dynamic> roteiro3 = {};

  // Roteiro list
  for (var genero in generos) {
    List<Livro> roteirosDoGenero = await buscarLivrosPorGenero(genero, 9);
    roteiro1[genero] = roteirosDoGenero.take(3).toList();
    roteiro2[genero] = roteirosDoGenero.skip(3).take(3).toList();
    roteiro3[genero] = roteirosDoGenero.skip(6).take(3).toList();
  }

  scriptList.add(roteiro1);
  scriptList.add(roteiro2);
  scriptList.add(roteiro3);

  print("---------------------END-----------------------");
  //carregamento.hide();

  return scriptList;
}

//funcoes para a logica do jogo ----------------------------------------

//atribuir pontos
void aumentaPontos(int pontos) {
  dadosUser['pontos'] += pontos;
  aumentaNivel();
}

//aumentar o nivel do jogador
void aumentaNivel() {
  //a disposição do nível pode ser adequada no futuro
  const int base = 10;
  const double fator = 1.3;

  int nivelAtual = dadosUser['nivel'];
  int pontosAtuais = dadosUser['pontos'];
  int pontosNecessarios = (base * (nivelAtual * fator)).ceil();

  //para subir mais de um nível se o usuário ganhar vários pontos de uma vez
  while (pontosAtuais >= pontosNecessarios) {
    dadosUser['nivel'] = nivelAtual++;
    pontosNecessarios = (base * (nivelAtual * fator)).ceil();
  }
}

//salva livro concluido pelo usuario ----------------------------------------------------------------
Future<bool> salvaLivroLido(BuildContext context, String isbn) async {
  
  final usuarioId = dadosBasicosUser('id');
  final dataLeitura = DateTime.now();

  carregamento.show(context);

  Map<String, dynamic> body = {
    'usuario_id': usuarioId,
    'isbn': isbn,
    'data_leitura': dataLeitura.toIso8601String(),
  };

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/livros-lidos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      // Sucesso
      carregamento.hide();
      return true;
    } else {
      // Falha
      carregamento.hide();
      return false;
    }
  } catch (error) {
    // Erro
    // ignore: avoid_print
    print('Erro ao enviar livro lido: $error');
    return false;
  }
}

//verifica livros ja lidos pelo usuario
Future<void> obterLivrosLidos(int usuarioId) async {
  
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
    // ignore: avoid_print
    print('Erro ao obter livros lidos: $error');
  }
}

//manipulacao de roteiros ----------------------------------------------------------------

// criar um roteiro para o usuario
Future<bool> criarRoteiroDeLeitura(BuildContext context, String nomeRoteiro) async {
  // ve se o usuario esta logado
  if (dadosUser.isEmpty || dadosUser['id'] == null) {    
    return false;
  }
  carregamento.show(context);

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

    if (response.statusCode == 201) {
      //sucesso
      carregamento.hide();
      return true;
    } else {
      //falha
      carregamento.hide();
      return false;
    }
  } catch (error) {
    // ignore: avoid_print
    print('Erro ao criar roteiro de leitura: $error');
    return false;
  }
}

// adicionar livro ao roteiro
Future<void> adicionarLivroAoRoteiro(BuildContext context, roteiroId, String isbn) async {
  
  carregamento.show(context);

  Map<String, dynamic> body = {
    'isbn': isbn,
    'sequencia': 1,
  };
  
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/roteiro/$roteiroId/livro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      //sucesso
      carregamento.hide();      
    } else {
      //falha
      carregamento.hide();      
    }
  } catch (error) {
    // ignore: avoid_print
    print('Erro ao adicionar livro ao roteiro de leitura: $error');
  }
}