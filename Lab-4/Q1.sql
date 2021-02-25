#Q1 
select ssid,marks
from students
order by marks desc
limit 1 offset 1; #limit 1 => only one entry. Offset 1 => start entry from index 1 (They are 0 indexded)

#Q2
select branch
from students
group by branch
having count(*)>=3;

#Q3
#Retrieve branches for which average marks of the branch is more than average marks of the female students.
select branch,avg(marks)
from students
group by branch
having avg(marks) > (select avg(marks)
					from students
					group by gender
					having gender = 'Female');

#Q4
#Retrieve branches for which average marks of the male students of branch is more than average marks of the female students.
select branch,avg(marks),gender
from students T
group by branch,gender
having avg(marks) > (select avg(marks)
					from students S
					group by gender
					having gender='Female'
					and T.gender = 'Male');

#Q5
select T.branch
from students T
group by branch
having avg(marks) >  (select avg(marks)
					from students S
					group by branch,gender
					having gender = 'Female'
					and T.branch=S.branch); 

#Q6
with max_female_score(value) as
		(select max(marks)
		from students
		group by gender
		having gender='Female')
select (max(marks)-max_female_score.value) as max_marks_diff
from students,max_female_score
group by gender
having gender='Male';

#Q7
select count(*)
from students
where branch='CS' and marks between 71 and 89;

#Q8
update students
set gender = lower(gender);

