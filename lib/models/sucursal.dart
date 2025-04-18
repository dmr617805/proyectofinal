class Sucursal {
  final int? idSucursal;
  final String nombre;
  final String ubicacion;
  final bool isActive;

  Sucursal({
    this.idSucursal,
    required this.nombre,
    required this.ubicacion,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_sucursal': idSucursal,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Sucursal.fromMap(Map<String, dynamic> map) {
    return Sucursal(
      idSucursal: map['id_sucursal'],
      nombre: map['nombre'],
      ubicacion: map['ubicacion'],
      isActive: map['is_active'] == 1,
    );
  }

  Sucursal copyWith({
    int? idSucursal,
    String? nombre,
    String? ubicacion,
    bool? isActive,
  }) {
    return Sucursal(
      idSucursal: idSucursal ?? this.idSucursal,
      nombre: nombre ?? this.nombre,
      ubicacion: ubicacion ?? this.ubicacion,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sucursal &&
          runtimeType == other.runtimeType &&
          idSucursal == other.idSucursal;

  @override
  int get hashCode => idSucursal.hashCode;

  @override
  String toString() {
    return 'Sucursal(idSucursal: $idSucursal, nombre: $nombre, ubicacion: $ubicacion, isActive: $isActive)';
  }
}
