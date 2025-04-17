import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/metodo_pago.dart';

class MetodoPagoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Obtener todos los métodos de pago
  Future<List<MetodoPago>> obtenerTodos({bool soloActivos = true}) async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'metodo_pago',
      whereClause: soloActivos ? 'is_active = ?' : null,
      whereArgs: soloActivos ? [1] : null,
    );

    return List.generate(maps.length, (i) {
      return MetodoPago.fromMap(maps[i]);
    });
  }
}
