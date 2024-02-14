import 'package:discrete_structure_books/screens/favoritos.dart';
import 'package:flutter/material.dart';
import 'models/libro.dart';
import 'screens/detalle_libro.dart';
import 'screens/agregar_libro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Libros',
      theme: ThemeData(
        primaryColor: Colors.orange, // Cambia el color principal a naranja
        hintColor: Colors.blue, // Cambia el color de acento a azul
        scaffoldBackgroundColor:
            Colors.yellow[10], // Cambia el color de fondo a naranja claro
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          subtitle1: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ),
      debugShowCheckedModeBanner: false, // Elimina la bandera de debug
      home: MyHomePage(title: 'Libros para Estructuras Discretas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Libro> libros = [
    Libro(
      titulo: 'Flutter para principiantes',
      autor: 'John Doe',
      portada:
          'https://cdn.pixabay.com/photo/2015/11/19/21/10/glasses-1052010_1280.jpg',
      descripcion:
          'Aprende a crear aplicaciones móviles multiplataforma con Flutter.',
    ),
    Libro(
      titulo: 'El señor de los anillos',
      autor: 'J.R.R. Tolkien',
      portada:
          'https://cdn.pixabay.com/photo/2015/11/19/21/10/glasses-1052010_1280.jpg',
      descripcion:
          'Una novela épica de fantasía sobre la lucha contra el Señor Oscuro Sauron.',
    ),
    // ... más libros
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Lógica para la búsqueda
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: libros.length + 1, // Agregar uno para el botón
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          if (index < libros.length) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetalleLibroScreen(libro: libros[index]),
                  ),
                );
              },
              child: _buildLibroCard(libros[index]),
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  _agregarLibro(context); // Lógica para agregar libros
                },
                child: Text(
                  'Agregar Libro',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.library_books),
              onPressed: () {
                // Lógica para la opción "Biblioteca"
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritosPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
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
                      child: Text(
                        'Leer más',
                        style: TextStyle(
                            color: Colors
                                .white), // Cambia el color del texto a blanco
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
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

  void _agregarLibro(BuildContext context) async {
    final nuevoLibro = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgregarLibroScreen()),
    );

    if (nuevoLibro != null) {
      setState(() {
        libros.add(nuevoLibro);
      });
    }
  }
}
