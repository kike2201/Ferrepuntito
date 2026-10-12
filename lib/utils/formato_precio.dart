
String formatearPrecio(int precio) {
  final numero = precio.toString();
  final resultado = StringBuffer();

  for (int i = 0; i < numero.length; i++) {
    if (i > 0 && (numero.length - i) % 3 == 0) {
      resultado.write('.');
    }
    resultado.write(numero[i]);
  }

  return '\$$resultado';
}
