# 🔧 Ferrepuntito

**Aplicación móvil de ferretería desarrollada con Flutter y Firebase.**

**Asignatura:** Computación Móvil
**Carrera:** Ingeniería Informática
**Año:** 2026

### Integrantes

- María Ocanto Navas
- Enrique Manquepan Pacheco

---

## 1. Descripción del proyecto

Ferrepuntito es una aplicación móvil desarrollada como parte de la evaluación de la asignatura Computación Móvil.

Nuestro objetivo fue crear una aplicación orientada a una ferretería, donde los usuarios puedan registrarse, iniciar sesión y consultar un catálogo de productos. También incorporamos funciones para agregar, editar y eliminar productos, además de un buscador y un filtro por categorías.

Para el desarrollo utilizamos Flutter y Dart, conectando la aplicación con Firebase para administrar los usuarios y almacenar la información de los productos.

El proyecto fue desarrollado progresivamente, implementando las funcionalidades y comprobando su funcionamiento desde el emulador Android, Firebase y Postman.

## 2. Tecnologías utilizadas

- **Flutter y Dart:** para desarrollar las pantallas, formularios y navegación de la aplicación.
- **Firebase Authentication:** para registrar usuarios, iniciar sesión y recuperar contraseñas.
- **Cloud Firestore:** para almacenar los productos y mantener actualizado el catálogo online.
- **Firebase Cloud Functions:** para desarrollar servicios HTTP que permiten administrar productos y realizar pruebas desde Postman.
- **Firebase Emulator Suite:** para ejecutar y comprobar los servicios del backend en un entorno local.
- **Postman:** para probar solicitudes HTTP y verificar las respuestas del backend.
- **Git y GitHub:** para mantener el código organizado y compartir el proyecto.

## 3. Funcionalidades implementadas

### Registro e inicio de sesión

La aplicación permite crear cuentas utilizando un correo electrónico y una contraseña.

También cuenta con inicio y cierre de sesión, además de la posibilidad de recuperar la contraseña mediante correo electrónico.

Estas funciones están conectadas con Firebase Authentication.

### Administración de productos

Desarrollamos las operaciones principales para administrar el catálogo:

- Agregar productos con nombre, precio, stock y categoría.
- Consultar los productos almacenados.
- Editar la información de productos existentes.
- Eliminar productos mediante una confirmación previa.

Los cambios realizados desde la aplicación se reflejan en Cloud Firestore online.

### Catálogo de productos

El catálogo cuenta con seis productos de ferretería, cada uno con fotografía, nombre, categoría, precio y stock disponible.

Incorporamos categorías como herramientas manuales, herramientas eléctricas, medición y nivelación, y pintura y accesorios.

También implementamos un buscador por nombre, un filtro por categorías y una pantalla para consultar el detalle de cada producto.

Las fotografías están guardadas dentro del proyecto, en `assets/productos/`, mientras que Firestore almacena la ruta de la imagen correspondiente.

Para mejorar la presentación, los precios se muestran con el formato utilizado en Chile, por ejemplo, **$12.990**.

### Widgets reutilizables

Organizamos el código en pantallas, servicios y componentes reutilizables para mantener una estructura más ordenada.

Uno de estos componentes es `ProductoCard`, utilizado para mostrar la información de cada producto sin repetir el mismo diseño en distintas partes de la aplicación.

Este widget incluye la fotografía, el nombre, el precio, la categoría, el stock y las acciones disponibles para el producto.

## 4. Cómo ejecutar Ferrepuntito

El código del proyecto está disponible en GitHub:

https://github.com/kike2201/Ferrepuntito

Para ejecutar la aplicación se necesita tener instalado Flutter, Android Studio y disponer de un emulador Android o un dispositivo compatible.

### Paso 1. Descargar el proyecto

Desde una terminal, ejecutar:

```bash
git clone https://github.com/kike2201/Ferrepuntito.git
cd Ferrepuntito
```

Si el repositorio es privado, primero se debe contar con acceso autorizado.

### Paso 2. Instalar las dependencias

```bash
flutter pub get
```

### Paso 3. Iniciar un emulador Android

Se puede iniciar desde Android Studio y comprobar los dispositivos disponibles mediante:

```bash
flutter devices
```

### Paso 4. Ejecutar la aplicación

```bash
flutter run
```

Si existen varios dispositivos conectados, se puede seleccionar uno mediante:

```bash
flutter run -d emulator-5554
```

El identificador debe reemplazarse por el que corresponda al dispositivo disponible.

### Conexión con Firebase online

Ferrepuntito utiliza el proyecto Firebase configurado en el código de la aplicación.

En su ejecución normal se conecta a Firebase online. Por lo tanto, **no es necesario iniciar Firebase Emulator Suite para probar el registro de usuarios, el inicio de sesión y el catálogo de productos**.

Los productos están almacenados en Cloud Firestore y pueden consultarse desde distintas instalaciones conectadas al mismo proyecto.

Al abrir la aplicación, se puede registrar una cuenta, ingresar y visualizar los productos disponibles en la base de datos.

## 5. Backend y pruebas mediante Postman

Además de la conexión directa entre Flutter y Firestore, desarrollamos servicios HTTP utilizando Firebase Cloud Functions.

Para esta evaluación trabajamos con dos entornos:

- **Firebase online:** utilizado por la aplicación Flutter para Authentication y Cloud Firestore.
- **Firebase Emulator Suite:** utilizado para ejecutar localmente los servicios HTTP y comprobarlos mediante Postman.

Esta separación permite evaluar el backend sin modificar los productos que están disponibles en la aplicación móvil.

### Requisitos para ejecutar el backend

En otro computador se necesita:

- Node.js 24 y npm.
- Java compatible con Firebase Emulator Suite.
- Firebase CLI.
- Postman para realizar las solicitudes HTTP.

Las dependencias del backend están definidas en los archivos `functions/package.json` y `functions/package-lock.json`.

### Paso 1. Instalar Firebase CLI

Desde PowerShell o una terminal, ejecutar:

```bash
npm install -g firebase-tools
```

### Paso 2. Instalar las dependencias del backend

Desde la carpeta principal del proyecto:

```bash
cd functions
npm ci
cd ..
```

### Paso 3. Iniciar Firebase Emulator Suite

Desde la carpeta principal de Ferrepuntito:

```bash
firebase emulators:start --project ferrepuntito --only auth,functions,firestore
```

Cuando aparezca el mensaje `All emulators ready!`, los servicios estarán preparados para recibir solicitudes HTTP.

Los emuladores utilizan los siguientes puertos:

| Servicio | Puerto |
|---|---|
| Authentication | 9099 |
| Firestore | 8080 |
| Cloud Functions | 5001 |
| Emulator UI | 4000 |

También se puede acceder a la interfaz de los emuladores desde:

http://127.0.0.1:4000/

### Paso 4. Comprobar el funcionamiento del backend

Con los emuladores funcionando, abrir en el navegador o enviar desde Postman una solicitud GET a:

```text
http://127.0.0.1:5001/ferrepuntito/us-central1/estado
```

La respuesta esperada es:

```json
{
  "mensaje": "Backend de Ferrepuntito funcionando",
  "estado": "OK"
}
```

Esta prueba permite comprobar que el servicio HTTP está disponible y responde correctamente.

### Paso 5. Probar los endpoints en Postman

La dirección base de los servicios HTTP es:

```text
http://127.0.0.1:5001/ferrepuntito/us-central1/
```

Implementamos los siguientes endpoints:

| Endpoint | Método HTTP | Función |
|---|---|---|
| `estado` | GET | Comprobar el funcionamiento del backend |
| `obtenerProductos` | GET | Consultar productos |
| `crearProducto` | POST | Crear un producto |
| `actualizarProducto` | PUT | Actualizar un producto |
| `eliminarProducto` | DELETE | Eliminar un producto |

**Ejemplo: consultar productos**

En Postman, seleccionar el método GET e ingresar:

```text
http://127.0.0.1:5001/ferrepuntito/us-central1/obtenerProductos
```

Si Firestore local todavía no tiene productos, se obtiene una respuesta similar a:

```json
{
  "mensaje": "Productos obtenidos correctamente",
  "productos": []
}
```

Esto es normal, ya que los productos de Firebase online no se copian automáticamente a los emuladores.

**Ejemplo: crear un producto**

En Postman, seleccionar el método POST e ingresar:

```text
http://127.0.0.1:5001/ferrepuntito/us-central1/crearProducto
```

En la pestaña **Body**, seleccionar **raw** y **JSON**. Luego utilizar un cuerpo de prueba como el siguiente:

```json
{
  "nombre": "Martillo de prueba",
  "precio": 5990,
  "stock": 10,
  "categoria": "Herramientas manuales"
}
```

Al realizar esta solicitud se puede comprobar la creación de un producto en el Firestore local.

Posteriormente, mediante `obtenerProductos`, es posible verificar que el producto fue registrado. También se pueden probar los endpoints de actualización y eliminación utilizando el identificador generado.

### Consideraciones sobre los emuladores

Los endpoints HTTP funcionan de manera local y no están publicados en internet.

Esto significa que `127.0.0.1` corresponde al computador donde se están ejecutando los emuladores.

Los servicios HTTP pueden probarse sin configurar credenciales de correo electrónico. Estas solamente se requieren para las funciones relacionadas con el envío de correos.

Las solicitudes realizadas contra los emuladores no modifican los productos almacenados en Firebase online.

## 6. Funcionalidades adicionales

Durante el desarrollo también implementamos un carrito de compras y un proceso de venta.

Estas funciones permiten agregar y quitar productos del carrito, verificar el stock, registrar una compra y descontar las existencias mediante transacciones de Firestore.

También incorporamos el envío de comprobantes de compra por correo electrónico utilizando Nodemailer y SMTP.

Estas funcionalidades fueron probadas en Firebase Emulator Suite y se mantienen como un complemento del proyecto, considerando que el proceso de compras quedó fuera de los requisitos obligatorios señalados posteriormente para esta evaluación.

Para probar el envío de correos se requiere configurar credenciales SMTP propias en un archivo local `functions/.env`. Por seguridad, dichas credenciales no se incluyen en GitHub.

El procesamiento de compras no está desplegado en Firebase online y no representa pagos reales.

## 7. Pruebas realizadas

Durante el desarrollo comprobamos:

- Registro, inicio de sesión y recuperación de contraseña.
- Lectura de productos desde Cloud Firestore online.
- Creación, edición y eliminación de productos.
- Búsqueda por nombre y filtrado por categorías.
- Visualización de fotografías y detalle de productos.
- Funcionamiento de los servicios HTTP mediante Postman.
- Ejecución del proyecto en un emulador Android.
- Inicialización de los emuladores y respuesta de los endpoints `estado` y `obtenerProductos` sin credenciales SMTP.

También utilizamos las herramientas de Flutter para comprobar el estado del código.

**Análisis del proyecto:**

```bash
flutter analyze
```

Resultado obtenido:

```text
No issues found!
```

**Pruebas automatizadas:**

```bash
flutter test
```

Resultado obtenido:

```text
+3: All tests passed!
```

Las tres pruebas automatizadas comprueban la información mostrada en `ProductoCard` y el funcionamiento de sus acciones.

## 8. Organización del proyecto

La aplicación está organizada en carpetas para separar las distintas responsabilidades:

| Carpeta | Contenido |
|---|---|
| `lib/screens/` | Pantallas de la aplicación |
| `lib/services/` | Servicios para Firebase y administración de productos |
| `lib/widgets/` | Componentes visuales reutilizables |
| `lib/constants/` | Categorías disponibles |
| `lib/utils/` | Funciones auxiliares, como el formato de precios |
| `assets/productos/` | Fotografías utilizadas en el catálogo |
| `functions/` | Servicios HTTP desarrollados con Node.js |
| `test/` | Pruebas automatizadas |

## 9. Consideraciones finales

Ferrepuntito fue desarrollado con el objetivo de aplicar los contenidos de Computación Móvil en una aplicación funcional, utilizando Flutter para la interfaz y Firebase para la gestión de usuarios y productos.

Para facilitar la revisión, el catálogo principal utiliza Firebase online y mantiene los productos disponibles sin necesidad de volver a ingresarlos en cada instalación.

Los servicios HTTP pueden comprobarse por separado mediante Postman y Firebase Emulator Suite.

El proyecto corresponde a una implementación académica. Antes de utilizarlo como sistema comercial sería necesario incorporar controles de acceso por roles, reforzar la seguridad del backend y realizar pruebas adicionales.

## 10. Referencias y recursos utilizados

Durante el desarrollo del proyecto consultamos documentación técnica y materiales de apoyo de la asignatura para implementar y comprobar las distintas funcionalidades.

**Documentación técnica**

- Flutter. Documentación oficial: https://docs.flutter.dev/
- Dart. Documentación oficial: https://dart.dev/
- Firebase. Documentación oficial: https://firebase.google.com/docs
- Cloud Firestore. Documentación: https://firebase.google.com/docs/firestore
- Firebase Authentication. Documentación: https://firebase.google.com/docs/auth
- Postman. Documentación oficial: https://learning.postman.com/docs/

**Material de la asignatura**

- Material de clases y grabaciones de Computación Móvil, 2026.
- Ejemplos de autenticación y consumo de API REST proporcionados por el docente, utilizados como referencia de aprendizaje.

**Recursos gráficos**

Para mejorar la presentación visual del catálogo de Ferrepuntito, se incorporaron seis fotografías de referencia de productos de ferretería, obtenidas mediante búsquedas en Google Imágenes.

Las fotografías se utilizan como recursos gráficos dentro de `assets/productos/`, para la demostración académica del catálogo. Sus fuentes originales y condiciones de uso no se han identificado.

---

**Ferrepuntito — Evaluación de Computación Móvil, 2026.**

**María Ocanto Navas — Enrique Manquepan Pacheco**