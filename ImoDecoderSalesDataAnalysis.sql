-- creating database and tables for Sales Data and Analysis
create database if not exists ImoMcnSales;
use ImoMcnSales;
Create table Sales_Location (
center_id int,
center varchar (12) NOT NULL,
Activation_code varchar (15) not null,
Region varchar (6) not null,
primary key (center_id)
);
create table Transactions(
Transaction_date date NOT NULL,
Decoder_type varchar (4) NOT NULL,
IUCNumber varchar (10) NOT NULL,
Customer_num int NOT NULL,
Amount decimal (7.2) NOT NULL,
MCNshare decimal (7.2) NOT NULL,
Dealer_share decimal (7.2) NOT NULL,
center_id int NOT NULL,
FOREIGN KEY (center_id)  REFERENCES Sales_Location (center_id)  ON DELETE CASCADE,
primary key (Customer_num)
);
DROP TABLE IF EXISTS sales.transactions,
 sales.sales_location;
select * from
imomcnsales.transactions;
delete from imomcnsales.transactions
where center_id=10018;
select * 
from imomcnsales.transactions
where mcnshare >= 7900
group by Decoder_type;

-- Looking for tranactions where MCN has made more money
select * from imomcnsales.transactions
where center_id = 10016 or 10018 or 10019
and mcnshare >=12400;

-- Looking the percentage of the percentage of every transaction that goes to the Dealers and MCN
select Transaction_date, IUCNumber, amount, dealer_share, (Dealer_share/amount)*100 as dealer_cut
from imomcnsales.transactions
order by dealer_cut asc;

select Transaction_date, IUCNumber, amount, MCNshare, (MCNshare/amount)*100 as MCN_cut
from imomcnsales.transactions
order by MCN_cut asc;

-- Analysing Total sales in the state
select transactions.center_id, count(transactions.Decoder_type) as Decodersales,
 sum(transactions.amount) as Totalsales, sum(transactions.MCNshare) as TotalMcnShare,
 sum(transactions.Dealer_share) as TotalDealershare, sales_location.center,
 sales_location.Activation_code, sales_location.Region
from imomcnsales.transactions
join imomcnsales.sales_location
	on transactions.center_id = sales_location.center_id
group by center_id
;
-- creating Temp table for Percentage of sales
create table PercentageofSales (
center_id int,
Decodersales int,
Totalsales int,
TotalMcnShare int,
TotalDealershare int,
center varchar(15),
Activation_code varchar(16),
Region varchar (6)
)
;
insert into PercentageofSales (
select transactions.center_id, count(transactions.Decoder_type) as Decodersales,
 sum(transactions.amount) as Totalsales, sum(transactions.MCNshare) as TotalMcnShare,
 sum(transactions.Dealer_share) as TotalDealershare, sales_location.center,
 sales_location.Activation_code, sales_location.Region
from imomcnsales.transactions
join imomcnsales.sales_location
	on transactions.center_id = sales_location.center_id
group by center_id
);

-- creating Temp table for sum of decoders sold
create table if not exists TotalDecsales (
Total int
);
insert into TotalDecsales (
select sum(Decodersales)
from Percentageofsales
);
-- final sales analysis
select Percentageofsales.center_id, Percentageofsales.Decodersales, 
(Decodersales/TotalDecsales.Total)*100 as salespercentage, 
Percentageofsales.Totalsales, Percentageofsales.TotalMcnShare, 
Percentageofsales.TotalDealershare, Percentageofsales.center, 
Percentageofsales.Activation_code, Percentageofsales.Region
from PercentageofSales,TotalDecsales;

 -- creating views for sales data visualization
 create view Imodecodersalesdata as
 select Percentageofsales.center_id, Percentageofsales.Decodersales, 
(Decodersales/TotalDecsales.Total)*100 as salespercentage, 
Percentageofsales.Totalsales, Percentageofsales.TotalMcnShare, 
Percentageofsales.TotalDealershare, Percentageofsales.center, 
Percentageofsales.Activation_code, Percentageofsales.Region
from PercentageofSales,TotalDecsales;
