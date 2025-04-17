import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/models/venta.dart';

class VentaRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;




  // Crear una venta con sus detalles
  Future<int> crear(Venta venta, List<DetalleVenta> detalles) async {
    final db = await _databaseHelper.database;
    int ventaId = 0;

    await db.transaction((txn) async {
      ventaId = await txn.insert('venta', venta.toMap());

      for (final detalle in detalles) {
        await txn.insert('detalle_venta', {
          'id_venta': ventaId,
          'id_producto': detalle.idProducto,
          'cantidad': detalle.cantidad,
          'precio_unitario': detalle.precioUnitario,
        });

        // Actualizar inventario restando la cantidad vendida
        final productoId = detalle.idProducto;
        final cantidadVendida = detalle.cantidad;

        await txn.rawUpdate('''
          UPDATE inventario
          SET cantidad_disponible = cantidad_disponible - ?
          WHERE id_producto = ? AND id_sucursal = ?
        ''', [cantidadVendida, venta.idSucursal, productoId]);
      }
    });

    return ventaId;
  }

  // Obtener todas las ventas
  Future<List<Venta>> obtenerTodas() async {
    final List<Map<String, dynamic>> maps = await _databaseHelper.query('venta');

    return maps.map((map) => Venta.fromMap(map)).toList();
  }

  // Obtener detalles de una venta
  Future<List<DetalleVenta>> obtenerDetallesPorVenta(int idVenta) async {
    final maps = await _databaseHelper.query(
      'detalle_venta',
      whereClause: 'id_venta = ?',
      whereArgs: [idVenta],
    );

    return maps.map((map) => DetalleVenta.fromMap(map)).toList();
  }

  // Obtener una venta con detalles
  Future<Map<String, dynamic>> obtenerVentaCompleta(int idVenta) async {
    final ventaMap = await _databaseHelper.query(
      'venta',
      whereClause: 'id_venta = ?',
      whereArgs: [idVenta],
    );

    if (ventaMap.isEmpty) return {};

    final venta = Venta.fromMap(ventaMap.first);
    final detalles = await obtenerDetallesPorVenta(idVenta);

    return {
      'venta': venta,
      'detalles': detalles,
    };
  }

  // Eliminar lógicamente una venta (si aplicara is_active en tabla venta)
  Future<int> eliminar(int idVenta) async {
    return await _databaseHelper.update(
      'venta',
      {'is_active': 0},
      'id_venta = ?',
      [idVenta],
    );
  }
}
