import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'agregar_producto_page.dart';
import 'editar_producto_page.dart';
import '../services/producto_service.dart';
import '../services/auth_service.dart';
import 'detalle_producto_page.dart';
import 'carrito_page.dart';
import '../services/carrito_service.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  String textoBusqueda = '';
  String categoriaSeleccionada = 'Todas';

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
    final cantidad = CarritoService.instancia.cantidadTotal;

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
            builder: (context) => const CarritoPage(),
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
              content: Text('Error al cerrar sesión: $e'),
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
        builder: (context) => const AgregarProductoPage(),
      ),
    );
  },
  child: const Icon(Icons.add),
),
      
      
body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Buscar productos',
          hintText: 'Ej. taladro, martillo, sierra...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (valor) {
          setState(() {
            textoBusqueda = valor.toLowerCase().trim();
          });
        },
      ),
    ),
    
StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: ProductoService().obtenerProductos(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const SizedBox.shrink();
    }

    final categorias = snapshot.data!.docs
        .map((doc) =>
            (doc.data()['categoria'] ?? '').toString().trim())
        .where((categoria) => categoria.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: DropdownButtonFormField<String>(
        value: categorias.contains(categoriaSeleccionada)
            ? categoriaSeleccionada
            : 'Todas',
        decoration: const InputDecoration(
          labelText: 'Filtrar por categoría',
          prefixIcon: Icon(Icons.category),
          border: OutlineInputBorder(),
        ),
        items: [
          const DropdownMenuItem<String>(
            value: 'Todas',
            child: Text('Todas las categorías'),
          ),
          ...categorias
              .where((categoria) => categoria != 'Todas')
              .map(
                (categoria) => DropdownMenuItem<String>(
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
    );
  },
),

    
    Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
stream: ProductoService().obtenerProductos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar productos: ${snapshot.error}',
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

        
              final todosLosProductos = snapshot.data!.docs;

                            
              final productos = todosLosProductos.where((documento) {
                final datos = documento.data();

                final nombre =
                    (datos['nombre'] ?? '').toString().toLowerCase();

                final categoria =
                    (datos['categoria'] ?? '').toString();

                final coincideBusqueda = nombre.contains(textoBusqueda);

                final coincideCategoria =
                    categoriaSeleccionada == 'Todas' ||
                    categoria == categoriaSeleccionada;

                return coincideBusqueda && coincideCategoria;
              }).toList();



          if (productos.isEmpty) {
            return const Center(
              child: Text('No hay productos registrados'),
            );
          }

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index].data();

              final nombre =
                  producto['nombre']?.toString() ?? 'Sin nombre';
              final categoria =
                  producto['categoria']?.toString() ?? 'Sin categoría';
              final precio =
                  (producto['precio'] as num?)?.toInt() ?? 0;
              final stock =
                  (producto['stock'] as num?)?.toInt() ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleProductoPage(
                        productoId: productos[index].id,
                        datos: producto,
                      ),
                    ),
                  );
                },

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
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarProductoPage(
              productoId: productos[index].id,
              datos: producto,
            ),
          ),
        );
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () async {
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

        if (confirmar != true || !context.mounted) return;

        try {
          
        await ProductoService().eliminarProducto(
              productos[index].id,
          );


          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado correctamente'),
            ),
          );
        } catch (e) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
            ),
          );
        }
      },
    ),
  ],
),

                ),
              );
           
            },
          );
        },
      ),
    ),
  ],
),
    );
  }
}
