class Inventario {
  final int idSucursal;
  final int idProducto;
  final int cantidadDisponible;

  Inventario({
    required this.idSucursal,
    required this.idProducto,
    required this.cantidadDisponible,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_sucursal': idSucursal,
      'id_producto': idProducto,
      'cantidad_disponible': cantidadDisponible,
    };
  }

  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      idSucursal: map['id_sucursal'],
      idProducto: map['id_producto'],
      cantidadDisponible: map['cantidad_disponible'],
    );
  }

  Inventario copyWith({
    int? idSucursal,
    int? idProducto,
    int? cantidadDisponible,
  }) {
    return Inventario(
      idSucursal: idSucursal ?? this.idSucursal,
      idProducto: idProducto ?? this.idProducto,
      cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
    );
  }

  @override
  String toString() {
    return 'Inventario(idSucursal: $idSucursal, idProducto: $idProducto, cantidadDisponible: $cantidadDisponible)';
  }
}
