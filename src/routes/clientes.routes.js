import { Router } from "express";
import {
  listarClientes,
  crearNuevoCliente,
  obtenerCliente,
  obtenerDetalleCliente,
  eliminarCliente,
  actualizarCliente,
} from "../controllers/clientes.controller";

const router = Router();

router.get("/clientes", listarClientes);//Listo

router.post("/clientes", crearNuevoCliente);//Listo

router.get("/clientes/:idCliente", obtenerCliente);//Listo

router.get("/clientes/detalle/:idCliente", obtenerDetalleCliente);//Listo

router.delete("/clientes/:idCliente", eliminarCliente);//Listo

router.put("/clientes/:idCliente", actualizarCliente);//Listo

export default router;
