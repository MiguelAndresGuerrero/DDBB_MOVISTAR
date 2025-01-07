USE movistar;

DELIMITER //

-- 1. Actualización automática del historial de servicios cuando se actualiza una contratación
CREATE TRIGGER after_contratacion_update
AFTER UPDATE ON contrataciones
FOR EACH ROW
BEGIN
    IF OLD.estado != NEW.estado THEN
        INSERT INTO historial_servicios (id_usuario, id_servicio, estado_antiguo, estado_nuevo, fecha_actualizacion)
        VALUES (NEW.id_usuario, NEW.id_servicio, OLD.estado, NEW.estado, NOW());
    END IF;
END //

-- UPDATE contrataciones SET estado = 'ACTIVO' WHERE id_contratacion = 123;

-- 2. Actualizar historial de servicios al insertar una nueva contratación
CREATE TRIGGER after_contratacion_insert
AFTER INSERT ON contrataciones
FOR EACH ROW
BEGIN
    INSERT INTO historial_servicios (id_usuario, id_servicio, estado_antiguo, estado_nuevo, fecha_actualizacion)
    VALUES (NEW.id_usuario, NEW.id_servicio, 'N/A', NEW.estado, NOW());
END //

-- INSERT INTO contrataciones (id_usuario, id_servicio, estado, fecha_contratacion) VALUES (1, 10, 'ACTIVO', NOW());

-- 3. Validación de elegibilidad para bonificaciones
CREATE TRIGGER check_bonificacion_eligibility
BEFORE INSERT ON bonificaciones
FOR EACH ROW
BEGIN
    DECLARE user_years INT;
    SELECT TIMESTAMPDIFF(YEAR, fecha_registro, NOW()) INTO user_years FROM usuarios WHERE id_usuario = NEW.id_usuario;
    IF user_years < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no tiene la antigüedad suficiente para recibir bonificación.';
    END IF;
END //

-- INSERT INTO bonificaciones (id_usuario, tipo_bonificacion, monto, fecha_asignacion) VALUES (5, 'DESCUENTO', 50, NOW());

-- 4. Actualizar el historial de servicios cuando se elimina una contratación
CREATE TRIGGER after_contratacion_delete
AFTER DELETE ON contrataciones
FOR EACH ROW
BEGIN
    INSERT INTO historial_servicios (id_usuario, id_servicio, estado_antiguo, estado_nuevo, fecha_actualizacion)
    VALUES (OLD.id_usuario, OLD.id_servicio, OLD.estado, 'CANCELADO', NOW());
END //

-- DELETE FROM contrataciones WHERE id_contratacion = 123;

-- 5. Verificación de cambios en las bonificaciones
CREATE TRIGGER after_bonificacion_update
AFTER UPDATE ON bonificaciones
FOR EACH ROW
BEGIN
    IF OLD.tipo_bonificacion != NEW.tipo_bonificacion THEN
        INSERT INTO cambios_bonificaciones (id_usuario, tipo_antiguo, tipo_nuevo, fecha_cambio)
        VALUES (NEW.id_usuario, OLD.tipo_bonificacion, NEW.tipo_bonificacion, NOW());
    END IF;
END //

-- UPDATE bonificaciones SET tipo_bonificacion = 'SERVICIO GRATUITO' WHERE id_bonificacion = 456;

-- 6. Notificación de nuevos informes generados
CREATE TRIGGER after_reporte_insert
AFTER INSERT ON reportes
FOR EACH ROW
BEGIN
    INSERT INTO log_notificaciones (mensaje, fecha_notificacion)
    VALUES (CONCAT('Nuevo reporte generado: ', NEW.nombre_reporte), NOW());
END //

-- INSERT INTO reportes (nombre_reporte, fecha_reporte) VALUES ('Reporte de ingresos', NOW());

-- 7. Control de acceso por tipo de usuario
CREATE TRIGGER check_user_access
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.categoria_usuario NOT IN ('NUEVO', 'REGULAR', 'LEAL') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de usuario es inválido.';
    END IF;
END //

-- INSERT INTO usuarios (id_usuario, nombre, categoria_usuario, fecha_registro) VALUES (100, 'Juan Perez', 'VIP', NOW());

-- 8. Actualización automática de precio de servicio
CREATE TRIGGER update_servicio_price
AFTER INSERT ON contrataciones
FOR EACH ROW
BEGIN
    UPDATE servicios SET precio = precio * 1.05 WHERE id_servicio = NEW.id_servicio;
END //

-- INSERT INTO contrataciones (id_usuario, id_servicio, estado, fecha_contratacion) VALUES (1, 2, 'ACTIVO', NOW());

-- 9. Control de usuarios con más de 5 servicios contratados
CREATE TRIGGER limit_user_services
BEFORE INSERT ON contrataciones
FOR EACH ROW
BEGIN
    DECLARE user_service_count INT;
    SELECT COUNT(*) INTO user_service_count FROM contrataciones WHERE id_usuario = NEW.id_usuario;
    IF user_service_count >= 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no puede contratar más de 5 servicios.';
    END IF;
END //

-- INSERT INTO contrataciones (id_usuario, id_servicio, estado, fecha_contratacion) VALUES (3, 2, 'ACTIVO', NOW());

-- 10. Verificar existencia de usuario antes de insertar una nueva contratación
CREATE TRIGGER check_user_exists_before_contratacion
BEFORE INSERT ON contrataciones
FOR EACH ROW
BEGIN
    DECLARE user_exists INT;

    SELECT COUNT(*) INTO user_exists
    FROM usuarios
    WHERE id_usuario = NEW.id_usuario;

    IF user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe en la base de datos.';
    END IF;
END //

-- INSERT INTO contrataciones (id_usuario, id_servicio, estado, fecha_contratacion) VALUES (3, 2, 'ACTIVO', NOW());

-- 11. Actualizar el total de servicios contratados por un usuario
CREATE TRIGGER update_user_service_count
AFTER INSERT ON contrataciones
FOR EACH ROW
BEGIN
    UPDATE usuarios
    SET total_servicios = total_servicios + 1
    WHERE id_usuario = NEW.id_usuario;
END //

-- INSERT INTO contrataciones (id_usuario, id_servicio, estado, fecha_contratacion) VALUES (1, 2, 'ACTIVO', NOW());

-- 12. Control de la actualización de bonificaciones por fecha
CREATE TRIGGER check_bonificacion_date
BEFORE UPDATE ON bonificaciones
FOR EACH ROW
BEGIN
    IF NEW.fecha_asignacion > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede asignar una bonificación con fecha futura.';
    END IF;
END //

-- UPDATE bonificaciones SET fecha_asignacion = '2025-02-01' WHERE id_bonificacion = 123;

-- 13. Notificar cambios en los usuarios
CREATE TRIGGER log_user_update
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log_usuarios (id_usuario, nombre_antiguo, nombre_nuevo, fecha_cambio)
    VALUES (NEW.id_usuario, OLD.nombre, NEW.nombre, NOW());
END //

-- UPDATE usuarios SET nombre = 'Carlos Perez' WHERE id_usuario = 5;

-- 14. Verificación de existencia de servicios antes de la contratación
CREATE TRIGGER check_service_exists
BEFORE INSERT ON contrataciones
FOR EACH ROW
BEGIN
    DECLARE service_count INT;
    SELECT COUNT(*) INTO service_count FROM servicios WHERE id_servicio = NEW.id_servicio;
    IF service_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El servicio no existe.';
    END IF;
END //

-- INSERT INTO contrataciones (id_usuario, id_servicio, estado, fecha_contratacion) VALUES (2, 10, 'ACTIVO', NOW());

-- 15. Registro de la fecha de última actualización de usuario
CREATE TRIGGER update_user_last_modified
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    UPDATE usuarios SET fecha_ultima_modificacion = NOW() WHERE id_usuario = NEW.id_usuario;
END //

-- UPDATE usuarios SET nombre = 'Ana Gomez' WHERE id_usuario = 8;

-- 16. Validación de contratos duplicados
CREATE TRIGGER check_duplicate_contracts
BEFORE INSERT ON contrataciones
FOR EACH ROW
BEGIN
    DECLARE contract_count INT;
    SELECT COUNT(*) INTO contract_count FROM contrataciones WHERE id_usuario = NEW.id_usuario AND id_servicio = NEW.id_servicio;
    IF contract_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario ya tiene contratado este servicio.';
    END IF;
END //

-- INSERT INTO contrataciones (id_usuario, id_servicio, estado, fecha_contratacion) VALUES (3, 5, 'ACTIVO', NOW());

-- 17. Registro de cambios en los precios de los servicios
CREATE TRIGGER log_service_price_changes
AFTER UPDATE ON servicios
FOR EACH ROW
BEGIN
    INSERT INTO log_precios_servicios (id_servicio, precio_antiguo, precio_nuevo, fecha_cambio)
    VALUES (NEW.id_servicio, OLD.precio, NEW.precio, NOW());
END //

-- UPDATE servicios SET precio = 100 WHERE id_servicio = 2;

-- 18. Eliminar solicitud cuando se cancela el servicio
CREATE TRIGGER delete_bonification_on_service_cancel
AFTER UPDATE ON contrataciones
FOR EACH ROW
BEGIN
    IF NEW.estado = 'CANCELADO' THEN
        DELETE FROM bonificaciones WHERE id_usuario = NEW.id_usuario AND id_servicio = NEW.id_servicio;
    END IF;
END //

-- UPDATE contrataciones SET estado = 'CANCELADO' WHERE id_contratacion = 3;

-- 19. Actualizar el historial de cambios cuando se cancela un servicio
CREATE TRIGGER log_service_cancellation
AFTER UPDATE ON contrataciones
FOR EACH ROW
BEGIN
    IF NEW.estado = 'CANCELADO' THEN
        INSERT INTO historial_servicios (id_usuario, id_servicio, estado_antiguo, estado_nuevo, fecha_actualizacion)
        VALUES (NEW.id_usuario, NEW.id_servicio, OLD.estado, NEW.estado, NOW());
    END IF;
END //

-- UPDATE contrataciones SET estado = 'CANCELADO' WHERE id_contratacion = 7;

-- 20. Notificar cuando un cliente recibe un servicio gratuito
CREATE TRIGGER log_free_service
AFTER INSERT ON bonificaciones
FOR EACH ROW
BEGIN
    IF NEW.tipo_bonificacion = 'SERVICIO GRATUITO' THEN
        INSERT INTO log_servicios_gratuitos (id_usuario, monto, fecha_bonificacion)
        VALUES (NEW.id_usuario, NEW.monto, NEW.fecha_asignacion);
    END IF;
END //

-- INSERT INTO bonificaciones (id_usuario, tipo_bonificacion, monto, fecha_asignacion) VALUES (4, 'SERVICIO GRATUITO', 0, NOW());

DELIMITER ;