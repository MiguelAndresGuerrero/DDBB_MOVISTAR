### DDBB MOVISTAR
## ![Logo Movistar](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6O7mkSWxmHDibfTiT7NKPtaGZe3Shub8uOg&s)

## Descripción del Proyecto

Este proyecto busca diseñar e implementar un sistema de base de datos (DDBB) para MOVISTAR , con el objetivo de optimizar sus procesos y fortalecer la relación con sus clientes. La solución propuesta no solo mejorará la eficiencia operativa, sino que también permitirá una gestión más cercana y personalizada, resolviendo los desafíos actuales y potenciando la experiencia de los usuarios fieles

---

## Requisitos del Sistema

- **MySQL Installer** versión 8.0.40
- **MySQL Workbench** (para la gestión visual de la base de datos)

---

## Instalación y Configuración

1. **Crear la base de datos**  
   Ejecuta el archivo `ddl.sql` para crear la estructura de la base de datos.

2. **Cargar datos iniciales**  
   Ejecuta el archivo `dml.sql` para insertar los datos iniciales en las tablas.

3. **Ejecutar consultas**  
   Utiliza los archivos `dql_select.sql`, `dql_procedimientos.sql`, `dql_funciones.sql`, `dql_triggers.sql` para ejecutar los procedimientos, funciones y triggers que se han creado.

---

## Estructura de la Base de Datos

La base de datos está organizada en las siguientes tablas clave:

### 1. **Roles**
   - Contiene información de los roles (nombre_rol, descripcion)

### 2. **Usuarios**
   - Contiene datos de los usuarios (id_rol, nombre, apellido, direccion, telefono, email, fecha_registro, categoria_usuario)

### 3. **Permisos**
  - Contiene los permisos otorgados a los usuarios (nombre_permiso, descripcion)

### 4. **Roles_permisos**
  - Contiene los permisos que se le dan a los usuarios (id_rol, id_permiso)

### 5. **Servicios**
  - Contiene los datos de los servicios ofrecidos (nombre_servicio, descripcion, precio, tipo)

### 6. **Bonificaciones**
  - Contiene informacion de las bonificaciones para clientes fieles (id_usuario, tipo_bonificacion, monto, fecha_asignacion)

### 7. **Reportes**
  - Contiene la informacion de los reportes (nombre_reporte, descripcion, fecha_creacion, tipo_reporte)

### 8. **Contrataciones**
  - Contiene informacion de los servicios contratados por los usuarios (id_usuario, id_servicio, fecha_contratacion, estado)

---

## Ejemplos de Consultas

**Estado actual de algunos procedimientos**

```sql

--  Registrar nuevo usuario

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

-- Actualizar algun servicio existente

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

--  Clasificar automaticamente a los usuarios leales

DELIMITER //
CREATE PROCEDURE clasificar_usuario_leal()
BEGIN
    UPDATE usuarios
    SET categoria_usuario = 'LEAL'
    WHERE DATEDIFF(CURDATE(), fecha_registro) > 365 AND categoria_usuario != 'LEAL';
END //
DELIMITER ;

-- Ver los usuarios clasificados como leales

DELIMITER //
CREATE PROCEDURE obtener_usuarios_leales()
BEGIN
    SELECT id_usuario, nombre, apellido, fecha_registro 
    FROM usuarios 
    WHERE categoria_usuario = 'LEAL';
END //
DELIMITER ;

```

**Estado actual de algunas funciones**

```sql

 -- Calcular el total de bonificaciones asignadas a un usuario

DELIMITER //
CREATE FUNCTION total_bonificaciones_usuario (p_id_usuario INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_bonificaciones DECIMAL(10,2);
    
    SELECT SUM(b.monto) INTO total_bonificaciones
    FROM bonificaciones b
    WHERE b.id_usuario = p_id_usuario AND b.fecha_asignacion <= CURDATE();
    
    RETURN total_bonificaciones;
END //
DELIMITER ;

-- Calcular el precio total de los servicios contratados por un usuario

DELIMITER //
CREATE FUNCTION precio_total_servicios_usuario (p_id_usuario INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_precio DECIMAL(10,2);
    
    SELECT SUM(s.precio) INTO total_precio
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE c.id_usuario = p_id_usuario AND c.estado = 'ACTIVO';
    
    RETURN total_precio;
END //
DELIMITER ;

-- Calcular el número total de usuarios leales

DELIMITER //
CREATE FUNCTION contar_usuarios_leales ()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_leales INT;
    
    SELECT COUNT(*) INTO total_leales
    FROM usuarios
    WHERE categoria_usuario = 'LEAL';
    
    RETURN total_leales;
END //
DELIMITER ;

-- Calcular la cantidad de servicios contratados por tipo

DELIMITER //
CREATE FUNCTION contar_servicios_por_tipo (p_tipo_servicio ENUM('POSPAGO', 'PREPAGO', 'FIBRA'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_servicios INT;
    
    SELECT COUNT(*) INTO total_servicios
    FROM servicios s
    JOIN contrataciones c ON s.id_servicio = c.id_servicio
    WHERE s.tipo = p_tipo_servicio AND c.estado = 'ACTIVO';
    
    RETURN total_servicios;
END //
DELIMITER ;

```

**Estado actual de algunos eventos**

```sql
-- Generación semanal de reportes

CREATE EVENT generate_weekly_report
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO reportes (nombre_reporte, fecha_reporte)
    VALUES ('Reporte Semanal', NOW());
END //

-- Resumen mensual de ingresos por servicios

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

-- Vencimiento de promociones

CREATE EVENT expire_promotions
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM promociones WHERE fecha_vencimiento < CURDATE();
END //

--  Generación de reportes de cancelaciones

CREATE EVENT generate_cancellation_report
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO reportes_cancelaciones (fecha, total_cancelaciones)
    SELECT CURDATE(), COUNT(*) FROM contrataciones WHERE estado = 'CANCELADO' AND MONTH(fecha_contratacion) = MONTH(CURDATE());
END //

```

**Estado actual de los permisos**

```sql
-- Administrador

INSERT INTO roles_permisos (id_rol, id_permiso) VALUES
(1, 1); -- GESTION_TOTAL

-- Asesor de Ventas

INSERT INTO roles_permisos (id_rol, id_permiso) VALUES
(2, 2), -- GESTION_SERVICIOS
(2, 3); -- GESTION_BONIFICACIONES

-- Encargado de Reportes

INSERT INTO roles_permisos (id_rol, id_permiso) VALUES
(3, 4); -- GESTION_REPORTES

-- Gestor de Servicios

INSERT INTO roles_permisos (id_rol, id_permiso) VALUES
(4, 2); -- GESTION_SERVICIOS

-- Encargado de Fidelización

INSERT INTO roles_permisos (id_rol, id_permiso) VALUES
(5, 3), -- GESTION_BONIFICACIONES
(5, 5); -- GESTION_CLIENTES_LEALES
```
## Otras consultas que se encuentra en los documentos son

Además de las consultas anteriores, se han incluido las siguientes funcionalidades:

- Subconsultas
- Procedimientos
- Funciones
- Triggers
- Roles de Usuario y Permisos

## Contacto

Para cualquier consulta sobre el proyecto, por favor contacta a
Miguel Guerrero: [Gmail](Guerreromiguelmartinez@gmail.com)

sql

    ├── Diagrama.drawio             # Diagrama de la Base de Datos (DDBB)
    ├── README.md                   # Este archivo
    ├── ddl.sql                     # Creación de las tablas y la base de datos
    ├── dml.sql                     # Inserción de datos iniciales
    ├── dql_events.sql              # Eventos
    ├── dql_funciones.sql           # Funciones
    ├── dql_procedimientos.sql      # Procedimientos almacenados
    ├── dql_select.sql              # Consultas selects
    ├── dql_triggers.sql            # Triggers
    ├── drawSQL.png                 # Diagrama Entidad Relacion
