import { Router } from "express";
import { listarCuentas } from "../controllers/cuentas.controller";

const router = Router();

router.get("/cuentas", listarCuentas);//Listo


export default router;