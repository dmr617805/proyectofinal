
import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/usuario.dart';

class UsuarioRepository {
    final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar un usuario
  Future<int> crear(Usuario usuario) async {
    return await _databaseHelper.insert('usuario', usuario.toMap());
  }

  // Actualizar un usuario
  Future<int> actualizar(Usuario usuario) async {
    return await _databaseHelper.update(
      'usuario',
      usuario.toMap(),
      'id_usuario = ?',
      [usuario.idUsuario],
    );
  }

  // Eliminar lógicamente un usuario (cambiar is_active a 0)
  Future<int> eliminar(int idUsuario) async {
    return await _databaseHelper.update(
      'usuario',
      {'is_active': 0},
      'id_usuario = ?',
      [idUsuario],
    );
  }

  // Obtener todos los usuarios (opcionalmente solo los activos)
  Future<List<Usuario>> obtenerTodos({bool soloActivos = true}) async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'usuario',
      whereClause: soloActivos ? 'is_active = ?' : null,
      whereArgs: soloActivos ? [1] : null,
    );

    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }


  // Validar el inicio de sesión de un usuario 
  Future<Usuario?> login(String correo, String password) async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'usuario',
      whereClause: 'correo = ? AND password = ?',
      whereArgs: [correo, password],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }

    return null;
  }

  // Obtener un usuario por correo
  Future<Usuario?> obtenerPorCorreo(String correo) async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'usuario',
      whereClause: 'correo = ?',
      whereArgs: [correo],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }

    return null;
  }

  // Obtener un usuario por ID
  Future<Usuario?> obtenerPorId(int idUsuario) async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'usuario',
      whereClause: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }

    return null;
  }
}