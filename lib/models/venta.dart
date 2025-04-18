import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/models/usuario.dart';

class Venta {
  final int? idVenta;
  final DateTime fecha;
  final int idSucursal;
  final int idCliente;
  final int idMetodoPago;
  final int idUsuario;
  final double total;
  final Cliente? cliente;
  final Sucursal? sucursal;
  final Usuario? usuario;

  Venta({
    this.idVenta,
    required this.fecha,
    required this.idSucursal,
    required this.idCliente,
    required this.idMetodoPago,
    required this.idUsuario,
    required this.total,
    this.cliente,
    this.sucursal,
    this.usuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_venta': idVenta,
      'fecha': fecha.toIso8601String(),
      'id_sucursal': idSucursal,
      'id_cliente': idCliente,
      'id_metodo_pago': idMetodoPago,
      'id_usuario': idUsuario,
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
      idUsuario: map['id_usuario'],
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
    int? idUsuario,
    double? total,
    Cliente? cliente,
    Sucursal? sucursal,
    Usuario? usuario,
  }) {
    return Venta(
      idVenta: idVenta ?? this.idVenta,
      fecha: fecha ?? this.fecha,
      idSucursal: idSucursal ?? this.idSucursal,
      idCliente: idCliente ?? this.idCliente,
      idMetodoPago: idMetodoPago ?? this.idMetodoPago,
      idUsuario: idUsuario ?? this.idUsuario,
      total: total ?? this.total,
      cliente: cliente ?? this.cliente,
      sucursal: sucursal ?? this.sucursal,
      usuario: usuario ?? this.usuario,
    );
  }

  @override
  String toString() {
    return 'Venta(idVenta: $idVenta, fecha: $fecha, idSucursal: $idSucursal, idCliente: $idCliente, idMetodoPago: $idMetodoPago, total: $total)';
  }
}
