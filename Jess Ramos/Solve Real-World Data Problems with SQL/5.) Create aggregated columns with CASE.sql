SELECT
    F1.UserID,
    COUNT(CASE WHEN F1.eventid = 1 THEN F1.UserID ELSE NULL END) AS viewedhelpcenterpage,
    COUNT(CASE WHEN F1.eventid = 2 THEN F1.UserID ELSE NULL END) AS clickedfaqs,
    COUNT(CASE WHEN F1.eventid = 3 THEN F1.UserID ELSE NULL END) AS clickedcontactsupport,
    COUNT(CASE WHEN F1.eventid = 4 THEN F1.UserID ELSE NULL END) AS submittedticket
FROM FrontendEventLog F1
LEFT JOIN FrontendEventDefinitions F2 ON F1.eventid = F2.eventid
WHERE F2.eventtype = 'Customer Support'
GROUP BY UserID;
