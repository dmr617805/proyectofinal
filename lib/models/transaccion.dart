class Transaccion {
  final int? idTransaccion;
  final String referencia;
  final DateTime fecha;
  final String estatus;
  final int idVenta;

  Transaccion({
    this.idTransaccion,
    required this.referencia,
    required this.fecha,
    required this.estatus,
    required this.idVenta,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_transaccion': idTransaccion,
      'referencia': referencia,
      'fecha': fecha.toIso8601String(),
      'estatus': estatus,
      'id_venta': idVenta,
    };
  }

  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      idTransaccion: map['id_transaccion'],
      referencia: map['referencia'],
      fecha: DateTime.parse(map['fecha']),
      estatus: map['estatus'],
      idVenta: map['id_venta'],
    );
  }

  Transaccion copyWith({
    int? idTransaccion,
    String? referencia,
    DateTime? fecha,
    String? estatus,
    int? idVenta,
  }) {
    return Transaccion(
      idTransaccion: idTransaccion ?? this.idTransaccion,
      referencia: referencia ?? this.referencia,
      fecha: fecha ?? this.fecha,
      estatus: estatus ?? this.estatus,
      idVenta: idVenta ?? this.idVenta,
    );
  }


}
