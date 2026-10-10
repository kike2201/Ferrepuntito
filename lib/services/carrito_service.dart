
import 'package:flutter/foundation.dart';

import '../models/item_carrito.dart';

class CarritoService extends ChangeNotifier {
  CarritoService._();

  static final CarritoService instancia = CarritoService._();

  final List<ItemCarrito> _productos = [];

  // Obtener los productos del carrito
  List<ItemCarrito> get productos =>
      List.unmodifiable(_productos);

  // Obtener la cantidad total de unidades
  int get cantidadTotal {
    return _productos.fold(
      0,
      (total, item) => total + item.cantidad,
    );
  }

  // Calcular el valor total del carrito
  int get total {
    return _productos.fold(
      0,
      (total, item) => total + item.subtotal,
    );
  }

  // Agregar un producto
  bool agregarProducto(ItemCarrito nuevoItem) {
    final indice = _productos.indexWhere(
      (item) => item.productoId == nuevoItem.productoId,
    );

    if (indice >= 0) {
      final existente = _productos[indice];

      if (existente.cantidad + nuevoItem.cantidad >
          nuevoItem.stockDisponible) {
        return false;
      }

      existente.cantidad += nuevoItem.cantidad;
    } else {
      if (nuevoItem.cantidad < 1 ||
          nuevoItem.cantidad > nuevoItem.stockDisponible) {
        return false;
      }

      _productos.add(nuevoItem);
    }

    notifyListeners();
    return true;
  }

  // Quitar un producto del carrito
  void quitarProducto(String productoId) {
    _productos.removeWhere(
      (item) => item.productoId == productoId,
    );

    notifyListeners();
  }

  // Vaciar el carrito
  void vaciarCarrito() {
    _productos.clear();
    notifyListeners();
  }
}
