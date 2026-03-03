-- ============================================================
-- CureSA - Gestion Hospitalaria
-- 03_data_import.sql
-- Descripcion: Importacion de datos desde CSV y JSON
-- Archivos necesarios en C:\importar\
-- Prerequisito: 01_schema.sql
-- ============================================================

USE CURESA
GO

-- LUEGO DEJAR DOCUMENTACIÓN DEL BULK INSERT

-- Cosas a tener en cuenta: 
-- No admite la modificación de los ya ingresados.
-- Contemplamos asignar un usuario genérico al ser la primera vez que ingresa, con una contraseña 12345678
-- Luego el usuario deberá cambiar su contraseña


IF OBJECT_ID('CargarDatosDesdeCSV_Pacientes') IS NOT NULL
BEGIN
    DROP PROCEDURE CargarDatosDesdeCSV_Pacientes
    IF OBJECT_ID('CargarDatosDesdeCSV_Pacientes') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar el procedure CargarDatosDesdeCSV_Pacientes.', 16, 1);
    ELSE
        PRINT 'Procedure CargarDatosDesdeCSV_Pacientes eliminada correctamente.'
END
GO
CREATE OR ALTER PROCEDURE CargarDatosDesdeCSV_Pacientes
AS
BEGIN
	-- Crear una tabla temporal con la misma estructura que el archivo CSV
	CREATE TABLE #TempTable
	(
		Nombre NVARCHAR(50),  
		Apellido NVARCHAR(50),
		FechadeNacimiento VARCHAR(50),
		tipoDocumento VARCHAR(10),
		Nrodocumento VARCHAR(50),
		Sexo VARCHAR(10),
		genero VARCHAR(10),
		Telefonofijo VARCHAR(20),
		Nacionalidad VARCHAR(30),
		Mail VARCHAR(50),
		CalleyNro NVARCHAR(50),
		Localidad NVARCHAR(50),
		Provincia NVARCHAR(50)
	);

	-- Cargar datos desde el archivo CSV en la tabla temporal
	BULK INSERT #TempTable
	FROM 'C:\importar\Pacientes.csv'
	WITH (
		FIELDTERMINATOR = ';',  
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	);

	 -- Insertar en la tabla datosPaciente.Domicilio solo si no existen registros con el mismo nroDocumento
	INSERT INTO datosPaciente.Domicilio(calleYNro, piso, departamento, codigoPostal, pais, provincia, localidad, nroDocumento)
	SELECT
	CalleyNro,
	NULL,
	NULL,
	NULL,
	CAST(T.Nacionalidad AS NVARCHAR(15)),
	CAST(T.Provincia AS NVARCHAR(15)),
	CAST(T.Localidad AS NVARCHAR(15)),
	CAST(T.Nrodocumento AS int)
	FROM #TempTable T
	WHERE NOT EXISTS (SELECT 1 FROM datosPaciente.Domicilio WHERE nroDocumento = T.Nrodocumento);

	-- Realizar transformación de datos y luego insertar en la tabla datosPaciente.Paciente solo si no existen registros con el mismo nroDocumento
	INSERT INTO datosPaciente.Paciente(nombre, apellido, apellidomaterno, fechaNacimiento, tipoDocumento,
				nroDocumento, sexo, genero, nacionalidad, fotoPerfil, mail, telefonoFijo, telefonoContactoAlternativo, telefonoLaboral,
				fechaRegistro, fechaActualizacion, idUsuario, idEstudio, idCobertura, idUsuarioActualizacion)
	SELECT 
		CAST(T.Nombre AS VARCHAR(20)),  
		CAST(T.Apellido AS VARCHAR(20)),
		'No cargado',
		CAST(T.FechadeNacimiento AS varchar(10)),
		CAST(T.tipoDocumento AS VARCHAR(9)),
		CAST(T.Nrodocumento AS INT),
		CAST(T.Sexo AS VARCHAR(9)),
		CAST(T.genero AS VARCHAR(6)),
		CAST(T.Nacionalidad AS VARCHAR(15)),
		'No cargado',
		CAST(T.Mail AS VARCHAR(60)),
		CAST(T.TelefonoFijo AS VARCHAR(20)),
		'No cargado',
		'No cargado',
		GETDATE(),
		NULL,
		1,
		1,
		1,
		NULL
	FROM #TempTable T 
	WHERE NOT EXISTS (SELECT 1 FROM datosPaciente.Paciente WHERE nroDocumento = T.Nrodocumento);

	DROP TABLE #TempTable;
END
go

IF OBJECT_ID('CargarDatosDesdeCSV_Medicos') IS NOT NULL
BEGIN
    DROP PROCEDURE CargarDatosDesdeCSV_Medicos
    IF OBJECT_ID('CargarDatosDesdeCSV_Medicos') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar el procedure CargarDatosDesdeCSV_Medicos.', 16, 1);
    ELSE
        PRINT 'Procedure CargarDatosDesdeCSV_Medicos eliminada correctamente.'
END
GO
	    
CREATE OR ALTER PROCEDURE CargarDatosDesdeCSV_Medicos
AS
BEGIN
	-- Crear una tabla temporal con la misma estructura que el archivo CSV
	CREATE TABLE #TempTable
	(
		Nombre VARCHAR(50),  
		Apellidos VARCHAR(50),
		Especialidad VARCHAR(50),
		Numerodecolegiado VARCHAR(50)
	);

	-- Cargar datos desde el archivo CSV en la tabla temporal
	BULK INSERT #TempTable
	FROM 'C:\importar\Medicos.csv'
	WITH (
		FIELDTERMINATOR = ';',  
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	);

	-- Insertar en la tabla datosAtencion.Especialidad solo si no existen registros con el mismo nombre
	INSERT INTO datosAtencion.Especialidad (nombre)
	SELECT 
	DISTINCT(Especialidad) 
	FROM #tempTable T
	WHERE NOT EXISTS (SELECT 1 FROM datosAtencion.Especialidad WHERE nombre COLLATE Modern_Spanish_CI_AI = T.Especialidad COLLATE Modern_Spanish_CI_AI);

	-- Realizar transformación de datos y luego insertar en la tabla de destino
	INSERT INTO datosAtencion.Medico(nombre, apellido, idEspecialidad, nroMatricula)
	SELECT 
		CAST(T.Nombre AS VARCHAR(20)),  
		CAST(T.Apellidos AS VARCHAR(20)),
		E.id,
		CAST(Numerodecolegiado as INT)
	FROM #TempTable T 
	INNER JOIN datosAtencion.Especialidad E 
	ON T.Especialidad COLLATE Modern_Spanish_CI_AI = E.nombre COLLATE Modern_Spanish_CI_AI
	WHERE NOT EXISTS (SELECT 1 FROM datosAtencion.Medico WHERE nroMatricula = CAST(T.Numerodecolegiado AS INT));

	-- Eliminar la tabla temporal después de su uso 
	DROP TABLE #TempTable;		
END 
go

IF OBJECT_ID('CargarDatosDesdeCSV_Sedes') IS NOT NULL
BEGIN
    DROP PROCEDURE CargarDatosDesdeCSV_Sedes
    IF OBJECT_ID('CargarDatosDesdeCSV_Sedes') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar el procedure CargarDatosDesdeCSV_Sedes.', 16, 1);
    ELSE
        PRINT 'Procedure CargarDatosDesdeCSV_Sedes eliminada correctamente.'
END
GO
CREATE OR ALTER PROCEDURE CargarDatosDesdeCSV_Sedes
AS
BEGIN
	-- Crear una tabla temporal con la misma estructura que el archivo CSV
	CREATE TABLE #TempTable
	(
		nombre NVARCHAR(30) COLLATE Modern_Spanish_CI_AI NOT NULL,
		direccion NVARCHAR(30) COLLATE Modern_Spanish_CI_AI NOT NULL,
		localidad NVARCHAR(30) COLLATE Modern_Spanish_CI_AI,
		provincia NVARCHAR(30) COLLATE Modern_Spanish_CI_AI
	);

	-- Cargar datos desde el archivo CSV en la tabla temporal
	BULK INSERT #TempTable
	FROM 'C:\importar\Sedes.csv'
	WITH (
		FIELDTERMINATOR = ';',  
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
		--,ERRORFILE = 'C:\Dataset\ErroresSedes.csv'
	);

	-- Realizar transformación de datos y luego insertar en la tabla datosAtencion.SedeAtencion solo si no existen registros con el mismo nombre y dirección
	INSERT INTO datosAtencion.SedeAtencion(nombre, direccion, fechaBorrado)
	SELECT 
		CAST(T.nombre AS NVARCHAR(30)),  
		CAST(T.direccion AS NVARCHAR(30)),
		NULL
	FROM #TempTable T 
	WHERE NOT EXISTS (
	        SELECT 1 
	        FROM datosAtencion.SedeAtencion 
	        WHERE nombre COLLATE Modern_Spanish_CI_AI = T.nombre AND direccion COLLATE Modern_Spanish_CI_AI = T.direccion
   	);

	-- Eliminar la tabla temporal después de su uso 
	DROP TABLE #TempTable;
END 
GO

IF OBJECT_ID('CargarDatosDesdeCSV_Prestadores') IS NOT NULL
BEGIN
    DROP PROCEDURE CargarDatosDesdeCSV_Prestadores
    IF OBJECT_ID('CargarDatosDesdeCSV_Prestadores') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar el procedure CargarDatosDesdeCSV_Prestadores.', 16, 1);
    ELSE
        PRINT 'Procedure CargarDatosDesdeCSV_Prestadores eliminada correctamente.'
END
GO
CREATE OR ALTER PROCEDURE CargarDatosDesdeCSV_Prestadores
AS
BEGIN
	-- Crear una tabla temporal con la misma estructura que el archivo CSV
	CREATE TABLE #TempTable
	(
		nombre NVARCHAR(40) COLLATE Modern_Spanish_CI_AI NOT NULL,
		tipoPlan NVARCHAR(40) COLLATE Modern_Spanish_CI_AI NOT NULL
	);

	-- Cargar datos desde el archivo CSV en la tabla temporal
	BULK INSERT #TempTable
	FROM 'C:\importar\Prestador.csv'
	WITH (
		FIELDTERMINATOR = ';',  
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	);
	
	-- Realizar transformación de datos y luego insertar en la tabla datosPaciente.Prestador solo si no existen registros con el mismo nombre y tipoPlan
	INSERT INTO datosPaciente.Prestador(nombre, tipoPlan, fechaBorrado)
	SELECT 
		CAST(T.nombre AS NVARCHAR(30)),  
		CAST(REPLACE(T.tipoPlan, ';;', '') AS NVARCHAR(30)) COLLATE Modern_Spanish_CI_AI,
		NULL
	FROM #TempTable T 
	WHERE NOT EXISTS (
	        SELECT 1 
	        FROM datosPaciente.Prestador 
	        WHERE nombre COLLATE Modern_Spanish_CI_AI = T.nombre AND tipoPlan COLLATE Modern_Spanish_CI_AI = REPLACE(T.tipoPlan, ';;', '')
    	);

	-- Eliminar la tabla temporal después de su uso 
	DROP TABLE #TempTable;
END 
GO

-----------------------------------------------------------------------------------
-- Importar contenido del archivo JSON a nuestra tabla datosAtencion.Centro_Autorizaciones

-- Vaciamos la tabla
IF OBJECT_ID('CargarDatosDesdeJSON') IS NOT NULL
BEGIN
    DROP PROCEDURE CargarDatosDesdeJSON
    IF OBJECT_ID('CargarDatosDesdeJSON') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar el procedure CargarDatosDesdeJSON.', 16, 1);
    ELSE
        PRINT 'Procedure CargarDatosDesdeJSON eliminada correctamente.'
END
GO
CREATE OR ALTER PROCEDURE CargarDatosDesdeJSON
AS
BEGIN
	DELETE FROM datosAtencion.Centro_Autorizaciones

	-- Guardamos nuestro json en una variable
	DECLARE @jsonEstudiosClinicos NVARCHAR(MAX);
	SET @jsonEstudiosClinicos = (
		SELECT * 
		FROM OPENROWSET (BULK 'C:\importar\Centro_Autorizaciones.Estudios clinicos.json', SINGLE_CLOB) as JsonFile
	)
	-- Insertar los resultados de la consulta en la tabla creada
	INSERT INTO datosAtencion.Centro_Autorizaciones (Area, Estudio, Prestador, Programa, [Porcentaje Cobertura], Costo, [Requiere autorizacion])
	SELECT 
		Area,
		Estudio,
		Prestador,
		Programa,
		[Porcentaje Cobertura],
		Costo,
		CASE 
			WHEN [Requiere autorizacion] = 1 THEN 'True'
			ELSE 'False'
		END AS [Requiere autorizacion]
	FROM OPENJSON(@jsonEstudiosClinicos)
	WITH(
		Area varchar(30) '$.Area',
		Estudio varchar(30) '$.Estudio',
		Prestador varchar(30) '$.Prestador',
		Programa varchar(50) '$.Plan',
		[Porcentaje Cobertura] int '$."Porcentaje Cobertura"',
		Costo money '$.Costo',
		[Requiere autorizacion] bit '$."Requiere autorizacion"'
	)
	WHERE NOT EXISTS (
		SELECT 1 
		FROM datosAtencion.Centro_Autorizaciones ca
		WHERE ca.Area = Area
		AND ca.Estudio = Estudio
		AND ca.Prestador = Prestador
		AND ca.Programa = Programa
		AND ca.[Porcentaje Cobertura] = [Porcentaje Cobertura]
	);
END
GO
--select * from datosAtencion.Centro_Autorizaciones

-----------------------------------------------------------------------------------