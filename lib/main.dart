import 'package:bookflix/funcoes.dart';
import 'package:flutter/material.dart';
//import 'login.dart';
import 'sessao_leitura.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MaterialApp (
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {    
    setAppContext(context);
    // ignore: prefer_const_constructors
    return GetMaterialApp(      
      title: 'Bookflix',      
      home: const SessaoLeitura(),      
    );
  }
}