--Запрос 1 +
create or replace function place_count(r in numeric,typeid in numeric)
return numeric
as
est_count PLS_INTEGER:=0;
begin
    select count(*) into est_count from (select est_id,type_id,CONNECT_BY_ROOT est_id as Root 
            from establishments est
            connect by prior est_id=boss_est_id
            start with est.type_id=typeid) t1 inner join establishment_type on t1.type_id=establishment_type.type_id where establishment_type.type_name in ('Филиал','Киоск','Главный офис') and root=r;
    return est_count;
end;
/
create or replace procedure Quest_1
as
curs SYS_REFCURSOR:=null;
e_i Number:=0;
e_n varchar2(32767):=null;
e_adr varchar2(32767):=null;
t_name varchar2(32767):=null;
b_est_id Number:=0;
pl_count Number:=0;
begin
DBMS_OUTPUT.put_line('id Заведения|Название заведения|Адрес заведения|Название типа заведения|id Заведени выше по иерархии|Количество пунктов приема заказов');
open curs for select est_id, est_name, est_address,type_name,boss_est_id,place_count(est_id,establishments.type_id) place_count
        from establishments inner join establishment_type on establishments.type_id=establishment_type.type_id where type_name in ('Филиал','Киоск','Главный офис'); 
loop
    fetch curs into e_i,e_n,e_adr,t_name,b_est_id,pl_count;
    exit when curs%NOTFOUND;
    DBMS_OUTPUT.put_line(e_i||'|'||e_n||'|'||e_adr||'|'||t_name||'|'||b_est_id||'|'||pl_count);
end loop;
end;      
/
exec quest_1();

--Запрос 2 +
create or replace procedure quest2(estid in number,start_d in timestamp,end_d in timestamp)
as
est_count SYS_REFCURSOR;
ord_i float:=0;
est_i float:=0;
cust_i float:=0;
express_o float:=0;
st_date timestamp:=null;
nom_i float:=0;
nom_n varchar2(32767):=null;
ord_c float:=0;
s_date timestamp:=null;
e_date timestamp:=null;
begin
    if start_d is null then
        select min(start_date) into s_date from orders;
    else
        s_date:=start_d;
    end if;
    if end_d is null then
        select max(start_date) into e_date from orders;
    else
        e_date:=end_d;
    end if;
    DBMS_OUTPUT.put_line('id заказа'||'|'||'id принявшего заведения'||'|'||'id заказчика'||'|'||'Срочность заказа'||'|'||'Дата поступления заказа'||'|Количество заказов на фотоработы связанных с этим заведением');
    open est_count for with mt as (select order_id,est_id,customer_id,express_ord,start_date,nom_name,t2.nomenclature_id nom_id from orders t1 inner join order_position t2 on t1.export_record_id=t2.order_record_id inner join nomenclature on t2.nomenclature_id=nomenclature.nomenclature_id where t1.est_id in (select estid from establishments union select est_id
            from establishments
            connect by prior est_id=boss_est_id
            start with boss_est_id=estid) and start_date>=s_date and start_date<=e_date and photo_work=1)
    select order_id,est_id,customer_id,express_ord,start_date,(select count(order_id) from (select distinct order_id from mt)) from mt group by order_id,est_id,customer_id,express_ord,start_date having count(*)>0;
    loop
        fetch est_count into ord_i,est_i,cust_i,express_o,st_date,ord_c;
        exit when est_count%NOTFOUND;
        DBMS_OUTPUT.put_line(ord_i||'|'||est_i||'|'||cust_i||'|'||express_o||'|'||st_date||'|'||ord_c);
    end loop;    
end;
/
exec quest2(2,'13.10.23','14.10.23');

--Запрос 3 +
create or replace procedure quest3(estid in number,start_d in timestamp,end_d in timestamp)
as
est_count SYS_REFCURSOR;
ord_i float:=0;
est_i float:=0;
cust_i float:=0;
express_o float:=0;
st_date timestamp:=null;
nom_i float:=0;
nom_n varchar2(32767):=null;
ord_c float:=0;
s_date timestamp:=null;
e_date timestamp:=null;
begin
    if start_d is null then
        select min(start_date) into s_date from orders;
    else
        s_date:=start_d;
    end if;
    if end_d is null then
        select max(start_date) into e_date from orders;
    else
        e_date:=end_d;
    end if;
    DBMS_OUTPUT.put_line('id заказа'||'|'||'id принявшего заведения'||'|'||'id заказчика'||'|'||'Срочность заказа'||'|'||'Дата поступления заказа'||'id Фотоработы|Название фотоработы'||'|Раздельное количество заказов на фотоработу');
    open est_count for with mt as (select order_id,est_id,customer_id,express_ord,start_date,nomenclature.nomenclature_id nom_id,nom_name from orders t1 inner join order_position t2 on t1.export_record_id=t2.order_record_id inner join nomenclature on t2.nomenclature_id=nomenclature.nomenclature_id 
    where t1.est_id in (
                select estid from establishments union select est_id
                from establishments
                connect by prior est_id=boss_est_id
                start with boss_est_id=estid) 
            and start_date>=s_date and start_date<=e_date and photo_work=1)
    select order_id,est_id,customer_id,t3.express_ord,start_date,mt.nom_id,nom_name,order_count from mt inner join (select nom_id,express_ord,count(order_id) as order_count from mt group by nom_id,express_ord) t3 on mt.nom_id=t3.nom_id and mt.express_ord=t3.express_ord;
    loop
        fetch est_count into ord_i,est_i,cust_i,express_o,st_date,nom_i,nom_n,ord_c;
        exit when est_count%NOTFOUND;
        DBMS_OUTPUT.put_line(ord_i||'|'||est_i||'|'||cust_i||'|'||express_o||'|'||st_date||'|'||nom_i||'|'||nom_n||'|'||ord_c);
    end loop;    
end;
/    
exec quest3(1,'12.10.23','14.10.23');

--Запрос 4
create or replace procedure quest4(estid in number,start_d in timestamp,end_d in timestamp)
as
est_count SYS_REFCURSOR;
est_i number:=0;
nom_i number:=0;
nom_n varchar2(32767):=null;
expr_ord number:=0;
reve float:=0;
s_date timestamp:=null;
e_date timestamp:=null;
begin
    if start_d is null then
        select min(start_date) into s_date from orders;
    else
        s_date:=start_d;
    end if;
    if end_d is null then
        select max(start_date) into e_date from orders;
    else
        e_date:=end_d;
    end if;
    DBMS_OUTPUT.put_line('id Заведения|id фотоработы|название фотоработы|срочность заказа|выручка');
    open est_count for 
    with mt as (select order_id,est_id,customer_id,express_ord,start_date,t2.total_cost,nomenclature.nomenclature_id nom_id,nom_name from orders t1 inner join order_position t2 on t1.export_record_id=t2.order_record_id inner join nomenclature on t2.nomenclature_id=nomenclature.nomenclature_id 
        where t1.est_id in (
                    select estid from establishments union select est_id
                    from establishments
                    connect by prior est_id=boss_est_id
                    start with boss_est_id=estid) 
                and start_date>=s_date and start_date<=e_date and photo_work=1),
        mt2 as (select order_id,est_id,personal_discount_use,partners.discount discount,express_ord from orders inner join partners on partners.partner_id=orders.customer_id where est_id in (
                        select estid from establishments union select est_id
                        from establishments
                        connect by prior est_id=boss_est_id
                        start with boss_est_id=estid)),
        mt3 as (select mt.est_id,nom_id,nom_name,mt.express_ord,sum(mt.total_cost*(1+mt2.express_ord)*(1-mt2.personal_discount_use*mt2.discount/100)) as Revenue from mt inner join mt2 on mt2.order_id=mt.order_id and mt2.est_id=mt.est_id group by nom_id,mt.est_id,nom_name,mt.express_ord)
        select * from mt3 where est_id!=estid union select estid,nom_id,nom_name,express_ord,sum(Revenue) from mt3 group by nom_id,nom_name,express_ord; 
    loop
        fetch est_count into est_i,nom_i,nom_n,expr_ord,reve;
        exit when est_count%NOTFOUND;
        DBMS_OUTPUT.put_line(est_i||'|'||nom_i||'|'||nom_n||'|'||expr_ord||'|'||reve);
    end loop;    
end;
/
exec quest4(1,'13.10.23','14.10.23');




--Запрос 5 +
create or replace procedure quest5(estid in number,start_d in timestamp,end_d in timestamp)
as
est_count SYS_REFCURSOR;
est_i float:=0;
est_n varchar2(32767):=null;
est_ad varchar2(32767):=null;
express_o float:=0;
ord_c float:=0;
total_c float:=0;
type_id float:=0;
s_date timestamp:=null;
e_date timestamp:=null;
begin
    if start_d is null then
        select min(start_date) into s_date from orders;
    else
        s_date:=start_d;
    end if;
    if end_d is null then
        select max(start_date) into e_date from orders;
    else
        e_date:=end_d;
    end if;
    DBMS_OUTPUT.put_line('id заведения|название заведения|адрес заведения|срочность заказов|количество фотографий по введенному заведению|количество фотографий в этом заведении');
    open est_count for with mt as (select order_id,t3.est_id,t3.est_name,t3.est_address,t3.type_id,express_ord,t2.count_of_position from orders t1 inner join order_position t2 on t1.export_record_id=t2.order_record_id  inner join establishments t3 on t1.est_id=t3.est_id
    where t1.est_id in (
                select estid from establishments union select est_id
                from establishments
                connect by prior est_id=boss_est_id
                start with boss_est_id=estid) 
            and start_date>=s_date and start_date<=e_date and photo_print=1)
    select est_id,est_name,est_address,type_id,t1.express_ord,p1,p2 from (select est_id,est_name,est_address,type_id,mt.express_ord, sum(count_of_position) p1 from mt group by est_id,est_name,est_address,type_id,express_ord) t2 inner join (select express_ord,sum(count_of_position) p2 from mt group by express_ord) t1 on t2.express_ord=t1.express_ord ;
 
    loop
        fetch est_count into est_i,est_n,est_ad,type_id,express_o,total_c,ord_c;
        exit when est_count%NOTFOUND;
        DBMS_OUTPUT.put_line(est_i||'|'||est_n||'|'||est_ad||'|'||type_id||'|'||express_o||'|'||total_c||'|'||ord_c);
    end loop;    
end;
/
exec quest5(2,'12.10.23',null);

--Запрос 6+
create or replace procedure quest6(estid in number,start_d in timestamp,end_d in timestamp)
as
est_count SYS_REFCURSOR;
est_i float:=0;
est_n varchar2(32767):=null;
est_ad varchar2(32767):=null;
express_o float:=0;
ord_c float:=0;
total_c float:=0;
s_date timestamp:=null;
e_date timestamp:=null;
begin
    if start_d is null then
        select min(start_date) into s_date from orders;
    else
        s_date:=start_d;
    end if;
    if end_d is null then
        select max(start_date) into e_date from orders;
    else
        e_date:=end_d;
    end if;
    DBMS_OUTPUT.put_line('id заведения|название заведения|адрес заведения|срочность заказов|количество проявленных пленок в этом заведении|Общее количество проявленных пленок');
    open est_count for with mt as (select order_id,t3.est_id,t3.est_name,t3.est_address,express_ord from orders t1 inner join order_position t2 on t1.export_record_id=t2.order_record_id  inner join establishments t3 on t1.est_id=t3.est_id inner join nomenclature t4 on t4.nomenclature_id=t2.nomenclature_id 
    where t1.est_id in (
                select estid from establishments union select est_id
                from establishments
                connect by prior est_id=boss_est_id
                start with boss_est_id=estid) 
            and start_date>=s_date and start_date<=e_date and nom_name='Проявка пленки'),
    mt2 as (select est_id,est_name,est_address,express_ord,count(*) p from mt group by est_id,est_name,est_address,express_ord)
    select est_id,est_name,est_address,mt2.express_ord,p,p2 from mt2 inner join (select express_ord,sum(p) p2 from mt2 group by express_ord) t1 on mt2.express_ord=t1.express_ord;
 
    loop
        fetch est_count into est_i,est_n,est_ad,express_o,ord_c,total_c;
        exit when est_count%NOTFOUND;
        DBMS_OUTPUT.put_line(est_i||'|'||est_n||'|'||est_ad||'|'||express_o||'|'||ord_c||'|'||total_c);
    end loop;    
end;
/
exec quest6(1,'13.10.23',null);


--Запрос 9
create or replace procedure quest9(estid in number,start_d in timestamp,end_d in timestamp)
as
est_count SYS_REFCURSOR;
est_i number:=0;
cons_a varchar2(32767):=null;
cons_n varchar2(32767):=null;
creator_i number:=0;
reve float:=0;
s_date timestamp:=null;
e_date timestamp:=null;
begin
    if start_d is null then
        select min(start_date) into s_date from orders;
    else
        s_date:=start_d;
    end if;
    if end_d is null then
        select max(start_date) into e_date from orders;
    else
        e_date:=end_d;
    end if;
    DBMS_OUTPUT.put_line('id заведения|артикул товара|название товара|id производителя|выручка');
    open est_count for with mt as (select t1.est_id,est_name,est_address,t2.total_cost,nomenclature.nomenclature_id nom_id,nomenclature.consumable_articul,order_id from orders t1 inner join order_position t2 on t1.export_record_id=t2.order_record_id inner join nomenclature on t2.nomenclature_id=nomenclature.nomenclature_id inner join establishments on t1.est_id=establishments.est_id
        where t1.est_id in (
                    select estid from establishments union select est_id
                    from establishments
                    connect by prior est_id=boss_est_id
                    start with boss_est_id=estid) 
                and start_date>=s_date and start_date<=e_date and sold_without_service=1),

        mt2 as (select order_id,est_id,personal_discount_use,partners.discount discount,express_ord from orders inner join partners on partners.partner_id=orders.customer_id where est_id in (
                    select estid from establishments union select est_id
                    from establishments
                    connect by prior est_id=boss_est_id
                    start with boss_est_id=estid)),
        mt3 as (select mt.est_id,nom_id,consumable_articul,sum(mt.total_cost*(1+mt2.express_ord)*(1-mt2.personal_discount_use*mt2.discount/100)) as Revenue from mt inner join mt2 on mt2.order_id=mt.order_id and mt2.est_id=mt.est_id group by nom_id,mt.est_id,consumable_articul)
        select est_id,t1.consumable_articul,consumable_name,creator_id,revenue from (select * from mt3 where est_id!=estid union select estid,nom_id,consumable_articul,sum(Revenue) from mt3 group by nom_id,consumable_articul) t1 inner join consumables on t1.consumable_articul=consumables.consumable_articul;
    
    loop
        fetch est_count into est_i,cons_a,cons_n,creator_i,reve;
        exit when est_count%NOTFOUND;
        DBMS_OUTPUT.put_line(est_i||'|'||cons_a||'|'||cons_n||'|'||creator_i||'|'||reve);
    end loop;    
end;
/
exec quest9(8,'12.10.23','15.11.23');


--Запрос 10+
create or replace procedure quest_10(estid in numeric)
as
curs SYS_REFCURSOR;
est_i number:=0;
est_n varchar2(32767):=null;
est_a varchar2(32767):=null;
type_i number:=0;
count_of_est float:=0;
cons_articul varchar2(32767):=null;
cons_name varchar2(32767):=null;
creator_i number :=0;
indiv number:=0;
begin
open curs for with mt as (select est_id,nomenclature_id,sum(count_of_position) as p from order_position inner join orders on export_record_id=order_record_id  
            where est_id in 
                (select estid from establishments union select est_id
                    from establishments
                    connect by prior est_id=boss_est_id
                    start with boss_est_id=estid)
                and sold_without_service=1 group by est_id,nomenclature_id),
    mt2 as (select mt.est_id,establishments.est_name,establishments.est_address,establishments.type_id,mt.nomenclature_id,p from mt inner join establishments on mt.est_id=establishments.est_id inner join nomenclature on mt.nomenclature_id=nomenclature.nomenclature_id where mt.p in (select max(p) from mt where mt.est_id=est_id group by mt.est_id)),
    mt3 as (select * from mt2 union (select est_id,est_name,est_address,type_id,nomenclature_id,p1 from (select nomenclature_id,sum(p) p1 from mt2 group by nomenclature_id),establishments where p1=(select max(p1) from (select nomenclature_id,sum(p) p1 from mt2 group by nomenclature_id)) and est_id=estid)) 
    select mt3.est_id,mt3.est_name,mt3.est_address,mt3.type_id,mt3.p,consumables.consumable_articul,consumable_name,partner_id,partners.individual from mt3 inner join nomenclature t1 on t1.nomenclature_id=mt3.nomenclature_id inner join consumables on t1.consumable_articul=consumables.consumable_articul inner join partners on partners.partner_id=consumables.creator_id;

DBMS_OUTPUT.put_line('id Заведения|Название заведение|id типа|количество товара|артикул|название товара|id производителя|физлицо?');
loop
    fetch curs into est_i,est_n,est_a,type_i,count_of_est,cons_articul,cons_name,creator_i,indiv;
    exit when curs%NOTFOUND;
    DBMS_OUTPUT.put_line(est_i||'|'||est_n||'|'||est_a||'|'||type_i||'|'||count_of_est||'|'||cons_articul||'|'||cons_name||'|'||creator_i||'|'||indiv);
end loop;
close curs;
end;    
/
exec quest_10(1);
    
--Запрос 11 +
create or replace procedure quest11(estid in number,start_d in timestamp,end_d in timestamp)
as
est_count SYS_REFCURSOR;
est_i float:=0;
est_n varchar2(32767):=null;
est_ad varchar2(32767):=null;
express_o varchar2(32767):=null;
ord_c float:=0;
total_c float:=0;
s_date timestamp:=null;
e_date timestamp:=null;
begin
    if start_d is null then
        select min(start_date) into s_date from orders;
    else
        s_date:=start_d;
    end if;
    if end_d is null then
        select max(start_date) into e_date from orders;
    else
        e_date:=end_d;
    end if;
    DBMS_OUTPUT.put_line('id заведения|название заведения|адрес заведения|название товара|количество товара|Количество товара по всей иерархии');
    open est_count for with mt as (select order_id,t3.est_id,t3.est_name,t3.est_address,t2.nomenclature_id nom_id,t2.count_of_position from orders t1 inner join order_position t2 on t1.export_record_id=t2.order_record_id  inner join establishments t3 on t1.est_id=t3.est_id
    where t1.est_id in (
                select estid from establishments union select est_id
                from establishments
                connect by prior est_id=boss_est_id
                start with boss_est_id=estid) 
            and start_date>=s_date and start_date<=e_date and sold_without_service=1),
    mt2 as (select est_id,est_name,est_address,nomenclature.nom_name,nomenclature_id,s1 from (select est_id,est_name,est_address,nom_id,sum(count_of_position) as s1 from mt group by est_id,est_name,est_address,nom_id) t1 inner join nomenclature on t1.nom_id=nomenclature.nomenclature_id)
    select est_id,est_name,est_address,mt2.nom_name,mt2.s1,t1.s2 from mt2 inner join (select nomenclature_id,sum(s1) s2 from mt2 group by nomenclature_id) t1 on mt2.nomenclature_id=t1.nomenclature_id;
 
    loop
        fetch est_count into est_i,est_n,est_ad,express_o,ord_c,total_c;
        exit when est_count%NOTFOUND;
        DBMS_OUTPUT.put_line(est_i||'|'||est_n||'|'||est_ad||'|'||express_o||'|'||ord_c||'|'||total_c);
    end loop;    
end;
/
exec quest11(9,'12.10.23','12.11.23');

--Запрос 12+
create or replace procedure Quest_12(center_id in numeric,prof_name in varchar2)
as
prof_id Number:=0;
curs SYS_REFCURSOR:=null;
work_numb Number:=0;
e_i number:=null;
s_date date:=null;
pr_id number:=null;
b_est_id Number:=0;
sal float:=0;
begin
DBMS_OUTPUT.put_line('Табельный номер сотрудника|id Места работы|Дата начала работы|id Профиля работы|id записи начальника|Зарплата');
if prof_name!='-1' then
    select profile_id into prof_id from worker_profiles where profile_name=prof_name;
    open curs for select personal_number,est_id,start_date,profile_id,boss_record,salary from workers_est where est_id in (select est_id 
            from establishments
            connect by prior est_id=boss_est_id
            start with boss_est_id=center_id union select center_id from establishments) and profile_id=prof_id and end_date is null; 
else
    open curs for select personal_number,est_id,start_date,profile_id,boss_record,salary from workers_est where est_id in (select est_id 
            from establishments
            connect by prior est_id=boss_est_id
            start with boss_est_id=center_id union select center_id from establishments) and end_date is null; 

end if;
loop
    fetch curs into work_numb,e_i,s_date,pr_id,b_est_id,sal;
    exit when curs%NOTFOUND;
    DBMS_OUTPUT.put_line(work_numb||'|'||e_i||'|'||s_date||'|'||pr_id||'|'||b_est_id||'|'||sal);
end loop;
close curs;
end;      
/
exec quest_12(8,'-1');
