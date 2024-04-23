--Создаем таблицу с профилем рабочих мест +
create table worker_profiles(
    profile_id number generated always as identity(start with 1 increment by 1) constraint wp_pk primary key not null,
    profile_name varchar2(1000 char) not null
);
--Создаем таблицу с типом заведений +
create table establishment_type(
    type_id number generated always as identity(start with 1 increment by 1) constraint est_t_pk primary key not null,
    type_name varchar2(100 char) not null
);

--Создаем таблицу заведений +
create table establishments(
    est_id number generated always as identity(start with 1 increment by 1) constraint est_pk primary key,
    type_id number not null constraint est_type references establishment_type(type_id),
    boss_est_id number default null constraint boss_est references establishments(est_id),
    est_name varchar2(1000 byte) not null,
    est_address varchar2(1000 byte) default null
);


--Создаем таблицу партнеров +
create table partners(
    partner_id number generated always as identity(start with 1 increment by 1) constraint part_pk primary key,
    individual number(1,0) default 1 not null,
    discount float default 0 check(discount>=0)
);

--Создаем таблицу клиентов +
create table clients(
    partner_id number not null constraint client_fk references partners(partner_id) constraint clients_pk primary key,
    phone_number varchar2(15) check(REGEXP_LIKE(phone_number,'^[+]{1}[7]{1}([0-9]{3}){1}([0-9]{3})?([0-9]{7})$')) not null,
    first_name varchar2(100) not null,
    surname varchar2(100) not null,
    patronymic varchar2(100) default null
);

--Создаем таблицу юр лиц +
create table legal_entities(
    partner_id number not null references partners(partner_id) constraint legal_ent_pk primary key,
    ent_name varchar2(100) not null,
    address varchar2(100) default null,
    inn varchar2(10) check(regexp_like(inn,'^[0-9]{10}$')) not null unique
);


--Создаем таблицу дисконтных карт +
create table discount_cards(
    card_number varchar2(100) not null check(REGEXP_LIKE(card_number,'^[0-9]+$')),
    est_id number not null references establishments(est_id),
    partner_id number not null references partners(partner_id),
    export_record_id number generated always as identity(start with 1 increment by 1) unique,
    discount_percent FLOAT not null check(discount_percent>0),
    constraint dis_cards_pk primary key(card_number,est_id)
);


--Создаем таблицы с заказами и фирмами
--Таблица Расходные материалы +
create table consumables(
    consumable_articul varchar2(100 byte) not null constraint consumables_pk primary key,
    creator_id number not null references partners(partner_id),
    consumable_name varchar2(100) not null
);

--Таблицf Доп характеристика всех материалов и товаров +
create table all_extra_char(
    char_id number generated always as identity(start with 1 increment by 1) constraint all_extra_char_pk primary key ,
    char_name varchar2(100) not null,
    unit_of_measure varchar2(100) default null
);

--Таблица Материал_характеристика +
create table extra_char_const(
    consumable_articul varchar2(100 byte) not null references consumables(consumable_articul),
    char_id number not null references all_extra_char(char_id),
    char_value varchar2(100) not null,
    constraint extra_char_const_pk primary key(consumable_articul,char_id)
);

--Таблица Расходные материалы_поставщик +
create table cons_prov(
    consumable_articul varchar2(100 byte) not null references consumables(consumable_articul),
    provider_id number not null references partners(partner_id),
    cons_cost float not null check(cons_cost>0),
    measuer_unit varchar2(100) not null,
    export_record_id number generated always as identity(start with 1 increment by 1) unique,
    primary key(consumable_articul,provider_id)
);

--Создаем таблицу заказов от филиалов и фотоцентров
--Таблица общие заказы по фотоцентру +
create table center_orders(
    order_id number generated always as identity(start with 1 increment by 1) constraint center_orders_pk primary key,
    center_id number references establishments(est_id),
    start_date date default null,
    end_date date default null,
    center_order_total_cost float default 0 not null check(center_order_total_cost>=0)
);

--Таблица заказы на поставку +
create table supply_orders(
    order_id number generated always as identity(start with 1 increment by 1) constraint supply_orders_pk primary key,
    est_id number not null references establishments(est_id),
    center_order number default null references center_orders(order_id),
    start_date date default null,
    end_date date default null,
    total_cost float default 0 not null check(total_cost>=0)
);

--Таблица заказы на поставку_материалы +
create table sup_orders_cons(
    order_id number not null references supply_orders(order_id),
    record_id number not null references cons_prov(export_record_id),
    start_date date not null,
    end_date date default null,
    required_count float default 0 check(required_count>=0),
    acquired_count float default 0 check(acquired_count>=0) not null,
    total_cost float  default 0 check(total_cost>=0),
    primary key(order_id,record_id)
);


--Создаем таблицу заказов
create table orders(
    order_id number not null check(order_id>0),
    est_id number not null references establishments(est_id),
    customer_id number not null references partners(partner_id),
    express_ord number(1,0) default 0,
    start_date timestamp not null,
    personal_discount_use number(1,0) default 0,
    card_record_id number default null references discount_cards(export_record_id),
    total_cost float default 0 check(total_cost>=0),
    export_record_id number generated always as identity(start with 1 increment by 1) unique,
    constraint orders_pk primary key(order_id,est_id)
);

--Создаем таблицу работников +
create table workers(
    passport_number varchar2(10) constraint workers_pk primary key not null,
    first_name varchar2(100) not null,
    surname varchar2(100) not null,
    patronymic varchar2(100) default null
);

--Места работы +
create table workers_est(
    personal_number number check(personal_number>0) not null,
    est_id number not null references establishments(est_id),
    start_date date not null,
    end_date date default null,
    profile_id number not null references worker_profiles(profile_id),
    export_record_id number generated always as identity(start with 1 increment by 1) unique,
    passport_number varchar2(10) not null references workers(passport_number),
    boss_record number default null references workers_est(export_record_id),
    salary float check(salary>0) not null,
    constraint workers_est primary key(personal_number,est_id,start_date)
);


--Создаем таблицу выполнений заказов +
create table fulfil_orders(
    order_record_id number not null primary key references orders(export_record_id),
    workers_est_record_id number not null references workers_est(export_record_id),
    end_date timestamp not null,
    revenue float check(revenue>0) not null,
    money_change float check(money_change>=0) not null
);

--Создаем позиции заказа
--Таблица видов номенклатуры +
create table nomenclature_type(
    type_id number generated always as identity(start with 1 increment by 1) constraint nom_type_pk primary key,
    type_name varchar2(100) not null,
    service_cons number(1,0) default 1
);
--Создаем таблицу номенклатура
create table nomenclature(
    nomenclature_id number generated always as identity(start with 1 increment by 1) constraint nom_pk primary key,
    nom_name varchar2(100) not null,
    consumable_articul varchar2(100 byte) default null references consumables(consumable_articul),
    type_id number not null references nomenclature_type(type_id),
    photo_work number(1,0) default 0,
    base_cost float  default 0 check(base_cost>=0),
    measure_unit varchar2(100) not null    
);
--Создаем таблицу заказ_позиция
create table order_position(
    order_record_id number not null references orders(export_record_id),
    nomenclature_id number not null references nomenclature(nomenclature_id),
    count_of_position float check(count_of_position>0),
    bought_film_here number(1,0) default 0,
    photo_print number(1,0) default 0,
    sold_without_service number(1,0) default 0,
    total_cost float default 0 check(total_cost>=0) not null,
    constraint ord_pos primary key (order_record_id,nomenclature_id)
);
