class ReporteVenta {
  final String nombre;
  final double total;

  ReporteVenta({required this.nombre, required this.total});

  factory ReporteVenta.fromMap(Map<String, dynamic> map) {
    return ReporteVenta(
      nombre: map['nombre'] ?? '',
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

}
