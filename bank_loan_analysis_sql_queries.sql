-- to get the whole table
select * from bank_loan_data

--total loan applications
select count(id) as Total_Applications from bank_loan_data

--MTD loan applications
select count(id) as Total_Applications from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

--PMTD loan applications

select count(id) as Total_Applications from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

-- MOM applications(Compared to last month, how much did this month change)((Current − Previous) / Previous) i.e (MTD-PMTD)/PTMD
--Today is 18 December

--MTD → data from 1 Dec to 18 Dec

--PMTD → data from 1 Nov to 18 Nov

-- Total funded amount (amount which is funded by the bank)
select sum(loan_amount) as Total_Funded_Amount from bank_loan_data

-- total funded amount for MTD

select sum(loan_amount) as MTD_Total_Funded_Amount from bank_loan_data
where month(issue_date) = 12 and year(issue_date) =2021

-- total funded amount for PMTD
select sum(loan_amount) as PMTD_Total_Funded_Amount from bank_loan_data
where month(issue_date) = 11 and year(issue_date) =2021

-- Total Amount received
--473070933
select sum(total_payment) as Total_Amount_Received from bank_loan_data

-- Total Amount received for MTD
--58074380
select sum(total_payment) as MTD_Total_Amount_Received from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

-- Total Amount received for PMTD
-- 50132030
select sum(total_payment) as MTD_Total_Amount_Received from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

-- Average Interest rate
--12.05
select round(avg(int_rate), 4)*100 as Average_Interest_rate from bank_loan_data

-- Average Interest rate for MTD
--12.36 (highest interest rate is benificial for bank not for customers)
select round(avg(int_rate), 4)*100 as MTD_Average_Interest_rate from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

-- Average Interest rate for PMTD
--11.94
select round(avg(int_rate), 4)*100 as PMTD_Average_Interest_rate from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021


--DTI (Debt-to-income-ratio) (how much of your income is already used to pay debts.) (Monthly Debt Payment/Monthly Income) *100
--Lower DTI = better (easier to manage money)
--Higher DTI = risky (less money left)
--13.33
select round(avg(dti),4) * 100 as Average_Dti from bank_loan_data

--DTI (Debt-to-income-ratio) for MTD
--13.67
select round(avg(dti),4) * 100 as MTD_Average_Dti from bank_loan_data
where month(issue_date) = 12 and year(issue_date) =2021

--DTI (Debt-to-income-ratio) for PMTD
--13.3
select round(avg(dti),4) * 100 as PMTD_Average_Dti from bank_loan_data
where month(issue_date) = 11 and year(issue_date) =2021



select loan_status from bank_loan_data

-- Good Loan goes under
--Fully Paid - the customer has fully paid the loan amount
--Current -  current the repaying is in process regularly
-- bad loan goes under
-- Charged Off -  defaulters who are not repaying the particular installment

--Total no of %age applications received for Good loan
--86
select 
	(count(case when loan_status = 'Fully Paid' or loan_status = 'Current' then id  end)*100)
	/
	count(id) as Good_Loan_Percentage
from bank_loan_data

--Total no of good loan applications
--33243

select count(id) as Good_Loan_Applications from bank_loan_data 
where loan_status = 'Fully Paid' or loan_status = 'Current'

--Good Loan Funded Amount
--370224850
select sum(loan_amount) as Good_Loan_Funded_Amount from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current'

--Good Loan Total Received Amount
--435786170
select sum(total_payment) as Good_Loan_Total_Received_Amount from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current'

--Total no of %age applications received for Bad Loan
--13
select 
	(count(case when loan_status = 'Charged Off' then id  end)*100)
	/
	count(id) as Bad_Loan_Percentage
from bank_loan_data

--Total no of Bad loan applications
--5333

select count(id) as Bad_Loan_Applications from bank_loan_data 
where loan_status = 'Charged Off'

--Bad Loan Total Received Amount
--65532225
select sum(loan_amount) as Bad_Loan_Funded_Amount from bank_loan_data
where loan_status = 'Charged Off'

--Bad Loan Total Received Amount
--37284763
select sum(total_payment) as Bad_Loan_Received_Amount from bank_loan_data
where loan_status = 'Charged Off'


--Loan Status Grid View
select 
	loan_status,
	count(id) as Total_Applications,
	sum(total_payment) as Total_Amount_Received,
	sum(loan_amount) as Total_Funded_Amount,
	avg(int_rate *100) as Interest_Rate,
	avg(dti * 100) as DTI
from
	bank_loan_data
group by
	loan_status


select 
		loan_status,
		sum(total_payment) as MTD_Total_Amount_Received,
		sum(loan_amount) as MTD_Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021
group by loan_status




--FOR OVERVIEW DASHBOARD
--wrt each month what are the loan applications, Total funded amount and total amount received

select 
	month(issue_date) as Month_Number,
	--dimension
	datename(month, issue_date) as Month_Name,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by month(issue_date) ,datename(month, issue_date)  -- coz we can't use a column alias directly in a group by
order by month(issue_date)

--wrt each state what are the loan applications, Total funded amount and total amount received
select 
	address_state,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by address_state
order by address_state

--wrt each state what are the loan applications, Total funded amount and total amount received and order by total funded amount in descending descending to check which state has max total_funded-amount
select 
	address_state,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by address_state
order by Total_Funded_Amount desc

-- Loan term analysis

select 
	term,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by term
order by term

--wrt to employee_length (working experience)

select 
	emp_length,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by emp_length
order by emp_length

-- wrt emp_length in desc

select 
	emp_length,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by emp_length
order by Total_Loan_Applications desc

-- for which purpose they are buying the loan

select 
	purpose,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by purpose
order by Total_Loan_Applications desc


--wrt home_ownership

select 
	home_ownership,
	--aggregations
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by home_ownership
order by Total_Loan_Applications desc



