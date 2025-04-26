CREATE DATABASE SistemaDeGestionHotelera;

GO
USE SistemaDeGestionHotelera;
GO

-- EXCEP sp_configure filestream_access_level, 2
-- RECONFIGURE

-- Tabla: Direccion
CREATE TABLE Direccion (
    IdDireccion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Provincia VARCHAR(20) NOT NULL,
    Canton VARCHAR(30) NOT NULL,
    Distrito VARCHAR(30) NOT NULL,
    Barrio VARCHAR(40) NULL,
    SenasExactas VARCHAR(150) NULL
);

-- Tabla: TipoInstalacion
CREATE TABLE TipoInstalacion (
    IdTipoInstalacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreInstalacion VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla: EmpresaHospedaje
CREATE TABLE EmpresaHospedaje (
    CedulaJuridica VARCHAR(15) PRIMARY KEY,
    NombreHotel VARCHAR(50) NOT NULL,
    IdTipoHotel SMALLINT NOT NULL,
    IdDireccion SMALLINT NOT NULL,
    ReferenciaGPS GEOGRAPHY NOT NULL,
    CorreoElectronico VARCHAR(50) NOT NULL UNIQUE,
    SitioWeb VARCHAR(50) NULL UNIQUE,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    CONSTRAINT FK_Empresa_Direccion FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion),
    CONSTRAINT FK_Tipo_Hotel_Empresa FOREIGN KEY (IdDireccion) REFERENCES TipoInstalacion(IdTipoInstalacion)
);
-- CONSTRAINT FK_ FOREIGN KEY () REFERENCES ()


-- Tabla: ServiciosEstablecimiento
CREATE TABLE ServiciosEstablecimiento (
    IdServicio SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreServicio VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla: ListaServiciosHospedaje
CREATE TABLE ListaServiciosHospedaje (
    IdEmpresa VARCHAR(15) NOT NULL,
    IdServicio SMALLINT NOT NULL,
    PRIMARY KEY (IdEmpresa, IdServicio),
    CONSTRAINT FK_Servicios_EmpresaHospedaje FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica),
    CONSTRAINT FK_ServiciosHospedaje_Lista FOREIGN KEY (IdServicio) REFERENCES ServiciosEstablecimiento(IdServicio)
);

-- Tabla: RedesSociales
CREATE TABLE RedesSociales (
    IdRedSocial SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL UNIQUE
);

-- Tabla: ListaRedesSociales
CREATE TABLE ListaRedesSociales (
    IdEmpresa VARCHAR(15) NOT NULL,
    IdRedSocial SMALLINT NOT NULL,
    Enlace VARCHAR(255) NOT NULL,
    PRIMARY KEY (IdEmpresa, IdRedSocial),
    CONSTRAINT FK_Red_Social_Empresa FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica),
    CONSTRAINT FK_Red_Social_Lista FOREIGN KEY (IdRedSocial) REFERENCES RedesSociales(IdRedSocial)
);

-- Tabla: TipoCama
CREATE TABLE TipoCama (
    IdTipoCama SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreCama VARCHAR(20) NOT NULL UNIQUE
);

-- Tabla: TipoHabitacion
CREATE TABLE TipoHabitacion (
    IdTipoHabitacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(40) NOT NULL,
    Descripcion VARCHAR(150) NOT NULL,
    --Fotos VARBINARY(MAX) NOT NULL,  --Fotos VARBINARY(MAX) FILESTREAM NOT NULL,  -- Este da problemas.
    IdTipoCama SMALLINT NOT NULL,
    Precio FLOAT CHECK (Precio > 0) NOT NULL,
    CONSTRAINT FK_Tipo_Cama_Habitacion FOREIGN KEY (IdTipoCama) REFERENCES TipoCama(IdTipoCama)
);

-- Tabla: Fotos
CREATE TABLE Fotos (

    IdImagen SMALLINT IDENTITY(1,1)  PRIMARY KEY,
    IdTipoHabitacion SMALLINT,
    Imagen VARBINARY(MAX),

    CONSTRAINT FK_Foto_TipoHabitacion FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion)

);

-- Tabla: DatosHabitacion
CREATE TABLE DatosHabitacion (
    IdDatosHabitacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Numero TINYINT NOT NULL,
    IdTipoHabitacion SMALLINT NOT NULL,
    CONSTRAINT FK_DatosHabitacion_TipoHabitacion FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion),
    CONSTRAINT UQ_Empresa_NumeroHabitacion UNIQUE (IdTipoHabitacion, Numero)
);

-- Tabla: HabitacionesEmpresa
CREATE TABLE HabitacionesEmpresa (
    IdEmpresa VARCHAR(15) NOT NULL,
    IdHabitacion SMALLINT NOT NULL,
    PRIMARY KEY (IdEmpresa, IdHabitacion),
    CONSTRAINT FK_HabitacionesEmpresa_Empresa FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica),
    CONSTRAINT FK_HabitacionesEmpresa_Habitacion FOREIGN KEY (IdHabitacion) REFERENCES DatosHabitacion(IdDatosHabitacion)
);

-- Tabla: Comodidad
CREATE TABLE Comodidad (
    IdComodidad SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL UNIQUE
);

-- Tabla: ListaComodidades
CREATE TABLE ListaComodidades (
    IdTipoHabitacion SMALLINT NOT NULL,
    IdComodidad SMALLINT NOT NULL,
    PRIMARY KEY (IdTipoHabitacion, IdComodidad),
    CONSTRAINT FK_ListaComodidades_Habitacion FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion),
    CONSTRAINT FK_ListaComodidades_Comodidad FOREIGN KEY (IdComodidad) REFERENCES Comodidad(IdComodidad)
);

-- Tabla: Cliente
CREATE TABLE Cliente (
    Cedula VARCHAR(15) PRIMARY KEY,
    NombreCompleto VARCHAR(50) NOT NULL,
    TipoIdentificacion VARCHAR(20) NOT NULL,
    PaisResidencia VARCHAR(50) NOT NULL,
    FechaNacimiento DATE CHECK (FechaNacimiento < GETDATE()) NOT NULL,
    IdDireccion SMALLINT NULL,
    CONSTRAINT FK_Cliente_Direccion FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

-- Tabla: Telefono
CREATE TABLE Telefono (
    IdTelefono SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario VARCHAR(15) NOT NULL,
    CodigoPais VARCHAR(5) NULL,
    NumeroTelefonico VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Telefono_Cliente FOREIGN KEY (IdUsuario) REFERENCES Cliente(Cedula)
);

-- Tabla: Reservacion
CREATE TABLE Reservacion (
    IdReservacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdCliente VARCHAR(15) NOT NULL,
    IdHabitacion SMALLINT NOT NULL,
    FechaHoraIngreso DATETIME CHECK (FechaHoraIngreso >= GETDATE()) NOT NULL,
    FechaHoraSalida DATETIME NOT NULL,
    CantidadPersonas TINYINT CHECK (CantidadPersonas > 0) NOT NULL,
    Vehiculo VARCHAR(2) NOT NULL CHECK (Vehiculo IN ('Si', 'No')),
    CONSTRAINT FK_Reservacion_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(Cedula),
    CONSTRAINT FK_Reservacio_Habitacion FOREIGN KEY (IdHabitacion) REFERENCES DatosHabitacion(IdDatosHabitacion)
);

-- Tabla: Facturacion
CREATE TABLE Facturacion (
    IdFacturacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdReservacion SMALLINT NOT NULL,
    MetodoPago VARCHAR(10) NOT NULL CHECK (MetodoPago IN ('Efectivo', 'Tarjeta')),
    CONSTRAINT FK_Facturacion_Reservacion FOREIGN KEY (IdReservacion) REFERENCES Reservacion(IdReservacion)
);

-- Tabla: EmpresaRecreacion
CREATE TABLE EmpresaRecreacion (
    CedulaJuridica VARCHAR(15) PRIMARY KEY,
    NombreEmpresa VARCHAR(50) NOT NULL,
    CorreoElectronico VARCHAR(50) NOT NULL UNIQUE,
    PersonaAContactar VARCHAR(30) NOT NULL,
    IdDireccion SMALLINT NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    CONSTRAINT FK_Empresa_Recreacion_Direccion FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

-- Tabla: ServiciosRecreacion
CREATE TABLE ServiciosRecreacion (
    IdServicio SMALLINT IDENTITY PRIMARY KEY,
    IdEmpresa VARCHAR(15) NOT NULL,
    NombreServicio VARCHAR(30) NOT NULL,
    Precio FLOAT CHECK (Precio > 0) NOT NULL,
    CONSTRAINT FK_Servicios_Recreacion_Empresa FOREIGN KEY (IdEmpresa) REFERENCES EmpresaRecreacion(CedulaJuridica)
);

-- Tabla: Actividad
CREATE TABLE Actividad (
    IdActividad SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreActividad VARCHAR(30) NOT NULL,
    DescripcionActividad VARCHAR(100) NOT NULL
);

-- Tabla: ListaActividades
CREATE TABLE ListaActividades (
    IdServicio SMALLINT NOT NULL,
    IdActividad SMALLINT NOT NULL,
    PRIMARY KEY (IdServicio, IdActividad),
    CONSTRAINT FK_ServiciosRecreacion_Lista FOREIGN KEY (IdServicio) REFERENCES ServiciosRecreacion(IdServicio),
    CONSTRAINT FK_ActividadRecreacion_Lista FOREIGN KEY (IdActividad) REFERENCES Actividad(IdActividad)
);

-- Tabla: ActividadesRecreacionPorEmpresa
CREATE TABLE ActividadesRecreacionPorEmpresa (
    IdEmpresa VARCHAR(15) NOT NULL,
    IdActividad SMALLINT NOT NULL,
    PRIMARY KEY (IdEmpresa, IdActividad),
    FOREIGN KEY (IdEmpresa) REFERENCES EmpresaRecreacion(CedulaJuridica),
    FOREIGN KEY (IdActividad) REFERENCES Actividad(IdActividad)
);



-- Podemos agregar este trigger, para hacer lo de la validacion de fechas:
-- Creación del TRIGGER para validar la relación entre FechaHoraIngreso y FechaHoraSalida
-- CREATE TRIGGER trg_ValidarFechasReservacion
-- ON Reservacion
-- AFTER INSERT, UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;
    
--     IF EXISTS (
--         SELECT 1 FROM inserted WHERE FechaHoraSalida <= FechaHoraIngreso
--     )
--     BEGIN
--         PRINT 'Error: FechaHoraSalida debe ser mayor a FechaHoraIngreso';
--         ROLLBACK TRANSACTION;
--     END
-- END;

-- Trigger para validar que los clientes no puedan registrar mas de tres telefonos.
CREATE TRIGGER trg_LimiteTelefonoCliente
ON Telefono
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT IdUsuario
        FROM Telefono
        GROUP BY IdUsuario
        HAVING COUNT(IdTelefono) > 3
    )
    BEGIN
        PRINT 'Error: Un cliente no puede tener más de 3 números de teléfono.';
        ROLLBACK TRANSACTION;
    END
END;

-- Videito sobre procedure: https://www.youtube.com/watch?v=8sCrjt5e2Yk&ab_channel=INFORMATICONFIG
-- ========================== Para la tabla de Direccion:
-- Agregar nuevas direcciones.
CREATE PROCEDURE sp_AgregarDireccion
    @Provincia VARCHAR(20),
    @Canton VARCHAR(30),
    @Distrito VARCHAR(30),
    @Barrio VARCHAR(40) NULL,
    @SenasExactas VARCHAR(150) NULL,
    @NuevoIdDireccion SMALLINT OUTPUT -- Este de aqui es para lo de optener el id creado
AS
BEGIN
    SET NOCOUNT ON; -- Para que no se muestren la cantidad de columnas afectadas.
    INSERT INTO Direccion (Provincia, Canton, Distrito, Barrio, SenasExactas)
    VALUES (@Provincia, @Canton, @Distrito, @Barrio, @SenasExactas);

    SET @NuevoIdDireccion = SCOPE_IDENTITY();
END;



-- ========================== Para la tabla de TipoInstalacion:

-- Agregar nuevos instalaciones.
CREATE PROCEDURE sp_AgregarTipoInstalacion
    @NombreInstalacion VARCHAR(30),
    @NuevoIdTipoInstalacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM TipoInstalacion WHERE NombreInstalacion = @NombreInstalacion) -- Revisar que no se tenga ese nombre agregado
    BEGIN
        INSERT INTO TipoInstalacion (NombreInstalacion)
        VALUES (@NombreInstalacion);

        SET @NuevoIdTipoInstalacion = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdTipoInstalacion = -1;  --- Codigo de error, mas facil para saber si ya existe.
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de EmpresaHospedaje:
-- Agregar
CREATE PROCEDURE sp_AgregarEmpresaHospedaje
    @CedulaJuridica VARCHAR(15),
    @NombreHotel VARCHAR(50),
    @IdTipoHotel SMALLINT,
    @IdDireccion SMALLINT,
    @ReferenciaGPS GEOGRAPHY,
    @CorreoElectronico VARCHAR(50),
    @SitioWeb VARCHAR(50) NULL,
    @Telefono VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CedulaJuridica = @CedulaJuridica)
    BEGIN
        INSERT INTO EmpresaHospedaje (CedulaJuridica, NombreHotel, IdTipoHotel, IdDireccion, ReferenciaGPS, CorreoElectronico, SitioWeb, Telefono)
        VALUES (@CedulaJuridica, @NombreHotel, @IdTipoHotel, @IdDireccion, @ReferenciaGPS, @CorreoElectronico, @SitioWeb, @Telefono);
    END
    ELSE
    BEGIN
        PRINT 'Error: Ya existe una empresa con esta cédula.';
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de ServiciosEstablecimiento:
-- Agregar
CREATE PROCEDURE sp_AgregarServicioEstablecimiento
    @NombreServicio VARCHAR(30),
    @NuevoIdServicio SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ServiciosEstablecimiento WHERE NombreServicio = @NombreServicio)
    BEGIN
        INSERT INTO ServiciosEstablecimiento (NombreServicio)
        VALUES (@NombreServicio);

        SET @NuevoIdServicio = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdServicio = -1; 
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de ListaServiciosHospedaje:
-- Agrgar un nuevo servicios a la lista de la empresa
CREATE PROCEDURE sp_AgregarListaServiciosHospedaje
    @IdEmpresa VARCHAR(15),
    @IdServicio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM ListaServiciosHospedaje
        WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio
    )
    BEGIN
        INSERT INTO ListaServiciosHospedaje (IdEmpresa, IdServicio)
        VALUES (@IdEmpresa, @IdServicio);
    END
    ELSE
    BEGIN
        PRINT 'Error: La empresa ya tiene asociado este servicio.';
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de RedSocial:

-- Agregar nueva red social:
CREATE PROCEDURE sp_AgregarRedSocial
    @Nombre VARCHAR(20),
    @NuevoIdRedSocial SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RedesSociales WHERE Nombre = @Nombre)
    BEGIN
        INSERT INTO RedesSociales (Nombre)
        VALUES (@Nombre);

        SET @NuevoIdRedSocial = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdRedSocial = -1;  
    END
END;


-- Editar

-- Eliminar:


-- ========================== Para la tabla de ListaRedesSociales:

-- Agregar asociacion entre red social y empresa
CREATE PROCEDURE sp_AgregarListaRedesSociales
    @IdEmpresa VARCHAR(15),
    @IdRedSocial SMALLINT,
    @Enlace VARCHAR(255),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial)
    BEGIN
        INSERT INTO ListaRedesSociales (IdEmpresa, IdRedSocial, Enlace)
        VALUES (@IdEmpresa, @IdRedSocial, @Enlace);

        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de TipoCama:

-- Agregar
CREATE PROCEDURE sp_AgregarTipoCama
    @NombreCama VARCHAR(20),
    @NuevoIdTipoCama SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM TipoCama WHERE NombreCama = @NombreCama)
    BEGIN
        INSERT INTO TipoCama (NombreCama)
        VALUES (@NombreCama);

        SET @NuevoIdTipoCama = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdTipoCama = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de TipoHabitacion:

-- Agregar
CREATE PROCEDURE sp_AgregarTipoHabitacion
    @Nombre VARCHAR(40),
    @Descripcion VARCHAR(150),
    @IdTipoCama SMALLINT,
    @Precio FLOAT,
    @NuevoIdTipoHabitacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM TipoHabitacion WHERE Nombre = @Nombre)
    BEGIN
        INSERT INTO TipoHabitacion (Nombre, Descripcion, IdTipoCama, Precio)
        VALUES (@Nombre, @Descripcion, @IdTipoCama, @Precio);

        SET @NuevoIdTipoHabitacion = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdTipoHabitacion = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de Imagen:

-- Agregar nueva imagen. (Esta no tiene )
CREATE PROCEDURE sp_AgregarFoto
    @IdTipoHabitacion SMALLINT,
    @Imagen VARBINARY(MAX),
    @NuevoIdImagen SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Fotos (IdTipoHabitacion, Imagen)
    VALUES (@IdTipoHabitacion, @Imagen);

    SET @NuevoIdImagen = SCOPE_IDENTITY();
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de DatosHabitacion:

-- Agregar
CREATE PROCEDURE sp_AgregarDatosHabitacion
    @Numero TINYINT,
    @IdTipoHabitacion SMALLINT,
    @NuevoIdDatosHabitacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que el número de habitación no esté repetido en la misma empresa, este hay que modificarlo para que sea un join y use el id de empresa
    IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion AND Numero = @Numero)
    BEGIN
        INSERT INTO DatosHabitacion (Numero, IdTipoHabitacion)
        VALUES (@Numero, @IdTipoHabitacion);

        SET @NuevoIdDatosHabitacion = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdDatosHabitacion = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de HabitacionesEmpresa:

-- Agregar la asociacion entre las habitaciones y la empresa.
CREATE PROCEDURE sp_AgregarHabitacionesEmpresa
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion)
    BEGIN
        INSERT INTO HabitacionesEmpresa (IdEmpresa, IdHabitacion)
        VALUES (@IdEmpresa, @IdHabitacion);

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de Comodidad:

-- Agregar
CREATE PROCEDURE sp_AgregarComodidad
    @Nombre VARCHAR(20),
    @NuevoIdComodidad SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Comodidad WHERE Nombre = @Nombre)
    BEGIN
        INSERT INTO Comodidad (Nombre)
        VALUES (@Nombre);

        SET @NuevoIdComodidad = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdComodidad = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de ListaComodidades:

-- Agregar
CREATE PROCEDURE sp_AgregarListaComodidades
    @IdTipoHabitacion SMALLINT,
    @IdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad)
    BEGIN
        INSERT INTO ListaComodidades (IdTipoHabitacion, IdComodidad)
        VALUES (@IdTipoHabitacion, @IdComodidad);

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de Cliente:

-- Agregar
CREATE PROCEDURE sp_AgregarCliente
    @Cedula VARCHAR(15),
    @NombreCompleto VARCHAR(50),
    @TipoIdentificacion VARCHAR(20),
    @PaisResidencia VARCHAR(50),
    @FechaNacimiento DATE,
    @IdDireccion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE Cedula = @Cedula)
    BEGIN
        INSERT INTO Cliente (Cedula, NombreCompleto, TipoIdentificacion, PaisResidencia, FechaNacimiento, IdDireccion)
        VALUES (@Cedula, @NombreCompleto, @TipoIdentificacion, @PaisResidencia, @FechaNacimiento, @IdDireccion);

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de Telefono:

-- Agregar
CREATE PROCEDURE sp_AgregarTelefono
    @IdUsuario VARCHAR(15),
    @CodigoPais VARCHAR(5),
    @NumeroTelefonico VARCHAR(20),
    @NuevoIdTelefono SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que el cliente no tenga más de 3 números registrados
    IF (SELECT COUNT(*) FROM Telefono WHERE IdUsuario = @IdUsuario) < 3
    BEGIN
        INSERT INTO Telefono (IdUsuario, CodigoPais, NumeroTelefonico)
        VALUES (@IdUsuario, @CodigoPais, @NumeroTelefonico);

        SET @NuevoIdTelefono = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdTelefono = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de Reservacion:

-- Agregar
CREATE PROCEDURE sp_AgregarReservacion -- Este deveria de verificar que en el rango de fechas indicado no se haya reservado anteriormente esa habitacion.
    @IdCliente VARCHAR(15),
    @IdHabitacion SMALLINT,
    @FechaHoraIngreso DATETIME,
    @FechaHoraSalida DATETIME,
    @CantidadPersonas TINYINT,
    @Vehiculo VARCHAR(2),
    @NuevoIdReservacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que la fecha de salida sea mayor a la fecha de ingreso
    IF @FechaHoraSalida > @FechaHoraIngreso
    BEGIN
        INSERT INTO Reservacion (IdCliente, IdHabitacion, FechaHoraIngreso, FechaHoraSalida, CantidadPersonas, Vehiculo)
        VALUES (@IdCliente, @IdHabitacion, @FechaHoraIngreso, @FechaHoraSalida, @CantidadPersonas, @Vehiculo);

        SET @NuevoIdReservacion = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdReservacion = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de Facturacion:

-- Agregar
CREATE PROCEDURE sp_AgregarFacturacion
    @IdReservacion SMALLINT,
    @MetodoPago VARCHAR(10),
    @NuevoIdFacturacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Facturacion WHERE IdReservacion = @IdReservacion)
    BEGIN
        INSERT INTO Facturacion (IdReservacion, MetodoPago)
        VALUES (@IdReservacion, @MetodoPago);

        SET @NuevoIdFacturacion = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdFacturacion = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de EmpresaRecreacion:

-- Agregar
CREATE PROCEDURE sp_AgregarEmpresaRecreacion
    @CedulaJuridica VARCHAR(15),
    @NombreEmpresa VARCHAR(50),
    @CorreoElectronico VARCHAR(50),
    @PersonaAContactar VARCHAR(30),
    @IdDireccion SMALLINT,
    @Telefono VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica)
    BEGIN
        INSERT INTO EmpresaRecreacion (CedulaJuridica, NombreEmpresa, CorreoElectronico, PersonaAContactar, IdDireccion, Telefono)
        VALUES (@CedulaJuridica, @NombreEmpresa, @CorreoElectronico, @PersonaAContactar, @IdDireccion, @Telefono);

        SET @Resultado = 1;  -- Éxito
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Error: Ya existe la empresa
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de ServiciosRecreacion:

-- Agregar
CREATE PROCEDURE sp_AgregarServiciosRecreacion
    @IdEmpresa VARCHAR(15),
    @NombreServicio VARCHAR(30),
    @Precio FLOAT,
    @NuevoIdServicio SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ServiciosRecreacion WHERE IdEmpresa = @IdEmpresa AND NombreServicio = @NombreServicio)
    BEGIN
        INSERT INTO ServiciosRecreacion (IdEmpresa, NombreServicio, Precio)
        VALUES (@IdEmpresa, @NombreServicio, @Precio);

        SET @NuevoIdServicio = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdServicio = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de Actividad:

-- Agregar 
CREATE PROCEDURE sp_AgregarActividad
    @NombreActividad VARCHAR(30),
    @DescripcionActividad VARCHAR(100),
    @NuevoIdActividad SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Actividad WHERE NombreActividad = @NombreActividad)
    BEGIN
        INSERT INTO Actividad (NombreActividad, DescripcionActividad)
        VALUES (@NombreActividad, @DescripcionActividad);

        SET @NuevoIdActividad = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @NuevoIdActividad = -1;  -- Deveria de devolver el id de la actividad de una vez de ser posible
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de ListaActividades:

-- Agregar
CREATE PROCEDURE sp_AgregarListaActividades
    @IdServicio SMALLINT,
    @IdActividad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad)
    BEGIN
        INSERT INTO ListaActividades (IdServicio, IdActividad)
        VALUES (@IdServicio, @IdActividad);

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Editar

-- Eliminar:

-- ========================== Para la tabla de :

-- Agregar

-- Editar

-- Eliminar:


-- ========================== Para la tabla de :

-- Agregar

-- Editar

-- Eliminar:

