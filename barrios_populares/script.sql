CREATE TABLE Provincias(
  id int identity(1,1),
  nombre varchar(35) not null unique,
  constraint pk_provincias primary key (id)
);

CREATE TABLE Departamentos(
  id int identity(1,1),
  nombre varchar(35) not null unique,
  prov_id int not null,
  constraint pk_departamentos primary key (id),
  constraint fk_provincias foreign key (prov_id) references Provincias(id)
);

CREATE TABLE Localidades(
  id int identity(1,1),
  nombre varchar(50) not null,
  depa_id int not null,
  constraint pk_localidades primary key (id),
  constraint fk_departamentos foreign key (depa_id) references Departamentos(id)
);