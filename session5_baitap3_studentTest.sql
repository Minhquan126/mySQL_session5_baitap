create database studentTest;
use studentTest;
create table test(
testId int primary key,
name varchar(50)
);
create table student(
studentId int primary key,
name varchar(50),
age tinyint,
status bit
);
create table studentTest(
RN int,
testId int,
date date,
mark float
);
alter table studentTest
add foreign key (RN) references student(studentId);
alter table studentTest
add foreign key (testId) references test(testId);
insert into student(studentId,name,age,status) values
(1,"quan",30,1),
(2,"tuan anh",33,1),
(3,"ngan",24,1),
(4,"nhan",26,1),
(5,"hieu",30,1),
(6,"khoa",22,1);
insert into test(testId,name) values
(1,"javaScript"),
(2,"reactJs"),
(3,"java"),
(4,"php");
insert into studentTest(RN,testId,date,mark) values
(1,1,"2023-04-10",7),
(1,2,"2023-04-14",4),
(3,3,"2023-04-21",9),
(2,1,"2023-04-10",7),
(2,3,"2023-04-21",6),
(3,1,"2023-04-10",7),
(3,4,"2023-04-24",5),
(4,1,"2023-04-10",7),
(4,2,"2023-04-14",9),
(4,3,"2023-04-21",4),
(5,1,"2023-04-10",7),
(5,3,"2023-04-21",5),
(5,4,"2023-04-24",3);
truncate table studentTest;
-- 2.a them rang buoc cho age
alter table student
add constraint check_age check (age between 15 and 55);
-- 2.b thêm giá trị mặc định cho mark
alter table studenttest
modify mark float default 1;
-- 2.c	Thêm khóa chính cho bảng studenttest là (RN,TestID)
alter table studenttest
add primary key (RN,testId);
-- 2.d.	Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
alter table test
modify name varchar(50) unique;
-- 2e.	Xóa ràng buộc duy nhất (unique) trên bảng Test
alter table test
drop constraint name;
-- 3.	Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi 
select @stt:=@stt + 1 as STT, student.studentId, student.name, test.name,studenttest.mark,studenttest.date from
(select @stt:=0) as STT, studenttest join student on studenttest.RN = student.studentId
join test on studenttest.testId = test.testId
order by student.studentId;
-- 4.	Hiển thị danh sách các bạn học viên chưa thi môn nào
select * from student
where studentId not in
(select studentId from student join studentTest on student.studentId = studentTest.RN);
-- 5.	Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi
select student.studentId, student.name, test.name,studenttest.mark,studenttest.date from
studenttest join student on studenttest.RN = student.studentId
join test on studenttest.testId = test.testId
where mark < 5;
-- 6.	Hiển thị danh sách học viên và điểm trung bình
select studentId,student.name, avg(mark) from
studenttest join student on studenttest.RN = student.studentId
join test on studenttest.testId = test.testId
group by studentId
order by avg(mark) desc;
-- 7.	Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất 
select max(dtb) from
(select avg(mark) as dtb from studentTest group by RN);
select studentId,student.name,avg(mark) from
student join studentTest on student.studentId = studentTest.RN
group by RN order by avg(mark) desc limit 1;
-- 8.8.	Hiển thị điểm thi cao nhất của từng môn học
select test.testId,test.name,mark from
test join studentTest on test.testId = studentTest.testId
where mark = (select max(mark) from studentTest group by testId)
order by mark desc;
select test.testId,test.name,max(mark) from
test join studentTest on test.testId = studentTest.testId
group by studentTest.testId
order by name desc;
-- 9.	Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi 
select student.name,test.name from
student left join studenttest on student.studentId = studenttest.RN
left join test on studenttest.testId = test.testId;
-- 10.	Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update student set age = age + 1;
-- 11.	Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student
alter table student
add column studentStatus varchar(10) after status;
-- 12.	Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, trường hợp còn lại nhận giá trị ‘Old’
update student
set studentStatus = case when age < 30 then "young" else "old" end;
-- 13.	Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi 
select row_number() over(order by date asc) as "", student.name,test.name,mark,date from
student join studenttest on student.studentId = studenttest.RN
 join test on studenttest.testId = test.testId;

 -- 14 Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. 
 select student.name,age,avg(mark) as dtb from
 student join studenttest on student.studentId = studenttest.RN
 group by studenttest.RN
 having avg(mark) > 4.5 and student.name like "T%";
 -- 15 xếp hạng dựa vào điểm trung bình của học viên
 select student.studentId, student.name,age,avg(mark) as dtb, rank() over(order by avg(mark) desc) as xephang from
 student join studenttest on student.studentId = studenttest.RN
 group by studenttest.RN;
 -- 16.	Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
 alter table student
  modify name varchar(255); 
-- 17.	Cập nhật (sử dụng phương thức write) cột name 
update student
set name = case when age < 20 then concat("young",name) when age >= 20 then concat("old",name) end;
-- 18.	 Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi
delete from test where test.name not in (select student.name from student join studenttest on student.studentId = studenttest.RN);




