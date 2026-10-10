
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'registro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();

  bool ingresando = false;

  Future<void> iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      ingresando = true;
    });

    try {
      await AuthService().iniciarSesion(
        correo: correoController.text.trim(),
        contrasena: contrasenaController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión iniciada correctamente'),
        ),
      );

      // La navegación al catálogo se conectará después.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensaje;

      switch (e.code) {
        case 'invalid-email':
          mensaje = 'El correo electrónico no es válido';
          break;
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          mensaje = 'Correo o contraseña incorrectos';
          break;
        case 'too-many-requests':
          mensaje = 'Demasiados intentos. Intenta más tarde';
          break;
        default:
          mensaje = 'Error de inicio de sesión: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          ingresando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ferrepuntito'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 75,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenido a Ferrepuntito',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) {
                      if (valor == null ||
                          valor.trim().isEmpty ||
                          !valor.contains('@')) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contrasenaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: ingresando ? null : iniciarSesion,
                    child: Text(
                      ingresando
                          ? 'Ingresando...'
                          : 'Iniciar sesión',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RegistroPage(),
                        ),
                      );
                    },
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  TextButton(
                  onPressed: () async {
                  final correo = correoController.text.trim();

                  if (correo.isEmpty ||
                      !correo.contains('@') ||
                      !correo.contains('.')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Ingresa primero tu correo electrónico',
                        ),
                      ),
                    );
                  return;
                  }

                  try {
                    await AuthService().recuperarContrasena(correo);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Si el correo tiene una cuenta registrada, '
                          'recibirás instrucciones para recuperar tu contraseña.',
                        ),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'No se pudo procesar la solicitud: ${e.message}',
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error de conexión: $e'),
                      ),
                    );
                  }
                },
                child: const Text('¿Olvidaste tu contraseña?'),
                     ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
