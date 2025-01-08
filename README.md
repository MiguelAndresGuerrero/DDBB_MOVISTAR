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

## Roles de Usuario y Permisos

**Administrador**: Puede realizar todas las acciones en el sistema.
**Asesor de Ventas**: Accede a información básica y puede actualizar e insertar datos en las tablas venta, inventario, y cliente.
**Encargado de Reportes**: Acceso a informes financieros y registros de detalles financieros.
**Gestor de Servicios**: 
**Encargado de Fidelización**: 

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
