--1. Profile the data by finding the total number of records for each of the tables below:

SELECT COUNT(*) AS attribute_table_num
FROM attribute
	--10000

SELECT COUNT(*) AS business_table_num
FROM business
	--10000

SELECT COUNT(*) AS category_table_num
FROM category
	-- 10000 
	
SELECT COUNT(*) AS checkin_table_num
FROM checkin
	--10000
	
SELECT COUNT(*) AS elite_years_table_num
FROM elite_years
	--10000

SELECT COUNT(*) AS friend_table_num
FROM friend
	--10000

SELECT COUNT(*) AS hours_table_num
FROM hours
	--10000

SELECT COUNT(*) AS photo_table_num
FROM photo
	--10000

SELECT COUNT(*) AS review_table_nun
FROM review
	--10000

SELECT COUNT(*) AS tip_table_num
FROM tip
	--10000

SELECT COUNT(*) AS user_table_num
FROM user
	--10000

--3. Are there any columns with null values in the Users table? Indicate "yes," or "no."

SELECT *
FROM user
WHERE id IS NULL OR
    name IS NULL OR
    review_count IS NULL OR
    yelping_since IS NULL OR
    useful IS NULL OR
    funny IS NULL OR
    cool IS NULL OR
    fans IS NULL OR
    average_stars IS NULL OR
    compliment_hot IS NULL OR
    compliment_more IS NULL OR
    compliment_profile IS NULL OR
    compliment_cute IS NULL OR
    compliment_list IS NULL OR
    compliment_note IS NULL OR
    compliment_plain IS NULL OR
    compliment_cool IS NULL OR
    compliment_funny IS NULL OR
    compliment_writer IS NULL OR
    compliment_photos IS NULL
LIMIT 10;
	

--4. For each table and column listed below, display the smallest (minimum), largest (maximum), and average (mean) value for the following fields:

-- review / stars
SELECT MIN(stars) AS min_star,
	MAX(stars) AS max_star,
	AVG(stars) AS avg_star
FROM review;

-- business / stars
SELECT MIN(stars) AS min_star,
	MAX(stars) AS max_star,
	AVG(stars) AS avg_star
FROM business

-- tip / likes
SELECT MIN(likes) AS min_like,
	MAX(likes) AS max_like,
	AVG(likes) AS avg_like
FROM tip

-- checkin / count
SELECT MIN(count) AS min_count,
	MAX(count) AS max_count,
	AVG(count) AS avg_count
FROM checkin

-- user / review_count
SELECT MIN(review_count) AS min_review,
	MAX(review_count) AS max_review,
	AVG(review_count) AS avg_review
FROM user

--5. List the cities with the most reviews in descending order:
SELECT city,
	SUM(review_count) AS review_count
FROM business
GROUP BY city
ORDER BY review_count DESC;

--6. Find the distribution of star ratings to the business in the following cities:
-- distribution: 2 columns, star rating and count
--Avon
SELECT stars,
	COUNT(stars) AS count 
FROM business
WHERE city = 'Avon'
GROUP BY stars

--Beachwood
SELECT stars,
	COUNT(stars) AS count 
FROM business
WHERE city = 'Beachwood'
GROUP BY stars


--7. Find the top 3 users based on their total number of reviews:
SELECT id, 
	name,
	review_count
FROM user
ORDER BY review_count DESC
LIMIT 3;

--8. Does posing more reviews correlate with more fans?
SELECT id, 
	name,
	review_count,
	fans
FROM user
ORDER BY fans DESC;

--9. Are there more reviews with the word "love" or with the word "hate" in them?
-- number of reviews with the word 'love' : 1780
SELECT COUNT(*) AS total_reviews
FROM review
WHERE text LIKE '%love%';

-- number of reviews with the word 'hate' : 232
SELECT COUNT(*) AS total_reviews
FROM review
WHERE text LIKE '%hate%';

--10. Find the top 10 users with the most fans:
SELECT id, 
	name,
	fans
FROM user
ORDER BY fans DESC
LIMIT 10;

--Part 2: Inferences and Analysis

/*
1. Pick one city and category of your choice and group the businesses in that city or category by their overall star rating. 
Compare the businesses with 2-3 stars to the businesses with 4-5 stars and answer the following questions. Include your code.
*/
-- I pick the food category businesses for analysis.

SELECT name,
	city,
	category,
	ROUND(AVG(review_count),2) AS avg_reviews,
	COUNT(DISTINCT hours) AS open_days,
	CASE
		WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
		WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
		ELSE '1~2 star'
	END stars_group,
	latitude,
	longitude,
	postal_code,
	address
FROM hours h
	LEFT JOIN business b ON b.id = h.business_id
	LEFT JOIN category c ON h.business_id = c.business_id
WHERE stars_group IN('2~3 star', '4~5 star') AND
	category LIKE '%Food%'
GROUP BY name;



--i. Do the two groups you chose to analyze have a different distribution of hours?
-- group 2~3 stars : 6.83 days
-- group 4~5 stars : 6.58 days
--In all categories related to food, businesses rated 2~3 stars have slightly more average opening days than those rated 4~5 stars.

SELECT stars_group,
	AVG(open_days) AS avg_open_days
FROM   (
	SELECT name,
		--city,
		--category,
		--ROUND(AVG(review_count),2) AS avg_reviews,
		COUNT(DISTINCT hours) AS open_days,
		CASE
			WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
			WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
			ELSE '1~2 star'
		END stars_group
		--latitude,
		--longitude,
		--postal_code,
		--address
	FROM hours h
		LEFT JOIN business b ON b.id = h.business_id
		LEFT JOIN category c ON h.business_id = c.business_id
	WHERE stars_group IN('2~3 star', '4~5 star') AND
		category LIKE '%Food%'
	GROUP BY name
	)
GROUP BY stars_group;

--distribution of hours
SELECT stars_group,
	open_day,
	COUNT(open_day) AS count
FROM   (
	SELECT name,
	--city,
	--category,
	--ROUND(AVG(review_count),2) AS avg_reviews,
	hours,
	--COUNT(DISTINCT hours) AS open_days,
	CASE
		WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
		WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
		ELSE '1~2 star'
	END stars_group,
	CASE
		WHEN hours LIKE 'Friday%' THEN 'Friday'
		WHEN hours LIKE 'Tuesday%' THEN 'Tuesday'
		WHEN hours LIKE 'Saturday%' THEN 'Saturday'
		WHEN hours LIKE 'Sunday%' THEN 'Sunday'
		WHEN hours LIKE 'Thursday%' THEN 'Thursday'
		WHEN hours LIKE 'Monday%' THEN 'Monday'
		ELSE 'Wednesday'
	END open_day
	--latitude,
	--longitude,
	--postal_code,
	--address
	FROM hours h
		LEFT JOIN business b ON b.id = h.business_id
		LEFT JOIN category c ON h.business_id = c.business_id
	WHERE stars_group IN('2~3 star', '4~5 star') AND
		category LIKE '%Food%'
	)
GROUP BY open_day, stars_group
ORDER BY stars_group

--ii. Do the two groups you chose to analyze have a different number of reviews?
-- group 2~3 stars : 14.5 reviews
-- group 4~5 stars : 133.83 reviews
--In all categories related to food, businesses rated 4~5 stars have more reviews than those rated 2-3 stars

SELECT stars_group,
	AVG(avg_reviews) AS avg_reviews
FROM(
	SELECT name,
		--city,
		--category,
		ROUND(AVG(review_count),2) AS avg_reviews,
		--COUNT(DISTINCT hours) AS open_days,
		CASE
			WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
			WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
			ELSE '1~2 star'
		END stars_group
		--latitude,
		--longitude,
		--postal_code,
		--address
	FROM hours h
		LEFT JOIN business b ON b.id = h.business_id
		LEFT JOIN category c ON h.business_id = c.business_id
	WHERE stars_group IN('2~3 star', '4~5 star') AND
		category LIKE '%Food%'
	GROUP BY name
	)
GROUP BY stars_group;

--iii. Are you able to infer anything from the location data provided between these two groups? Explain.
--I realise that those business rated 4~5 stars will be close to each other
--However, business rated 2~3 stars are far from each other
--Interestingly, business rated 2~3 stars are closer to business rated 4~5 stars


/* 
In the same city, how far or near are between businesses rated 2~3 stars and those rated 4~5 stars
*/ 

SELECT A.postal_code AS postal_code_l,
	B.postal_code AS postal_code_h,
	A.city
FROM(
	SELECT name,
		city,
		postal_code,
		address,
		category,
		CASE
			WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
			WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
			ELSE '1~2 star'
		END stars_group
		
	FROM hours h
		LEFT JOIN business b ON b.id = h.business_id
		LEFT JOIN category c ON h.business_id = c.business_id
	WHERE stars_group IN('2~3 star', '4~5 star') AND
		category LIKE '%Food%'
	GROUP BY name
	ORDER BY stars, city
	) A,
	(
	SELECT name,
		city,
		postal_code,
		address,
		category,
		CASE
			WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
			WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
			ELSE '1~2 star'
		END stars_group
		
	FROM hours h
		LEFT JOIN business b ON b.id = h.business_id
		LEFT JOIN category c ON h.business_id = c.business_id
	WHERE stars_group IN('2~3 star', '4~5 star') AND
		category LIKE '%Food%'
	GROUP BY name
	ORDER BY stars, city
	) B
WHERE A.city = B.city AND
	A.stars_group <> B.stars_group AND
	A.stars_group = '2~3 star'
	
ORDER BY A.city;


/*
In the same city, how near are businesses rated the same stars.
*/

SELECT A.postal_code AS postal_code_1,
	B.postal_code AS postal_code_2,
	A.city,
	A.address,
	B.address,
	A.stars_group
FROM(
	SELECT name,
		city,
		postal_code,
		address,
		category,
		CASE
			WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
			WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
			ELSE '1~2 star'
		END stars_group
		
	FROM hours h
		LEFT JOIN business b ON b.id = h.business_id
		LEFT JOIN category c ON h.business_id = c.business_id
	WHERE stars_group IN('2~3 star', '4~5 star') AND
		category LIKE '%Food%'
	GROUP BY name
	ORDER BY stars, city
	) A,
	(
	SELECT name,
		city,
		postal_code,
		address,
		category,
		CASE
			WHEN stars >= 2 AND stars <= 3 THEN '2~3 star'
			WHEN stars >=4 AND stars <= 5 THEN '4~5 star'
			ELSE '1~2 star'
		END stars_group
		
	FROM hours h
		LEFT JOIN business b ON b.id = h.business_id
		LEFT JOIN category c ON h.business_id = c.business_id
	WHERE stars_group IN('2~3 star', '4~5 star') AND
		category LIKE '%Food%'
	GROUP BY name
	ORDER BY stars, city
	) B
WHERE A.city = B.city AND
	A.stars_group = B.stars_group AND
	postal_code_1 <> postal_code_2
	
ORDER BY A.city;



/*
2. Group business based on the ones that are open and the ones that are closed. 
What differences can you find between the ones that are still open and the ones that are closed? 
List at least two differences and the SQL code you used to arrive at your answer.
*/

--i. Difference 1:
--reviews

--ii. Difference 2:
--stars/rating

SELECT is_open,
	COUNT(review_count) AS reviews,
	ROUND(AVG(stars), 2) AS avg_rating
FROM business
GROUP BY is_open

/*
3. For this last part of your analysis, you are going to choose the type of analysis you want to conduct on 
the Yelp dataset and are going to prepare the data for analysis.

Ideas for analysis include: Parsing out keywords and business attributes for sentiment analysis, 
clustering businesses to find commonalities or anomalies between them, 
predicting the overall star rating for a business, predicting the number of fans a user will have, and so on. 
These are just a few examples to get you started, so feel free to be creative and come up with your own problem you want to solve. 
Provide answers, in-line, to all of the following:
*/

--i. Indicate the type of analysis you chose to do:
--i. Write 1-2 brief paragraphs on the type of data you will need for your analysis and why you chose that data:
--iii. Output of your finished dataset:
--iv. Provide the SQL code you used to create your final dataset:

-- 1. clustering business categories by reviews to find commonalities or differences
SELECT b.id,
    name,
    b.stars,
    review_count,
    category,
    text
FROM business b
    LEFT JOIN category c ON b.id = c.business_id
    LEFT JOIN review r ON b.id = r.business_id

--2. the relation between attributes and stars rating
SELECT a.business_id,
    b.name AS business_name,
    stars AS business_rating,
    a.name AS attribute_name,
    value
FROM attribute a
    LEFT JOIN business b ON b.id = a.business_id
WHERE b.name is not null;





