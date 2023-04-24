use qlsv;
select * from marks;
insert into marks(mark,studentId,subjectId) values
(8,1,1),
(6,1,2),
(4,1,3),
(7,1,4),
(8,2,1),
(7,2,2),
(6,2,3),
(2,2,4),
(7,3,1),
(5,3,2),
(4,3,4),
(8,4,1),
(9,4,2),
(3,5,3),
(6,5,4),
(4,5,1),
(2,6,1),
(5,6,2),
(7,6,4);
-- hiển thị danh sách học viên
select * from student;
-- danh sách môn họcache index
select * from subject;
-- điểm trung bình của mỗi hoc viên
select studentName,round(avg(mark))  from
student join marks on student.studentId = marks.studentId
group by student.studentId;
-- môn học có điểm cao nhất
select subjectName,marks.mark from
subject join marks on subject.subjectId = marks.subjectId
 where marks.mark = (select max(mark) from marks);
 -- sắp xếp điểm giảm dần
 select * from marks order by mark desc;
 -- thay đổi kiểu dữ liệu
 alter table subject modify subjectName varchar(255);
 -- chỉnh sửa subjectName
 update subject set subjectName =  concat("day la mon hoc",subjectName);
 -- thêm check contrain
alter table student
add constraint ck_age check(age > 15 and age < 50);
-- loại bỏ quan hệ giữa các bảng
alter table marks drop foreign key marks_ibfk_1;
alter table marks drop foreign key marks_ibfk_2;
alter table classstudent drop foreign key classstudent_ibfk_2;
alter table marks drop foreign key marks_ibfk_2;

-- xóa học viên
delete from student where studentId = 3;
-- thêm trường
alter table student
add column `status` bit default 1 after email;
-- caap nhat gia tri cho truowng
update student
set `status` = 0 where studentId = 1;
