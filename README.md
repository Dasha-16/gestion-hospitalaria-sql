# 🏥 CureSA — Sistema de Gestión Hospitalaria (Base de Datos)

> Trabajo Práctico Integrador — Materia: **Bases de Datos Aplicadas**  
> Grupo 12 · Turno Martes Noche · 2023

---

## 📋 Descripción del proyecto

CureSA es un sistema de base de datos relacional diseñado para el **Hospital Cure SA**, que gestiona la reserva de turnos médicos y la visualización de estudios clínicos.

El proyecto fue desarrollado en dos etapas principales:

- **TP3 – Diseño e implementación del modelo relacional:** creación de la base de datos, esquemas, tablas y Stored Procedures para todas las entidades del sistema.
- **TP4 – Importación de datos y generación de reportes XML:** importación de maestros desde archivos CSV/JSON y generación de informes XML para obras sociales.

---

## 🗂️ Estructura del repositorio

```
/
├── 01_schema.sql         # Creación de base de datos, esquemas y tablas
├── 02_procedures.sql     # Stored Procedures CRUD para todas las entidades
├── 03_data_import.sql    # Importación de datos desde archivos CSV y JSON
├── 04_reports.sql        # Generación de reportes XML para obras sociales
└── 05_tests.sql          # Casos de prueba (ejecutar de a secciones)
```

> Los archivos están numerados en el orden correcto de ejecución.

---

## 🧱 Modelo de datos

La base de datos `CURESA` está organizada en **tres esquemas**:

| Esquema           | Propósito                                                   |
|-------------------|-------------------------------------------------------------|
| `datosPaciente`   | Gestión de pacientes, usuarios, coberturas y prestadores    |
| `datosAtencion`   | Médicos, especialidades y sedes de atención                 |
| `datosReserva`    | Reservas, estados de turno y tipos de turno                 |

### Entidades principales

- **Paciente** — historia clínica, datos personales, cobertura médica
- **Médico** — matrícula, especialidad, sedes y horarios asignados
- **Prestador** — obras sociales y prepagas con vigencia contractual
- **Reserva** — turnos médicos con estado, tipo (presencial/virtual), sede y especialidad
- **Estudio** — estudios clínicos autorizados con resultados
- **SedeAtencion** — sucursales del hospital

---

## ⚙️ Funcionalidades implementadas

### Stored Procedures (CRUD completo)

Se implementaron operaciones de **Insertar, Modificar y Eliminar** (borrado lógico con `fechaBorrado`) para todas las entidades:

- `datosPaciente`: Usuario, Domicilio, Paciente, Prestador, Cobertura, Estudio
- `datosAtencion`: Especialidad, Médico, SedeAtencion, DiasXSede (horarios)
- `datosReserva`: Reserva, TipoTurno, EstadoTurno

Características destacadas:
- Validación de parámetros con `RAISERROR`
- Borrado lógico (soft delete) con `fechaBorrado`
- Uso de `ISNULL` para actualizaciones parciales
- Verificación de existencia antes de operar

### Importación y reportes

- Importación de maestros desde archivos **CSV** (Médicos, Pacientes, Prestadores, Sedes)
- Importación de parametrización desde **JSON** (autorización de estudios por obra social)
- Generación de reportes en **XML** con turnos atendidos para informar a la obra social (filtrable por prestador e intervalo de fechas)
- Diseñado para admitir **novedades periódicas** mensuales sin duplicar datos

---

## 🚀 Cómo ejecutar

### Requisitos

- **SQL Server** (2019 o superior recomendado)
- **SQL Server Management Studio (SSMS)**

### Pasos

1. Abrir SSMS y conectarse a tu instancia de SQL Server.
2. Ejecutar `01_schema.sql` — crea la base de datos `CURESA`, los esquemas y las tablas.
3. Ejecutar `02_procedures.sql` — crea todos los Stored Procedures.
4. Ejecutar `03_data_import.sql` — importa los datos desde CSV y JSON (los archivos deben estar en `C:\importar\`).
5. Ejecutar `04_reports.sql` — crea el SP para generar reportes XML.
6. Opcionalmente, ejecutar `05_tests.sql` de a secciones para verificar el funcionamiento.

---

## 💡 Decisiones de diseño destacadas

- **Borrado lógico** (`fechaBorrado`) en lugar de DELETE físico, para preservar historial.
- Los **contratos de prestadores** tienen fecha de baja para reflejar la vigencia del convenio; al darse de baja, los turnos asociados quedan disponibles.
- La tabla `DiasXSede` modela la disponibilidad de cada médico por sede y día de la semana, con clave primaria compuesta.
- Tipo de turno restringido a `'Virtual'` o `'Presencial'` mediante `CHECK CONSTRAINT`.
- Estado del turno con valores `'Atendido'`, `'Ausente'` o `'Cancelado'`.

---

## 👥 Integrantes

| Nombre               
|----------------------
| Santiago Galo        
| Juan Manuel Pergola  
| Dasha Apollaro       
| Johnathan Portillo   

---

## 🛠️ Tecnologías

- Microsoft SQL Server
- T-SQL (Transact-SQL)
- SQL Server Management Studio (SSMS)
