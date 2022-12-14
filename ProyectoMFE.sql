-- Creacción de las tablas.
CREATE TABLE [CATEGORIAS] (
	ID_CATEGORIA int IDENTITY(1,1) NOT NULL,
	NOMBRE nvarchar(20) NOT NULL,
  CONSTRAINT [PK_CATEGORIAS] PRIMARY KEY CLUSTERED
  (
  [ID_CATEGORIA] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [DISPOSITIVOS] (
	NUM_SERIE nvarchar(20) NOT NULL,
	ID_CATEGORIA int NOT NULL,
	MARCA nvarchar(20) NOT NULL,
	MODELO nvarchar(40) NOT NULL,
	LOCALIZACION nvarchar(10) NOT NULL,
	ESTADO nvarchar(15) NOT NULL, -- Disponible, Pendiente, Ocupado, Instalado
  CONSTRAINT [PK_DISPOSITIVOS] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [SOLICITUDES] (
	NUM_SERIE nvarchar(20) NOT NULL,
	ID_USUARIO int NOT NULL,
	ESTADO nvarchar(15) NOT NULL, -- Pendiente, Aceptado, Rechazado
  CONSTRAINT [PK_SOLICITUDES] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC,
  [ID_USUARIO] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [USUARIOS] (
	ID_USUARIO int IDENTITY(1,1) NOT NULL,
	CORREO nvarchar(30) NOT NULL UNIQUE,
	NOMBRE nvarchar(30) NOT NULL,
	PRIMER_APELLIDO nvarchar(30) NOT NULL,
	SEGUNDO_APELLIDO nvarchar(30) NOT NULL,
	TIPO char NOT NULL,
	CONTRASENIA nvarchar(200) NOT NULL,
  CONSTRAINT [PK_USUARIOS] PRIMARY KEY CLUSTERED
  (
  [ID_USUARIO] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [PANTALLAS] (
	NUM_SERIE nvarchar(20) NOT NULL,
	PULGADAS int NOT NULL,
  CONSTRAINT [PK_PANTALLAS] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [HW_RED] (
	NUM_SERIE nvarchar(20) NOT NULL,
	NUM_PUERTOS int NOT NULL,
	VELOCIDAD int NOT NULL,
  CONSTRAINT [PK_HW_RED] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [ORDENADORES] (
	NUM_SERIE nvarchar(20) NOT NULL,
	PROCESADOR nvarchar(20) NOT NULL,
	RAM nvarchar(15) NOT NULL,
	DISCO_PRINCIPAL nvarchar(15) NOT NULL,
	DISCO_SECUNDARIO nvarchar(15),
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
ON DELETE CASCADE
GO
ALTER TABLE [PANTALLAS] CHECK CONSTRAINT [PANTALLAS_fk0]
GO

-- Creamos la clave foranea entre dispositivos y hardware red.
ALTER TABLE [HW_RED] WITH CHECK ADD CONSTRAINT [HW_RED_fk0] FOREIGN KEY ([NUM_SERIE]) REFERENCES [DISPOSITIVOS]([NUM_SERIE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HW_RED] CHECK CONSTRAINT [HW_RED_fk0]
GO

-- Creamos la clave foranea entre dispositivos y ordenadores.
ALTER TABLE [ORDENADORES] WITH CHECK ADD CONSTRAINT [ORDENADORES_fk0] FOREIGN KEY ([NUM_SERIE]) REFERENCES [DISPOSITIVOS]([NUM_SERIE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ORDENADORES] CHECK CONSTRAINT [ORDENADORES_fk0]
GO

-- Creacción de la tabla de histórico.
CREATE TABLE [HISTORICO_SOLICITUDES] (
	NUM_SERIE nvarchar(20) NOT NULL,
	ID_USUARIO int NOT NULL,
	FECHA datetime NOT NULL,
	ULTIMATUM nvarchar(15) NOT NULL, -- Rechazado, Aceptado
  CONSTRAINT [PK_HISTORICO_SOLICITUDES] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC,
  [ID_USUARIO] ASC,
  [FECHA] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)
)
GO

-- Trigger para poner en pendiente un dispositivo en el momento que se solicita.
CREATE TRIGGER SOLICITAR_EQUIPO 
ON SOLICITUDES AFTER INSERT 
AS
    DECLARE @num_dispositivo nvarchar(20)
	
	SELECT @num_dispositivo = NUM_SERIE FROM INSERTED
	
	UPDATE DISPOSITIVOS SET ESTADO = 'Pendiente' WHERE NUM_SERIE = @num_dispositivo
GO

-- Trigger cuando se acepta o rechaza una solicitud.
CREATE TRIGGER ULTIMATUM_EQUIPO 
ON SOLICITUDES AFTER UPDATE
AS
    DECLARE @num_dispositivo nvarchar(20), @num_usuario int, @ultimatum nvarchar(15)
	
	SELECT @num_dispositivo = NUM_SERIE FROM INSERTED
	SELECT @num_usuario = ID_USUARIO FROM INSERTED
	SELECT @ultimatum = ESTADO FROM INSERTED

	INSERT INTO HISTORICO_SOLICITUDES VALUES (@num_dispositivo, @num_usuario, GETDATE(), @ultimatum)
	
	IF @ultimatum = 'Rechazado'
		DELETE FROM SOLICITUDES WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @num_usuario
GO

-- Trigger cuando se devuelve un dispositivo.
CREATE TRIGGER DEVOLVER_EQUIPO 
ON SOLICITUDES AFTER DELETE
AS
    DECLARE @num_dispositivo nvarchar(20), @num_usuario int, @ultimatum nvarchar(15)
	
	SELECT @num_dispositivo = NUM_SERIE FROM DELETED
	SELECT @num_usuario = ID_USUARIO FROM DELETED

	UPDATE DISPOSITIVOS SET ESTADO = 'Disponible' WHERE NUM_SERIE = @num_dispositivo
	
	DELETE FROM SOLICITUDES WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @num_usuario
GO

-- Este procedimiento inserta una solicitud.
CREATE PROCEDURE INSERTAR_SOLICITUD(@correo nvarchar(30), @num_dispositivo nvarchar(20))
AS
	DECLARE @id_usuario int

	SELECT @id_usuario = ID_USUARIO FROM USUARIOS WHERE CORREO = @correo

	INSERT INTO SOLICITUDES VALUES (@num_dispositivo, @id_usuario, 'Pendiente')
GO

-- Este procedimiento acepta una solicitud.
CREATE PROCEDURE ACEPTAR_SOLICITUD(@correo nvarchar(30), @num_dispositivo nvarchar(20))
AS
	DECLARE @id_usuario int

	SELECT @id_usuario = ID_USUARIO FROM USUARIOS WHERE CORREO = @correo

	UPDATE SOLICITUDES SET ESTADO = 'Aceptado' WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @id_usuario
	UPDATE DISPOSITIVOS SET ESTADO = 'Ocupado' WHERE NUM_SERIE = @num_dispositivo
GO

-- Este procedimiento rechaza una solicitud.
CREATE PROCEDURE RECHAZAR_SOLICITUD(@correo nvarchar(30), @num_dispositivo nvarchar(20))
AS
	DECLARE @id_usuario int

	SELECT @id_usuario = ID_USUARIO FROM USUARIOS WHERE CORREO = @correo

	UPDATE SOLICITUDES SET ESTADO = 'Rechazado' WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @id_usuario
GO

-- Este procedimiento finaliza una solicitud.
CREATE PROCEDURE FINALIZAR_SOLICITUD(@correo nvarchar(30), @num_dispositivo nvarchar(20))
AS
	DECLARE @id_usuario int

	SELECT @id_usuario = ID_USUARIO FROM USUARIOS WHERE CORREO = @correo

	DELETE FROM SOLICITUDES WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @id_usuario
GO