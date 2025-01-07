use movistar;

-- 1. Determinar la categoría de un usuario

DELIMITER //
CREATE FUNCTION obtener_categoria_usuario (p_id_usuario INT)
RETURNS ENUM('NUEVO', 'REGULAR', 'LEAL')
BEGIN
    DECLARE categoria ENUM('NUEVO', 'REGULAR', 'LEAL');
    
    SELECT categoria_usuario INTO categoria
    FROM usuarios
    WHERE id_usuario = p_id_usuario;
    
    RETURN categoria;
END //
DELIMITER ;

-- SELECT obtener_categoria_usuario(1);

-- 2. Calcular ingresos totales por tipo de servicio

DELIMITER //
CREATE FUNCTION ingresos_totales_por_tipo (p_tipo_servicio ENUM('POSPAGO', 'PREPAGO', 'FIBRA'))
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_ingresos DECIMAL(10,2);
    
    SELECT SUM(s.precio) INTO total_ingresos
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE s.tipo = p_tipo_servicio AND c.estado = 'ACTIVO';
    
    RETURN total_ingresos;
END //
DELIMITER ;

-- SELECT ingresos_totales_por_tipo('PREPAGO');

-- 3. Calcular el número de servicios contratados por un usuario

DELIMITER //
CREATE FUNCTION contar_servicios_contratados (p_id_usuario INT)
RETURNS INT
BEGIN
    DECLARE total_servicios INT;
    
    SELECT COUNT(*) INTO total_servicios
    FROM contrataciones
    WHERE id_usuario = p_id_usuario AND estado = 'ACTIVO';
    
    RETURN total_servicios;
END //
DELIMITER ;

-- SELECT contar_servicios_contratados(1);

-- 4. Calcular el total de bonificaciones asignadas a un usuario

DELIMITER //
CREATE FUNCTION total_bonificaciones_usuario (p_id_usuario INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_bonificaciones DECIMAL(10,2);
    
    SELECT SUM(b.monto) INTO total_bonificaciones
    FROM bonificaciones b
    WHERE b.id_usuario = p_id_usuario AND b.fecha_asignacion <= CURDATE();
    
    RETURN total_bonificaciones;
END //
DELIMITER ;

-- SELECT total_bonificaciones_usuario(1);

-- 5. Calcular el tiempo en días desde que un usuario se registró

DELIMITER //
CREATE FUNCTION tiempo_registro_usuario (p_id_usuario INT)
RETURNS INT
BEGIN
    DECLARE dias_registro INT;
    
    SELECT DATEDIFF(CURDATE(), fecha_registro) INTO dias_registro
    FROM usuarios
    WHERE id_usuario = p_id_usuario;
    
    RETURN dias_registro;
END //
DELIMITER ;

-- SELECT tiempo_registro_usuario(1);

-- 6. Calcular el precio total de los servicios contratados por un usuario

DELIMITER //
CREATE FUNCTION precio_total_servicios_usuario (p_id_usuario INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_precio DECIMAL(10,2);
    
    SELECT SUM(s.precio) INTO total_precio
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE c.id_usuario = p_id_usuario AND c.estado = 'ACTIVO';
    
    RETURN total_precio;
END //
DELIMITER ;

-- SELECT precio_total_servicios_usuario(1);

-- 7. Calcular el porcentaje de bonificación de un usuario

DELIMITER //
CREATE FUNCTION porcentaje_bonificacion_usuario (p_id_usuario INT)
RETURNS DECIMAL(5,2)
BEGIN
    DECLARE total_bonificacion DECIMAL(10,2);
    DECLARE total_precio DECIMAL(10,2);
    DECLARE porcentaje DECIMAL(5,2);
    
    SELECT SUM(b.monto) INTO total_bonificacion
    FROM bonificaciones b
    WHERE b.id_usuario = p_id_usuario;
    
    SELECT SUM(s.precio) INTO total_precio
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE c.id_usuario = p_id_usuario AND c.estado = 'ACTIVO';
    
    IF total_precio > 0 THEN
        SET porcentaje = (total_bonificacion / total_precio) * 100;
    ELSE
        SET porcentaje = 0;
    END IF;
    
    RETURN porcentaje;
END //
DELIMITER ;

-- SELECT porcentaje_bonificacion_usuario(1);

-- 8. Calcular el número total de usuarios leales

DELIMITER //
CREATE FUNCTION contar_usuarios_leales ()
RETURNS INT
BEGIN
    DECLARE total_leales INT;
    
    SELECT COUNT(*) INTO total_leales
    FROM usuarios
    WHERE categoria_usuario = 'LEAL';
    
    RETURN total_leales;
END //
DELIMITER ;

-- SELECT contar_usuarios_leales();

-- 9. Calcular la cantidad de servicios contratados por tipo

DELIMITER //
CREATE FUNCTION contar_servicios_por_tipo (p_tipo_servicio ENUM('POSPAGO', 'PREPAGO', 'FIBRA'))
RETURNS INT
BEGIN
    DECLARE total_servicios INT;
    
    SELECT COUNT(*) INTO total_servicios
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE s.tipo = p_tipo_servicio AND c.estado = 'ACTIVO';
    
    RETURN total_servicios;
END //
DELIMITER ;

-- SELECT contar_servicios_por_tipo('FIBRA');

-- 10. Calcular el número de servicios cancelados por usuario

DELIMITER //
CREATE FUNCTION contar_servicios_cancelados_usuario (p_id_usuario INT)
RETURNS INT
BEGIN
    DECLARE total_cancelados INT;
    
    SELECT COUNT(*) INTO total_cancelados
    FROM contrataciones
    WHERE id_usuario = p_id_usuario AND estado = 'CANCELADO';
    
    RETURN total_cancelados;
END //
DELIMITER ;

-- SELECT contar_servicios_cancelados_usuario(1);

-- 11. Calcular los ingresos totales por usuario

DELIMITER //
CREATE FUNCTION ingresos_totales_usuario (p_id_usuario INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_ingresos DECIMAL(10,2);
    
    SELECT SUM(s.precio) INTO total_ingresos
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE c.id_usuario = p_id_usuario AND c.estado = 'ACTIVO';
    
    RETURN total_ingresos;
END //
DELIMITER ;

-- SELECT ingresos_totales_usuario(1);

-- 12. Calcular el total de servicios activos en la base de datos

DELIMITER //
CREATE FUNCTION contar_servicios_activos ()
RETURNS INT
BEGIN
    DECLARE total_servicios_activos INT;
    
    SELECT COUNT(*) INTO total_servicios_activos
    FROM contrataciones
    WHERE estado = 'ACTIVO';
    
    RETURN total_servicios_activos;
END //
DELIMITER ;

-- SELECT contar_servicios_activos();

-- 13. Calcular el promedio de precio de los servicios contratados

DELIMITER //
CREATE FUNCTION promedio_precio_servicios ()
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE promedio DECIMAL(10,2);
    
    SELECT AVG(s.precio) INTO promedio
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE c.estado = 'ACTIVO';
    
    RETURN promedio;
END //
DELIMITER ;

-- SELECT promedio_precio_servicios();

-- 14. Calcular el número de usuarios que tienen más de un servicio

DELIMITER //
CREATE FUNCTION contar_usuarios_con_multiple_servicio ()
RETURNS INT
BEGIN
    DECLARE total_usuarios INT;
    
    SELECT COUNT(DISTINCT c.id_usuario) INTO total_usuarios
    FROM contrataciones c
    GROUP BY c.id_usuario
    HAVING COUNT(c.id_servicio) > 1;
    
    RETURN total_usuarios;
END //
DELIMITER ;

-- SELECT contar_usuarios_con_multiple_servicio();

-- 15. Calcular el total de ingresos por servicio específico

DELIMITER //
CREATE FUNCTION ingresos_por_servicio (p_id_servicio INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_ingresos DECIMAL(10,2);
    
    SELECT SUM(s.precio) INTO total_ingresos
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE s.id_servicio = p_id_servicio AND c.estado = 'ACTIVO';
    
    RETURN total_ingresos;
END //
DELIMITER ;

-- SELECT ingresos_por_servicio(2);

-- 16. Calcular la edad promedio de los usuarios

DELIMITER //
CREATE FUNCTION edad_promedio_usuarios ()
RETURNS DECIMAL(5,2)
BEGIN
    DECLARE edad_promedio DECIMAL(5,2);
    
    SELECT AVG(DATEDIFF(CURDATE(), fecha_registro) / 365.25) INTO edad_promedio
    FROM usuarios;
    
    RETURN edad_promedio;
END //
DELIMITER ;

-- SELECT edad_promedio_usuarios();

-- 17. Calcular el total de usuarios que han cancelado sus servicios

DELIMITER //
CREATE FUNCTION contar_usuarios_con_cancelaciones ()
RETURNS INT
BEGIN
    DECLARE total_cancelaciones INT;
    
    SELECT COUNT(DISTINCT id_usuario) INTO total_cancelaciones
    FROM contrataciones
    WHERE estado = 'CANCELADO';
    
    RETURN total_cancelaciones;
END //
DELIMITER ;

-- SELECT contar_usuarios_con_cancelaciones();

-- 18. Calcular el total de bonificaciones activas de todos los usuarios

DELIMITER //
CREATE FUNCTION total_bonificaciones_activas ()
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_bonificaciones DECIMAL(10,2);
    
    SELECT SUM(b.monto) INTO total_bonificaciones
    FROM bonificaciones b
    WHERE b.fecha_asignacion <= CURDATE();
    
    RETURN total_bonificaciones;
END //
DELIMITER ;

-- SELECT total_bonificaciones_activas();

-- 19. Calcular el número de usuarios con más de una bonificación

DELIMITER //
CREATE FUNCTION contar_usuarios_con_multiple_bonificacion ()
RETURNS INT
BEGIN
    DECLARE total_usuarios INT;
    
    SELECT COUNT(DISTINCT b.id_usuario) INTO total_usuarios
    FROM bonificaciones b
    GROUP BY b.id_usuario
    HAVING COUNT(b.id_bonificacion) > 1;
    
    RETURN total_usuarios;
END //
DELIMITER ;

-- SELECT contar_usuarios_con_multiple_bonificacion();

-- 20. Calcular el número total de servicios prepago contratados

DELIMITER //
CREATE FUNCTION contar_servicios_prepago ()
RETURNS INT
BEGIN
    DECLARE total_servicios INT;
    
    SELECT COUNT(*) INTO total_servicios
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE s.tipo = 'PREPAGO' AND c.estado = 'ACTIVO';
    
    RETURN total_servicios;
END //
DELIMITER ;

-- SELECT contar_servicios_prepago();