import 'package:flutter/material.dart';

class CustomButtons {
  static Widget buildCancelButton(BuildContext context) {
    return TextButton(
      child: const Text('Cancelar'),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  static Widget buildAddButton(
      {required bool isEditing, required Function onPressed}) {
    final text = isEditing ? 'Salvar' : 'Adicionar';
    return TextButton(
      child: Text(text),
      onPressed: () => onPressed(),
    );
  }
}
