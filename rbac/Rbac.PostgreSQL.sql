create table object (
   id serial primary key,
   code varchar not null,
   title varchar not null
);
comment on table object is 'объект доступа';

create table action (
   id serial primary key,
   code varchar not null,
   title varchar not null
);
comment on table action is 'действие, производимое над object';

create table permission (
   id serial primary key,
   object_id integer references object(id),
   action_id integer references action(id)
);
comment on table permission is 'разрешение на действие action над объектом object';

create table role (
   id serial primary key,
   code varchar not null,
   title varchar not null
);
comment on table role is 'роль';

create table role_permission (
   role_id integer references role(id),
   permission_id integer references permission(id)
);
comment on table role_permission is 'назначение разрешения к роли';

create table user_assigment (
   id serial primary key,
   name varchar not null
);
comment on table user_assigment is 'пользователь';

create table role_user_assigment (
   user_assigment_id integer references user_assigment(id),
   role_id integer references role(id)
);
comment on table role_user_assigment is 'назначение пользователя к конкретной роли';

create table subscriber (
   id serial primary key,
   inn varchar(12) not null,
   short_name varchar(50) not null,
   full_name varchar(4000) not null,
   address varchar(200) not null,
   phone varchar(200) not null,
   full_name_head varchar(200) not null,
   representative varchar(4000) not null,
   representative_phone varchar(200) not null
);
comment on table subscriber is 'абоненты';

insert into subscriber values(1, 123, 'Краткое наименование абонента', 'Полное наименование абонента', 'Адрес абонента', 'Телефоны абонента', 'ФИО руководителя', 'Представитель абонента', 'Телефоны представителя');

insert into object values(1, 'subscriber', 'абоненты');
insert into object values(2, 'user', 'пользователи');

insert into action values(1, 'create', 'добавление записи');
insert into action values(2, 'update', 'редактирование записи');
insert into action values(3, 'delete', 'удаление записи');
insert into action values(4, 'read', 'просмотр списка');
insert into action values(5, 'print', 'печать списка');

insert into permission values(1, 1, 1);
insert into permission values(2, 1, 2);
insert into permission values(3, 1, 3);
insert into permission values(4, 1, 4);
insert into permission values(5, 1, 5);

insert into role values(1, 'role1', 'Роль 1');
insert into role values(2, 'role2', 'Роль 2');
insert into role values(3, 'role3', 'Роль 3');
insert into role values(4, 'admin', 'Администратор');

insert into role_permission values(1, 1);
insert into role_permission values(1, 2);
insert into role_permission values(1, 4);

insert into role_permission values(2, 2);
insert into role_permission values(2, 4);

insert into role_permission values(3, 4);
insert into role_permission values(3, 5);

insert into user_assigment values(1, 'user1');
insert into user_assigment values(2, 'user2');
insert into user_assigment values(3, 'user3');

insert into role_user_assigment values(1, 1);
insert into role_user_assigment values(2, 2);
insert into role_user_assigment values(3, 3);

/*
select u.id    as user_id,
       u.name  as user_name,
       r.code  as role,
       r.title as role_title,
       o.code  as object,
       o.title as object_title,
       a.code  as action,
       a.title as action_title
  from user_assigment u, role_user_assigment ru, role r, role_permission rp, permission p, object o, action a
 where u.id = ru.user_assigment_id
   and ru.role_id = r.id
   and r.id = rp.role_id
   and rp.permission_id = p.id
   and o.id = p.object_id
   and a.id = p.action_id
   and u.id = 1
   and (o.code = null or null is null)
*/

-- https://habr.com/ru/post/217383/
