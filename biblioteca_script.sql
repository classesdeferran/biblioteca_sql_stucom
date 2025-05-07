/* 
Comentario
multilinea
 */

-- Creación de una base de datos
CREATE DATABASE IF NOT EXISTS biblioteca;

-- Borrado de la base de datos
-- DROP DATABASE IF EXISTS biblioteca;

-- Necesitamos decirle a MySQL cual BD vamos a usar
USE biblioteca;

-- Creación de una tabla
-- Hay que especificar el tipo de dato obligatoriamente
-- Otras propiedades son optativas
CREATE TABLE IF NOT EXISTS libros (
id_libro int AUTO_INCREMENT NOT NULL PRIMARY KEY, 
titulo_libro varchar(100) NOT NULL,
id_autor int not null,
editorial varchar(50) not null,
ejemplares_stock smallint
);

-- Inserción de datos "fila a fila"

-- Si no indicamos los nombres de las columnas deberán ser todas ellas, en el orden que se han creado 
INSERT INTO autores VALUES (1, "Jules", "Verne");

-- Pero se pueden especificar los nombres de las columnas. En ese caso deben estar al menos todas las obligatorias
-- Sigue este modelo:
-- INSERT INTO nombre_de_la_tabla(nombre_columna_1, nombre_columna_2) VALUES (valor_columna_1, valor_columna_2, etc)
INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Isaac", "Asimov"), ("Stanislaw", "Lem");
INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Stephen", "King");


-- Para mostra datos se utiliza SELECT
SELECT * FROM autores; /* el asterisco significa todas las columnas de la tabla */
-- Obtener los nombres de los autores que empiezan por S
SELECT nombre_autor, apellido_autor 
FROM autores
WHERE nombre_autor LIKE "S%"; 
/* LIKE permite el uso de 'wildcards' (comodines). 
% para cualquier cantidad de cualquier valor
_ (guión bajo) para un sólo caracter cualquiera */

-- Obtener los autores cuyo nombre contiene 5 letras
SELECT nombre_autor, apellido_autor 
FROM autores
WHERE nombre_autor LIKE "_____"; /* aquí hay 5 _ */

-- También podemos utilizar funciones predefinidas del sistema 
-- COUNT(columna) cuenta filas que se correspondan con el argumento
SELECT COUNT(*) as "cantidad de autores"
FROM autores;

INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Pepe", "Vargas Llosa");

-- Las actualizaciones de datos se realizan con UPDATE
-- Es importante la clausula WHERE para espcificar cual se quiere modificar
UPDATE autores SET nombre_autor = "Mario" WHERE apellido_autor = "Vargas Llosa";

-- DELETE FROM es para el borrado de datos. 
-- También deberíamos de especificar cual queremos borrar o los eliminará todos
DELETE FROM autores WHERE apellido_autor = "Vargas Llosa";

-- CONCAT y CONCAT_WS son funciones para concatenar textos
SELECT CONCAT(apellido_autor, ", ",nombre_autor) as autor
FROM autores
ORDER BY apellido_autor DESC, nombre_autor ASC
LIMIT 1 
;
SELECT CONCAT_WS(", ", UPPER(apellido_autor),nombre_autor) as autor
FROM autores
ORDER BY apellido_autor
LIMIT 1 
;

-- Podemos obtener información de cómo es una tabla (no los datos)
DESCRIBE libros;
describe autores_libros;

-- Quitar una columna de una tabla
ALTER TABLE libros
DROP COLUMN id_autor;

INSERT INTO libros (titulo_libro, editorial, ejemplares_stock) 
VALUES("La vuelta al mundo en 80 días", "Taurus", 5),
("De la Tierra a la Luna", "Taurus", 3),
("Yo, robot", "Gredos", 3),
("Solaris", "Alfauara", 5);

INSERT INTO autores_libros(id_autor, id_libro) VALUES
(1, 1), (1, 2), (2, 3), (3, 4);

CREATE TABLE editoriales (
id_editorial int AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_editorial varchar(50) NOT NULL,
id_poblacion int NOT NULL
);



CREATE TABLE poblaciones (
id_poblacion int AUTO_INCREMENT NOT NULL PRIMARY KEY,
poblacion varchar(25)
);

-- Quitar una columna de una tabla
ALTER TABLE editoriales
DROP COLUMN id_poblacion;

-- Obtener solo las editoriales de la tabla libros
-- SE puede hacer un INSERT con valores que etsán en otra tabla
INSERT INTO editoriales(nombre_editorial)
SELECT DISTINCT editorial FROM libros;

-- Añadir la columna id_editorial a la tabla libros
ALTER TABLE libros
ADD COLUMN id_editorial int NOT NULL;

UPDATE libros l, editoriales e
SET l.id_editorial = e.id_editorial
WHERE l.editorial = e.nombre_editorial;

ALTER TABLE libros
DROP COLUMN editorial;

insert into poblaciones(poblacion) VALUES ("Barcelona"), ("Madrid"), ("Cornellà"), ("París");

ALTER TABLE editoriales
ADD COLUMN id_poblacion int NOT NULL;

SELECT SUM(ejemplares_stock) as stock_total FROM libros;

-- ===========================================================
-- JOINS : para obtener información de varias tablas

-- Sistema simple pero NO recomendado
SELECT l.titulo_libro, e.nombre_editorial
FROM libros l, editoriales e
WHERE l.id_editorial = e.id_editorial;

-- Sistema de vinculación recomendado
SELECT l.titulo_libro, e.nombre_editorial
FROM libros l
JOIN editoriales e
ON l.id_editorial = e.id_editorial;

SELECT l.titulo_libro, e.nombre_editorial
FROM libros l
NATURAL JOIN editoriales e;

-- Nombre del autor, titulo del libro, editorial, poblacion
-- SELECT a.nombre_autor, l.titulo_libro, e.nombre_editorial, p.poblacion
-- FROM autores a


SELECT a.nombre_autor, l.titulo_libro
FROM autores a
LEFT JOIN autores_libros al
ON a.id_autor = al.id_autor
LEFT JOIN libros l
ON l.id_libro = al.id_libro
WHERE l.titulo_libro IS NULL;

-- poblaciones que no tienen editorial
SELECT p.poblacion
FROM poblaciones p
LEFT JOIN editoriales e
ON p.id_poblacion = e.id_poblacion
WHERE e.nombre_editorial IS NULL;

CREATE TABLE usuarios (
id_usuario int NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_usuario varchar(20) NOT NULL,
apellido_usuario varchar(50) NOT NULL,
fecha_nacimiento DATE,
carnet_biblio int UNIQUE NOT NULL,
fecha_inscripcion timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Para generar un numero aleatorio
SELECT FLOOR(RAND()*(99999999 - 10000000 + 1))+ 10000000 as carnet;

INSERT INTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio) VALUES
("Steve", "Jobs", "1955-02-24", FLOOR(RAND()*(99999999 - 10000000 + 1))+ 10000000),
("Letizia", "Ortiz", "1968-06-30", FLOOR(RAND()*(99999999 - 10000000 + 1))+ 10000000),
("Peter", "Parker", "2000-03-11", FLOOR(RAND()*(99999999 - 10000000 + 1))+ 10000000),
("Clark", "Kent", "1989-09-11", FLOOR(RAND()*(99999999 - 10000000 + 1))+ 10000000),
("Lois", "Lane", "1989-10-06", FLOOR(RAND()*(99999999 - 10000000 + 1))+ 10000000);

CREATE TABLE prestamos (
id_prestamo int NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_usuario int NOT NULL,
id_libro int NOT NULL,
fecha_prestamo timestamp DEFAULT CURRENT_TIMESTAMP,
fecha_devolucion timestamp  
);

INSERT INTO prestamos(id_usuario, id_libro) VALUES
(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (3, 1);

-- Obtener los préstamos de los libros prestados
SELECT l.titulo_libro, COUNT(p.id_libro) as prestamos
FROM libros l
NATURAL JOIN prestamos p
GROUP BY p.id_libro;

INSERT INTO prestamos(id_usuario, id_libro) VALUES (4, 4);

-- Obtener los préstamos de los libros prestados
SELECT l.titulo_libro
FROM libros l
NATURAL JOIN prestamos p
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) > 1
;

-- Obtener los libros con menor cantidad de prestamos
-- Primero debemos saber cuál la menor cantidad de préstamos
SELECT COUNT(p.id_libro) as minima_cantidad
FROM prestamos p
GROUP BY p.id_libro
ORDER BY minima_cantidad ASC
LIMIT 1;

-- Ahora podemos hacer el SELECT para obtener los libros
SELECT l.titulo_libro
FROM libros l
NATURAL JOIN prestamos p
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) = (
	SELECT COUNT(p.id_libro) as minima_cantidad
	FROM prestamos p
	GROUP BY p.id_libro
	ORDER BY minima_cantidad asc
	LIMIT 1
);


insert into libros(titulo_libro, ejemplares_stock, id_editorial)
values ('Python', 20, 1), ('HTML', 10, 1), ('CSS', 1, 1);

select * from libros where ejemplares_stock BETWEEN 1 and 5;
select * from libros where ejemplares_stock >= 1 and ejemplares_stock <= 5;

-- Título de libros en préstamo a usuarios cuyo nombre empieza por S o por L
-- y el nombre del usuario
SELECT l.titulo_libro, u.nombre_usuario, u.apellido_usuario
FROM usuarios u
NATURAL JOIN prestamos p
NATURAL JOIN libros l
WHERE u.nombre_usuario like 'S%' or u.nombre_usuario like 'L%' ;

-- Usuarios que han tomado en préstamo más de un libro
SELECT u.nombre_usuario, u.apellido_usuario 
FROM usuarios u
NATURAL JOIN prestamos p
GROUP BY p.id_usuario
HAVING COUNT(p.id_usuario) > 1;


-- Cuál o cuáles son los títulos de libros más prestados
-- Quiero saber cuál es la cantidad mayor de préstamos de un libro
SELECT COUNT(p.id_libro) as maximo
FROM prestamos p
GROUP BY p.id_libro
ORDER BY maximo DESC
LIMIT 1;

-- ¿Y cuál o cuáles son los libros?
SELECT l.titulo_libro
FROM libros l
NATURAL JOIN prestamos p
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) = (
	SELECT COUNT(p.id_libro) as maximo
	FROM prestamos p
	GROUP BY p.id_libro
	ORDER BY maximo DESC
	LIMIT 1
);

-- Añadimos un préstamo más insert into prestamos(id_usuario, id_libro) VALUES (5, 2);
 

use biblioteca;
-- PROCEDIMIENTO ALMACENADO
-- Ejemplo para añadir un usuario
DELIMITER $$
CREATE PROCEDURE insertUsuario (p_nombre varchar(20), p_apellido varchar(50), p_fecha_nacimiento date) 
BEGIN
INSERT INTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio) VALUES
(p_nombre, p_apellido, p_fecha_nacimiento, FLOOR(RAND()*(99999999 - 10000000 + 1))+ 10000000);
END $$
DELIMITER ;

-- Ejecución del Procedimiento
CALL insertUsuario ("Bruce", "Wayne", "1998-06-09");

-- Procedimiento Almacenado (Stored Procedure -> SP)
-- Inserción completa de un libro

DELIMITER //
CREATE PROCEDURE insertLibro (
p_titulo_libro varchar(100),
p_ejemplares_stock smallint,
p_nombre_editorial varchar(50),
p_poblacion varchar(25),
p_nombre_autor varchar(50),
p_apellido_autor varchar(100),
p_epoca varchar(20)
)
BEGIN

-- SET @id_poblacion = (SELECT id_poblacion FROM poblaciones WHERE poblacion = p_poblacion);
-- definir la variable local
DECLARE v_id_poblacion int;
DECLARE v_id_editorial int;
DECLARE v_id_libro int;
/* Encontrar el id de la población  */ 
SELECT id_poblacion INTO v_id_poblacion FROM poblaciones WHERE poblacion = p_poblacion;
/* Encontrar el id de la editorial  */ 
SELECT id_editorial INTO v_id_editorial FROM editoriales WHERE nombre_editorial = p_nombre_editorial;
/* Encontrar el id del libro */ 
SELECT id_libro INTO v_id_libro FROM libros WHERE titulo_libro = p_titulo_libro;


IF v_id_poblacion IS NULL THEN
	INSERT INTO poblaciones(poblacion) VALUES (p_poblacion);
    SELECT id_poblacion INTO v_id_poblacion FROM poblaciones WHERE poblacion = p_poblacion;
END IF;

IF v_id_editorial IS NULL THEN 
	INSERT INTO editoriales(nombre_editorial, id_poblacion) VALUES (p_nombre_editorial, v_id_poblacion);
	SELECT id_editorial INTO v_id_editorial FROM editoriales WHERE nombre_editorial = p_nombre_editorial;
END IF;

IF v_id_libro IS NULL THEN
	INSERT INTO libros (titulo_libro, ejemplares_stock, id_editorial) VALUES
    (p_titulo_libro, p_ejemplares_stock, v_id_editorial);
    SELECT id_libro INTO v_id_libro FROM libros WHERE titulo_libro = p_titulo_libro;
ELSE 
	UPDATE libros SET ejemplares_stock = ejemplares_stock + p_ejemplares_stock WHERE id_libro = v_id_libro;
END IF;





END //
DELIMITER ;

CALL insertLibro (
"MySQL",
5,
"X",
"Albacete",
"A",
"Pérez",
"futuro"
);


-- Obtener todos los datos de un libro
USE biblioteca;

DROP VIEW IF EXISTS vista_libros;
CREATE VIEW vista_libros AS
SELECT li.titulo_libro, li.ejemplares_stock, 
au.nombre_autor, au.apellido_autor, ep.epoca,
ed.nombre_editorial, po.poblacion
FROM poblaciones po
NATURAL JOIN editoriales ed
NATURAL JOIN libros li
NATURAL JOIN autores_libros al
NATURAL JOIN autores au
NATURAL JOIN epocas ep
ORDER BY li.titulo_libro;

SELECT * FROM vista_libros;


DROP TRIGGER IF EXISTS tr_disponibilidad;

DELIMITER $$
-- creación del trigger
CREATE TRIGGER tr_disponibilidad
-- Si se va a ejecutar antes (BEFORE) o después (AFTER) de
-- la acción sobre los datos de la tabla (INSERT, UPDATE, DELETE) 
BEFORE INSERT ON prestamos
FOR EACH ROW
BEGIN
DECLARE v_stock int;
DECLARE v_libros_prestados int;
SELECT COUNT(id_libro) INTO v_libros_prestados FROM PRESTAMOS WHERE id_libro = new.id_libro and id_usuario = new.id_usuario; 

SELECT ejemplares_stock INTO v_stock FROM libros WHERE id_libro = new.id_libro;

IF v_libros_prestados = 1 THEN
	-- funciona como un return
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ya tienes el libro prestado";
END IF;    
    
IF v_stock < 1 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No hay ejemplares disponibles";
ELSE
	UPDATE libros SET ejemplares_stock = ejemplares_stock - 1 WHERE id_libro = new.id_libro;
END IF;

END $$
DELIMITER ;



insert into prestamos(id_usuario, id_libro) VALUES(3, 2);



DELIMITER $$
-- creación del trigger
CREATE TRIGGER tr_disponibilidad
-- Si se va a ejecutar antes (BEFORE) o después (AFTER) de
-- la acción sobre los datos de la tabla (INSERT, UPDATE, DELETE) 
BEFORE INSERT ON prestamos
FOR EACH ROW
BEGIN
DECLARE v_stock int;
DECLARE v_libros_prestados int;
SELECT COUNT(id_libro) INTO v_libros_prestados FROM PRESTAMOS WHERE id_libro = new.id_libro and id_usuario = new.id_usuario; 

SELECT ejemplares_stock INTO v_stock FROM libros WHERE id_libro = new.id_libro;

IF v_libros_prestados = 1 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ya tienes el libro prestado";
ELSE
	IF v_stock < 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No hay ejemplares disponibles";
	ELSE
		UPDATE libros SET ejemplares_stock = ejemplares_stock - 1 WHERE id_libro = new.id_libro;
	END IF;
END IF;
END $$
DELIMITER ;


-- incrementar stock al borrar un préstamo


DELIMITER $$
CREATE FUNCTION fn_prestamos ( p_titulo varchar (100))
RETURNS int
DETERMINISTIC
BEGIN
DECLARE v_prestamos int;
SELECT COUNT(p.id_libro) INTO v_prestamos
FROM prestamos p
NATURAL JOIN libros l
WHERE l.titulo_libro = p_titulo;

RETURN v_prestamos;
END $$
DELIMITER ;

SELECT titulo_libro, fn_prestamos(titulo_libro)
FROM libros;


