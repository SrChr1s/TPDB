DROP TABLE IF EXISTS [dbo].[Barrios]
DROP TABLE IF EXISTS [dbo].[Decadas]
DROP TABLE IF EXISTS [dbo].[Energias_Electricas]
DROP TABLE IF EXISTS [dbo].[Salidas_Cloacales]
DROP TABLE IF EXISTS [dbo].[Aguas_Corrientes]
DROP TABLE IF EXISTS [dbo].[Cocinas]
DROP TABLE IF EXISTS [dbo].[Calefacciones]
DROP TABLE IF EXISTS [dbo].[Clasificaciones]
DROP TABLE IF EXISTS [dbo].[Localidades]
DROP TABLE IF EXISTS [dbo].[Departamentos]
DROP TABLE IF EXISTS [dbo].[Provincias]

CREATE TABLE Provincias (
	id int identity(1,1) primary key,
	nombre varchar(255) not null
);

INSERT INTO Provincias(nombre)
select distinct provincia from base order by 1;

CREATE TABLE Departamentos (
	id int identity(1,1) primary key,
	nombre varchar(255) not null,
	id_prov int not null,
	foreign key (id_prov) references Provincias(id)
);

INSERT INTO Departamentos(nombre, id_prov)
select distinct b.departamento, p.id from base as b
inner join Provincias as p on p.nombre = b.provincia
order by 1;

CREATE TABLE Localidades (
	id int identity(1,1) primary key,
	nombre varchar(255) not null,
	id_depa int not null,
	foreign key (id_depa) references Departamentos(id)
);

INSERT INTO Localidades(nombre, id_depa)
select distinct b.localidad, d.id from base as b
inner join Provincias as p on p.nombre = b.provincia
inner join Departamentos as d on d.nombre = b.departamento and d.id_prov = p.id
order by 1;

CREATE TABLE Decadas (
	id int identity(1,1) primary key,
	decada int not null
);

INSERT INTO Decadas(decada)
select distinct CAST(SUBSTRING(decada_de_creacion,7,100) AS int) from base order by 1;

CREATE TABLE Energias_Electricas (
	id int identity(1,1) primary key,
	descripcion varchar(255) not null
);

INSERT INTO Energias_Electricas(descripcion)
select distinct b.energia_electrica from base as b order by 1;

CREATE TABLE Salidas_Cloacales (
	id int identity(1,1) primary key,
	descripcion varchar(255) not null
);

INSERT INTO Salidas_Cloacales(descripcion)
select distinct b.efluentes_cloacales from base as b order by 1;

CREATE TABLE Aguas_Corrientes (
	id int identity(1,1) primary key,
	descripcion varchar(255) not null
);

INSERT INTO Aguas_Corrientes(descripcion)
select distinct b.agua_corriente from base as b order by 1;

CREATE TABLE Cocinas (
	id int identity(1,1) primary key,
	descripcion varchar(255) not null
);

INSERT INTO Cocinas(descripcion)
select distinct b.cocina from base as b order by 1;

CREATE TABLE Calefacciones (
	id int identity(1,1) primary key,
	descripcion varchar(255) not null
);

INSERT INTO Calefacciones(descripcion)
select distinct b.calefaccion from base as b order by 1;

CREATE TABLE Clasificaciones (
	id int identity(1,1) primary key,
	descripcion varchar(255) not null
);

INSERT INTO Clasificaciones(descripcion)
select distinct b.clasificacion_barrio from base as b order by 1;

CREATE TABLE Barrios (
	id int identity(1,1) primary key,
	nombre varchar(255) not null,
	id_localidad int not null,
	cant_viviendas int not null,
	cant_familias int not null,
	id_decada int not null,
	anio_creacion int,
	id_energia int not null,
	id_cloaca int not null,
	id_agua int not null,
	id_cocina int not null,
	id_calefaccion int not null,
	titulo_propiedad bit not null,
	id_clasificacion int not null,
	superficie_m2 int not null,
	foreign key (id_localidad) references Localidades(id),
	foreign key (id_decada) references Decadas(id),
	foreign key (id_energia) references Energias_Electricas(id),
	foreign key (id_cloaca) references Salidas_Cloacales(id),
	foreign key (id_agua) references Aguas_Corrientes(id),
	foreign key (id_cocina) references Cocinas(id),
	foreign key (id_calefaccion) references Calefacciones(id),
	foreign key (id_clasificacion) references Clasificaciones(id),
);

INSERT INTO Barrios (nombre, id_localidad, cant_viviendas, cant_familias, id_decada,
anio_creacion, id_energia, id_cloaca, id_agua, id_cocina, id_calefaccion, titulo_propiedad,
id_clasificacion, superficie_m2)
select distinct b.nombre_barrio, l.id, b.cantidad_viviendas_aproximadas, b.cantidad_familias_aproximada,
d.id, b.anio_de_creacion, e.id, clo.id, a.id, coc.id, cal.id, CASE b.titulo_propiedad WHEN 'SI' THEN 1 ELSE 0 END, cla.id,
b.superficie_m2
from base as b
inner join Provincias as p on p.nombre = b.provincia
inner join Departamentos as depa on depa.nombre = b.departamento and depa.id_prov = p.id
inner join Localidades as l on l.nombre = b.localidad and l.id_depa = depa.id
inner join Decadas as d on d.decada = SUBSTRING(b.decada_de_creacion,7,100)
inner join Energias_Electricas as e on e.descripcion = b.energia_electrica
inner join Salidas_Cloacales as clo on clo.descripcion = b.efluentes_cloacales
inner join Aguas_Corrientes as a on a.descripcion = b.agua_corriente
inner join Cocinas as coc on coc.descripcion = b.cocina
inner join Calefacciones as cal on cal.descripcion = b.calefaccion
inner join Clasificaciones as cla on cla.descripcion = b.clasificacion_barrio;