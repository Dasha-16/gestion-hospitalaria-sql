-- ============================================================
-- CureSA - Gestion Hospitalaria
-- 04_reports.sql
-- Descripcion: Generacion de reportes XML para obras sociales
-- Prerequisito: 01_schema.sql, 02_procedures.sql
-- ============================================================

USE CURESA
GO

-- Generar archivo XML detallando los turnos atendidos para informar a la Obra Social
IF OBJECT_ID('GenerarInformeTurnos') IS NOT NULL
BEGIN
    DROP PROCEDURE GenerarInformeTurnos
    IF OBJECT_ID('GenerarInformeTurnos') IS NOT NULL
	RAISERROR('Ocurrió un error al intentar eliminar el procedure GenerarInformeTurnos.', 16, 1);
    ELSE
        PRINT 'Procedure GenerarInformeTurnos eliminada correctamente.'
END
GO
CREATE OR ALTER PROCEDURE GenerarInformeTurnos(
    @NombreObraSocial NVARCHAR(255),
    @FechaInicio DATE,
    @FechaFin DATE
)
AS
BEGIN
    SELECT 
        P.Apellido AS 'ApellidoPaciente',
        P.Nombre AS 'NombrePaciente',
        P.nroDocumento AS 'DNIPaciente',
        r.fecha, 
        r.hora, 
        m.nombre AS 'NombreProfesional', 
        m.nroMatricula AS 'MatriculaProfesional', 
        e.nombre AS especialidad
    FROM datosReserva.Reserva AS r
    INNER JOIN datosAtencion.Medico AS m ON r.idMedico = m.id
    INNER JOIN datosAtencion.Especialidad AS e ON r.idEspecialidad = e.id
    INNER JOIN datosPaciente.Paciente AS P ON r.idPaciente = P.nroDocumento
    WHERE r.idPaciente IN (
        SELECT P.nroDocumento 
        FROM datosPaciente.Paciente AS P
        INNER JOIN datosPaciente.Cobertura AS C ON P.idCobertura = C.id
        INNER JOIN datosPaciente.Prestador AS PR ON C.idPrestador = PR.id
        WHERE PR.nombre = @NombreObraSocial
    )
    AND r.idEstadoTurno = 1
	AND r.fecha BETWEEN @FechaInicio AND @FechaFin
    FOR xml raw('Registro'), elements, root('XML');
END
GO
--Esto devuelve toda 1 fila con los datos en formato xml, si los clickeas te abre una pestaña nueva y ahi se pueden guardar

-----------------------------------------------------------------------------------
-- Creo un usuario generico, un estudio genérico, una cobertura generica y un prestador genérico 





