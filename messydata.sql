create database MessyDataAnalyze;
use MessyDataAnalyze;
create table Profiless (
gender enum ('M','F') null, 
age int null,
id char(32) null,
becamemember date null,
salary int null
);
create table transcript (
person char(32) not null,
event_s varchar (15) not null,
offer_id char(32) null
);
create table portfolio (
reward int not null,
channels_1 varchar(8) not null,
channels_2 varchar(8) not null,
channels_3 varchar(8) not null,
channels_4 varchar(8) not null,
difficulty int not null,
duration int not null,
offer_type varchar(15) not null,
offer_id char(32) not null
);
use messydataanalyze;
-- finding the age of the highest purchasers
select age, id, amount 
from profiless join transcript
on id = person
group by id
order by age desc;
-- what month has the highest purchase
select monthname(becamemember) as Month, sum(amount) as Totalsales
from profiless join transcript
on id = person
where event_s like ('tr%')
group by month
order by Totalsales desc;
-- what promos do older males enjoy viewing?
select offer_id as offerviewed,gender,age
from profiless join transcript
on id = person
where event_s like ('%viewed') and gender = 'M' and age >=50
group by offerviewed
order by age desc;
-- are the highest purchasers the richest?
select salary, amount
from profiless join transcript
on id=person
where event_s like('tr%') and salary >=50000
order by salary desc;

-- CREATING VIEWS FOR ALL THE INSIGHTS...these views are created to enable data visualization
Create view Highestpurchaserage as
select age, id, amount 
from profiless join transcript
on id = person
group by id
order by age desc;
create view Highpurchasemonth as
select monthname(becamemember) as Month, sum(amount) as Totalsales
from profiless join transcript
on id = person
where event_s like ('tr%')
group by month
order by Totalsales desc;
create view Oldermalepromoview as
select offer_id as offerviewed,gender,age
from profiless join transcript
on id = person
where event_s like ('%viewed') and gender = 'M' and age >=50
group by offerviewed
order by age desc;
create view richestnothighestpurchaser as
select salary, amount
from profiless join transcript
on id=person
where event_s like('tr%') and salary >=50000
order by salary desc;