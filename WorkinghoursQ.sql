
	WITH RankedSignals AS (
    SELECT  
        RTLSLogs.DBO.LE_TagBatteryMessage.TagCode,
        APP_TAG.Hex as TagHexID,
        DATEADD(HOUR, 4, RTLSLogs.DBO.LE_TagBatteryMessage.MessageDate) AS Signal,
        DATEADD(HOUR, 4, LE_TagBatteryHealth.UpdateDate) AS LastSeen,
        DATEDIFF(HOUR, RTLSLogs.DBO.LE_TagBatteryMessage.MessageDate, LE_TagBatteryHealth.UpdateDate) AS WorkingHours,
        ROW_NUMBER() OVER (
            PARTITION BY RTLSLogs.DBO.LE_TagBatteryMessage.TagCode
            ORDER BY RTLSLogs.DBO.LE_TagBatteryMessage.MessageDate ASC
        ) AS rn
    FROM
        APP_TAG
        JOIN RTLSLogs.DBO.LE_TagBatteryMessage 
            ON APP_TAG.PrimaryCode = RTLSLogs.DBO.LE_TagBatteryMessage.TagCode
        JOIN APP_ENTITY_TAG_RELATION 
            ON APP_ENTITY_TAG_RELATION.TagID = APP_TAG.ID 
            AND APP_ENTITY_TAG_RELATION.Status = 1
        JOIN LE_TagBatteryHealth 
            ON LE_TagBatteryHealth.TagCode = APP_TAG.PrimaryCode

    WHERE 
        RTLSLogs.DBO.LE_TagBatteryMessage.MessageDate >= CAST(GETDATE() AS DATE)
        AND RTLSLogs.DBO.LE_TagBatteryMessage.MessageDate <= DATEADD(DAY, 1, CAST(GETDATE() AS DATE))

)

SELECT
    TagCode,
    TagHexID,
    Signal,
    LastSeen,
    WorkingHours,
	CASE
	WHEN  LEFT ( Signal ,10 ) = LEFT ( Signal ,10 ) THEN   LEFT ( Signal ,10 )
	END AS H_DAY
FROM RankedSignals
WHERE rn = 1
