<cfoutput>
CREATE TABLE tadcampaigns (
  campaignID char(35) NOT NULL default '',
  userID char(35) default NULL,
  dateCreated timestamp default NULL,
  lastUpdate timestamp default NULL,
  lastUpdateBy varchar(50) default NULL,
  name varchar(50) default NULL,
  startDate timestamp default NULL,
  endDate timestamp default NULL,
  isActive int default NULL,
  notes clob,
  PRIMARY KEY  (campaignID)
) ;

CREATE TABLE tadcreatives (
  creativeID char(35) NOT NULL default '',
  userID char(35) default NULL,
  dateCreated timestamp default NULL,
  lastUpdate timestamp default ('now'),
  lastUpdateBy varchar(50) default NULL,
  name varchar(50) default NULL,
  creativeType varchar(50) default NULL,
  fileID varchar(35) default NULL,
  mediaType varchar(50) default NULL,
  redirectURL varchar(200) default NULL,
  altText varchar(200) default NULL,
  notes clob,
  isActive int default NULL,
  height int default NULL,
  width int default NULL,
  textBody clob,
  PRIMARY KEY  (creativeID)
) ;



CREATE TABLE tadipwhitelist (
  IP varchar(50) NOT NULL default '',
  siteID varchar(50) NOT NULL default ''
) ;



CREATE TABLE tadplacementdetails (
  detailID integer generated always as identity (detailID_seq),
  placementID char(35) NOT NULL default '',
  PlacementType char(35) NOT NULL default '',
  PlacementValue int NOT NULL default 0,
   PRIMARY KEY  (detailID)
) ;


CREATE TABLE tadplacements (
  placementID char(35) NOT NULL default '',
  campaignID char(35) default NULL,
  adZoneID char(35) default NULL,
  creativeID char(35) default NULL,
  dateCreated timestamp default NULL,
  lastUpdate timestamp default ('now'),
  lastUpdateBy varchar(50) default NULL,
  startDate timestamp default NULL,
  endDate timestamp default NULL,
  costPerImp decimal(18,5) default NULL,
  costPerClick decimal(18,2) default NULL,
  isExclusive int default NULL,
  billable decimal(18,2) default NULL,
  budget int default NULL,
  isActive int default NULL,
  notes clob,
  PRIMARY KEY  (placementID)
) ;


CREATE TABLE tadstats (
  statID integer generated always as identity (statID_seq),
  PlacementID char(35) default NULL,
  StatHour int default NULL,
  StatDate timestamp default NULL,
  Type varchar(50) default NULL,
  counter int default NULL,
   PRIMARY KEY  (statID)
) ;


CREATE TABLE tadzones (
  adZoneID char(35) NOT NULL default '',
  siteID varchar(25) default NULL,
  dateCreated timestamp default NULL,
  lastUpdate timestamp default ('now'),
  lastUpdateBy varchar(50) default NULL,
  name varchar(50) default NULL,
  creativeType varchar(50) default NULL,
  notes clob,
  isActive int default NULL,
  height int default NULL,
  width int default NULL,
   PRIMARY KEY  (adZoneID)
) ;


CREATE TABLE tcaptcha (
  LetterID int NOT NULL default 0,
  Letter char(1) default NULL,
  ImageFile varchar(50) default NULL
) ;


INSERT INTO tcaptcha (LetterID,Letter,ImageFile) VALUES
(1,'a','a.gif'),
(2,'b','b.gif'),
(3,'c','c.gif'),
(4,'d','d.gif'),
(5,'e','e.gif'),
(6,'f','f.gif'),
(7,'g','g.gif'),
(8,'h','h.gif'),
(9,'i','i.gif'),
(10,'j','j.gif'),
(11,'k','k.gif'),
(12,'l','l.gif'),
(13,'m','m.gif'),
(14,'n','n.gif'),
(15,'o','o.gif'),
(16,'p','p.gif'),
(17,'q','q.gif'),
(18,'r','r.gif'),
(19,'s','s.gif'),
(20,'t','t.gif'),
(21,'u','u.gif'),
(22,'v','v.gif'),
(23,'w','w.gif'),
(24,'x','x.gif'),
(25,'y','y.gif'),
(26,'z','z.gif');

CREATE TABLE tcontent (
  TContent_ID integer generated always as identity (tcontent_ID_seq),
  SiteID varchar(25) default NULL,
  ModuleID char(35) default NULL,
  ParentID char(35) default NULL,
  ContentID char(35) default NULL,
  ContentHistID char(35) default NULL,
  RemoteID varchar(255) default NULL,
  RemoteURL varchar(255) default NULL,
  RemotePubDate varchar(50) default NULL,
  RemoteSourceURL varchar(255) default NULL,
  RemoteSource varchar(255) default NULL,
  Credits varchar(255) default NULL,
  FileID char(35) default NULL,
  Template varchar(50) default NULL,
  Type varchar(25) default NULL,
  subType varchar(25) default NULL,
  Active smallint default 0,
  OrderNo int default NULL,
  Title varchar(255) default NULL,
  MenuTitle varchar(255) default NULL,
  Summary clob,
  Filename varchar(255) default NULL,
  MetaDesc clob,
  MetaKeyWords clob,
  Body clob,
  lastUpdate timestamp default ('now'),
  lastUpdateBy varchar(50) default NULL,
  lastUpdateByID varchar(50) default NULL,
  DisplayStart timestamp default NULL,
  DisplayStop timestamp default NULL,
  Display smallint default NULL,
  Approved smallint default NULL,
  IsNav smallint default NULL,
  Restricted smallint default NULL,
  RestrictGroups varchar(255) default NULL,
  Target varchar(50) default NULL,
  TargetParams varchar(255) default NULL,
  responseChart smallint default NULL,
  responseMessage clob,
  responseSendTo clob,
  responseDisplayFields clob,
  moduleAssign varchar(255) default NULL,
  displayTitle smallint default NULL,
  Notes clob,
  inheritObjects varchar(25) default NULL,
  isFeature smallint default NULL,
  ReleaseDate timestamp default NULL,
  IsLocked smallint default NULL,
  nextN int default NULL,
  sortBy varchar(50) default NULL,
  sortDirection varchar(50) default NULL,
  featureStart timestamp default NULL,
  featureStop timestamp default NULL,
  forceSSL smallint NOT NULL default 0,
  audience clob,
  keyPoints clob,
  searchExclude smallint default NULL,
  path clob,
  tags clob,
   PRIMARY KEY  (TContent_ID)
) ;

 create index IX_TContent on tcontent (ContentID);
 create index IX_TContent_1 on tcontent (ContentHistID);
 create index IX_TContent_2 on tcontent (SiteID);
 create index IX_TContent_3 on tcontent (ParentID);
 create index IX_TContent_4 on tcontent (RemoteID);
 create index IX_TContent_5 on tcontent (ModuleID);



INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
 ('default','00000000000000000000000000000000003','00000000000000000000000000000000END','00000000000000000000000000000000003','6300ED4A-1320-5CC3-F9D6A2D279E386D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Components',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
 ('default','00000000000000000000000000000000004','00000000000000000000000000000000END','00000000000000000000000000000000004','6300ED59-1320-5CC3-F9706221E0EFF7A2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Forms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
 ('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000001','6300ED69-1320-5CC3-F922E3012E2C6BAE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default.cfm','Page','Default',1,1,'Home','Home',NULL,NULL,NULL,NULL,NULL,null,'System',NULL,NULL,NULL,1,1,1,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'Cascade',0,NULL,0,10,'orderno','asc',NULL,NULL,0,NULL,NULL,0,'00000000000000000000000000000000001');

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000006','00000000000000000000000000000000END','00000000000000000000000000000000006','6300ED79-1320-5CC3-F92E6325C26664B6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Advertising',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000000','6300ED88-1320-5CC3-F9E241684D21FEC9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000008','00000000000000000000000000000000END','00000000000000000000000000000000008','6300ED98-1320-5CC3-F9398EB23A57CBD0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Members',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000005','00000000000000000000000000000000END','00000000000000000000000000000000005','6300EDA8-1320-5CC3-F93DF074187C935E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Email Broadcaster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000009','00000000000000000000000000000000END','00000000000000000000000000000000009','6300EDB7-1320-5CC3-F9D664F38EBBD2D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Mailing Lists',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000010','00000000000000000000000000000000END','00000000000000000000000000000000010','6300EDC7-1320-5CC3-F9DB8034C9626B70',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Categories',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000011','00000000000000000000000000000000END','00000000000000000000000000000000011','6300EDD6-1320-5CC3-F9625545444B880F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Content Collections',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);
 
INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
('default','00000000000000000000000000000000012','00000000000000000000000000000000END','00000000000000000000000000000000012','6300EDE6-1320-5CC3-F94E2FCEF5DE046D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Filemanager Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);


CREATE TABLE tcontentstats (
  contentID char(35) NOT NULL default '',
  siteID varchar(25) NOT NULL default '',
  views int NOT NULL default 0,
  rating float NOT NULL default 0,
  totalVotes int NOT NULL default 0,
  upVotes int NOT NULL default 0,
  downVotes int NOT NULL default 0,
  comments int NOT NULL default 0,
  PRIMARY KEY  (contentID,siteID)
) ;


CREATE TABLE tcontentassignments (
  contentID char(35) NOT NULL default '',
  contentHistID char(35) NOT NULL default '',
  siteID varchar(25) NOT NULL default '',
  userID char(35) NOT NULL default '',
  PRIMARY KEY  (contentID,contentHistID,siteID,userID)
) ;


CREATE TABLE tcontentcategories (
  categoryID char(35) NOT NULL default '',
  siteID varchar(25) default NULL,
  parentID char(35) default NULL,
  dateCreated timestamp default NULL,
  lastUpdate timestamp default ('now'),
  lastUpdateBy varchar(50) default NULL,
  name varchar(50) default NULL,
  notes clob,
  isInterestGroup int default NULL,
  isActive int default NULL,
  isOpen int default NULL,
  sortBy varchar(50) default NULL,
  sortDirection varchar(50) default NULL,
  restrictGroups varchar(255) default NULL,
  path clob,
  PRIMARY KEY  (categoryID) 
) ;

create index IX_TContentCategories_siteid on tcontentcategories (siteID);

CREATE TABLE tcontentcategoryassign (
  contentHistID char(35) NOT NULL default '',
  categoryID char(35) NOT NULL default '',
  contentID char(35) default NULL,
  isFeature int default NULL,
  orderno int default NULL,
  siteID varchar(50) default NULL,
  featureStart timestamp default NULL,
  featureStop timestamp default NULL,
  PRIMARY KEY  (contentHistID,categoryID)
) ;


CREATE TABLE tcontentcomments (
  commentid char(35) NOT NULL default '',
  contentid char(35) default NULL,
  contenthistid char(35) default NULL,
  url varchar(50) default NULL,
  name varchar(50) default NULL,
  comments clob,
  entered timestamp default NULL,
  email varchar(100) default NULL,
  siteid varchar(25) default NULL,
  ip varchar(50) default NULL,
  isApproved smallint default 0,
  PRIMARY KEY  (commentid)
) ;

create index IX_TContentComments_contentID on tcontentcomments (contentid);


CREATE TABLE tcontentdisplaytitleapprovals (
  contentid char(35) NOT NULL default '',
  isApproved smallint default NULL,
  email varchar(150) default NULL,
  siteid varchar(25) default NULL
) ;


CREATE TABLE tcontenteventreminders (
  contentId char(35) NOT NULL default '',
  siteId varchar(35) NOT NULL default '',
  email varchar(200) NOT NULL default '',
  RemindDate timestamp default NULL,
  RemindHour int default NULL,
  RemindMinute int default NULL,
  RemindInterval int default NULL,
  isSent int default NULL
) ;


CREATE TABLE tcontentfeedadvancedparams (
  paramID char(35) NOT NULL default '',
  feedID char(35) NOT NULL default '',
  param decimal(18,0) default NULL,
  relationship varchar(50) default NULL,
  field varchar(100) default NULL,
  condition varchar(50) default NULL,
  criteria varchar(200) default NULL,
  dataType varchar(50) default NULL,
  PRIMARY KEY  (paramID)
) ;


CREATE TABLE tcontentfeeditems (
  feedID char(35) NOT NULL default '',
  itemID char(35) NOT NULL default '',
  type varchar(50) default NULL
) ;


CREATE TABLE tcontentfeeds (
  feedID char(35) NOT NULL default '',
  siteID varchar(35) default NULL,
  parentID char(35) default NULL,
  name varchar(250) default NULL,
  isActive smallint default NULL,
  isPublic smallint default NULL,
  isDefault smallint default NULL,
  isFeaturesOnly smallint default NULL,
  description clob,
  maxItems int default NULL,
  allowHTML smallint default NULL,
  lang varchar(50) default NULL,
  lastUpdateBy varchar(100) default NULL,
  lastUpdate timestamp default ('now'),
  dateCreated timestamp default NULL,
  restricted smallint default NULL,
  restrictGroups clob,
  version varchar(50) default NULL,
  channelLink varchar(250) default NULL,
  Type varchar(50) default NULL,
  sortBy varchar(50) default NULL,
  sortDirection varchar(50) default NULL,
  nextN int default NULL,
  displayName smallint default NULL,
  displayRatings smallint default NULL,
  displayComments smallint default NULL,
  PRIMARY KEY  (feedID)
) ;

create index IX_TContentFeeds on tcontentfeeds (siteID);

CREATE TABLE tcontentobjects (
  ContentHistID char(35) NOT NULL default '',
  ObjectID varchar(100) NOT NULL default '',
  Object varchar(50) NOT NULL default '',
  ContentID char(35) default NULL,
  Name varchar(255) default NULL,
  OrderNo int default NULL,
  SiteID varchar(25) default NULL,
  ColumnID int default NULL,
  PRIMARY KEY  (ContentHistID,ObjectID,Object,ColumnID )
) ;

create index  IX_TContentObjects on tcontentobjects (SiteID);


CREATE TABLE tcontentratings (
  contentID char(35) NOT NULL default '',
  userID char(35) NOT NULL default '',
  siteID varchar(35) NOT NULL default '',
  rate int default NULL,
  entered timestamp NULL  default ('now'),
  PRIMARY KEY  (contentID,userID,siteID)
) ;

create index IDX_tcontentratings_entered on  tcontentratings (entered);


CREATE TABLE tcontentrelated (
  contentHistID char(35) NOT NULL default '',
  relatedID char(35) NOT NULL default '',
  contentID char(35) NOT NULL default '',
  siteID varchar(25) NOT NULL default '',
  PRIMARY KEY  (contentHistID,relatedID,contentID,siteID)
) ;


CREATE TABLE temailreturnstats (
  emailID char(35) default NULL,
  email varchar(100) default NULL,
  url clob,
  created timestamp default NULL
) ;


CREATE TABLE temails (
  EmailID char(35) NOT NULL default '',
  siteid varchar(25) default NULL,
  Subject varchar(255) default NULL,
  BodyText clob,
  BodyHtml clob,
  CreatedDate timestamp default ('now'),
  DeliveryDate timestamp default NULL,
  status smallint default NULL,
  GroupList clob,
  LastUpdateBy varchar(50) default NULL,
  LastUpdateByID varchar(35) default NULL,
  NumberSent int NOT NULL default 0,
  ReplyTo varchar(50) default NULL,
  format varchar(50) default NULL,
  fromLabel varchar(50) default NULL,
  isDeleted smallint NOT NULL default 0,
  PRIMARY KEY  (EmailID)
) ;

create index IX_TEmails on temails (siteid);


CREATE TABLE temailstats (
  EmailID char(35) default NULL,
  Email char(100) default NULL,
  emailOpen int NOT NULL default 0,
  returnClick int NOT NULL default 0,
  bounce int NOT NULL default 0,
  sent int NOT NULL default 0,
  Created timestamp default NULL
) ;


CREATE TABLE tfiles (
  fileID char(35) NOT NULL default '',
  contentID char(35) default NULL,
  siteID varchar(25) default NULL,
  moduleID char(35) default NULL,
  filename varchar(200) default NULL,
  image blob,
  imageSmall blob,
  imageMedium blob,
  fileSize int default NULL,
  contentType varchar(100) default NULL,
  contentSubType varchar(200) default NULL,
  fileExt varchar(50) default NULL,
  created timestamp default NULL,
  PRIMARY KEY  (fileID)
) ;


CREATE TABLE tformresponsepackets (
  ResponseID char(35) NOT NULL default '',
  FormID char(35) default NULL,
  SiteID varchar(25) default NULL,
  FieldList clob,
  Data clob,
  Entered timestamp default NULL,
  PRIMARY KEY  (ResponseID)
) ;

create index IX_TFormResponsePackets on tformresponsepackets (FormID,SiteID);


CREATE TABLE tformresponsequestions (
  responseID char(35) default NULL,
  formID char(35) default NULL,
  formField varchar(50) default NULL,
  formValue clob,
  pollValue varchar(255) default NULL
) ;


CREATE TABLE tglobals (
  appreload timestamp default NULL,
  loadlist clob
) ;


CREATE TABLE tmailinglist (
  MLID char(35) default NULL,
  SiteID varchar(25) default NULL,
  Name varchar(50) default NULL,
  Description clob,
  LastUpdate timestamp default ('now'),
  isPurge int default NULL,
  isPublic int default NULL
) ;


INSERT INTO tmailinglist (MLID,SiteID,Name,Description,LastUpdate,isPurge,isPublic) VALUES 
 ('#createUUID()#','default','Please Remove Me from All Lists','',null,1,1);



CREATE TABLE tmailinglistmembers (
  MLID char(35) default NULL,
  Email varchar(100) default NULL,
  SiteID varchar(25) default NULL,
  fname varchar(50) default NULL,
  lname varchar(50) default NULL,
  company varchar(50) default NULL,
  isVerified smallint NOT NULL default 0
) ;


CREATE TABLE tpermissions (
  ContentID char(35) default NULL,
  GroupID char(35) default NULL,
  SiteID varchar(25) default NULL,
  Type varchar(50) default NULL
) ;


CREATE TABLE tredirects (
  redirectID char(35) NOT NULL default '',
  URL clob,
  created timestamp default NULL,
  PRIMARY KEY  (redirectID)
) ;


CREATE TABLE tsessiontracking (
  trackingID integer generated always as identity (trackingID_seq),
  contentID char(35) default NULL,
  siteID varchar(25) default NULL,
  userid char(35) default NULL,
  remote_addr varchar(50) default NULL,
  server_name varchar(50) default NULL,
  query_string clob,
  referer varchar(255) default NULL,
  user_agent varchar(200) default NULL,
  script_name varchar(200) default NULL,
  urlToken varchar(130) NOT NULL default '',
  entered timestamp NOT NULL default '0000-00-00 00:00:00',
  country varchar(50) default NULL,
  lang varchar(50) default NULL,
  locale varchar(50) default NULL,
  keywords varchar(200) default NULL,
  originalUrlToken varchar(130) default NULL,
  PRIMARY KEY  (trackingID)
) ;

create index IDX_ENTERED on tsessiontracking (entered);
create index IX_TSessionTracking on tsessiontracking (siteID);
create index IX_TSessionTracking_1 on tsessiontracking (contentID);
create index IX_TSessionTracking_2 on tsessiontracking (urlToken);
create index IX_TSessionTracking_3 on tsessiontracking (userID);


CREATE TABLE tsettings (
  SiteID varchar(25) default NULL,
  Site varchar(50) default NULL,
  MaxNestLevel int default NULL,
  PageLimit int default NULL,
  Locking varchar(50) default NULL,
  Domain varchar(100) default NULL,
  exportLocation varchar(100) default NULL,
  FileDir varchar(50) default NULL,
  Contact varchar(50) default NULL,
  MailserverIP varchar(50) default NULL,
  MailServerUsername varchar(50) default NULL,
  MailServerPassword varchar(50) default NULL,
  EmailBroadcaster int default NULL,
  Extranet int default NULL,
  ExtranetPublicReg int default NULL,
  ExtranetPublicRegNotify varchar(50) default NULL,
  ExtranetSSL int default NULL,
  Cache int default NULL,
  ViewDepth int default NULL,
  NextN int default NULL,
  DataCollection int default NULL,
  columnCount int default NULL,
  columnNames varchar(255) default NULL,
  primaryColumn int default NULL,
  publicSubmission int default NULL,
  AdManager int default NULL,
  archiveDate timestamp default NULL,
  contactName varchar(50) default NULL,
  contactAddress varchar(50) default NULL,
  contactCity varchar(50) default NULL,
  contactState varchar(50) default NULL,
  contactZip varchar(50) default NULL,
  contactEmail varchar(100) default NULL,
  contactPhone varchar(50) default NULL,
  privateUserPoolID varchar(50) default NULL,
  publicUserPoolID varchar(50) default NULL,
  advertiserUserPoolID varchar(50) default NULL,
  orderNo int default NULL,
  emailBroadcasterLimit int NOT NULL default 0,
  feedManager int default NULL,
  displayPoolID varchar(50) default NULL,
  galleryMainScaleBy varchar(50) default NULL,
  galleryMainScale int default NULL,
  gallerySmallScaleBy varchar(50) default NULL,
  gallerySmallScale int default NULL,
  galleryMediumScaleBy varchar(50) default NULL,
  galleryMediumScale int default NULL,
  sendLoginScript clob,
  mailingListConfirmScript clob,
  publicSubmissionApprovalScript clob,
  reminderScript clob,
  loginURL varchar(255) default NULL,
  editProfileURL varchar(255) default NULL,
  CommentApprovalDefault smallint default NULL,
  deploy smallint default NULL,
  lastDeployment timestamp default NULL,
  accountActivationScript clob,
  googleAPIKey varchar(100) default NULL,
  useDefaultSMTPServer smallint default NULL,
  theme varchar(50) default NULL,
  mailserverSMTPPort varchar(5) default NULL,
  mailserverPOPPort varchar(5) default NULL,
  mailserverTLS varchar(5) default NULL, 
  mailserverSSL varchar(5) default NULL
) ;


INSERT INTO tsettings (SiteID,Site,MaxNestLevel,PageLimit,Locking,Domain,exportLocation,FileDir,Contact,MailserverIP,MailServerUsername,MailServerPassword,EmailBroadcaster,Extranet,ExtranetPublicReg,ExtranetPublicRegNotify,ExtranetSSL,Cache,ViewDepth,NextN,DataCollection,columnCount,columnNames,primaryColumn,publicSubmission,AdManager,archiveDate,contactName,contactAddress,contactCity,contactState,contactZip,contactEmail,contactPhone,privateUserPoolID,publicUserPoolID,advertiserUserPoolID,orderNo,emailBroadcasterLimit,feedManager,displayPoolID,galleryMainScaleBy,galleryMainScale,gallerySmallScaleBy,gallerySmallScale,galleryMediumScaleBy,galleryMediumScale,sendLoginScript,mailingListConfirmScript,publicSubmissionApprovalScript,reminderScript,loginURL,editProfileURL,CommentApprovalDefault,deploy,lastDeployment,accountActivationScript,useDefaultSMTPServer) VALUES 
 ('default','Default',NULL,1000,'none','localhost',NULL,NULL,'info@getmura.com','mail.server.com','username@server.com','password',1,1,1,NULL,0,0,1,20,1,3,'Left Column^Main Content^Right Column',2,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default','default','default',1,0,1,'default','y',500,'s',100,'y',250,NULL,NULL,NULL,NULL,'?display=login','?display=editProfile',1,0,NULL,NULL,0);


CREATE TABLE tsystemobjects (
  Object varchar(50) default NULL,
  SiteID varchar(25) default NULL,
  Name varchar(50) default NULL,
  OrderNo int default NULL
) ;


INSERT INTO tsystemobjects (Object,SiteID,Name,OrderNo) VALUES 
 ('event_reminder_form','default','Event Reminder Form',12),
 ('forward_email','default','Forward Email',13),
 ('site_map','default','Site Map',2),
 ('peer_nav','default','Peer Navigation',3),
 ('sub_nav','default','Sub Navigation',4),
 ('standard_nav','default','Standard Navigation',5),
 ('portal_nav','default','Portal Navigation',6),
 ('comments','default','Accept Comments',9),
 ('seq_nav','default','Sequential Nav',8),
 ('rater','default','Content Rater',16),
 ('favorites','default','User Favorites',17),
 ('dragable_feeds','default','Dragable Feeds',18),
 ('related_content','default','Related Content',19),
 ('user_tools','default','User Tools',20),
 ('tag_cloud','default','Tag Cloud',21),
 ('goToFirstChild','default','Go To First Child',23);


CREATE TABLE tuseraddresses (
  addressID char(35) NOT NULL default '',
  userID char(35) default NULL,
  siteID varchar(25) default NULL,
  addressName varchar(50) default NULL,
  address1 varchar(50) default NULL,
  address2 varchar(50) default NULL,
  city varchar(50) default NULL,
  state varchar(50) default NULL,
  zip varchar(50) default NULL,
  country varchar(50) default NULL,
  phone varchar(50) default NULL,
  fax varchar(50) default NULL,
  isPrimary smallint default NULL,
  addressNotes clob,
  addressURL varchar(200) default NULL,
  longitude float default NULL,
  latitude float default NULL,
  addressEmail varchar(100) default NULL,
  hours clob,
  PRIMARY KEY  (addressID)
) ;

create index IX_tuseraddresses_2 on tuseraddresses (longitude);
create index IX_tuseraddresses_3 on tuseraddresses (latitude);
create index IX_tuseraddresses_4 on tuseraddresses (userID);


CREATE TABLE tusers (
  UserID char(35) NOT NULL default '',
  GroupName varchar(50) default NULL,
  Fname varchar(50) default NULL,
  Lname varchar(50) default NULL,
  UserName varchar(50) default NULL,
  Password varchar(50) default NULL,
  PasswordCreated timestamp default NULL,
  Email varchar(50) default NULL,
  Company varchar(50) default NULL,
  JobTitle varchar(50) default NULL,
  mobilePhone varchar(50) default NULL,
  Website varchar(255) default NULL,
  Type int default NULL,
  subType varchar(50) default NULL,
  Ext int default NULL,
  ContactForm clob,
  Admin int default NULL,
  S2 int default NULL,
  LastLogin timestamp default ('now'),
  LastUpdate timestamp default ('now'),
  LastUpdateBy varchar(50) default null,
  LastUpdateByID varchar(35) default NULL,
  Perm smallint default NULL,
  InActive smallint default NULL,
  isPublic int default NULL,
  SiteID varchar(50) default NULL,
  Subscribe int default NULL,
  notes clob,
  description clob,
  interests clob,
  keepPrivate smallint default NULL,
  photoFileID varchar(35) default NULL,
  IMName varchar(100) default NULL,
  IMService varchar(50) default NULL,
  created timestamp NULL default ('now'),
  remoteID varchar(35) default NULL,
  tags clob,
  PRIMARY KEY  (userID)
) ;


INSERT INTO tusers (UserID,GroupName,Fname,Lname,UserName,Password,PasswordCreated,Email,Company,JobTitle,mobilePhone,Website,Type,subType,Ext,ContactForm,Admin,S2,LastLogin,LastUpdate,LastUpdateBy,LastUpdateByID,Perm,InActive,isPublic,SiteID,Subscribe,notes,description,interests,keepPrivate,photoFileID,IMName,IMService,created,remoteID,tags) VALUES 
 ('#adminUserID#',NULL,'Admin','User','admin','21232F297A57A5A743894A0E4A801FC3','now','admin@localhost.com',NULL,NULL,NULL,NULL,2,'Default',NULL,NULL,NULL,1,'now','now','System','22FC551F-FABE-EA01-C6EDD0885DDC1682',0,0,0,'default',0,NULL,NULL,NULL,0,NULL,NULL,NULL,'now',NULL,NULL),
 ('#createUUID()#','Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Default',NULL,NULL,NULL,0,NULL,'now','System',NULL,1,0,0,'default',0,NULL,NULL,NULL,0,NULL,NULL,NULL,'now',NULL,NULL);


CREATE TABLE tusersfavorites (
  favoriteID char(35) NOT NULL default '',
  userID char(35) NOT NULL default '',
  favoriteName varchar(100) default NULL,
  favorite clob,
  type varchar(30) NOT NULL default '',
  siteID varchar(35) default NULL,
  dateCreated timestamp NOT NULL default ('now'),
  columnNumber int default NULL,
  rowNumber int default NULL,
  maxRSSItems int default NULL,
  PRIMARY KEY  (favoriteID)
) ;


CREATE TABLE tusersinterests (
  userID char(35)  NOT NULL default '',
  categoryID char(35) NOT NULL default '',
  PRIMARY KEY (userID,categoryID)
) ;


CREATE TABLE tusersmemb (
  UserID char(35) NOT NULL default '',
  GroupID char(35) NOT NULL default '',
  PRIMARY KEY  (UserID,GroupID)
) ;


CREATE TABLE  tcontentpublicsubmissionapprovals (
  contentID char(35) NOT NULL default '',
  isApproved int NOT NULL,
  email varchar(150) NOT NULL,
  siteID varchar(25) NOT NULL,
  PRIMARY KEY (contentID,siteID)
) ;


CREATE TABLE tcontenttags (
  tagID integer generated always as identity (tagID_content_seq),
  contentID CHAR(35) NOT NULL,
  contentHistID CHAR(35) NOT NULL,
  siteID VARCHAR(25) NOT NULL,
  tag VARCHAR(100) NOT NULL,
  PRIMARY KEY (tagID)
);

create index IX_tcontenttags_2 on tcontenttags (contentHistID);
create index IX_tcontenttags_3 on tcontenttags (siteID);
create index IX_tcontenttags_4 on tcontenttags (contentID);
create index IX_tcontenttags_5 on tcontenttags (tag);

CREATE TABLE tuserstags (
  tagID integer generated always as identity (tagID_user_seq),
  userID CHAR(35) NOT NULL,
  siteID VARCHAR(25) NOT NULL,
  tag VARCHAR(100) NOT NULL,
  PRIMARY KEY (tagID)
);

create index tuserstags_2 on tuserstags (userID);
create index tuserstags_3 on tuserstags (siteID);
create index tuserstags_4 on tuserstags (tag);

CREATE TABLE tclassextenddatauseractivity  (
	dataID integer generated always as identity (tclassextenddatauseractivity_seq),
	baseID char (35)  NOT NULL ,
	attributeID INT NOT NULL ,
	siteID varchar (25)  NULL ,
	attributeValue clob,
	PRIMARY KEY (dataID)
) ;

create index tclassextenddatauseractivity_2 on tclassextenddatauseractivity (baseID);
create index tclassextenddatauseractivity_3 on tclassextenddatauseractivity (attributeID);


CREATE TABLE tclassextenddata  (
	dataID integer generated always as identity (tclassextenddata_seq),
	baseID char (35)  NOT NULL ,
	attributeID INTEGER NOT NULL ,
	siteID varchar (25)  NULL ,
	attributeValue clob,
	PRIMARY KEY (dataID)
);

create index IX_tclassextenddata_2 on tclassextenddata (baseID);
create index IX_tclassextenddata_3 on tclassextenddata (attributeID);


CREATE TABLE tclassextend (
	subTypeID char (35)  NOT NULL ,
	siteID varchar (25)  NULL ,
	baseTable varchar (50) NULL ,
	baseKeyField varchar (50) NULL ,
	dataTable varchar (50) NULL ,
	type varchar (50) NULL ,
	subType varchar (50) NULL ,
	isActive smallint NULL ,
	notes clob ,
	lastUpdate timestamp NULL ,
	dateCreated timestamp NULL ,
	lastUpdateBy varchar (100)  NULL ,
	PRIMARY KEY (subTypeID)
) ;


CREATE TABLE tclassextendattributes (
	attributeID integer generated always as identity (tclassextendattributes_seq),	
	extendSetID char (35)  NULL ,
	siteID varchar (25) NULL ,
	name varchar (100) NULL ,
	label clob  NULL ,
	hint clob  NULL ,
	type varchar (100) NULL ,
	orderno int NULL ,
	isActive smallint NULL ,
	required varchar(50) NULL ,
	validation varchar (50) NULL ,
	regex clob  NULL ,
	message clob  NULL ,
	defaultValue varchar (100) NULL ,
	optionList clob ,
	optionLabelList clob,
	PRIMARY KEY (attributeID)
) ;

create index IX_tclassextendattributes_2 on tclassextendattributes (extendSetID);

CREATE TABLE tclassextendsets (
	extendSetID char(35) NOT NULL ,
	subTypeID char(35) NULL ,
	categoryID clob ,
	siteID varchar (25) NULL ,
	name varchar(50)  NULL ,
	orderno int NULL ,
	isActive smallint NULL,
	PRIMARY KEY (extendSetID)
) ;

create index IX_tclassextendsets_2 on tclassextendsets (subTypeID)

</cfoutput>
