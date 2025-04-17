import 'package:flutter/material.dart';
import 'package:proyectofinal/models/metodo_pago.dart';

class MetodoPagoCard extends StatelessWidget {
  final MetodoPago metodoPago;
  final bool isSelect;
  final VoidCallback onTap;

  const MetodoPagoCard({
    super.key,
    required this.metodoPago,
    required this.isSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelect ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: isSelect ? 2 : 1,
          color: isSelect ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                _getPaymentIcon(metodoPago.codigo),
                size: 32,
                color: isSelect ? Theme.of(context).primaryColor : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  metodoPago.descripcion,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelect
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                  ),
                ),
              ),
              if (isSelect) Icon(Icons.check_circle),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'efectivo':
        return Icons.money;
      case 'tarjeta_credito':
        return Icons.credit_card;
      case 'tarjeta_debito':
        return Icons.credit_card;
      case 'paypal':
        return Icons.paypal;
      case 'transferencia_bancaria':
        return Icons.account_balance;
      default:
        return Icons.money;
    }
  }
}
