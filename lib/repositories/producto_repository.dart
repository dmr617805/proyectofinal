import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/inventario.dart';

class ProductoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insertar un producto y su inventario
  Future<int> crear(Producto producto) async {
    final db = await _databaseHelper.database;
    int productoId = 0;

    await db.transaction((txn) async {
      productoId = await txn.insert('producto', producto.toMap());

      for (final inv in producto.inventario) {
        await txn.insert('inventario', {
          'id_producto': productoId,
          'id_sucursal': inv.idSucursal,
          'cantidad_disponible': inv.cantidadDisponible,
        });
      }
    });

    return productoId;
  }

  // Actualizar un producto
  Future<int> actualizar(Producto producto) async {
    return await _databaseHelper.update(
      'producto',
      producto.toMap(),
      'id_producto = ?',
      [producto.idProducto],
    );
  }

  // Eliminar lógicamente un producto
  Future<int> eliminar(int idProducto) async {
    return await _databaseHelper.update(
      'producto',
      {'is_active': 0},
      'id_producto = ?',
      [idProducto],
    );
  }

  // Obtener todos los productos activos
  Future<List<Producto>> obtenerTodos({bool soloActivos = true}) async {
    List<Producto> productos = [];

    final List<Map<String, dynamic>> maps = await _databaseHelper.query(
      'producto',
      whereClause: soloActivos ? 'is_active = ?' : null,
      whereArgs: soloActivos ? [1] : null,
    );

    maps.map((map) =>  productos.add(Producto.fromMap(map))).toList();

    // Obtener inventario para cada producto
    for (int i = 0; i < productos.length; i++) {
      final inventario = await obtenerInventarioPorProducto(
        productos[i].idProducto!,
      );
      productos[i] = productos[i].copyWith(inventario: inventario);
    }

    return productos;
  }

  // Obtener inventario por producto
  Future<List<Inventario>> obtenerInventarioPorProducto(int idProducto) async {
    final maps = await _databaseHelper.query(
      'inventario',
      whereClause: 'id_producto = ?',
      whereArgs: [idProducto],
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => Inventario.fromMap(map)).toList();
  }

  // Agregar inventario a un producto
  Future<int> agregarInventario(Inventario inventario) async {
    return await _databaseHelper.insert('inventario', inventario.toMap());
  }

  // Eliminar inventario por producto
  Future<int> eliminarInventarioPorProducto(int idProducto) async {
    return await _databaseHelper.delete('inventario', 'id_producto = ?', [
      idProducto,
    ]);
  }

  // Actualizar inventario de un producto para una sucursal
  Future<int> actualizarInventario(Inventario inventario) async {
    return await _databaseHelper.update(
      'inventario',
      inventario.toMap(),
      'id_producto = ? AND id_sucursal = ?',
      [inventario.idProducto, inventario.idSucursal],
    );
  }

  // Actualizar cantidad de inventario de un producto en una sucursal específica
  Future<int> actualizarCantidadInventario(
    int idProducto,
    int idSucursal,
    int nuevaCantidad,
  ) async {
    return await _databaseHelper.update(
      'inventario',
      {'cantidad_disponible': nuevaCantidad},
      'id_producto = ? AND id_sucursal = ?',
      [idProducto, idSucursal],
    );
  }
}
