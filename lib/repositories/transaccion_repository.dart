import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/transaccion.dart';

class TransaccionRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar una transacción por venta realizada
  Future<int> crear(Transaccion transaccion) async {
    return await _databaseHelper.insert('transaccion', transaccion.toMap());
  }
}
