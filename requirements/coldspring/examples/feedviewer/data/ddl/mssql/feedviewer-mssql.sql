IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'dbAggregator')
	DROP DATABASE [dbAggregator]
GO

CREATE DATABASE [dbAggregator]  ON (NAME = N'dbAggregator_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\Data\dbAggregator_Data.MDF' , SIZE = 1, FILEGROWTH = 10%) LOG ON (NAME = N'dbAggregator_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\Data\dbAggregator_Log.LDF' , SIZE = 1, FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'dbAggregator', N'autoclose', N'true'
GO

exec sp_dboption N'dbAggregator', N'bulkcopy', N'false'
GO

exec sp_dboption N'dbAggregator', N'trunc. log', N'true'
GO

exec sp_dboption N'dbAggregator', N'torn page detection', N'true'
GO

exec sp_dboption N'dbAggregator', N'read only', N'false'
GO

exec sp_dboption N'dbAggregator', N'dbo use', N'false'
GO

exec sp_dboption N'dbAggregator', N'single', N'false'
GO

exec sp_dboption N'dbAggregator', N'autoshrink', N'true'
GO

exec sp_dboption N'dbAggregator', N'ANSI null default', N'false'
GO

exec sp_dboption N'dbAggregator', N'recursive triggers', N'false'
GO

exec sp_dboption N'dbAggregator', N'ANSI nulls', N'false'
GO

exec sp_dboption N'dbAggregator', N'concat null yields null', N'false'
GO

exec sp_dboption N'dbAggregator', N'cursor close on commit', N'false'
GO

exec sp_dboption N'dbAggregator', N'default to local cursor', N'false'
GO

exec sp_dboption N'dbAggregator', N'quoted identifier', N'false'
GO

exec sp_dboption N'dbAggregator', N'ANSI warnings', N'false'
GO

exec sp_dboption N'dbAggregator', N'auto create statistics', N'true'
GO

exec sp_dboption N'dbAggregator', N'auto update statistics', N'true'
GO

if( ( (@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 724) ) or ( (@@microsoftversion / power(2, 24) = 7) and (@@microsoftversion & 0xffff >= 1082) ) )
	exec sp_dboption N'dbAggregator', N'db chaining', N'false'
GO

use [dbAggregator]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[category]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[category]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[category_channels]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[category_channels]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[channel]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[channel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[entry]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[entry]
GO

CREATE TABLE [dbo].[category] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[description] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[category_channels] (
	[fk_category_id] [int] NOT NULL ,
	[fk_channel_id] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[channel] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[title] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[url] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[description] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[entry] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[fk_channel_id] [int] NOT NULL ,
	[url] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[title] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[body] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[authored_on] [datetime] NULL ,
	[authored_by] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[guid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[retrieved_on] [datetime] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

