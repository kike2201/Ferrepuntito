
import 'package:flutter/material.dart';

import '../services/carrito_service.dart';
import '../services/compra_service.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  final carrito = CarritoService.instancia;
  final compraService = CompraService();

  bool procesandoCompra = false;

  Future<void> confirmarCompra() async {
    if (procesandoCompra || carrito.productos.isEmpty) {
      return;
    }

    setState(() {
      procesandoCompra = true;
    });

    try {
      // Capturar los productos antes de enviarlos.
      final productos = carrito.productos;

      // Enviar la compra al backend.
      final resultado = await compraService.confirmarCompra(
        productos,
      );

      if (!mounted) return;

      final ventaId = resultado['ventaId'];
      final total = resultado['total'];

      // Vaciar el carrito solamente si la compra fue exitosa.
      carrito.vaciarCarrito();

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('¡Compra confirmada!'),
            content: Text(
              'Tu compra se registró correctamente.\n\n'
              'Número de venta: $ventaId\n'
              'Total: \$$total',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo confirmar la compra:\n$error',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          procesandoCompra = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi carrito'),
        backgroundColor: Colors.orange,
      ),
      body: ListenableBuilder(
        listenable: carrito,
        builder: (context, child) {
          final productos = carrito.productos;

          if (productos.isEmpty) {
            return const Center(
              child: Text('Tu carrito está vacío'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final item = productos[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.shopping_bag,
                          color: Colors.orange,
                        ),
                        title: Text(item.nombre),
                        subtitle: Text(
                          'Precio: \$${item.precio}\n'
                          'Cantidad: ${item.cantidad}\n'
                          'Subtotal: \$${item.subtotal}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: procesandoCompra
                              ? null
                              : () {
                                  carrito.quitarProducto(
                                    item.productoId,
                                  );
                                },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: \$${carrito.total}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: procesandoCompra
                          ? null
                          : confirmarCompra,
                      icon: procesandoCompra
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.payment),
                      label: Text(
                        procesandoCompra
                            ? 'Procesando compra...'
                            : 'Confirmar compra',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
