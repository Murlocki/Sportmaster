--Триггер на удаление из таблицы профили работы
create or replace trigger worker_profile_fil before delete on worker_profiles
for each row
    declare 
        workplace_count PLS_INTEGER :=0;
        work_place_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into work_place_count from workers_est where profile_id = :old.profile_id;
    if work_place_count > 0 then
        raise_application_error(-20001, 'Есть зависимые записи в таблице Места работы(workers_est) ' || (work_place_count));
    end if;
end worker_profile_fil;
/

--Триггеры типов заведений
--Триггер на удаление из таблицы тип заведения
create or replace trigger est_type_delete before delete on establishment_type
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  establishments where type_id = :old.type_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть зависимые записи в таблице Заведения(establishments) ' || (est_count));
    end if;
end est_type_delete;
/

--Триггеры заведений
--Триггеры на добавление и обновление
create or replace trigger ests_change before update or insert on establishments
for each row
    declare 
        est_count PLS_INTEGER :=null;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  establishment_type where type_id = :new.type_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного типа заведения');
    end if;
end ests_change;
/
--Триггер на удаление
create or replace trigger ests_delete before delete on establishments
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  establishments where boss_est_id = :old.est_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть записи в таблице Заведения(establishments): '|| est_count);
    end if;
    select count(*) into est_count from  workers_est where est_id = :old.est_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть записи в таблице Место работы(workers_est): '|| est_count);
    end if;
    select count(*) into est_count from  orders where est_id = :old.est_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть записи в таблице Заказы(orders): '|| est_count);
    end if;
    select count(*) into est_count from  discount_cards where est_id = :old.est_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть записи в таблице Дисконтные карты(discount_cards): '|| est_count);
    end if;
    select count(*) into est_count from  center_orders where center_id = :old.est_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть записи в таблице Общие заказы фотоцентра(center_orders): '|| est_count);
    end if;
    select count(*) into est_count from  supply_orders where est_id = :old.est_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть записи в таблице Заказы на поставку(supply_orders): '|| est_count);
    end if;
end ests_delete;
/



--Триггеры на партнера
--Триггер на изменение партнера
create or replace trigger partners_change before update on partners
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    if :new.individual = 1 then
        delete from legal_entities where partner_id=:new.partner_id;
    elsif :new.individual = 0 then
        delete from clients where partner_id=:new.partner_id;
    end if;
end partners_change;
/
--Триггер на удаление партнера
create or replace trigger partners_delete before delete on partners
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from orders where customer_id = :old.partner_id;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Есть зависмые записи в таблице Заказы(orders):'||est_count);
    end if;
    select count(*) into est_count from clients where partner_id = :old.partner_id;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Есть зависмые записи в таблице Клиенты(clients):'||est_count);
    end if;
    select count(*) into est_count from legal_entities where partner_id = :old.partner_id;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Есть зависмые записи в таблице Юр-лица(legal_entities):'||est_count);
    end if;
    select count(*) into est_count from discount_cards where partner_id = :old.partner_id;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Есть зависмые записи в таблице Дисконтные карты(discount_cards):'||est_count);
    end if;
    select count(*) into est_count from cons_prov where provider_id = :old.partner_id;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Есть зависмые записи в таблице Расходные материалы_Поставщик(cons_prov):'||est_count);
    end if;
    select count(*) into est_count from consumables where creator_id = :old.partner_id;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Есть зависмые записи в таблице Расходные материалы и товары(consumables):'||est_count);
    end if;
end partners_delete;
/

--Триггеры на таблицу клиенты(Clients)
--Триггер на добавление или обновление
create or replace trigger clients_change before update or insert on clients
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from partners where partner_id=:new.partner_id and individual = 0;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Запись должна быть в таблице Юр-лица(legal_entities)');
    end if;
end clients_change;
/

--Триггеры на таблицу Юр-лица(Legal_entities)
--Триггер на добавление или обновление
create or replace trigger legal_entities_change before update or insert on legal_entities
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from partners where partner_id=:new.partner_id and individual = 1;
    if est_count>0 then
        RAISE_APPLICATION_ERROR(-20001, 'Запись должна быть в таблице Клиенты(Clients)');
    end if;
end legal_enteties_change;
/


--Триггеры на таблицу дисконтные карты(discount_cards)
--Триггеры на изменения карты
create or replace trigger card_change before insert or update on discount_cards
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  partners where partner_id = :new.partner_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Отсутствует указанный владелец');
    end if;
    select count(*) into est_count from  establishments where est_id = :new.est_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Отсутствует указанное заведения');
    end if;
end card_change;
/
--Триггеры на удаления карты
create or replace trigger card_delete before delete on discount_cards
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  orders where card_record_id = :old.export_record_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть зависимость в таблице Заказы(Orders):'||est_count);
    end if;
end card_delete;
/

--Триггеры таблицы Расходные материалы
--Триггер удаления
create or replace trigger consumables_delete before delete on consumables
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  extra_char_const where consumable_articul = :old.consumable_articul;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть зависимость в таблице Материал_характеристика(extra_char_const):'||est_count);
    end if;
    select count(*) into est_count from  cons_prov where consumable_articul = :old.consumable_articul;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть зависимость в таблице Расходные материалы_поставщик(cons_prov):'||est_count);
    end if;
    select count(*) into est_count from  nomenclature where consumable_articul = :old.consumable_articul;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть зависимость в таблице Номенклатура(nomenclature):'||est_count);
    end if;
end consumables_delete;
/
--Триггер изменения
create or replace trigger consumables_change before insert or update on consumables
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  partners where partner_id = :new.creator_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного производителя в таблицу Partners(Партненры)');
    end if;
end consumables_change;
/

--Триггеры таблицы Доп характеристика вех материалов и товаров
--Триггер удаления
create or replace trigger all_extra_char_delete before delete on all_extra_char
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  extra_char_const where char_id = :old.char_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть зависимые записи в таблице Материал_характеристики(all_extra_char):'||est_count);
    end if;
end all_extra_char_delete;
/

--Триггеры таблицы Материал_характеристика
--Триггер изменения
create or replace trigger extra_char_const_change before insert or update on extra_char_const
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  all_extra_char where char_id = :new.char_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанной характеристики в таблице all_extra_char');
    end if;
    select count(*) into est_count from  consumables where consumable_articul = :new.consumable_articul;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного товара в таблице Расходные материалы(consumables)');
    end if;
end all_extra_char_change;
/

--Триггеры таблицы Расходные материалы_поставщик
--Триггер удаления
create or replace trigger cons_prov_delete before delete on cons_prov
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  sup_orders_cons where record_id = :old.export_record_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Есть зависимые записи в таблице Заказы на поставку_материалы(sup_orders_cons):'||est_count);
    end if;
end cons_prov_delete;
/
--Триггер изменения
create or replace trigger cons_prov_change before insert or update on cons_prov
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  consumables where consumable_articul = :new.consumable_articul;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного материала в таблице Расходные материалы(consumables)');
    end if;
    select count(*) into est_count from  partners where partner_id = :new.provider_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного поставщика в таблице Партнеры(partners)');
    end if;
end cons_prov_change;
/





--Триггеры Заказы на поставку
--Триггер изменения

--Функция перерассчета центрального заказа
create or replace procedure center_order_total_cost(new_center_order_id in numeric,old_center_order_id in numeric,new_pos_cost in float,old_pos_cost in float)
as 
total float:=0;
est_count float:=0;
begin
    DBMS_OUTPUT.put_line(old_pos_cost||new_pos_cost);
    if old_center_order_id is not null then
        update center_orders set center_order_total_cost=center_order_total_cost-old_pos_cost where order_id=old_center_order_id; 
    end if;
    if new_center_order_id is not null then
        update center_orders set center_order_total_cost=center_order_total_cost+new_pos_cost where order_id=new_center_order_id; 
    end if;
end;
/

create or replace trigger supply_change before insert or update on supply_orders
for each row
    declare 
        est_count float :=0;
        est_count1 float:=0;
        est_date date :=null;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    if :old.center_order is not null then
        select Root into est_count from (select est_id,CONNECT_BY_ROOT est_id as Root from establishments connect by prior est_id=boss_est_id start with boss_est_id is null) where est_id=:old.est_id;
        select center_id into est_count1 from center_orders where order_id=:old.center_order;
        if est_count!=est_count1 then
            raise_application_error(-20001, 'Заказ привязан к неправильному фотоцентру');
        end if;
    end if;
    select count(*) into est_count from  center_orders where order_id = :new.center_order;
    if est_count = 0 and :new.center_order is not null then
        raise_application_error(-20001, 'Нет указанного центрального заказа на поставку');
    end if;
    select count(*) into est_count from  establishments where est_id = :new.est_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного заведения');
    end if;
    if :new.end_date<:new.start_date and :new.end_date is not null then
        raise_application_error(-20001, 'Неверная дата завершения заказа');
    end if;
    if :old.end_date is not null and updating then
        raise_application_error(-20001, 'Заказ на поставку закрыт. Его нельзя изменять');
    end if;
    select count(*) into est_count from center_orders where order_id = :old.center_order and end_date is not null;
    if est_count>0 then
        raise_application_error(-20001, 'Центральный заказ закрыт. Изменение информации о нем запрещено');
    end if;
    if inserting then
        center_order_total_cost(:new.center_order,null,:new.total_cost,0);
    end if;
    if updating then
        center_order_total_cost(:new.center_order,:old.center_order,:new.total_cost,:old.total_cost);
        
    end if;
end;
/
create or replace trigger supply_delete before delete on supply_orders
for each row
declare
    est_count float:=0;
begin
    if :old.end_date is not null then
        raise_application_error(-20001, 'Привязан к закрытому заказу');
    end if;
    center_order_total_cost(null,:old.center_order,null,:old.total_cost);
end;
/





--Триггеры общие заказы фотоцентра
create or replace trigger center_order_delete before delete on center_orders
for each row
declare
    est_count float:=0;
begin
    if :old.end_date is not null then
        raise_application_error(-20001, 'Заказ закрыт');
    end if;
    select count(*) into est_count from supply_orders where center_order=:old.order_id;
    if est_count>0 then
        raise_application_error(-20001, 'К центральному заказу привязаны заказы на поставку');
    end if;
end;
/

create or replace trigger center_order_update before insert or update on center_orders
for each row
declare
    est_count float:=0;
begin
    if :old.end_date is not null and updating then
        raise_application_error(-20001, 'Заказ закрыт');
    end if;
    if :new.start_date > :new.end_date and :new.end_date is not null then
        raise_application_error(-20001, 'Неверная дата закрытия заказа');
    end if;
    select count(*) into est_count from establishments where est_id=:new.center_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет нужного заведения');
    end if;
end;
/

--Триггеры Заказы-поставки материалы
--Функция перерассчета заказа-поставки материалы
create or replace Function supply_order_total_cost(orderid in numeric,this_cons_id in numeric,pos_cost in float) 
return float
As
est_count float:=0;
begin
    select sum(total_cost) into est_count from sup_orders_cons where order_id=orderid and record_id!=this_cons_id;
    if est_count is null then
        est_count:=0;
    end if;
    est_count:=est_count+pos_cost;
    if est_count<0 then
        est_count:=0;
    end if;
    return est_count;
end;
/

--Перерасчет позиции
create or replace Function sup_ord_cons_cost(orderid in numeric,count_cons in float)
return float 
as
est_count float:=0;
coef PLS_INTEGER:=1;
coef2 float:=0;
begin
    select cons_cost into est_count from cons_prov where export_record_id=orderid;
    return est_count * count_cons;
end;
/



--Триггер изменения
create or replace trigger sup_orders_cons_change before insert or update on sup_orders_cons
for each row
    declare 
        est_count float :=0;
        est_date date :=null;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    
    select count(*) into est_count from  supply_orders where order_id = :new.order_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного заказа на поставку');
    end if;
    select count(*) into est_count from  cons_prov where export_record_id = :new.record_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного материала на поставку');
    end if;
    if :new.end_date<:new.start_date and :new.end_date is not null then
        raise_application_error(-20001, 'Неверная дата завершения заказа');
    end if;
    if :old.end_date is not null and updating then
        raise_application_error(-20001, 'Позиия уже закрыта.Ее нельзя изменять');
    end if;
    if :new.required_count < :new.acquired_count then
        raise_application_error(-20001, 'Неверно введены значение запрошено(required_count) и получено(acquierd_count)');
    end if;
    if :new.end_date is not null and :old.required_count > :old.acquired_count then
        raise_application_error(-20001, 'Закройте позицию по доставленному товару');
    end if;
    

    select count(*) into est_count from supply_orders where order_id = :old.order_id and end_date is not null;
    if est_count>0 then
        raise_application_error(-20001, 'Заказ на поставку закрыт');
    end if;
    if est_count=0 then
        if inserting then
            est_count:=sup_ord_cons_cost(:new.record_id,:new.required_count);
            :new.total_cost:=est_count;
            est_count:=supply_order_total_cost(:new.order_id,:new.record_id,est_count);
            update supply_orders set total_cost=est_count where order_id=:new.order_id;
        end if;
    end if;
end;
/

create or replace trigger sup_orders_cons_delete before delete on sup_orders_cons
for each row
declare
    est_count float:=0;
begin
    if :old.end_date is not null then
        raise_application_error(-20001, 'Привязан к закрытому заказу');
    end if;
    select total_cost into est_count from supply_orders where order_id=:old.order_id;
    if est_count - :old.total_cost < 0 then
        est_count := 0;
    else
        est_count := est_count - :old.total_cost;
    end if;
    update supply_orders set total_cost=est_count where order_id=:old.order_id;
end;
/





--Триггеры таблицы Вид номенклатуры
--Триггер удаления
create or replace trigger nom_type_delete before delete on nomenclature_type
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  nomenclature where type_id = :old.type_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Присутствуют зависимые записи в таблице Номенклатура(nomenclature):'||est_count);
    end if;
end nom_type_delete;
/

--Триггеры таблицы номенклатура
--Триггер удаления
create or replace trigger nom_delete before delete on nomenclature
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  order_position where nomenclature_id = :old.nomenclature_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Присутствуют зависимые записи в таблице Заказ_позиция(order_position):'||est_count);
    end if;
end nom_delete;
/
--Триггер изменения
create or replace trigger nom_change before insert or update on nomenclature
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  nomenclature_type where type_id = :new.type_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет указанного значения в таблице вид номенклатуры(Nomenclature_type)');
    end if;
    select count(*) into est_count from  consumables where consumable_articul = :new.consumable_articul;
    if est_count = 0 and :new.consumable_articul is not null then
        raise_application_error(-20001, 'Нет указанного значения в таблице Расходные материалы(consumables)');
    end if;
end nom_change;
/


--Триггеры таблицы работников
--Триггер удаления
create or replace trigger workers_delete before delete on workers
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  workers_est where passport_number = :old.passport_number;
    if est_count > 0 then
        raise_application_error(-20001, 'Присутствуют зависимые записи в таблице Место работы(workers_est):'||est_count);
    end if;
end workers_delete;
/

--Триггеры места работы
--Триггер удаления
create or replace trigger workers_est_delete before delete on workers_est
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  workers_est where boss_record = :old.export_record_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Присутствуют зависимые записи в таблице Место работы(workers_est):'||est_count);
    end if;
    select count(*) into est_count from  fulfil_orders where workers_est_record_id = :old.export_record_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Присутствуют зависимые записи в таблице Журнал выполненных заказов(fulfil_orders):'||est_count);
    end if;
end workers_est_delete;
/
--Триггер изменения
create or replace trigger workers_est_change before update or insert on workers_est
for each row
    declare 
        est_count PLS_INTEGER :=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  worker_profiles where profile_id = :new.profile_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Отсутствует указнный профиль в таблице Профиль рабочих мест(workeer_proifles)');
    end if;
    select count(*) into est_count from  workers where passport_number = :new.passport_number;
    if est_count = 0 then
        raise_application_error(-20001, 'Отсутствует указанный работник в таблице Работнки(workers)');
    end if;
    select count(*) into est_count from  establishments where est_id = :new.est_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Отсутствует указанное заведение в таблице Заведения(establishments)');
    end if;
end workers_est_change;
/


--Триггеры Журнал выполненных заказов
create or replace trigger fulfil_orders_change before insert or update on fulfil_orders
for each row
    declare 
        est_count PLS_INTEGER :=0;
        est_count2 PLS_INTEGER :=0;
        est timestamp:=null;
        est1 timestamp:=null;
        est2 timestamp:=null;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  orders where export_record_id = :new.order_record_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Отсутствует указанный заказ в таблице Заказы(orders)');
    end if;
    select count(*) into est_count from workers_est where export_record_id = :new.workers_est_record_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Отсутствует указанный работник в таблице Места работы(workers_est)');
    end if;
    
    select count(*) into est_count from orders where export_record_id=:new.order_record_id;
    if est_count>0 then
        select start_date into est from orders where export_record_id=:new.order_record_id;
        if :new.end_date<est and :new.end_date is not null then
            raise_application_error(-20001, 'Неверная дата завершения заказа');
        end if;
        end if;
    select count(*) into est_count from workers_est where export_record_id=:new.workers_est_record_id;
    if est_count>0 then
        select end_date into est2 from workers_est where export_record_id=:new.workers_est_record_id;
        if est2 is not null and :new.end_date>est2 then
            raise_application_error(-20001, 'Неверный работник для заказа');
        end if;
        end if;
    select est_id into est_count from workers_est where export_record_id = :new.workers_est_record_id;
    select est_id into est_count2 from orders where export_record_id = :new.order_record_id;
    if est_count!=est_count2 then
        raise_application_error(-20001, 'Неверный работник для заказа или неверный заказ');
    end if;
end;
/


--Таблица заказ_позиция
--Триггер изменения
--Процедура перерассчета цены
create or replace Function order_pos_cost(nom_id in numeric,orderid in numeric,b in numeric,photo_print in numeric,count_of_position in numeric)
return float
As
est_count float:=0;
coef PLS_INTEGER:=1;
coef2 float:=0;
begin
    
    select base_cost into est_count from nomenclature where nomenclature_id = nom_id;
    if b=1 then
        coef := 0;
    end if;
    if photo_print=1 then
        coef2:=null;
        select card_record_id into coef2 from orders where export_record_id=orderid;
        if coef2 is not null then
            select discount_percent into coef2 from discount_cards where export_record_id = coef2; 
        else
            coef2:=0;
        end if;
    end if;
    return est_count * count_of_position * coef * (100-coef2)/100;
end;
/

create or replace function order_totalcost(orderid in numeric,this_nom_id in numeric,pos_cost in float) 
return float
As
est_count float:=0;
coef float:=1;
b float:=0;
begin
    select sum(total_cost) into est_count from order_position where order_record_id=orderid and nomenclature_id!=this_nom_id;
    if est_count is null then
        est_count:=0;
    end if;
    select express_ord into b from orders where export_record_id=orderid;
    est_count:=est_count+pos_cost;
    if b !=0 then
        est_count:=est_count*2;
    end if;
    select personal_discount_use into coef from orders where export_record_id=orderid;
    if coef>0 then
        select customer_id into coef from orders where export_record_id=orderid;
        select discount into coef from partners where partner_id=coef;
        b:=coef;
    end if;
    if est_count<0 then
        est_count:=0;
    end if;
    return est_count * (100-b)/100;
end;
/
--Работает
create or replace trigger order_position_change before insert or update on order_position
for each row
    declare 
        cosPos float:=0;
        costPos float:=0;
        est_count PLS_INTEGER :=0;
        est_date timestamp:=null;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from  fulfil_orders where order_record_id=:new.order_record_id;
    if est_count !=0 then
        raise_application_error(-20001, 'Заказ закрыт сделать ничего нельзя');
    end if;
    if est_count =0 and inserting then
        cosPos:=order_pos_cost(:new.nomenclature_id,:new.order_record_id,:new.bought_film_here,:new.photo_print,:new.count_of_position);
        :new.total_cost:=cosPos;
        costPos:=order_totalcost(:new.order_record_id,:new.nomenclature_id,cosPos);
        update orders set total_cost=costPos where export_record_id=:new.order_record_id;
    end if;
    
    select count(*) into est_count from nomenclature where nomenclature_id = :new.nomenclature_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет такой номенклатуры');
    end if;
    select count(*) into est_count from orders where export_record_id = :new.order_record_id;
    if est_count = 0 then
        raise_application_error(-20001, 'Нет такого заказа');
    end if;
end;
/



create or replace trigger order_position_delete before delete on order_position
for each row
    declare 
        est_count PLS_INTEGER :=0;
        est_date float:=0;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from fulfil_orders where order_record_id = :old.order_record_id;
    if est_count > 0 then
        raise_application_error(-20001, 'Заказ закрыт');
    end if;
    est_date:=order_totalcost(:old.order_record_id,:old.nomenclature_id,0);
    update orders set total_cost=est_date where export_record_id=:old.order_record_id;
end;
/



--Триггеры для таблицы Заказы
create or replace trigger order_delete before delete on orders
for each row
    declare 
        est_count PLS_INTEGER :=0;
        est_date timestamp:=null;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from fulfil_orders where order_record_id = :old.export_record_id;
    if est_count>0 then
        raise_application_error(-20001, 'Есть зависимости в таблице выполненные заказы(fulfil_orders):'||est_count);
    end if;
    select count(*) into est_count from order_position where order_record_id = :old.export_record_id;
    if est_count>0 then
        raise_application_error(-20001, 'Есть зависимости в таблице Заказы_позиция(order_position):'||est_count);
    end if;
end;
/
--Работает
create or replace trigger order_change before insert or update on orders
for each row
    declare 
        est_count PLS_INTEGER :=0;
        est_date timestamp:=null;
        delete_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT (delete_exception, -20001);
begin
    select count(*) into est_count from establishments where est_id = :new.est_id;
    if est_count=0 then
        raise_application_error(-20001, 'Нет указанного заведения');
    end if;
    select count(*) into est_count from partners where partner_id = :new.customer_id;
    if est_count=0 then
        raise_application_error(-20001, 'Нет указанного партнера');
    end if;
    
    select root into est_count from (
            select est_id,type_id,boss_est_id,est_name, CONNECT_BY_ROOT est_id as Root 
            from establishments
            connect by prior est_id=boss_est_id
            start with boss_est_id is null
        )
        where est_id=:new.est_id;
    
    if :new.card_record_id is not null then
        select count(*) into est_count from discount_cards where est_id = est_count and export_record_id=:new.card_record_id;
        if est_count=0 then
            raise_application_error(-20001, 'Карта другого заведения');
        end if;
    end if;
end;
