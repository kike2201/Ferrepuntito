const {onRequest} = require("firebase-functions/v2/https");

const admin = require("firebase-admin");

admin.initializeApp();

exports.estado = onRequest((req, res) => {
  res.status(200).json({
    mensaje: "Backend de Ferrepuntito funcionando",
    estado: "OK",
  });
});


exports.obtenerProductos = onRequest(async (req, res) => {
  if (req.method !== "GET") {
    return res.status(405).json({
      error: "Metodo no permitido. Utiliza GET.",
    });
  }

  try {
    const snapshot = await admin
      .firestore()
      .collection("productos")
      .get();

    const productos = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    return res.status(200).json({
      mensaje: "Productos obtenidos correctamente",
      productos: productos,
    });
  } catch (error) {
    console.error("Error al obtener productos:", error);

    return res.status(500).json({
      error: "No fue posible consultar los productos",
    });
  }
});


exports.crearProducto = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).json({
      error: "Metodo no permitido. Utiliza POST.",
    });
  }

  try {
    const {nombre, precio, stock, categoria} = req.body || {};

    if (
      typeof nombre !== "string" ||
      nombre.trim() === "" ||
      typeof categoria !== "string" ||
      categoria.trim() === "" ||
      !Number.isInteger(precio) ||
      precio <= 0 ||
      !Number.isInteger(stock) ||
      stock < 0
    ) {
      return res.status(400).json({
        error: "Datos invalidos. Revisa nombre, precio, stock y categoria.",
      });
    }

    const nuevoProducto = {
      nombre: nombre.trim(),
      precio: precio,
      stock: stock,
      categoria: categoria.trim(),
      fechaCreacion: new Date(),
    };

    const documento = await admin
      .firestore()
      .collection("productos")
      .add(nuevoProducto);

    return res.status(201).json({
      mensaje: "Producto creado correctamente",
      id: documento.id,
    });
  } catch (error) {
    console.error("Error al crear producto:", error);

    return res.status(500).json({
      error: "No fue posible crear el producto",
    });
  }
});


exports.actualizarProducto = onRequest(async (req, res) => {
  if (req.method !== "PUT") {
    return res.status(405).json({
      error: "Metodo no permitido. Utiliza PUT.",
    });
  }

  try {
    const {id, nombre, precio, stock, categoria} = req.body || {};

    if (
      typeof id !== "string" ||
      id.trim() === "" ||
      typeof nombre !== "string" ||
      nombre.trim() === "" ||
      typeof categoria !== "string" ||
      categoria.trim() === "" ||
      !Number.isInteger(precio) ||
      precio <= 0 ||
      !Number.isInteger(stock) ||
      stock < 0
    ) {
      return res.status(400).json({
        error: "Datos invalidos. Revisa los campos.",
      });
    }

    const referencia = admin.firestore()
      .collection("productos")
      .doc(id);

    const documento = await referencia.get();

    if (!documento.exists) {
      return res.status(404).json({
        error: "El producto no existe",
      });
    }

    await referencia.update({
      nombre: nombre.trim(),
      precio: precio,
      stock: stock,
      categoria: categoria.trim(),
    });

    return res.status(200).json({
      mensaje: "Producto actualizado correctamente",
      id: id,
    });
  } catch (error) {
    console.error("Error al actualizar producto:", error);

    return res.status(500).json({
      error: "No fue posible actualizar el producto",
    });
  }
});



exports.eliminarProducto = onRequest(async (req, res) => {
  if (req.method !== "DELETE") {
    return res.status(405).json({
      error: "Metodo no permitido. Utiliza DELETE.",
    });
  }

  try {
    const {id} = req.body || {};

    if (typeof id !== "string" || id.trim() === "") {
      return res.status(400).json({
        error: "Debes proporcionar un ID valido.",
      });
    }

    const referencia = admin
      .firestore()
      .collection("productos")
      .doc(id);

    const documento = await referencia.get();

    if (!documento.exists) {
      return res.status(404).json({
        error: "El producto no existe.",
      });
    }

    await referencia.delete();

    return res.status(200).json({
      mensaje: "Producto eliminado correctamente",
      id: id,
    });
  } catch (error) {
    console.error("Error al eliminar producto:", error);

    return res.status(500).json({
      error: "No fue posible eliminar el producto.",
    });
  }
});



exports.procesarCompra = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).json({
      error: "Metodo no permitido. Utiliza POST.",
    });
  }

  // Comprobar la credencial del comprador.
  const authorization = req.headers.authorization || "";

  if (!authorization.startsWith("Bearer ")) {
    return res.status(401).json({
      error: "Debes iniciar sesion para comprar.",
    });
  }

  const token = authorization.substring(7).trim();

  let usuario;

  try {
    usuario = await admin.auth().verifyIdToken(token);
  } catch (error) {
    return res.status(401).json({
      error: "Sesion invalida o expirada.",
    });
  }

  try {
    const {productos} = req.body || {};


    if (!Array.isArray(productos) || productos.length === 0) {
      return res.status(400).json({
        error: "Debes enviar productos para comprar.",
      });
    }

    // Validar los productos antes de iniciar la transaccion.
    const ids = new Set();

    for (const item of productos) {
      if (
        !item ||
        typeof item.productoId !== "string" ||
        item.productoId.trim() === "" ||
        !Number.isInteger(item.cantidad) ||
        item.cantidad <= 0 ||
        ids.has(item.productoId)
      ) {
        return res.status(400).json({
          error: "Productos o cantidades invalidas.",
        });
      }

      ids.add(item.productoId);
    }

    const db = admin.firestore();

    const resultado = await db.runTransaction(async (transaction) => {
      const referencias = productos.map((item) =>
        db.collection("productos").doc(item.productoId)
      );

      // Primero leer todos los productos.
      const documentos = await Promise.all(
        referencias.map((ref) => transaction.get(ref))
      );

      const detalles = [];
      const sinStock = [];
      let total = 0;

      for (let i = 0; i < productos.length; i++) {
        const item = productos[i];
        const documento = documentos[i];

        if (
          !documento.exists ||
          !Number.isInteger(documento.data().stock) ||
          documento.data().stock < item.cantidad
        ) {
          sinStock.push(item.productoId);
          continue;
        }

        const datos = documento.data();

        if (
          !Number.isInteger(datos.precio) ||
          datos.precio <= 0
        ) {
          throw new Error("Precio de producto invalido");
        }

        detalles.push({
          productoId: item.productoId,
          nombre: datos.nombre,
          cantidad: item.cantidad,
          precio: datos.precio,
          subtotal: datos.precio * item.cantidad,
        });

        total += datos.precio * item.cantidad;
      }

      // Si falta stock, no modificar nada.
      if (sinStock.length > 0) {
        return {
          exito: false,
          sinStock,
        };
      }

      // Descontar el inventario.
      for (let i = 0; i < productos.length; i++) {
        transaction.update(referencias[i], {
          stock: documentos[i].data().stock -
              productos[i].cantidad,
        });
      }

      // Registrar la venta.
      const ventaRef = db.collection("ventas").doc();

     
      transaction.set(ventaRef, {
        usuarioId: usuario.uid,
        correoCliente: usuario.email || null,
        productos: detalles,
        total,
        fecha: new Date(),
        estado: "confirmada",
      });


      return {
        exito: true,
        ventaId: ventaRef.id,
        total,
      };
    });

    if (!resultado.exito) {
      return res.status(409).json({
        mensaje: "Stock insuficiente o producto inexistente",
        productosSinStock: resultado.sinStock,
      });
    }

    return res.status(200).json({
      mensaje: "Compra registrada correctamente",
      ventaId: resultado.ventaId,
      total: resultado.total,
    });
  } catch (error) {
    console.error("Error al procesar compra:", error);

    return res.status(500).json({
      error: "No fue posible procesar la compra",
    });
  }
});

