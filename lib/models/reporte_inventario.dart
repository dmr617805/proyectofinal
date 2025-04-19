class ReporteInventario {
    final int? idProducto;
    final int? idSucursal;
    final String producto;
    final String sucursal;
    final int cantidadDisponible;
    final int cantidadMinima;
    final double precio;


    ReporteInventario({
        required this.idProducto,
        required this.idSucursal,
        required this.producto,
        required this.sucursal,
        required this.cantidadDisponible,
        required this.cantidadMinima,
        required this.precio,
    });

    Map<String, dynamic> toMap() {
        return {
            'id_producto': idProducto,
            'id_sucursal': idSucursal,
            'producto': producto,
            'sucursal': sucursal,
            'cantidad_disponible': cantidadDisponible,
            'cantidad_minima': cantidadMinima,
            'precio': precio,
        };
    }

    factory ReporteInventario.fromMap(Map<String, dynamic> map) {
        return ReporteInventario(
            idProducto: map['id_producto'],
            idSucursal: map['id_sucursal'],
            producto: map['producto'],
            sucursal: map['sucursal'],
            cantidadDisponible: map['cantidad_disponible'],
            cantidadMinima: map['cantidad_minima'],
            precio: map['precio'] is int ? (map['precio'] as int).toDouble() : map['precio'],
        );
    }

    ReporteInventario copyWith({
        int? idProducto,
        int? idSucursal,
        String? producto,
        String? sucursal,
        int? cantidadDisponible,
        int? cantidadMinima,
        double? precio,
    }) {
        return ReporteInventario(
            idProducto: idProducto ?? this.idProducto,
            idSucursal: idSucursal ?? this.idSucursal,
            producto: producto ?? this.producto,
            sucursal: sucursal ?? this.sucursal,
            cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
            cantidadMinima: cantidadMinima ?? this.cantidadMinima,
            precio: precio ?? this.precio,
        );
    } 
  
}