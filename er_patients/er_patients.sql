SELECT * FROM visit;
SELECT * FROM patient;

# How many distinct visit reasons start with the word “Pain”?
SELECT COUNT(DISTINCT visitid) AS NumPainReason
FROM visit WHERE visitreason LIKE 'Pain%';

# What is the average cost of the most popular visit reason?
SELECT visitreason, AVG(cost) AS avgcost
FROM visit
WHERE visitreason = (SELECT visitreason
        FROM visit
        GROUP BY visitreason
        ORDER BY COUNT(*) DESC
        LIMIT 1);

# Which month and year (e.g., March 2017) had the greatest number of ER visits? 
SELECT 
    YEAR(arrivaldate),
    MONTH(arrivaldate),
    COUNT(visitid) AS NumERvisits
FROM
    visit
GROUP BY visitreason
ORDER BY NumERvisits DESC
LIMIT 1;

# What is the average cost of all emergency room visits for female patients?
SELECT AVG(cost) AS avgfemalecost
FROM visit JOIN patient ON visit.patientID = patient.patientID
WHERE patient.gender = 'Female';

# What is the most common visit reason of patients in their 20s (Age 20~29)? 
SELECT visitreason, COUNT(visitid) AS fall_count
FROM visit
WHERE
    arrivalmode = (SELECT arrivalmode
        FROM visit JOIN patient ON visit.patientID = patient.patientID
        GROUP BY arrivalmode
        ORDER BY AVG(age) ASC
        LIMIT 1)
        AND visitreason LIKE '%fall%'
GROUP BY visitreason;

# What is the hospital admission ratio of all ER visits?
SELECT (SELECT COUNT(visitid)
        FROM visit
        WHERE hospadmit = 'Yes') / COUNT(visitid) AS hospadmitratio 
        FROM visit;