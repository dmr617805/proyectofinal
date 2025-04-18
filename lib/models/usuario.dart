class Usuario {
  final int? idUsuario;
  final String nombre;
  final String apellidoPaterno;
  final String? apellidoMaterno;
  final String correo;
  final String password;
  final String rol;
  final bool isActive;

  Usuario({
    this.idUsuario,
    required this.nombre,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    required this.correo,
    required this.password,
    required this.rol,
    this.isActive = true,
  });

  bool get esAdmin => rol == 'administrador';
  bool get esVendedor => rol == 'vendedor';

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      nombre: map['nombre'],
      apellidoPaterno: map['apellido_paterno'],
      apellidoMaterno: map['apellido_materno'],
      correo: map['correo'],
      password: map['password'],
      rol: map['rol'],
      isActive: map['is_active'] == 1,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'correo': correo,
      'password': password,
      'rol': rol,
      'is_active': isActive ? 1 : 0,
    };
  }
}
