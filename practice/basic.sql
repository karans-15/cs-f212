#Basic SQL

use practice1; #this command depends on what you have named your database while importing it

show tables; #to check if it has been imported properly

select *
from instructor;

select *
from students;

#Display a literal (1x1 tabled formed)
select '437';

#Display a literal with column name "FOO"
select '437' as FOO;  #NOTE: You can omit 'as' clause. i.e. select '437' as FOO; == select '437' FOO;

#Display N rows of 'A', where N is no of rows in instructor
select 'A'
from instructor;

#Display monthly salary
select ID,name,salary/12 as monthly_salary
from instructor;

select name
from instructor
where dept_name = 'Comp. Sci.';

#Find all instructors in CS with salary > 70000
select name
from instructor
where dept_name = 'Comp. Sci.' and salary>70000;

#Cartesian Product
select *
from instructor,teaches;

#Find names of all instructors in art dept who have taught some course and the course_id
select name, course_id
from instructor, teaches
where instructor.ID = teaches.ID and instructor.dept_name = 'Art';

#Find names of all instructors who have salary higher than some instructor in CS dept
select distinct T.name
from instructor as T, instructor as Sci #Note: We can omit 'as' clause and it will still remain the same
where T.salary > S.salary and dept_name = 'Comp. Sci.';

#STRING OPERATIONS
#Find names of all instructors whose names include substring 't'
select name
from instructor
where name like '%t%';

#Find names of all instructors whose names are 3 char long
select name
from instructor
where name like '___';

#Match the string "100%"
select name
from instructor
where name like '100\%'; #use backslash(\) as the escape character

#Check slides for more info
#Concatenation operation
select concat('Hello','\n', 'World');  

#Lowercase and uppercase transformations
select lower(str); #str is the string. lower(),lcase() are interchangable and have same functionalities
select upper(str); #str is the string. upper(),ucase() are interchangable and have same functionalities

#String length
select length(str); #str is the string. Displayes length of string
#NOTE: char_length(str) is an alternate. 
#char_length() counts number of chars
#length() counts no of bytes

#Substrings
select substring("SQL Tutorial", 5, 3) AS ExtractString; #displays "Tut"
#5 is starting position(indexed 1), 3 is length of substring
#Note: If starting position is negative, it counts from end of string and traverses forward

#List in alphabetic order, names of all inst (Will name according to ascii lexicographically)
select distinct name
from instructor
order by name; # if we write: order by name desc : it will display in descending order

#Sort on multiple attributes, will sort on attribute mentioned first, first
select name,dept_name
from instructor
order by dept_name,name;

#Find names of all instructors with salary between a range (including the endpoints)
select name
from instructor
where salary between 90000 and 100000;

#Tuple comparison
select name, course_id
from instructor, teaches
where (instructor.ID, dept_name) = (teaches.ID, 'Biology');

#Set operations. Only union is supported by mySQL 
#NOTE: as union is a set operation, it automatically eliminates duplicates.
(select course_id from section where semester = 'Fall' and year = 2017)
union
(select course_id from section where semester = 'Spring' and year = 2018);

#Checking for null values
select name
from instructor
where salary is null;
#Can check for non null values by using clause 'is not null'
#NOTE: any result of arithmetic operation or string operations like concat involving a null will give result null

#AGGREGATE Functions
#Finds average salary
select avg(salary)
from instructor
where dept_name = 'Comp. Sci.';

#Find total no. of instructors who teach a course in spring 2018 semester
select count(distinct ID)
from teaches
where semester = 'Spring' and year = 2018;

#Find no of rows/tuples in course relation
select count(*)
from course;

#Find avg salary of instructors in each dept (averages of each dept)
select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name;

#ERRONEOUS Query!!! Shows ID with entire depts eventho ID is property of single tuple
select dept_name, ID, avg (salary)
from instructor
group by dept_name;

#Difference b/w where and having clause
#predicates in the having clause are applied after the formation of groups whereas predicates in the where clause are applied before forming groups
#Find the names and average salaries of all departments whose average salary is greater than 42000
select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name
having avg(salary) > 42000;

select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name
where avg(salary) > 42000; #this line will give error as groups not made yet.

#Find courses offerent in fall 2017 and in spring 2018 (Intersect)
select distinct course_id
from section
where semester = 'Fall' and course_id in(select course_id
										from section
										where semester = 'Spring' and year = 2018);
#Find courses offered in fall 2017 but not in spring 2018 (Set difference)
select distinct course_id
from section
where semester = 'Fall' and year = 2017
				and course_id not in (select course_id
									from section
									where semester = 'Spring' and year = 2018);

#Name all instructors whoese name is neither mozart nor einstein
select distinct name
from instructor
where name not in ('Mozart','Einstein');

#Find total no of distinct students who have taken course sections taught by the instructor with ID 10101
select count(distinct ID)
from takes
where (course_id,sec_id,semester,year) in 
									(select course_id,sec_id,semester,year
									from teaches
									where teaches.ID = 10101);
#The above query can be wrote in a much simpler format


#Set comparison (Using some)
#Find names of instructors with salary > than salary of some instructor in bio dept
select distinct name
from instructor
where salary > some (select salary
					from instructor
					where dept_name='Biology');

#some != not in
#Find the names of all instructors whose salary is greater than the salary of all instructors in the Biology department.
select name
from instructor
where salary > all (select salary
					from instructor
					where dept_name='Biology');

#Find all courses taught in both the Fall 2017 semester and in the Spring 2018 semester (Using exists)
select course_id
from section S
where semester='Fall' and year=2017 and
	exists (select*
			from section T
			where semester='Spring' and year=2018
				and S.course_id=T.course_id);

	#not exists
select distinct S.ID,S.name
from student as S
where not exists ((select course_id
					from course
					where dept_name='Biology') 			#Selects all courses in biology
				except
					(select T.course_id
					from takes as T
					where S.ID = T.ID));				#Selects all courses taken up by student in biology
#subtracts all courses in bio   - all courses taken by student in bio
#if equal to zero, means that he has taken all, so  not exists
#NOTE: mysql does not support 'except' clause

#Find all courses that were offered at most once in 2017
select T.course_id
from course as T
where unique ( select R.course_id
               from section as R
               where T.course_id= R.course_id
               and R.year = 2017);

#Find the average instructors’ salaries of those departments where the average salary is greater than $42,000.”
select dept_name, avg_salary
from ( select dept_name, avg (salary) as avg_salary
       from instructor
       group by dept_name) as T
where avg_salary > 42000;
#OR
select dept_name, avg_salary
from ( select dept_name, avg (salary) 
       from instructor
       group by dept_name) 
as dept_avg (dept_name, avg_salary)
where avg_salary > 42000;

#Find all departments with the maximum budget 
#Like a temp variable
with max_budget (value) as
	(select max(budget)
	from department)
select department.dept_name
from department, max_budget
where department.budget = max_budget.value;


#Find all departments where the total salary is greater than the average of the total salary at all departments
with dept_total(dept_name,value) as
	(select dept_name,sum(salary)
		from instructor
		group by dept_name),
dept_total_avg(value) as 
	(select avg(value)
	 from dept_total)
select dept_name
from dept_total,dept_total_avg
where dept_total.value > dept_total_avg.value;

#List all departments along with the number of instructors in each department
#Scalar subquery, need to have only one value
select dept_name, 
    ( select count(*)
     from instructor
     where department.dept_name = instructor.dept_name)
as num_instructors
from department;


#MODIFICATIONS TO THE DB

#Delete all instructors
delete from instructor;

#Delete all instructors from the finance dept
delete from instructor
	where dept_name='Finance';

#Delete all tuples in the instructor relation for those instructors associated with a department located in the Watson building.
delete from instructor
	where dept_name in (select dept_name
						from department
						where building='Watson');

#Delete all instructors whose salary is less than the average salary of instructors
#First, compute avg (salary) and find all tuples to delete
#Next, delete all tuples found above (without recomputing avg or retesting the tuples)
#Or else avg will change with every deletion
with avg_salary(value) as
	(select avg(salary)
	from instructor)
delete from instructor
	where salary < avg_salary.value;

#Insertion
insert into course
    values ('CS-437', 'Database Systems', 'Comp. Sci.', 4);

insert into course (course_id, title, dept_name, credits)
    values ('CS-437', 'Database Systems', 'Comp. Sci.', 4);


#Make each student in the Music department who has earned more than 144 credit hours an instructor in the Music department with a salary of  $18,000.
insert into instructor
	select ID, name, dept_name, 18000
	from   student
	where   dept_name = 'Music' and total_cred > 144;

#Updates

#Give  a 5% salary raise to instructors whose salary is less than average
#May have to use with clause
update instructor
set salary = salary * 1.05
where salary <  (select avg (salary)
				from instructor);

#Same query as before but with case statement
#Conditional updates
update instructor
	set salary = case
		when salary <= 100000 then salary * 1.05
		else salary * 1.03
		end;
# case
							#when sum(credits) is not null then sum(credits)
							#else 0
							#end
#Recompute and update tot_creds value for all students
update student S
	set tot_cred = (select sum(credits)
		from takes, course
		where takes.course_id = course.course_id  and 
	       	S.ID= takes.ID and
	       	takes.grade != 'F' and
	       	takes.grade is not null);

UPDATE student
	SET tot_cred=0 WHERE tot_cred is null;



