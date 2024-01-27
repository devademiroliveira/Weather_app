import 'package:flutter/material.dart';

class TextBase extends StatelessWidget {
  final String? texto;
  final double? tamanhoTexto;
  const TextBase({super.key, this.texto, this.tamanhoTexto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto!,
      style: TextStyle(
        fontSize: tamanhoTexto,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
