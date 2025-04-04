import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/cliente.dart';

class ClienteRepository {

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar un cliente
  Future<int> crear(Cliente cliente) async {
    return await _databaseHelper.insert('cliente', cliente.toMap());
  }

  //Actualizar un cliente
  Future<int> actualizar(Cliente cliente) async {
    return await _databaseHelper.update(
      'cliente',
      cliente.toMap(),
      'id_cliente = ?',
      [cliente.idCliente],
    );
  }

  //Eliminar un cliente logicamente
  Future<int> eliminar(int idCliente) async {
    return await _databaseHelper.update(
      'cliente',
      {'is_active': 0},
      'id_cliente = ?',
      [idCliente],
    );
  }

  //obtener todos los clientes activos
  Future<List<Cliente>> obtenerTodos({bool soloActivos = true}) async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'cliente',
      whereClause:  soloActivos ? 'is_active = ?' : null,
      whereArgs: soloActivos ? [1] : null,
    );

    return List.generate(maps.length, (i) {
      return Cliente.fromMap(maps[i]);
    });
  }

}