/* Looking at the structure of each table */
select * from Demographics;
select * from Conditions;
select * from TextMessages;


/* Joining the tables into a new one for easier manipulation */
select A.*, B.*, C.* into lrozema.democontext
from Demographics A
inner join
Conditions B
on A.contactid = B.tri_patientid
inner join 
TextMessages C
on A.contactid = C.tri_contactId;

select top 10 * from lrozema.democontext

/* There are still some duplicate where there were more than two texts sent on the latest date, so I'm only selecting one here */
select *
from (
   select *,
          row_number() over (partition by contactid order by TextSentDate desc) as row_number
   from lrozema.democontext
   ) as rows
where row_number = 1

select * from lrozema.democontext



