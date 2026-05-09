-- NextGen Corp. Employee Success Analytics
--  SQL 

--Table Datasets
select *from attendance;
select *from department;
select *from employee;
select *from performance;
select *from salary;
select *from turnover;

-- SECTION A - Employee Retention Analysis

-- Q1: top 5 highest serving (longest-tenured) employees

select 
	employee_id,
	first_name || ' ' || last_name as full_name,
	hire_date
from employee
order by hire_date ASC
limit 5;

-- Q2: what is the turnover rate for each department
select 
	d.department_name,
	count(distinct e.employee_id) as total_employees,
	count(distinct t.employee_id) as employees_left,
	round(count(distinct t.employee_id) * 100.0 / count(distinct e.employee_id), 2) as turnover_rate
from department d
left join employee e 
on d.department_id = e.department_id
left join turnover t 
on e.employee_id = t.employee_id
group by d.department_name;

-- Q3: which employees are at risk of leaving based on their performance
select
    e.employee_id,
    e.first_name || ' ' || e.last_name as full_name,
    ROUND(avg(p.performance_score), 2) as avg_score
from employee e
join performance p 
on e.employee_id = p.employee_id
group by e.employee_id, e.first_name, e.last_name
having avg(p.performance_score) < 3.5;


-- Q4: What are the main reasons employees are leaving the company?
select 
	reason_for_leaving, 
	count(employee_id) as total_employees
from turnover
group by reason_for_leaving;



-- SECTION 2: PERFORMANCE ANALYSIS

-- Q1: How many employees have left the company?

select count(distinct employee_id) as total_employees_left
from turnover;


-- Q2: How many employees have a performance score of 5.0/below 3.5?
select 
	count(distinct employee_id) as total_employees
from performance
where performance_score = 5.0;


-- How many employees have a performance score below 3.5?
select 
	count(distinct employee_id) as total_employees_below_3_5
from performance
where performance_score < 3.5;



-- Q3: Which department has the most employees with a performance score of 5.0?
select 
	d.department_name,
	count(distinct p.employee_id) as total_employees
from performance p
join department d
on p.department_id = d.department_id
where p.performance_score = 5.0
group by d.department_name
order by total_employees desc
limit 1;



-- Which department has the most employees with a performance score below 3.5?
select 
	d.department_name,
	count(distinct p.employee_id) as total_employees
from performance p
join department d
on p.department_id = d.department_id
where p.performance_score < 3.5
group by d.department_name
order by total_employees desc
limit 1;


-- Q4: What is the average performance score by department?

select 
	d.department_name,
	round(avg(p.performance_score), 2) as avg_performance_score
from performance p
join department d
on p.department_id = d.department_id
group by d.department_name
order by avg_performance_score desc;



-- SECTION 3: SALARY ANALYSIS

-- Q1: What is the total salary expense for the company?

select 
	'$' || to_char(sum(salary_amount), 'FM999,999,999') as total_salary_expense
from salary;


-- Q2: What is the average salary by job title?

select 
	e.job_title,
	'$' || to_char(round(avg(s.salary_amount), 2), 'FM999,999.00') as avg_salary  --'$' || to_char(sum(), 'FM999,999.00') as total_sales
from salary s
join employee e
on s.employee_id = e.employee_id
group by e.job_title;


-- Q3: How many employees earn above 80,000?

select count(distinct employee_id) as employees_above_80k
from salary
where salary_amount > 80000;


-- Q4: How does performance correlate with salary across departments?

select 
	d.department_name,
	round(avg(s.salary_amount), 2) as avg_salary,
	round(avg(p.performance_score), 2) as avg_performance_score
from employee e
join department d
on e.department_id = d.department_id
join salary s
on s.employee_id = e.employee_id
join performance p
on p.employee_id = e.employee_id
group by d.department_name;




