
# 🔧 Ferrepuntito

Aplicación móvil de ferretería desarrollada con Flutter, Dart y Firebase para la asignatura de Computación Móvil.

Permite registrar usuarios, iniciar sesión, administrar productos y consultar un catálogo con búsqueda, filtros por categoría y detalle de cada producto.

## 1. Tecnologías utilizadas

- Flutter y Dart: desarrollo de la aplicación Android.
- Firebase Authentication: registro, inicio de sesión y recuperación de contraseña.
- Cloud Firestore: almacenamiento online de productos.
- Firebase Cloud Functions (Node.js): servicios HTTP de productos y compras.
- Firebase Emulator Suite: ejecución y pruebas locales de los servicios HTTP.
- Postman: pruebas de los endpoints del backend.
- Git y GitHub: control de versiones.

## 2. Funcionalidades principales

### Autenticación

- Registro de usuarios con correo y contraseña.
- Inicio y cierre de sesión.
- Recuperación de contraseña mediante correo electrónico.

### Administración de productos

- Crear productos.
- Consultar el listado.
- Editar productos existentes.
- Eliminar productos con confirmación.
- Buscar productos por nombre.
- Filtrar por categorías.
- Consultar el detalle, precio y stock.

### Diseño y widgets

- Interfaz desarrollada con Material Design.
- Widget reutilizable `ProductoCard`.
- Separación del proyecto en pantallas, servicios, modelos y widgets.
- Pruebas automatizadas del componente `ProductoCard`.

## 3. Requisitos de instalación

Para ejecutar la aplicación Android:

- Flutter SDK y Dart SDK.
- Android Studio con un emulador Android configurado.
- Conexión a internet.

Para ejecutar adicionalmente el backend HTTP local:

- Node.js y npm.
- Firebase CLI.
- Postman para probar los servicios.

## 4. Descargar y ejecutar Ferrepuntito

Clonar el repositorio:

```bash
git clone https://github.com/kike2201/Ferrepuntito.git
cd Ferrepuntito
```

Instalar las dependencias:

```bash
flutter pub get
```

Iniciar un emulador Android desde Android Studio.

Consultar los dispositivos disponibles:

```bash
flutter devices
```

Ejecutar la aplicación:

```bash
flutter run
```

Si hay más de un dispositivo conectado, se puede indicar el identificador:

```bash
flutter run -d emulator-5554
```

Reemplazar `emulator-5554` por el identificador correspondiente.

### Conexión a Firebase online

En el modo normal, la aplicación utiliza el proyecto Firebase **Ferrepuntito** mediante la configuración incluida en `lib/firebase_options.dart`.

Se utiliza Firebase Authentication para administrar usuarios y Cloud Firestore para almacenar los productos.

No es necesario iniciar Firebase Emulator Suite para utilizar la autenticación y el catálogo online.

Los productos almacenados en Cloud Firestore se comparten entre las instalaciones que utilizan el mismo proyecto Firebase.

### Primera ejecución

1. Abrir la aplicación.
2. Registrar una cuenta de prueba o iniciar sesión.
3. Acceder al catálogo de productos.
4. Utilizar la búsqueda y el filtro por categorías.
5. Abrir el detalle de un producto.
6. Probar la creación, edición o eliminación de un producto de prueba.

La base de datos online ya contiene productos demostrativos.

**Nota:** el acceso a los productos está sujeto a las reglas de seguridad de Firestore. Para administrar el catálogo es necesario iniciar sesión.

## 5. Backend HTTP y Postman

El proyecto también incluye servicios HTTP implementados con Firebase Cloud Functions.

Estos servicios se desarrollaron y probaron mediante Firebase Emulator Suite.

### Preparación

Desde la carpeta principal del proyecto:

```bash
cd functions
npm ci
cd ..
```

Iniciar los emuladores:

```bash
firebase emulators:start --only auth,functions,firestore
```

Los servicios utilizan los siguientes puertos:

| Servicio | Puerto |
|---|---|
| Authentication | 9099 |
| Firestore | 8080 |
| Cloud Functions | 5001 |
| Emulator UI | 4000 |

Interfaz del emulador:

http://127.0.0.1:4000

### Endpoints HTTP

Dirección base local:

```text
http://127.0.0.1:5001/ferrepuntito/us-central1/
```

| Función | Método HTTP | Descripción |
|---|---|---|
| `estado` | GET | Comprobar el backend |
| `obtenerProductos` | GET | Consultar productos |
| `crearProducto` | POST | Crear productos |
| `actualizarProducto` | PUT | Modificar productos |
| `eliminarProducto` | DELETE | Eliminar productos |
| `procesarCompra` | POST | Procesar una compra autenticada |

Ejemplo de consulta en Postman:

**Método:** GET

**URL:**

```text
http://127.0.0.1:5001/ferrepuntito/us-central1/obtenerProductos
```

Los servicios HTTP funcionan en el entorno local de pruebas. No están desplegados como endpoints públicos de producción.

**Importante:** el CRUD utilizado por las pantallas Flutter en modo online se comunica directamente con Cloud Firestore mediante el SDK oficial de Firebase. Los endpoints HTTP de Cloud Functions son una implementación adicional para las pruebas del backend con Postman.

## 6. Funcionalidades adicionales

Se implementaron funcionalidades de carrito y compras, adicionales al alcance principal confirmado para la evaluación:

- Agregar y quitar productos del carrito.
- Consultar cantidades, subtotales y total.
- Verificar el stock antes de comprar.
- Registrar ventas en Firestore.
- Descontar inventario mediante transacciones.
- Rechazar compras con stock insuficiente.
- Enviar comprobantes mediante Nodemailer y SMTP.

Estas funcionalidades fueron probadas utilizando Firebase Emulator Suite.

**No representan pagos reales y el procesamiento de compras no está desplegado online.**

### Configuración opcional del correo

Para probar el envío real de correos en el entorno local, crear el archivo `functions/.env` con:

```dotenv
SMTP_USER=correo_remitente@gmail.com
SMTP_PASS=contraseña_de_aplicacion
```

Se deben utilizar credenciales propias del entorno de pruebas.

Por seguridad, el archivo `.env` está excluido de GitHub y no se incluyen contraseñas personales en el repositorio.

El funcionamiento principal del catálogo online no requiere configurar SMTP.

## 7. Pruebas realizadas

Se realizaron las siguientes comprobaciones:

- Registro e inicio de sesión.
- Recuperación de contraseña.
- Lectura de productos desde Firebase online.
- Creación, edición y eliminación de productos online.
- Búsqueda de productos y filtrado por categorías.
- Consulta del detalle de productos.
- CRUD HTTP probado mediante Postman en Firebase Emulator Suite.
- Compras y descuento de stock en el entorno local.

### Análisis estático

```bash
flutter analyze
```

Resultado obtenido durante el desarrollo:

```text
No issues found!
```

### Pruebas automatizadas

```bash
flutter test
```

Resultado obtenido:

```text
+3: All tests passed!
```

Las tres pruebas comprueban el widget `ProductoCard`, su información y las acciones de sus botones.

## 8. Estructura del proyecto

```text
Ferrepuntito/
├── android/
├── functions/
│   ├── index.js
│   ├── package.json
│   └── package-lock.json
├── lib/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── widgets/
│   ├── firebase_options.dart
│   └── main.dart
├── test/
│   └── widget_test.dart
├── firebase.json
├── .firebaserc
├── README.md
└── pubspec.yaml
```

## 9. Consideraciones técnicas

- El catálogo principal utiliza Firebase online.
- Es necesario tener conexión a internet para utilizar ese catálogo.
- Los servicios HTTP de Cloud Functions requieren Firebase Emulator Suite.
- La versión online no procesa las compras mediante Cloud Functions, ya que estas no están desplegadas.
- No existe una pasarela de pago real.
- El carrito mantiene sus datos en memoria.
- Las reglas actuales de Firestore permiten administrar productos a usuarios autenticados para fines de evaluación; antes de un uso público se debe implementar autorización por roles.
- No se incluyen credenciales SMTP privadas.
- La aplicación fue probada principalmente en un emulador Android.

## 10. Repositorio

https://github.com/kike2201/Ferrepuntito

---

**Ferrepuntito — Proyecto académico de Computación Móvil, 2026.**
