class Libro {
  final String titulo;
  final String autor;
  final String portada;
  final String descripcion;
  bool esFavorito; // Nuevo atributo para indicar si el libro es favorito

  Libro({
    required this.titulo,
    required this.autor,
    required this.portada,
    required this.descripcion,
    this.esFavorito = false, // Por defecto, el libro no es favorito
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'portada': portada,
      'descripcion': descripcion,
      'esFavorito': esFavorito, // Incluye el estado de favorito en el mapa
    };
  }

  factory Libro.fromMap(Map<String, dynamic> map) {
    return Libro(
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      portada: map['portada'] ?? '',
      descripcion: map['descripcion'] ?? '',
      esFavorito: map['esFavorito'] ?? false, // Lee el estado de favorito del mapa
    );
  }
}
