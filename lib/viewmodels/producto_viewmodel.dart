import 'package:flutter/material.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/inventario.dart';
import 'package:proyectofinal/models/reporte_inventario.dart';
import 'package:proyectofinal/repositories/producto_repository.dart';

class ProductoViewModel with ChangeNotifier {
  final ProductoRepository _repo = ProductoRepository();

  List<Producto> _productos = [];
  final Map<int, List<Inventario>> _inventarioPorProducto = {};

  List<Producto> get productos => _productos;

  /// Retorna el inventario por producto ID
  List<Inventario> obtenerInventarioDeProducto(int idProducto) {
    return _inventarioPorProducto[idProducto] ?? [];
  }

  /// Cargar todos los productos activos y su inventario correspondiente
  Future<void> cargarProductosConInventario({bool soloActivos = true}) async {
    _productos = await _repo.obtenerTodos(soloActivos: soloActivos);
    _inventarioPorProducto.clear();

    notifyListeners();
  }

  /// Guardar producto (crear o actualizar según corresponda)
  Future<void> guardar(Producto producto) async {
    if (producto.idProducto == null) {
      await _repo.crear(producto);
    } else {
      await actualizar(producto);
    }
    await cargarProductosConInventario();
  }


  /// Actualizar producto y su inventario
  Future<void> actualizar(Producto producto) async {
    await _repo.actualizar(producto);

    await _repo.eliminarInventarioPorProducto(producto.idProducto!);
    for (var item in producto.inventario) {
      await _repo.agregarInventario(item);
    }
    
  }

  /// Eliminar producto lógicamente y limpiar su inventario
  Future<void> eliminar(int idProducto) async {
    await _repo.eliminar(idProducto);
    await _repo.eliminarInventarioPorProducto(idProducto);
    await cargarProductosConInventario();
  }


  // Obtener reporte de inventario
  Future<List<ReporteInventario>> obtenerReporteInventario() async {
    return await _repo.obtenerReporteInventario();
  }

  /// Actualizar cantidad de inventario de un producto en una sucursal específica
  Future<void> actualizarInventario(
    int idProducto,
    int idSucursal,
    int nuevaCantidad,
  ) async {
    await _repo.actualizarCantidadInventario(
      idProducto,
      idSucursal,
      nuevaCantidad,
    );
    await cargarProductosConInventario();
  }
}
