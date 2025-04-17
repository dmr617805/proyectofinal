import 'package:proyectofinal/models/producto.dart';

class DetalleVenta {
  final int? idVenta;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final Producto? producto;

  DetalleVenta({
    this.idVenta,
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    this.producto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_venta': idVenta,
      'id_producto': idProducto,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
    };
  }

  factory DetalleVenta.fromMap(Map<String, dynamic> map) {
    return DetalleVenta(
      idVenta: map['id_venta'],
      idProducto: map['id_producto'],
      cantidad: map['cantidad'],
      precioUnitario: map['precio_unitario'] is int
          ? (map['precio_unitario'] as int).toDouble()
          : map['precio_unitario'],
    );
  }

  DetalleVenta copyWith({
    int? idVenta,
    int? idProducto,
    int? cantidad,
    double? precioUnitario,
    Producto? producto,
  }) {
    return DetalleVenta(
      idVenta: idVenta ?? this.idVenta,
      idProducto: idProducto ?? this.idProducto,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      producto: producto ?? this.producto,
    );
  }

  @override
  String toString() {
    return 'DetalleVenta(idVenta: $idVenta, idProducto: $idProducto, cantidad: $cantidad, precioUnitario: $precioUnitario)';
  }
}
