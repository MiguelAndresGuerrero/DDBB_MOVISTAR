use movistar;

DELIMITER //

-- 1. Actualización diaria de los servicios más contratados
CREATE EVENT update_most_popular_services
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO servicios_populares (id_servicio, cantidad_contrataciones)
    SELECT id_servicio, COUNT(*) 
    FROM contrataciones
    GROUP BY id_servicio
    ORDER BY cantidad_contrataciones DESC
    LIMIT 5;
END //

-- 2. Generación semanal de reportes
CREATE EVENT generate_weekly_report
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO reportes (nombre_reporte, fecha_reporte)
    VALUES ('Reporte Semanal', NOW());
END //

-- 3. Vencimiento de bonificaciones no utilizadas
CREATE EVENT expire_unused_bonifications
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    DELETE FROM bonificaciones WHERE DATEDIFF(CURDATE(), fecha_asignacion) > 30;
END //

-- 4. Resumen mensual de ingresos por servicios
CREATE EVENT monthly_service_revenue_summary
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO resumen_ingresos (mes, ingresos_totales)
    SELECT MONTH(CURDATE()), SUM(precio) 
    FROM contrataciones c
    JOIN servicios s ON c.id_servicio = s.id_servicio
    WHERE MONTH(c.fecha_contratacion) = MONTH(CURDATE())
    GROUP BY MONTH(CURDATE());
END //

-- 5. Actualización diaria de las fechas de expiración de servicios
CREATE EVENT update_service_expirations
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    UPDATE contrataciones
    SET fecha_expiracion = DATE_ADD(fecha_contratacion, INTERVAL 1 YEAR)
    WHERE DATEDIFF(fecha_expiracion, CURDATE()) < 30;
END //

-- 6. Limpiar registros de usuarios inactivos
CREATE EVENT clean_inactive_users
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    DELETE FROM usuarios WHERE DATEDIFF(CURDATE(), fecha_ultima_modificacion) > 180;
END //

-- 7. Generación de estadísticas diarias de contrataciones
CREATE EVENT daily_contract_statistics
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO estadisticas_contratos (fecha, total_contrataciones)
    SELECT CURDATE(), COUNT(*) FROM contrataciones WHERE DATE(fecha_contratacion) = CURDATE();
END //

-- 8. Restablecimiento de contraseñas de usuarios inactivos
CREATE EVENT reset_passwords_for_inactive_users
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    UPDATE usuarios
    SET contrasena = 'default_password'
    WHERE DATEDIFF(CURDATE(), fecha_ultimo_login) > 90;
END //

-- 9. Actualización de precios mensuales de servicios
CREATE EVENT update_service_prices
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    UPDATE servicios
    SET precio = precio * 1.10;
END //

-- 10. Vencimiento de promociones
CREATE EVENT expire_promotions
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM promociones WHERE fecha_vencimiento < CURDATE();
END //

-- 11. Generación de reportes de clientes con más de 10 servicios
CREATE EVENT report_top_clients
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO reportes_top_clientes (cliente_id, cantidad_servicios)
    SELECT id_usuario, COUNT(*) FROM contrataciones 
    GROUP BY id_usuario
    HAVING COUNT(*) > 10;
END //

-- 12. Notificación de bonificaciones a los usuarios elegibles
CREATE EVENT notify_eligible_bonifications
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO notificaciones (id_usuario, mensaje)
    SELECT id_usuario, 'Tienes una bonificación disponible.'
    FROM usuarios
    WHERE DATEDIFF(CURDATE(), fecha_registro) > 365;
END //

-- 13. Eliminar registros de contrataciones canceladas después de 6 meses
CREATE EVENT remove_old_canceled_contracts
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM contrataciones 
    WHERE estado = 'CANCELADO' AND DATEDIFF(CURDATE(), fecha_contratacion) > 180;
END //

-- 14. Descuento automático mensual en servicios prepago
CREATE EVENT apply_monthly_discount
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    UPDATE servicios
    SET precio = precio * 0.95
    WHERE tipo = 'PREPAGO';
END //

-- 15. Generación de reportes de cancelaciones
CREATE EVENT generate_cancellation_report
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO reportes_cancelaciones (fecha, total_cancelaciones)
    SELECT CURDATE(), COUNT(*) FROM contrataciones WHERE estado = 'CANCELADO' AND MONTH(fecha_contratacion) = MONTH(CURDATE());
END //

-- 16. Vencimiento de bonificaciones de un 100%
CREATE EVENT expire_full_bonifications
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    DELETE FROM bonificaciones WHERE tipo_bonificacion = 'DESCUENTO' AND monto = 100 AND fecha_asignacion < CURDATE();
END //

-- 17. Enviar recordatorio de pago a usuarios
CREATE EVENT send_payment_reminder
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO recordatorios_pago (id_usuario, mensaje)
    SELECT id_usuario, 'Tu servicio vencerá en 7 días, por favor realiza tu pago.'
    FROM contrataciones
    WHERE DATEDIFF(fecha_expiracion, CURDATE()) = 7;
END //

-- 18. Registro de cancelaciones diarias
CREATE EVENT daily_cancellation_log
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO log_cancelaciones (fecha, id_usuario, id_servicio)
    SELECT CURDATE(), id_usuario, id_servicio 
    FROM contrataciones
    WHERE estado = 'CANCELADO' AND DATE(fecha_contratacion) = CURDATE();
END //

-- 19. Aplicación de ajustes de precios para servicios premium
CREATE EVENT apply_premium_service_price_adjustment
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    UPDATE servicios
    SET precio = precio * 1.20
    WHERE tipo = 'PREMIUM';
END //

-- 20. Enviar notificación a nuevos usuarios
CREATE EVENT send_welcome_notifications
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO notificaciones (id_usuario, mensaje)
    SELECT id_usuario, '¡Bienvenido! Gracias por registrarte en nuestro sistema.'
    FROM usuarios
    WHERE DATEDIFF(CURDATE(), fecha_registro) <= 1;
END //

DELIMITER ;

CALL verificar_permiso(1, 'GESTION_TOTAL');
