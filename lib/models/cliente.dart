class Cliente {
  final int? idCliente;
  final String nombre;
  final String correo;
  final String telefono;
  final String direccion;

  Cliente({
    this.idCliente,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.direccion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': idCliente,
      'nombre': nombre,
      'correo': correo,
      'telefono': telefono,
      'direccion': direccion,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      idCliente: map['id_cliente'],
      nombre: map['nombre'],
      correo: map['correo'],
      telefono: map['telefono'],
      direccion: map['direccion'],
    );
  }

  Cliente copyWith({
    int? idCliente,
    String? nombre,
    String? correo,
    String? telefono,
    String? direccion,
  }) {
    return Cliente(
      idCliente: idCliente ?? this.idCliente,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
    );
  }

  @override
  String toString() {
    return 'Cliente(idCliente: $idCliente, nombre: $nombre, correo: $correo, telefono: $telefono, direccion: $direccion)';
  }
}
