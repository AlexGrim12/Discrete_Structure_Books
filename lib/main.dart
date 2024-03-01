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
        // Habilitar Material You (Material 3
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
            color: _currentTheme == ThemeData.light()
                ? Colors.black
                : Colors.white,
          ),
          subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _currentTheme == ThemeData.light()
                ? Colors.black
                : Colors.white,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: _currentTheme == ThemeData.light()
                ? Colors.black
                : Colors.white,
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
          ubicacion: "Biblioteca Antonio Dovalí Jaime",
          esFavorito: false,
        ),
        Libro(
          titulo: 'Matemáticas Discretas y sus Aplicaciones',
          autor: 'Rosen, Kenneth H.',
          portada: 'https://pictures.abebooks.com/isbn/9780072899054-es.jpg',
          descripcion:
              'Contiene gran número de ejercicios y ejemplos aclaratorios. Cada tema incluye demostraciones matemáticas, análisis combinatorio, estructuras discretas, algoritmos, engarzando estos conceptos con herramientas para resolver problemas a través de modelos. Especial importancia a la Lógica, tipos de prueba y pruebas de escritura.',
          ubicacion: "Biblioteca Antonio Dovalí Jaime",
          esFavorito: false,
        ),
        Libro(
          titulo: 'Discrete Mathematics for Computer Scientists',
          autor: 'Stein, Clifford L.',
          portada:
              'https://m.media-amazon.com/images/I/51H0Fc9ivSL._SY342_.jpg',
          descripcion:
              'Written specifically for computer science students, this unique textbook directly addresses their needs by providing a foundation in discrete math while using motivating, relevant CS applications. This text takes an active-learning approach where activities are presented as exercises and the material is then fleshed out through explanations and extensions of the exercises.',
          ubicacion: "Biblioteca Antonio Dovalí Jaime",
          esFavorito: false,
        ),
        Libro(
          titulo: 'Discrete Mathematics',
          autor: 'Keneeth A. Ross, Charles R. Wright',
          portada:
              'https://images.bwbcovers.com/013/Discrete-Mathematics-Ross-Kenneth-A-9780132181570.jpg',
          descripcion:
              'Revised for extra clarity, the distinguishing characteristic of Ross and Wright is a sound mathematical treatment that increases smoothly in sophistication. The text presents utility-grade discrete math tools so students can understand them, use them, and move on to more advanced mathematical topics.',
          ubicacion: "Biblioteca Antonio Dovalí Jaime",
          esFavorito: false,
        ),

        Libro(
          titulo: 'Discrete mathematical structures',
          autor: 'Bernard Kolman, Robert C. Busby, Sharon Ross',
          portada:
              'https://images-na.ssl-images-amazon.com/images/P/9688807990.01.LZZZZZZZ.jpg',
          descripcion:
              'ofrece una presentación clara y concisa de los conceptos fundamentales de las matemáticas discretas. Ideal para un curso introductorio de un semestre, este texto contiene más aplicaciones genuinas de informática que cualquier otro texto en este campo. Este libro está escrito en un nivel apropiado para una amplia variedad de especialidades y no especialidades, y asume un curso universitario de álgebra como requisito previo.',
          ubicacion:
              "8 en  Facultad de Ingeniería 7 en  Fac. Ing. Div. Est. Prof. Anexo Clasificacion: QA76.9 K64 2018",
          esFavorito: false,
        ),

        Libro(
          titulo: 'Matemáticas discretas con teoría de gráficas y combinatoria',
          autor: 'T. Veerarajan ; traducción, Gabriel Nagore C.',
          portada:
              'https://www.elsotano.com/imagenes_grandes/9789701/978970106530.JPG',
          descripcion:
              'En esta obra, T. Veerarajan introduce algunos conceptos fundamentales de las matemáticas discretas, de una manera precisa y fácil. El libro contiene una mezcla inteligente de conceptos, ejemplos resueltos y ejercicios con respuestas que lo hace ideal para los cursos de licenciatura de matemáticas discretas. Esta combinación de elementos logra que el estudiante relacione en forma adecuada las técnicas matemáticas con las aplicaciones de cómputo. Características sobresalientes o Cobertura exhaustiva de la teoría de conjuntos. o Teoría de gráficas y combinatoria abordadas',
          ubicacion:
              "8 en  Facultad de Ingeniería 2 en  Fac. Ing. Div. Est. Prof. Anexo Clasificacion: QA248 V4418",
          esFavorito: false,
        ),

        Libro(
          titulo: 'Introductory discrete mathematics',
          autor: 'V.K. Balakrishnan',
          portada: 'https://m.media-amazon.com/images/I/61C-frrq2-L.SL1000.jpg',
          descripcion:
              'This concise text offers an introduction to discrete mathematics for undergraduate students in computer science and mathematics. Mathematics educators consider it vital that their students be exposed to a course in discrete methods that introduces them to combinatorial mathematics and to algebraic and logical structures focusing on the interplay between computer science and mathematics. The present volume emphasizes combinatorics, graph theory with applications to some stand network optimization problems, and algorithms to solve these problems.',
          ubicacion:
              "3 en  Facultad de Ingeniería 1 en  Fac. Ing. Div. Est. Prof. Anex Clasificacion: QA39.2 B356 1996",
          esFavorito: false,
        ),

Libro(
          titulo: 'Discrete mathematics',
          autor: 'Richard Johnsonbaugh',
          portada:
              'https://m.media-amazon.com/images/I/91Sb82idcVL.SL1500.jpg',
          descripcion:
              'With nearly 4,500 exercises, Discrete Mathematics provides ample opportunities for students to practice, apply, and demonstrate conceptual understanding. Exercise sets features a large number of applications, especially applications to computer science. The almost 650 worked examples provide ready reference for students as they work. A strong emphasis on the interplay among the various topics serves to reinforce understanding.',
          ubicacion:
              "2 en  Facultad de Ingeniería Div. Est. Prof. Anex Clasificacion: QA39.2 J64 2005",
          esFavorito: false,
        ),

Libro(
          titulo: 'Matematicas discretas : con aplicacion a las ciencias de la computacion',
          autor: 'Jean-Paul Tremblay, Ram Manohar ; tr. Raymundo Hugo Rangel Gutierrez ',
          portada:
              '',
          descripcion:
              'Contiene lógica, teoría de conjuntos, estructuras algebraicas, álgebra booleana, teorpia de gráficos y teoría de computabilidad básica.',
          ubicacion:
              "23 en  Facultad de Ingeniería Div. Est. Prof. Anex Clasificacion: QA39.2 T44 1996",
          esFavorito: false,
        ),
//         Titulo:
// Matemáticas discretas con teoría de gráficas y combinatoria
// Autores:
// T. Veerarajan ; traducción, Gabriel Nagore C. 
// Descripcion:

// URL IMAGEN:
// https://books.google.com/books/content?id=cU6VPgAACAAJ&printsec=frontcover&img=1&zoom=5

// 8 en  Facultad de Ingeniería 
// 2 en  Fac. Ing. Div. Est. Prof. Anex 


// Clasificacion:
// QA248 V4418
Libro(
          titulo: 'Matemáticas discretas con aplicaciones',
          autor: 'Susanna S. Epp ; traducción, Gabriel Nagore C.',
          portada:
              'https://books.google.com/books/content?id=cU6VPgAACAAJ&printsec=frontcover&img=1&zoom=5',
          descripcion:
              'Este libro es una introducción accesible a las ideas matemáticas básicas de la matemática discreta y la teoría de grafos, que se presenta en un marco que muestra la relevancia de las ideas y cómo se aplican a problemas del mundo real. Los estudiantes aprenden sobre las estructuras matemáticas que se utilizan para modelar problemas del mundo real y sobre las herramientas necesarias para resolver esos problemas.',
          ubicacion:
              "8 en  Facultad de Ingeniería 7 en  Fac. Ing. Div. Est. Prof. Anex Clasificacion: QA248 V4418",
          esFavorito: false,
        ),
//         Titulo:
// Matematica discreta
// Autores:
// Francesc Comellas
// Descripcion:
// La matemática discreta es la parte de las matemáticas que trata de estructuras finitas y numerables. Esta nueva rama de la ciencia matemática ha recibido un impulso decisivo gracias a los recientes progresos de la informática y las técnicas de computación

// URL IMAGEN:
// https://m.media-amazon.com/images/I/51S2qH7OqqL.jpg


// 5 en  Fac. Ing. Div. Est. Prof. Anex 

// Clasificacion:
// QA37.3 M3718 2002
Libro(
          titulo: 'Matemática discreta',
          autor: 'Francesc Comellas',
          portada:
              'https://m.media-amazon.com/images/I/51S2qH7OqqL.jpg',
          descripcion:
              'La matemática discreta es la parte de las matemáticas que trata de estructuras finitas y numerables. Esta nueva rama de la ciencia matemática ha recibido un impulso decisivo gracias a los recientes progresos de la informática y las técnicas de computación',
          ubicacion:
              "5 en  Fac. Ing. Div. Est. Prof. Anex Clasificacion: QA37.3 M3718 2002",
          esFavorito: false,
        ),
//         Titulo:
// Matemáticas discretas
// Autores:
// Edward R. Scheinerman
// Descripcion:


// URL IMAGEN:
// https://sabio.eia.edu.co/cgi-bin/koha/opac-image.pl?thumbnail=1&imagenumber=5068


// 1 en  Fac. de Ingeniería. Posgrado 
// 6 en  Fac. Ing. Div. Est. Prof. Anex 

// Clasificacion:
// QA37.2 S3518
Libro(
          titulo: 'Matemáticas discretas',
          autor: 'Edward R. Scheinerman',
          portada:
              'https://sabio.eia.edu.co/cgi-bin/koha/opac-image.pl?thumbnail=1&imagenumber=5068',
          descripcion:
              '',
          ubicacion:
              "1 en  Fac. de Ingeniería. Posgrado 6 en  Fac. Ing. Div. Est. Prof. Anex Clasificacion: QA37.2 S3518",
          esFavorito: false,
        ),

//         Titulo:
// Matemáticas discretas
// Autores:
// Espinoza Armenta Ramón
// Descripcion:
// Este libro de texto está dirigido a estudiantes de ciencias básicas e ingeniería y en él se exponen los fundamentos de esta área de las matemáticas que es uno de los pilares de la ciencia de la computación. La obra consta de cuatro partes: Fundamentos, Métodos algebraicos, Enumeración combinatoria y Teoría de grafos. Para esta nueva edición se han agregado nuevas secciones, se ha ampliado el número de problemas propuestos al final de cada capítulo y se han incluido más aplicaciones relacionadas con la ciencia de la computación.

// URL IMAGEN:
// https://www.elsotano.com/imagenes/9786076/978607622752.JPG

// Ubicacion:
// 1 en  Fac. Ing. Div. Est. Prof. Anex 
// Biblioteca “Mtro. Enrique Rivero Borrell”

// Clasificacion:
// QA39.3 E76 2017
Libro(
          titulo: 'Matemáticas discretas',
          autor: 'Espinoza Armenta Ramón',
          portada:
              'https://www.elsotano.com/imagenes/9786076/978607622752.JPG',
          descripcion:
              'Este libro de texto está dirigido a estudiantes de ciencias básicas e ingeniería y en él se exponen los fundamentos de esta área de las matemáticas que es uno de los pilares de la ciencia de la computación. La obra consta de cuatro partes: Fundamentos, Métodos algebraicos, Enumeración combinatoria y Teoría de grafos. Para esta nueva edición se han agregado nuevas secciones, se ha ampliado el número de problemas propuestos al final de cada capítulo y se han incluido más aplicaciones relacionadas con la ciencia de la computación.',
          ubicacion:
              "1 en  Fac. Ing. Div. Est. Prof. Anex Biblioteca “Mtro. Enrique Rivero Borrell” Clasificacion: QA39.3 E76 2017",
          esFavorito: false,
        ),
//         Titulo:
// Matemáticas discretas
// Autores:
// Lipschutz, Seymour / Lipson, Marc
// Descripcion:
// Las matemáticas discretas, el estudio de los sistemas finitos, han adquirido cada vez más importancia en la medida en que ha avanzado la era de las computadoras. Básicamente, la computadora digital es una estructura finita, y muchas de sus propiedades pueden comprenderse e interpretarse en el marco de referencia de los sistemas matemáticos finitos.
// Este libro, al presentar el material esencial, cumple los requisitos de un curso formal de matemáticas discretas, o como complemento de cualquier texto actual.Este libro, al presentar el material esencial, cumple los requisitos de un curso formal de matemáticas discretas o como complemento de cualquier texto actual. Matemáticas Discretas aborda temas sobre conjuntos, relaciones, funciones y algoritmos. También trata sobre gráficas, árboles binarios, lenguajes, conjuntos y álgebra booleana.

// URL IMAGEN:
// https://www.elsotano.com/imagenes/9789701/978970107236.JPG

// Ubicacion:
// 30 en  Fac. Ing. Div. Est. Prof. Anex 
// Biblioteca “Mtro. Enrique Rivero Borrell”

// Clasificacion:
// QA162 L54918
Libro(
          titulo: 'Matemáticas discretas',
          autor: 'Lipschutz, Seymour / Lipson, Marc',
          portada:
              'https://www.elsotano.com/imagenes/9789701/978970107236.JPG',
          descripcion:
              'Las matemáticas discretas, el estudio de los sistemas finitos, han adquirido cada vez más importancia en la medida en que ha avanzado la era de las computadoras. Básicamente, la computadora digital es una estructura finita, y muchas de sus propiedades pueden comprenderse e interpretarse en el marco de referencia de los sistemas matemáticos finitos. Este libro, al presentar el material esencial, cumple los requisitos de un curso formal de matemáticas discretas, o como complemento de cualquier texto actual.Este libro, al presentar el material esencial, cumple los requisitos de un curso formal de matemáticas discretas o como complemento de cualquier texto actual. Matemáticas Discretas aborda temas sobre conjuntos, relaciones, funciones y algoritmos. También trata sobre gráficas, árboles binarios, lenguajes, conjuntos y álgebra booleana.',
          ubicacion:
              "30 en  Fac. Ing. Div. Est. Prof. Anex Biblioteca “Mtro. Enrique Rivero Borrell” Clasificacion: QA162 L54918",
          esFavorito: false,
        ),
//         Titulo:
// Matemáticas discretas con aplicaciones
// Autores:
// Epp, Susanna S.
// Descripcion:
// Ofrece una introducción clara a la matemática discreta. Explica conceptos complejos y abstractos con claridad y precisión. Este libro presenta no sólo los temas principales de la matemática discreta, sino también el razonamiento que subyace el pensamiento matemático. Los estudiantes desarrollan la capacidad de pensar en forma abstracta del mismo modo en que ellos estudian las ideas de la lógica y la demostración. Mientras se aprende acerca de conceptos tales como circuitos lógicos y adición de equipo, análisis de algoritmos, pensamiento recursivo, computabilidad, autómatas, criptografía y combinatoria, los estudiantes descubren que las ideas de la matemática discreta subyacen y son esenciales para la ciencia y la tecnología de la era de las computadoras.

// URL IMAGEN:
// https://www.elsotano.com/imagenes/9786074/978607481621.JPG

// Ubicacion:
// 3 en  Fac. Ing. Div. Est. Prof. Anex 
// Biblioteca “Mtro. Enrique Rivero Borrell”

// Clasificacion:
// QA39.2 E6618
Libro(
          titulo: 'Matemáticas discretas con aplicaciones',
          autor: 'Epp, Susanna S.',
          portada:
              'https://www.elsotano.com/imagenes/9786074/978607481621.JPG',
          descripcion:
              'Ofrece una introducción clara a la matemática discreta. Explica conceptos complejos y abstractos con claridad y precisión. Este libro presenta no sólo los temas principales de la matemática discreta, sino también el razonamiento que subyace el pensamiento matemático. Los estudiantes desarrollan la capacidad de pensar en forma abstracta del mismo modo en que ellos estudian las ideas de la lógica y la demostración. Mientras se aprende acerca de conceptos tales como circuitos lógicos y adición de equipo, análisis de algoritmos, pensamiento recursivo, computabilidad, autómatas, criptografía y combinatoria, los estudiantes descubren que las ideas de la matemática discreta subyacen y son esenciales para la ciencia y la tecnología de la era de las computadoras.',
          ubicacion:
              "3 en  Fac. Ing. Div. Est. Prof. Anex Biblioteca “Mtro. Enrique Rivero Borrell” Clasificacion: QA39.2 E6618",
          esFavorito: false,
        ),
//         Titulo:
// Matemáticas discretas con aplicaciones
// Autores:
// Epp, Susanna S.
// Descripcion:
// Ofrece una introducción clara a la matemática discreta. Explica conceptos complejos y abstractos con claridad y precisión. Este libro presenta no sólo los temas principales de la matemática discreta, sino también el razonamiento que subyace el pensamiento matemático. Los estudiantes desarrollan la capacidad de pensar en forma abstracta del mismo modo en que ellos estudian las ideas de la lógica y la demostración. Mientras se aprende acerca de conceptos tales como circuitos lógicos y adición de equipo, análisis de algoritmos, pensamiento recursivo, computabilidad, autómatas, criptografía y combinatoria, los estudiantes descubren que las ideas de la matemática discreta subyacen y son esenciales para la ciencia y la tecnología de la era de las computadoras.

// URL IMAGEN:
// https://www.elsotano.com/imagenes/9786074/978607481621.JPG

// Ubicacion:
// 3 en  Fac. Ing. Div. Est. Prof. Anex 
// Biblioteca “Mtro. Enrique Rivero Borrell”

// Clasificacion:
// QA39.2 E6618

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
            child: SearchBar(
              controller: searchController,
              onChanged: (value) {
                _filtrarLibros(
                    value); // Llamar a la función de filtrado cuando cambie el texto
              },
              leading: const Icon(Icons.search),
              hintText: 'Buscar libros...',
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
