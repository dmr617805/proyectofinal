class MetodoPago {
  final int? idMetodoPago;
  final String codigo;
  final String descripcion;
  final bool isActive;

  MetodoPago({this.idMetodoPago, required this.codigo, required this.descripcion, this.isActive = true});

  factory MetodoPago.fromMap(Map<String, dynamic> map) {
    return MetodoPago(
      idMetodoPago: map['id_metodo_pago'],
      codigo: map['codigo'],
      descripcion: map['descripcion'],
      isActive: map['is_active'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_metodo_pago': idMetodoPago,
      'codigo': codigo,
      'descripcion': descripcion,
      'is_active': isActive ? 1 : 0,
    };
  }

  MetodoPago copyWith({int? idMetodoPago, String? codigo, String? descripcion, bool? isActive}) {
    return MetodoPago(
      idMetodoPago: idMetodoPago ?? this.idMetodoPago,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'MetodoPago(idMetodoPago: $idMetodoPago, codigo: $codigo, descripcion: $descripcion, isActive: $isActive)';
  }
}
