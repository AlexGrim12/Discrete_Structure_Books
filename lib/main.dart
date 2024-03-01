import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'models/libro.dart';
import 'screens/detalle_libro.dart';
import 'screens/agregar_libro.dart';
import 'screens/favoritos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _currentTheme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Libros 📙',
      theme: _currentTheme.copyWith(
        colorScheme: _currentTheme == ThemeData.light()
            ? const ColorScheme.light(
                primary: Colors.orange,
                secondary: Colors.orange,
              )
            : const ColorScheme.dark(
                primary: Colors.orange,
                secondary: Colors.orange,
              ),
        textTheme: TextTheme(
          // Ajustar los colores de texto para el modo claro y oscuro
          headline1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _currentTheme == ThemeData.light() ? Colors.black : Colors.white,
          ),
          subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _currentTheme == ThemeData.light() ? Colors.black : Colors.white,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: _currentTheme == ThemeData.light() ? Colors.black : Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Libros para Estructuras Discretas',
        toggleTheme:
            _toggleTheme, // Pasar la función de cambio de tema a MyHomePage
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      // Cambiar el tema según el tema actual
      _currentTheme = _currentTheme == ThemeData.light()
          ? ThemeData.dark()
          : ThemeData.light();
    });
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final VoidCallback toggleTheme; // Función para cambiar el tema

  const MyHomePage({Key? key, required this.title, required this.toggleTheme})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Libro> libros = [];
  late List<Libro> librosFiltrados; // Lista para almacenar libros filtrados
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarLibros();
    librosFiltrados =
        libros; // Inicializar librosFiltrados con todos los libros al inicio
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose del controlador de texto
    super.dispose();
  }

  Future<void> _cargarLibros() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? librosJson = prefs.getStringList('libros');

    if (librosJson != null) {
      setState(() {
        libros
            .addAll(librosJson.map((json) => Libro.fromMap(jsonDecode(json))));
      });
    } else {
      // Si no hay libros guardados, agrega los libros predeterminados
      libros = [
        Libro(
          titulo: 'Algorithms: sequential, parallel, and distributed',
          autor: 'Berman, Kenneth A.',
          portada:
              'https://m.media-amazon.com/images/I/51j7s-ICwCL._AC_UF1000,1000_QL80_.jpg',
          descripcion:
              'Algorithms: Sequential, Parallel, and Distributed offers in-depth coverage of traditional and current topics in sequential algorithms, as well as a solid introduction to the theory of parallel and distributed algorithms. In light of the emergence of modern computing environments such as parallel computers, the Internet, and cluster and grid computing, it is important that computer science students be exposed to algorithms that exploit these technologies. Berman and Pauls text will teach students how to create new algorithms or modify existing algorithms, thereby enhancing students ability to think independently.',
          ubicacion: "Biliblioteca ",
          esFavorito: false,
        ),
        Libro(
          titulo: 'Matemáticas Discretas y sus Aplicaciones',
          autor: 'Rosen, Kenneth H.',
          portada: 'https://pictures.abebooks.com/isbn/9780072899054-es.jpg',
          descripcion:
              'Contiene gran número de ejercicios y ejemplos aclaratorios. Cada tema incluye demostraciones matemáticas, análisis combinatorio, estructuras discretas, algoritmos, engarzando estos conceptos con herramientas para resolver problemas a través de modelos. Especial importancia a la Lógica, tipos de prueba y pruebas de escritura.',
          ubicacion: "Biliblioteca ",
          esFavorito: false,
        ),
        Libro(
          titulo: 'Discrete Mathematics for Computer Scientists',
          autor: 'Stein, Clifford L.',
          portada:
              'https://m.media-amazon.com/images/I/51H0Fc9ivSL._SY342_.jpg',
          descripcion:
              'Written specifically for computer science students, this unique textbook directly addresses their needs by providing a foundation in discrete math while using motivating, relevant CS applications. This text takes an active-learning approach where activities are presented as exercises and the material is then fleshed out through explanations and extensions of the exercises.',
          ubicacion: "Biliblioteca ",
          esFavorito: false,
        ),
        Libro(
          titulo: 'Discrete Mathematics',
          autor: 'Keneeth A. Ross, Charles R. Wright',
          portada:
              'https://images.bwbcovers.com/013/Discrete-Mathematics-Ross-Kenneth-A-9780132181570.jpg',
          descripcion:
              'Revised for extra clarity, the distinguishing characteristic of Ross and Wright is a sound mathematical treatment that increases smoothly in sophistication. The text presents utility-grade discrete math tools so students can understand them, use them, and move on to more advanced mathematical topics.',
          ubicacion: "Biliblioteca ",
          esFavorito: false,
        ),
        // Puedes agregar más libros aquí si lo deseas
      ];
      _guardarLibros(); // Guardar los libros predeterminados
    }
  }

  Future<void> _guardarLibros() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> librosJson =
        libros.map((libro) => jsonEncode(libro.toMap())).toList();
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
            icon: Icon(
                Icons.sunny), // Cambiar el icono dependiendo del tema actual
            onPressed:
                widget.toggleTheme, // Llamar a la función de cambio de tema
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar libros',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filtrarLibros(
                    value); // Llamar a la función de filtrado cuando cambie el texto
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: librosFiltrados.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                if (index < librosFiltrados.length) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleLibroScreen(libro: librosFiltrados[index]),
                        ),
                      );
                    },
                    child: _buildLibroCard(librosFiltrados[index]),
                  );
                } else {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _agregarLibro(context);
                      },
                      style: ButtonStyle(
                          // backgroundColor:
                          //     MaterialStateProperty.all(Colors.orange),
                          ),
                      child: const Text(
                        'Agregar Libro',
                        // style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
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

  // Función para filtrar los libros basados en el término de búsqueda
  void _filtrarLibros(String searchTerm) {
    setState(() {
      librosFiltrados = libros.where((libro) {
        final titulo = libro.titulo.toLowerCase();
        final autor = libro.autor.toLowerCase();
        final descripcion = libro.descripcion.toLowerCase();
        final searchLower = searchTerm.toLowerCase();
        // Devuelve verdadero si alguno de los campos del libro contiene el término de búsqueda
        return titulo.contains(searchLower) ||
            autor.contains(searchLower) ||
            descripcion.contains(searchLower);
      }).toList();
    });
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
              height: 450,
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
                        libro.esFavorito
                            ? Icons.favorite
                            : Icons.favorite_border,
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
