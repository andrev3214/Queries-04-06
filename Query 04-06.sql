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
)

create table Medicamentos
(
	IdMedicamento int primary key identity(1,1),
	NombreMedicamento varchar(100) not null,
	Descripcion varchar(255),
	stock int not null
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
	references Medicamentos(IdMedicamento)
)


