
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTRAR un nuevo usuario
  Future<UserCredential> registrarUsuario({
    required String correo,
    required String contrasena,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: correo,
      password: contrasena,
    );
  }

  // INICIAR SESIÓN
  Future<UserCredential> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: correo,
      password: contrasena,
    );
  }

  // RECUPERAR CONTRASEÑA
  Future<void> recuperarContrasena(String correo) async {
    await _auth.sendPasswordResetEmail(
      email: correo,
    );
  }

  // CERRAR SESIÓN
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // CONSULTAR USUARIO ACTUAL
  User? obtenerUsuarioActual() {
    return _auth.currentUser;
  }

  // ESCUCHAR CAMBIOS DE AUTENTICACIÓN
  Stream<User?> cambiosAutenticacion() {
    return _auth.authStateChanges();
  }
}
