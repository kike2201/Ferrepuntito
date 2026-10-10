
class ItemCarrito {
  final String productoId;
  final String nombre;
  final int precio;
  final int stockDisponible;
  int cantidad;

  ItemCarrito({
    required this.productoId,
    required this.nombre,
    required this.precio,
    required this.stockDisponible,
    this.cantidad = 1,
  });

  int get subtotal {
    return precio * cantidad;
  }
}
