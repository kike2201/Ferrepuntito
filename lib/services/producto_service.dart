
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoService {
  final CollectionReference<Map<String, dynamic>> _productos =
      FirebaseFirestore.instance.collection('productos');

  // LEER productos en tiempo real
  Stream<QuerySnapshot<Map<String, dynamic>>> obtenerProductos() {
    return _productos.snapshots();
  }

  // CREAR un producto
  Future<void> agregarProducto({
    required String nombre,
    required int precio,
    required int stock,
    required String categoria,
  }) async {
    await _productos.add({
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'categoria': categoria,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }

  // ACTUALIZAR un producto
  Future<void> actualizarProducto({
    required String id,
    required String nombre,
    required int precio,
    required int stock,
    required String categoria,
  }) async {
    await _productos.doc(id).update({
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'categoria': categoria,
    });
  }

  // ELIMINAR un producto
  Future<void> eliminarProducto(String id) async {
    await _productos.doc(id).delete();
  }
}
