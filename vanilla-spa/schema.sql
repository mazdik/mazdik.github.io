drop table if exists region;
create table region (
    id integer primary key autoincrement,
    region_name text not null
);

drop table if exists city;
create table city (
    id integer primary key autoincrement,
    region_id integer,
    city_name text not null
);

drop table if exists user;
create table user (
    id integer primary key autoincrement,
    surname text not null,
    name text not null,
    middle_name text,
    city_id integer,
    phone text,
    email text
);

drop table if exists comment;
create table comment (
    id integer primary key autoincrement,
    user_id integer not null,
    comment text
);

insert into region values (1, 'Краснодарский край');
insert into region values (2, 'Ростовская область');
insert into region values (3, 'Ставропольский край');

insert into city values (1, 1, 'Краснодар');
insert into city values (2, 1, 'Кропоткин');
insert into city values (3, 1, 'Славянск');

insert into city values (4, 2, 'Ростов');
insert into city values (5, 2, 'Шахты');
insert into city values (6, 2, 'Батайск');

insert into city values (7, 3, 'Ставрополь');
insert into city values (8, 3, 'Пятигорск');
insert into city values (9, 3, 'Кисловодск');
