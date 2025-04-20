import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/reporte_venta.dart';

class ReporteVentasRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<ReporteVenta>> ventasPorSucursal(
    DateTime inicio,
    DateTime fin,
  ) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT s.nombre, SUM(v.total) as total
      FROM venta v
      INNER JOIN sucursal s ON s.id_sucursal = v.id_sucursal
      WHERE v.fecha >= ? AND v.fecha <= ?
      GROUP BY s.nombre
    ''',
      [inicio.toIso8601String(), fin.toIso8601String()],
    );

    return result.map((row) => ReporteVenta.fromMap(row)).toList();
  }

  Future<List<ReporteVenta>> ventasPorUsuario(
    DateTime inicio,
    DateTime fin,
  ) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT u.nombre || ' ' || u.apellido_paterno as nombre, SUM(v.total) as total
      FROM venta v
      INNER JOIN usuario u ON u.id_usuario = v.id_usuario
      WHERE v.fecha >= ? AND v.fecha <= ?
      GROUP BY u.id_usuario
    ''',
      [inicio.toIso8601String(), fin.toIso8601String()],
    );

    return result.map((row) => ReporteVenta.fromMap(row)).toList();

  }

  Future<List<ReporteVenta>> ventasPorProducto(
    DateTime inicio,
    DateTime fin,
  ) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT p.nombre, SUM(dv.cantidad * dv.precio_unitario) as total
      FROM detalle_venta dv
      INNER JOIN producto p ON p.id_producto = dv.id_producto
      INNER JOIN venta v ON v.id_venta = dv.id_venta
      WHERE v.fecha >= ? AND v.fecha <= ?
      GROUP BY p.id_producto
    ''',
      [inicio.toIso8601String(), fin.toIso8601String()],
    );

    return result.map((row) => ReporteVenta.fromMap(row)).toList();

  }
}
