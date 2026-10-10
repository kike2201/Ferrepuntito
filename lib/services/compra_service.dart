
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/item_carrito.dart';

class CompraService {
  // Preparar los productos que enviaremos al backend.
  Map<String, dynamic> prepararCompra(
    List<ItemCarrito> productos,
  ) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Debes iniciar sesión para comprar');
    }

    if (productos.isEmpty) {
      throw Exception('El carrito está vacío');
    }

    return {
      'productos': productos.map((item) {
        return {
          'productoId': item.productoId,
          'cantidad': item.cantidad,
        };
      }).toList(),
    };
  }

  // Enviar la compra al backend local de Firebase Functions.
  Future<Map<String, dynamic>> confirmarCompra(
    List<ItemCarrito> productos,
  ) async {
    const usarEmuladores = bool.fromEnvironment(
      'USE_FIREBASE_EMULATORS',
      defaultValue: false,
    );

    if (!usarEmuladores || kReleaseMode) {
      throw Exception(
        'La compra requiere un backend configurado. '
        'Por ahora solo está disponible en modo de pruebas.',
      );
    }

    final datosCompra = prepararCompra(productos);

    final usuario = FirebaseAuth.instance.currentUser!;

    // Obtener la credencial del usuario autenticado.
    final token = await usuario.getIdToken();

    final url = Uri.parse(
      'http://10.0.2.2:5001/'
      'ferrepuntito/us-central1/procesarCompra',
    );

    // Enviar la solicitud al backend.
    final respuesta = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(datosCompra),
    ).timeout(const Duration(seconds: 20));

    final resultado = jsonDecode(respuesta.body);

    if (resultado is! Map<String, dynamic>) {
      throw Exception('Respuesta inesperada del servidor');
    }

    if (respuesta.statusCode == 200) {
      return resultado;
    }

    if (respuesta.statusCode == 409) {
      throw Exception(
        'Stock insuficiente. Revisa los productos del carrito.',
      );
    }

    if (respuesta.statusCode == 401) {
      throw Exception(
        'Tu sesión no es válida. Vuelve a iniciar sesión.',
      );
    }

    throw Exception(
      resultado['error'] ??
          resultado['mensaje'] ??
          'No fue posible confirmar la compra',
    );
  }
}
