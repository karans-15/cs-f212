#Advanced SQL

#Assertion - a predicate that our database satisfies all the time (Our integrity contraints/domain/referential integrity contstraints are a part of assertions)
#certain constraints that we cannot define via integrity contraints
#can have before/after/during assertions also

#syntax
create asserion assertionName
	check predicate;

#note, sql doesn not support 
		#for all X, check P(X), hence we need to make an equivalent predicate,
		#hence we check instead, for neither P(X) of X  = using 'not exists clause'

#Eg: checking for discrepancies in total grade because of counting NC/F
create assertion credit_earned_constraint
	check (not exists (select ID 
					from student
					where tot_credit <> (select sum(credits)
										from takes natural join course
										where student.id = takes.id
											and grade is not null
											and grade <> 'NC')));

#Q. Write an assertion for the condition:
	#An instructor cannot teach in two different classroomes in a semester in the same timeslots
	#Hint. Tables involved: instructor, section, teaches(maybe), timeslot 	

create assertion no_clash
	check ( not exists (select *
					from (select ID,year,semester,time_slot_id 
							from teaches natural join instructor natural join section
							where teaches.ID = instructor.ID and section.course_id = teaches.course_id) as T
						group by ID,year,semester,time_slot_id
						having count(*)>1));

#Note: database assertion in DBMS is v slow as complex assertions are not supported as it will be checked everytime any changes are made. 
#Hence it may not be supported.


#Triggers:
#An automatic statement executed by the system as a side effect of a modifiaction to the database
#We must specify when(event), conditions and actions in a trigger.

#Usually update triggers are used on attributes/columns wherease delete/insertion are used on rows

#syntax:
#create trigger triggerName
#before/after
#insert/delete/update
#of tableName
#for each row/column
#when condition  //NOTE: we use 'when' over here instead of 'where'

#values of attributes before and after an update can be references as:
# 'referencing old row as' : for deletes and updates
# 'referencing new row as' : for inserts and updates

#Eg.1 converting new blank rows to null before every update in takes table.
create trigger setnull_trigger 
before updates of takes
referencing new row as nrow
for each row
	when (nrow.grade = '') #finding if new row grade is empty. NOTE: We used when not where
	begin atomic
		set nrow.grade = null;  #changing empty rows to null
end;

#This trigger will execute automatically on every new update operation and we dont need to do it manually

#Eg.2  Triggers when such a timeslot created that is not permissible
create trigger time_slot_check
after insert on section
referencing new row as nrow
for each row
	when nrow.timeslot.id not in (select timeslot_id 
						from timeslot)
	#begin atomic...
end;


#Eg3. 

#NOTE: We should not use tiggers when we are using update cascade, delete cascade etc.

#disabling a table (if you want to disable temporarily) It is disabled until an enable statement is encounted.
disable trigger time_slot_check;
enable trigger time_slot_check;
#dropping a trigger
drop trigger time_slot_check;
