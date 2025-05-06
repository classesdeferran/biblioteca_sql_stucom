/* 
Comentario
multilinea
 */

CREATE DATABASE IF NOT EXISTS biblioteca;
-- DROP DATABASE IF EXISTS biblioteca;
# Esto también es un comentario pero no lo recomiendo

USE biblioteca;

CREATE TABLE IF NOT EXISTS libros (
id_libro int AUTO_INCREMENT NOT NULL PRIMARY KEY,
titulo_libro varchar(100) NOT NULL,
id_autor int not null,
editorial varchar(50) not null,
ejemplares_stock smallint
);

INSERT INTO autores VALUES (1, "Jules", "Verne");
INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Isaac", "Asimov"), ("Stanislaw", "Lem");
INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Stephen", "King");

SELECT * FROM autores;
-- Obtener los nombres de los autores que empiezan por S
SELECT nombre_autor, apellido_autor 
FROM autores
WHERE nombre_autor LIKE "S%";

-- Obtener los autores cuyo nombre contiene 5 letras
SELECT nombre_autor, apellido_autor 
FROM autores
WHERE nombre_autor LIKE "_____";

SELECT COUNT(*) as "cantidad de autores"
FROM autores;

INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Pepe", "Vargas Llosa");

UPDATE autores SET nombre_autor = "Mario" WHERE apellido_autor = "Vargas Llosa";

DELETE FROM autores WHERE apellido_autor = "Vargas Llosa";

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

DESCRIBE libros;
describe autores_libros;

ALTER TABLE libros
DROP COLUMN id_autor;

ALTER TABLE editoriales
ADD CONSTRAINT fk_poblaciones
FOREIGN KEY (id_poblacion)
REFERENCES poblaciones (id_poblacion)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE autores
ADD COLUMN id_epoca int NOT NULL;

CREATE TABLE epocas (
id_epoca int PRIMARY KEY AUTO_INCREMENT,
epoca varchar(20) NOT NULL
);

ALTER TABLE autores
ADD CONSTRAINT fk_epoca
FOREIGN KEY (id_epoca)
REFERENCES epocas(id_epoca)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

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


-- Cuál o cuales son los títulos de libros más prestados

 


