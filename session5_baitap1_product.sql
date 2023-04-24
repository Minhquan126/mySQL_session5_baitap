create database product;
use product;
create table product(
id varchar(50),
productCode int,
productName varchar(50),
productPrice float,
productAmount int,
productDescription text,
productStatus bit
);
insert into product(id,productCode,productName,productPrice,productAmount,productDescription,productStatus) values
("1",1,"kia morning",800,20,"xe dich vu",1),
("2",2,"camry",2500,20,"xe sang trong",1),
("3",3,"land cuise",4000,20,"xe cho sep",1),
("4",4,"mayback",5000,20,"xe cua doanh nha",1),
("5",5,"fadil",400,20,"xe cua dai gia",1);
-- bước 3 : tạo index
alter table product add index idx_code(productCode);
alter table product drop index idx_code;
alter table product add unique index idx_code(productCode);
alter table product add index idx_product(productName,productPrice);
select * from product where productCode = 2;
-- bước 4 : tạo,thao tác với view
create view view_product as
select productCode,productName,productPrice,productStatus
from product;
select * from view_product;
update view_product set productStatus = 0 where productCode = 3 or productCode = 4 or productCode = 5;
drop view view_product;
-- bước 5 : tạo procedure
-- show product
delimiter //
create procedure proc_showProduct()
begin
select * from product;
end
//delimiter ;
-- thêm sản phẩm
delimiter //
create procedure proc_create_product(
in id varchar(50), productCode int,productName varchar(50),productPrice float,productAmount int,productDescription text,productStatus bit
)
begin
insert into product value (id,productCode,productName,productPrice,productAmount,productDescription,productStatus);
end
//delimiter ;
call proc_create_product("6",6,"lexus",10000,20,"xe cua quan",1);
-- sửa thông tin sản phẩm
delimiter //
create procedure proc_update_product(
in idUpdate varchar(50), productCode int,productName varchar(50),productPrice float,productAmount int,productDescription text,productStatus bit
)
begin
delete from product where id = idUpdate;
call proc_create_product(idUpdate,productCode,productName,productPrice,productAmount,productDescription,productStatus);
end
//delimiter ;
call proc_update_product("4",4,"LuxSA",1200,20,"xe viet nam xin",1);
delimiter //
create procedure proc_update_product2(
in idUpdate varchar(50), nproductCode int,nproductName varchar(50),nproductPrice float,nproductAmount int,nproductDescription text,nproductStatus bit
)
begin
update product
set 
productCode = nproductCode,
productName = nproductName,
productPrice = nproductPrice,
productAmount = nproductAmount,
productDescription = nproductDescription,
productStatus = nproductStatus
where id = idUpdate;
end
// delimiter ;
call proc_update_product2("3",3,"LuxSA",1200,20,"xe viet nam xin",1);
-- xóa sản phẩm
delimiter //
create procedure proc_del_product(
in idDel varchar(50)
)
begin
delete from product where id = idDel;
end
//delimiter ;
call proc_del_product("1");




