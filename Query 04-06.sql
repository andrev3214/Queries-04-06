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

--Eliminar  tabla temporal

drop table TablaTemporal;
go


--Eliminar restricción CHECK

alter table Pacientes
drop constraint CK_Pacientes_Edad;
go


--Eliminar restriccion UNIQUE

alter table Pacientes
drop constraint UQ_Pacientes_Correo;
go


--Eliminar una columna
alter table Medicos
drop column Turno;
go


--Eliminar tabla de pruebas
drop table TablaPruebas;
go


--Crear y eliminar tabla de auditoría
create table Auditoria
(
    IdAuditoria int primary key identity(1,1),
    Descripcion varchar(200),
    Fecha datetime default getdate()
);
go

drop table Auditoria;
go

--Crear y eliminar tabla de logs

create table Logs
(
    IdLog int primary key identity(1,1),
    Mensaje varchar(255),
    Fecha datetime default getdate()
);
go

drop table Logs;
go


--Eliminar foreign key

alter table Citas
drop constraint FK_Citas_Pacientes;
go

--Eliminar tabla MedicamentosPrueba

drop table MedicamentosPrueba;
go


--Eliminar base de datos de pruebas
use master;
go

drop database HospitalPruebasDB;
go

--Insertar 5 especialidades medicas
insert into Especialidades (NombreEspecialidad) values ('Cardiología'), ('Neurología'), ('Pediatría'), ('Dermatología'), ('Gastroenterología');

--Insertar 10 medicos
insert into Medicos (Nombre, Apellido, Correo, Telefono, IdEspecialidades) values 
('Juan', 'Pérez', 'juan.perez@example.com', '555-1234', 1),
('María', 'Gómez', 'maria.gomez@example.com', '555-5678', 2),
('Carlos', 'López', 'carlos.lopez@example.com', '555-9012', 3),
('Ana', 'Martínez', 'ana.martinez@example.com', '555-3456', 4),
('Luis', 'Rodríguez', 'luis.rodriguez@example.com', '555-7890', 5),
('Sofía', 'Hernández', 'sofia.hernandez@example.com', '555-2345', 1),
('Miguel', 'García', 'miguel.garcia@example.com', '555-6789', 2),
('Laura', 'Sánchez', 'laura.sanchez@example.com', '555-0123', 3),
('Diego', 'Ramírez', 'diego.ramirez@example.com', '555-4567', 4),
('Valentina', 'Torres', 'valentina.torres@example.com', '555-8901', 5);

--Insertar 20 pacientes
insert into Pacientes (Nombre, Apellido, FechaNacimiento, Correo, Genero, Direccion, Telefono, Tipo_Sangre) values 
('Pedro', 'González', '1985-03-15', 'pedro.gonzalez@example.com', 'M', 'Calle 123, Ciudad', '555-1111', 'O+'),
('Lucía', 'Fernández', '1990-07-22', 'lucia.fernandez@example.com', 'F', 'Avenida 456, Ciudad', '555-2222', 'A-'),
('Jorge', 'Martínez', '1978-11-30', 'jorge.martinez@example.com', 'M', 'Calle 789, Ciudad', '555-3333', 'B+'),
('Sofía', 'López', '2000-01-10', 'sofia.lopez@example.com', 'F', 'Avenida 321, Ciudad', '555-4444', 'AB-'),
('Diego', 'García', '1995-05-05', 'diego.garcia@example.com', 'M', 'Calle 654, Ciudad', '555-5555', 'O-'),
('Valentina', 'Hernández', '1988-09-18', 'valentina.hernandez@example.com', 'F', 'Avenida 987, Ciudad', '555-6666', 'A+'),
('Miguel', 'Sánchez', '1975-12-25', 'miguel.sanchez@example.com', 'M', 'Calle 321, Ciudad', '555-7777', 'B-'),
('Laura', 'Ramírez', '1992-04-12', 'laura.ramirez@example.com', 'F', 'Calle 654, Ciudad', '555-8888', 'AB+'),
('Carlos', 'Torres', '1980-08-20', 'carlos.torres@example.com', 'M', 'Avenida 123, Ciudad', '555-9999', 'O+'),
('Ana','Gómez','1998-02-28','ana.gomez@example.com','F','Calle 987, Ciudad','555-0000','A-'),
('Luis','Rodríguez','1983-06-10','luis.rodriguez@example.com','M','Calle 456, Ciudad','555-1111','B+'),
('Sofía','Hernández','1991-09-25','sofia.hernandez@example.com','F','Avenida 321, Ciudad','555-2222','AB-'),
('Miguel','García','1977-11-05','miguel.garcia@example.com','M','Calle 789, Ciudad','555-3333','O+'),
('Laura','Sánchez','1993-03-18','laura.sanchez@example.com','F','Calle 654, Ciudad','555-4444','A+'),
('Diego','Ramírez','1989-12-30','diego.ramirez@example.com','M','Avenida 123, Ciudad','555-5555','B-'),
('Valentina','Torres','1995-07-14','valentina.torres@example.com','F','Calle 321, Ciudad','555-6666','O+'),
('Pedro','González','1985-03-15','pedro.gonzalez@example.com','M','Calle 123, Ciudad','555-1111','O+'),
('Lucía','Fernández','1990-07-22','lucia.fernandez@example.com','F','Avenida 456, Ciudad','555-2222','A-'),
('Jorge','Martínez','1978-11-30','jorge.martinez@example.com','M','Calle 789, Ciudad','555-3333','B+'),
('Sofía','López','2000-01-10','sofia.lopez@example.com','F','Avenida 321, Ciudad','555-4444','AB-');

--Insertar 15 citas
insert into Citas (FechaCita, HoraCita, Motivo, IdPaciente, IdMedico) values 
('2024-07-01', '09:00:00', 'Consulta general', 1, 1),
('2024-07-02', '10:30:00', 'Dolor de cabeza', 2, 2),
('2024-07-03', '14:00:00', 'Chequeo anual', 3, 3),
('2024-07-04', '11:15:00', 'Erupción cutánea', 4, 4),
('2024-07-05', '16:45:00', 'Dolor abdominal', 5, 5),
('2024-07-06', '13:30:00', 'Consulta general', 6, 1),
('2024-07-07', '15:00:00', 'Dolor de cabeza', 7, 2),
('2024-07-08', '09:45:00', 'Chequeo anual', 8, 3),
('2024-07-09', '12:30:00', 'Erupción cutánea', 9, 4),
('2024-07-10', '14:15:00', 'Dolor abdominal', 10, 5),
('2024-07-11', '10:00:00', 'Consulta general', 11, 1),
('2024-07-12', '11:30:00', 'Dolor de cabeza', 12, 2),
('2024-07-13', '13:45:00', 'Chequeo anual', 13, 3),
('2024-07-14', '15:30:00', 'Erupción cutánea', 14, 4),
('2024-07-15', '09:15:00', 'Dolor abdominal', 15, 5);

--Insertar 10 habitaciones
insert into Habitaciones (NumeroHabitacion, TipoHabitacion, Estado) values 
('101', 'Individual', 'Disponible'),
('102', 'Doble', 'Ocupada'),
('103', 'Suite', 'Disponible'),
('104', 'Individual', 'Ocupada'),
('105', 'Doble', 'Disponible'),
('106', 'Suite', 'Ocupada'),
('107', 'Individual', 'Disponible'),
('108', 'Doble', 'Ocupada'),
('109', 'Suite', 'Disponible'),
('110', 'Individual', 'Ocupada');

--Insertar 10 tratamientos
insert into Tratamientos (Descripcion, FechaInicio, IdPaciente, IdMedicamento) values 
('Tratamiento para hipertensión', '2024-07-01', 1, 1),
('Tratamiento para migraña', '2024-07-02', 2, 2),
('Tratamiento para diabetes', '2024-07-03', 3, 3),
('Tratamiento para acné', '2024-07-04', 4, 4),
('Tratamiento para gastritis', '2024-07-05', 5, 5),
('Tratamiento para hipertensión', '2024-07-06', 6, 1),
('Tratamiento para migraña', '2024-07-07', 7, 2),
('Tratamiento para diabetes', '2024-07-08', 8, 3),
('Tratamiento para acné', '2024-07-09', 9, 4),
('Tratamiento para gastritis', '2024-07-10', 10, 5);

--Insertar 20 medicamentos 
insert into Medicamentos (NombreMedicamento, Descripcion, stock, IdTratamiento) values 
('Lisinopril', 'Medicamento para la hipertensión', 100, 1),
('Sumatriptán', 'Medicamento para la migraña', 50, 2),
('Metformina', 'Medicamento para la diabetes', 200, 3),
('Isotretinoína', 'Medicamento para el acné', 30, 4),
('Omeprazol', 'Medicamento para la gastritis', 150, 5),
('Amlodipino', 'Medicamento para la hipertensión', 120, 1),
('Rizatriptán', 'Medicamento para la migraña', 60, 2),
('Glipizida', 'Medicamento para la diabetes', 180, 3),
('Tretinoína', 'Medicamento para el acné', 40, 4),
('Ranitidina', 'Medicamento para la gastritis', 130, 5),
('Enalapril', 'Medicamento para la hipertensión', 110, 1),
('Zolmitriptán', 'Medicamento para la migraña', 70, 2),
('Gliburida', 'Medicamento para la diabetes', 160, 3),
('Adapaleno', 'Medicamento para el acné', 35, 4),
('Famotidina', 'Medicamento para la gastritis', 140, 5),
('Captopril', 'Medicamento para la hipertensión', 90, 1),
('Eletriptán', 'Medicamento para la migraña', 80, 2),
('Pioglitazona', 'Medicamento para la diabetes', 170, 3),
('Clindamicina tópica','Medicamento para el acné','25','4'),
('Sucralfato', 'Medicamento para la gastritis', 120, 5);

--Insertar pacientes con todos los campos
insert into Pacientes (Nombre, Apellido, FechaNacimiento, Genero, Direccion, Telefono, Tipo_Sangre) values 
('Pedro', 'González', '1985-03-15', 'M', 'Calle 123, Ciudad', '555-1111', 'O+'),
('Lucía', 'Fernández', '1990-07-22', 'F', 'Avenida 456, Ciudad', '555-2222', 'A-'),
('Jorge', 'Martínez', '1978-11-30', 'M', 'Calle 789, Ciudad', '555-3333', 'B+'),
('Sofía', 'López', '2000-01-10', 'F', 'Avenida 321, Ciudad', '555-4444', 'AB-'),
('Diego', 'García', '1995-05-05', 'M', 'Calle 654, Ciudad', '555-5555', 'O-'),
('Valentina', 'Hernández', '1988-09-18', 'F', 'Avenida 987, Ciudad', '555-6666', 'A+'),
('Miguel', 'Sánchez', '1975-12-25', 'M', 'Calle 321, Ciudad', '555-7777', 'B-'),
('Laura', 'Ramírez', '1992-04-12', 'F', 'Avenida 654, Ciudad', '555-8888', 'AB+'),
('Carlos', 'Torres', '1980-08-20', 'M', 'Calle 987, Ciudad', '555-9999','O+'),
('Ana','Gómez','1998-02-28','F','Avenida 123, Ciudad','555-0000','A+');

--Insertar medicos especialistas
insert into Medicos (Nombre, Apellido, Correo, Telefono, IdEspecialidades, Experiencia) values 
('Juan', 'Pérez', 'juan.perez@hospital.com', '555-1111', 1, 10),
('María', 'Gómez', 'maria.gomez@hospital.com', '555-2222', 2, 8),
('Carlos', 'López', 'carlos.lopez@hospital.com', '555-3333', 3, 12);

--Insertar citas con fecha actual
insert into Citas (FechaCita, HoraCita, Motivo, IdPaciente, IdMedico) values
(getdate(), '10:00:00', 'Consulta general', 1, 1),
(getdate(), '11:30:00', 'Dolor de cabeza', 2, 2),
(getdate(), '14:00:00', 'Chequeo anual', 3, 3);

--Insertar citas futuras
insert into Citas (FechaCita, HoraCita, Motivo, IdPaciente, IdMedico) values
('2024-08-01', '09:00:00', 'Consulta general', 4, 1),
('2024-08-02', '10:30:00', 'Dolor de cabeza', 5, 2),
('2024-08-03', '14:00:00', 'Chequeo anual', 6, 3);

--Insertar habitaciones ocupadas
insert into Habitaciones (NumeroHabitacion, TipoHabitacion, Estado) values 
('201', 'Individual', 'Ocupada'),
('202', 'Doble', 'Ocupada'),
('203', 'Suite', 'Ocupada');

--Insertar	habitaciones disponibles
insert into Habitaciones (NumeroHabitacion, TipoHabitacion, Estado) values 
('204', 'Individual', 'Disponible'),
('205', 'Doble', 'Disponible'),
('206', 'Suite', 'Disponible');

--Insertar tratamientos activos
insert into Tratamientos (Descripcion, FechaInicio, IdPaciente, IdMedicamento) values 
('Tratamiento para hipertensión', getdate(), 1, 1),
('Tratamiento para migraña', getdate(), 2, 2),
('Tratamiento para diabetes', getdate(), 3, 3);

--Insertar tratamientos finalizados
insert into Tratamientos (Descripcion, FechaInicio, IdPaciente, IdMedicamento) values 
('Tratamiento para acné', '2024-01-01', 4, 4),
('Tratamiento para gastritis', '2024-02-01', 5, 5),
('Tratamiento para hipertensión', '2024-03-01', 6, 1);

--Modulo VI - Update

--actualizar telefono de un paciente
update Pacientes set Telefono = '555-9999' where IdPaciente = 1;

--Actualizar direccion de un paciente
update Pacientes set Direccion = 'Calle Nueva 456, Ciudad' where IdPaciente = 2;

--Actualizar salario de un medico
update Medicos set Salario = 75000 where IdMedico = 1;

--Actualizar turno de un medico
update Medicos set Turno = 'Tarde' where IdMedico = 2;

--Cambiar estado de una cita
update Citas set Estado = 'Confirmada' where IdCita = 1;

--Actualizar costo de una consulta
update Citas set Costo_Consulta = 150.00 where IdCita = 2;

--Actualizar nombre de una especialidad
update Especialidades set NombreEspecialidad = 'Cardiología Avanzada' where IdEspecialidad = 1;

--Actualizar disponibilidad de una habitación
update Habitaciones set Disponibilidad = 'No Disponible' where IdHabitacion = 204;

--Actualizar tratamiento activo
update Tratamientos set FechaInicio = getdate() where IdTratamiento = 1;

--Actualizar medicamento
update Medicamentos set stock = 80 where IdMedicamento = 1;

--Actualizar correo de paciente
update Pacientes set Correo = 'lucia.fernandez@gmail.com' where IdPaciente = 2;

--Actualizar correo de medico
update Medicos set Correo = 'maria.gomez@hozpital.com' where IdMedico = 2;

--Actulizar fecha de cita
update Citas set FechaCita = '2024-08-15' where IdCita = 1;

--Actualizar experiencia de medico
update Medicos set Experiencia = 15 where IdMedico = 1;

--Actualizar tipo de sangre
update Pacientes set Tipo_Sangre = 'O+' where IdPaciente = 1;

--Modulo VII - Delete

--Eliminar un paciente en especifico
delete from Pacientes where IdPaciente = 1;

--Eliminar una cita
delete from Citas where IdCita = 1;

--Eliminar un medicamento
delete from Medicamentos where IdMedicamento = 1;

--Eliminar una habitacion
delete from Habitaciones where IdHabitacion = 204;

--Eliminar un tratamiento
delete from Tratamientos where IdTratamiento = 1;

--Eliminar citas canceladas
delete from Citas where Estado = 'Cancelada';

--Eliminar pacientes sin citas
delete from Pacientes where IdPaciente not in (select IdPaciente from Citas);

--Eliminar habitaciones vacias
delete from Habitaciones where Estado = 'Disponible';

--Eliminar medicamentos vencidos
delete from Medicamentos where stock = 0;

--Eliminar registros de pruebas
delete from Pacientes where Nombre like 'Test%';

--Modulo VIII - Consultas select

--Mostrar todos los pacientes
select * from Pacientes;

--Mostrar todos los medicos
select * from Medicos;
