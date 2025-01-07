use movistar;

-- 1. Registrar nuevo usuario
DELIMITER //
CREATE PROCEDURE registrar_usuario (
    IN p_id_usuario INT, 
    IN p_nombre VARCHAR(100), 
    IN p_apellido VARCHAR(100), 
    IN p_direccion VARCHAR(200), 
    IN p_telefono VARCHAR(30), 
    IN p_email VARCHAR(100), 
    IN p_fecha_registro DATE, 
    IN p_categoria_usuario ENUM('NUEVO', 'REGULAR', 'LEAL')
)
BEGIN
    INSERT INTO usuarios (id_usuario, nombre, apellido, direccion, telefono, email, fecha_registro, categoria_usuario)
    VALUES (p_id_usuario, p_nombre, p_apellido, p_direccion, p_telefono, p_email, p_fecha_registro, p_categoria_usuario);
END //
DELIMITER ;

-- CALL registrar_usuario(51, 'Juan', 'Pérez', 'Calle Falsa 123', '555123456', 'juan@example.com', '2024-01-01', 'NUEVO');

-- 2. Actualiza datos de usuarios
DELIMITER //
CREATE PROCEDURE actualizar_usuario (
    IN p_id_usuario INT, 
    IN p_nombre VARCHAR(100), 
    IN p_apellido VARCHAR(100), 
    IN p_direccion VARCHAR(200), 
    IN p_telefono VARCHAR(30), 
    IN p_email VARCHAR(100), 
    IN p_categoria_usuario ENUM('NUEVO', 'REGULAR', 'LEAL')
)
BEGIN
    UPDATE usuarios 
    SET nombre = p_nombre, apellido = p_apellido, direccion = p_direccion, 
        telefono = p_telefono, email = p_email, categoria_usuario = p_categoria_usuario
    WHERE id_usuario = p_id_usuario;
END //
DELIMITER ;

-- CALL actualizar_usuario(51, 'Juan', 'Pérez', 'Calle Falsa 123', '555987654', 'juanperez@example.com', 'REGULAR');

-- 3. Registrar nuevos servicios
DELIMITER //
CREATE PROCEDURE registrar_servicio (
    IN p_id_servicio INT, 
    IN p_nombre_servicio VARCHAR(100), 
    IN p_descripcion TEXT, 
    IN p_precio DECIMAL(10,2), 
    IN p_tipo ENUM('POSPAGO', 'PREPAGO', 'FIBRA')
)
BEGIN
    INSERT INTO servicios (id_servicio, nombre_servicio, descripcion, precio, tipo)
    VALUES (p_id_servicio, p_nombre_servicio, p_descripcion, p_precio, p_tipo);
END //
DELIMITER ;

-- CALL registrar_servicio(1, 'Internet Fibra Óptica', 'Servicio de internet de alta velocidad', 29.99, 'FIBRA');

-- 4. Actualizar algun servicio existente
DELIMITER //
CREATE PROCEDURE actualizar_servicio (
    IN p_id_servicio INT, 
    IN p_nombre_servicio VARCHAR(100), 
    IN p_descripcion TEXT, 
    IN p_precio DECIMAL(10,2), 
    IN p_tipo ENUM('POSPAGO', 'PREPAGO', 'FIBRA')
)
BEGIN
    UPDATE servicios 
    SET nombre_servicio = p_nombre_servicio, descripcion = p_descripcion, 
        precio = p_precio, tipo = p_tipo
    WHERE id_servicio = p_id_servicio;
END //
DELIMITER ;

-- CALL actualizar_servicio(1, 'Internet Fibra Óptica', 'Servicio de internet con mayor velocidad', 35.99, 'FIBRA');

-- 5. Clasificar automaticamente a los usuarios leales
DELIMITER //
CREATE PROCEDURE clasificar_usuario_leal()
BEGIN
    UPDATE usuarios
    SET categoria_usuario = 'LEAL'
    WHERE DATEDIFF(CURDATE(), fecha_registro) > 365 AND categoria_usuario != 'LEAL';
END //
DELIMITER ;

-- CALL asignar_bonificacion(1, 51, 'DESCUENTO', 10.00, '2024-01-01');

-- 6. Asignar alguna bonificacion a un usuario
DELIMITER //
CREATE PROCEDURE asignar_bonificacion (
    IN p_id_bonificacion INT,
    IN p_id_usuario INT,
    IN p_tipo_bonificacion ENUM('DESCUENTO', 'SERVICIO GRATUITO'),
    IN p_monto DECIMAL(10,2),
    IN p_fecha_asignacion DATE
)
BEGIN
    INSERT INTO bonificaciones (id_bonificacion, id_usuario, tipo_bonificacion, monto, fecha_asignacion)
    VALUES (p_id_bonificacion, p_id_usuario, p_tipo_bonificacion, p_monto, p_fecha_asignacion);
END //
DELIMITER ;

-- CALL asignar_bonificacion(1, 51, 'DESCUENTO', 10.00, '2024-01-01');

-- 7. Eliminar alguna bonificacion a un usuario
DELIMITER //
CREATE PROCEDURE eliminar_bonificacion (
    IN p_id_bonificacion INT
)
BEGIN
    DELETE FROM bonificaciones WHERE id_bonificacion = p_id_bonificacion;
END //
DELIMITER ;

-- CALL eliminar_bonificacion(1);

-- 8. Ver los servicios contratados de un usuario
DELIMITER //
CREATE PROCEDURE obtener_servicios_usuario (
    IN p_id_usuario INT
)
BEGIN
    SELECT s.id_servicio, s.nombre_servicio, s.descripcion, s.precio, s.tipo
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE c.id_usuario = p_id_usuario;
END //
DELIMITER ;

-- CALL obtener_servicios_usuario(51);

-- 9. Actualizar el estado de contratacion de un servicio
DELIMITER //
CREATE PROCEDURE actualizar_estado_contratacion (
    IN p_id_contratacion INT, 
    IN p_estado ENUM('ACTIVO', 'CANCELADO')
)
BEGIN
    UPDATE contrataciones
    SET estado = p_estado
    WHERE id_contratacion = p_id_contratacion;
END //
DELIMITER ;

-- CALL actualizar_estado_contratacion(1, 'CANCELADO');

-- 10. Eliminar una contratacion
DELIMITER //
CREATE PROCEDURE eliminar_contratacion (
    IN p_id_contratacion INT
)
BEGIN
    DELETE FROM contrataciones WHERE id_contratacion = p_id_contratacion;
END //
DELIMITER ;

-- CALL eliminar_contratacion(1);

-- 11. Ver usuarios con bonificaciones activas
DELIMITER //
CREATE PROCEDURE obtener_usuarios_con_bonificacion()
BEGIN
    SELECT u.id_usuario, u.nombre, u.apellido, b.tipo_bonificacion, b.monto
    FROM usuarios u
    JOIN bonificaciones b ON u.id_usuario = b.id_usuario
    WHERE b.fecha_asignacion <= CURDATE();
END //
DELIMITER ;

-- CALL obtener_usuarios_con_bonificacion();

-- 12. Ver los usuarios clasificados como leales
DELIMITER //
CREATE PROCEDURE obtener_usuarios_leales()
BEGIN
    SELECT id_usuario, nombre, apellido, fecha_registro 
    FROM usuarios 
    WHERE categoria_usuario = 'LEAL';
END //
DELIMITER ;

-- CALL obtener_usuarios_leales();

-- 13. Contar los servicios contratados por un usuario
DELIMITER //
CREATE PROCEDURE contar_servicios_usuario (
    IN p_id_usuario INT
)
BEGIN
    SELECT COUNT(*) AS total_servicios
    FROM contrataciones
    WHERE id_usuario = p_id_usuario;
END //
DELIMITER ;

-- CALL contar_servicios_usuario(51);

-- 14. Actualizar precio de un servicio
DELIMITER //
CREATE PROCEDURE actualizar_precio_servicio (
    IN p_id_servicio INT,
    IN p_nuevo_precio DECIMAL(10,2)
)
BEGIN
    UPDATE servicios
    SET precio = p_nuevo_precio
    WHERE id_servicio = p_id_servicio;
END //
DELIMITER ;

-- CALL actualizar_precio_servicio(1, 39.99);

-- 15. Generar reporte de usuario por categoria
DELIMITER //
CREATE PROCEDURE generar_reporte_usuarios_categoria()
BEGIN
    SELECT categoria_usuario, COUNT(*) AS cantidad
    FROM usuarios
    GROUP BY categoria_usuario;
END //
DELIMITER ;

-- CALL generar_reporte_usuarios_categoria();

-- 16. Ver reporte de servicios mas contratados
DELIMITER //
CREATE PROCEDURE reporte_servicios_contratados()
BEGIN
    SELECT s.nombre_servicio, COUNT(c.id_contratacion) AS cantidad_contrataciones
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    GROUP BY s.id_servicio
    ORDER BY cantidad_contrataciones DESC;
END //
DELIMITER ;

-- CALL reporte_servicios_contratados();

-- 17. Actualizar la bonificacion de un usuario
DELIMITER //
CREATE PROCEDURE actualizar_bonificacion (
    IN p_id_bonificacion INT, 
    IN p_monto DECIMAL(10,2)
)
BEGIN
    UPDATE bonificaciones
    SET monto = p_monto
    WHERE id_bonificacion = p_id_bonificacion;
END //
DELIMITER ;

-- CALL actualizar_bonificacion(1, 15.00);

-- 18. Eliminar un servicio
DELIMITER //
CREATE PROCEDURE eliminar_servicio (
    IN p_id_servicio INT
)
BEGIN
    DELETE FROM servicios WHERE id_servicio = p_id_servicio;
END //
DELIMITER ;

-- CALL eliminar_servicio(1);

-- 19. Generar reporte de cancelaciones
DELIMITER //
CREATE PROCEDURE reporte_cancelaciones()
BEGIN
    SELECT u.id_usuario, u.nombre, u.apellido, s.nombre_servicio, c.fecha_contratacion
    FROM contrataciones c
    JOIN usuarios u ON c.id_usuario = u.id_usuario
    JOIN servicios s ON c.id_servicio = s.id_servicio
    WHERE c.estado = 'CANCELADO';
END //
DELIMITER ;

-- CALL reporte_cancelaciones();

-- 20. Activar o desactivar un servicio
DELIMITER //
CREATE PROCEDURE cambiar_estado_servicio (
    IN p_id_usuario INT, 
    IN p_id_servicio INT, 
    IN p_estado ENUM('ACTIVO', 'INACTIVO')
)
BEGIN
    UPDATE contrataciones
    SET estado = p_estado
    WHERE id_usuario = p_id_usuario AND id_servicio = p_id_servicio;
END //
DELIMITER ;

-- CALL cambiar_estado_servicio(51, 1, 'INACTIVO');

DELIMITER //

CREATE PROCEDURE verificar_permiso(IN usuario_id INT, IN permiso_nombre VARCHAR(50))
BEGIN
    DECLARE tiene_permiso INT;

    SELECT COUNT(*)
    INTO tiene_permiso
    FROM roles_permisos rp
    JOIN permisos p ON rp.id_permiso = p.id_permiso
    JOIN usuarios u ON u.id_rol = rp.id_rol
    WHERE u.id_usuario = usuario_id AND p.nombre_permiso = permiso_nombre;

    IF tiene_permiso = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Acceso denegado: No tienes el permiso necesario.';
    END IF;
END //

DELIMITER ;