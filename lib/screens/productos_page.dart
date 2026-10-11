
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'agregar_producto_page.dart';
import 'editar_producto_page.dart';
import 'detalle_producto_page.dart';
import 'carrito_page.dart';

import '../services/producto_service.dart';
import '../services/auth_service.dart';
import '../services/carrito_service.dart';
import '../widgets/producto_card.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final ProductoService productoService = ProductoService();
  final TextEditingController buscadorController =
      TextEditingController();

  late final Stream<QuerySnapshot<Map<String, dynamic>>>
      productosStream;

  String textoBusqueda = '';
  String categoriaSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();

    // Mantener una sola suscripcion a Firestore.
    productosStream = productoService.obtenerProductos();
  }

  @override
  void dispose() {
    buscadorController.dispose();
    super.dispose();
  }

  Future<void> eliminarProducto(
    String productoId,
    String nombre,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Seguro que deseas eliminar "$nombre"?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await productoService.eliminarProducto(productoId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Producto eliminado correctamente',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ferrepuntito - Productos'),
        backgroundColor: Colors.orange,
        actions: [
          ListenableBuilder(
            listenable: CarritoService.instancia,
            builder: (context, child) {
              final cantidad =
                  CarritoService.instancia.cantidadTotal;

              return IconButton(
                tooltip: 'Ver carrito ($cantidad unidades)',
                icon: Badge(
                  isLabelVisible: cantidad > 0,
                  label: Text('$cantidad'),
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CarritoPage(),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              try {
                await AuthService().cerrarSesion();
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error al cerrar sesión: $e',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AgregarProductoPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // El buscador queda fuera del StreamBuilder,
          // para evitar que desaparezca al actualizar datos.
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: buscadorController,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: 'Buscar productos',
                hintText: 'Ej. taladro, martillo, sierra...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() {
                  textoBusqueda =
                      valor.toLowerCase().trim();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: productosStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar productos: '
                      '${snapshot.error}',
                    ),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final todosLosProductos =
                    snapshot.data?.docs ?? [];

                final categorias = todosLosProductos
                    .map(
                      (doc) =>
                          (doc.data()['categoria'] ?? '')
                              .toString()
                              .trim(),
                    )
                    .where(
                      (categoria) => categoria.isNotEmpty,
                    )
                    .toSet()
                    .toList()
                  ..sort();

                final categoriaActual =
                    categorias.contains(categoriaSeleccionada)
                        ? categoriaSeleccionada
                        : 'Todas';

                final productos =
                    todosLosProductos.where((documento) {
                  final datos = documento.data();

                  final nombre =
                      (datos['nombre'] ?? '')
                          .toString()
                          .toLowerCase();

                  final categoria =
                      (datos['categoria'] ?? '').toString();

                  final coincideBusqueda =
                      nombre.contains(textoBusqueda);

                  final coincideCategoria =
                      categoriaActual == 'Todas' ||
                      categoria == categoriaActual;

                  return coincideBusqueda &&
                      coincideCategoria;
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: DropdownButtonFormField<String>(
                        key: ValueKey(categoriaActual),
                        initialValue: categoriaActual,
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por categoría',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: 'Todas',
                            child: Text(
                              'Todas las categorías',
                            ),
                          ),
                          ...categorias
                              .where(
                                (categoria) =>
                                    categoria != 'Todas',
                              )
                              .map(
                                (categoria) =>
                                    DropdownMenuItem<String>(
                                  value: categoria,
                                  child: Text(categoria),
                                ),
                              ),
                        ],
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() {
                              categoriaSeleccionada = valor;
                            });
                          }
                        },
                      ),
                    ),

                    Expanded(
                      child: productos.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay productos '
                                'que coincidan con la búsqueda',
                              ),
                            )
                          : ListView.builder(
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                final documento =
                                    productos[index];

                                final producto =
                                    documento.data();

                                final nombre =
                                    producto['nombre']
                                            ?.toString() ??
                                        'Sin nombre';

                                final categoria =
                                    producto['categoria']
                                            ?.toString() ??
                                        'Sin categoría';

                                final precio =
                                    (producto['precio']
                                                as num?)
                                            ?.toInt() ??
                                        0;

                                final stock =
                                    (producto['stock']
                                                as num?)
                                            ?.toInt() ??
                                        0;

                                return ProductoCard(
                                  nombre: nombre,
                                  categoria: categoria,
                                  precio: precio,
                                  stock: stock,

                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetalleProductoPage(
                                          productoId:
                                              documento.id,
                                          datos: producto,
                                        ),
                                      ),
                                    );
                                  },

                                  onEditar: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditarProductoPage(
                                          productoId:
                                              documento.id,
                                          datos: producto,
                                        ),
                                      ),
                                    );
                                  },

                                  onEliminar: () {
                                    eliminarProducto(
                                      documento.id,
                                      nombre,
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
