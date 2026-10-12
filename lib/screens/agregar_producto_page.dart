
import 'package:flutter/material.dart';

import '../services/producto_service.dart';
import '../constants/categorias.dart';

class AgregarProductoPage extends StatefulWidget {
  const AgregarProductoPage({super.key});

  @override
  State<AgregarProductoPage> createState() =>
      _AgregarProductoPageState();
}

class _AgregarProductoPageState extends State<AgregarProductoPage> {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final stockController = TextEditingController();
  final imagenController = TextEditingController();

  String? categoriaSeleccionada;
  bool guardando = false;

  Future<void> guardarProducto() async {
    final nombre = nombreController.text.trim();
    final imagen = imagenController.text.trim();
    final precio = int.tryParse(precioController.text.trim());
    final stock = int.tryParse(stockController.text.trim());
    final categoria = categoriaSeleccionada;

    if (nombre.isEmpty ||
        categoria == null ||
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
      imagen: imagen,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
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
    imagenController.dispose();
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

            DropdownButtonFormField<String>(
              initialValue: categoriaSeleccionada,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: categoriasProductos.map((categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(
                    categoria,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  categoriaSeleccionada = valor;
                });
              },
            ),

            const SizedBox(height: 16),
            TextField(
              controller: imagenController,
              decoration: const InputDecoration(
                labelText: 'Imagen del producto',
                hintText: 'assets/productos/martillo.jpg',
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(),
                ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: guardando ? null : guardarProducto,
              child: Text(
                guardando ? 'Guardando...' : 'Guardar producto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
