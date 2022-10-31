-- Categorías de los dispositivos
INSERT INTO CATEGORIAS VALUES ('Ordenador')
INSERT INTO CATEGORIAS VALUES ('Switch')
INSERT INTO CATEGORIAS VALUES ('Pantalla')
INSERT INTO CATEGORIAS VALUES ('Componente')

-- Dispositivos
INSERT INTO DISPOSITIVOS VALUES ('AES21', 1, 'Dell', 'Centios 12', 'C9', 'D');
INSERT INTO ORDENADORES VALUES ('AES21', 'I5 7400', '4GB DDR4', 'SSD 120GB', 'HDD 500GB');
INSERT INTO DISPOSITIVOS VALUES ('OSI12', 2, 'Cisco', 'Runzic 212', 'C9', 'O');
INSERT INTO HW_RED VALUES ('OSI12', 32, 1000);
INSERT INTO DISPOSITIVOS VALUES ('OZE12', 3, 'Dell', 'Riya 412', 'C9', 'I');
INSERT INTO PANTALLAS VALUES ('OZE12', 32);
INSERT INTO DISPOSITIVOS VALUES ('GIE12', 4, 'Gigabyte', 'GTX 1050 TI 4GB', 'C9', 'E');

-- Usuarios
INSERT INTO USUARIOS VALUES ('jaime@iescomercio.com', 'Jaime', 'Fernández', 'Pérez', 'A', 'fde2fdb1dbf604aede0ffee76d26e4ce') -- Contraseña: jaime
INSERT INTO USUARIOS VALUES ('pepe@iescomercio.com', 'Pepe', 'Hernández', 'Ruiz', 'P', '926e27eecdbc7a18858b3798ba99bddd') -- Contraseña: pepe