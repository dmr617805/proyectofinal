class Venta {
  final int? idVenta;
  final DateTime fecha;
  final int idSucursal;
  final int idCliente;
  final int idMetodoPago;
  final double total;

  Venta({
    this.idVenta,
    required this.fecha,
    required this.idSucursal,
    required this.idCliente,
    required this.idMetodoPago,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_venta': idVenta,
      'fecha': fecha.toIso8601String(),
      'id_sucursal': idSucursal,
      'id_cliente': idCliente,
      'id_metodo_pago': idMetodoPago,
      'total': total,
    };
  }

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      idVenta: map['id_venta'],
      fecha: DateTime.parse(map['fecha']),
      idSucursal: map['id_sucursal'],
      idCliente: map['id_cliente'],
      idMetodoPago: map['id_metodo_pago'],
      total:
          map['total'] is int ? (map['total'] as int).toDouble() : map['total'],
    );
  }

  Venta copyWith({
    int? idVenta,
    DateTime? fecha,
    int? idSucursal,
    int? idCliente,
    int? idMetodoPago,
    double? total,
  }) {
    return Venta(
      idVenta: idVenta ?? this.idVenta,
      fecha: fecha ?? this.fecha,
      idSucursal: idSucursal ?? this.idSucursal,
      idCliente: idCliente ?? this.idCliente,
      idMetodoPago: idMetodoPago ?? this.idMetodoPago,
      total: total ?? this.total,
    );
  }

  @override
  String toString() {
    return 'Venta(idVenta: $idVenta, fecha: $fecha, idSucursal: $idSucursal, idCliente: $idCliente, idMetodoPago: $idMetodoPago, total: $total)';
  }
}
