/* 
-- Questions
============
Employee Demographics & General Insights
	1.	How many employees are currently working in each department?
	2.	What is the gender distribution of employees across different job roles?
	3.	What is the average age of employees in each department?
	4.	Which education field has the highest number of employees?

Attrition & Employee Turnover
	5.	What is the overall attrition rate, and how does it vary by department?
	6.	Is there a correlation between employee attrition and work-life balance scores?
	7.	Which age group has the highest attrition rate?
	8.	What percentage of employees with stock options have left the company?

Performance & Satisfaction Analysis
	9.	What is the average performance rating by department and job role?
	10.	Is there a relationship between relationship satisfaction and attrition?
	11.	Do employees who travel frequently have a higher attrition rate than those who travel rarely?
	12.	What is the average number of years spent in the company for employees who received a promotion vs. those who didn’t?
*/
-- view all data
SELECT * 
FROM HR_Data
LIMIT 50;

-- How many employees are currently working in each department?
SELECT 
	Department,
    SUM(EmployeeCount) TotalEmployees
FROM HR_Data
WHERE CF_attritionlabel <> 'Ex-Employees'
GROUP BY Department;

-- What is the gender distribution of employees across different job roles?
SELECT
	JobRole,
	SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) male,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) female
FROM hr_data
GROUP BY JobRole;

-- What is the average age of employees in each department?

SELECT 
	Department,
	ROUND(AVG(age))
FROM hr_data
GROUP BY Department;

-- Which education field has the highest number of employees?
SELECT 
	EducationField,
    COUNT(EducationField) AS Total
FROM hr_data
GROUP BY EducationField
ORDER BY COUNT(EducationField) DESC;

-- What is the overall attrition rate, and how does it vary by department?
SELECT 
    Department,
    COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) AS AttritionCount,
    COUNT(*) AS TotalEmployees,
    ROUND( (COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0) / COUNT(*), 2 ) AS AttritionRate
FROM hr_data
GROUP BY Department
ORDER BY AttritionRate DESC;

-- Is there a correlation between employee attrition and work-life balance scores?
SELECT 
    WorkLifeBalance,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS AttritionRate
FROM HR_Data
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- Which age group has the highest attrition rate?

SELECT 
	CF_ageband,
    COUNT(*) AS TotalEmplopyees,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS AttritionRate
FROM hr_data
GROUP BY CF_ageband
ORDER BY ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) DESC;

-- What percentage of employees with stock options have left the company?
SELECT 
	SUM(CASE WHEN StockOptionLevel IN ('1', '2', '3') THEN 1 ELSE 0 END) * 100 / COUNT(*) AS StockOptionPercent
FROM hr_data;

-- What is the average performance rating by department and job role?
SELECT 
	Department,
    JobRole,
    AVG(PerformanceRating) AvgPerformanceRating
FROM hr_data
GROUP BY Department, JobRole
ORDER BY Department, AvgPerformanceRating DESC;

-- Is there a relationship between relationship satisfaction and attrition?
SELECT 
    Attrition,
    ROUND(AVG(RelationshipSatisfaction), 2) AS AvgRelationshipSatisfaction,
    COUNT(*) AS EmployeeCount
FROM HR_Data
GROUP BY Attrition;

-- Do employees who travel frequently have a higher attrition rate than those who travel rarely?

SELECT 
	BusinessTravel,
    COUNT(*) AS TotalEmplopyees,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS AttritionRate
FROM hr_data
GROUP BY BusinessTravel
ORDER BY ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) DESC;
    
-- What is the average number of years spent in the company for employees who received a promotion vs. those who didn’t?

WITH Promotion_cte AS 
(
	SELECT
		YearsAtCompany,
		EmployeeNumber,
		CASE
			WHEN YearsSinceLastPromotion = 0
			THEN 'NotPromoted'
			ELSE 'Promoted' END AS PromotionStatus
	FROM hr_data
)
SELECT 
	PromotionStatus,
	ROUND(AVG(YearsAtCompany),2) AvgYearAtCompany
FROM Promotion_cte
GROUP BY PromotionStatus;

	