// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'login.dart';
import 'principal.dart';
import 'roteiros.dart';
import 'sessao_leitura.dart';
import 'configuracoes.dart';
import 'widgets/funcoes.dart';

class Rotas {
  static const String login = '/login';
  static const String principal = '/principal';
  static const String conta = '/conta';
  static const String roteiros = '/roteiro';
  static const String historicoLeitura = '/historico_leitura';  
  static const String trocarSenha = '/troca_senha';
  static const String generos = '/generos';
  static const String leitura = '/sessao_leitura';

   static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const Login(),
      principal: (context) => const Principal(),
      conta: (context) => const ContaUsuario(),
      roteiros: (context) => SelecaoRoteiroRandom(generosUsuario: dadosUser['generos']),
      generos: (context) => const SelecaoGenero(),
      leitura: (context) => const SessaoLeitura(),
      trocarSenha: (context) => const AlterarSenha(),
      historicoLeitura: (context) => const HistoricoLeitura(),         
    };
  }
}