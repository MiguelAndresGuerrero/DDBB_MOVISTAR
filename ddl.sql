create database Movistar;

use Movistar;

create table roles (
    id_rol int primary key auto_increment,
    nombre_rol varchar(100) not null,
    descripcion text
);

create table usuarios (
	id_usuario int primary key,
    id_rol int,
    nombre varchar(100) not null,
    apellido varchar(100),
    direccion varchar(200),
    telefono varchar(30) not null,
    email varchar(100),
    fecha_registro date,
    categoria_usuario enum('NUEVO', 'REGULAR', 'LEAL'),
    foreign key (id_rol) references roles(id_rol)
);

create table permisos (
    id_permiso int primary key auto_increment,
    nombre_permiso varchar(100) not null,
    descripcion text
);

create table roles_permisos (
    id_rol int,
    id_permiso int,
    primary key (id_rol, id_permiso),
    foreign key (id_rol) references roles(id_rol),
    foreign key (id_permiso) references permisos(id_permiso)
);

create table servicios (
	id_servicio int primary key,
    nombre_servicio varchar(100) not null,
    descripcion text not null,
    precio decimal(10,2) not null,
    tipo enum('POSPAGO', 'PREPAGO', 'FIBRA') not null
);

create table bonificaciones (
	id_bonificacion int primary key,
    id_usuario int,
    tipo_bonificacion enum('DESCUENTO', 'SERVICIO GRATUITO') not null,
    monto decimal(10,2),
    fecha_asignacion date not null,
    foreign key (id_usuario) references usuarios(id_usuario)
);

create table reportes (
	id_reporte int primary key,
    nombre_reporte varchar(100) not null,
    descripcion text not null,
    fecha_creacion date,
    tipo_reporte text not null
);

create table contrataciones (
	id_contratacion int primary key,
    id_usuario int,
    id_servicio int,
    fecha_contratacion date not null,
    estado enum('ACTIVO', 'CANCELADO'),
    foreign key (id_usuario) references usuarios(id_usuario),
    foreign key (id_servicio) references servicios(id_servicio)
);