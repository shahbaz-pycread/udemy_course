-- CREATE DATABASE udemy_courseDB;

-- USE udemy_courseDB;

SELECT 
	TOP 100
	*
FROM
	dbo.course;

-- DROP column: url
ALTER TABLE course
DROP COLUMN url;

-- Change the datatype of is_paid column from bit to varchar
ALTER TABLE course
ALTER COLUMN is_paid VARCHAR(6);

UPDATE course
SET is_paid = 'Paid'
WHERE is_paid = 1;

UPDATE course
SET is_paid = 'Free'
WHERE is_paid = '0';

-- Set Null Values to 0 in content_duration

UPDATE course
SET content_duration = 0
WHERE content_duration IS NULL;



-- DELETE Duplicate Values

with total_course AS(
	SELECT
		course_id
		,course_title
		,is_paid
		,price
		,num_subscribers
		,num_reviews
		,num_lectures
		,level
		,content_duration
		,published_timestamp
		,subject
		,ROW_NUMBER()OVER(PARTITION BY course_id ORDER BY course_id DESC) rn
	FROM
		course
)
DELETE
FROM
	total_course
WHERE 
	rn > 1;

-- Types of Subject

SELECT
	DISTINCT subject
FROM
	dbo.course;


-- Total Number of Course by Subjects
SELECT
	subject
	,COUNT(*) 'Total Course'
FROM
	dbo.course
GROUP BY
	subject
ORDER BY
	'Total Course' DESC;

-- Total Course by Type - Paid and Free

SELECT
	is_paid 'Course Type'
	,COUNT(*) 'Total Course'
FROM
	dbo.course
GROUP BY
	is_paid
ORDER BY
	'Total Course' DESC;

-- Total Course by level type

SELECT
	level
	,COUNT(*) 'Total Course'
FROM	
	course
GROUP BY
	level
ORDER BY 
	'Total Course' DESC;

-- Total Course published by Year
SELECT
	YEAR(published_timestamp) 'Published Year'
	,COUNT(*) 'Total Course'
FROM	
	course
GROUP BY
	YEAR(published_timestamp)
ORDER BY 
	'Published Year';

-- Total Course published by Year and Paid Type
SELECT
	YEAR(published_timestamp) 'Published Year'
	,is_paid 'Paid Type'
	,COUNT(*) 'Total Course'
FROM	
	course
GROUP BY
	YEAR(published_timestamp)
	,is_paid
ORDER BY 
	'Published Year',
	'Paid Type';

-- Average Price by level and subject
SELECT
	level
	,subject
	,YEAR(published_timestamp) 'Published Year'
	,ROUND(AVG(price),2) 'Average Price'
FROM
	course
WHERE
	is_paid = 'Paid'
GROUP BY
	level
	,subject
	,YEAR(published_timestamp)
ORDER BY
	'Published Year'
	,level
	,subject;

-- What is the distribution of courses across different subjects and levels?

SELECT
	subject 'Subject'
	,level 'Level'
	,COUNT(*) 'Total Course'
FROM
	course
GROUP BY
	subject
	,level
ORDER BY
	'Subject'
	,'Level';

-- How many paid and free courses are available in each subject?

SELECT
	subject 'Subject'
	,COUNT(
		CASE
			WHEN is_paid = 'Paid' THEN 1 
		END
		  ) AS [Paid Course]
	,COUNT(
		CASE
			WHEN is_paid = 'Free' THEN 1 
		END
		  ) AS [Free Course]
FROM
	course
GROUP BY
	subject;

-- Which courses have the highest number of subscribers? (TOP 5)

SELECT
	TOP 5
	course_title
	,num_subscribers 'Total Subscribers'
FROM
	course
ORDER BY
	'Total Subscribers' DESC;

-- Which courses have the least number of subscribers? (TOP 5)

SELECT
	TOP 5
	course_title
	,num_subscribers 'Total Subscribers'
FROM
	course
ORDER BY
	'Total Subscribers';

 -- Which courses have the highest number of reviews? (TOP 5)
 SELECT
	TOP 5
	course_title
	,num_reviews 'Total Reviews'
FROM
	course
ORDER BY
	'Total Reviews' DESC;

-- Average Content Duration by Paid Type

SELECT
	is_paid 'Paid Type'
	,ROUND(AVG(content_duration),2) 'Content Duration'
FROM
	course
GROUP BY
	is_paid
ORDER BY
	'Content Duration';



