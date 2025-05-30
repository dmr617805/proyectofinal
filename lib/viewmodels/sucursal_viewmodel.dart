import 'package:flutter/material.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/repositories/sucursal_repository.dart';

class SucursalViewModel with ChangeNotifier {
  final SucursalRepository _repo = SucursalRepository();
  List<Sucursal> _sucursales = [];

  List<Sucursal> get sucursales => _sucursales;

  Future<void> cargarSucursales() async {
    _sucursales = await _repo.obtenerTodos();
    notifyListeners();
  }

  Future<void> guardar(Sucursal sucursal) async {
    if (sucursal.idSucursal == null) {
      await _repo.crear(sucursal);
    } else {
      await _repo.actualizar(sucursal);
    }
    await cargarSucursales();
  }

  Future<void> eliminar(int id) async {
    await _repo.eliminar(id);
    await cargarSucursales();
  }
}
