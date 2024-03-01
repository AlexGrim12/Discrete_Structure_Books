import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../screens/detalle_libro.dart';

class FavoritosPage extends StatefulWidget {
  final List<Libro> libros; // Lista de todos los libros

  FavoritosPage({required this.libros});

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  @override
  Widget build(BuildContext context) {
    List<Libro> favoritos = widget.libros.where((libro) => libro.esFavorito).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: _buildListaFavoritos(favoritos),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.library_books),
              onPressed: () {
                Navigator.pop(context); // Regresa a la página principal
              },
              color: Colors.grey[400],
              hoverColor: Colors.orange[100],
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                // Lógica para navegar a la página de inicio
              },
              color: Colors.red,
              hoverColor: Colors.red[100],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaFavoritos(List<Libro> favoritos) {
    if (favoritos.isEmpty) {
      return Center(
        child: Text('No hay libros favoritos.'),
      );
    } else {
      return ListView.builder(
        itemCount: favoritos.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleLibroScreen(libro: favoritos[index]),
                ),
              );
            },
            child: _buildLibroCard(favoritos[index]),
          );
        },
      );
    }
  }

  Widget _buildLibroCard(Libro libro) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              libro.portada,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  libro.titulo,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: 8),
                Text(
                  libro.autor,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 16),
                Text(
                  libro.descripcion,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                      ),
                      child: const Text(
                        'Leer más',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _mostrarAlertaEliminarLibro(context, libro);
                      },
                      icon: Icon(Icons.favorite),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarAlertaEliminarLibro(BuildContext context, Libro libro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("¿Estás seguro de que deseas eliminar este libro de favoritos?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  libro.esFavorito = false;
                });
                Navigator.of(context).pop();
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }
}
