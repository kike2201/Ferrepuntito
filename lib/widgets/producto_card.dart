import 'package:flutter/material.dart';

class ProductoCard extends StatelessWidget {
  final String nombre;
  final String categoria;
  final int precio;
  final int stock;
  final VoidCallback onTap;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const ProductoCard({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.onTap,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(
          Icons.handyman,
          color: Colors.orange,
        ),
        title: Text(nombre),
        subtitle: Text(
          'Categoría: $categoria\n'
          'Precio: \$$precio\n'
          'Stock: $stock unidades',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Editar producto',
              onPressed: onEditar,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Eliminar producto',
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
