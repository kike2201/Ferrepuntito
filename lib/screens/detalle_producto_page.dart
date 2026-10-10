
import 'package:flutter/material.dart';
import '../models/item_carrito.dart';
import '../services/carrito_service.dart';  

class DetalleProductoPage extends StatelessWidget {
  final String productoId;
  final Map<String, dynamic> datos;

  const DetalleProductoPage({
    super.key,
    required this.productoId,
    required this.datos,
  });

  @override
  Widget build(BuildContext context) {
    final nombre =
        datos['nombre']?.toString() ?? 'Sin nombre';

    final categoria =
        datos['categoria']?.toString() ?? 'Sin categoría';

    final precio =
        (datos['precio'] as num?)?.toInt() ?? 0;

    final stock =
        (datos['stock'] as num?)?.toInt() ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.handyman,
              size: 110,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),

            Text(
              nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              categoria,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Precio: \$$precio',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              stock > 0
                  ? 'Disponible: $stock unidades'
                  : 'Producto sin stock',
              style: TextStyle(
                fontSize: 17,
                color: stock > 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 30),

            
            ElevatedButton.icon(
              onPressed: stock > 0
                  ? () {
                      final item = ItemCarrito(
                        productoId: productoId,
                        nombre: nombre,
                        precio: precio,
                        stockDisponible: stock,
                        cantidad: 1,
                      );

                      final agregado =
                          CarritoService.instancia.agregarProducto(item);

                      if (agregado) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$nombre agregado al carrito',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No puedes agregar más unidades que el stock disponible',
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Agregar al carrito'),
            ),

          ],
        ),
      ),
    );
  }
}
