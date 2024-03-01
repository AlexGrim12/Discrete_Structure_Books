class Libro {
  final String titulo;
  final String autor;
  final String portada;
  final String descripcion;
  final String ubicacion; // Nuevo atributo para la ubicación del libro
  bool esFavorito; // Nuevo atributo para indicar si el libro es favorito

  Libro({
    required this.titulo,
    required this.autor,
    required this.portada,
    required this.descripcion,
    this.ubicacion = '', // Por defecto, la ubicación del libro es vacía
    this.esFavorito = false, // Por defecto, el libro no es favorito
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'portada': portada,
      'descripcion': descripcion,
      'ubicacion': ubicacion, // Incluye la ubicación en el mapa
      'esFavorito': esFavorito, // Incluye el estado de favorito en el mapa
    };
  }

  factory Libro.fromMap(Map<String, dynamic> map) {
    return Libro(
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      portada: map['portada'] ?? '',
      descripcion: map['descripcion'] ?? '',
      ubicacion: map['ubicacion'] ?? '', // Lee la ubicación del mapa
      esFavorito: map['esFavorito'] ?? false, // Lee el estado de favorito del mapa
    );
  }
}
