
import 'package:flutter/material.dart';
import '../utils/formato_precio.dart';

class ProductoCard extends StatelessWidget {
  final String nombre;
  final String categoria;
  final int precio;
  final int stock;
  final String imagen;

  final VoidCallback onTap;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const ProductoCard({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    this.imagen = '',
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
        leading: SizedBox(
          width: 64,
          height: 64,
          child: imagen.isEmpty
              ? const Icon(
                  Icons.handyman,
                  color: Colors.orange,
                  size: 32,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagen,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.handyman,
                        color: Colors.orange,
                        size: 32,
                      );
                    },
                  ),
                ),
        ),
        title: Text(nombre),
        subtitle: Text(
          'Categoría: $categoria\n'
          'Precio: ${formatearPrecio(precio)}\n'
          'Stock: $stock unidades',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              tooltip: 'Editar producto',
              onPressed: onEditar,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              tooltip: 'Eliminar producto',
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
