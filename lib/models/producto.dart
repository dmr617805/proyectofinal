import 'package:proyectofinal/models/inventario.dart';

class Producto {
  final int? idProducto;
  final String nombre;
  final String? descripcion;
  final double? precio;
  final int cantidadMinima;
  final bool isActive;
  final List<Inventario> inventario;

  Producto({
    this.idProducto,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.cantidadMinima = 0,
    this.isActive = true,
    this.inventario = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'cantidad_minima': cantidadMinima,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      idProducto: map['id_producto'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'] is int ? (map['precio'] as int).toDouble() : map['precio'],
      cantidadMinima: map['cantidad_minima'] ?? 0,
      isActive: map['is_active'] == 1,
    );
  }

  Producto copyWith({
    int? idProducto,
    String? nombre,
    String? descripcion,
    double? precio,
    int? cantidadMinima,
    bool? isActive,
    List<Inventario>? inventario,
  }) {
    return Producto(
      idProducto: idProducto ?? this.idProducto,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      cantidadMinima: cantidadMinima ?? this.cantidadMinima,
      isActive: isActive ?? this.isActive,
      inventario: inventario ?? this.inventario,
    );
  }

  @override
  String toString() {
    return 'Producto(idProducto: $idProducto, nombre: $nombre, descripcion: $descripcion, precio: $precio, isActive: $isActive)';
  }
}
