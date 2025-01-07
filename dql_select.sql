use movistar;

-- 1. Obtener todos los usuarios
SELECT * FROM usuarios;

-- 2. Listar usuarios registrados en 2025
SELECT * FROM usuarios WHERE fecha_registro >= '2025-01-01';

-- 3. Contar cuántos usuarios hay en cada categoría
SELECT categoria_usuario, COUNT(*) AS cantidad FROM usuarios GROUP BY categoria_usuario;

-- 4. Listar usuarios con nombre "Juan"
SELECT * FROM usuarios WHERE nombre = 'Juan';

-- 5. Buscar usuarios con correo terminado en "@gmail.com"
SELECT * FROM usuarios WHERE email LIKE '%@gmail.com';

-- 6. Mostrar usuarios cuyo número de teléfono comience con "300"
SELECT * FROM usuarios WHERE telefono LIKE '300%';

-- 7. Listar usuarios con dirección no especificada
SELECT * FROM usuarios WHERE direccion IS NULL OR direccion = '';

-- 8. Obtener usuarios con apellidos que contengan la letra "a"
SELECT * FROM usuarios WHERE apellido LIKE '%a%';

-- 9. Usuarios registrados antes de 2020
SELECT * FROM usuarios WHERE fecha_registro < '2020-01-01';

-- 10. Obtener los 5 primeros usuarios registrados
SELECT * FROM usuarios ORDER BY fecha_registro ASC LIMIT 5;

-- 11. Listar todos los servicios
SELECT * FROM servicios;

-- 12. Servicios de tipo "FIBRA"
SELECT * FROM servicios WHERE tipo = 'FIBRA';

-- 13. Contar cuántos servicios hay de cada tipo
SELECT tipo, COUNT(*) AS cantidad FROM servicios GROUP BY tipo;

-- 14. Listar servicios con precio mayor a 50
SELECT * FROM servicios WHERE precio > 50;

-- 15. Ordenar servicios por precio descendente
SELECT * FROM servicios ORDER BY precio DESC;

-- 16. Buscar servicios con la palabra "Internet" en su nombre
SELECT * FROM servicios WHERE nombre_servicio LIKE '%Internet%';

-- 17. Mostrar servicios con descripción no especificada
SELECT * FROM servicios WHERE descripcion IS NULL OR descripcion = '';

-- 18. Obtener el servicio más caro
SELECT * FROM servicios ORDER BY precio DESC LIMIT 1;

-- 19. Calcular el precio promedio de los servicios
SELECT AVG(precio) AS precio_promedio FROM servicios;

-- 20. Contar cuántos servicios tienen precio entre 20 y 100
SELECT COUNT(*) AS cantidad FROM servicios WHERE precio BETWEEN 20 AND 100;

-- 21. Listar todas las bonificaciones
SELECT * FROM bonificaciones;

-- 22. Mostrar bonificaciones de tipo "DESCUENTO"
SELECT * FROM bonificaciones WHERE tipo_bonificacion = 'DESCUENTO';

-- 23. Contar cuántas bonificaciones tiene cada usuario
SELECT id_usuario, COUNT(*) AS cantidad FROM bonificaciones GROUP BY id_usuario;

-- 24. Obtener bonificaciones asignadas en 2025
SELECT * FROM bonificaciones WHERE fecha_asignacion >= '2025-01-01';

-- 25. Calcular el monto promedio de las bonificaciones
SELECT AVG(monto) AS monto_promedio FROM bonificaciones;

-- 26. Bonificaciones con monto mayor a 100
SELECT * FROM bonificaciones WHERE monto > 100;

-- 27. Mostrar los usuarios con más de 2 bonificaciones
SELECT id_usuario, COUNT(*) AS cantidad FROM bonificaciones GROUP BY id_usuario HAVING cantidad > 2;

-- 28. Ordenar bonificaciones por fecha de asignación descendente
SELECT * FROM bonificaciones ORDER BY fecha_asignacion DESC;

-- 29. Obtener la bonificación más reciente
SELECT * FROM bonificaciones ORDER BY fecha_asignacion DESC LIMIT 1;

-- 30. Contar cuántas bonificaciones se asignaron por tipo
SELECT tipo_bonificacion, COUNT(*) AS cantidad FROM bonificaciones GROUP BY tipo_bonificacion;

-- 31. Listar todos los reportes
SELECT * FROM reportes;

-- 32. Reportes creados después del 2025-01-01
SELECT * FROM reportes WHERE fecha_creacion >= '2025-01-01';

-- 33. Contar reportes por tipo
SELECT tipo_reporte, COUNT(*) AS cantidad FROM reportes GROUP BY tipo_reporte;

-- 34. Buscar reportes con la palabra "Consumo"
SELECT * FROM reportes WHERE nombre_reporte LIKE '%Consumo%';

-- 35. Ordenar reportes por fecha de creación ascendente
SELECT * FROM reportes ORDER BY fecha_creacion ASC;

-- 36. Obtener los 10 reportes más recientes
SELECT * FROM reportes ORDER BY fecha_creacion DESC LIMIT 10;

-- 37. Reportes con descripción vacía o no especificada
SELECT * FROM reportes WHERE descripcion IS NULL OR descripcion = '';

-- 38. Contar cuántos reportes fueron creados antes del 2020
SELECT COUNT(*) AS cantidad FROM reportes WHERE fecha_creacion < '2020-01-01';

-- 39. Listar reportes con tipo no repetido
SELECT DISTINCT tipo_reporte FROM reportes;

-- 40. Obtener el reporte más antiguo
SELECT * FROM reportes ORDER BY fecha_creacion ASC LIMIT 1;

-- 41. Listar todas las contrataciones
SELECT * FROM contrataciones;

-- 42. Contrataciones activas
SELECT * FROM contrataciones WHERE estado = 'ACTIVO';

-- 43. Contar contrataciones por estado
SELECT estado, COUNT(*) AS cantidad FROM contrataciones GROUP BY estado;

-- 44. Contrataciones realizadas después de 2025-01-01
SELECT * FROM contrataciones WHERE fecha_contratacion >= '2025-01-01';

-- 45. Obtener las contrataciones de un usuario específico
SELECT * FROM contrataciones WHERE id_usuario = 5;

-- 46. Contrataciones que incluyen el servicio más caro
SELECT * FROM contrataciones WHERE id_servicio = (SELECT id_servicio FROM servicios ORDER BY precio DESC LIMIT 1);

-- 47. Contar cuántas contrataciones tiene cada usuario
SELECT id_usuario, COUNT(*) AS cantidad FROM contrataciones GROUP BY id_usuario;

-- 48. Obtener contrataciones agrupadas por servicio
SELECT id_servicio, COUNT(*) AS cantidad FROM contrataciones GROUP BY id_servicio;

-- 49. Contrataciones realizadas en los últimos 30 días
SELECT * FROM contrataciones WHERE fecha_contratacion >= CURDATE() - INTERVAL 30 DAY;

-- 50. Ordenar contrataciones por fecha de contratación
SELECT * FROM contrataciones ORDER BY fecha_contratacion DESC;

-- 51. Usuarios con contrataciones activas
SELECT u.* 
FROM usuarios u 
JOIN contrataciones c ON u.id_usuario = c.id_usuario 
WHERE c.estado = 'ACTIVO';

-- 52. Servicios contratados por un usuario específico
SELECT s.* 
FROM servicios s 
JOIN contrataciones c ON s.id_servicio = c.id_servicio 
WHERE c.id_usuario = 3;

-- 53. Reportes generados relacionados con contrataciones
SELECT r.* 
FROM reportes r 
JOIN contrataciones c ON r.nombre_reporte LIKE CONCAT('%', c.estado, '%');

-- 54. Usuarios con bonificaciones activas
SELECT u.*, b.* 
FROM usuarios u 
JOIN bonificaciones b ON u.id_usuario = b.id_usuario;

-- 55. Contrataciones y sus respectivos usuarios y servicios
SELECT c.*, u.nombre, s.nombre_servicio 
FROM contrataciones c 
JOIN usuarios u ON c.id_usuario = u.id_usuario 
JOIN servicios s ON c.id_servicio = s.id_servicio;

-- 56. Servicios más contratados
SELECT s.nombre_servicio, COUNT(c.id_servicio) AS total_contrataciones 
FROM servicios s 
JOIN contrataciones c ON s.id_servicio = c.id_servicio 
GROUP BY s.nombre_servicio 
ORDER BY total_contrataciones DESC 
LIMIT 5;

-- 57. Usuarios con más de 3 contrataciones
SELECT u.*, COUNT(c.id_usuario) AS total_contrataciones 
FROM usuarios u 
JOIN contrataciones c ON u.id_usuario = c.id_usuario 
GROUP BY u.id_usuario 
HAVING total_contrataciones > 3;

-- 58. Servicios ofrecidos con bonificaciones asignadas
SELECT s.*, b.tipo_bonificacion, b.monto 
FROM servicios s 
JOIN contrataciones c ON s.id_servicio = c.id_servicio 
JOIN bonificaciones b ON c.id_usuario = b.id_usuario;

-- 59. Usuarios con categoría "LEAL" registrados después de 2020
SELECT * FROM usuarios WHERE categoria_usuario = 'LEAL' AND fecha_registro > '2020-01-01';

-- 60. Contar cuántos usuarios tienen dirección especificada
SELECT COUNT(*) AS usuarios_con_direccion FROM usuarios WHERE direccion IS NOT NULL AND direccion <> '';

-- 61. Buscar usuarios cuyo nombre contenga más de 5 caracteres
SELECT * FROM usuarios WHERE CHAR_LENGTH(nombre) > 5;

-- 62. Listar los apellidos de todos los usuarios sin repetir
SELECT DISTINCT apellido FROM usuarios;

-- 63. Obtener el número de usuarios registrados cada año
SELECT YEAR(fecha_registro) AS anio, COUNT(*) AS cantidad FROM usuarios GROUP BY anio;

-- 64. Contar cuántos usuarios tienen correo con dominio "hotmail.com"
SELECT COUNT(*) AS usuarios_hotmail FROM usuarios WHERE email LIKE '%@hotmail.com';

-- 65. Listar usuarios con categoría diferente a "NUEVO"
SELECT * FROM usuarios WHERE categoria_usuario != 'NUEVO';

-- 66. Ordenar usuarios alfabéticamente por nombre y apellido
SELECT * FROM usuarios ORDER BY nombre ASC, apellido ASC;

-- 67. Obtener usuarios con registro más reciente por categoría
SELECT * FROM usuarios WHERE (categoria_usuario, fecha_registro) IN (
  SELECT categoria_usuario, MAX(fecha_registro) FROM usuarios GROUP BY categoria_usuario
);

-- 68. Usuarios con número de teléfono menor a 10 caracteres
SELECT * FROM usuarios WHERE CHAR_LENGTH(telefono) < 10;

-- 69. Listar servicios con precio inferior a 30
SELECT * FROM servicios WHERE precio < 30;

-- 70. Contar servicios que contienen la palabra "Móvil" en su descripción
SELECT COUNT(*) AS servicios_moviles FROM servicios WHERE descripcion LIKE '%Móvil%';

-- 71. Servicios con precio entre 40 y 60 ordenados por tipo
SELECT * FROM servicios WHERE precio BETWEEN 40 AND 60 ORDER BY tipo;

-- 72. Obtener los 3 servicios más económicos
SELECT * FROM servicios ORDER BY precio ASC LIMIT 3;

-- 73. Servicios con nombres que comienzan con "Plan"
SELECT * FROM servicios WHERE nombre_servicio LIKE 'Plan%';

-- 74. Contar servicios que no sean de tipo "PREPAGO"
SELECT COUNT(*) AS servicios_no_prepago FROM servicios WHERE tipo != 'PREPAGO';

-- 75. Servicios con descripción más larga de 50 caracteres
SELECT * FROM servicios WHERE CHAR_LENGTH(descripcion) > 50;

-- 76. Calcular el precio total de todos los servicios
SELECT SUM(precio) AS precio_total FROM servicios;

-- 77. Servicios agrupados por tipo, mostrando precio promedio
SELECT tipo, AVG(precio) AS precio_promedio FROM servicios GROUP BY tipo;

-- 78. Obtener el servicio con descripción más corta
SELECT * FROM servicios ORDER BY CHAR_LENGTH(descripcion) ASC LIMIT 1;

-- 79. Bonificaciones asignadas en los últimos 6 meses
SELECT * FROM bonificaciones WHERE fecha_asignacion >= CURDATE() - INTERVAL 6 MONTH;

-- 80. Mostrar usuarios con bonificaciones mayores a 50
SELECT b.*, u.nombre, u.apellido 
FROM bonificaciones b 
JOIN usuarios u ON b.id_usuario = u.id_usuario 
WHERE b.monto > 50;

-- 81. Bonificaciones con tipo "SERVICIO GRATUITO" y monto superior a 0
SELECT * FROM bonificaciones WHERE tipo_bonificacion = 'SERVICIO GRATUITO' AND monto > 0;

-- 82. Contar bonificaciones por usuario con su monto total acumulado
SELECT id_usuario, COUNT(*) AS total_bonificaciones, SUM(monto) AS monto_acumulado 
FROM bonificaciones GROUP BY id_usuario;

-- 83. Bonificaciones asignadas a usuarios registrados en 2025
SELECT b.* 
FROM bonificaciones b 
JOIN usuarios u ON b.id_usuario = u.id_usuario 
WHERE u.fecha_registro >= '2025-01-01';

-- 84. Ordenar bonificaciones por monto descendente
SELECT * FROM bonificaciones ORDER BY monto DESC;

-- 85. Mostrar las bonificaciones más antiguas asignadas por cada tipo
SELECT tipo_bonificacion, MIN(fecha_asignacion) AS fecha_mas_antigua 
FROM bonificaciones GROUP BY tipo_bonificacion;

-- 86. Contar bonificaciones asignadas en cada mes
SELECT MONTH(fecha_asignacion) AS mes, COUNT(*) AS cantidad 
FROM bonificaciones GROUP BY mes;

-- 87. Bonificaciones con fecha posterior al registro del usuario
SELECT b.* 
FROM bonificaciones b 
JOIN usuarios u ON b.id_usuario = u.id_usuario 
WHERE b.fecha_asignacion > u.fecha_registro;

-- 88. Usuarios sin bonificaciones
SELECT * 
FROM usuarios u 
WHERE NOT EXISTS (SELECT 1 FROM bonificaciones b WHERE b.id_usuario = u.id_usuario);

-- 89. Reportes cuyo tipo contiene "Error"
SELECT * FROM reportes WHERE tipo_reporte LIKE '%Error%';

-- 90. Contar reportes generados cada mes
SELECT MONTH(fecha_creacion) AS mes, COUNT(*) AS cantidad FROM reportes GROUP BY mes;

-- 91. Reportes creados en el mismo día
SELECT fecha_creacion, COUNT(*) AS cantidad 
FROM reportes 
GROUP BY fecha_creacion 
HAVING cantidad > 1;

-- 92. Reportes con el nombre más largo
SELECT * FROM reportes ORDER BY CHAR_LENGTH(nombre_reporte) DESC LIMIT 1;

-- 93. Buscar reportes con descripción que contenga "Problema"
SELECT * FROM reportes WHERE descripcion LIKE '%Problema%';

-- 94. Reportes creados en los últimos 90 días
SELECT * FROM reportes WHERE fecha_creacion >= CURDATE() - INTERVAL 90 DAY;

-- 95. Contar reportes por cada año de creación
SELECT YEAR(fecha_creacion) AS anio, COUNT(*) AS cantidad FROM reportes GROUP BY anio;

-- 96. Reportes con tipo no especificado
SELECT * FROM reportes WHERE tipo_reporte IS NULL OR tipo_reporte = '';

-- 97. Reportes creados por usuarios con más de 2 contrataciones
SELECT r.* 
FROM reportes r 
JOIN contrataciones c ON r.nombre_reporte LIKE CONCAT('%', c.estado, '%')
GROUP BY r.id_reporte 
HAVING COUNT(c.id_contratacion) > 2;

-- 98. El reporte más reciente creado por cada tipo
SELECT tipo_reporte, MAX(fecha_creacion) AS reporte_mas_reciente 
FROM reportes GROUP BY tipo_reporte;

-- 99. Contrataciones realizadas por usuarios con categoría "LEAL"
SELECT c.* 
FROM contrataciones c 
JOIN usuarios u ON c.id_usuario = u.id_usuario 
WHERE u.categoria_usuario = 'LEAL';

-- 100. Usuarios con contrataciones canceladas en 2025
SELECT u.*, c.estado 
FROM usuarios u 
JOIN contrataciones c ON u.id_usuario = c.id_usuario 
WHERE c.estado = 'CANCELADO' AND c.fecha_contratacion >= '2025-01-01';