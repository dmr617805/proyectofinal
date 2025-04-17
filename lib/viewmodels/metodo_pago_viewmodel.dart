import 'package:flutter/material.dart';
import 'package:proyectofinal/models/metodo_pago.dart';
import 'package:proyectofinal/repositories/metodo_pago_repository.dart';

class MetodoPagoViewmodel with ChangeNotifier {
  final MetodoPagoRepository _repo = MetodoPagoRepository();
  List<MetodoPago> _metodosPago = [];
  List<MetodoPago> get metodosPago => _metodosPago;

  // Cargar Metodos de pago
  Future<void> cargarMetodosPago() async {
    _metodosPago = await _repo.obtenerTodos();
    notifyListeners();
  }
}
