
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'screens/productos_page.dart';
import 'screens/login_page.dart';

// Activar exclusivamente durante pruebas locales.
const bool usarEmuladores = bool.fromEnvironment(
  'USE_FIREBASE_EMULATORS',
  defaultValue: false,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (usarEmuladores) {
    if (kReleaseMode) {
      throw StateError(
        'No se permite utilizar emuladores en modo release.',
      );
    }

    // 10.0.2.2 permite que el emulador Android
    // se conecte al computador donde corre Firebase.
    const host = '10.0.2.2';

    await FirebaseAuth.instance.useAuthEmulator(host, 9099);

    FirebaseFirestore.instance.useFirestoreEmulator(
      host,
      8080,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ferrepuntito',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Error al verificar la autenticación',
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return const ProductosPage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
