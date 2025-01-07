use movistar;

INSERT INTO usuarios (nombre, apellido, direccion, telefono, email, fecha_registro, categoria_usuario) VALUES
('Carlos', 'Gómez', 'Calle 45 #12-34', '3123456789', 'carlos.gomez@example.com', '2020-05-12', 'LEAL'),
('María', 'Rodríguez', 'Carrera 23 #45-67', '3134567890', 'maria.rodriguez@example.com', '2022-01-15', 'NUEVO'),
('Juan', 'Pérez', 'Avenida Siempre Viva #100', '3145678901', 'juan.perez@example.com', '2019-08-20', 'REGULAR'),
('Ana', 'Martínez', 'Calle 10 #15-20', '3156789012', 'ana.martinez@example.com', '2018-03-10', 'LEAL'),
('Luis', 'Hernández', 'Carrera 8 #20-40', '3167890123', 'luis.hernandez@example.com', '2021-07-18', 'REGULAR'),
('Sofía', 'García', 'Calle 50 #30-60', '3178901234', 'sofia.garcia@example.com', '2023-02-01', 'NUEVO'),
('Jorge', 'López', 'Carrera 12 #34-56', '3189012345', 'jorge.lopez@example.com', '2017-11-25', 'LEAL'),
('Laura', 'Torres', 'Avenida Central #200', '3190123456', 'laura.torres@example.com', '2016-06-30', 'LEAL'),
('Andrés', 'Ramírez', 'Calle 15 #45-50', '3101234567', 'andres.ramirez@example.com', '2021-12-10', 'REGULAR'),
('Camila', 'Gómez', 'Carrera 7 #80-20', '3112345678', 'camila.gomez@example.com', '2022-05-25', 'NUEVO');

INSERT INTO servicios (nombre_servicio, descripcion, precio, tipo) VALUES
('Internet Fibra 50 Mbps', 'Conexión de alta velocidad con 50 Mbps', 100000.00, 'FIBRA'),
('Internet Fibra 100 Mbps', 'Conexión de alta velocidad con 100 Mbps', 150000.00, 'FIBRA'),
('Plan Pospago 5 GB', 'Plan de datos con 5 GB mensuales', 50000.00, 'POSPAGO'),
('Plan Pospago 10 GB', 'Plan de datos con 10 GB mensuales', 80000.00, 'POSPAGO'),
('Plan Prepago Básico', 'Recargas disponibles según consumo', 20000.00, 'PREPAGO'),
('Plan Prepago Avanzado', 'Recargas con promociones especiales', 30000.00, 'PREPAGO'),
('Internet Fibra 200 Mbps', 'Conexión de alta velocidad con 200 Mbps', 250000.00, 'FIBRA'),
('Plan Pospago Ilimitado', 'Datos, llamadas y mensajes ilimitados', 120000.00, 'POSPAGO'),
('Plan Prepago Familiar', 'Recargas con descuentos para grupos familiares', 40000.00, 'PREPAGO'),
('Internet Fibra 500 Mbps', 'Conexión de alta velocidad con 500 Mbps', 500000.00, 'FIBRA');

INSERT INTO bonificaciones (id_usuario, tipo_bonificacion, monto, fecha_asignacion) VALUES
(1, 'DESCUENTO', 20000.00, '2023-01-01'),
(4, 'SERVICIO GRATUITO', 0.00, '2023-02-15'),
(7, 'DESCUENTO', 15000.00, '2023-03-10'),
(8, 'SERVICIO GRATUITO', 0.00, '2023-04-20'),
(1, 'DESCUENTO', 5000.00, '2023-05-05');

INSERT INTO reportes (nombre_reporte, descripcion, fecha_creacion, tipo_reporte) VALUES
('Usuarios Nuevos', 'Reporte mensual de usuarios nuevos registrados', '2023-01-31', 'Estadístico'),
('Servicios Contratados', 'Reporte de los servicios más contratados', '2023-02-28', 'Operativo'),
('Bonificaciones Asignadas', 'Resumen de bonificaciones otorgadas a usuarios', '2023-03-31', 'Administrativo'),
('Clientes Leales', 'Reporte de clientes con más de 10 años', '2023-04-30', 'Estadístico'),
('Ingresos por Servicios', 'Reporte de ingresos generados por cada tipo de servicio', '2023-05-31', 'Financiero');

INSERT INTO contrataciones (id_usuario, id_servicio, fecha_contratacion, estado) VALUES
(1, 1, '2023-01-10', 'ACTIVO'),
(2, 3, '2023-02-15', 'ACTIVO'),
(3, 4, '2023-03-05', 'CANCELADO'),
(4, 2, '2023-01-20', 'ACTIVO'),
(5, 7, '2023-04-25', 'ACTIVO'),
(6, 5, '2023-05-10', 'ACTIVO'),
(7, 8, '2023-02-28', 'CANCELADO'),
(8, 6, '2023-03-12', 'ACTIVO'),
(9, 9, '2023-04-01', 'ACTIVO'),
(10, 10, '2023-05-15', 'ACTIVO');
