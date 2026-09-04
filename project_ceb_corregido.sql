-- ============================================================
-- PROJECT CEB - BASE DE DATOS MYSQL
-- Sistema de gestión de estudiantes, acudientes y excusas
-- Compatible con MySQL 8.0+
-- ============================================================

DROP DATABASE IF EXISTS project_ceb;
CREATE DATABASE project_ceb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE project_ceb;

-- ============================================================
-- 1. ROLES Y USUARIOS
-- ============================================================

CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    correo VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    foto VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 2. ESTRUCTURA ACADÉMICA
-- ============================================================

CREATE TABLE niveles (
    id_nivel INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE grados (
    id_grado INT AUTO_INCREMENT PRIMARY KEY,
    id_nivel INT NOT NULL,
    numero TINYINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    UNIQUE KEY uq_grado_nivel (id_nivel, numero),
    FOREIGN KEY (id_nivel) REFERENCES niveles(id_nivel)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    id_grado INT NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    jornada ENUM('Mañana','Tarde','Única') NOT NULL DEFAULT 'Mañana',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_curso_grado (id_grado, codigo),
    FOREIGN KEY (id_grado) REFERENCES grados(id_grado)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 3. ESTUDIANTES
-- ============================================================

CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(30) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    id_curso INT NOT NULL,
    fecha_nacimiento DATE NULL,
    correo VARCHAR(150),
    telefono VARCHAR(30),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_estudiante_nombre (apellidos, nombres),
    INDEX idx_estudiante_curso (id_curso)
) ENGINE=InnoDB;

-- ============================================================
-- 4. ACUDIENTES
-- ============================================================

CREATE TABLE acudientes (
    id_acudiente INT AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(30) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(30),
    correo VARCHAR(150),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_acudiente_nombre (apellidos, nombres)
) ENGINE=InnoDB;

CREATE TABLE estudiante_acudiente (
    id_estudiante INT NOT NULL,
    id_acudiente INT NOT NULL,
    parentesco VARCHAR(50) NOT NULL,
    es_principal BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id_estudiante, id_acudiente),
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (id_acudiente) REFERENCES acudientes(id_acudiente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 5. CATÁLOGO DE EXCUSAS
-- ============================================================

CREATE TABLE tipos_excusa (
    id_tipo_excusa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE estados_excusa (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- ============================================================
-- 6. EXCUSAS
-- ============================================================

CREATE TABLE excusas (
    id_excusa INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_acudiente INT NOT NULL,
    id_tipo_excusa INT NOT NULL,
    id_estado INT NOT NULL DEFAULT 1,
    id_usuario_revisor INT NULL,
    fecha_excusa DATE NOT NULL,
    detalle TEXT NOT NULL,
    firma_digital VARCHAR(255),
    observacion TEXT,
    fecha_presentacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_revision DATETIME NULL,

    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (id_acudiente) REFERENCES acudientes(id_acudiente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (id_tipo_excusa) REFERENCES tipos_excusa(id_tipo_excusa)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (id_estado) REFERENCES estados_excusa(id_estado)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (id_usuario_revisor) REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_excusa_estudiante (id_estudiante),
    INDEX idx_excusa_acudiente (id_acudiente),
    INDEX idx_excusa_estado (id_estado),
    INDEX idx_excusa_fecha (fecha_excusa),
    INDEX idx_excusa_tipo (id_tipo_excusa)
) ENGINE=InnoDB;

-- ============================================================
-- 7. DOCUMENTOS DE LAS EXCUSAS
-- ============================================================

CREATE TABLE documentos_excusa (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_excusa INT NOT NULL,
    nombre_original VARCHAR(255) NOT NULL,
    nombre_sistema VARCHAR(255),
    ruta_archivo VARCHAR(500) NOT NULL,
    extension VARCHAR(20),
    tipo_mime VARCHAR(100),
    tamano_bytes BIGINT UNSIGNED,
    fecha_carga DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    FOREIGN KEY (id_excusa) REFERENCES excusas(id_excusa)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    INDEX idx_documento_excusa (id_excusa)
) ENGINE=InnoDB;

-- ============================================================
-- 8. CHECKLIST DE REVISIÓN
-- ============================================================

CREATE TABLE checklist_excusa (
    id_checklist INT AUTO_INCREMENT PRIMARY KEY,
    id_excusa INT NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    estado ENUM('Pendiente','En proceso','Completo') NOT NULL DEFAULT 'Pendiente',
    fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (id_excusa) REFERENCES excusas(id_excusa)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 9. HISTORIAL / ENTRADAS Y SALIDAS DE LAS EXCUSAS
-- ============================================================

CREATE TABLE movimientos_excusa (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_excusa INT NOT NULL,
    id_usuario INT NULL,
    tipo_movimiento ENUM(
        'Entrada',
        'En revisión',
        'Aprobación',
        'Rechazo',
        'Salida'
    ) NOT NULL,
    descripcion VARCHAR(500),
    fecha_movimiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_excusa) REFERENCES excusas(id_excusa)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_movimiento_excusa (id_excusa),
    INDEX idx_movimiento_fecha (fecha_movimiento)
) ENGINE=InnoDB;

-- ============================================================
-- 10. DATOS INICIALES
-- ============================================================

INSERT INTO roles (nombre, descripcion) VALUES
('Administrador', 'Puede gestionar estudiantes, acudientes y excusas'),
('Usuario', 'Puede registrar y consultar excusas');

INSERT INTO niveles (nombre) VALUES
('Primaria'),
('Bachillerato');

-- Grados de primaria
INSERT INTO grados (id_nivel, numero, nombre) VALUES
(1, 1, 'Primero'),
(1, 2, 'Segundo'),
(1, 3, 'Tercero'),
(1, 4, 'Cuarto'),
(1, 5, 'Quinto');

-- Grados de bachillerato
INSERT INTO grados (id_nivel, numero, nombre) VALUES
(2, 6, 'Sexto'),
(2, 7, 'Séptimo'),
(2, 8, 'Octavo'),
(2, 9, 'Noveno'),
(2, 10, 'Décimo'),
(2, 11, 'Undécimo');

-- Cursos de ejemplo usados por el proyecto
INSERT INTO cursos (id_curso, id_grado, codigo, jornada) VALUES
(1, 1, '102', 'Mañana'),
(2, 7, '604', 'Mañana'),
(3, 9, '805', 'Tarde'),
(4, 4, '907', 'Mañana'),
(5, 5, '1005', 'Mañana'),
(6, 5, '10-05', 'Mañana'),
(8, 9, '806', 'Tarde'),
(9, 9, '905', 'Mañana');

INSERT INTO tipos_excusa (nombre, descripcion) VALUES
('Salud', 'Excusa relacionada con una situación de salud'),
('Uniforme', 'Excusa relacionada con el uniforme escolar'),
('Inasistencia', 'Justificación de inasistencia');

INSERT INTO estados_excusa (nombre, descripcion) VALUES
('Pendiente', 'La excusa fue recibida y aún no ha sido revisada'),
('En revisión', 'La excusa está siendo revisada'),
('Aceptada', 'La excusa fue aprobada'),
('No aceptada', 'La excusa fue rechazada'),
('Anulada', 'La excusa fue anulada');

-- ============================================================
-- 11. USUARIOS DE EJEMPLO
-- IMPORTANTE: reemplazar estos hashes por hashes generados con
-- password_hash() en PHP para usuarios reales.
-- ============================================================

INSERT INTO usuarios
(id_rol, nombre, apellido, correo, password_hash)
VALUES
(1, 'Administrador', 'CEB', 'admin@projectceb.local',
 '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC7GJZ9k4q7bZ6qL8e6u'),
(2, 'Usuario', 'CEB', 'usuario@projectceb.local',
 '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC7GJZ9k4q7bZ6qL8e6u');

-- ============================================================
-- 12. ESTUDIANTES DE EJEMPLO
-- ============================================================

INSERT INTO estudiantes
(documento, nombres, apellidos, id_curso)
VALUES
('1012522232', 'Emiliano', 'Perez', 9),
('795222015', 'Zoe', 'Forero', 3),
('10276428', 'Zoe', 'Forero', 6),
('10357888', 'Laura', 'Rodriguez', 1),
('10000001', 'Allison', 'Pataquiva', 2),
('10000002', 'Eduardo', 'Lopez', 3);

-- ============================================================
-- 13. ACUDIENTES DE EJEMPLO
-- ============================================================

INSERT INTO acudientes
(documento, nombres, apellidos, telefono, correo)
VALUES
('5235484', 'Maria Carmen', 'Lopez Urrego', '3041104864', 'LopezMaria@gmail.com'),
('7654212', 'Paula Andrea', 'Forero Diaz', '3159841122', 'Paula@gmail.com'),
('5247867', 'Paula', 'Forero', '+57 3041104864', 'PaulaForero02@gmail.com'),
('54387244', 'Luis', 'Rodriguez', '+57 322869510', 'RodriguezLuis@gmail.com'),
('60000001', 'Macarena', 'Pataquiva', '3000000001', 'macarena@example.com'),
('60000002', 'Martha', 'Lopez', '3000000002', 'martha@example.com');

-- Relaciones estudiante-acudiente
INSERT INTO estudiante_acudiente
(id_estudiante, id_acudiente, parentesco, es_principal)
VALUES
(2, 3, 'Madre', TRUE),
(4, 4, 'Padre/Madre', TRUE),
(5, 5, 'Madre', TRUE),
(6, 6, 'Madre', TRUE);

-- ============================================================
-- 14. EXCUSAS DE EJEMPLO
-- ============================================================

-- Zoe - Salud - Pendiente
INSERT INTO excusas
(id_estudiante, id_acudiente, id_tipo_excusa, id_estado,
 fecha_excusa, detalle, firma_digital)
VALUES
(3, 3, 1, 1, '2026-08-25',
 'Justificación por situación de salud.',
 'firma_paula');

-- Laura - Uniforme - Pendiente
INSERT INTO excusas
(id_estudiante, id_acudiente, id_tipo_excusa, id_estado,
 fecha_excusa, detalle, firma_digital)
VALUES
(4, 4, 2, 1, '2026-07-15',
 'Justificación relacionada con el uniforme.',
 'firma_luis');

-- Allison - Uniforme - Aceptada
INSERT INTO excusas
(id_estudiante, id_acudiente, id_tipo_excusa, id_estado,
 id_usuario_revisor, fecha_excusa, detalle, observacion)
VALUES
(5, 5, 2, 3, 1, '2026-08-20',
 'Excusa por inconveniente con el uniforme.',
 'La excusa se encuentra completa');

-- Eduardo - Salud - Aceptada
INSERT INTO excusas
(id_estudiante, id_acudiente, id_tipo_excusa, id_estado,
 id_usuario_revisor, fecha_excusa, detalle, observacion)
VALUES
(6, 6, 1, 3, 1, '2026-08-21',
 'Excusa por situación de salud.',
 'La excusa se encuentra en orden');

-- Zoe - Uniforme - No aceptada
INSERT INTO excusas
(id_estudiante, id_acudiente, id_tipo_excusa, id_estado,
 id_usuario_revisor, fecha_excusa, detalle, observacion)
VALUES
(3, 3, 2, 4, 1, '2026-08-22',
 'Excusa por inconveniente con el uniforme.',
 'No se acepta la excusa ya que los documentos no están completos');

-- Laura - Salud - No aceptada
INSERT INTO excusas
(id_estudiante, id_acudiente, id_tipo_excusa, id_estado,
 id_usuario_revisor, fecha_excusa, detalle, observacion)
VALUES
(4, 4, 1, 4, 1, '2026-07-15',
 'Excusa relacionada con salud.',
 'No se acepta la excusa ya que es inválida');

-- ============================================================
-- 15. DOCUMENTOS
-- ============================================================

INSERT INTO documentos_excusa
(id_excusa, nombre_original, nombre_sistema, ruta_archivo, extension, tipo_mime)
VALUES
(3, 'excusa_Allison.pdf', 'excusa_3.pdf',
 'Documentos/excusa_Allison.pdf', 'pdf', 'application/pdf'),

(4, 'excusa_Eduardo.pdf', 'excusa_4.pdf',
 'Documentos/excusa_Eduardo.pdf', 'pdf', 'application/pdf'),

(5, 'excusa_zoe.pdf', 'excusa_5.pdf',
 'Documentos/excusa_zoe.pdf', 'pdf', 'application/pdf'),

(6, 'excusa_laura.pdf', 'excusa_6.pdf',
 'Documentos/excusa_laura.pdf', 'pdf', 'application/pdf');

-- ============================================================
-- 16. CHECKLIST DE EJEMPLO
-- ============================================================

INSERT INTO checklist_excusa (id_excusa, descripcion, estado) VALUES
(3, 'Adjuntar documento médico', 'Pendiente'),
(3, 'Validar firma del médico', 'Completo'),
(3, 'Verificar información', 'En proceso');

-- ============================================================
-- 17. HISTORIAL DE MOVIMIENTOS
-- ============================================================

INSERT INTO movimientos_excusa
(id_excusa, id_usuario, tipo_movimiento, descripcion)
VALUES
(1, NULL, 'Entrada', 'Excusa recibida por el sistema'),
(1, 1, 'En revisión', 'Administrador inició la revisión'),
(2, NULL, 'Entrada', 'Excusa recibida por el sistema'),
(3, NULL, 'Entrada', 'Excusa recibida por el sistema'),
(3, 1, 'Aprobación', 'Excusa aprobada por el administrador'),
(3, 1, 'Salida', 'Resultado de revisión disponible'),
(4, NULL, 'Entrada', 'Excusa recibida por el sistema'),
(4, 1, 'Aprobación', 'Excusa aprobada por el administrador'),
(4, 1, 'Salida', 'Resultado de revisión disponible'),
(5, NULL, 'Entrada', 'Excusa recibida por el sistema'),
(5, 1, 'Rechazo', 'Excusa no aceptada por documentos incompletos'),
(5, 1, 'Salida', 'Resultado de revisión disponible'),
(6, NULL, 'Entrada', 'Excusa recibida por el sistema'),
(6, 1, 'Rechazo', 'Excusa no aceptada por información inválida'),
(6, 1, 'Salida', 'Resultado de revisión disponible');

-- ============================================================
-- 18. VISTAS PARA EL PANEL ADMINISTRATIVO
-- ============================================================

CREATE OR REPLACE VIEW vista_estudiantes AS
SELECT
    e.id_estudiante,
    e.documento,
    CONCAT(e.nombres, ' ', e.apellidos) AS estudiante,
    c.codigo AS curso,
    g.numero AS numero_grado,
    CONCAT(g.numero, '°') AS grado,
    n.nombre AS nivel,
    c.jornada,
    e.activo
FROM estudiantes e
INNER JOIN cursos c ON e.id_curso = c.id_curso
INNER JOIN grados g ON c.id_grado = g.id_grado
INNER JOIN niveles n ON g.id_nivel = n.id_nivel;

CREATE OR REPLACE VIEW vista_acudientes AS
SELECT
    a.id_acudiente,
    a.documento,
    CONCAT(a.nombres, ' ', a.apellidos) AS acudiente,
    a.telefono,
    a.correo
FROM acudientes a
WHERE a.activo = TRUE;

CREATE OR REPLACE VIEW vista_excusas AS
SELECT
    ex.id_excusa,
    te.nombre AS tipo,
    ex.fecha_excusa AS fecha,
    CONCAT(e.nombres, ' ', e.apellidos) AS estudiante,
    e.documento AS documento_estudiante,
    c.codigo AS curso,
    CONCAT(g.numero, '°') AS grado,
    n.nombre AS nivel,
    CONCAT(a.nombres, ' ', a.apellidos) AS acudiente,
    a.documento AS documento_acudiente,
    ee.nombre AS estado,
    ex.detalle,
    ex.observacion,
    ex.fecha_presentacion,
    ex.fecha_revision
FROM excusas ex
INNER JOIN tipos_excusa te ON ex.id_tipo_excusa = te.id_tipo_excusa
INNER JOIN estudiantes e ON ex.id_estudiante = e.id_estudiante
INNER JOIN cursos c ON e.id_curso = c.id_curso
INNER JOIN grados g ON c.id_grado = g.id_grado
INNER JOIN niveles n ON g.id_nivel = n.id_nivel
INNER JOIN acudientes a ON ex.id_acudiente = a.id_acudiente
INNER JOIN estados_excusa ee ON ex.id_estado = ee.id_estado;

CREATE OR REPLACE VIEW vista_documentos_excusas AS
SELECT
    d.id_documento,
    d.id_excusa,
    d.nombre_original,
    d.ruta_archivo,
    d.extension,
    d.tipo_mime,
    d.fecha_carga,
    CONCAT(e.nombres, ' ', e.apellidos) AS estudiante,
    te.nombre AS tipo_excusa,
    ee.nombre AS estado
FROM documentos_excusa d
INNER JOIN excusas ex ON d.id_excusa = ex.id_excusa
INNER JOIN estudiantes e ON ex.id_estudiante = e.id_estudiante
INNER JOIN tipos_excusa te ON ex.id_tipo_excusa = te.id_tipo_excusa
INNER JOIN estados_excusa ee ON ex.id_estado = ee.id_estado;

-- ============================================================
-- 19. CONSULTAS ÚTILES PARA EL PROYECTO
-- ============================================================

-- Todas las excusas:
-- SELECT * FROM vista_excusas ORDER BY fecha DESC;

-- Excusas aceptadas:
-- SELECT * FROM vista_excusas WHERE estado = 'Aceptada';

-- Excusas no aceptadas:
-- SELECT * FROM vista_excusas WHERE estado = 'No aceptada';

-- Excusas pendientes:
-- SELECT * FROM vista_excusas WHERE estado = 'Pendiente';

-- Buscar por tipo:
-- SELECT * FROM vista_excusas WHERE tipo = 'Salud';

-- Buscar por estudiante:
-- SELECT * FROM vista_excusas
-- WHERE estudiante LIKE '%Zoe%';

-- Buscar por fecha:
-- SELECT * FROM vista_excusas
-- WHERE fecha = '2026-08-25';

-- Documentos de una excusa:
-- SELECT * FROM vista_documentos_excusas
-- WHERE id_excusa = 3;

-- Historial de una excusa:
-- SELECT * FROM movimientos_excusa
-- WHERE id_excusa = 3
-- ORDER BY fecha_movimiento ASC;

-- Estudiantes por nivel:
-- SELECT * FROM vista_estudiantes
-- WHERE nivel = 'Bachillerato';

-- Estudiantes por grado:
-- SELECT * FROM vista_estudiantes
-- WHERE numero_grado = 10;

-- Estudiantes por curso:
-- SELECT * FROM vista_estudiantes
-- WHERE curso = '10-05';

-- Acudientes:
-- SELECT * FROM vista_acudientes ORDER BY acudiente;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
