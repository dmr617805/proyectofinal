import 'package:proyectofinal/database/database_helper.dart';
import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/models/metodo_pago.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/models/usuario.dart';
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

        await txn.rawUpdate(
          '''
          UPDATE inventario
          SET cantidad_disponible = cantidad_disponible - ?
          WHERE id_producto = ? AND id_sucursal = ?
        ''',
          [cantidadVendida, productoId, venta.idSucursal],
        );
      }
    });

    return ventaId;
  }

  Future<List<Venta>> obtener({int? idUsuario}) async {
    final db = await _databaseHelper.database;

    final String baseQuery = '''
    SELECT 
      v.id_venta,
      v.fecha,
      v.total,            

      c.id_cliente,
      c.nombre AS cliente_nombre,
      c.correo AS cliente_correo,
      c.telefono AS cliente_telefono,
      c.direccion AS cliente_direccion,

      s.id_sucursal,
      s.nombre AS sucursal_nombre,
      s.ubicacion AS sucursal_ubicacion,

      u.id_usuario,
      u.nombre AS usuario_nombre,
      u.apellido_paterno AS usuario_apellido_paterno,
      u.correo AS usuario_correo,
      u.rol AS usuario_rol,

      mp.id_metodo_pago,
      mp.codigo AS metodo_pago_codigo,
      mp.descripcion AS metodo_pago_descripcion

    FROM venta v
    INNER JOIN cliente c ON v.id_cliente = c.id_cliente
    INNER JOIN sucursal s ON v.id_sucursal = s.id_sucursal
    INNER JOIN usuario u ON v.id_usuario = u.id_usuario
    INNER JOIN metodo_pago mp ON v.id_metodo_pago = mp.id_metodo_pago
  ''';

    // Agregar condición si hay idUsuario esto se usa cuando el usuario
    // es vendedor que solo vea sus ventas
    // es casp de ser admin el puede ver todas las ventas
    final String whereClause =
        idUsuario != null ? 'WHERE v.id_usuario = ?' : '';
    final String orderBy = 'ORDER BY v.fecha DESC';

    final String finalQuery = '$baseQuery $whereClause $orderBy';

    final List<Map<String, dynamic>> rows =
        idUsuario != null
            ? await db.rawQuery(finalQuery, [idUsuario])
            : await db.rawQuery(finalQuery);

    if (rows.isEmpty) return [];

    return rows.map((row) {
      final cliente = Cliente(
        idCliente: row['id_cliente'],
        nombre: row['cliente_nombre'],
        correo: row['cliente_correo'],
        telefono: row['cliente_telefono'],
        direccion: row['cliente_direccion'],
      );

      final sucursal = Sucursal(
        idSucursal: row['id_sucursal'],
        nombre: row['sucursal_nombre'],
        ubicacion: row['sucursal_ubicacion'],
      );

      final usuario = Usuario(
        idUsuario: row['id_usuario'],
        nombre: row['usuario_nombre'],
        apellidoPaterno: row['usuario_apellido_paterno'],
        correo: row['usuario_correo'],
        rol: row['usuario_rol'],
        password: '',
      );

      final metodoPago = MetodoPago(
        idMetodoPago: row['id_metodo_pago'],
        codigo: row['metodo_pago_codigo'],
        descripcion: row['metodo_pago_descripcion'],
      );

      return Venta(
        idVenta: row['id_venta'],
        fecha: DateTime.parse(row['fecha']),
        total: row['total'],
        idSucursal: row['id_sucursal'],
        idCliente: row['id_cliente'],
        idMetodoPago: row['id_metodo_pago'],
        idUsuario: row['id_usuario'],
        cliente: cliente,
        sucursal: sucursal,
        usuario: usuario,
        metodoPago: metodoPago,
      );
    }).toList();
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
