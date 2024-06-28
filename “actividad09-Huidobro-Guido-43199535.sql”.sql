create schema if not exists farmacia;
show schemas;
use farmacia;
select schema();

create table obra_social(
codigo int primary key,
nombre varchar ( 45 ) not null,
descripcion varchar ( 100 ) not null
);

insert into obra_social
values ( 1 , "PAMI" , "Programa de Atención Médica Integral" );
insert into obra_social ( codigo , nombre , descripcion)
values ( 2 , "IOMA" , "Instituto de Obra Medico Asistencial" );
insert into obra_social ( codigo , nombre , descripcion)
values ( 3 , "OSECAC" , "Obra Social de Empleados de Comercio" );
select * from obra_social;

-- Creamos las tablas provincia,localidad y calle en el esquema activo:
create table provincia(
	idprovincia int primary key,
	nombre varchar(45) not null
    );
    create table localidad(
	idlocalidad int primary key,
	nombre varchar(45) not null
    );
    create table calle(
	idcalle int primary key,
	nombre varchar(45) not null
    );
    
    -- Eliminamos las tablas
   drop table provincia;
   drop table localidad;
   drop table calle;

 -- Volvemos a crearlas
 create table provincia(
	idprovincia int primary key,
	nombre varchar(45) not null
    );
    create table localidad(
	idlocalidad int primary key,
	nombre varchar(45) not null
    );
    create table calle(
	idcalle int primary key,
	nombre varchar(45) not null
    );
    -- Cambiamos el nombre de las tablas y volvemos al nombre original
    alter table provincia rename to provinciaa;
    alter table provinciaa rename to provincia;
    alter table localidad rename to localidadd;
    alter table localidadd rename to localidad;
    alter table calle rename to callee;
    alter table callee rename to calle;
    
    -- Cambiamos el nombre de alguna columna y volvemos a cambiarlo al original
    alter table provincia change column nombre identificacion varchar(45);
    alter table provincia change column identificacion nombre varchar(45);
    alter table localidad change column idlocalidad localidadid varchar(45);
    alter table localidad change column localidadid idlocalidad varchar(45);
    alter table calle change column nombre identificacion varchar(45);
    alter table calle change column identificacion nombre varchar(45);
    
    -- Agregamos Datos
    
    insert into provincia
values(1,"Buenos Aires");
 insert into provincia
values(2,"CABA");
 insert into localidad
values(1,"Lanus");
insert into localidad
values(2,"Pompeya");
insert into localidad
values(3,"Avellaneda");
insert into calle
values(1,"9 de julio");
insert into calle
values(2,"Hipolito Yrigoyen");
insert into calle
values(3,"Mitre");
insert into calle
values(4,"Saenz");
    
-- Consultamos los registros ingresados

select * from provincia;
select * from localidad;
select * from calle;

-- Creamos la tabla cliente

create table cliente(
dni int primary key,
apellido varchar(45) not null,
nombre varchar(45)not null,
calle_idcalle int not null,
localidad_idlocalidad int not null,
provincia_idprovincia int not null,
numero_calle int not null,
foreign key (calle_idcalle) references calle(idcalle),
foreign key (localidad_idlocalidad) references
localidad(idlocalidad),
foreign key (provincia_idprovincia) references
provincia(idprovincia)
);


insert into cliente values(12345678, "Belgrano", "Manuel", 1,1,1,2345);
insert into cliente values(23456789, "Saavedra", "Cornelio",1,1,1,1234);
insert into cliente values(44444444, "Moreno", "Mariano", 3,3,1,3333);
insert into cliente values(33333333, "Larrea", "Juan", 4,2,2,2345);
insert into cliente values(22222222, "Moreno", "Manuel", 4,2,2,7777);

select * from cliente; -- todos los clientes

select dni,apellido from cliente; -- solo dni y apellido

-- Consultamos registros por dni:
select apellido,nombre from cliente where dni=12345678;

-- Consultamos registros por apellido:
select * from cliente where cliente.apellido="Saavedra";

-- Consultamos clientes de la calle 9 de julio
select * from cliente where calle_idcalle=1;

-- Consultamos clientes de la calle 9 de Julio con el número 2345
select * from cliente where calle_idcalle=1 and numero_calle=2345;

-- Consultamos clientes que vivan en la calle 9 de Julio o en la calle Mitre
select * from cliente where calle_idcalle=1 or calle_idcalle=3;

create table cliente_tiene_obra_social(
cliente_dni int primary key,
obra_social_codigo int not null,
nro_afiliado int not null,
foreign key (cliente_dni) references cliente(dni),
foreign key (obra_social_codigo) references obra_social(codigo)
);

-- Insertamos datos en la tabla. El cliente Cornelio Saavedra no tiene
-- obra social, por ello no existe un registro con su dni en la misma
insert into cliente_tiene_obra_social values (22222222, 2, 11223344);
insert into cliente_tiene_obra_social values (33333333, 2, 33445566);
insert into cliente_tiene_obra_social values (44444444, 2, 12356987);
insert into cliente_tiene_obra_social values (12345678, 1, 87654321);

-- Consultamos todos los clientes con su calle usando alias de tabla
-- Inner join: todos los registros de una tabla con correlato en la otra
select c.dni, c.apellido, c.nombre, ca.nombre, c.numero_calle from cliente c inner join calle ca on c.calle_idcalle=ca.idcalle;

-- inner join con filtro por nombre de localidad
select c.dni, c.apellido, c.nombre, l.nombre as Localidad from cliente c inner join localidad l on c.localidad_idlocalidad=l.idlocalidad where l.nombre="Avellaneda";

-- Left join: Todos los registros de la izquierda y sólo los de la
-- derecha que participan en la relación.
select ca.nombre as calle, dni, apellido, c.nombre from calle ca left join cliente c on ca.idcalle=c.calle_idcalle;

-- Right join: Todos los registros de la derecha y los de la izquierda que
-- participan en la relación.
select cos.nro_afiliado, dni, apellido, c.nombre
from cliente_tiene_obra_social cos right join cliente c on c.dni=cos.cliente_dni;

-- Vemos como un right join se puede escribir como un left join y
-- viceversa. Esta consulta es similar a la anterior
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni;

-- Traemos a los clientes sin obra social
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni where isnull(cos.nro_afiliado);

-- Traemos a los clientes con obra social
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni where not isnull(cos.nro_afiliado);

-- Clientes que poseen la obra social IOMA
select c.dni, c.apellido, c.nombre, o.nombre
from cliente c
inner join cliente_tiene_obra_social co on c.dni=co.cliente_dni
inner join obra_social o on co.obra_social_codigo=o.codigo
where o.nombre="IOMA";

create table laboratorio(
codigo int primary key,
nombre varchar(45) not null
);

insert into laboratorio values(1, "Bayer");
insert into laboratorio values(2, "Roemmers");
insert into laboratorio values(3, "Farma");
insert into laboratorio values(4, "Elea");

create table producto(
codigo int primary key,
nombre varchar(45) not null,
descripcion varchar(45) not null,
precio int not null,
laboratorio_codigo int not null,
foreign key(codigo_laboratorio) references laboratorio(codigo)
);

insert into producto values(1, 'Bayaspirina', 'Aspirina por tira de 10 unidades', 10, 1);
insert into producto values(2, 'Ibuprofeno', 'Ibuprofeno por tira de 6 unidades', 20, 3);
insert into producto values(3, 'Amoxidal 500', 'Antibiótico de amplio espectro', 300, 2);
insert into producto values(4, 'Redoxon', 'Complemento vitamínico', 120, '1');
insert into producto values(5, 'Atomo', 'Crema desinflamante', 90, 3);

create table venta(
numero int primary key,
fecha varchar(45) not null,
cliente_dni int not null
);

insert into venta values(1, '200820', 12345678);
insert into venta values(2, '200820', 33333333);
insert into venta values(3, '200822', 22222222);
insert into venta values(4, '200822', 44444444);
insert into venta values (5, '200822', 22222222);
insert into venta values(6, '200823', 12345678);

-- consultamos todas las ventas
select v.numero,v.fecha,c.nombre,c.apellido from venta v inner join cliente c ON v.cliente_dni = c.dni;

-- igual que la anterior,pero que traiga solo las del cliente con dni 12345678
select v.numero,v.fecha,c.nombre,c.apellido from venta v inner join cliente c ON v.cliente_dni = c.dni where dni = '12345678';

-- Todos (pero todos) los clientes con sus ventas
select v.numero,v.fecha,c.nombre,c.apellido from venta v inner join cliente c ;

-- todos los laboratorios
select * from laboratorio;

-- Todos los productos, indicando a que laboratorio pertencen
select p.codigo, p.descripcion,p.nombre,p.precio, lab.nombre from laboratorio lab inner join producto p ON p.laboratorio_codigo= lab.codigo;

-- Todos (pero todos) los laboratorios con los productos que elaboran
select lab.nombre,p.nombre,p.descripcion from laboratorio lab inner join producto p;

create table detalle_venta(
venta_numero int,
producto_codigo int,
precio_unitario decimal(10,2),
cantidad int,
primary key (venta_numero, producto_codigo),
foreign key (venta_numero) references venta(numero),
foreign key (producto_codigo) references producto(codigo)
);
-- venta_numero, producto_codigo, precio_unitario, cantidad
insert into detalle_venta values(1, 2, 20.00, 3); 
insert into detalle_venta values(1, 3, 300.00, 1);
insert into detalle_venta values(2, 1, 10.00, 2);
insert into detalle_venta values(2, 4, 120.00, 1);
insert into detalle_venta values(3, 2, 20.00, 3);
insert into detalle_venta values(3, 5, 90.00, 2);
insert into detalle_venta values(4, 2, 20.00, 2);
insert into detalle_venta values(5, 1, 8.00, 4);
insert into detalle_venta values(5, 5, 70.00, 1);
insert into detalle_venta values(6, 2, 20.00, 2);
insert into detalle_venta values(6, 3, 300.00, 1);
insert into detalle_venta values(6, 4, 120.00, 1);


-- Total facturado para un ítem determinado de una venta:
select precio_unitario*cantidad as total from detalle_venta
where venta_numero=1 and producto_codigo=2;

-- Total facturado por la farmacia
select sum(precio_unitario*cantidad) as total from detalle_venta;

-- Total facturado en una venta
select sum(precio_unitario*cantidad) as total from detalle_venta where venta_numero = 1;

-- Total facturado discriminado venta por venta ( sum con group by ):
select venta_numero , sum ( precio_unitario * cantidad ) as total from
detalle_venta
group by venta_numero;

 -- si quisieramos conocer cuantas ventas se realizaron
select count(*) as cant_ventas from venta;

-- cantidad de ventas por dia total ( count con group by)
select fecha , count(*) as cant_ventas from venta group by fecha;

-- precio promedio de productos vendidos por producto ( inner join , avg ,
-- group by)
select p . nombre , avg ( dv . precio_unitario ) as precio_promedio , p . precio as
precio_lista
from producto p
inner join detalle_venta dv on p . codigo = dv . producto_codigo
group by p . codigo;

-- precio promedio de productos vendidos entre fecha (i nner join , avg ,group by , between)

select p . nombre , avg ( dv . precio_unitario ) as precio_promedio , p . precio as
precio_lista
from producto p
inner join detalle_venta dv on p . codigo = dv . producto_codigo inner join venta v on dv . venta_numero = v . numero
where v . fecha between '2020-08-22' and '2020-08-23'
group by p . codigo;

-- artículos vendidos más baratos que el precio de lista
select v . numero , p . nombre , p . descripcion , p . precio as precio_lista ,
dv . precio_unitario as precio_venta,
dv . precio_unitario - p . precio as diferencia
from venta v
inner join detalle_venta dv on v . numero = dv . venta_numero
inner join producto p on dv . producto_codigo = p . codigo
where dv . precio_unitario - p . precio < 0;

-- total facturado en el a ñ o ( inner join , sum , where)
select year( v . fecha ) as año , sum( precio_unitario * cantidad ) as total
from detalle_venta d
inner join venta v on d . venta_numero = v . numero
group by year ( v . fecha );

-- Total facturado mayor a $100 ( sum con group by y having ):
select venta_numero , sum( precio_unitario * cantidad ) as total from
detalle_venta group by venta_numero having total > 100;

-- Total facturado mayor a $100 ( sum con group by y having, ordenado por total):
select venta_numero , sum( precio_unitario * cantidad ) as total from
detalle_venta
group by venta_numero
having total > 100
order by total;
-- Total facturado mayor a $100 ( sum con group by y having, ordenado por total ):
select venta_numero , sum( precio_unitario * cantidad ) as total from
detalle_venta
group by venta_numero
having total > 100
order by total desc;

-- Realizar una consulta que devuelva el total facturado por el
-- producto 'Amoxidal 500' pero eligiendo el producto por nombre 
-- (no por código). 
select p.nombre, sum(precio_unitario*cantidad) as total
from detalle_venta dv
inner join producto p on dv.producto_codigo=p.codigo
where p.nombre="Amoxidal 500";

-- Realizar una consulta que devuelva el total facturado al cliente con dni 
-- 22222222
select v.cliente_dni, sum(precio_unitario*cantidad) as total
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
where v.cliente_dni=22222222;

/*Realizar una consulta que devuelva la cantidad de ventas realizadas al 
cliente con dni 12345678. Cantidad de ventas es cada ticket emitido, no cada 
producto vendido*/
select v.cliente_dni, count(numero) as total
from venta v
where v.cliente_dni=12345678;

/*Realizar una consulta que devuelva las ventas realizadas a los clientes con apellido
'Belgrano', discriminado venta por venta. La consulta debe mostrar: venta_numero, total*/
select c.apellido as apellido, dv.venta_numero, sum(precio_unitario*cantidad) as total from detalle_venta dv
inner join venta v on venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
where c.apellido="Belgrano"
group by venta_numero;

/*Realizar una consulta que devuelva la cantidad de ventas realizadas a los clientes 
con apellido 'Moreno'. La consulta debe mostrar un campo indicando la cantidad de ventas*/
select c.apellido, count(numero) as total from venta v
inner join cliente c on v.cliente_dni=c.dni
where c.apellido="Moreno";

-- Traer el total facturado por obra social. Se debe indicar nombre de obra social, monto total.
select os.nombre,sum(precio_unitario*cantidad) as total from  venta v 
inner join detalle_venta dv on v.numero=dv.venta_numero
inner join cliente c on v.cliente_dni=c.dni
inner join cliente_tiene_obra_social cob on cob.cliente_dni=c.dni
inner join obra_social os on cob.obra_social_codigo=os.codigo
group by os.codigo;

-- Idem a la anterior, pero filtrando desde el 1/1/2020 hasta el 30/8/2020.
select os.nombre, sum(precio*cantidad) as total from venta v
inner join detalle_venta dv on dv.venta_numero=v.numero
inner join producto p on p.codigo=dv.producto_codigo
inner join cliente_tiene_obra_social cob on cob.cliente_dni=v.cliente_dni
inner join obra_social os on os.codigo = cob.obra_social_codigo
where v.fecha between "20-01-01" and "20-08-30"
group by os.codigo;

-- Traer el total facturado a clientes que no tienen obra social
/*select os.nombre,sum(precio_unitario*cantidad) as total from  venta v 
inner join detalle_venta dv on v.numero=dv.venta_numero
inner join cliente c on v.cliente_dni=c.dni
inner join cliente_tiene_obra_social cob on cob.cliente_dni=c.dni
inner join obra_social os on cob.obra_social_codigo=os.codigo
group by os.codigo;*/

-- Realizar una consulta que devuelva las ventas realizadas a clientes de la 
-- calle Sáenz (se debe filtrar por nombre de calle="Sáenz")
select ca.nombre as calle, sum(precio_unitario*cantidad) as total from detalle_venta dv
inner join venta v on venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
inner join calle ca on c.calle_idcalle=ca.idcalle
where ca.nombre="Sáenz";

/*Realizar una consulta que devuelva las ventas realizadas a clientes de la 
calle Sáenz (se debe filtrar por nombre de calle="Sáenz", discriminada 
venta por venta (venta_numero, total)*/

select ca.nombre as calle, dv.venta_numero, sum(precio_unitario*cantidad) as total from detalle_venta dv
inner join venta v on venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
inner join calle ca on c.calle_idcalle=ca.idcalle
where ca.nombre="Sáenz"
group by venta_numero;

-- Realizar una consulta que devuelva los productos vendidos. Se debe mostrar cada 
-- producto una sola vez (Ayuda: hay que agrupar por producto)
select p.nombre as producto, dv.cantidad, p.precio as precio_unitario
from producto p
inner join detalle_venta dv on p.codigo=dv.producto_codigo
group by p.codigo;

/*Realizar una consulta que devuelva el total de ventas sin detallar realizadas 
a clientes de la obra social IOMA que vivan en la provincia de Buenos Aires. 
Consultar por nombre de obra social y de provincia*/
select os.nombre as obra_social, p.nombre as provincia,sum(precio_unitario*cantidad) as total from detalle_venta dv
inner join venta v on venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
inner join cliente_tiene_obra_social ctob on c.dni=ctob.cliente_dni
inner join obra_social os on ctob.obra_social_codigo=os.codigo
inner join provincia p on c.provincia_idprovincia=p.idprovincia
where os.nombre="IOMA" and p.nombre="Buenos Aires";

-- Realizar una consulta que devuelva cuántas son las ventas de la consulta anterior
select count(dv.venta_numero) as ventas_consulta_anterior from detalle_venta dv
inner join venta v on v.numero = dv.venta_numero
inner join cliente c on c.dni = v.cliente_dni
inner join provincia p on p.idprovincia = c.provincia_idprovincia
inner join cliente_tiene_obra_social cos on cos.cliente_dni = c.dni
inner join obra_social os on os.codigo = cos.obra_social_codigo
where os.nombre = "IOMA" and p.nombre = "Buenos Aires";
 
-- Campos en select con dependencias funcionales con un campo en group by:
select c . dni , sum( precio_unitario * cantidad ) as total_facturado , c . nombre ,
c . apellido
from detalle_venta dv
inner join venta v on dv . venta_numero = v . numero
inner join cliente c on v . cliente_dni = c . dni
group by c . dni; 

-- Campos en select sin dependencia funcional con alg ún campo en group by ( incorrecta)
-- debe devolver error , si no es as í, verificar sql_mode:
select c . dni , sum( precio_unitario * cantidad ) as total_facturado , c . nombre ,
c . apellido , v . fecha
from detalle_venta dv
inner join venta v on dv . venta_numero = v . numero
inner join cliente c on v . cliente_dni = c . dni
group by c . dni;
 
-- Campos en select sin dependencia funcional con alguno en group by,
-- pero en funci ó n de agregaci ó n:
select c . dni , sum( precio_unitario * cantidad ) as total_facturado , c . nombre ,
c . apellido, max( v . fecha ) as fecha_ultima_venta
from detalle_venta dv
inner join venta v on dv . venta_numero = v . numero
right join cliente c on v . cliente_dni = c . dni
left join cliente_tiene_obra_social cos on c . dni = cos . cliente_dni
group by c . dni;

SET@@session.sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- agregamos 20 % al precio de todos los productos
update producto set precio = precio * 1.2;

-- agregamos 20 % al precio de todos los productos
update producto set precio = precio * 1.2 where producto.codigo>-1;

-- agregamos 15 % al precio de los productos Bayer
update producto set precio = precio * 1.15
where laboratorio_codigo = 1;

-- agregamos 10 % a un producto determinado
update producto set precio = precio * 1.1
where codigo = 2;

-- agregamos 10 % a los productos cuyo precio sea > 150
update producto set precio = precio * 1.1
where precio > 150;

-- podemos actualizar varios campos a la vez separando con comas.
-- aqu í utilizamos una funci ó n de MySQL para concatenar dos strings
-- year , sum , count , avg tambi é n son funciones.
-- Listado de funciones de MySQL:
-- https : //dev.mysql.com/doc/refman/8.0/en/sql-function-reference.html
update producto set precio = precio * 1.1 , descripcion = concat (descripcion , "nueva fórmula")
where nombre = "Amoxidal 500";
select * from producto;

-- damos de alta una obra social para luego eliminarla
insert into obra_social ( codigo , nombre , descripcion)
values ( 4 , "OSPAPEL" , "Obra Social del personal del papel" );

-- la eliminamos
delete from obra_social where codigo = 4;

-- realizar una consulta que traiga el total de las ventas de un cliente indicando apellido,nombre,dni,localidad y total de ventas
 select c.apellido, c.nombre, c.dni, l.nombre, count(*) as total_ventas
	from detalle_venta dv 
	inner join venta v on dv.venta_numero = v.numero
    inner join cliente c on v.cliente_dni = c.dni
    inner join localidad l on c.localidad_idlocalidad = l.idLocalidad
    group by c.dni;
    

-- Realizar una consulta que traiga el total de las ventas por provincia, indicando provincia,total de ventas
 select p.nombre,count(distinct v.numero) as total_ventas
 from detalle_venta dv
 inner join venta v on dv.venta_numero = v.numero
 inner join provincia p on p.nombre = p.nombre
 group by p.nombre;
 
/*Realizar una consulta que devuelva el promedio de precio de venta por producto, mostrando 
producto, precio promedio. El precio de venta es el precio con que se vendió, no el precio 
de lista*/

-- Realizar una consulta que le cambie la obra social al cliente con dni 22222222.
update cliente_tiene_obra_social set obra_social_codigo =3 where cliente_dni=22222222;

-- Realizar una consulta que retorne la obra social del cliente con dni 22222222 a la original (IOMA).
update cliente_tiene_obra_social set obra_social_codigo =2 where cliente_dni=22222222;

-- Realizar una consulta que modifique al cliente Mariano Moreno para que quede sin obra social
delete from cliente_tiene_obra_social where cliente_dni=44444444;

-- Realizar una consulta que asigne nuevamente al cliente Mariano Moreno su obra social original y su número de afiliado (IOMA, 12356987)
insert into cliente_tiene_obra_social values (44444444, 2, 12356987);

/*Crear una venta número 7, de fecha  25/08/2020, al cliente Cornelio Saavedra, con los 
siguientes productos (producto, cantidad):
Amoxidal 500, 3
Bayaspirina, 10
Redoxon, 1
Los precios deben ser los precios de lista*/
insert into venta values(7, '250820', 23456789);
insert into detalle_venta values(7, 3, 300.00, 3);  
insert into detalle_venta values(7, 2, 10.00, 10);  
insert into detalle_venta values(7, 4, 120.00, 1);  

-- Crear una consulta que Modifique el precio del artículo Redoxon de la venta 7 a $200
update detalle_venta set precio_unitario = precio_unitario*1.67
where producto_codigo = 4; -- da 200.40$

-- Crear las consultas necesarias para eliminar completamente la venta 7, incluyendo su detalle
delete from detalle_venta where venta_numero = 7;

create table pedido(
numero int primary key,
fecha date not null,
cliente_dni int not null,
venta_numero int,
foreign key ( cliente_dni ) references cliente ( dni ),
foreign key ( venta_numero ) references venta ( numero)
);
create table detalle_pedido(
pedido_numero int,
producto_codigo int,
cantidad int,
primary key ( pedido_numero , producto_codigo ),
foreign key ( pedido_numero ) references pedido ( numero ),
foreign key ( producto_codigo ) references producto ( codigo)
);
-- insertamos pedidos:
INSERT INTO `farmacia` . `pedido` ( `numero` , `fecha` , `cliente_dni` ) VALUES ( '1' , '2018-04-17' , '22222222' );
INSERT INTO `farmacia` . `pedido` ( `numero` , `fecha` , `cliente_dni` ) VALUES ( '2' , '2018-04-18' , '22222222' );
INSERT INTO `farmacia` . `pedido` ( `numero` , `fecha` , `cliente_dni` ) VALUES ( '3' , '2018-04-19' , '44444444' );
INSERT INTO `farmacia` . `pedido` ( `numero` , `fecha` , `cliente_dni` ) VALUES ( '4' , '2018-04-19' , '23456789' );
INSERT INTO `farmacia` . `detalle_pedido` ( pedido_numero , `producto_codigo` , `cantidad` ) VALUES ( '1' , '2' , '3' );
INSERT INTO `farmacia` . `detalle_pedido` ( pedido_numero , `producto_codigo` , `cantidad` ) VALUES ( '1' , '3' , '1' );
INSERT INTO `farmacia` . `detalle_pedido` ( pedido_numero , `producto_codigo` , `cantidad` ) VALUES ( '2' , '1' , '2' );
INSERT INTO `farmacia` . `detalle_pedido` ( pedido_numero , `producto_codigo` , `cantidad` ) VALUES ( '2' , '4' , '1' );
INSERT INTO `farmacia` . `detalle_pedido` ( pedido_numero , `producto_codigo` , `cantidad` ) VALUES ( '3' , '5' , '2' );
INSERT INTO `farmacia` . `detalle_pedido` ( pedido_numero , `producto_codigo` , `cantidad` ) VALUES ( '3' , '2' , '3' );
INSERT INTO `farmacia` . `detalle_pedido` ( pedido_numero , `producto_codigo` , `cantidad` ) VALUES ( '4' , '2' , '2' );

/*consulta de unión entre la tabla venta y pedido, para conocer las
ventas realizadas y los pedidos pendientes de un cliente determinado:*/
select 'v' as tipo_operacion , v . numero , v . fecha from
venta v where v . cliente_dni = 22222222 union select 'p' as tipo_operacion , p . numero , p . fecha
from pedido p where p . cliente_dni = 22222222 and p . venta_numero IS NULL;

/*Caso 1 : podemos tener un subquery en la cl á usula WHERE , para filtrar los
 resultados de la consulta exterior de acuerdo a lo que nos devuelva la
 interior: */
select fecha , numero from venta v where v . cliente_dni in ( select c . dni
from cliente c where c . localidad_idlocalidad = 1 );

-- E l mismo resultado puede alcanzarse con un join:
select v . fecha , v . numero from venta v inner join cliente c
ON v . cliente_dni = c . dni where c . localidad_idlocalidad = 1;

/* Otro ejemplo , con operadores de comparaci ó n y funciones de agregaci ó n:
-- obtenemos las ventas con alg ú n art í culo cuyo precio unitario
-- efectivamente cobrado sea mayor que el precio promedio de lista
-- de todos los productos: */
select d . venta_numero from detalle_venta d where d . precio_unitario > ( select
avg ( p . precio) from producto p) group by d . venta_numero;

/* obtenemos los productos con precio mayor que el promedio de todos los
 artículos vendidos . Tanto la consulta externa como la interna
 se realizan sobre la misma tabla: */
select p . nombre , p . descripcion , p . precio from producto p
where p . precio > ( select avg ( p2 . precio) from producto p2 );

-- la siguiente consulta devuelve aquellos productos que nunca se vendieron:
select * from producto p where not exists( select d . venta_numero
from detalle_venta d where d . producto_codigo = p . codigo );

-- En nuestra base de datos no tenemos productos que no se hayan vendido. Agreguemos algún producto para obtener resultados
INSERT INTO farmacia . producto ( codigo , nombre , descripcion , precio ,
laboratorio_codigo)
VALUES ( 6 , 'Cafiaspirina' , 'Aspirina con cafeína por tira de 10 unidades' ,
'15' , '1' );

-- La misma consulta , pero implementada con joins:
SELECT p .* FROM producto p LEFT JOIN detalle_venta d ON p . codigo = d . producto_codigo
WHERE ISNULL ( d . producto_codigo );

-- queremos conocer qué clientes compraron más de cierto monto por factura:
select c.dni , c.apellido ,c.nombre from cliente c
where exists ( select sum( d . precio_unitario * d . cantidad ) as total
from detalle_venta d inner join venta v ON v . numero = d . venta_numero
where v . cliente_dni = c . dni group by v . numero having total > 200 );

select
max( items . cantidad_items ) as maximo,
avg ( items . cantidad_items ) as promedio,
min( items . cantidad_items ) as minimo
from( select d . venta_numero , count( d . venta_numero ) as cantidad_items
from detalle_venta d group by d . venta_numero ) as items;

-- Subqueries en INSERTs:
create table cliente_importante(
dni int primary key,
apellido varchar ( 45 ),
nombre varchar ( 45)
);

insert into cliente_importante ( select c . dni , c . apellido , c . nombre
from cliente c where exists ( select sum ( d . precio_unitario * d . cantidad ) as total
from detalle_venta d inner join venta v ON v . numero = d . venta_numero
where v . cliente_dni = c . dni group by v . numero having total > 200 ));
select * from cliente_importante;

-- También DELETE puede emplear subqueries . Eliminamos los productos
-- que no existen en ninguna venta:
delete p .* from producto p where not exists( select d . venta_numero
from detalle_venta d where d . producto_codigo = p . codigo );