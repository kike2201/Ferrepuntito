import 'package:flutter/material.dart';
import '../services/producto_service.dart';


class AgregarProductoPage extends StatefulWidget {
  const AgregarProductoPage({super.key});

  @override
  State<AgregarProductoPage> createState() =>
      _AgregarProductoPageState();
}

class _AgregarProductoPageState
    extends State<AgregarProductoPage> {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final stockController = TextEditingController();
  final categoriaController = TextEditingController();

  bool guardando = false;

  Future<void> guardarProducto() async {
    final nombre = nombreController.text.trim();
    final categoria = categoriaController.text.trim();
    final precio = int.tryParse(precioController.text.trim());
    final stock = int.tryParse(stockController.text.trim());

    if (nombre.isEmpty ||
        categoria.isEmpty ||
        precio == null ||
        stock == null ||
        precio <= 0 ||
        stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisa los datos ingresados'),
        ),
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    try {
      
await ProductoService().agregarProducto(
  nombre: nombre,
  precio: precio,
  stock: stock,
  categoria: categoria,
);


      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    stockController.dispose();
    categoriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio en pesos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock disponible',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoriaController,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: guardando ? null : guardarProducto,
              child: Text(
                guardando
                    ? 'Guardando...'
                    : 'Guardar producto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}