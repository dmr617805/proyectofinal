import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/sucursal.dart';

class SucursalRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar una sucursal
  Future<int> crear(Sucursal sucursal) async {
    return await _databaseHelper.insert('sucursal', sucursal.toMap());
  }

  // Actualizar una sucursal
  Future<int> actualizar(Sucursal sucursal) async {
    return await _databaseHelper.update(
      'sucursal',
      sucursal.toMap(),
      'id_sucursal = ?',
      [sucursal.idSucursal],
    );
  }

  // Eliminar lógicamente una sucursal
  Future<int> eliminar(int idSucursal) async {
    return await _databaseHelper.update(
      'sucursal',
      {'is_active': 0},
      'id_sucursal = ?',
      [idSucursal],
    );
  }

  // Obtener todas las sucursales activas
  Future<List<Sucursal>> obtenerTodos({bool soloActivos = true}) async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'sucursal',
      whereClause: soloActivos ? 'is_active = ?' : null,
      whereArgs: soloActivos ? [1] : null,
    );

    return List.generate(maps.length, (i) {
      return Sucursal.fromMap(maps[i]);
    });
  }
}
