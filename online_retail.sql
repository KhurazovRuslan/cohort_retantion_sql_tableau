--- have a look at the data

--- 541909 records in total
select * from OnlineRetailer..online_retail

--- cleaning the data

--- select only the data where CustomerID is not NULL,
--- and Quantity and UnitPrice are positive numbers
select * from OnlineRetailer..online_retail
where (CustomerID is not NULL) and (Quantity > 0) and (UnitPrice > 0)
--- now there are 397884 records left

--- now use previous query as CTE to check for duplicates
with retail as(
	select * from OnlineRetailer..online_retail
	where (CustomerID is not NULL) and (Quantity > 0) and (UnitPrice > 0)
)
select *, ROW_NUMBER() over (partition by InvoiceNo, StockCode, Quantity order by InvoiceDate) as num_duplicates
from retail

--- putting previous queries into CTE to get clean data for analysis
with retail as(
	select * from OnlineRetailer..online_retail
	where (CustomerID is not NULL) and (Quantity > 0) and (UnitPrice > 0)
), 
with_duplicates as (
select *, ROW_NUMBER() over (partition by InvoiceNo, StockCode, Quantity order by InvoiceDate) as num_duplicates
from retail
)
select * from with_duplicates
where num_duplicates = 1
--- only 392669 records left

--- putting clean data (only original columns) into local temp table for further work
with retail as(
	select * from OnlineRetailer..online_retail
	where (CustomerID is not NULL) and (Quantity > 0) and (UnitPrice > 0)
), 
with_duplicates as (
select *, ROW_NUMBER() over (partition by InvoiceNo, StockCode, Quantity order by InvoiceDate) as num_duplicates
from retail
)
select InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country 
into #online_retail_clean
from with_duplicates
where num_duplicates = 1

--- have a look at clean data
select * from #online_retail_clean

--- Cohort analysis (cohorts created by month and year)

--- things needed for the analysis:
--- unique identifier
--- initial start date (first invoice date)
--- revenue data
select CustomerID, min(InvoiceDate) as first_purchase,
       DATEFROMPARTS(year(min(InvoiceDate)),month(min(InvoiceDate)),1) as cohort
--- put it into another local temp table
into #cohorts
from #online_retail_clean
group by CustomerID

--- have a look
select * from #cohorts
order by cohort

--- creating cohort index
--- which will show when the customer made his second purchase
--- e.g. 1 would mean that the customer made the first purchase on that month and year,
--- 2 would mean that the customer made another purchase on the next month after the first purchase as so on

--- first, join two temp tables and get years and months differences between
--- customer's first purchase and actual purchase
with cohort_data as (
	select 
		o.*, 
		c.cohort,
		year_diff = year(o.InvoiceDate) - year(c.cohort),
		month_diff = month(o.InvoiceDate) - month(c.cohort)
	from #online_retail_clean as o
	left join #cohorts as c
	on o.CustomerID = c.CustomerID
	)
--- assign cohort indexes
select *, cohort_index = year_diff*12 + month_diff + 1
--- put it into temp table
into #cohort_index
from cohort_data

--- have a look at a table
select * from #cohort_index

--- the data from #cohort_index table was saved into .csv file 
--- to create a Tableau dashboard

--- have a look at unique customers and their cohort index
select distinct
	   CustomerID,
	   cohort,
	   cohort_index
from #cohort_index
order by CustomerID, cohort_index
--- some of the customers never returned after their first purchase

--- pivot data to see cohort numbers
with dist_customers as (
	select distinct
	   CustomerID,
	   cohort,
	   cohort_index
	from #cohort_index
)
select * 
into #pivot_table
from dist_customers
pivot(

	Count(CustomerID)
	for cohort_index in --- there are 13 distinct cohorts
	([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13])

) as pivot_table

--- have a look
select * from #pivot_table
order by cohort

--- see cohorts' retention rate in %
select cohort,
	1.0*[1]/[1]*100 as first_month,
	1.0*[2]/[1]*100 as second_month,
	1.0*[3]/[1]*100 as third_month,
	1.0*[4]/[1]*100 as fourth_month,
	1.0*[5]/[1]*100 as fifth_month,
	1.0*[6]/[1]*100 as sixth_month,
	1.0*[7]/[1]*100 as seventh_month,
	1.0*[8]/[1]*100 as eigth_month,
	1.0*[9]/[1]*100 as ninth_month,
	1.0*[10]/[1]*100 as tenth_month,
	1.0*[11]/[1]*100 as eleventh_month,
	1.0*[12]/[1]*100 as twelveth_month,
	1.0*[13]/[1]*100 as thirteenth_month
from #pivot_table
order by cohort

