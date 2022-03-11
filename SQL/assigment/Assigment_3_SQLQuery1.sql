

CREATE TABLE Actions
(
Visitor_ID BIGINT,
Adv_Type VARCHAR(20),
[Action] VARCHAR(20),
);

INSERT Actions VALUES
(1,  'A'    , 'Left')
,(2,  'A'    , 'Order')
,(3,  'B'   , 'Left' )
,(4,  'A'    , 'Order' )
,(5,  'A'    , 'Review' )
,(6,  'A'    , 'Left' )
,(7,  'B'    , 'Left' )
,(8,  'B'    , 'Order' )
,(9,  'B'    , 'Review' )
,(10,  'A'    , 'Review')

select * 
from Actions

--2. b.	Retrieve count of total Actions, and Orders for each Advertisement Type

--3.Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.


SELECT Adv_Type, ROUND((SELECT CAST((SELECT Count(Action) 
					FROM Actions 
					WHERE Action = 'Order' AND Adv_Type = 'A' ) AS float) / (SELECT Count(Action)
				    FROM Actions
				    WHERE Adv_Type = 'A')),2) AS Conversion_Rate
FROM Actions
WHERE Adv_Type = 'A'
GROUP BY Adv_Type

UNION 

SELECT Adv_Type, ROUND((SELECT  CAST((SELECT Count(Action) 
					FROM Actions 
					WHERE Action = 'Order' AND Adv_Type = 'B' ) AS float) / (SELECT Count(Action)
				    FROM Actions
				    WHERE Adv_Type = 'B')),2) AS Conversion_Rate
FROM Actions
WHERE Adv_Type = 'B'
GROUP BY Adv_Type














