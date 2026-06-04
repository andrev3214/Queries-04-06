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
	Telefono varchar(20)
)
go


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
	Telefono varchar(20),
	IdEspecialidades int not null,
)


create table Citas
(
	IdCita int primary key identity(1,1),
	FechaCita date not null,
	HoraCita time not null,
	Motivo varchar(255),
	IdPaciente int not null,
	IdMedico int not null,
)

create table Habitaciones
(
	IdHabitacion int primary key identity(1,1),
	NumeroHabitacion varchar(10) not null,
	TipoHabitacion varchar(50),
	Estado varchar(50)
)
