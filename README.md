# 🔧 Ferrepuntito

**Aplicación móvil de ferretería desarrollada con Flutter y Firebase.**

Proyecto académico de Computación Móvil que implementa un catálogo de productos de ferretería, autenticación de usuarios, administración de productos, carrito de compras y procesamiento de ventas con actualización automática del inventario.

## 1. Tecnologías utilizadas

- **Flutter y Dart:** desarrollo de la aplicación móvil.
- **Firebase Authentication:** registro, inicio de sesión y recuperación de contraseña.
- **Cloud Firestore:** almacenamiento de productos y ventas.
- **Firebase Cloud Functions (Node.js):** backend para administrar productos y procesar compras.
- **Firebase Emulator Suite:** pruebas locales de Authentication, Firestore y Functions.
- **Postman:** pruebas de los endpoints HTTP.
- **Git y GitHub:** control de versiones y repositorio del proyecto.

## 2. Funcionalidades implementadas

### Autenticación
- Registro de usuarios mediante correo y contraseña.
- Inicio y cierre de sesión.
- Recuperación de contraseña mediante correo electrónico.

### Productos
- Crear productos.
- Consultar y listar productos.
- Editar productos existentes.
- Eliminar productos.
- Buscar productos por nombre.
- Filtrar productos por categoría.
- Consultar detalles, precios y stock.

### Carrito de compras
- Agregar productos al carrito.
- Mostrar cantidades, subtotales y total.
- Eliminar productos del carrito.
- Confirmar compras desde la aplicación.

### Procesamiento de compras
- Verificación de identidad mediante Firebase Authentication.
- Validación del stock disponible.
- Registro de ventas en Firestore.
- Descuento de inventario mediante transacciones.
- Asociación de cada venta con el identificador y correo del comprador.
- Respuesta de error cuando el stock es insuficiente.

**Nota:** el procesamiento de compras ha sido probado mediante Firebase Emulator Suite. Las Cloud Functions no están desplegadas en producción. La confirmación de compra no representa un pago real.

## 3. Requisitos

Para ejecutar el proyecto se necesita:

- Flutter SDK y Dart SDK.
- Android Studio y un emulador Android.
- Node.js y npm.
- Firebase CLI.
- Una configuración Firebase válida para la aplicación.
- Git, opcionalmente, para clonar el repositorio.

## 4. Obtener el proyecto

Clonar el repositorio:

```bash
git clone https://github.com/kike2201/Ferrepuntito.git
cd Ferrepuntito
```

Instalar las dependencias Flutter:

```bash
flutter pub get
```

Instalar las dependencias del backend:

```bash
cd functions
npm ci
cd ..
```

## 5. Ejecutar Firebase Emulator Suite

Desde la carpeta principal del proyecto:

```bash
firebase emulators:start --only auth,functions,firestore
```

Servicios utilizados:

| Servicio | Puerto |
|---|---|
| Authentication Emulator | 9099 |
| Firestore Emulator | 8080 |
| Functions Emulator | 5001 |
| Emulator UI | 4000 |

Interfaz local de Firebase Emulator:

http://127.0.0.1:4000

Los datos guardados anteriormente en los emuladores no se incluyen en este repositorio. Al ejecutar el proyecto en un entorno nuevo, será necesario registrar un usuario de prueba y crear productos de prueba.

## 6. Ejecutar la aplicación Android

Primero, iniciar el emulador Android desde Android Studio o mediante Flutter.

Consultar los dispositivos disponibles:

```bash
flutter devices
```

Para ejecutar Ferrepuntito con los emuladores de Firebase:

```bash
flutter run -d emulator-5554 --dart-define=USE_FIREBASE_EMULATORS=true
```

Reemplazar `emulator-5554` por el identificador correspondiente, si fuera diferente.

Esta configuración utiliza la dirección `10.0.2.2` para que el emulador Android pueda comunicarse con los servicios Firebase ejecutados en el computador.

La aplicación también dispone de un modo normal:

```bash
flutter run
```

El modo normal utiliza la configuración Firebase del proyecto y **no habilita el procesamiento local de compras**. Para demostrar las compras debe utilizarse el modo de emuladores.

## 7. Backend y endpoints HTTP

Dirección base local:

```text
http://127.0.0.1:5001/ferrepuntito/us-central1/
```

| Función | Método | Descripción |
|---|---|---|
| estado | GET | Comprueba el estado del backend |
| obtenerProductos | GET | Consulta productos |
| crearProducto | POST | Registra productos |
| actualizarProducto | PUT | Modifica productos |
| eliminarProducto | DELETE | Elimina productos |
| procesarCompra | POST | Valida y registra una compra autenticada |

La función `procesarCompra` requiere un ID token válido de Firebase Authentication enviado mediante la cabecera `Authorization: Bearer TOKEN`.

**Seguridad:** los endpoints de administración de productos están implementados para el entorno académico de pruebas y todavía requieren controles de autorización antes de un despliegue público.

## 8. Pruebas realizadas

Se comprobaron las siguientes operaciones:

- Registro e inicio de sesión.
- Recuperación de contraseña.
- CRUD de productos.
- Búsqueda y filtrado de productos.
- Carrito de compras.
- Rechazo de compras sin autenticación.
- Aceptación de tokens de autenticación válidos.
- Registro de ventas asociadas a usuarios.
- Descuento de stock después de una compra.
- Rechazo de compras cuando no existe inventario suficiente.

Las pruebas del backend se realizaron con Postman y Firebase Emulator Suite.

## 9. Limitaciones

- Las Cloud Functions se ejecutan localmente mediante Firebase Emulator Suite.
- No existe una pasarela de pago real.
- El carrito se mantiene en memoria durante la ejecución de la aplicación.
- No se incluye una base de datos de demostración preconfigurada.
- Antes de publicar el sistema deben reforzarse los controles de autorización y las reglas de seguridad de Firestore.
- La aplicación fue desarrollada y probada principalmente en un emulador Android.

## 10. Estructura del proyecto

```text
Ferrepuntito/
├── android/
├── functions/
│   ├── index.js
│   └── package.json
├── lib/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── firebase_options.dart
│   └── main.dart
├── test/
├── firebase.json
├── .firebaserc
└── pubspec.yaml
```

## 11. Repositorio

GitHub: https://github.com/kike2201/Ferrepuntito

---

**Ferrepuntito — Proyecto académico de Computación Móvil, 2026.**


## Confirmación de compras por correo

Ferrepuntito envía un correo de confirmación mediante
Nodemailer y SMTP después de registrar una compra.

El comprobante incluye:
- Número de venta.
- Productos adquiridos.
- Cantidades y subtotales.
- Total de la compra.

El envío fue probado exitosamente utilizando Firebase
Emulator Suite y una cuenta Gmail configurada mediante
contraseña de aplicación.

### Configuración del correo

Para ejecutar esta funcionalidad localmente, crear el
archivo `functions/.env` con las variables:

SMTP_USER=correo_remitente@gmail.com
SMTP_PASS=contraseña_de_aplicacion

Las credenciales deben ser propias del entorno de pruebas.
El archivo `.env` está excluido de Git y no se incluye
en el repositorio.

Un fallo de SMTP no revierte una venta registrada.
El estado del envío queda indicado en Firestore mediante
el campo `correoEstado`.
