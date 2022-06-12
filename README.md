<h1>Data cleaning and cohort retention rate with SQL and Tableau visualization</h1>

This project is to build a cohort retention rate table with SQL and visualize it with Tableau Public.<p> 
The data for the project was downloaded from <a href='https://archive.ics.uci.edu/ml/datasets/Online+Retail'>here</a> and contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail. The company mainly sells unique all-occasion gifts.<p>
The cohorts were build on the customers' first purchases and the resulted table and Tableau dashboard show percent of customers who returned for another purchase in 1,2,3 etc. months after the initial purchase was made.  
<a href='https://public.tableau.com/app/profile/ruslan.khurazov/viz/CohortDashboard_16549947912740/CohortRetention'><img src="https://github.com/KhurazovRuslan/cohort_retantion_sql_tableau/blob/main/CohortRetention.png" alt="COVID numbers" style="width:90%"></a>
<h2>Software used in the project:</h2>
<li>Microsoft SQL Server Management Studio v.18.11.1</li>
<li>Tableau Public 2022.1</li>
<h2>Files:</h2>
<li><a href='https://github.com/KhurazovRuslan/cohort_retantion_sql_tableau/blob/main/online_retail.sql'>online_retail.sql</a> - a file that contain SQL queries for cleaning the data and building retention rate table using join statements, CTEs and temp tables. After cleaning and manipulation the data was used to create a dashboard that can be found in <a href='https://public.tableau.com/app/profile/ruslan.khurazov/viz/CohortDashboard_16549947912740/CohortRetention'>my public Tableau account.</a></li>
<li><a href='https://github.com/KhurazovRuslan/cohort_retantion_sql_tableau/blob/main/README.md'>README.md file.</a></li>
<p>

On the dashboard it's easy to see that between 11% and 37% of customers of all cohorts return for another purchase next month. The online gift store had the highest number of cutomers in December 2010, and that same cohort showed the highest retention rate, around 50%, in December 2011. This phenomenon can be explained by big Christmas and New Year's holidays. 
