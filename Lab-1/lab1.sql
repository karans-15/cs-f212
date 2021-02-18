#Q1 
create database db212BITSScreen; 
show databases; 
use db212BITSScreen; 

create table Movies (MovieID INT, 
MovieName VARCHAR(30) NOT NULL, 
ReleaseYear INT NOT NULL, 
Duration INT, 
Language VARCHAR(20),
ReleasedDate DATE, 
ReleasedCountry VARCHAR(15),
primary key(MovieID));

create table Critics (CriticID INT, 
Name VARCHAR(20), 
primary key(CriticID)); 

create table Ratings (MovieID INT, 
CriticID INT, 
Rating DECIMAL(2,1), 
NumOfRatings INT, 
primary key(MovieID, CriticID)); 

show tables;

#Q2 
desc Ratings;

#Q3
alter table Ratings 
change NumOfRatings NumOfReviews INT; 

alter table Critics 
modify Name VARCHAR(20) NOT NULL; 

alter table Ratings 
modify Rating DECIMAL(6,2); 

#Q4
show create table Movies;

#Q5
insert into Movies 
values (125, 'Good Will Hunting', 1997, 126, 'English', '1998-06-03', 'UK'); 

insert into Movies 
values (126, 'Back To The Future', 1985, 116, 'English', '1985-12-04', 'UK'); 

insert into Movies 
values (127, 'Seven Samurai', 1954, 207, 'Japanese', '1957-04-26', 'JP'); 

insert into Movies 
values (128, 'Jurassic Park', 1993, 128, 'English', '1993-06-26', 'US');

insert into Movies 
values (129, 'Uri: The Surgical Strike', 2019, 138, 'Hindi', '2019-01-11', 'IND'); 

insert into Critics 
values (500,'Judith Crist'); 

insert into Critics 
values (501,'Roger Ebert'); 

insert into Critics 
values (502,'Andrew Sarris'); 

insert into Critics 
values (503,'Omar Qureshi'); 

insert into Ratings 
values (125, 502,8.4,26375); 

insert into Ratings 
values (127, 500,7.9,202778); 

insert into Ratings 
values (129, 501, 8.1, 13091); 

insert into Ratings 
values (129, 503, 8.6, 81328); 

#Q6
select ReleaseYear 
from Movies 
where MovieName='Seven Samurai';

#Q7
select MovieName 
from Movies 
where MovieID in (125,128,129); 

#Q8
select MovieName 
from Movies 
where ReleaseYear < 1990; 

#Q9
select distinct ReleasedCountry 
from Movies;

#Q10 (IMP)
select MovieName 
from Movies 
where MovieID in (select MovieID 
      from Ratings 
      where Rating > 8);

#Q11
UPDATE Movies 
SET Duration=Duration-10;

#Q12
select Name 
from Critics 
UNION 
select MovieName 
from Movies; 
#UNION selects only distinct values by default
#use UNION ALL to select duplicates as well

#Q13
select Duration*1.5,MovieName 
from Movies;

#Q14 
alter table Movies 
add column Age INT DEFAULT 0;

#Q15
UPDATE Movies 
SET Age = YEAR(CURDATE()) - ReleaseYear;
#CURDATE() gives current date, SYSDATE() gives you current datetime, NOW() gives datetime when statement, procedure etc started.

#Q16
select curdate();

