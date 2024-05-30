import 'package:flutter/material.dart';

// tela de carregamento simples
class LoadingOverlay {
  // ignore: unused_field
  late BuildContext _context;
  late OverlayEntry _overlayEntry;
  //bloqueia e mostra efeito
  void show(BuildContext context) {
    _context = context;
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Stack(
        children: <Widget>[
          ModalBarrier(
            color: Colors.white.withOpacity(0.5),
            dismissible: false,
          ),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF48a0d4)),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry);
  }
  //libera e apaga efeito
  void hide() {
    _overlayEntry.remove();
  }
}