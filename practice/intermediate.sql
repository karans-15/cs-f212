#Intermediate SQL

connect practice1;

#Cartesian Product
select *
from employee cross join department;
#OR
select *
from employee, department;

#Inner join
#Natural inner join for no duplicate columns
select * 
from course natural inner join prereq;

#Natural join
#kinda same as natural inner join

#Dangers of this join
#List the names of students instructors along with the titles of courses that they have taken

#Correct
select name, title
from student natural join takes, course
where takes.course_id = course.course_id;

select name, title
from student natural join takes natural join course;
#This query omits all (student name, course title) pairs where the student takes a course in a department other than the student's own department. 

#Outer join (Need to add natural or else gives error)
#displays all courses w or w/o prereq
select * from course natural left outer join prereq;
#displays all courses havig prereq
select * from course natural right outer join prereq;
#Full join
select * from course natural full outer join prereq;


#Joined relations

select *
from course natural right outer join prereq;

select *
from course natural left outer join prereq;

select *
from course left outer join prereq using (course_id);

select *
from course inner join prereq on
course.course_id = prereq.course_id;
#Equates null values as well
select *
from course left outer join prereq on
course.course_id = prereq.course_id;


#Views
	#NOTE: To see all created views, 
	#show full tables;
#Create view of instructors w/o salary
create view faculty as
	select ID,name,dept_name
	from instructor;

#Find all instructors in bio deot
select namef
rom faculty
where dept_name = 'Biology'

#Create a view of department salary totals
create view departments_total_salary(dept_name,salary) as
	select dept_name,sum(salary)
	from instructor
	group by dept_name;

#creating views from other views
create view physics_fall_2017 as
	select course.course_id, sec_id, building, room_number
	from course, section
	where course.course_id = section.course_id and course.dept_name = 'Physics' and section.semester = 'Fall' and section.year = 2017;
create view physics_fall_2017_watson as
	select course_id, room_number
	from physics_fall_2017
	where building= 'Watson';

with recursive 
odd_no (sr_no, n) as
(
select 1, 1 #primary initialization
union all
select sr_no+1, n+2 from odd_no where sr_no < 5  #recursion conditions and break conditions
)
select * from odd_no;  

with recursive 
odd_no (sr_no, n) as
(
select 1, 5 #primary initialization
union all
select sr_no+1, n+2 from odd_no where sr_no < 12  #recursion conditions and break conditions
)
select * from odd_no;  

create view temp_faculty as
	select ID,name,dept_name
	from instructor;

create view temp_faculty as
	select ID,name,dept_name
	from temp_faculty
	where dept_name = 'Biology';

#Do recursive views later


#Materialized views
#1. The basic difference between View and Materialized View is that Views are not stored physically on the disk. 
#On the other hands, Materialized Views are stored on the disc.
#2. View can be defined as a virtual table created as a result of the query expression. 
#However, Materialized View is a physical copy, picture or snapshot of the base table.
#3. A view is always updated as the query creating View executes each time the View is used.
#On the other hands, Materialized View is updated manually or by applying triggers to it.
#4. Materialized View responds faster than View as the Materialized View is precomputed.
#5. Materialized View utilizes the memory space as it stored on the disk whereas, 
#the View is just a display hence it do not require memory space.


insert into faculty 
	values ('30765', 'Green', 'Music');

DELETE FROM faculty
WHERE name='Green';

#Transactions check from these articles: https://www.javatpoint.com/mysql-transaction, https://www.mysqltutorial.org/mysql-transaction.aspx/

#Integrity constraints;
#check clause;
create table temp1 (temp_id int primary key, 
	name varchar(15) not null, 
	semester varchar(15),
	check(semester in ('Fall','Winter','Spring','Summer')));

create table course_taken (temp_id int, 
	course_name varchar(15),
	course_units int,
	primary key(temp_id,course_name),
	constraint fk foreign key (temp_id) references temp1(temp_id) on delete cascade on update cascade); 

#we can alter temp1 temp_id and they will reflect in course_taken
#but we cant alter temp_id in course_taken as it is a child table

#User defined data types
create type Dollars as numeric (12,2) final;

#Domains. Like user defined types but can have constraints on them as well. Domains dont allow this behavoir
#Not supported in MySQL
#create domain degree_level varchar(10)
#	constraint degree_level_test
#	check (value in ('Bachelors','Masters','Doctorate')); 


#Indices 
#Like mapping/hashing
#Efficiently does updation/finding etc in O(1) and dont need to traverse through all the tuples
create table student	
	(ID varchar (5),
	name varchar (20) not null,
	dept_name varchar (20),
	tot_cred numeric (3,0) default 0,
	primary key (ID));

create index studentID_index on student(ID);
#can do optimized/efficient operations
select *
from  student
where  ID = '12345'

drop index studentID_index; #to drop it

#Authorization (privilege)
#Syntax
grant <privilege list> 
on <relation or view > 
to <user list>

#select < insert < update < delete < all privileges

revoke <privilege list> 
on <relation or view> 
from <user list>

#Role.  (Like interface)
#create role <name>;
#grant <role> to <users>

#Eg:
create role instructor;
grant select on takes to instructor;
grant instructor to Amit;

create role teaching_assistant;
grant teaching_assistant to instructor; #inherits all privileges of teaching_assistant

create role dean;
grant instructor to dean;
grant dean to Satoshi;

#Eg2
create view  geo_instructor as
	(select *
	from instructor
	where dept_name = 'Geology');

grant select on geo_instructor to  geo_staff;

#'references' privilege to create foreign key
grant reference (dept_name) on department to Mariano;

#Give amit the permission to grant to others
grant select on department to Amit with grant option;
revoke grant option for select on department from Amit; #only revokes amit from granting forward

#Cascading effect seen
revoke select on department from Amit, Satoshi cascade;

#No cascading effect seen
revoke select on department from Amit, Satoshi restrict;
