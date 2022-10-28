-- Este procedimiento inserta una solicitud.
CREATE PROCEDURE INSERTAR_SOLICITUD(@correo nvarchar, @num_dispositivo nvarchar)
AS
	DECLARE @id_usuario int

	SELECT @id_usuario = ID_USUARIO FROM USUARIOS WHERE CORREO = @correo

	INSERT INTO SOLICITUDES VALUES (@num_dispositivo, @id_usuario, 'O')
GO

-- Este procedimiento acepta una solicitud.
CREATE PROCEDURE ACEPTAR_SOLICITUD(@correo nvarchar, @num_dispositivo nvarchar)
AS
	DECLARE @id_usuario int

	SELECT @id_usuario = ID_USUARIO FROM USUARIOS WHERE CORREO = @correo

	UPDATE SOLICITUDES SET ESTADO = 'A' WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @id_usuario
GO

-- Este procedimiento rechaza o devuelve una solicitud.
CREATE PROCEDURE FINALIZAR_SOLICITUD(@correo nvarchar, @num_dispositivo nvarchar)
AS
	DECLARE @id_usuario int

	SELECT @id_usuario = ID_USUARIO FROM USUARIOS WHERE CORREO = @correo

	DELETE FROM SOLICITUDES WHERE NUM_SERIE = @num_dispositivo AND ID_USUARIO = @id_usuario
GO