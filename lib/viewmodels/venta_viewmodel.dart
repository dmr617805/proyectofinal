import 'package:flutter/material.dart';
import 'package:proyectofinal/models/venta.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/repositories/venta_repository.dart';

class VentaViewModel with ChangeNotifier {
  final VentaRepository _repo = VentaRepository();

  List<Venta> _ventas = [];
  List<Venta> get ventas => _ventas;

  /// Cargar todas las ventas
  Future<void> cargarVentas() async {
    _ventas = await _repo.obtenerTodas();
    notifyListeners();
  }

  /// Registrar una venta con sus detalles
  Future<void> registrarVenta(Venta venta, List<DetalleVenta> detalles) async {
    await _repo.crear(venta, detalles);
    await cargarVentas();
  }
}
