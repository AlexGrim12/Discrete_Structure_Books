import 'package:discrete_structure_books/screens/favoritos.dart';
import 'package:flutter/material.dart';
import 'models/libro.dart';
import 'screens/detalle_libro.dart';
import 'screens/agregar_libro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Libros 📙',
      theme: ThemeData(
        primaryColor: Colors.orange,
        hintColor: Colors.blue,
        scaffoldBackgroundColor: Colors.yellow[10],
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Libros para Estructuras Discretas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Libro> libros = [];

  @override
  void initState() {
    super.initState();
    _cargarLibros();
  }

  Future<void> _cargarLibros() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? librosJson = prefs.getStringList('libros');

    if (librosJson != null) {
      setState(() {
        libros.addAll(librosJson.map((json) => Libro.fromMap(jsonDecode(json))));
      });
    } else {
      // Si no hay libros guardados, agrega los libros predeterminados
      libros = [
        Libro(
          titulo: 'Flutter para principiantes',
          autor: 'John Doe',
          portada: 'https://cdn.pixabay.com/photo/2015/11/19/21/10/glasses-1052010_1280.jpg',
          descripcion: 'Aprende a crear aplicaciones móviles multiplataforma con Flutter.',
          esFavorito: false,
        ),
        Libro(
          titulo: 'El señor de los anillos',
          autor: 'J.R.R. Tolkien',
          portada: 'https://cdn.pixabay.com/photo/2015/11/19/21/10/glasses-1052010_1280.jpg',
          descripcion: 'Una novela épica de fantasía sobre la lucha contra el Señor Oscuro Sauron.',
          esFavorito: false,
        ),
        // Puedes agregar más libros aquí si lo deseas
      ];
      _guardarLibros(); // Guardar los libros predeterminados
    }
  }

  Future<void> _guardarLibros() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> librosJson = libros.map((libro) => jsonEncode(libro.toMap())).toList();
    await prefs.setStringList('libros', librosJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Lógica para la búsqueda
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: libros.length + 1,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          if (index < libros.length) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleLibroScreen(libro: libros[index]),
                  ),
                );
              },
              child: _buildLibroCard(libros[index]),
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  _agregarLibro(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                ),
                child: const Text(
                  'Agregar Libro',
                  style: TextStyle(color: Colors.white),
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
              icon: const Icon(Icons.library_books),
              onPressed: () {
                // Lógica para la opción "Biblioteca"
              },
              color: Colors.orange,
              hoverColor: Colors.orange[100],
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritosPage(libros: libros),
                  ),
                );
              },
              hoverColor: Colors.red[100],
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibroCard(Libro libro) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
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
                child: const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  libro.titulo,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 8),
                Text(
                  libro.autor,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 16),
                Text(
                  libro.descripcion,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.orange),
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
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          libro.esFavorito = !libro.esFavorito;
                        });
                        _guardarLibros();
                      },
                      icon: Icon(
                        libro.esFavorito ? Icons.favorite : Icons.favorite_border,
                        color: libro.esFavorito ? Colors.red : Colors.grey,
                      ),
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
          content: Text("¿Estás seguro de que deseas eliminar este libro?"),
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
                  libros.remove(libro);
                });
                _guardarLibros();
                Navigator.of(context).pop();
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
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
      _guardarLibros();
    }
  }
}
