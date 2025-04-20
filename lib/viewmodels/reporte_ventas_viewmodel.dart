
import 'package:flutter/material.dart';
import 'package:proyectofinal/models/reporte_venta.dart';
import 'package:proyectofinal/repositories/reporte_ventas_repository.dart';

class ReporteVentasViewModel extends ChangeNotifier {
  final ReporteVentasRepository _repo = ReporteVentasRepository();

  List<ReporteVenta> _ventasSucursal = [];
  List<ReporteVenta> _ventasUsuario = [];
  List<ReporteVenta> _ventasProducto = [];

  DateTime fechaInicio = DateTime.now().subtract(Duration(days: 20));
  DateTime fechaFin = DateTime.now();

  List<ReporteVenta> get ventasSucursal => _ventasSucursal;
  List<ReporteVenta> get ventasUsuario => _ventasUsuario;
  List<ReporteVenta> get ventasProducto => _ventasProducto;

  Future<void> cargarReportes() async {
    _ventasSucursal = await _repo.ventasPorSucursal(fechaInicio, fechaFin);
    _ventasUsuario = await _repo.ventasPorUsuario(fechaInicio, fechaFin);
    _ventasProducto = await _repo.ventasPorProducto(fechaInicio, fechaFin);
    notifyListeners();
  }

  void setFechas(DateTime inicio, DateTime fin) {
    fechaInicio = DateTime(inicio.year, inicio.month, inicio.day); // 00:00:00
  fechaFin = DateTime(fin.year, fin.month, fin.day, 23, 59, 59); // 23:59:59
    cargarReportes();
  }
}