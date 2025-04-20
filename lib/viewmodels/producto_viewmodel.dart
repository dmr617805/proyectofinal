import 'package:flutter/material.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/reporte_inventario.dart';
import 'package:proyectofinal/repositories/producto_repository.dart';

class ProductoViewModel with ChangeNotifier {
  final ProductoRepository _repo = ProductoRepository();

  List<Producto> _productos = [];
  List<Producto> get productos => _productos;

  /// Cargar todos los productos activos y su inventario correspondiente
  Future<void> cargarProductosConInventario({bool soloActivos = true}) async {
    _productos = await _repo.obtenerTodos(soloActivos: soloActivos);
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
}
