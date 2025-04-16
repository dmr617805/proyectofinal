import 'package:proyectofinal/models/inventario.dart';

class Producto {
  final int? idProducto;
  final String nombre;
  final String? descripcion;
  final double? precio;
  final bool isActive;
  final List<Inventario> inventario;

  Producto({
    this.idProducto,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.isActive = true,
    this.inventario = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      idProducto: map['id_producto'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'] is int ? (map['precio'] as int).toDouble() : map['precio'],
      isActive: map['is_active'] == 1,
    );
  }

  Producto copyWith({
    int? idProducto,
    String? nombre,
    String? descripcion,
    double? precio,
    bool? isActive,
    List<Inventario>? inventario,
  }) {
    return Producto(
      idProducto: idProducto ?? this.idProducto,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      isActive: isActive ?? this.isActive,
      inventario: inventario ?? this.inventario,
    );
  }

  @override
  String toString() {
    return 'Producto(idProducto: $idProducto, nombre: $nombre, descripcion: $descripcion, precio: $precio, isActive: $isActive)';
  }
}
