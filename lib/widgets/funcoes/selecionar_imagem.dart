/*
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> selecionarImagem(ImageSource imagem) async {
  try {
    ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: imagem);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('Nenhuma imagem foi selecionada.');
      return null;
    }
  } catch (e) {
    print('Erro ao selecionar imagem: $e');
    return null;
  }
}
*/