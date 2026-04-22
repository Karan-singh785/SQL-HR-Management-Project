# 📊 HR Management System (Excel + SQL)

## 📌 Overview
The HR Management System is a data analysis project built using Microsoft Excel and SQL. It focuses on managing employee data, performing analysis, and generating insights to support HR decision-making.

---

## 🎯 Objectives
- Manage and organize employee data efficiently  
- Perform data cleaning and transformation  
- Analyze salary, department, and attrition trends  
- Generate reports for better HR decisions  

---

## 🛠️ Tools & Technologies
- Microsoft Excel (Data Cleaning, Pivot Tables, Dashboards)  
- SQL (MySQL / SQL Server / PostgreSQL)  


---

## 📊 Dataset
The dataset includes:
- Employee ID  
- Name  
- Age  
- Gender  
- Department  
- Job Role  
- Salary  
- Joining Date  
- Performance Rating  
- Attrition Status  

---

## 🔍 SQL Operations
- SELECT, WHERE  
- JOIN (INNER, LEFT)  
- GROUP BY & Aggregations  
- Subqueries  

Example:
```sql
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
