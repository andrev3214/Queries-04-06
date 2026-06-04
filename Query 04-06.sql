use master;
go

if(exists(select * from sys.databases where name = 'HospitalDB'))
begin
	drop database HospitalDB
end
go

create database HospitalDB
go


use HospitalDB
go

create table Pacientes
(
	IdPaciente int primary key identity(1,1),
	Nombre varchar(100) not null,
	Apellido varchar(100) not null,
	FechaNacimiento date not null,
	Genero char(1),
	Direccion varchar(200),
	Telefono varchar(20),
	FechaRegistro date default getdate()
)

create table Especialidades
(
	IdEspecialidad int primary key identity(1,1),
	NombreEspecialidad varchar(100) not null
)

create table Medicos
(
	IdMedico int primary key identity(1,1),
	Nombre varchar(100) not null,
	Apellido varchar(100) not null,
	Correo varchar(150) unique,
	Telefono varchar(20),
	IdEspecialidades int not null,

	constraint FK_Medicos_Especialidades
	foreign key (IdEspecialidades)
	references Especialidades(IdEspecialidad)
)

create table Habitaciones
(
	IdHabitacion int primary key identity(1,1),
	NumeroHabitacion varchar(10) not null,
	TipoHabitacion varchar(50),
	Estado varchar(50)
	
	constraint FK_Habitaciones_Pacientes
    foreign key (IdPaciente)
    references Pacientes(IdPaciente)
)

create table Medicamentos
(
	IdMedicamento int primary key identity(1,1),
	NombreMedicamento varchar(100) not null,
	Descripcion varchar(255),
	stock int not null,
	IdTratamiento int not null,

	constraint FK_Medicamentos_Tratamientos
	foreign key (IdTratamiento)
	references Tratamientos(IdTratamiento)
)

create table Citas
(
	IdCita int primary key identity(1,1),
	FechaCita date not null,
	HoraCita time not null,
	Motivo varchar(255),
	IdPaciente int not null,
	IdMedico int not null,

	constraint FK_Citas_Pacientes
	foreign key (IdPaciente)
	references Pacientes(IdPaciente),

	constraint FK_Citas_Medicas
	foreign key (IdMedico)
	references Medicos(IdMedico)
)

create table Tratamientos
(
	IdTratamiento int primary key identity(1,1),
	Descripcion varchar(255) not null,
	FechaInicio date,
	IdPaciente int not null,
	IdMedicamento int not null,

	constraint FK_Tratamientos_Pacientes
	foreign key (IdPaciente)
	References Pacientes(IdPaciente),

	constraint FK_Tratamientos_Medicamentos
	foreign key (IdPaciente)
	references Medicamentos(IdMedicamento),

    constraint FK_Tratamientos_Pacientes
    foreign key (IdPaciente)
    references Pacientes(IdPaciente)
)

-- Agregar teléfono
alter table Pacientes
add Telefono varchar(20);

-- Agregar dirección
alter table Pacientes
add Direccion varchar(200);

-- Agregar género
alter table Pacientes
add Genero char(1);

-- Agregar tipo de sangre
alter table Pacientes
add Tipo_Sangre varchar(5);

-- Agregar fecha de nacimiento
alter table Pacientes
add Fecha_Nacimiento date;

-- Modificar tamaño del campo nombre
alter table Pacientes
alter column Nombre varchar(150) NOT NULL;

-- Modificar tamaño del campo dirección
alter table Pacientes
alter column Direccion varchar(300);

/*
Medicos
-- Agregar experiencia
*/
alter table Medicos
add Experiencia int;

-- Agregar turno
alter table Medicos
add Turno varchar(50);

-- Agregar observaciones
alter table Medicos
add Observaciones varchar(255);

-- Eliminar observaciones
alter table Medicos
drop column Observaciones;

/*
Citas
-- Agregar estado
*/
alter table Citas
add Estado varchar(50);

-- Agregar costo de consulta
alter table Citas
add Costo_Consulta float;

-- Modificar tipo de dato del costo
alter table Citas
alter column Costo_Consulta decimal(10,2);

/*
Habitaciones
*/

-- Agregar disponibilidad
alter table Habitaciones
add Disponibilidad varchar(50);

