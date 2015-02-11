
CREATE TABLE [dbo].[tcontent] (
	[tcontent_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[SiteID] [nvarchar] (25) NULL ,
	[ModuleID] [char] (35) NULL ,
	[ParentID] [char] (35) NULL ,
	[ContentID] [char] (35) NULL ,
	[ContentHistID] [char] (35) NULL ,
	[RemoteID] [nvarchar] (255) NULL ,
	[RemoteURL] [nvarchar] (255) NULL ,
	[RemotePubDate] [nvarchar] (50) NULL ,
	[RemoteSourceURL] [nvarchar] (255) NULL ,
	[RemoteSource] [nvarchar] (255) NULL ,
	[Credits] [nvarchar] (255) NULL ,
	[FileID] [char] (35) NULL ,
	[Template] [nvarchar] (50) NULL ,
	[Type] [nvarchar] (25) NULL ,
	[subType] [nvarchar] (25) NULL ,
	[Active] [tinyint] NULL ,
	[OrderNo] [int] NULL ,
	[Title] [nvarchar] (255) NULL ,
	[MenuTitle] [nvarchar] (255) NULL ,
	[Summary] [nvarchar] (max) NULL ,
	[Filename] [nvarchar] (255) NULL ,
	[MetaDesc] [nvarchar] (max) NULL ,
	[MetaKeyWords] [nvarchar] (max) NULL ,
	[Body] [nvarchar] (max) NULL ,
	[lastUpdate] [datetime] NULL ,
	[lastUpdateBy] [nvarchar] (50) NULL ,
	[lastUpdateByID] [nvarchar] (50) NULL ,
	[DisplayStart] [datetime] NULL ,
	[DisplayStop] [datetime] NULL ,
	[Display] [tinyint] NULL ,
	[Approved] [tinyint] NULL ,
	[IsNav] [tinyint] NULL ,
	[Restricted] [tinyint] NULL ,
	[RestrictGroups] [nvarchar] (255) NULL ,
	[Target] [nvarchar] (50) NULL ,
	[TargetParams] [nvarchar] (255) NULL ,
	[responseChart] [tinyint] NULL ,
	[responseMessage] [nvarchar] (max) NULL ,
	[responseSendTo] [nvarchar] (max) NULL ,
	[responseDisplayFields] [nvarchar] (max) NULL ,
	[moduleAssign] [nvarchar] (255) NULL ,
	[displayTitle] [tinyint] NULL ,
	[Notes] [nvarchar] (max) NULL ,
	[inheritObjects] [nvarchar] (25) NULL ,
	[isFeature] [tinyint] NULL ,
	[ReleaseDate] [datetime] NULL ,
	[IsLocked] [tinyint] NULL ,
	[nextN] [int] NULL ,
	[sortBy] [nvarchar] (50) NULL ,
	[sortDirection] [nvarchar] (50) NULL ,
	[featureStart] [datetime] NULL ,
	[featureStop] [datetime] NULL ,
	[forceSSL] [tinyint] NOT NULL ,
	[audience] [nvarchar] (255) NULL ,
	[keyPoints] [nvarchar] (max) NULL ,
	[searchExclude] [tinyint] NULL ,
	[path] [nvarchar] (max) NULL ,
	[tags] [nvarchar] (max) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



CREATE TABLE [dbo].[tcontentstats] (
  [contentID] char(35) NOT NULL,
  [siteID] varchar(25) NOT NULL,
  [views] [int]  NOT NULL,
  [rating] [float] NOT NULL,
  [totalVotes] [int]  NOT NULL,
  [upVotes] [int]  NOT NULL,
  [downVotes] [int]  NOT NULL,
  [comments] [int]  NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentassignments] (
	[contentID] [char] (35) NOT NULL ,
	[contentHistID] [char] (35) NOT NULL ,
	[siteID] [nvarchar] (50) NOT NULL ,
	[userID] [char] (35) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentcategories] (
	[categoryID] [char] (35) NOT NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[parentID] [char] (35) NULL ,
	[dateCreated] [datetime] NULL ,
	[lastUpdate] [datetime] NULL ,
	[lastUpdateBy] [nvarchar] (50) NULL ,
	[name] [nvarchar] (50) NULL ,
	[notes] [nvarchar] (max) NULL ,
	[isInterestGroup] [int] NULL ,
	[isActive] [int] NULL ,
	[isOpen] [int] NULL ,
	[sortBy] [varchar] (50) NULL ,
	[sortDirection] [varchar] (50) NULL ,
	[restrictGroups] [nvarchar] (255) NULL ,
	[path] [nvarchar] (max) NULL ,
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentcategoryassign] (
	[contentHistID] [char] (35) NOT NULL ,
	[categoryID] [char] (35) NOT NULL ,
	[contentID] [char] (35) NULL ,
	[isFeature] [int] NULL ,
	[orderno] [int] NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[featureStart] [datetime] NULL ,
	[featureStop] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentcomments] (
	[commentid] [char] (35) NOT NULL ,
	[contentid] [char] (35) NULL ,
	[contenthistid] [char] (35) NULL ,
	[url] [nvarchar] (50) NULL ,
	[name] [nvarchar] (50) NULL ,
	[comments] [nvarchar] (max) NULL ,
	[entered] [datetime] NULL ,
	[email] [nvarchar] (100) NULL ,
	[siteid] [nvarchar] (25) NULL ,
	[ip] [nvarchar] (50) NULL ,
	[isApproved] [tinyint] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontenteventreminders] (
	[contentId] [char] (35) NOT NULL ,
	[siteId] [nvarchar] (25) NOT NULL ,
	[email] [nvarchar] (200) NOT NULL ,
	[RemindDate] [datetime] NULL ,
	[RemindHour] [int] NULL ,
	[RemindMinute] [int] NULL ,
	[RemindInterval] [int] NULL ,
	[isSent] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentfeedadvancedparams] (
	[paramID] [char] (35) NOT NULL ,
	[feedID] [char] (35) NOT NULL ,
	[param] [numeric](18, 0) NULL ,
	[relationship] [nvarchar] (50) NULL ,
	[field] [nvarchar] (100) NULL ,
	[condition] [nvarchar] (50) NULL ,
	[criteria] [nvarchar] (200) NULL ,
	[dataType] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentfeeditems] (
	[feedID] [char] (35) NOT NULL ,
	[itemID] [char] (35) NOT NULL ,
	[type] [varchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentfeeds] (
	[feedID] [char] (35) NOT NULL ,
	[siteID] [varchar] (25) NULL ,
	[parentID] [char] (35) NULL ,
	[name] [varchar] (250) NULL ,
	[isActive] [tinyint] NULL ,
	[isPublic] [tinyint] NULL ,
	[isDefault] [tinyint] NULL ,
	[isFeaturesOnly] [tinyint] NULL ,
	[description] [nvarchar] (max) NULL ,
	[maxItems] [int] NULL ,
	[allowHTML] [tinyint] NULL ,
	[lang] [varchar] (50) NULL ,
	[lastUpdateBy] [varchar] (100) NULL ,
	[lastUpdate] [datetime] NULL ,
	[dateCreated] [datetime] NULL ,
	[restricted] [tinyint] NULL ,
	[restrictGroups] [nvarchar] (max) NULL ,
	[version] [varchar] (50) NULL ,
	[channelLink] [varchar] (250) NULL ,
	[Type] [varchar] (50) NULL ,
	[sortBy] [varchar] (50) NULL ,
	[sortDirection] [varchar] (50) NULL ,
	[nextN] [int] NULL ,
	[displayName] [tinyint] NULL,
	[displayRatings] [tinyint] NULL,
	[displayComments] [tinyint] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentobjects] (
	[ContentHistID] [char] (35) NOT NULL ,
	[ObjectID] [nvarchar] (100) NOT NULL ,
	[Object] [nvarchar] (50) NOT NULL ,
	[ContentID] [char] (35) NULL ,
	[Name] [nvarchar] (255) NULL ,
	[OrderNo] [int] NULL ,
	[SiteID] [nvarchar] (25) NULL ,
	[ColumnID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentdisplaytitleapprovals] (
	[contentid] [char] (35) NOT NULL ,
	[isApproved] [tinyint] NULL ,
	[email] [nvarchar] (150) NULL ,
	[siteid] [nvarchar] (25) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentratings] (
	[contentID] [char] (35) NOT NULL ,
	[userID] [char] (35) NOT NULL ,
	[siteID] [char] (25) NOT NULL ,
	[rate] [int] NULL ,
	[entered] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentrelated] (
	[contentHistID] [char] (35) NOT NULL ,
	[relatedID] [char] (35) NOT NULL ,
	[contentID] [char] (35) NOT NULL ,
	[siteID] [varchar] (25) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[temailreturnstats] (
	[emailID] [char] (35) NULL ,
	[email] [nvarchar] (100) NULL ,
	[url] [nvarchar] (1500) NULL ,
	[created] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[temailstats] (
	[EmailID] [char] (35) NULL ,
	[Email] [varchar] (100) NULL ,
	[emailOpen] [int] NOT NULL ,
	[returnClick] [int] NOT NULL ,
	[bounce] [int] NOT NULL ,
	[sent] [int] NOT NULL ,
	[Created] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[temails] (
	[EmailID] [char] (35) NOT NULL ,
	[siteid] [nvarchar] (25) NULL ,
	[Subject] [nvarchar] (255) NULL ,
	[BodyText] [nvarchar] (max) NULL ,
	[BodyHtml] [nvarchar] (max) NULL ,
	[CreatedDate] [datetime] NULL ,
	[DeliveryDate] [datetime] NULL ,
	[status] [tinyint] NULL ,
	[GroupList] [nvarchar] (max) NULL ,
	[LastUpdateBy] [nvarchar] (50) NULL ,
	[LastUpdateByID] [nvarchar] (35) NULL ,
	[NumberSent] [int] NOT NULL ,
	[ReplyTo] [nvarchar] (50) NULL ,
	[format] [nvarchar] (50) NULL ,
	[fromLabel] [nvarchar] (50) NULL ,
	[isDeleted] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tfiles] (
	[fileID] [char] (35) NOT NULL ,
	[contentID] [char] (35) NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[moduleID] [char] (35) NULL ,
	[filename] [nvarchar] (200) NULL ,
	[image] [varbinary] (max) NULL ,
	[imageSmall] [varbinary] (max) NULL ,
	[imageMedium] [varbinary] (max) NULL ,
	[fileSize] [int] NULL ,
	[contentType] [nvarchar] (100) NULL ,
	[contentSubType] [nvarchar] (200) NULL ,
	[fileExt] [nvarchar] (50) NULL,
	[created] [datetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tformresponsepackets] (
	[ResponseID] [char] (35) NOT NULL ,
	[FormID] [char] (35) NULL ,
	[SiteID] [nvarchar] (25) NULL ,
	[FieldList] [nvarchar] (max) NULL ,
	[Data] [nvarchar] (max) NULL ,
	[Entered] [datetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tformresponsequestions] (
	[responseID] [char] (35) NULL ,
	[formID] [char] (35) NULL ,
	[formField] [nvarchar] (50) NULL ,
	[formValue] [nvarchar] (max) NULL ,
	[pollValue] [nvarchar] (255) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tglobals] (
	[appreload] [datetime] NULL, 
	[loadlist] [nvarchar] (500) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tmailinglist] (
	[MLID] [char] (35) NULL ,
	[SiteID] [nvarchar] (25) NULL ,
	[Name] [nvarchar] (50) NULL ,
	[Description] [nvarchar] (max) NULL ,
	[LastUpdate] [datetime] NULL ,
	[isPurge] [int] NULL ,
	[isPublic] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tmailinglistmembers] (
	[MLID] [char] (35) NULL ,
	[Email] [nvarchar] (100) NULL ,
	[SiteID] [nvarchar] (25) NULL ,
	[fname] [nvarchar] (50) NULL ,
	[lname] [nvarchar] (50) NULL ,
	[company] [nvarchar] (50) NULL ,
	[isVerified] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tpermissions] (
	[ContentID] [char] (35) NULL ,
	[GroupID] [char] (35) NULL ,
	[SiteID] [nvarchar] (25) NULL ,
	[Type] [nvarchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tredirects] (
	[redirectID] [char] (35) NOT NULL ,
	[URL] [nvarchar] (2000) NULL ,
	[created] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tsessiontracking] (
	[trackingID] [int] IDENTITY (1, 1) NOT NULL ,
	[contentID] [char] (35) NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[userid] [char] (35) NULL ,
	[remote_addr] [nvarchar] (50) NULL ,
	[server_name] [nvarchar] (50) NULL ,
	[query_string] [nvarchar] (300) NULL ,
	[referer] [nvarchar] (255) NULL ,
	[user_agent] [nvarchar] (200) NULL ,
	[script_name] [nvarchar] (200) NULL ,
	[urlToken] [nvarchar] (130) NOT NULL ,
	[entered] [datetime] NOT NULL ,
	[country] [nvarchar] (50) NULL ,
	[lang] [nvarchar] (50) NULL ,
	[locale] [nvarchar] (50) NULL ,
	[keywords] [nvarchar] (200) NULL ,
	[originalUrlToken] [nvarchar] (130) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tsettings] (
	[SiteID] [nvarchar] (25) NULL ,
	[Site] [nvarchar] (50) NULL ,
	[MaxNestLevel] [int] NULL ,
	[PageLimit] [int] NULL ,
	[Locking] [nvarchar] (50) NULL ,
	[Domain] [nvarchar] (100) NULL ,
	[exportLocation] [nvarchar] (100) NULL ,
	[FileDir] [nvarchar] (50) NULL ,
	[Contact] [nvarchar] (50) NULL ,
	[MailserverIP] [nvarchar] (50) NULL ,
	[MailServerUsername] [nvarchar] (50) NULL ,
	[MailServerPassword] [nvarchar] (50) NULL ,
	[EmailBroadcaster] [int] NULL ,
	[Extranet] [int] NULL ,
	[ExtranetPublicReg] [int] NULL ,
	[ExtranetPublicRegNotify] [nvarchar] (50) NULL ,
	[ExtranetSSL] [int] NULL ,
	[Cache] [int] NULL ,
	[ViewDepth] [int] NULL ,
	[NextN] [int] NULL ,
	[DataCollection] [int] NULL ,
	[columnCount] [int] NULL ,
	[columnNames] [nvarchar] (255) NULL ,
	[primaryColumn] [int] NULL ,
	[publicSubmission] [int] NULL ,
	[AdManager] [int] NULL ,
	[archiveDate] [datetime] NULL ,
	[contactName] [nvarchar] (50) NULL ,
	[contactAddress] [nvarchar] (50) NULL ,
	[contactCity] [nvarchar] (50) NULL ,
	[contactState] [nvarchar] (50) NULL ,
	[contactZip] [nvarchar] (50) NULL ,
	[contactEmail] [nvarchar] (100) NULL ,
	[contactPhone] [nvarchar] (50) NULL ,
	[privateUserPoolID] [nvarchar] (50) NULL ,
	[publicUserPoolID] [nvarchar] (50) NULL ,
	[advertiserUserPoolID] [nvarchar] (50) NULL ,
	[orderNo] [int] NULL ,
	[emailBroadcasterLimit] [int] NOT NULL ,
	[feedManager] [int] NULL ,
	[displayPoolID] [nvarchar] (50) NULL ,
	[galleryMainScaleBy] [nvarchar] (50) NULL ,
	[galleryMainScale] [int] NULL ,
	[gallerySmallScaleBy] [nvarchar] (50) NULL ,
	[gallerySmallScale] [int] NULL ,
	[galleryMediumScaleBy] [nvarchar] (50) NULL ,
	[galleryMediumScale] [int] NULL ,
	[sendLoginScript] [nvarchar] (max) NULL ,
	[mailingListConfirmScript] [nvarchar] (max) NULL ,
	[publicSubmissionApprovalScript] [nvarchar] (max) NULL ,
	[reminderScript] [nvarchar] (max) NULL ,
	[loginURL] [varchar] (255) NULL ,
	[editProfileURL] [varchar] (255) NULL ,
	[CommentApprovalDefault] [tinyint] NULL ,
	[deploy] [tinyint] NULL ,
	[lastDeployment] [datetime] NULL ,
	[accountActivationScript] [nvarchar] (max) NULL,
	[googleAPIKey] [varchar] (100) NULL ,
	[useDefaultSMTPServer] [tinyint] NULL,
    [theme] [varchar] (50) NULL,
 	[mailserverSMTPPort] [varchar] (5) NULL,
 	[mailserverPOPPort] [varchar] (5) NULL,
 	[mailserverTLS] [varchar] (5) NULL,
 	[mailserverSSL] [varchar] (5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tsystemobjects] (
	[Object] [nvarchar] (50) NULL ,
	[SiteID] [nvarchar] (25) NULL ,
	[Name] [nvarchar] (50) NULL ,
	[OrderNo] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tuseraddresses] (
	[addressID] [char] (35) NOT NULL ,
	[userID] [char] (35) NULL ,
	[siteID] [nvarchar] (50) NULL ,
	[addressName] [nvarchar] (50) NULL ,
	[address1] [nvarchar] (50) NULL ,
	[address2] [nvarchar] (50) NULL ,
	[city] [nvarchar] (50) NULL ,
	[state] [nvarchar] (50) NULL ,
	[zip] [nvarchar] (50) NULL ,
	[country] [nvarchar] (50) NULL ,
	[phone] [nvarchar] (50) NULL ,
	[fax] [nvarchar] (50) NULL ,
	[isPrimary] [tinyint] NULL ,
	[addressNotes] [nvarchar] (max) NULL,
	[addressURL] [nvarchar] (200) NULL,
	[longitude] [float] NULL,
  	[latitude] [float] NULL,
	[addressEmail] [nvarchar] (100) NULL,
	[hours] [nvarchar] (max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tusers] (
	[UserID] [char] (35) NOT NULL ,
	[GroupName] [nvarchar] (50) NULL ,
	[Fname] [nvarchar] (50) NULL ,
	[Lname] [nvarchar] (50) NULL ,
	[UserName] [nvarchar] (50) NULL ,
	[Password] [nvarchar] (50) NULL ,
	[PasswordCreated] [datetime] NULL ,
	[Email] [nvarchar] (100) NULL ,
	[Company] [nvarchar] (50) NULL ,
	[JobTitle] [nvarchar] (50) NULL ,
	[mobilePhone] [nvarchar] (50) NULL ,
	[Website] [nvarchar] (255) NULL ,
	[Type] [int] NULL ,
	[subType] [nvarchar] (50) NULL ,
	[Ext] [int] NULL ,
	[ContactForm] [nvarchar] (max) NULL ,
	[Admin] [int] NULL ,
	[S2] [int] NULL ,
	[LastLogin] [datetime] NULL ,
	[LastUpdate] [datetime] NULL ,
	[LastUpdateBy] [nvarchar] (50) NULL ,
	[LastUpdateByID] [nvarchar] (35) NULL ,
	[Perm] [tinyint] NULL ,
	[InActive] [tinyint] NULL ,
	[isPublic] [int] NULL ,
	[SiteID] [nvarchar] (50) NULL ,
	[Subscribe] [int] NULL ,
	[notes] [nvarchar] (max) NULL ,
	[description] [nvarchar] (max) NULL ,
	[interests] [nvarchar] (max) NULL ,
	[keepPrivate] [tinyint] NULL ,
	[photoFileID] [char] (35) NULL ,
	[IMName] [nvarchar] (100) NULL ,
	[IMService] [nvarchar] (50) NULL ,
	[created] [datetime] NULL,
	[remoteID] [nvarchar] (35) NULL,
	[tags] [nvarchar] (max) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tusersfavorites] (
	[favoriteID] [char] (35) NOT NULL ,
	[userID] [char] (35) NOT NULL ,
	[favoriteName] [varchar] (255) NULL ,
	[favorite] [varchar] (1000) NOT NULL ,
	[type] [varchar] (30) NOT NULL ,
	[siteID] [varchar] (25) NULL ,
	[dateCreated] [datetime] NOT NULL ,
	[columnNumber] [int] NULL ,
	[rowNumber] [int] NULL ,
	[maxRSSItems] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tusersinterests] (
	[userID] [char] (35) NOT NULL ,
	[categoryID] [char] (35) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tusersmemb] (
	[UserID] [char] (35) NOT NULL ,
	[GroupID] [char] (35) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontentpublicsubmissionapprovals] (
	[contentid] [char] (35) NOT NULL ,
	[isApproved] [tinyint] NULL ,
	[email] [nvarchar] (150) NULL ,
	[siteid] [varchar] (25) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tcontenttags] (
	[tagID] [int] IDENTITY (1, 1) NOT NULL ,
	[contentHistID] [char] (35) NOT NULL ,
	[contentID] [char] (35) NOT NULL ,
	[siteID] [char] (25) NOT NULL ,
	[tag] [nvarchar] (100) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tclassextenddatauseractivity] (
	[dataID] [int] IDENTITY (1, 1) NOT NULL ,
	[baseID] [char] (35) NOT NULL ,
	[attributeID] [int] NOT NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[attributeValue] [nvarchar] (max) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tclassextenddata] (
	[dataID] [int] IDENTITY (1, 1) NOT NULL ,
	[baseID] [char] (35) NOT NULL ,
	[attributeID] [int] NOT NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[attributeValue] [nvarchar] (max) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tclassextend] (
	[subTypeID] [char] (35) NOT NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[baseTable] [nvarchar] (50) NULL ,
	[baseKeyField] [nvarchar] (50) NULL ,
	[dataTable] [nvarchar] (50) NULL ,
	[type] [nvarchar] (50) NULL ,
	[subType] [nvarchar] (50) NULL ,
	[isActive] [tinyint] NULL ,
	[notes] [nvarchar] (max) NULL ,
	[lastUpdate] [datetime] NULL ,
	[dateCreated] [datetime] NULL ,
	[lastUpdateBy] [nvarchar] (100) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tclassextendattributes] (
	[attributeID] [int] IDENTITY (1, 1) NOT NULL ,
	[extendSetID] [char] (35) NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[name] [nvarchar] (100) NULL ,
	[label] [nvarchar] (max) NULL ,
	[hint] [nvarchar] (max)  NULL ,
	[type] [nvarchar] (100) NULL ,
	[orderno] [int] NULL ,
	[isActive] [tinyint] NULL ,
	[required] [nvarchar] (50) NULL ,
	[validation] [nvarchar] (50) NULL ,
	[regex] [nvarchar] (300) NULL ,
	[message] [nvarchar] (300) NULL ,
	[defaultValue] [nvarchar] (100) NULL ,
	[optionList] [nvarchar] (max) NULL ,
	[optionLabelList] [nvarchar] (max) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tclassextendsets] (
	[extendSetID] [char] (35) NOT NULL ,
	[subTypeID] [char] (35) NULL ,
	[categoryID] [nvarchar] (max) NULL ,
	[siteID] [nvarchar] (25) NULL ,
	[name] [nvarchar] (50) NULL ,
	[orderno] [int] NULL ,
	[isActive] [tinyint] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tuserstags] (
	[tagID] [int] IDENTITY (1, 1) NOT NULL ,
	[userID] [char] (35) NULL ,
	[siteid] [varchar] (25) NULL ,
	[tag] [varchar] (100) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tcontent] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontent_ID] PRIMARY KEY  CLUSTERED 
	(
		[tcontent_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentstats] WITH NOCHECK ADD 
	CONSTRAINT [DF__views] DEFAULT (0) FOR [views],
	CONSTRAINT [DF__rating] DEFAULT (0) FOR [rating],
	CONSTRAINT [DF__totalVotes] DEFAULT (0) FOR [totalVotes],
	CONSTRAINT [DF__upVotes] DEFAULT (0) FOR [upVotes],
	CONSTRAINT [DF__downVotes] DEFAULT (0) FOR [downVotes],
	CONSTRAINT [DF__comments] DEFAULT (0) FOR [comments]
GO

ALTER TABLE [dbo].[tcontentstats] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentstats] PRIMARY KEY  CLUSTERED 
	(
		[contentID],
		[siteID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[tcontentassignments] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentassignments] PRIMARY KEY  CLUSTERED 
	(
		[contentID],
		[contentHistID],
		[siteID],
		[userID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentcategories] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentcategories] PRIMARY KEY  CLUSTERED 
	(
		[categoryID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentcategoryassign] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentcategoryassign] PRIMARY KEY  CLUSTERED 
	(
		[contentHistID],
		[categoryID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentcomments] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentcomments] PRIMARY KEY  CLUSTERED 
	(
		[commentid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentfeedadvancedparams] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentFeedAdvanceParams] PRIMARY KEY  CLUSTERED 
	(
		[paramID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentfeeds] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentfeeds] PRIMARY KEY  CLUSTERED 
	(
		[feedID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentobjects] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentobjects] PRIMARY KEY  CLUSTERED 
	(
		[ContentHistID],
		[ObjectID],
		[Object],
		[ColumnID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentratings] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentratings] PRIMARY KEY  CLUSTERED 
	(
		[contentID],
		[userID],
		[siteID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontentrelated] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentrelated] PRIMARY KEY  CLUSTERED 
	(
		[contentHistID],
		[relatedID],
		[contentID],
		[siteID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[temails] WITH NOCHECK ADD 
	CONSTRAINT [PK_temails] PRIMARY KEY  CLUSTERED 
	(
		[EmailID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tfiles] WITH NOCHECK ADD 
	CONSTRAINT [PK_tfiles] PRIMARY KEY  CLUSTERED 
	(
		[fileID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tformresponsepackets] WITH NOCHECK ADD 
	CONSTRAINT [PK_tformresponsepackets] PRIMARY KEY  CLUSTERED 
	(
		[ResponseID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tredirects] WITH NOCHECK ADD 
	CONSTRAINT [PK_tredirects] PRIMARY KEY  CLUSTERED 
	(
		[redirectID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tsessiontracking] WITH NOCHECK ADD 
	CONSTRAINT [PK_tsessiontracking] PRIMARY KEY  CLUSTERED 
	(
		[trackingID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tuseraddresses] WITH NOCHECK ADD 
	CONSTRAINT [PK_tuseraddresses] PRIMARY KEY  CLUSTERED 
	(
		[addressID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tusersfavorites] WITH NOCHECK ADD 
	CONSTRAINT [PK_tusersfavorites] PRIMARY KEY  CLUSTERED 
	(
		[favoriteID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tusersinterests] WITH NOCHECK ADD 
	CONSTRAINT [PK_tusersinterests] PRIMARY KEY  CLUSTERED 
	(
		[userID],
		[categoryID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tusersmemb] WITH NOCHECK ADD 
	CONSTRAINT [PK_tusersmemb] PRIMARY KEY  CLUSTERED 
	(
		[UserID],
		[GroupID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tcontent] WITH NOCHECK ADD 
	CONSTRAINT [DF_tcontent_Active] DEFAULT (0) FOR [Active],
	CONSTRAINT [DF_tcontent_forceSSL] DEFAULT (0) FOR [forceSSL]
GO

ALTER TABLE [dbo].[tcontentcomments] WITH NOCHECK ADD 
	CONSTRAINT [DF_tcontentcomments_isApproved] DEFAULT (0) FOR [isApproved]
GO

ALTER TABLE [dbo].[tcontentratings] WITH NOCHECK ADD 
	CONSTRAINT [DF_tcontentratings_entered] DEFAULT (getdate()) FOR [entered]
GO

ALTER TABLE [dbo].[temailstats] WITH NOCHECK ADD 
	CONSTRAINT [DF_temailstats_emailOpen] DEFAULT (0) FOR [emailOpen],
	CONSTRAINT [DF_temailstats_returnClick] DEFAULT (0) FOR [returnClick],
	CONSTRAINT [DF_temailstats_bounce] DEFAULT (0) FOR [bounce],
	CONSTRAINT [DF_temailstats_sent] DEFAULT (0) FOR [sent]
GO

ALTER TABLE [dbo].[temails] WITH NOCHECK ADD 
	CONSTRAINT [DF_temails_NumberSent] DEFAULT (0) FOR [NumberSent],
	CONSTRAINT [DF_temails_isDeleted] DEFAULT (0) FOR [isDeleted]
GO

ALTER TABLE [dbo].[tusers] WITH NOCHECK ADD 
	CONSTRAINT [DF_tusers_created] DEFAULT (getdate()) FOR [created]
GO

ALTER TABLE [dbo].[tusersfavorites] WITH NOCHECK ADD 
	CONSTRAINT [DF_tusersfavorites_dateCreated] DEFAULT (getdate()) FOR [dateCreated]
GO

ALTER TABLE [dbo].[tclassextenddatauseractivity] WITH NOCHECK ADD 
	CONSTRAINT [PK_tclassextenddatauseractivity] PRIMARY KEY  CLUSTERED 
	(
		[dataID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tclassextenddata] WITH NOCHECK ADD 
	CONSTRAINT [PK_tclassextenddata] PRIMARY KEY  CLUSTERED 
	(
		[dataID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tclassextend] WITH NOCHECK ADD 
	CONSTRAINT [PK_TClassSubTypes] PRIMARY KEY  CLUSTERED 
	(
		[subTypeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tclassextendattributes] WITH NOCHECK ADD 
	CONSTRAINT [PK_tclassextendattributes] PRIMARY KEY  CLUSTERED 
	(
		[attributeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tclassextendsets] WITH NOCHECK ADD 
	CONSTRAINT [PK_tclassextendsets] PRIMARY KEY  CLUSTERED 
	(
		[extendSetID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[tcontenttags] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontenttags] PRIMARY KEY  CLUSTERED 
	(
		[tagID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tuserstags] WITH NOCHECK ADD 
	CONSTRAINT [PK_tuserstags] PRIMARY KEY  CLUSTERED 
	(
		[tagID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tusers] WITH NOCHECK ADD 
	CONSTRAINT [PK_tusers] PRIMARY KEY  CLUSTERED 
	(
		[userID]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tcontent] ON [dbo].[tcontent]([ContentID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontent_1] ON [dbo].[tcontent]([ContentHistID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontent_2] ON [dbo].[tcontent]([SiteID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontent_3] ON [dbo].[tcontent]([ParentID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontent_4] ON [dbo].[tcontent]([RemoteID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontent_5] ON [dbo].[tcontent]([ModuleID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontentcategories] ON [dbo].[tcontentcategories]([siteID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontentcomments] ON [dbo].[tcontentcomments]([contentid]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontentfeeds] ON [dbo].[tcontentfeeds]([siteID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontentobjects] ON [dbo].[tcontentobjects]([SiteID]) ON [PRIMARY]
GO

 CREATE  INDEX [IDX_ENTERED] ON [dbo].[tcontentratings]([entered]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_temails] ON [dbo].[temails]([siteid]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tformresponsepackets] ON [dbo].[tformresponsepackets]([FormID], [SiteID]) ON [PRIMARY]
GO

 CREATE  INDEX [IDX_ENTERED] ON [dbo].[tsessiontracking]([entered]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_tsessiontracking] ON [dbo].[tsessiontracking]([siteID]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_tsessiontracking_1] ON [dbo].[tsessiontracking]([contentID]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_tsessiontracking_2] ON [dbo].[tsessiontracking]([urlToken]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_tsessiontracking_3] ON [dbo].[tsessiontracking]([userID]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO


 CREATE  INDEX [IX_tcontentpublicsubmissionapprovals] ON [dbo].[tcontentpublicsubmissionapprovals]([contentid]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontentpublicsubmissionapprovals_1] ON [dbo].[tcontentpublicsubmissionapprovals]([siteid]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontenttags] ON [dbo].[tcontenttags]([tag]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontenttags_1] ON [dbo].[tcontenttags]([contentHistID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontenttags_2] ON [dbo].[tcontenttags]([contentID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tcontenttags_3] ON [dbo].[tcontenttags]([siteID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tuserstags] ON [dbo].[tuserstags]([userID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tuserstags_1] ON [dbo].[tuserstags]([siteid]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tuserstags_2] ON [dbo].[tuserstags]([tag]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tuseraddresses_1] ON [dbo].[tuseraddresses]([longitude]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tuseraddresses_2] ON [dbo].[tuseraddresses]([latitude]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tuseraddresses_3] ON [dbo].[tuseraddresses]([userID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tclassextenddatauseractivity_1] ON [dbo].[tclassextenddatauseractivity]([baseID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tclassextenddatauseractivity_2] ON [dbo].[tclassextenddatauseractivity]([attributeID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tclassextenddata_1] ON [dbo].[tclassextenddata]([baseID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tclassextenddata_2] ON [dbo].[tclassextenddata]([attributeID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tclassextendattributes_1] ON [dbo].[tclassextendattributes]([extendSetID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tclassextendsets_1] ON [dbo].[tclassextendsets]([subTypeID]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('event_reminder_form','default','Event Reminder Form',12);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('forward_email','default','Forward Email',13);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('site_map','default','Site Map',2);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('peer_nav','default','Peer Navigation',3);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('sub_nav','default','Sub Navigation',4);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('standard_nav','default','Standard Navigation',5);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('portal_nav','default','Portal Navigation',6);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('comments','default','Accept Comments',9);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('seq_nav','default','Sequential Nav',8);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('rater','default','Content Rater',16);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('favorites','default','User Favorites',17);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('related_content','default','Related Content',19);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('user_tools','default','User Tools',20);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('tag_cloud','default','Tag Cloud',21);
INSERT INTO [dbo].[tsystemobjects] ([Object],[SiteID],[Name],[OrderNo]) VALUES ('goToFirstChild','default','Go To First Child',23);
GO
<cfoutput>
INSERT INTO [dbo].[tusers] ([UserID],[GroupName],[Fname],[Lname],[UserName],[Password],[PasswordCreated],[Email],[Company],[JobTitle],[mobilePhone],[Website],[Type],[subType],[Ext],[ContactForm],[Admin],[S2],[LastLogin],[LastUpdate],[LastUpdateBy],[LastUpdateByID],[Perm],[InActive],[isPublic],[SiteID],[Subscribe],[notes],[keepPrivate],[tags]) VALUES ('#adminUserID#',NULL,'Admin','User','admin','21232F297A57A5A743894A0E4A801FC3',getDate(),'admin@localhost.com',NULL,NULL,NULL,NULL,2,'Default',NULL,NULL,NULL,1,getDate(),getDate(),'System','22FC551F-FABE-EA01-C6EDD0885DDC1682',0,0,0,'default',0,NULL,0,NULL);
INSERT INTO [dbo].[tusers] ([UserID],[GroupName],[Fname],[Lname],[UserName],[Password],[Email],[Company],[JobTitle],[mobilePhone],[Website],[Type],[subType],[Ext],[ContactForm],[Admin],[S2],[LastLogin],[LastUpdate],[LastUpdateBy],[LastUpdateByID],[Perm],[InActive],[isPublic],[SiteID],[Subscribe],[notes],[keepPrivate],[tags]) VALUES ('#createUUID()#','Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Default',NULL,NULL,NULL,0,NULL,getDate(),'System',NULL,1,0,0,'default',0,NULL,0,NULL);
GO
</cfoutput>
INSERT INTO [dbo].[tsettings] ([SiteID],[Site],[MaxNestLevel],[PageLimit],[Locking],[Domain],[exportLocation],[FileDir],[Contact],[MailserverIP],[MailServerUsername],[MailServerPassword],[EmailBroadcaster],[Extranet],[ExtranetPublicReg],[ExtranetPublicRegNotify],[ExtranetSSL],[Cache],[ViewDepth],[NextN],[DataCollection],[columnCount],[columnNames],[primaryColumn],[publicSubmission],[AdManager],[archiveDate],[contactName],[contactAddress],[contactCity],[contactState],[contactZip],[contactEmail],[contactPhone],[privateUserPoolID],[publicUserPoolID],[advertiserUserPoolID],[orderNo],[emailBroadcasterLimit],[feedManager],[displayPoolID],[galleryMainScaleBy],[galleryMainScale],[gallerySmallScaleBy],[gallerySmallScale],[galleryMediumScaleBy],[galleryMediumScale],[sendLoginScript],[mailingListConfirmScript],[publicSubmissionApprovalScript],[reminderScript],[loginURL],[editProfileURL],[CommentApprovalDefault],[deploy],[lastDeployment],[useDefaultSMTPServer]) VALUES ('default','Default',NULL,1000,'none','localhost',NULL,NULL,'info@getmura.com','mail.server.com','username@server.com','password',0,1,0,null,0,0,1,20,1,3,'Left Column^Main Content^Right Column',2,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default','default','default',1,0,1,'default','y',500,'s',100,'y',250,NULL,NULL,NULL,NULL,'?display=login','?display=editProfile',1,0,NULL,0);
GO

INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000003','00000000000000000000000000000000END','00000000000000000000000000000000003','6300ED4A-1320-5CC3-F9D6A2D279E386D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Components',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000004','00000000000000000000000000000000END','00000000000000000000000000000000004','6300ED59-1320-5CC3-F9706221E0EFF7A2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Forms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000001','6300ED69-1320-5CC3-F922E3012E2C6BAE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default.cfm','Page','Default',1,1,'Home','Home',NULL,NULL,NULL,NULL,NULL,getDate(),'System',NULL,NULL,NULL,1,1,1,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'Cascade',0,NULL,0,10,'orderno','asc',NULL,NULL,0,NULL,NULL,0,'''00000000000000000000000000000000001''');
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000006','00000000000000000000000000000000END','00000000000000000000000000000000006','6300ED79-1320-5CC3-F92E6325C26664B6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Advertising',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000000','6300ED88-1320-5CC3-F9E241684D21FEC9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000008','00000000000000000000000000000000END','00000000000000000000000000000000008','6300ED98-1320-5CC3-F9398EB23A57CBD0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Members',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000005','00000000000000000000000000000000END','00000000000000000000000000000000005','6300EDA8-1320-5CC3-F93DF074187C935E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Email Broadcaster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000009','00000000000000000000000000000000END','00000000000000000000000000000000009','6300EDB7-1320-5CC3-F9D664F38EBBD2D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Mailing Lists',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000010','00000000000000000000000000000000END','00000000000000000000000000000000010','6300EDC7-1320-5CC3-F9DB8034C9626B70',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Categories',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000011','00000000000000000000000000000000END','00000000000000000000000000000000011','6300EDD6-1320-5CC3-F9625545444B880F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Content Collections',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
INSERT INTO [dbo].[tcontent] ([SiteID],[ModuleID],[ParentID],[ContentID],[ContentHistID],[RemoteID],[RemoteURL],[RemotePubDate],[RemoteSourceURL],[RemoteSource],[Credits],[FileID],[Template],[Type],[subType],[Active],[OrderNo],[Title],[MenuTitle],[Summary],[Filename],[MetaDesc],[MetaKeyWords],[Body],[lastUpdate],[lastUpdateBy],[lastUpdateByID],[DisplayStart],[DisplayStop],[Display],[Approved],[IsNav],[Restricted],[RestrictGroups],[Target],[TargetParams],[responseChart],[responseMessage],[responseSendTo],[responseDisplayFields],[moduleAssign],[displayTitle],[Notes],[inheritObjects],[isFeature],[ReleaseDate],[IsLocked],[nextN],[sortBy],[sortDirection],[featureStart],[featureStop],[forceSSL],[audience],[keyPoints],[searchExclude],[path]) VALUES ('default','00000000000000000000000000000000012','00000000000000000000000000000000END','00000000000000000000000000000000012','6300EDE6-1320-5CC3-F94E2FCEF5DE046D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Filemanager Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
GO

<cfoutput>
INSERT INTO [dbo].[tmailinglist] ([MLID],[SiteID],[Name],[Description],[LastUpdate],[isPurge],[isPublic] ) 
VALUES ('#createUUID()#','default','Please Remove Me from All Lists','',getDate(),1,1)
GO
</cfoutput>

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

