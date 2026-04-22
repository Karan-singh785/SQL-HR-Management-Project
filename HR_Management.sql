drop database hr_management;
Create database hr_management;
use hr_management;
create table departments (
department_id Int Primary key auto_increment,
department_name varchar(50) not null,
location varchar(100)
);
Insert Into departments (department_name, location) values
('HR','Delhi'),
('IT', 'Bangalore'),
('Finance','Pune'),
('sales','Mumbai'),
('Marketing','Gurgaon');
select * from departments;
Create Table jobs(
job_id Int Primary key auto_increment,
job_title varchar(50) not null,
job_type varchar(20),
min_salary decimal(10,2),
max_salary decimal(10,2));
INSERT INTO jobs (job_title, job_type, min_salary, max_salary) values
('HR manager','Full time','20000','80000'),
('Software Developer','Full time',50000,120000),
('Accountant','Full time',35000,70000),
('Sales Executive','part time',0000,60000),
('Marketing Specialist','part time',35000,65000); 
select * from jobs;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    hire_date DATE,
    department_id INT,
    job_id INT,
    salary DECIMAL(10,2),
    manager_id INT,
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);
INSERT INTO employees 
(first_name,last_name,gender,date_of_birth,hire_date,department_id,job_id,salary,manager_id)
VALUES
('Rahul','Sharma','Male','1995-05-10','2022-01-15',2,2,75000,NULL),
('Priya','Verma','Female','1996-07-20','2021-03-10',1,1,60000,NULL),
('Amit','Singh','Male','1994-09-15','2023-02-05',2,2,72000,1),
('Neha','Kapoor','Female','1997-04-12','2022-06-18',3,3,50000,NULL),
('Rohan','Gupta','Male','1993-11-25','2020-08-10',4,4,45000,NULL);
select * from employees;
DROP TABLE IF EXISTS attendance;

CREATE TABLE attendance (
attendance_id INT PRIMARY KEY AUTO_INCREMENT,
employee_id INT,
attendance_date DATE,
status VARCHAR(20),
FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO attendance (employee_id,attendance_date,status) VALUES
(1,'2024-01-01','Present'),
(1,'2024-01-02','Present'),
(2,'2024-01-01','Absent'),
(3,'2024-01-01','Present'),
(4,'2024-01-01','Present'),
(5,'2024-01-01','Absent');

SELECT * FROM attendance;
CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    review_date DATE,
    rating INT,
    comments VARCHAR(200),
    
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
INSERT INTO performance_reviews 
(employee_id,review_date,rating,comments) VALUES
(1,'2024-01-10',5,'Excellent performance'),
(2,'2024-01-12',4,'Very good'),
(3,'2024-01-15',3,'Average'),
(4,'2024-01-18',4,'Good work'),
(5,'2024-01-20',2,'Needs improvement');
select * from performance_reviews;
CREATE TABLE salary_history (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    salary DECIMAL(10,2),
    effective_date DATE,
    
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
select * from salary_history;
CREATE TRIGGER salary_update
AFTER UPDATE ON employees
FOR EACH ROW
INSERT INTO salary_history(employee_id,salary,effective_date)
VALUES(NEW.employee_id,NEW.salary,CURDATE());

UPDATE employees	
SET salary = 90000
WHERE employee_id = 1;
SELECT * FROM salary_history;
SELECT * FROM employees;

-- Employee Overview (Basic Join)-> show employee full name, department name, job title, salary...
select 
concat(e.first_name, ' ', e.last_name) AS Employee_Name,
d.department_name,
j.job_title,
e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id;

-- Department Workforce & Salary Analysis-> total employees, average salary, highest salary, lowest salary
SELECT 
d.department_name,
COUNT(e.employee_id) AS total_employees,
AVG(e.salary) AS avg_salary,
MAX(e.salary) AS highest_salary,
MIN(e.salary) AS lowest_salary
FROM employees e
JOIN departments d ON e.department_id=d.department_id
GROUP BY d.department_name;
-- Job Role Salary Analysis-> number of employees, average salary, total salary expense
SELECT 
j.job_title,
COUNT(e.employee_id) AS total_employees,
AVG(e.salary) AS avg_salary,
SUM(e.salary) AS total_salary
FROM employees e
JOIN jobs j ON e.job_id=j.job_id
GROUP BY j.job_title;
-- Attendance Analysis-> total attendance records, number of days present, number of days absent
SELECT 
CONCAT(e.first_name,' ',e.last_name) AS employee_name,
COUNT(a.attendance_id) AS total_days,
SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS days_present,
SUM(CASE WHEN a.status='Absent' THEN 1 ELSE 0 END) AS days_absent
FROM employees e
JOIN attendance a ON e.employee_id=a.employee_id
GROUP BY employee_name;
-- Performance Review Analysis -> employee name, department, average performance rating
SELECT 
CONCAT(e.first_name,' ',e.last_name) AS employee_name,
d.department_name,
AVG(p.rating) AS avg_rating
FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN performance_reviews p ON e.employee_id=p.employee_id
GROUP BY employee_name,d.department_name;
-- Top Paid Employees-> Find top 3 highest paid employees with department and job.
SELECT 
CONCAT(e.first_name,' ',e.last_name) AS employee_name,
d.department_name,
j.job_title,
e.salary
FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN jobs j ON e.job_id=j.job_id
ORDER BY e.salary DESC
LIMIT 3;
-- Employees Paid Above Job Average-> Find employees whose salary is higher than the average salary of their job role.
SELECT 
CONCAT(first_name,' ',last_name) AS employee_name,
job_id,
salary
FROM employees e
WHERE salary >
( SELECT AVG(salary)
FROM employees
WHERE job_id=e.job_id
);
-- Hiring Trend Analysis-> hiring year, number of employees hired, average salary.
select
year(hire_date) AS Hire_Year,
count(employee_id) as Employees_Hired,
avg(salary) as Average_salary
from employees
 Group by hire_year;

-- Department Salary Ranking (Window Function)-> Rank employees within each department.
SELECT 
CONCAT(e.first_name,' ',e.last_name) AS employee_name,
d.department_name,
e.salary,
RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) AS dept_rank
FROM employees e
JOIN departments d ON e.department_id=d.department_id;
-- Salary vs Department Average-> employee salary, department average salary, difference.
SELECT 
CONCAT(first_name,' ',last_name) AS employee_name,
salary,
AVG(salary) OVER(PARTITION BY department_id) AS dept_avg_salary,
salary - AVG(salary) OVER(PARTITION BY department_id) AS salary_difference
FROM employees;
-- Manager–Employee Relationship-> Show employee and their manager.
SELECT 
CONCAT(e.first_name,' ',e.last_name) AS employee,
CONCAT(m.first_name,' ',m.last_name) AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id=m.employee_id;
-- Automatic Salary History on Insert->When a new employee is inserted, automatically store their initial salary in salary_history.

CREATE TRIGGER initial_salary_log
AFTER INSERT ON employees
FOR EACH ROW
INSERT INTO salary_history(employee_id,salary,effective_date)
VALUES(NEW.employee_id,NEW.salary,CURDATE());






