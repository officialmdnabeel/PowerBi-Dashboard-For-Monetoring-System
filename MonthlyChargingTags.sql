CREATE VIEW [dbo].MonthlyChargingTags AS

SELECT DISTINCT 
RTLSLogs.DBO.LE_TagBatteryMessage.TagCode,
APP_TAG.Hex as TagHexID,
LE_TagBatteryHealth.Percentage AS BatteryLevel,
LEFT ( RTLSLogs.DBO.LE_TagBatteryMessage.MessageDate,10) AS ChargingDay,
DATEADD(HOUR, 4,LE_TagBatteryHealth.UpdateDate) AS LastSeen,
DATEDIFF (DAY,RTLSLogs.DBO.LE_TagBatteryMessage.MessageDate,LE_TagBatteryHealth.UpdateDate) As WorkingDays

FROM
APP_TAG
JOIN RTLSLogs.DBO.LE_TagBatteryMessage ON APP_TAG.PrimaryCode = RTLSLogs.DBO.LE_TagBatteryMessage.TagCode  AND RTLSLogs.DBO.LE_TagBatteryMessage.IsCharging=1



JOIN APP_ENTITY_TAG_RELATION ON APP_ENTITY_TAG_RELATION.TagID = APP_TAG.ID AND APP_ENTITY_TAG_RELATION.Status = 1

JOIN LE_TagBatteryHealth ON LE_TagBatteryHealth.TagCode=APP_TAG.PrimaryCode