import 'package:flutter/material.dart';
import '../models/libro.dart';

class DetalleLibroScreen extends StatelessWidget {
  final Libro libro;

  DetalleLibroScreen({required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titulo),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  libro.portada,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Título: ${libro.titulo}',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Autor: ${libro.autor}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Descripción: ${libro.descripcion}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ubicación: ${libro.ubicacion}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Volver'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
