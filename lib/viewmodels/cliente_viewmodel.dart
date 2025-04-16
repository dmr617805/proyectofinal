
import 'package:flutter/material.dart';
import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/repositories/cliente_repository.dart';

class ClienteViewModel with ChangeNotifier  {
  final ClienteRepository _repo = ClienteRepository();
  List<Cliente> _clientes = [];

  List<Cliente> get clientes => _clientes;

  Future<void> cargarClientes() async {
    _clientes = await _repo.obtenerTodos();
    notifyListeners();
  }

  Future<void> guardar(Cliente cliente) async {
    if (cliente.idCliente == null) {
      await _repo.crear(cliente);
    } else {
      await _repo.actualizar(cliente);
    }    
    await cargarClientes();
  }


  Future<void> eliminar(int id) async {
    await _repo.eliminar(id);
    await cargarClientes();
  }
}
