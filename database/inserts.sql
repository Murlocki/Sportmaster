--Типы заведений
insert into establishment_type values (default,'Главный офис');
insert into establishment_type values (default,'Филиал');
insert into establishment_type values (default,'Киоск');
insert into establishment_type values (default,'Фотомагазин');

--Заведения
insert into establishments values (default,1,default,'Главник','улица Сормовская 108');
insert into establishments values (default,2,1,'Главник','улица Сормовская 110');
insert into establishments values (default,2,1,'Главник','улица Тюляева 18');
insert into establishments values (default,3,2,'Главник','улица Павлова 9');
insert into establishments values (default,3,3,'Главник','улица Сормовская 209');
insert into establishments values (default,3,3,'Главник','улица Сормовская 555555');
insert into establishments values (default,4,3,'Главник','улица Анаова 34');

insert into establishments values (default,1,default,'Кодак','улица Мовская 108');
insert into establishments values (default,2,8,'Кодак','улица Сормовская 210');
insert into establishments values (default,3,9,'Кодак','улица Павлова 29');
insert into establishments values (default,3,9,'Кодак','улица Сормовская 309');
insert into establishments values (default,4,9,'Кодак','улица Анаова 44');

--Профили рабочих мест
insert into worker_profiles values (default,'Управляющий заведением');
insert into worker_profiles values (default,'Фотограф');
insert into worker_profiles values (default,'Продавец');
insert into worker_profiles values (default,'Работник');
insert into worker_profiles values (default,'Кассир');

--Люди работники
insert into workers values ('3454567844','Абрамов','Иван',default);
insert into workers values ('3454567833','Абрамов','Вано',default);
insert into workers values ('3454567822','Конев','Алексей','Владимирович');
insert into workers values ('3454567811','Абмов','Иван',default);
insert into workers values ('4454567844','Ммов','Андрей',default);
insert into workers values ('5454567844','Абрамов','Иван',default);
insert into workers values ('8454567844','Венков','Алексей',default);
insert into workers values ('2154567844','Малышева','Даша',default);
insert into workers values ('7754567844','Корнеева','Мария',default);
insert into workers values ('9954567844','Книжная','Настя',default);
insert into workers values ('2254567844','Колыва','Валерия',default);
insert into workers values ('1954567844','Абрамов','Егор',default);
insert into workers values ('6654567844','Соннова','Полина',default);
insert into workers values ('2253356734','Абрамов','Артем',default);

--Место работы
insert into workers_est values (1,1,'12.10.23',default,1,default,'3454567844',default,10000);
insert into workers_est values (2,2,'13.10.23','13.10.23',2,default,'3454567833',default,10000);
insert into workers_est values (3,3,'12.10.23','15.10.23',3,default,'3454567822',default,10000);
insert into workers_est values (4,4,'12.10.23',default,3,default,'3454567811',default,10000);
insert into workers_est values (5,5,'12.10.23',default,2,default,'4454567844',default,10000);
insert into workers_est values (6,6,'12.10.23',default,1,default,'5454567844',default,10000);
insert into workers_est values (7,7,'12.10.23',default,2,default,'8454567844',default,10000);
insert into workers_est values (8,8,'12.10.23',default,3,default,'2154567844',default,10000);
insert into workers_est values (9,9,'12.10.23',default,4,default,'7754567844',default,10010);
insert into workers_est values (10,10,'12.10.23',default,5,default,'9954567844',default,12000);
insert into workers_est values (11,12,'12.10.23',default,2,default,'2254567844',default,13000);
insert into workers_est values (12,12,'12.10.22',default,1,default,'1954567844',default,14000);
insert into workers_est values (13,12,'12.10.23',default,2,default,'6654567844',default,10500);
insert into workers_est values (14,1,'12.10.23',default,3,default,'2253356734',1,20000);

--Партрнеры
insert into partners values(default,1,10);
insert into partners values(default,1,20);
insert into partners values(default,1,30);
insert into partners values(default,1,20);
insert into partners values(default,1,default);
insert into partners values(default,1,default);
insert into partners values(default,1,default);
insert into partners values(default,2,default);
insert into partners values(default,2,10);
insert into partners values(default,2,default);

--Клиенты
insert into clients values(2,'+77655677670','Fa','Fa',default);
insert into clients values(3,'+77655677671','Fb','Fb',default);
insert into clients values(4,'+77655677672','Fb','Fb',default);
insert into clients values(5,'+77655677673','Fb','Fb',default);
insert into clients values(6,'+77655677674','Fc','Fc',default);
insert into clients values(7,'+77655677675','Fd','Fd',default);
insert into clients values(1,'+77655677676','Fe','Fe',default);

--Юр лица
insert into legal_entities values(8,'ООО Завод',default,'1233444422');
insert into legal_entities values(9,'ООО Агроном',default,'1233544422');
insert into legal_entities values(10,'ООО Завод',default,'1233224422');

--Дисконтные карты
insert into discount_cards values('1',1,1,default,10);
insert into discount_cards values('13',8,2,default,10);
insert into discount_cards values('14',1,1,default,10);


--Вид номенклатуры
insert into nomenclature_type values (default,'Товар',0);
insert into nomenclature_type values (default,'Услуга',1);


--Расходные материалы
insert into consumables values ('1',1,'Бумага а4 размера 16.5x16.5');
insert into consumables values ('2',1,'Бумага а4 размера 20x16.5');
insert into consumables values ('3',2,'Чернила');
insert into consumables values ('4',3,'Бумага а5 размера 20x15');
insert into consumables values ('5',2,'Конверты 15x15');
insert into consumables values ('8',3,'Фотоаппарат sumsuang');
insert into consumables values ('13',10,'Фотоаппарат nokia');
insert into consumables values ('14',9,'Фотоаппарат micr');
insert into consumables values ('15',8,'Фотоаппарат alof');
insert into consumables values ('9',3,'Объектив маленький');
insert into consumables values ('10',3,'Пленка');

--Доп характеристики материалов
insert into all_extra_char values (default,'Размер бумаги','см');
insert into all_extra_char values (default,'Формат',default);
insert into all_extra_char values (default,'Размер коверта','см');

--Характеристики материалы
insert into extra_char_const values ('1',1,'16.5x16.5');
insert into extra_char_const values ('2',1,'20x16.5');
insert into extra_char_const values ('4',1,'20x15');
insert into extra_char_const values ('5',3,'15x15');
insert into extra_char_const values ('1',2,'a4');
insert into extra_char_const values ('2',2,'a4');
insert into extra_char_const values ('4',2,'a5');

--Расходные материалы поставщик
insert into cons_prov values ('1',1,10,'пачки',default);
insert into cons_prov values ('2',2,10,'пачки',default);
insert into cons_prov values ('3',3,20,'картридж',default);
insert into cons_prov values ('4',5,30,'пачки',default);
insert into cons_prov values ('5',6,40,'пачки',default);
insert into cons_prov values ('8',1,110,'шт',default);
insert into cons_prov values ('13',1,110,'шт',default);
insert into cons_prov values ('9',2,120,'шт',default);
insert into cons_prov values ('10',3,120,'шт',default);
insert into cons_prov values ('14',4,120,'шт',default);
insert into cons_prov values ('15',5,120,'шт',default);
insert into cons_prov values ('15',6,110,'шт',default);

--Номенклатура
insert into nomenclature values (default,'Бумага а4 размера 16.5x16.5','1',1,0,1,'шт');
insert into nomenclature values (default,'Бумага а4 размера 20x16.5','2',1,0,2,'шт');
insert into nomenclature values (default,'Бумага а5 размера 20x15','4',1,0,3,'шт');
insert into nomenclature values (default,'Конверты 15x15','5',1,0,2,'шт');
insert into nomenclature values (default,'Фотоаппарат sumsuang','8',1,0,290,'шт');
insert into nomenclature values (default,'Фотоаппарат nokia','13',1,0,280,'шт');
insert into nomenclature values (default,'Фотоаппарат micr','14',1,0,290,'шт');
insert into nomenclature values (default,'Фотоаппарат  alof','15',1,0,300,'шт');
insert into nomenclature values (default,'Объектив маленький','9',1,0,230,'шт');
insert into nomenclature values (default,'Пленка','10',1,0,4,'м');


insert into nomenclature values (default,'Проявка пленки',null,2,1,240,'шт');
insert into nomenclature values (default,'Фотография на документы',null,2,0,20,'шт');
insert into nomenclature values (default,'Прокат фотоаппаратов',null,2,0,200,'шт');
insert into nomenclature values (default,'Художественное фото',null,2,0,130,'шт');
insert into nomenclature values (default,'Реставрация фотографий',null,2,0,130,'шт');
insert into nomenclature values (default,'Услуги фотографа',null,2,0,200,'шт');

insert into nomenclature values (default,'Распечатка фотографий 3 на 4',null,2,1,20,'шт');
insert into nomenclature values (default,'Распечатка фотографий 2 на 5',null,2,1,20,'шт');
insert into nomenclature values (default,'Распечатка фотографий 15 на 5',null,2,1,25,'шт');

insert into nomenclature values (default,'Фотографий с кадра 10',null,2,0,40,'шт');
insert into nomenclature values (default,'Фотографий с кадра 20',null,2,0,50,'шт');
insert into nomenclature values (default,'Фотографий с кадра 30',null,2,0,60,'шт');

--Таблица заказы
insert into orders values(1,2,1,1,'13.10.23',1,1,default,default);
insert into orders values(2,2,2,0,'13.10.23',0,default,default,default);
insert into orders values(3,2,3,1,'13.10.23',1,1,default,default);
insert into orders values(4,3,4,0,'15.10.23',0,default,default,default);
insert into orders values(5,3,6,1,'16.10.23',0,default,default,default);
insert into orders values(6,3,7,0,'14.10.23',0,default,default,default);
insert into orders values(7,4,1,0,'18.10.23',1,1,default,default);
insert into orders values(8,7,2,1,'20.10.23',1,1,default,default);
insert into orders values(9,7,3,0,'21.10.23',1,1,default,default);
insert into orders values(10,9,4,0,'12.11.23',1,2,default,default);
insert into orders values(11,10,8,0,'12.10.23',0,default,default,default);
insert into orders values(12,10,9,1,'12.10.23',0,default,default,default);
insert into orders values(13,10,10,0,'12.10.23',0,default,default,default);
insert into orders values(14,10,5,0,'12.10.23',0,default,default,default);
insert into orders values(15,10,4,0,'12.10.23',0,default,default,default);



--Позиция заказов
insert into order_position values(1,1,10,0,0,0,default);
insert into order_position values(1,17,20,0,1,0,default);
insert into order_position values(1,20,1,0,0,0,default);

insert into order_position values(2,11,10,1,0,0,default);

insert into order_position values(3,1,10,0,0,0,default);
insert into order_position values(3,18,20,0,1,0,default);
insert into order_position values(3,21,1,0,0,0,default);


insert into order_position values(4,2,10,0,0,0,default);
insert into order_position values(4,17,10,0,1,0,default);
insert into order_position values(4,18,20,0,1,0,default);

insert into order_position values(5,5,1,0,0,1,default);
insert into order_position values(5,6,1,0,0,1,default);
insert into order_position values(5,7,1,0,0,1,default);
insert into order_position values(5,8,2,0,0,1,default);


insert into order_position values(6,12,1,0,0,0,default);

insert into order_position values(7,19,10,0,0,0,default);
insert into order_position values(7,3,6,0,0,0,default);

insert into order_position values(8,8,1,0,0,1,default);
insert into order_position values(8,9,1,0,0,1,default);

insert into order_position values(9,9,2,0,0,1,default);
insert into order_position values(9,8,3,0,0,1,default);

insert into order_position values(10,9,10,0,0,1,default);

insert into order_position values(11,9,2,0,0,1,default);
insert into order_position values(11,1,10,0,0,1,default);
insert into order_position values(11,2,10,0,0,1,default);
insert into order_position values(11,3,10,0,0,1,default);
insert into order_position values(11,8,2,0,0,1,default);

insert into order_position values(12,9,1,0,0,1,default);

insert into order_position values(13,9,1,0,0,1,default);

insert into order_position values(14,7,1,0,0,1,default);

insert into order_position values(15,9,1,0,0,1,default);

--Законченность заказов
insert into fulfil_orders values(1,2,'13.10.23',100,1000);
insert into fulfil_orders values(2,2,'13.10.23',100,1000);
insert into fulfil_orders values(3,2,'13.10.23',100,1000);
insert into fulfil_orders values(7,4,'19.10.23',100,1000);
insert into fulfil_orders values(8,7,'22.10.23',100,1000);
insert into fulfil_orders values(9,7,'22.10.23',100,1000);
insert into fulfil_orders values(10,9,'13.11.23',100,1000);
insert into fulfil_orders values(11,10,'13.10.23',100,1000);
insert into fulfil_orders values(12,10,'13.10.23',100,1000);
insert into fulfil_orders values(13,10,'13.10.23',100,1000);
insert into fulfil_orders values(15,10,'13.10.23',100,1000);

--Заказы на поставку
insert into supply_orders values (default,1,default,'12.11.23',default,default);
insert into supply_orders values (default,2,default,'12.11.23',default,default);
insert into supply_orders values (default,3,default,'14.11.23',default,default);
insert into supply_orders values (default,10,default,'15.11.23',default,default);
insert into supply_orders values (default,12,default,'12.11.23',default,default);
insert into supply_orders values (default,9,default,'12.11.23',default,default);

--Позиции поставки
insert into sup_orders_cons values (1,2,'09.11.23',default,100,0,default);
insert into sup_orders_cons values (1,3,'11.11.23',default,10,0,default);
insert into sup_orders_cons values (1,4,'13.11.23',default,30,0,default);
insert into sup_orders_cons values (2,5,'9.11.23',default,40,0,default);
insert into sup_orders_cons values (3,6,'9.11.23',default,50,0,default);
insert into sup_orders_cons values (3,3,'9.11.23',default,60,0,default);
insert into sup_orders_cons values (4,2,'9.11.23',default,70,0,default);
insert into sup_orders_cons values (4,1,'9.11.23',default,80,0,default);
insert into sup_orders_cons values (4,4,'9.11.23',default,30,0,default);
insert into sup_orders_cons values (5,5,'9.11.23',default,20,0,default);
insert into sup_orders_cons values (5,6,'9.11.23',default,100,0,default);


insert into center_orders values(default,1,'13.12.23',default,default);
insert into center_orders values(default,8,'14.12.23',default,default);
