/*Question #1*/
EXEC sp_rename 'lrozema.demographics.tri_age', 'age', 'Column'
EXEC sp_rename 'lrozema.demographics.gendercode', 'gender', 'Column'
EXEC sp_rename 'lrozema.demographics.contactid', 'ID', 'Column'
EXEC sp_rename 'lrozema.demographics.Address1Stateorprovince', 'State', 'Column'
EXEC sp_rename 'lrozema.demographics.Tri_ImagineCareenrollmentemailsentdate', 'EmailSentdate', 'Column'
EXEC sp_rename 'lrozema.demographics.Tri_enrollmentcompletedate', 'Completedate', 'Column'	

ALTER TABLE lrozema.demographics
Add TimetoComplete as datediff(dd, try_convert(date,EmailSentdate),try_convert(date,Completedate))

select top 10 * from lrozema.Demographics
order by NEWID()

/*Question #2*/
alter table lrozema.demographics
add EnrollmentStatus nvarchar(255) 

update lrozema.Demographics
set EnrollmentStatus = 'Complete'
where tri_imaginecareenrollmentstatus = 167410011;

update lrozema.Demographics
set EnrollmentStatus = 'Email sent'
where tri_imaginecareenrollmentstatus = 167410001;

update lrozema.Demographics
set EnrollmentStatus = 'Non-responder'
where tri_imaginecareenrollmentstatus = 167410004

update lrozema.Demographics
set EnrollmentStatus = 'Facilitated Enrollment'
where tri_imaginecareenrollmentstatus = 167410005

update lrozema.Demographics
set EnrollmentStatus = 'Incomplete Enrollments'
where tri_imaginecareenrollmentstatus = 167410002

update lrozema.Demographics
set EnrollmentStatus = 'Opted out'
where tri_imaginecareenrollmentstatus = 167410003

update lrozema.Demographics
set EnrollmentStatus = 'Unprocessed'
where tri_imaginecareenrollmentstatus = 167410000

update lrozema.Demographics
set EnrollmentStatus = 'Second Email Sent'
where tri_imaginecareenrollmentstatus = 167410006

select top 10 * from lrozema.Demographics
order by NEWID()

/* Question 3 */
Alter table lrozema.demographics
add Sex nvarchar(255)

update lrozema.Demographics
set Sex = 'Female'
where gender = '2'

update lrozema.Demographics
set Sex = 'Male' 
Where gender = '1'

update lrozema.Demographics
set Sex = 'Other'
Where gender = '167410000'

update lrozema.Demographics
set Sex = 'Unknown'
where gender = 'NULL'

select top 10 * from lrozema.Demographics
order by NEWID()

/* Question 4 */
alter table lrozema.demographics
add Age_group nvarchar(255)

update lrozema.Demographics
set Age_group = '0-25'
where age > 0 and age < 26

update lrozema.Demographics
set Age_group = '26-50'
where age > 25 and age < 51

update lrozema.Demographics
set Age_group = '51-75'
where age > 50 and age < 76

update lrozema.Demographics
set Age_group = '76+'
where age > 75

select top 10 * from lrozema.Demographics
order by NEWID()



