import 'package:flutter/material.dart';
import '../services/producto_service.dart';


class EditarProductoPage extends StatefulWidget {
  final String productoId;
  final Map<String, dynamic> datos;

  const EditarProductoPage({
    super.key,
    required this.productoId,
    required this.datos,
  });

  @override
  State<EditarProductoPage> createState() =>
      _EditarProductoPageState();
}

class _EditarProductoPageState
    extends State<EditarProductoPage> {
  late TextEditingController nombreController;
  late TextEditingController precioController;
  late TextEditingController stockController;
  late TextEditingController categoriaController;

  bool guardando = false;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.datos['nombre'].toString(),
    );
    precioController = TextEditingController(
      text: widget.datos['precio'].toString(),
    );
    stockController = TextEditingController(
      text: widget.datos['stock'].toString(),
    );
    categoriaController = TextEditingController(
      text: widget.datos['categoria'].toString(),
    );
  }

  Future<void> actualizarProducto() async {
    final nombre = nombreController.text.trim();
    final categoria = categoriaController.text.trim();
    final precio = int.tryParse(precioController.text.trim());
    final stock = int.tryParse(stockController.text.trim());

    if (nombre.isEmpty ||
        categoria.isEmpty ||
        precio == null ||
        precio <= 0 ||
        stock == null ||
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
     
await ProductoService().actualizarProducto(
  id: widget.productoId,
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
        SnackBar(
          content: Text('Error al actualizar: $e'),
        ),
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
        title: const Text('Editar producto'),
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
              onPressed: guardando ? null : actualizarProducto,
              child: Text(
                guardando
                    ? 'Actualizando...'
                    : 'Guardar cambios',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
