import 'package:flutter/material.dart';
import 'package:proyectofinal/models/usuario.dart';
import 'package:proyectofinal/models/venta.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/repositories/venta_repository.dart';

class VentaViewModel with ChangeNotifier {
  final VentaRepository _repo = VentaRepository();

  List<Venta> _ventas = [];
  List<Venta> get ventas => _ventas;

  /// Cargar todas las ventas
  Future<void> cargarVentas({required Usuario usuario}) async {
    _ventas = await _repo.obtener(idUsuario: usuario.esAdmin ? null : usuario.idUsuario);
    notifyListeners();
  }

  /// Registrar una venta con sus detalles
  Future<void> registrarVenta(Venta venta, List<DetalleVenta> detalles, Usuario usuario) async {
    await _repo.crear(venta, detalles);
    await cargarVentas(usuario: usuario);
  }

  // limpiar la lista de ventas
  void limpiarVentas() {
    _ventas.clear();
    notifyListeners();
  }
}
