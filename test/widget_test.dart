
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_movil/widgets/producto_card.dart';

void main() {
  group('ProductoCard', () {
    testWidgets('Muestra los datos del producto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductoCard(
              nombre: 'Martillo',
              categoria: 'Herramientas',
              precio: 5990,
              stock: 10,
              onTap: () {},
              onEditar: () {},
              onEliminar: () {},
            ),
          ),
        ),
      );

      expect(find.text('Martillo'), findsOneWidget);
      expect(find.textContaining('Herramientas'), findsOneWidget);
      expect(find.textContaining('5990'), findsOneWidget);
      expect(find.textContaining('10 unidades'), findsOneWidget);
    });

    testWidgets('Abre el producto al tocarlo', (tester) async {
      var pulsaciones = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductoCard(
              nombre: 'Taladro',
              categoria: 'Electricas',
              precio: 29990,
              stock: 5,
              onTap: () => pulsaciones++,
              onEditar: () {},
              onEliminar: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Taladro'));

      expect(pulsaciones, 1);
    });

    testWidgets('Funcionan editar y eliminar', (tester) async {
      var ediciones = 0;
      var eliminaciones = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductoCard(
              nombre: 'Destornillador',
              categoria: 'Herramientas',
              precio: 2490,
              stock: 20,
              onTap: () {},
              onEditar: () => ediciones++,
              onEliminar: () => eliminaciones++,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Editar producto'));
      await tester.tap(find.byTooltip('Eliminar producto'));

      expect(ediciones, 1);
      expect(eliminaciones, 1);
    });
  });
}
