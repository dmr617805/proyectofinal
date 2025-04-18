import 'package:flutter/material.dart';
import 'package:proyectofinal/models/usuario.dart';
import 'package:proyectofinal/repositories/usuario_repository.dart';

class UsuarioViewModel with ChangeNotifier {
  final UsuarioRepository _repo = UsuarioRepository();
  List<Usuario> _usuarios = [];

  List<Usuario> get usuarios => _usuarios;

  Usuario? _usuarioActual;
  Usuario? get usuario => _usuarioActual;

  // Cargar todos los usuarios activos
  Future<void> cargarUsuarios() async {
    _usuarios = await _repo.obtenerTodos();
    notifyListeners();
  }

  // Guardar o actualizar un usuario
  Future<void> guardar(Usuario usuario) async {
    if (usuario.idUsuario == null) {
      await _repo.crear(usuario);
    } else {
      await _repo.actualizar(usuario);
    }
    await cargarUsuarios();
  }

  // Eliminar (lógico) un usuario
  Future<void> eliminar(int id) async {
    await _repo.eliminar(id);
    await cargarUsuarios();
  }

  // Validar el inicio de sesión de un usuario
  Future<void> login(String correo, String contrasena) async {
    _usuarioActual =  await _repo.login(correo, contrasena);
     notifyListeners();    
  }

  // Cerrar sesión
  void logout() {
    _usuarioActual = null;
    notifyListeners();
  }

}
