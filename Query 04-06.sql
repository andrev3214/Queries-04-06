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

