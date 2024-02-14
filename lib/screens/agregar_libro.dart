import 'package:flutter/material.dart';
import '../models/libro.dart';

class AgregarLibroScreen extends StatelessWidget {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController autorController = TextEditingController();
  final TextEditingController portadaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Libro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: autorController,
              decoration: InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: portadaController,
              decoration: InputDecoration(labelText: 'URL de la Portada'),
            ),
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _agregarLibro(context);
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarLibro(BuildContext context) {
    final nuevoLibro = Libro(
      titulo: tituloController.text,
      autor: autorController.text,
      portada: portadaController.text,
      descripcion: descripcionController.text,
    );

    Navigator.pop(context, nuevoLibro);
  }
}
