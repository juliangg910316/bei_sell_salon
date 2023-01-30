import 'package:flutter/material.dart';

class CustomTextEditing {
  static Widget buildName(TextEditingController textController, String hint) =>
      TextFormField(
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hint,
        ),
        keyboardType: TextInputType.text,
        validator: (name) {
          print('name = $name');
          return name == null ? 'Complete los campos' : null;
        },
      );

  static Widget buildMonto(
          TextEditingController montoController, String hint) =>
      TextFormField(
        controller: montoController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hint,
        ),
        keyboardType: TextInputType.number,
        validator: (monto) {
          print('monto = $monto');
          return monto != null && int.tryParse(monto) == null
              ? 'Complete los campos'
              : null;
        },
      );
}
