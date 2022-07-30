import { getConnection, sql } from "../database";

export const listarCuentas = async (req, res) => {
    try {
      const pool = await getConnection();
      const result = await pool.request().execute("sp_listar_cuentas");
      res.json(result.recordset);
    } catch (error) {
      res.status(500);
      res.send(error.message);
    }
  };