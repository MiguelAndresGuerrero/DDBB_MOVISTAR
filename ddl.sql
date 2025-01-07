create database Movistar;

use Movistar;

create table usuarios (
	id_usuario int primary key auto_increment,
    nombre varchar(100) not null,
    apellido varchar(100),
    direccion varchar(200),
    telefono varchar(30) not null,
    email varchar(100),
    fecha_registro date,
    categoria_usuario enum('NUEVO', 'REGULAR', 'LEAL')
);

create table servicios (
	id_servicio int primary key auto_increment,
    nombre_servicio varchar(100) not null,
    descripcion varchar(200) not null,
    precio varchar(10) not null,
    tipo enum('POSPAGO', 'PREPAGO', 'FIBRA') not null
);

create table bonificaciones (
	id_bonificacion int primary key auto_increment,
    id_usuario int,
    tipo_bonificacion enum('DESCUENTO', 'SERVICIO GRATUITO') not null,
    monto varchar(100),
    fecha_asignacion date not null,
    foreign key (id_usuario) references usuarios(id_usuario)
);

create table reportes (
	id_reportes int primary key auto_increment,
    nombre_reporte varchar(100) not null,
    descripcion varchar(100) not null,
    fecha_creacion date,
    tipo_reporte varchar(100)
);

create table contrataciones (
	id_contratacion int primary key auto_increment,
    id_usuario int,
    id_servicio int,
    fecha_contratacion date not null,
    estado enum('ACTIVO', 'CANCELADO'),
    foreign key (id_usuario) references usuarios(id_usuario),
    foreign key (id_servicio) references servicios(id_servicio)
);
