-- ============================================================
-- CureSA - Gestion Hospitalaria
-- 01_schema.sql
-- Descripcion: Creacion de base de datos, esquemas y tablas
-- Ejecutar primero antes que cualquier otro script
-- ============================================================

-- Descomentar para eliminar la BD si ya existe:
-- DROP DATABASE CURESA

---- COMIENZO CREACION DE BASE DE DATOS Y ESQUEMAS ----
create database CURESA COLLATE Modern_Spanish_CI_AI;
go
use CURESA

GO
CREATE SCHEMA datosPaciente
GO
CREATE SCHEMA datosReserva
GO
CREATE SCHEMA datosAtencion
---- FIN CREACION DE BASE DE DATOS Y ESQUEMAS ----
GO

IF OBJECT_ID('datosPaciente.Usuario') IS NOT NULL
BEGIN
    DROP TABLE datosPaciente.Usuario
    IF OBJECT_ID('datosPaciente.Usuario') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosPaciente.Usuario', 16, 1);
    ELSE
        PRINT 'Tabla datosPaciente.Usuario eliminada correctamente.'
END
GO
CREATE TABLE datosPaciente.Usuario		
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	contraseña CHAR(8) NOT NULL,
	fechaCreacion DATETIME NOT NULL,
	fechaBorrado DATETIME NULL
) 
GO

IF OBJECT_ID('datosPaciente.Domicilio') IS NOT NULL
BEGIN
    DROP TABLE datosPaciente.Domicilio
    IF OBJECT_ID('datosPaciente.Domicilio') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosPaciente.Domicilio.', 16, 1);
    ELSE
        PRINT 'Tabla datosPaciente.Domicilio eliminada correctamente.'
END
GO
CREATE TABLE datosPaciente.Domicilio	
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	calleYNro NVARCHAR(50) NOT NULL,
	piso INT NULL,
	departamento NVARCHAR(10) NULL, 
	codigoPostal NVARCHAR(10) NULL,
	pais NVARCHAR(15) NOT NULL,
	provincia NVARCHAR(15) NOT NULL,
	localidad NVARCHAR(15) NOT NULL,
	nroDocumento INT NOT NULL
)
go

IF OBJECT_ID('datosPaciente.Prestador') IS NOT NULL
BEGIN
    DROP TABLE datosPaciente.Prestador
    IF OBJECT_ID('datosPaciente.Prestador') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosPaciente.Prestador.', 16, 1);
    ELSE
        PRINT 'Tabla datosPaciente.Prestador eliminada correctamente.'
END
GO
CREATE TABLE datosPaciente.Prestador	
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombre NVARCHAR(40) NOT NULL,
	tipoPlan NVARCHAR(40) NOT NULL,
	fechaBorrado DATETIME NULL
)
GO

IF OBJECT_ID('datosPaciente.Cobertura') IS NOT NULL
BEGIN
    DROP TABLE datosPaciente.Cobertura
    IF OBJECT_ID('datosPaciente.Cobertura') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosPaciente.Cobertura.', 16, 1);
    ELSE
        PRINT 'Tabla datosPaciente.Cobertura eliminada correctamente.'
END
GO
CREATE TABLE datosPaciente.Cobertura	
(
	id INT IDENTITY(1,1) PRIMARY KEY not null,
	imagenCredencial NVARCHAR(40) NOT NULL,
	nroSocio INT NOT NULL,
	fechaRegistro DATETIME NOT NULL,
	idPrestador INT NOT NULL,
	fechaBorrado DATETIME NULL,
	CONSTRAINT FK_Prestador FOREIGN KEY (idPrestador) REFERENCES datosPaciente.Prestador(id)
)
GO

IF OBJECT_ID('datosPaciente.Estudio') IS NOT NULL
BEGIN
    DROP TABLE datosPaciente.Estudio
    IF OBJECT_ID('datosPaciente.Estudio') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosPaciente.Estudio.', 16, 1);
    ELSE
        PRINT 'Tabla datosPaciente.Estudio eliminada correctamente.'
END
GO
CREATE TABLE datosPaciente.Estudio
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	fecha DATE NOT NULL,
	nombre NVARCHAR(15) NOT NULL,
	autorizado BIT NOT NULL,
	linkDocumentoResultado NVARCHAR(50) NOT NULL,
	imagenResultado NVARCHAR(40) NOT NULL,
	fechaBorrado DATETIME NULL
)
GO

IF OBJECT_ID('datosPaciente.Paciente') IS NOT NULL
BEGIN
    DROP TABLE datosPaciente.Paciente
    IF OBJECT_ID('datosPaciente.Paciente') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosPaciente.Paciente.', 16, 1);
    ELSE
        PRINT 'Tabla datosPaciente.Paciente eliminada correctamente.'
END
GO
CREATE TABLE datosPaciente.Paciente 
(
	idHistoriaClinica INT IDENTITY(1,1) NOT NULL,
	nombre NVARCHAR(20) NOT NULL,
	apellido NVARCHAR(20) NOT NULL,
	apellidoMaterno NVARCHAR(20) NOT NULL,
	fechaNacimiento VARCHAR(10) NOT NULL,
	tipoDocumento VARCHAR(9) NOT NULL,
	nroDocumento INT NOT NULL,
	sexo CHAR(9) NOT NULL,
	genero CHAR(6) NULL,
	nacionalidad NVARCHAR(15) NOT NULL,
	fotoPerfil VARCHAR(40) NOT NULL,
	mail VARCHAR(60) NOT NULL,
	telefonoFijo VARCHAR(20) NOT NULL,
	telefonoContactoAlternativo VARCHAR(20) NULL,
	telefonoLaboral VARCHAR(20) NULL,
	fechaRegistro DATE NOT NULL,
	fechaActualizacion DATETIME NULL,
	idUsuario INT NOT NULL,
	idEstudio INT NOT NULL,
	idCobertura INT NOT NULL,
	idUsuarioActualizacion INT NULL,
	fechaBorrado DATETIME NULL
	CONSTRAINT PK_Paciente PRIMARY KEY (nroDocumento),
	CONSTRAINT FK_Usuario FOREIGN KEY (idUsuario) REFERENCES datosPaciente.Usuario(id),
	CONSTRAINT FK_Estudio FOREIGN KEY (idEstudio) REFERENCES datosPaciente.Estudio(id),
	CONSTRAINT FK_Cobertura FOREIGN KEY (idCobertura) REFERENCES datosPaciente.Cobertura(id)
)
GO

IF OBJECT_ID('datosReserva.EstadoTurno') IS NOT NULL
BEGIN
    DROP TABLE datosReserva.EstadoTurno
    IF OBJECT_ID('datosReserva.EstadoTurno') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosReserva.EstadoTurno.', 16, 1);
    ELSE
        PRINT 'Tabla datosReserva.EstadoTurno eliminada correctamente.'
END
GO
CREATE TABLE datosReserva.EstadoTurno
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombreEstado CHAR(9) NOT NULL,
	fechaBorrado DATETIME NULL,
	CONSTRAINT CK_EstadoTurno_nombreEstado 
        	CHECK (nombreEstado IN ('Atendido', 'Ausente', 'Cancelado'))
)
GO

IF OBJECT_ID('datosAtencion.Especialidad') IS NOT NULL
BEGIN
    DROP TABLE datosAtencion.Especialidad
    IF OBJECT_ID('datosAtencion.Especialidad') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosAtencion.Especialidad.', 16, 1);
    ELSE
        PRINT 'Tabla datosAtencion.Especialidad eliminada correctamente.'
END
GO
CREATE TABLE datosAtencion.Especialidad
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombre VARCHAR(20) NOT NULL
)
GO

IF OBJECT_ID('datosAtencion.SedeAtencion') IS NOT NULL
BEGIN
    DROP TABLE datosAtencion.SedeAtencion
    IF OBJECT_ID('datosAtencion.SedeAtencion') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosAtencion.SedeAtencion.', 16, 1);
    ELSE
        PRINT 'Tabla datosAtencion.SedeAtencion eliminada correctamente.'
END
GO
CREATE TABLE datosAtencion.SedeAtencion
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombre NVARCHAR(20) NOT NULL,
	direccion NVARCHAR(30) NOT NULL,
	fechaBorrado DATETIME NULL
)
GO

IF OBJECT_ID('datosAtencion.Medico') IS NOT NULL
BEGIN
    DROP TABLE datosAtencion.Medico
    IF OBJECT_ID('datosAtencion.Medico') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosAtencion.Medico.', 16, 1);
    ELSE
        PRINT 'Tabla datosAtencion.Medico eliminada correctamente.'
END
GO
CREATE TABLE datosAtencion.Medico
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombre NVARCHAR(20) NOT NULL,
	apellido NVARCHAR(20) NOT NULL,
	nroMatricula INT NOT NULL,
	idEspecialidad INT NOT NULL,
	fechaBorrado DATETIME NULL,
	CONSTRAINT FK_Especialidad FOREIGN KEY (idEspecialidad) REFERENCES datosAtencion.Especialidad(id)
)
GO

-- hay campos comentados a modo de simplificar el codigo ya que no necesitamos de dichos campos para esta parte del trabajo
IF OBJECT_ID('datosReserva.Reserva') IS NOT NULL
BEGIN
    DROP TABLE datosReserva.Reserva
    IF OBJECT_ID('datosReserva.Reserva') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosReserva.Reserva.', 16, 1);
    ELSE
        PRINT 'Tabla datosReserva.Reserva eliminada correctamente.'
END
GO
CREATE TABLE datosReserva.Reserva
(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	fecha DATE NOT NULL,
	hora TIME NOT NULL,
	idMedico INT NOT NULL,
	idEspecialidad INT NOT NULL,
	--idDireccionAtencion INT NOT NULL,
	idEstadoTurno INT NOT NULL,
	--idTipoTurno INT NOT NULL,
	idPaciente INT NOT NULL,
	CONSTRAINT FK_Especialidad FOREIGN KEY (idEspecialidad) REFERENCES datosAtencion.Especialidad(id),
	--CONSTRAINT FK_Direccion FOREIGN KEY (idDireccionAtencion) REFERENCES datosAtencion.SedeAtencion(id),
	CONSTRAINT FK_EstadoTurno FOREIGN KEY (idEstadoTurno) REFERENCES datosReserva.EstadoTurno(id),
	--CONSTRAINT FK_TipoTurno FOREIGN KEY (idTipoTurno) REFERENCES datosReserva.TipoTurno(id),
	CONSTRAINT FK_Paciente FOREIGN KEY (idPaciente) REFERENCES datosPaciente.Paciente(nroDocumento)
)
GO

-- Tabla creada para almacenar el JSON
IF OBJECT_ID('datosAtencion.Centro_Autorizaciones') IS NOT NULL
BEGIN
    DROP TABLE datosAtencion.Centro_Autorizaciones
    IF OBJECT_ID('datosAtencion.Centro_Autorizaciones') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar la tabla datosAtencion.Centro_Autorizaciones.', 16, 1);
    ELSE
        PRINT 'Tabla datosAtencion.Centro_Autorizaciones eliminada correctamente.'
END
GO
CREATE TABLE datosAtencion.Centro_Autorizaciones (
    Area varchar(30),
    Estudio varchar(30),
    Prestador varchar(30),
    Programa varchar(50),
    [Porcentaje Cobertura] decimal(5,2),
    Costo money,
    [Requiere autorizacion] varchar(5) -- Usamos varchar para guardar 'True' o 'False'
);
GO

---------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Creacion de los SP para cargar los datos desde CSV