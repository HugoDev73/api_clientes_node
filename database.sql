CREATE DATABASE clientes
USE clientes

CREATE TABLE tbl_cmv_cliente (
	id_cliente INT IDENTITY PRIMARY KEY NOT NULL,
	nombre VARCHAR(50),
	apellido_paterno VARCHAR(50),
	apellido_materno VARCHAR(50),
	rfc VARCHAR(13),
	curp VARCHAR(18),
	fecha_alta DATETIME
)

CREATE TABLE cat_cmv_tipo_cuenta (
	id_cuenta INT IDENTITY PRIMARY KEY NOT NULL,
	nombre_cuenta VARCHAR(50),
)

CREATE TABLE tbl_cmv_cliente_cuenta (
	id_cliente_cuenta INT IDENTITY PRIMARY KEY NOT NULL,
	id_cliente INT NOT NULL,
	id_cuenta INT NOT NULL,
	saldo_actual MONEY,
	fecha_contratacion DATETIME,
	fecha_ultimo_movimiento DATETIME,
	CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES tbl_cmv_cliente (id_cliente) ON DELETE CASCADE,
	CONSTRAINT fk_cuenta FOREIGN KEY (id_cuenta) REFERENCES cat_cmv_tipo_cuenta (id_cuenta) ON DELETE CASCADE
)



--INSERTAR DATOS DE PRUEBA

INSERT INTO tbl_cmv_cliente VALUES('Hector','Mendoza','Hernandez','1234567891234','123456789123456789','2022/07/21')
INSERT INTO tbl_cmv_cliente VALUES('Tania','Gutierrez','Lopez','1234567891234','123456789123456789','2022/06/12')
INSERT INTO tbl_cmv_cliente VALUES('Pedro','Lopez','Salto','1234567891234','123456789123456789','2022/07/15')
INSERT INTO tbl_cmv_cliente VALUES('Sandra','San','Dirac','1234567891234','123456789123456789','2022/06/02')
INSERT INTO tbl_cmv_cliente VALUES('Hugo','Dan','Herrera','1234567891234','123456789123456789','2022/06/07')

INSERT INTO cat_cmv_tipo_cuenta VALUES ('Ahorro')
INSERT INTO cat_cmv_tipo_cuenta VALUES ('Nomina')
INSERT INTO cat_cmv_tipo_cuenta VALUES ('Chequera')

INSERT INTO tbl_cmv_cliente_cuenta VALUES (2,3,3500,'2022/07/21','2022/07/21')
INSERT INTO tbl_cmv_cliente_cuenta VALUES (5,1,2000,'2022/07/21','2022/07/21')
INSERT INTO tbl_cmv_cliente_cuenta VALUES (4,2,15000,'2022/07/21','2022/07/21')
INSERT INTO tbl_cmv_cliente_cuenta VALUES (1,2,15000,'2022/07/21','2022/07/21')
INSERT INTO tbl_cmv_cliente_cuenta VALUES (3,1,15000,'2022/07/21','2022/07/21')



--PROCEDIMIENTOS ALMACENADOS

--Listado de clientes
CREATE PROCEDURE sp_lista_clientes
AS
BEGIN
	SELECT id_cliente, nombre, apellido_paterno, apellido_materno, rfc, curp, fecha_alta  FROM tbl_cmv_cliente
END

--Registrar un Cliente
create proc sp_crear_cliente(
@nombre varchar(50),
@apellido_paterno varchar(50),
@apellido_materno varchar(50),
@rfc varchar(13),
@curp varchar(18),
@fecha_alta datetime
)as
begin
	insert into tbl_cmv_cliente(nombre, apellido_paterno, apellido_materno, rfc, curp, fecha_alta)
	values (@nombre, @apellido_paterno, @apellido_materno, @rfc, @curp, @fecha_alta)
end

--Actualizar un Cliente
CREATE PROC sp_actualizar_cliente(
@id_cliente int,
@nombre varchar(50) null,
@apellido_paterno varchar(50) null,
@apellido_materno varchar(50) null,
@rfc varchar(13) null,
@curp varchar(18) null
)AS
BEGIN
	UPDATE tbl_cmv_cliente 
	SET nombre = @nombre,
		apellido_paterno = @apellido_paterno,
		apellido_materno = @apellido_materno,
		rfc = @rfc,
		curp = @curp
	WHERE id_cliente = @id_cliente
END

--Eliminar un cliente
create proc sp_eliminar_cliente(@id_cliente int)
AS
BEGIN
	DELETE FROM tbl_cmv_cliente WHERE id_cliente = @id_cliente
END

--Ver detalle de un cliente y su cuenta
CREATE PROCEDURE sp_detalle_cliente(@id_cliente int)
AS
BEGIN
	SELECT  nombre, apellido_paterno, apellido_materno, rfc, curp,fecha_alta,nombre_cuenta, saldo_actual, fecha_contratacion, fecha_ultimo_movimiento
	FROM tbl_cmv_cliente 
		INNER JOIN tbl_cmv_cliente_cuenta ON tbl_cmv_cliente.id_cliente = tbl_cmv_cliente_cuenta.id_cliente
		INNER JOIN cat_cmv_tipo_cuenta ON tbl_cmv_cliente_cuenta.id_cuenta = cat_cmv_tipo_cuenta.id_cuenta
	WHERE tbl_cmv_cliente.id_cliente = @id_cliente
END

--Obtener un cliente por id
CREATE PROCEDURE sp_obtener_cliente(@id_cliente int)
AS
BEGIN
	SELECT  *
	FROM tbl_cmv_cliente 
	WHERE id_cliente = @id_cliente
END

CREATE PROC sp_listar_cuentas
AS
BEGIN
	SELECT *  FROM cat_cmv_tipo_cuenta
END

--asociar una cuenta a un cliente
create proc sp_asociar_cuenta_cliente(
@id_cliente int,
@id_cuenta int,
@saldo_actual money,
@fecha_contratacion datetime,
@fecha_ultimo_movimiento datetime
)as
begin
	insert into tbl_cmv_cliente_cuenta(id_cliente, id_cuenta, saldo_actual, fecha_contratacion, fecha_ultimo_movimiento)
	values (@id_cliente, @id_cuenta, @saldo_actual, @fecha_contratacion, @fecha_ultimo_movimiento)
end

--Ejemplos
EXEC sp_crear_cliente 'Lalo','Gomez','Arrollo','1234567891234','123456789123456789','2022/07/15'

EXEC sp_actualizar_cliente 3, 'Eduardo','Gomez','Arrollo','1234567891234','123456789123456789'

EXEC sp_asociar_cuenta 6,3,3500,'2022/07/21','2022/07/21'

EXEC sp_eliminar_cliente 6

EXEC sp_detalle_cliente 2

EXEC sp_obtener_cliente 3