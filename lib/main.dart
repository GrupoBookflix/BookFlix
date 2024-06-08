import 'package:bookflix/funcoes.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:get/get.dart';


void main() {
  runApp(const MaterialApp (
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {    
    setAppContext(context);
    // ignore: prefer_const_constructors
    return GetMaterialApp(      
      title: 'Bookflix',      
      home: const Login(),      
    );
  }
}