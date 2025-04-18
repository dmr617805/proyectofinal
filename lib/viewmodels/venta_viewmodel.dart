import 'package:flutter/material.dart';
import 'package:proyectofinal/models/filtro_venta.dart';
import 'package:proyectofinal/models/usuario.dart';
import 'package:proyectofinal/models/venta.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/repositories/venta_repository.dart';

class VentaViewModel with ChangeNotifier {
  final VentaRepository _repo = VentaRepository();

  List<Venta> _ventas = [];
  List<Venta> get ventas => _ventas;

  List<Venta> _ventasFiltradas = [];
  List<Venta> get ventasFiltradas => _ventasFiltradas;

  FiltroVenta? _filtroVenta;
  

  /// Cargar todas las ventas
  Future<void> cargarVentas({required Usuario usuario}) async {
    _ventas = await _repo.obtener(
      idUsuario: usuario.esAdmin ? null : usuario.idUsuario,
    );

    _ventasFiltradas = [..._ventas]; 
    if (_filtroVenta != null) {
      filtrarVentas(filtro: _filtroVenta!);
    }

    notifyListeners();
  }

  /// Registrar una venta con sus detalles
  Future<void> registrarVenta(
    Venta venta,
    List<DetalleVenta> detalles
  ) async {
    await _repo.crear(venta, detalles);
    await cargarVentas(usuario: venta.usuario!);
  }

  void filtrarVentas({required FiltroVenta filtro}) {
    _filtroVenta = filtro;
    final ventasOriginales = [..._ventas]; // Lista sin filtrar

    _ventasFiltradas =
        ventasOriginales.where((venta) {
          final coincideFecha =
              filtro.fecha == null ||
              venta.fecha.year == filtro.fecha?.year &&
                  venta.fecha.month == filtro.fecha?.month &&
                  venta.fecha.day == filtro.fecha?.day;

          final coincideSucursal =
              filtro.idSucursal == null || venta.idSucursal == filtro.idSucursal;

          return coincideFecha && coincideSucursal;
        }).toList();

    notifyListeners();
  }

  // limpiar la lista de ventas
  void limpiarVentas() {
    _ventas.clear();
    notifyListeners();
  }
}
