-- Creacción de las tablas.
CREATE TABLE [CATEGORIAS] (
	ID_CATEGORIA int NOT NULL,
	NOMBRE nvarchar NOT NULL,
  CONSTRAINT [PK_CATEGORIAS] PRIMARY KEY CLUSTERED
  (
  [ID_CATEGORIA] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [DISPOSITIVOS] (
	NUM_SERIE nvarchar NOT NULL,
	ID_CATEGORIA int NOT NULL,
	MARCA nvarchar NOT NULL,
	MODELO nvarchar NOT NULL,
	LOCALIZACION nvarchar NOT NULL,
	ESTADO char NOT NULL,
  CONSTRAINT [PK_DISPOSITIVOS] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [SOLICITUDES] (
	NUM_SERIE nvarchar NOT NULL,
	ID_USUARIO int NOT NULL,
	ESTADO char NOT NULL,
  CONSTRAINT [PK_SOLICITUDES] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC,
  [ID_USUARIO] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [USUARIOS] (
	ID_USUARIO int NOT NULL,
	CORREO nvarchar NOT NULL UNIQUE,
	NOMBRE nvarchar NOT NULL,
	PRIMER_APELLIDO nvarchar NOT NULL,
	SEGUNDO_APELLIDO nvarchar NOT NULL,
	TIPO char NOT NULL,
	CONTRASENIA nvarchar NOT NULL,
  CONSTRAINT [PK_USUARIOS] PRIMARY KEY CLUSTERED
  (
  [ID_USUARIO] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [PANTALLAS] (
	NUM_SERIE nvarchar NOT NULL,
	PULGADAS int NOT NULL,
  CONSTRAINT [PK_PANTALLAS] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [HW_RED] (
	NUM_SERIE nvarchar NOT NULL,
	NUM_PUERTOS int NOT NULL,
	VELOCIDAD int NOT NULL,
  CONSTRAINT [PK_HW_RED] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [ORDENADORES] (
	NUM_SERIE nvarchar NOT NULL,
	PROCESADOR nvarchar NOT NULL,
	RAM nvarchar NOT NULL,
	DISCO_PRINCIPAL nvarchar NOT NULL,
	DISCO_SECUNDARIO nvarchar,
  CONSTRAINT [PK_ORDENADORES] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO


-- Creamos la clave foranea entre dispositivos y categoría.
ALTER TABLE [DISPOSITIVOS] WITH CHECK ADD CONSTRAINT [DISPOSITIVOS_fk0] FOREIGN KEY ([ID_CATEGORIA]) REFERENCES [CATEGORIAS]([ID_CATEGORIA])
ON UPDATE CASCADE
GO
ALTER TABLE [DISPOSITIVOS] CHECK CONSTRAINT [DISPOSITIVOS_fk0]
GO

-- Creamos la clave foranea entre solicitudes y dispositivos.
ALTER TABLE [SOLICITUDES] WITH CHECK ADD CONSTRAINT [SOLICITUDES_fk0] FOREIGN KEY ([NUM_SERIE]) REFERENCES [DISPOSITIVOS]([NUM_SERIE])
ON UPDATE CASCADE
GO
ALTER TABLE [SOLICITUDES] CHECK CONSTRAINT [SOLICITUDES_fk0]
GO

-- Creamos la clave foranea entre solicitudes y usuarios.
ALTER TABLE [SOLICITUDES] WITH CHECK ADD CONSTRAINT [SOLICITUDES_fk1] FOREIGN KEY ([ID_USUARIO]) REFERENCES [USUARIOS]([ID_USUARIO])
ON UPDATE CASCADE
GO
ALTER TABLE [SOLICITUDES] CHECK CONSTRAINT [SOLICITUDES_fk1]
GO

-- Creamos la clave foranea entre dispositivos y pantallas.
ALTER TABLE [PANTALLAS] WITH CHECK ADD CONSTRAINT [PANTALLAS_fk0] FOREIGN KEY ([NUM_SERIE]) REFERENCES [DISPOSITIVOS]([NUM_SERIE])
ON UPDATE CASCADE
GO
ALTER TABLE [PANTALLAS] CHECK CONSTRAINT [PANTALLAS_fk0]
GO

-- Creamos la clave foranea entre dispositivos y hardware red.
ALTER TABLE [HW_RED] WITH CHECK ADD CONSTRAINT [HW_RED_fk0] FOREIGN KEY ([NUM_SERIE]) REFERENCES [DISPOSITIVOS]([NUM_SERIE])
ON UPDATE CASCADE
GO
ALTER TABLE [HW_RED] CHECK CONSTRAINT [HW_RED_fk0]
GO

-- Creamos la clave foranea entre dispositivos y ordenadores.
ALTER TABLE [ORDENADORES] WITH CHECK ADD CONSTRAINT [ORDENADORES_fk0] FOREIGN KEY ([NUM_SERIE]) REFERENCES [DISPOSITIVOS]([NUM_SERIE])
ON UPDATE CASCADE
GO
ALTER TABLE [ORDENADORES] CHECK CONSTRAINT [ORDENADORES_fk0]
GO

