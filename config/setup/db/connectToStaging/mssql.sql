if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tadstats]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tadstats]
GO

CREATE VIEW [dbo].[tadstats] AS SELECT * FROM [muradb].[dbo].[tadstats]
GO
   
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tclassextenddatauseractivity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tclassextenddatauseractivity]
GO

CREATE VIEW [dbo].[tclassextenddatauseractivity] AS SELECT * FROM [muradb].[dbo].[tclassextenddatauseractivity];
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[temailreturnstats]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[temailreturnstats]
GO

CREATE VIEW [dbo].[temailreturnstats] AS SELECT * FROM [muradb].[dbo].[temailreturnstats]
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[temails]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[temails]
GO

CREATE VIEW [dbo].[temails] AS SELECT * FROM [muradb].[dbo].[temails]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[temailstats]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[temailstats]
GO

CREATE VIEW [dbo].[temailstats] AS SELECT * FROM [muradb].[dbo].[temailstats]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tformresponsepackets]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tformresponsepackets]
GO

CREATE VIEW [dbo].[tformresponsepackets] AS SELECT * FROM [muradb].[dbo].[tformresponsepackets]
GO
   
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tformresponsequestions]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tformresponsequestions]
GO

CREATE VIEW [dbo].[tformresponsequestions] AS SELECT * FROM [muradb].[dbo].[tformresponsequestions]
GO
  
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tsessiontracking]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tsessiontracking]
GO

CREATE VIEW [dbo].[tsessiontracking] AS SELECT * FROM [muradb].[dbo].[tsessiontracking]; 
GO
      
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tuseraddresses]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tuseraddresses]
GO 

CREATE VIEW [dbo].[tuseraddresses] AS SELECT * FROM [muradb].[dbo].[tuseraddresses]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tusers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tusers]
GO 

CREATE VIEW [dbo].[tusers] AS SELECT * FROM [muradb].[dbo].[tusers]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tuserstags]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tuserstags]
GO 

CREATE VIEW [dbo].[tuserstags] AS SELECT * FROM [muradb].[dbo].[tuserstags]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tuserremotesessions]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tuserremotesessions]
GO 

CREATE VIEW [dbo].[tuserremotesessions] AS SELECT * FROM [muradb].[dbo].[tuserremotesessions]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tuserstrikes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tuserstrikes]
GO 

CREATE VIEW [dbo].[tuserstrikes] AS SELECT * FROM [muradb].[dbo].[tuserstrikes]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tclassextend]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tclassextend]
GO 

CREATE VIEW [dbo].[tclassextend] AS SELECT * FROM [muradb].[dbo].[tclassextend]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tclassextendsets]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tclassextendsets]
GO 

CREATE VIEW [dbo].[tclassextendsets] AS SELECT * FROM [muradb].[dbo].[tclassextendsets]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tclassextendattributes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tclassextendattributes]
GO 

CREATE VIEW [dbo].[tclassextendattributes] AS SELECT * FROM [muradb].[dbo].[tclassextendattributes]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tplugins]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tplugins]
GO 

CREATE VIEW [dbo].[tplugins] AS SELECT * FROM [muradb].[dbo].[tplugins]
GO
