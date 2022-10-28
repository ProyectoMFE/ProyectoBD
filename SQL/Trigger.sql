-- Creacción de la tabla de histórico.
CREATE TABLE [HISTORICO_SOLICITUDES] (
	NUM_SERIE nvarchar NOT NULL,
	ID_USUARIO int NOT NULL,
	FECHA datetime NOT NULL,
	ULTIMATUM char NOT NULL,
  CONSTRAINT [PK_HISTORICO_SOLICITUDES] PRIMARY KEY CLUSTERED
  (
  [NUM_SERIE] ASC,
  [ID_USUARIO] ASC,
  [FECHA] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)
)

-- Trigger para ocupar un dispositivo en el momento que se solicita.
CREATE TRIGGER SOLICITAR_EQUIPO 
ON SOLICITUDES AFTER INSERT 
AS
    DECLARE @num_dispositivo nvarchar
	
	SELECT @num_dispositivo = NUM_SERIE FROM INSERTED
	
	UPDATE DISPOSITIVOS SET ESTADO = 'O' WHERE NUM_SERIE = @num_dispositivo
GO

-- Trigger cuando se acepta o rechaza una solicitud.
CREATE TRIGGER ULTIMATUM_EQUIPO 
ON SOLICITUDES AFTER UPDATE
AS
    DECLARE @num_dispositivo nvarchar, @num_usuario int, @ultimatum char
	
	SELECT @num_dispositivo = NUM_SERIE FROM INSERTED
	SELECT @num_usuario = ID_USUARIO FROM INSERTED
	SELECT @ultimatum = ESTADO FROM INSERTED

	INSERT INTO HISTORICO_SOLICITUDES VALUES (@num_dispositivo, @num_usuario, GETDATE(), @ultimatum)
	
	IF @ultimatum = 'O'
		DELETE FROM SOLICITUDES WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @num_usuario
GO

-- Trigger cuando se devuelve un dispositivo.
CREATE TRIGGER DEVOLVER_EQUIPO 
ON SOLICITUDES AFTER DELETE
AS
    DECLARE @num_dispositivo nvarchar, @num_usuario int, @ultimatum char
	
	SELECT @num_dispositivo = NUM_SERIE FROM DELETED
	SELECT @num_usuario = ID_USUARIO FROM DELETED

	UPDATE DISPOSITIVOS SET ESTADO = 'D' WHERE NUM_SERIE = @num_dispositivo
	
	DELETE FROM SOLICITUDES WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @num_usuario
GO
