CREATE VIEW [dbo].[ChargingDataView] AS

SELECT 
[dbo].[TagState].EmpName ,
[dbo].[TagState].EmpNo ,
[dbo].[TagState].EmpEmail,
[dbo].MonthlyChargingTags.TagHexID,
[dbo].MonthlyChargingTags.BatteryLevel,
[dbo].MonthlyChargingTags.ChargingDay,
[dbo].MonthlyChargingTags.LastSeen,
[dbo].MonthlyChargingTags.WorkingDays
FROM [dbo].MonthlyChargingTags,[dbo].[TagState]

WHERE
[dbo].[TagState].TagHexID = [dbo].MonthlyChargingTags.TagHexID
AND ChargingDay >= DATEADD(Day,-30, GETDATE())




