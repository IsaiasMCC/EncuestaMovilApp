import 'package:flutter/material.dart';

void alertaSalida(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Esta seguro que quiere Salir?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text('se perdera todo el avance'),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pushNamed(context, 'encuestas'),
                child: const Text('aceptar')),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('cancelar')),
          ],
        );
      });
}
