class MetodoPago {
  final int? idMetodoPago;
  final String nombre;
  final bool isActive;

  MetodoPago({this.idMetodoPago, required this.nombre, this.isActive = true});

  factory MetodoPago.fromMap(Map<String, dynamic> map) {
    return MetodoPago(
      idMetodoPago: map['id_metodo_pago'],
      nombre: map['nombre'],
      isActive: map['is_active'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_metodo_pago': idMetodoPago,
      'nombre': nombre,
      'is_active': isActive ? 1 : 0,
    };
  }

  MetodoPago copyWith({int? idMetodoPago, String? nombre, bool? isActive}) {
    return MetodoPago(
      idMetodoPago: idMetodoPago ?? this.idMetodoPago,
      nombre: nombre ?? this.nombre,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'MetodoPago(idMetodoPago: $idMetodoPago, nombre: $nombre, isActive: $isActive)';
  }
}
