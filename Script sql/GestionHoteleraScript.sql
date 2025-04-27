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

-- Tabla: TipoGabitacionEmpresa
CREATE TABLE TipoHabitacionEmpresa (
    IdTipoHabitacion SMALLINT NOT NULL,
    IdEmpresa VARCHAR(15) NOT NULL,  
    PRIMARY KEY (IdTipoHabitacion, IdEmpresa), 
    CONSTRAINT FK_TipoHabitacion_EmpresaHospedaje FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion) ON DELETE CASCADE,
    CONSTRAINT FK_IdEmpresaHospedaje_Tipo FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica)
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
    IdEmpresa VARCHAR(15) NOT NULL,
    NombreActividad VARCHAR(30) NOT NULL,
    DescripcionActividad VARCHAR(100) NOT NULL,
    CONSTRAINT FK_ Actividad_EmpresaRecreacion FOREIGN KEY (IdEmpresa) REFERENCES EmpresaRecreacion(CedulaJuridica)

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

-- Editar
CREATE PROCEDURE sp_ActualizarDireccion
    @IdDireccion SMALLINT,
    @Provincia VARCHAR(20),
    @Canton VARCHAR(30),
    @Distrito VARCHAR(30),
    @Barrio VARCHAR(40),
    @SenasExactas VARCHAR(150),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Direccion WHERE IdDireccion = @IdDireccion)
    BEGIN
        UPDATE Direccion
        SET Provincia = @Provincia,
            Canton = @Canton,
            Distrito = @Distrito,
            Barrio = @Barrio,
            SenasExactas = @SenasExactas
        WHERE IdDireccion = @IdDireccion;

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarDireccion
    @IdDireccion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Para poder eliminar, la asociacion con cliente o empresas no debe de existir.
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE IdDireccion = @IdDireccion)
    AND NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE IdDireccion = @IdDireccion)
    AND NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE IdDireccion = @IdDireccion)
    BEGIN
        DELETE FROM Direccion WHERE IdDireccion = @IdDireccion;
        SET @Resultado = 1;  -- Se pudo eliminar
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- -1 Significa que hay un error y no se pudo eliminar, (Esta registrado en una tabla)
    END
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
CREATE PROCEDURE sp_ActualizarTipoInstalacion
    @IdTipoInstalacion SMALLINT,
    @NombreInstalacion VARCHAR(30),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM TipoInstalacion WHERE IdTipoInstalacion = @IdTipoInstalacion) -- Revisar que el id ingresado exista
    BEGIN
        -- Verificar que el nombre que se vaya a agregar no este previamente registrado
        IF NOT EXISTS (SELECT 1 FROM TipoInstalacion WHERE NombreInstalacion = @NombreInstalacion AND IdTipoInstalacion <> @IdTipoInstalacion)-- IdTipoInstalacion <> @IdTipoInstalacion: Esto verifica en las tablas en donde ese id es diferente del actual
        BEGIN
            UPDATE TipoInstalacion
            SET NombreInstalacion = @NombreInstalacion
            WHERE IdTipoInstalacion = @IdTipoInstalacion;

            SET @Resultado = 1;  -- Éxito
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  -- Ya existe una instalacion con ese nombre.
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- No se encontro 
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarTipoInstalacion
    @IdTipoInstalacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Que una empresa no tenga esta instalacion en uso
    IF NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE IdTipoHotel = @IdTipoInstalacion)
    BEGIN
        DELETE FROM TipoInstalacion WHERE IdTipoInstalacion = @IdTipoInstalacion;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

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
    @Telefono VARCHAR(15),
    @Resultado SMALLINT OUTPUT -- Se añade para manejar errores
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que la empresa no exista y que el correo y teléfono sean únicos
    IF NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CedulaJuridica = @CedulaJuridica)
    AND NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CorreoElectronico = @CorreoElectronico)
    AND NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE Telefono = @Telefono)
    BEGIN
        INSERT INTO EmpresaHospedaje (CedulaJuridica, NombreHotel, IdTipoHotel, IdDireccion, ReferenciaGPS, CorreoElectronico, SitioWeb, Telefono)
        VALUES (@CedulaJuridica, @NombreHotel, @IdTipoHotel, @IdDireccion, @ReferenciaGPS, @CorreoElectronico, @SitioWeb, @Telefono);

        SET @Resultado = 1;  -- Exito
    END
    ELSE
    BEGIN
        SET @Resultado = -1; -- Empresa existente.
    END
END;


-- Editar
CREATE PROCEDURE sp_ActualizarEmpresaHospedaje
    @CedulaJuridica VARCHAR(15),
    @NombreHotel VARCHAR(50),
    @IdTipoHotel SMALLINT,
    @IdDireccion SMALLINT,
    @ReferenciaGPS GEOGRAPHY,
    @CorreoElectronico VARCHAR(50),
    @SitioWeb VARCHAR(50),
    @Telefono VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CedulaJuridica = @CedulaJuridica) -- revisar que la mepresa exista
    BEGIN
        -- revisar que el correo y el telefono no esten siendo usados.
        IF NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CorreoElectronico = @CorreoElectronico AND CedulaJuridica <> @CedulaJuridica)
        AND NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE Telefono = @Telefono AND CedulaJuridica <> @CedulaJuridica)
        BEGIN
            UPDATE EmpresaHospedaje
            SET NombreHotel = @NombreHotel,
                IdTipoHotel = @IdTipoHotel,
                IdDireccion = @IdDireccion,
                ReferenciaGPS = @ReferenciaGPS,
                CorreoElectronico = @CorreoElectronico,
                SitioWeb = @SitioWeb,
                Telefono = @Telefono
            WHERE CedulaJuridica = @CedulaJuridica;

            SET @Resultado = 1;  -- Exito
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  -- Correo o email registrados
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Empresa no registrada
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarEmpresaHospedaje
    @CedulaJuridica VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Revisar que la empresa no tenga facturaciones con reservas que aún no han salido
    IF NOT EXISTS (
        SELECT 1 FROM Facturacion F
        JOIN Reservacion R ON F.IdReservacion = R.IdReservacion
        JOIN HabitacionesEmpresa H ON R.IdHabitacion = H.IdHabitacion
        WHERE H.IdEmpresa = @CedulaJuridica AND R.FechaHoraSalida > GETDATE()
    )
    BEGIN
        DELETE FROM EmpresaHospedaje WHERE CedulaJuridica = @CedulaJuridica;
        SET @Resultado = 1;  -- Exito
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Hay reservas activas.
    END
END;


-- ========================== Para la tabla de ServiciosEstablecimiento:
-- Agregar
CREATE PROCEDURE sp_AgregarServicioEstablecimiento
    @NombreServicio VARCHAR(30),
    @NuevoIdServicio SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica si el servicio ya existe
    IF EXISTS (SELECT 1 FROM ServiciosEstablecimiento WHERE NombreServicio = @NombreServicio)
    BEGIN
        -- Si existe optenemos el id
        SELECT @NuevoIdServicio = IdServicio FROM ServiciosEstablecimiento WHERE NombreServicio = @NombreServicio;
    END
    ELSE
    BEGIN
        -- Si no existe registramos enl nuevo servicio
        INSERT INTO ServiciosEstablecimiento (NombreServicio)
        VALUES (@NombreServicio);

        -- Se devuleve el id de recien agregado.
        SET @NuevoIdServicio = SCOPE_IDENTITY();
    END
END;


-- Editar
CREATE PROCEDURE sp_ActualizarServicioEstablecimiento
    @IdServicio SMALLINT,
    @NombreServicio VARCHAR(30),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ServiciosEstablecimiento WHERE IdServicio = @IdServicio)
    BEGIN
        -- Verifica que no se repita el nombre antes de modificar 
        IF NOT EXISTS (SELECT 1 FROM ServiciosEstablecimiento WHERE NombreServicio = @NombreServicio AND IdServicio <> @IdServicio)
        BEGIN
            UPDATE ServiciosEstablecimiento
            SET NombreServicio = @NombreServicio
            WHERE IdServicio = @IdServicio;

            SET @Resultado = 1;  -- Exito
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  --Ya existe otro servicio con ese nombre
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  --  Servicio no encontrado
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarServicioEstablecimiento
    @IdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que el servicio no este en una asociacion
    IF NOT EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdServicio = @IdServicio)
    BEGIN
        DELETE FROM ServiciosEstablecimiento WHERE IdServicio = @IdServicio;
        SET @Resultado = 1;  -- Exito
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Servicio en uso en ListaServiciosHospedaje
    END
END;

-- ========================== Para la tabla de ListaServiciosHospedaje:
-- Agrgar un nuevo servicios a la lista de la empresa
CREATE PROCEDURE sp_AgregarListaServiciosHospedaje
    @IdEmpresa VARCHAR(15),
    @IdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT  -- Se agrega para manejar el retorno
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

        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Servicios ya asociado a la empresa
    END
END;


-- Editar
CREATE PROCEDURE sp_ActualizarListaServiciosHospedaje
    @IdEmpresa VARCHAR(15),
    @IdServicio SMALLINT,
    @NuevoIdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio)
    BEGIN
        -- Verifica que la empresa no tenga ya asignado el nuevo servicio antes de actualizar
        IF NOT EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @NuevoIdServicio)
        BEGIN
            UPDATE ListaServiciosHospedaje
            SET IdServicio = @NuevoIdServicio
            WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  -- ELa empresa ya tiene ese servicio
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Relacion empresa-servicio no encontrada
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarListaServiciosHospedaje
    @IdEmpresa VARCHAR(15),
    @IdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio)
    BEGIN
        DELETE FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio;
        SET @Resultado = 1;  -- Exito
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Error: Relacion no encontrada
    END
END;

-- ========================== Para la tabla de RedSocial:

-- Agregar nueva red social:
CREATE PROCEDURE sp_AgregarRedSocial
    @Nombre VARCHAR(20),
    @NuevoIdRedSocial SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica si la red social ya existe
    IF EXISTS (SELECT 1 FROM RedesSociales WHERE Nombre = @Nombre)
    BEGIN
        -- Obtiene el ID del registro existente
        SELECT @NuevoIdRedSocial = IdRedSocial FROM RedesSociales WHERE Nombre = @Nombre;
    END
    ELSE
    BEGIN
        -- Inserta la nueva red social
        INSERT INTO RedesSociales (Nombre)
        VALUES (@Nombre);

        -- Obtiene el ID recién creado
        SET @NuevoIdRedSocial = SCOPE_IDENTITY();
    END
END;



-- Editar
CREATE PROCEDURE sp_ActualizarRedSocial
    @IdRedSocial SMALLINT,
    @Nombre VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM RedesSociales WHERE IdRedSocial = @IdRedSocial)
    BEGIN
        -- Validar que el nuevo nombre no este repetido
        IF NOT EXISTS (SELECT 1 FROM RedesSociales WHERE Nombre = @Nombre AND IdRedSocial <> @IdRedSocial)
        BEGIN
            UPDATE RedesSociales
            SET Nombre = @Nombre
            WHERE IdRedSocial = @IdRedSocial;

            SET @Resultado = 1;  -- Éxito
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  --Ya existe otra red social con ese nombre
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Red social no encontrada
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarRedSocial
    @IdRedSocial SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que la red social no ester asociada
    IF NOT EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdRedSocial = @IdRedSocial)
    BEGIN
        DELETE FROM RedesSociales WHERE IdRedSocial = @IdRedSocial;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Error: La red social está en uso
    END
END;


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
CREATE PROCEDURE sp_ActualizarListaRedesSociales
    @IdEmpresa VARCHAR(15),
    @IdRedSocial SMALLINT,
    @NuevoEnlace VARCHAR(255),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial)
    BEGIN
        UPDATE ListaRedesSociales
        SET Enlace = @NuevoEnlace
        WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial;

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarListaRedesSociales
    @IdEmpresa VARCHAR(15),
    @IdRedSocial SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial)
    BEGIN
        DELETE FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- ========================== Para la tabla de TipoCama:

-- Agregar
CREATE PROCEDURE sp_AgregarTipoCama
    @NombreCama VARCHAR(20),
    @NuevoIdTipoCama SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM TipoCama WHERE NombreCama = @NombreCama)
    BEGIN

        SELECT @NuevoIdTipoCama = IdTipoCama FROM TipoCama WHERE NombreCama = @NombreCama;
    END
    ELSE
    BEGIN
        
        INSERT INTO TipoCama (NombreCama)
        VALUES (@NombreCama);

        SET @NuevoIdTipoCama = SCOPE_IDENTITY();
    END
END;


-- Editar
CREATE PROCEDURE sp_ActualizarTipoCama
    @IdTipoCama SMALLINT,
    @NombreCama VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM TipoCama WHERE IdTipoCama = @IdTipoCama)
    BEGIN
        -- Validar que el nuevo nombre no este repetido
        IF NOT EXISTS (SELECT 1 FROM TipoCama WHERE NombreCama = @NombreCama AND IdTipoCama <> @IdTipoCama)
        BEGIN
            UPDATE TipoCama
            SET NombreCama = @NombreCama
            WHERE IdTipoCama = @IdTipoCama;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarTipoCama
    @IdTipoCama SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que el tipo de cama no este en uso
    IF NOT EXISTS (SELECT 1 FROM TipoHabitacion WHERE IdTipoCama = @IdTipoCama)
    BEGIN
        DELETE FROM TipoCama WHERE IdTipoCama = @IdTipoCama;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

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

    INSERT INTO TipoHabitacion (Nombre, Descripcion, IdTipoCama, Precio)
    VALUES (@Nombre, @Descripcion, @IdTipoCama, @Precio);

    SET @NuevoIdTipoHabitacion = SCOPE_IDENTITY();
END;


-- Editar
CREATE PROCEDURE sp_ActualizarTipoHabitacion
    @IdTipoHabitacion SMALLINT,
    @Nombre VARCHAR(40),
    @Descripcion VARCHAR(150),
    @IdTipoCama SMALLINT,
    @Precio FLOAT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Solo se valida que el ID de la habitación exista antes de actualizar
    IF EXISTS (SELECT 1 FROM TipoHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion)
    BEGIN
        UPDATE TipoHabitacion
        SET Nombre = @Nombre,
            Descripcion = @Descripcion,
            IdTipoCama = @IdTipoCama,
            Precio = @Precio
        WHERE IdTipoHabitacion = @IdTipoHabitacion;

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;


-- CREATE PROCEDURE sp_ActualizarTipoHabitacion
--     @IdTipoHabitacion SMALLINT,
--     @Nombre VARCHAR(40),
--     @Descripcion VARCHAR(150),
--     @IdTipoCama SMALLINT,
--     @Precio FLOAT,
--     @Resultado SMALLINT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     IF EXISTS (SELECT 1 FROM TipoHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion)
--     BEGIN
--         -- Validar que el nuevo nombre no este repetido
--         IF NOT EXISTS (SELECT 1 FROM TipoHabitacion WHERE Nombre = @Nombre AND IdTipoHabitacion <> @IdTipoHabitacion)
--         BEGIN
--             UPDATE TipoHabitacion
--             SET Nombre = @Nombre,
--                 Descripcion = @Descripcion,
--                 IdTipoCama = @IdTipoCama,
--                 Precio = @Precio
--             WHERE IdTipoHabitacion = @IdTipoHabitacion;

--             SET @Resultado = 1;  
--         END
--         ELSE
--         BEGIN
--             SET @Resultado = -2;  
--         END
--     END
--     ELSE
--     BEGIN
--         SET @Resultado = -1;  
--     END
-- END;

-- Eliminar: (Aparte de que no este en datoshabitacion, se debe de validar que solo la empresa a la que le pertenece, pueda eliminarla.)
CREATE PROCEDURE sp_EliminarTipoHabitacion
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15), 
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que el tipo de habitacion no este en y que la empresa dueña sea la que lo elimina
    IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion)
    AND EXISTS (SELECT 1 FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa)
    BEGIN
        DELETE FROM TipoHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;


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

-- Editar (Para este, no se deberia de usar, lo mejor seria eliminar la imagen y registrar una nueva, en la ventana, solo se mostran las opciones de agregar o eliminar la imagen)
CREATE PROCEDURE sp_ActualizarFoto
    @IdImagen SMALLINT,
    @Imagen VARBINARY(MAX),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Fotos WHERE IdImagen = @IdImagen)
    BEGIN
        UPDATE Fotos
        SET Imagen = @Imagen
        WHERE IdImagen = @IdImagen;

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarFoto
    @IdImagen SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Fotos WHERE IdImagen = @IdImagen)
    BEGIN
        DELETE FROM Fotos WHERE IdImagen = @IdImagen;
        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;


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
CREATE PROCEDURE sp_ActualizarDatosHabitacion
    @IdDatosHabitacion SMALLINT,
    @Numero TINYINT,
    @IdTipoHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdDatosHabitacion = @IdDatosHabitacion)
    BEGIN
        -- Validar que el numero de habitacion no este repetido en la misma empresa
        IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion AND Numero = @Numero AND IdDatosHabitacion <> @IdDatosHabitacion)
        BEGIN
            UPDATE DatosHabitacion
            SET Numero = @Numero,
                IdTipoHabitacion = @IdTipoHabitacion
            WHERE IdDatosHabitacion = @IdDatosHabitacion;

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarDatosHabitacion
    @IdDatosHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que la habitación no tenga reservas activas (fecha de salida > hoy)
    IF NOT EXISTS (
        SELECT 1 FROM Reservacion WHERE IdHabitacion = @IdDatosHabitacion AND FechaHoraSalida > GETDATE()
    )
    BEGIN
        DELETE FROM DatosHabitacion WHERE IdDatosHabitacion = @IdDatosHabitacion;
        SET @Resultado = 1;  -- Éxito
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Error: Habitación aún tiene reservas activas
    END
END;

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
CREATE PROCEDURE sp_ActualizarHabitacionesEmpresa
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @NuevoIdHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion)
    BEGIN
        -- Verifica que la empresa no tenga ya asignada la nueva habitacion antes de actualizar
        IF NOT EXISTS (SELECT 1 FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @NuevoIdHabitacion)
        BEGIN
            UPDATE HabitacionesEmpresa
            SET IdHabitacion = @NuevoIdHabitacion
            WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -2; 
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarHabitacionesEmpresa
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que la habitación ya no exista en el sistema
    IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdDatosHabitacion = @IdHabitacion)
    BEGIN
        DELETE FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion;
        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- ========================== Para la tabla de TipoHabitacionesEmpresa:

-- Agregar la asociacion entre las tiposhabitacion y la empresa.
CREATE PROCEDURE sp_AgregarTipoHabitacionEmpresa
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa
    )
    BEGIN
        INSERT INTO TipoHabitacionEmpresa (IdTipoHabitacion, IdEmpresa)
        VALUES (@IdTipoHabitacion, @IdEmpresa);

        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Editar
CREATE PROCEDURE sp_ActualizarTipoHabitacionEmpresa
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @NuevoIdTipoHabitacion SMALLINT,
    @NuevoIdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    
    IF EXISTS (
        SELECT 1 FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa
    )
    BEGIN
        UPDATE TipoHabitacionEmpresa
        SET IdTipoHabitacion = @NuevoIdTipoHabitacion,
            IdEmpresa = @NuevoIdEmpresa
        WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa;

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;


-- Eliminar:
CREATE PROCEDURE sp_EliminarTipoHabitacionEmpresa
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion)
    BEGIN
        DELETE FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;


-- ========================== Para la tabla de Comodidad:

-- Agregar
CREATE PROCEDURE sp_AgregarComodidad
    @Nombre VARCHAR(20),
    @NuevoIdComodidad SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @NuevoIdComodidad = IdComodidad FROM Comodidad WHERE Nombre = @Nombre;


    IF @NuevoIdComodidad IS NULL
    BEGIN
        INSERT INTO Comodidad (Nombre)
        VALUES (@Nombre);

        SET @NuevoIdComodidad = SCOPE_IDENTITY();
    END
END;


-- Editar
CREATE PROCEDURE sp_ActualizarComodidad
    @IdComodidad SMALLINT,
    @Nombre VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Comodidad WHERE IdComodidad = @IdComodidad)
    BEGIN
        -- Validar que el nuevo nombre no este repetido
        IF NOT EXISTS (SELECT 1 FROM Comodidad WHERE Nombre = @Nombre AND IdComodidad <> @IdComodidad)
        BEGIN
            UPDATE Comodidad
            SET Nombre = @Nombre
            WHERE IdComodidad = @IdComodidad;

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarComodidad
    @IdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    --
    IF NOT EXISTS (SELECT 1 FROM ListaComodidades WHERE IdComodidad = @IdComodidad)
    BEGIN
        DELETE FROM Comodidad WHERE IdComodidad = @IdComodidad;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

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
CREATE PROCEDURE sp_ActualizarListaComodidades
    @IdTipoHabitacion SMALLINT,
    @IdComodidad SMALLINT,
    @NuevoIdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @NuevoIdComodidad)
        BEGIN
            UPDATE ListaComodidades
            SET IdComodidad = @NuevoIdComodidad
            WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -2; 
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarListaComodidades
    @IdTipoHabitacion SMALLINT,
    @IdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad)
    BEGIN
        DELETE FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;

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
CREATE PROCEDURE sp_ActualizarCliente
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

    IF EXISTS (SELECT 1 FROM Cliente WHERE Cedula = @Cedula)
    BEGIN
        UPDATE Cliente
        SET NombreCompleto = @NombreCompleto,
            TipoIdentificacion = @TipoIdentificacion,
            PaisResidencia = @PaisResidencia,
            FechaNacimiento = @FechaNacimiento,
            IdDireccion = @IdDireccion
        WHERE Cedula = @Cedula;

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;


-- Eliminar:
CREATE PROCEDURE sp_EliminarCliente
    @Cedula VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que el cliente no tenga reservas activas
    IF NOT EXISTS (SELECT 1 FROM Reservacion WHERE IdCliente = @Cedula AND FechaHoraSalida > GETDATE())
    BEGIN
        DELETE FROM Cliente WHERE Cedula = @Cedula;
        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

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

    -- Verifica que el cliente no tenga mas de 3 números registrados
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

-- Editar ()
CREATE PROCEDURE sp_ActualizarTelefono
    @IdTelefono SMALLINT,
    @CodigoPais VARCHAR(5),
    @NumeroTelefonico VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Telefono WHERE IdTelefono = @IdTelefono)
    BEGIN

        IF NOT EXISTS (SELECT 1 FROM Telefono WHERE NumeroTelefonico = @NumeroTelefonico AND IdTelefono <> @IdTelefono)
        BEGIN
            UPDATE Telefono
            SET CodigoPais = @CodigoPais,
                NumeroTelefonico = @NumeroTelefonico
            WHERE IdTelefono = @IdTelefono;

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarTelefono
    @IdTelefono SMALLINT,
    @IdUsuario VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que el teléfono pertenece al usuario y que al menos quede uno registrado
    IF EXISTS (SELECT 1 FROM Telefono WHERE IdTelefono = @IdTelefono AND IdUsuario = @IdUsuario)
    AND (SELECT COUNT(*) FROM Telefono WHERE IdUsuario = @IdUsuario) > 1
    BEGIN
        DELETE FROM Telefono WHERE IdTelefono = @IdTelefono;
        SET @Resultado = 1;  -
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- ========================== Para la tabla de Reservacion:

-- Agregar (Este deveria de verificar que en el rango de fechas indicado no se haya reservado anteriormente esa habitacion.)
CREATE PROCEDURE sp_AgregarReservacion
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

    -- revisar que la fecha de salida sea mayor a la de ingreso
    IF @FechaHoraSalida > @FechaHoraIngreso
    BEGIN
        -- Revisar si el rango de fechas ingresado no cheque con alguna otra reserva.
        IF NOT EXISTS (
            SELECT 1 FROM Reservacion
            WHERE IdHabitacion = @IdHabitacion
            AND (
                (@FechaHoraIngreso BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                (@FechaHoraSalida BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                (FechaHoraIngreso BETWEEN @FechaHoraIngreso AND @FechaHoraSalida) OR
                (FechaHoraSalida BETWEEN @FechaHoraIngreso AND @FechaHoraSalida)
            )
        )
        BEGIN
            -- Registrar la reservacion
            INSERT INTO Reservacion (IdCliente, IdHabitacion, FechaHoraIngreso, FechaHoraSalida, CantidadPersonas, Vehiculo)
            VALUES (@IdCliente, @IdHabitacion, @FechaHoraIngreso, @FechaHoraSalida, @CantidadPersonas, @Vehiculo);

            SET @NuevoIdReservacion = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SET @NuevoIdReservacion = -2;  --  La habitacon ya esta reservada en este rango de fechas
        END
    END
    ELSE
    BEGIN
        SET @NuevoIdReservacion = -1; -- Fecha de salida menor a la de entrada.
    END
END;


-- Editar
CREATE PROCEDURE sp_ActualizarReservacion
    @IdReservacion SMALLINT,
    @IdCliente VARCHAR(15),
    @IdHabitacion SMALLINT,
    @FechaHoraIngreso DATETIME,
    @FechaHoraSalida DATETIME,
    @CantidadPersonas TINYINT,
    @Vehiculo VARCHAR(2),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Reservacion WHERE IdReservacion = @IdReservacion)
    BEGIN
        -- Validar que la fecha de salida sea mayor a la fecha de ingreso
        IF @FechaHoraSalida > @FechaHoraIngreso
        BEGIN
            -- Verificar si existe una reservación que choque en el rango de fechas, sin incluir el registro actual
            IF NOT EXISTS (
                SELECT 1 FROM Reservacion
                WHERE IdHabitacion = @IdHabitacion
                AND IdReservacion <> @IdReservacion
                AND (
                    (@FechaHoraIngreso BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                    (@FechaHoraSalida BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                    (FechaHoraIngreso BETWEEN @FechaHoraIngreso AND @FechaHoraSalida) OR
                    (FechaHoraSalida BETWEEN @FechaHoraIngreso AND @FechaHoraSalida)
                )
            )
            BEGIN
                UPDATE Reservacion
                SET IdCliente = @IdCliente,
                    IdHabitacion = @IdHabitacion,
                    FechaHoraIngreso = @FechaHoraIngreso,
                    FechaHoraSalida = @FechaHoraSalida,
                    CantidadPersonas = @CantidadPersonas,
                    Vehiculo = @Vehiculo
                WHERE IdReservacion = @IdReservacion;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -3;  -- La habitación ya esta reservada en este rango de fechas
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -2; -- Fecha de salida menor a la de ingreso
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;


-- Eliminar:
CREATE PROCEDURE sp_EliminarReservacion
    @IdReservacion SMALLINT,
    @IdCliente VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que la reservación no esté facturada y que el cliente sea el dueño
    IF NOT EXISTS (SELECT 1 FROM Facturacion WHERE IdReservacion = @IdReservacion)
    AND EXISTS (SELECT 1 FROM Reservacion WHERE IdReservacion = @IdReservacion AND IdCliente = @IdCliente)
    BEGIN
        DELETE FROM Reservacion WHERE IdReservacion = @IdReservacion;
        SET @Resultado = 1;  -- Éxito
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Error: Reservación facturada o cliente incorrecto
    END
END;

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
CREATE PROCEDURE sp_ActualizarFacturacion
    @IdFacturacion SMALLINT,
    @MetodoPago VARCHAR(10),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Facturacion WHERE IdFacturacion = @IdFacturacion)
    BEGIN
        UPDATE Facturacion
        SET MetodoPago = @MetodoPago
        WHERE IdFacturacion = @IdFacturacion;

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarFacturacion
    @IdFacturacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que la empresa sea la dueña de la habitación facturada
    IF EXISTS (
        SELECT 1 FROM Facturacion F
        JOIN Reservacion R ON F.IdReservacion = R.IdReservacion
        JOIN HabitacionesEmpresa H ON R.IdHabitacion = H.IdHabitacion
        WHERE F.IdFacturacion = @IdFacturacion AND H.IdEmpresa = @IdEmpresa
    )
    BEGIN
        DELETE FROM Facturacion WHERE IdFacturacion = @IdFacturacion;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;

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

        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Editar
CREATE PROCEDURE sp_ActualizarEmpresaRecreacion
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

    IF EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica)
    BEGIN
        
        IF NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CorreoElectronico = @CorreoElectronico AND CedulaJuridica <> @CedulaJuridica)
        AND NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE Telefono = @Telefono AND CedulaJuridica <> @CedulaJuridica)
        BEGIN
            UPDATE EmpresaRecreacion
            SET NombreEmpresa = @NombreEmpresa,
                CorreoElectronico = @CorreoElectronico,
                PersonaAContactar = @PersonaAContactar,
                IdDireccion = @IdDireccion,
                Telefono = @Telefono
            WHERE CedulaJuridica = @CedulaJuridica;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarEmpresaRecreacion
    @CedulaJuridica VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica)
    BEGIN
        DELETE FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica;
        SET @Resultado = 1;  -- Éxito
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- Error: Empresa no encontrada
    END
END;

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

    SELECT @NuevoIdServicio = IdServicio FROM ServiciosRecreacion 
    WHERE IdEmpresa = @IdEmpresa AND NombreServicio = @NombreServicio;

    IF @NuevoIdServicio IS NULL
    BEGIN
        INSERT INTO ServiciosRecreacion (IdEmpresa, NombreServicio, Precio)
        VALUES (@IdEmpresa, @NombreServicio, @Precio);

        SET @NuevoIdServicio = SCOPE_IDENTITY();
    END
END;


-- Editar
CREATE PROCEDURE sp_ActualizarServiciosRecreacion
    @IdServicio SMALLINT,
    @NombreServicio VARCHAR(30),
    @Precio FLOAT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ServiciosRecreacion WHERE IdServicio = @IdServicio)
    BEGIN
       
        IF NOT EXISTS (SELECT 1 FROM ServiciosRecreacion WHERE NombreServicio = @NombreServicio AND IdServicio <> @IdServicio)
        BEGIN
            UPDATE ServiciosRecreacion
            SET NombreServicio = @NombreServicio,
                Precio = @Precio
            WHERE IdServicio = @IdServicio;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarServiciosRecreacion
    @IdServicio SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    
    IF EXISTS (SELECT 1 FROM ServiciosRecreacion WHERE IdServicio = @IdServicio AND IdEmpresa = @IdEmpresa)
    BEGIN
        DELETE FROM ServiciosRecreacion WHERE IdServicio = @IdServicio;
        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  -- 
    END
END;

-- ========================== Para la tabla de Actividad:

-- Agregar 
CREATE PROCEDURE sp_AgregarActividad
    @IdEmpresa VARCHAR(15),
    @NombreActividad VARCHAR(30),
    @DescripcionActividad VARCHAR(100),
    @NuevoIdActividad SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @NuevoIdActividad = IdActividad FROM Actividad 
    WHERE IdEmpresa = @IdEmpresa AND NombreActividad = @NombreActividad;

    IF @NuevoIdActividad IS NULL
    BEGIN
        INSERT INTO Actividad (IdEmpresa, NombreActividad, DescripcionActividad)
        VALUES (@IdEmpresa, @NombreActividad, @DescripcionActividad);

        SET @NuevoIdActividad = SCOPE_IDENTITY();
    END
END;


-- Editar (Deberia de guardar el id de la empresa que lo crea)
CREATE PROCEDURE sp_ActualizarActividad
    @IdActividad SMALLINT,
    @IdEmpresa VARCHAR(15),
    @NombreActividad VARCHAR(30),
    @DescripcionActividad VARCHAR(100),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Actividad WHERE IdActividad = @IdActividad AND IdEmpresa = @IdEmpresa)
    BEGIN
       
        IF NOT EXISTS (SELECT 1 FROM Actividad WHERE IdEmpresa = @IdEmpresa AND NombreActividad = @NombreActividad AND IdActividad <> @IdActividad)
        BEGIN
            UPDATE Actividad
            SET NombreActividad = @NombreActividad,
                DescripcionActividad = @DescripcionActividad
            WHERE IdActividad = @IdActividad;

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -2; 
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;


-- Eliminar:
CREATE PROCEDURE sp_EliminarActividad
    @IdActividad SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ListaActividades WHERE IdActividad = @IdActividad)
    AND EXISTS (SELECT 1 FROM Actividad WHERE IdActividad = @IdActividad AND IdEmpresa = @IdEmpresa)
    BEGIN
        DELETE FROM Actividad WHERE IdActividad = @IdActividad;
        SET @Resultado = 1; 
    END
    ELSE
    BEGIN
        SET @Resultado = -1; 
    END
END;


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
CREATE PROCEDURE sp_ActualizarListaActividades
    @IdServicio SMALLINT,
    @IdActividad SMALLINT,
    @NuevoIdActividad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad)
    BEGIN
   
        IF NOT EXISTS (SELECT 1 FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @NuevoIdActividad)
        BEGIN
            UPDATE ListaActividades
            SET IdActividad = @NuevoIdActividad
            WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -2; 
        END
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- Eliminar:
CREATE PROCEDURE sp_EliminarListaActividades
    @IdServicio SMALLINT,
    @IdActividad SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM ListaActividades L
        JOIN ServiciosRecreacion S ON L.IdServicio = S.IdServicio
        WHERE L.IdServicio = @IdServicio AND L.IdActividad = @IdActividad AND S.IdEmpresa = @IdEmpresa
    )
    BEGIN
        DELETE FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad;
        SET @Resultado = 1;  
    END
    ELSE
    BEGIN
        SET @Resultado = -1;  
    END
END;

-- ========================== Para la tabla de :

-- Agregar

-- Editar

-- Eliminar:


-- ========================== Para la tabla de :

-- Agregar

-- Editar

-- Eliminar:




-- y otro en caso de una busqueda general en donde no se especifique el si es empresa de hospedaje o de recreacion,

-- - Busqueda general: 
-- ========================== PApartado de busquedas =========================:

-- >>> +++++++++++++++++++++ Clientes +++++++++++++++++++++++++++++++++++
-->> Buscar empresas:
-- > Hospedaje:
CREATE PROCEDURE sp_BuscarEmpresasHospedaje -- Recibimos todos los datos que se podrian usar.
    @NombreHotel VARCHAR(50) = NULL,
    @IdTipoHotel SMALLINT = NULL,
    @ReferenciaGPS GEOGRAPHY = NULL,
    @ListaServicios VARCHAR(MAX) = NULL,
    @Provincia VARCHAR(20) = NULL,
    @Canton VARCHAR(30) = NULL,
    @Distrito VARCHAR(30) = NULL,
    @Barrio VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ServiciosFiltrados TABLE (IdServicio SMALLINT);

    -- Convertir la lista de servicios en una tabla
    IF @ListaServicios IS NOT NULL
    BEGIN
        INSERT INTO @ServiciosFiltrados
        SELECT VALUE FROM STRING_SPLIT(@ListaServicios, ',');
    END;

    SELECT DISTINCT E.*
    FROM EmpresaHospedaje E
    JOIN Direccion D ON E.IdDireccion = D.IdDireccion
    LEFT JOIN ListaServiciosHospedaje LS ON E.CedulaJuridica = LS.IdEmpresa
    LEFT JOIN ServiciosEstablecimiento SE ON LS.IdServicio = SE.IdServicio

    WHERE (@NombreHotel IS NULL OR E.NombreHotel LIKE '%' + @NombreHotel + '%')
    AND (@IdTipoHotel IS NULL OR E.IdTipoHotel = @IdTipoHotel)
    AND (@ReferenciaGPS IS NULL OR E.ReferenciaGPS = @ReferenciaGPS)
    AND (@ListaServicios IS NULL OR LS.IdServicio IN (SELECT IdServicio FROM @ServiciosFiltrados))
    AND (@Provincia IS NULL OR D.Provincia = @Provincia)
    AND (@Canton IS NULL OR D.Canton = @Canton)
    AND (@Distrito IS NULL OR D.Distrito = @Distrito)
    AND (@Barrio IS NULL OR D.Barrio = @Barrio); -- Realizamos la busqueda de coincidencias, en donde los valores no sean nulos.
    -- En caso de ser nulo, significa que ese filtro no se uso.
END;



-- Recreacion: 
CREATE PROCEDURE sp_BuscarEmpresasRecreacion
    @NombreEmpresa VARCHAR(50) = NULL,
    @NombreServicio VARCHAR(30) = NULL,
    @ListaActividades VARCHAR(MAX) = NULL,
    @Provincia VARCHAR(20) = NULL,
    @Canton VARCHAR(30) = NULL,
    @Distrito VARCHAR(30) = NULL,
    @Barrio VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ActividadesFiltradas TABLE (IdActividad SMALLINT);
    
    -- Convertir la lista de actividades separadas por comas en una tabla
    IF @ListaActividades IS NOT NULL
    BEGIN
        INSERT INTO @ActividadesFiltradas
        SELECT value FROM STRING_SPLIT(@ListaActividades, ',');
    END;

    SELECT DISTINCT E.*
    FROM EmpresaRecreacion E
    JOIN Direccion E ON E.IdDireccion = D.IdDireccion
    LEFT JOIN ServiciosRecreacion S ON E.CedulaJuridica = S.IdEmpresa
    LEFT JOIN ListaActividades A ON S.IdServicio = A.IdServicio
    WHERE (@NombreEmpresa IS NULL OR E.NombreEmpresa LIKE '%' + @NombreEmpresa + '%')
    AND (@NombreServicio IS NULL OR S.NombreServicio LIKE '%' + @NombreServicio + '%')
    AND (@ListaActividades IS NULL OR L.IdActividad IN (SELECT IdActividad FROM @ActividadesFiltradas))
    AND (@Provincia IS NULL OR D.Provincia = @Provincia)
    AND (@Canton IS NULL OR D.Canton = @Canton)
    AND (@Distrito IS NULL OR D.Distrito = @Distrito)
    AND (@Barrio IS NULL OR D.Barrio = @Barrio);
END;


-- >>> Buscar habitaciones:
CREATE PROCEDURE sp_BuscarHabitaciones
    @NombreTipoHabitacion VARCHAR(40) = NULL,
    @FechaEntrada DATETIME = NULL,
    @FechaSalida DATETIME = NULL,
    @IdTipoCama SMALLINT = NULL,
    @ListaComodidades VARCHAR(MAX) = NULL,
    @PrecioMin FLOAT = NULL,
    @PrecioMax FLOAT = NULL,
    @Provincia VARCHAR(20) = NULL,
    @Canton VARCHAR(30) = NULL,
    @Distrito VARCHAR(30) = NULL,
    @Barrio VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ComodidadesFiltradas TABLE (IdComodidad SMALLINT);
    
    -- Convertir lista de comodidades separadas por comas en unWa tabla
    IF @ListaComodidades IS NOT NULL
    BEGIN
        INSERT INTO @ComodidadesFiltradas
        SELECT value FROM STRING_SPLIT(@ListaComodidades, ',');
    END;

    SELECT DISTINCT H.*
    FROM DatosHabitacion H
    JOIN TipoHabitacion TH ON H.IdTipoHabitacion = TH.IdTipoHabitacion
    JOIN TipoCama TC ON TH.IdTipoCama = TC.IdTipoCama
    JOIN EmpresaHospedaje E ON TH.IdTipoHabitacion = E.IdTipoHotel
    JOIN Direccion D ON E.IdDireccion = D.IdDireccion
    LEFT JOIN ListaComodidades LC ON TH.IdTipoHabitacion = LC.IdTipoHabitacion
    LEFT JOIN Reservacion R ON H.IdDatosHabitacion = R.IdHabitacion

    WHERE (@NombreTipoHabitacion IS NULL OR TH.Nombre LIKE '%' + @NombreTipoHabitacion + '%')
    AND (@IdTipoCama IS NULL OR TH.IdTipoCama = @IdTipoCama)
    AND (@ListaComodidades IS NULL OR LC.IdComodidad IN (SELECT IdComodidad FROM @ComodidadesFiltradas))
    AND (@PrecioMin IS NULL OR TH.Precio >= @PrecioMin)
    AND (@PrecioMax IS NULL OR TH.Precio <= @PrecioMax)
    AND (@Provincia IS NULL OR D.Provincia = @Provincia)
    AND (@Canton IS NULL OR D.Canton = @Canton)
    AND (@Distrito IS NULL OR D.Distrito = @Distrito)
    AND (@Barrio IS NULL OR D.Barrio = @Barrio)

    -- Revisar que las habitaciones esten disponibles en el rango de fechas seleccionado.
    AND (@FechaEntrada IS NULL OR NOT EXISTS (
        SELECT 1 FROM Reservacion R2 WHERE R2.IdHabitacion = H.IdDatosHabitacion
        AND (
            (@FechaEntrada BETWEEN R2.FechaHoraIngreso AND R2.FechaHoraSalida) OR
            (@FechaSalida BETWEEN R2.FechaHoraIngreso AND R2.FechaHoraSalida) OR
            (R2.FechaHoraIngreso BETWEEN @FechaEntrada AND @FechaSalida) OR
            (R2.FechaHoraSalida BETWEEN @FechaEntrada AND @FechaSalida)
        )
    ));
END;
