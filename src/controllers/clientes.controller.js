import { getConnection, sql } from "../database";

export const listarClientes = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool.request().execute("sp_lista_clientes");
    res.json(result.recordset);
  } catch (error) {
    res.status(500);
    res.send(error.message);
  }
};

export const crearNuevoCliente = async (req, res) => {
  const { nombre, apellido_paterno, apellido_materno, rfc, curp, fecha_alta } =
    req.body;

  // validating
  if ((req.body = null)) {
    return res
      .status(400)
      .json({ msg: "Bad Request. Por favor complete los campos" });
  }

  try {
    const pool = await getConnection();

    await pool
      .request()
      .input("nombre", sql.VarChar, nombre)
      .input("apellido_paterno", sql.VarChar, apellido_paterno)
      .input("apellido_materno", sql.VarChar, apellido_materno)
      .input("rfc", sql.VarChar, rfc)
      .input("curp", sql.VarChar, curp)
      .input("fecha_alta", sql.DateTime, fecha_alta)
      .execute("sp_crear_cliente");

    res.json({ message: "Cliente agregado correctamente" });
  } catch (error) {
    res.status(500);
    res.send(error.message);
  }
};

export const obtenerCliente = async (req, res) => {
  try {
    const pool = await getConnection();

    const result = await pool
      .request()
      .input("id_cliente", req.params.idCliente)
      .execute("sp_obtener_cliente");
    return res.json(result.recordset[0]);
  } catch (error) {
    res.status(500);
    res.send(error.message);
  }
};

export const obtenerDetalleCliente = async (req, res) => {
  try {
    const pool = await getConnection();

    const result = await pool
      .request()
      .input("id_cliente", req.params.idCliente)
      .execute("sp_detalle_cliente");
    return res.json(result.recordset[0]);
  } catch (error) {
    res.status(500);
    res.send(error.message);
  }
};

export const eliminarCliente = async (req, res) => {
  try {
    const pool = await getConnection();

    const result = await pool
      .request()
      .input("id_cliente", req.params.idCliente)
      .execute("sp_eliminar_cliente");

    if (result.rowsAffected[0] === 0) return res.sendStatus(404);

    return res.json({ message: "Cliente eliminado correctamente" });
  } catch (error) {
    res.status(500);
    res.send(error.message);
  }
};

export const actualizarCliente = async (req, res) => {
  const { nombre, apellido_paterno, apellido_materno, rfc, curp} =
    req.body;

  try {
    const pool = await getConnection();
    await pool
      .request()
      .input("id_cliente", req.params.idCliente)
      .input("nombre", sql.VarChar, nombre)
      .input("apellido_paterno", sql.VarChar, apellido_paterno)
      .input("apellido_materno", sql.VarChar, apellido_materno)
      .input("rfc", sql.VarChar, rfc)
      .input("curp", sql.VarChar, curp)
      .execute("sp_actualizar_cliente");
    res.json({message: "Cliente actualizado correctamente" });
  } catch (error) {
    res.status(500);
    res.send(error.message);
  }
};
