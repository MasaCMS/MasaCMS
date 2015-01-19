CREATE TABLE tcontent (
  TContent_ID INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  SiteID varchar(25)  default NULL,
  ModuleID char(35)  default NULL,
  ParentID char(35)  default NULL,
  ContentID char(35)  default NULL,
  ContentHistID char(35)  default NULL,
  RemoteID varchar(255)  default NULL,
  RemoteURL varchar(255)  default NULL,
  RemotePubDate varchar(50)  default NULL,
  RemoteSourceURL varchar(255)  default NULL,
  RemoteSource varchar(255)  default NULL,
  Credits varchar(255)  default NULL,
  FileID char(35)  default NULL,
  Template varchar(50)  default NULL,
  Type varchar(25)  default NULL,
  subType varchar(25)  default NULL,
  Active tinyint(3) default '0',
  OrderNo int(10) default NULL,
  Title varchar(255)  default NULL,
  MenuTitle varchar(255)  default NULL,
  Summary longtext,
  Filename varchar(255)  default NULL,
  MetaDesc longtext,
  MetaKeyWords longtext,
  Body longtext,
  lastUpdate datetime default NULL,
  lastUpdateBy varchar(50)  default NULL,
  lastUpdateByID varchar(50)  default NULL,
  DisplayStart datetime default NULL,
  DisplayStop datetime default NULL,
  Display tinyint(3) default NULL,
  Approved tinyint(3) default NULL,
  IsNav tinyint(3) default NULL,
  Restricted tinyint(3) default NULL,
  RestrictGroups varchar(255)  default NULL,
  Target varchar(50)  default NULL,
  TargetParams varchar(255)  default NULL,
  responseChart tinyint(3) default NULL,
  responseMessage longtext,
  responseSendTo longtext,
  responseDisplayFields longtext,
  moduleAssign varchar(255)  default NULL,
  displayTitle tinyint(3) default NULL,
  Notes longtext,
  inheritObjects varchar(25)  default NULL,
  isFeature tinyint(3) default NULL,
  ReleaseDate datetime default NULL,
  IsLocked tinyint(3) default NULL,
  nextN int(10) default NULL,
  sortBy varchar(50)  default NULL,
  sortDirection varchar(50)  default NULL,
  featureStart datetime default NULL,
  featureStop datetime default NULL,
  forceSSL tinyint(3) NOT NULL default '0',
  audience longtext,
  keyPoints longtext,
  searchExclude tinyint(3) default NULL,
  path longtext,
  tags longtext,
   PRIMARY KEY  (TContent_ID),
   KEY IX_TContent (ContentID),
   KEY IX_TContent_1 (ContentHistID),
   KEY IX_TContent_2 (SiteID),
   KEY IX_TContent_3 (ParentID),
   KEY IX_TContent_4 (RemoteID),
   KEY IX_TContent_5 (ModuleID)
) ;

INSERT INTO tcontent (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path) VALUES 
 ('default','00000000000000000000000000000000003','00000000000000000000000000000000END','00000000000000000000000000000000003','6300ED4A-1320-5CC3-F9D6A2D279E386D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Components',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
 ('default','00000000000000000000000000000000004','00000000000000000000000000000000END','00000000000000000000000000000000004','6300ED59-1320-5CC3-F9706221E0EFF7A2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Forms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000001','6300ED69-1320-5CC3-F922E3012E2C6BAE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default.cfm','Page','Default',1,1,'Home','Home',NULL,NULL,NULL,NULL,NULL,now(),'System',NULL,NULL,NULL,1,1,1,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'Cascade',0,NULL,0,10,'orderno','asc',NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000006','00000000000000000000000000000000END','00000000000000000000000000000000006','6300ED79-1320-5CC3-F92E6325C26664B6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Advertising',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000000','6300ED88-1320-5CC3-F9E241684D21FEC9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000008','00000000000000000000000000000000END','00000000000000000000000000000000008','6300ED98-1320-5CC3-F9398EB23A57CBD0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Members',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000005','00000000000000000000000000000000END','00000000000000000000000000000000005','6300EDA8-1320-5CC3-F93DF074187C935E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Email Broadcaster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000009','00000000000000000000000000000000END','00000000000000000000000000000000009','6300EDB7-1320-5CC3-F9D664F38EBBD2D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Mailing Lists',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000010','00000000000000000000000000000000END','00000000000000000000000000000000010','6300EDC7-1320-5CC3-F9DB8034C9626B70',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Categories',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000011','00000000000000000000000000000000END','00000000000000000000000000000000011','6300EDD6-1320-5CC3-F9625545444B880F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Content Collections',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL),
 ('default','00000000000000000000000000000000012','00000000000000000000000000000000END','00000000000000000000000000000000012','6300EDE6-1320-5CC3-F94E2FCEF5DE046D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Filemanager Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL);

CREATE TABLE tcontentstats (
  contentID char(35) NOT NULL default '',
  siteID varchar(25) NOT NULL default '',
  views int(10) unsigned NOT NULL default '0',
  rating float NOT NULL default '0',
  totalVotes int(10) unsigned NOT NULL default '0',
  upVotes int(10) unsigned NOT NULL default '0',
  downVotes int(10) unsigned NOT NULL default '0',
  comments int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (contentID,siteID)
) ;

CREATE TABLE tcontentassignments (
  contentID char(35) NOT NULL default '',
  contentHistID char(35) NOT NULL default '',
  siteID varchar(25)  NOT NULL default '',
  userID char(35) NOT NULL default '',
  PRIMARY KEY  (contentID,contentHistID,siteID,userID)
) ;

CREATE TABLE tcontentcategories (
  categoryID char(35)  NOT NULL default '',
  siteID varchar(25)  default NULL,
  parentID char(35)  default NULL,
  dateCreated datetime default NULL,
  lastUpdate datetime default NULL,
  lastUpdateBy varchar(50)  default NULL,
  name varchar(50)  default NULL,
  notes longtext,
  isInterestGroup int(10) default NULL,
  isActive int(10) default NULL,
  isOpen int(10) default NULL,
  sortBy varchar(50) default NULL,
  sortDirection varchar(50) default NULL,
  restrictGroups varchar(255)  default NULL,
  path longtext,
  PRIMARY KEY  (categoryID),
  KEY IX_TContentCategories (siteID)
) ;

CREATE TABLE tcontentcategoryassign (
  contentHistID char(35)  NOT NULL default '',
  categoryID char(35)  NOT NULL default '',
  contentID char(35)  default NULL,
  isFeature int(10) default NULL,
  orderno int(10) default NULL,
  siteID varchar(50)  default NULL,
  featureStart datetime default NULL,
  featureStop datetime default NULL,
  PRIMARY KEY  (contentHistID,categoryID)
) ;

CREATE TABLE tcontentcomments (
  commentid char(35)  NOT NULL default '',
  contentid char(35)  default NULL,
  contenthistid char(35)  default NULL,
  url varchar(50)  default NULL,
  name varchar(50)  default NULL,
  comments longtext,
  entered datetime default NULL,
  email varchar(100)  default NULL,
  siteid varchar(25)  default NULL,
  ip varchar(50)  default NULL,
  isApproved tinyint(3) default '0',
  PRIMARY KEY  (commentid),
  KEY IX_TContentComments (contentid)
) ;

CREATE TABLE tcontentdisplaytitleapprovals (
  contentid char(35)  NOT NULL default '',
  isApproved tinyint(3) default NULL,
  email varchar(150)  default NULL,
  siteid varchar(25)  default NULL
) ;

CREATE TABLE tcontenteventreminders (
  contentId char(35)  NOT NULL default '',
  siteId varchar(35)  NOT NULL default '',
  email varchar(200)  NOT NULL default '',
  RemindDate datetime default NULL,
  RemindHour int(10) default NULL,
  RemindMinute int(10) default NULL,
  RemindInterval int(10) default NULL,
  isSent int(10) default NULL
) ;

CREATE TABLE tcontentfeedadvancedparams (
  paramID char(35) NOT NULL default '',
  feedID char(35) NOT NULL default '',
  param decimal(18,0) default NULL,
  relationship varchar(50)  default NULL,
  field varchar(100)  default NULL,
  condition varchar(50)  default NULL,
  criteria varchar(200)  default NULL,
  dataType varchar(50)  default NULL,
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
  isActive tinyint(3) default NULL,
  isPublic tinyint(3) default NULL,
  isDefault tinyint(3) default NULL,
  isFeaturesOnly tinyint(3) default NULL,
  description longtext,
  maxItems int(10) default NULL,
  allowHTML tinyint(3) default NULL,
  lang varchar(50) default NULL,
  lastUpdateBy varchar(100) default NULL,
  lastUpdate datetime default NULL,
  dateCreated datetime default NULL,
  restricted tinyint(3) default NULL,
  restrictGroups longtext,
  version varchar(50) default NULL,
  channelLink varchar(250) default NULL,
  Type varchar(50) default NULL,
  sortBy varchar(50) default NULL,
  sortDirection varchar(50) default NULL,
  nextN int(10) default NULL,
  displayName tinyint(3) default NULL,
  displayRatings tinyint(3) default NULL,
  displayComments tinyint(3) default NULL,
  PRIMARY KEY  (feedID),
  KEY IX_TContentFeeds (siteID)
) ;

CREATE TABLE tcontentobjects (
  ContentHistID char(35) NOT NULL default '',
  ObjectID varchar(100) NOT NULL default '',
  Object varchar(50) NOT NULL default '',
  ContentID char(35) default NULL,
  Name varchar(255) default NULL,
  OrderNo int(10) default NULL,
  SiteID varchar(25) default NULL,
  ColumnID int(10) default NULL,
  PRIMARY KEY  (ContentHistID,ObjectID,Object,ColumnID ),
  KEY IX_TContentObjects (SiteID)
) ;

CREATE TABLE tcontentratings (
  contentID char(35) NOT NULL default '',
  userID char(35)  NOT NULL default '',
  siteID varchar(35)  NOT NULL default '',
  rate int(10) default NULL,
  entered timestamp NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (contentID,userID,siteID),
  KEY IDX_ENTERED1 (entered)
) ;

CREATE TABLE tcontentrelated (
  contentHistID char(35) NOT NULL default '',
  relatedID char(35) NOT NULL default '',
  contentID char(35) NOT NULL default '',
  siteID varchar(25) NOT NULL default '',
  PRIMARY KEY  (contentHistID,relatedID,contentID,siteID)
) ;

CREATE TABLE temailreturnstats (
  emailID char(35)  default NULL,
  email varchar(100)  default NULL,
  url mediumtext,
  created datetime default NULL
) ;

CREATE TABLE temails (
  EmailID char(35)  NOT NULL default '',
  siteid varchar(25)  default NULL,
  Subject varchar(255)  default NULL,
  BodyText longtext,
  BodyHtml longtext,
  CreatedDate datetime default NULL,
  DeliveryDate datetime default NULL,
  status tinyint(3) default NULL,
  GroupList longtext,
  LastUpdateBy varchar(50)  default NULL,
  LastUpdateByID varchar(35)  default NULL,
  NumberSent int(10) NOT NULL default '0',
  ReplyTo varchar(50)  default NULL,
  format varchar(50)  default NULL,
  fromLabel varchar(50)  default NULL,
  isDeleted tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (EmailID),
  KEY IX_TEmails (siteid)
) ;

CREATE TABLE temailstats (
  EmailID char(35)  default NULL,
  Email char(100)  default NULL,
  emailOpen int(10) NOT NULL default '0',
  returnClick int(10) NOT NULL default '0',
  bounce int(10) NOT NULL default '0',
  sent int(10) NOT NULL default '0',
  Created datetime default NULL
) ;

CREATE TABLE tfiles (
  fileID char(35)  NOT NULL default '',
  contentID char(35)  default NULL,
  siteID varchar(25)  default NULL,
  moduleID char(35)  default NULL,
  filename varchar(200)  default NULL,
  image longblob,
  imageSmall longblob,
  imageMedium longblob,
  fileSize int(10) default NULL,
  contentType varchar(100)  default NULL,
  contentSubType varchar(200)  default NULL,
  fileExt varchar(50)  default NULL,
  created datetime default NULL,
  PRIMARY KEY  (fileID)
) ;

CREATE TABLE tformresponsepackets (
  ResponseID char(35)  NOT NULL default '',
  FormID char(35)  default NULL,
  SiteID varchar(25)  default NULL,
  FieldList longtext,
  Data longtext,
  Entered datetime default NULL,
  PRIMARY KEY  (ResponseID),
  KEY IX_TFormResponsePackets (FormID,SiteID)
) ;

CREATE TABLE tformresponsequestions (
  responseID char(35)  default NULL,
  formID char(35)  default NULL,
  formField varchar(50)  default NULL,
  formValue longtext,
  pollValue varchar(255)  default NULL
) ;

CREATE TABLE tglobals (
  appreload datetime default NULL,
  loadlist mediumtext
) ;

CREATE TABLE tmailinglist (
  MLID char(35)  default NULL,
  SiteID varchar(25)  default NULL,
  Name varchar(50)  default NULL,
  Description longtext,
  LastUpdate datetime default NULL,
  isPurge int(10) default NULL,
  isPublic int(10) default NULL
) ;

<cfoutput>
INSERT INTO tmailinglist (MLID,SiteID,Name,Description,LastUpdate,isPurge,isPublic) VALUES 
 ('#createUUID()#','default','Please Remove Me from All Lists','',now(),1,1);
</cfoutput>

CREATE TABLE tmailinglistmembers (
  MLID char(35)  default NULL,
  Email varchar(100)  default NULL,
  SiteID varchar(25)  default NULL,
  fname varchar(50)  default NULL,
  lname varchar(50)  default NULL,
  company varchar(50)  default NULL,
  isVerified tinyint(1) NOT NULL default '0'
) ;

CREATE TABLE tpermissions (
  ContentID char(35)  default NULL,
  GroupID char(35)  default NULL,
  SiteID varchar(25)  default NULL,
  Type varchar(50)  default NULL
) ;

CREATE TABLE tredirects (
  redirectID char(35) NOT NULL default '',
  URL mediumtext,
  created datetime default NULL,
  PRIMARY KEY  (redirectID)
) ;

CREATE TABLE tsessiontracking (
  trackingID INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  contentID char(35)  default NULL,
  siteID varchar(25)  default NULL,
  userid char(35)  default NULL,
  remote_addr varchar(50)  default NULL,
  server_name varchar(50)  default NULL,
  query_string mediumtext,
  referer varchar(255)  default NULL,
  user_agent varchar(200)  default NULL,
  script_name varchar(200)  default NULL,
  urlToken varchar(130)  NOT NULL default '',
  entered datetime NOT NULL default '0000-00-00 00:00:00',
  country varchar(50)  default NULL,
  lang varchar(50)  default NULL,
  locale varchar(50)  default NULL,
  keywords varchar(200)  default NULL,
  originalUrlToken varchar(130)  default NULL,
  PRIMARY KEY  (trackingID),
  KEY IDX_ENTERED2 (entered),
  KEY IX_TSessionTracking (siteID),
  KEY IX_TSessionTracking_1 (contentID),
  KEY IX_TSessionTracking_2 (urlToken),
  KEY IX_TSessionTracking_3 (userID)
) ;

CREATE TABLE tsettings (
  SiteID varchar(25)  default NULL,
  Site varchar(50)  default NULL,
  MaxNestLevel int(10) default NULL,
  PageLimit int(10) default NULL,
  Locking varchar(50)  default NULL,
  Domain varchar(100)  default NULL,
  exportLocation varchar(100)  default NULL,
  FileDir varchar(50)  default NULL,
  Contact varchar(50)  default NULL,
  MailserverIP varchar(50)  default NULL,
  MailServerUsername varchar(50)  default NULL,
  MailServerPassword varchar(50)  default NULL,
  EmailBroadcaster int(10) default NULL,
  Extranet int(10) default NULL,
  ExtranetPublicReg int(10) default NULL,
  ExtranetPublicRegNotify varchar(50)  default NULL,
  ExtranetSSL int(10) default NULL,
  Cache int(10) default NULL,
  ViewDepth int(10) default NULL,
  NextN int(10) default NULL,
  DataCollection int(10) default NULL,
  columnCount int(10) default NULL,
  columnNames varchar(255)  default NULL,
  primaryColumn int(10) default NULL,
  publicSubmission int(10) default NULL,
  AdManager int(10) default NULL,
  archiveDate datetime default NULL,
  contactName varchar(50)  default NULL,
  contactAddress varchar(50)  default NULL,
  contactCity varchar(50)  default NULL,
  contactState varchar(50)  default NULL,
  contactZip varchar(50)  default NULL,
  contactEmail varchar(100)  default NULL,
  contactPhone varchar(50)  default NULL,
  privateUserPoolID varchar(50)  default NULL,
  publicUserPoolID varchar(50)  default NULL,
  advertiserUserPoolID varchar(50)  default NULL,
  orderNo int(10) default NULL,
  emailBroadcasterLimit int(10) NOT NULL default '0',
  feedManager int(10) default NULL,
  displayPoolID varchar(50)  default NULL,
  galleryMainScaleBy varchar(50)  default NULL,
  galleryMainScale int(10) default NULL,
  gallerySmallScaleBy varchar(50)  default NULL,
  gallerySmallScale int(10) default NULL,
  galleryMediumScaleBy varchar(50)  default NULL,
  galleryMediumScale int(10) default NULL,
  sendLoginScript longtext,
  mailingListConfirmScript longtext,
  publicSubmissionApprovalScript longtext,
  reminderScript longtext,
  loginURL varchar(255) default NULL,
  editProfileURL varchar(255) default NULL,
  CommentApprovalDefault tinyint(3) default NULL,
  deploy tinyint(3) default NULL,
  lastDeployment datetime default NULL,
  accountActivationScript longtext,
  googleAPIKey varchar(100) default NULL,
  useDefaultSMTPServer tinyint(3) default NULL,
  theme varchar(50) default NULL,
  mailserverSMTPPort varchar(5) default NULL,
  mailserverPOPPort varchar(5) default NULL,
  mailserverTLS varchar(5) default NULL, 
  mailserverSSL varchar(5) default NULL
) ;

INSERT INTO tsettings (SiteID,Site,MaxNestLevel,PageLimit,Locking,Domain,exportLocation,FileDir,Contact,MailserverIP,MailServerUsername,MailServerPassword,EmailBroadcaster,Extranet,ExtranetPublicReg,ExtranetPublicRegNotify,ExtranetSSL,Cache,ViewDepth,NextN,DataCollection,columnCount,columnNames,primaryColumn,publicSubmission,AdManager,archiveDate,contactName,contactAddress,contactCity,contactState,contactZip,contactEmail,contactPhone,privateUserPoolID,publicUserPoolID,advertiserUserPoolID,orderNo,emailBroadcasterLimit,feedManager,displayPoolID,galleryMainScaleBy,galleryMainScale,gallerySmallScaleBy,gallerySmallScale,galleryMediumScaleBy,galleryMediumScale,sendLoginScript,mailingListConfirmScript,publicSubmissionApprovalScript,reminderScript,loginURL,editProfileURL,CommentApprovalDefault,deploy,lastDeployment,accountActivationScript,useDefaultSMTPServer) VALUES 
 ('default','Default',NULL,1000,'none','localhost',NULL,NULL,'info@getmura.com','mail.server.com','username@server.com','password',0,1,0,NULL,0,0,1,20,1,3,'Left Column^Main Content^Right Column',2,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default','default','default',1,0,1,'default','y',500,'s',100,'y',250,NULL,NULL,NULL,NULL,'?display=login','?display=editProfile',1,0,NULL,NULL,0);

CREATE TABLE tsystemobjects (
  Object varchar(50)  default NULL,
  SiteID varchar(25)  default NULL,
  Name varchar(50)  default NULL,
  OrderNo int(10) default NULL
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
 ('related_content','default','Related Content',19),
 ('user_tools','default','User Tools',20),
 ('tag_cloud','default','Tag Cloud',21),
 ('goToFirstChild','default','Go To First Child',23);

CREATE TABLE tuseraddresses (
  addressID char(35) NOT NULL default '',
  userID char(35) default NULL,
  siteID varchar(25)  default NULL,
  addressName varchar(50)  default NULL,
  address1 varchar(50)  default NULL,
  address2 varchar(50)  default NULL,
  city varchar(50)  default NULL,
  state varchar(50)  default NULL,
  zip varchar(50)  default NULL,
  country varchar(50)  default NULL,
  phone varchar(50)  default NULL,
  fax varchar(50)  default NULL,
  isPrimary tinyint(3) default NULL,
  addressNotes longtext,
  addressURL varchar(200)  default NULL,
  longitude float default NULL,
  latitude float default NULL,
  addressEmail varchar(100)  default NULL,
  hours longtext,
  PRIMARY KEY  (addressID),
  INDEX uIndex_2(longitude),
  INDEX uIndex_3(latitude),
  INDEX uIndex_4(userID)
) ;

CREATE TABLE tusers (
  UserID char(35)  NOT NULL default '',
  GroupName varchar(50)  default NULL,
  Fname varchar(50)  default NULL,
  Lname varchar(50)  default NULL,
  UserName varchar(50)  default NULL,
  Password varchar(50)  default NULL,
  PasswordCreated datetime default NULL,
  Email varchar(50)  default NULL,
  Company varchar(50)  default NULL,
  JobTitle varchar(50)  default NULL,
  mobilePhone varchar(50)  default NULL,
  Website varchar(255)  default NULL,
  Type int(10) default NULL,
  subType varchar(50)  default NULL,
  Ext int(10) default NULL,
  ContactForm longtext,
  Admin int(10) default NULL,
  S2 int(10) default NULL,
  LastLogin datetime default NULL,
  LastUpdate datetime default NULL,
  LastUpdateBy varchar(50)  default NULL,
  LastUpdateByID varchar(35)  default NULL,
  Perm tinyint(3) default NULL,
  InActive tinyint(3) default NULL,
  isPublic int(10) default NULL,
  SiteID varchar(50)  default NULL,
  Subscribe int(10) default NULL,
  notes longtext,
  description longtext,
  interests longtext,
  keepPrivate tinyint(3) default NULL,
  photoFileID varchar(35) default NULL,
  IMName varchar(100)  default NULL,
  IMService varchar(50)  default NULL,
  created timestamp NULL default CURRENT_TIMESTAMP,
  remoteID varchar(35) default NULL,
  tags longtext,
   PRIMARY KEY  (userID)
) ;

<cfoutput>
INSERT INTO tusers (UserID,GroupName,Fname,Lname,UserName,Password,PasswordCreated,Email,Company,JobTitle,mobilePhone,Website,Type,subType,Ext,ContactForm,Admin,S2,LastLogin,LastUpdate,LastUpdateBy,LastUpdateByID,Perm,InActive,isPublic,SiteID,Subscribe,notes,description,interests,keepPrivate,photoFileID,IMName,IMService,created,remoteID,tags) VALUES 
 ('#adminUserID#',NULL,'Admin','User','admin','21232F297A57A5A743894A0E4A801FC3',now(),'admin@localhost.com',NULL,NULL,NULL,NULL,2,'Default',NULL,NULL,NULL,1,now(),now(),'System','22FC551F-FABE-EA01-C6EDD0885DDC1682',0,0,0,'default',0,NULL,NULL,NULL,0,NULL,NULL,NULL,now(),NULL,NULL),
 ('#createUUID()#','Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Default',NULL,NULL,NULL,0,NULL,now(),'System',NULL,1,0,0,'default',0,NULL,NULL,NULL,0,NULL,NULL,NULL,now(),NULL,NULL);
</cfoutput>

CREATE TABLE tusersfavorites (
  favoriteID char(35) NOT NULL default '',
  userID char(35) NOT NULL default '',
  favoriteName varchar(255) default NULL,
  favorite mediumtext,
  type varchar(30) NOT NULL default '',
  siteID varchar(35) default NULL,
  dateCreated timestamp NOT NULL default CURRENT_TIMESTAMP,
  columnNumber int(10) default NULL,
  rowNumber int(10) default NULL,
  maxRSSItems int(10) default NULL,
  PRIMARY KEY  (favoriteID)
) ;

CREATE TABLE tusersinterests (
  userID char(35)   NOT NULL default '',
  categoryID char(35)  NOT NULL default '',
  PRIMARY KEY (userID,categoryID)
) ;


CREATE TABLE tusersmemb (
  UserID char(35)  NOT NULL default '',
  GroupID char(35)  NOT NULL default '',
  PRIMARY KEY  (UserID,GroupID)
) ;

CREATE TABLE  tcontentpublicsubmissionapprovals (
  contentID char(35) NOT NULL default '',
  isApproved int(10) unsigned NOT NULL,
  email varchar(150) NOT NULL,
  siteID varchar(25) NOT NULL,
  PRIMARY KEY  (contentID,siteID)
) ;


CREATE TABLE tcontenttags (
  tagID INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  contentID CHAR(35) NOT NULL,
  contentHistID CHAR(35) NOT NULL,
  siteID VARCHAR(25) NOT NULL,
  tag VARCHAR(100) NOT NULL,
  PRIMARY KEY (tagID),
  INDEX cIndex_2(contentHistID),
  INDEX cIndex_3(siteID),
  INDEX cIndex_4(contentID),
  INDEX cIndex_5(tag)
)
;


CREATE TABLE tuserstags (
  tagID INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  userID CHAR(35) NOT NULL,
  siteID VARCHAR(25) NOT NULL,
  tag VARCHAR(100) NOT NULL,
  PRIMARY KEY (tagID),
  INDEX usIndex_2(userID),
  INDEX usIndex_3(siteID),
  INDEX usIndex_4(tag)
)
;


CREATE TABLE tclassextenddatauseractivity  (
	dataID INTEGER NOT NULL AUTO_INCREMENT,	
	baseID char (35)  NOT NULL ,
	attributeID INTEGER NOT NULL ,
	siteID varchar (25)  NULL ,
	attributeValue longtext,
	INDEX tcIndex_2(baseID),
	INDEX tcIndex_3(attributeID),
	PRIMARY KEY (dataID)
) ;


CREATE TABLE tclassextenddata  (
	dataID INTEGER NOT NULL AUTO_INCREMENT,
	baseID char (35)  NOT NULL ,
	attributeID INTEGER NOT NULL ,
	siteID varchar (25)  NULL ,
	attributeValue longtext,
	INDEX clIndex_2(baseID),
	INDEX clIndex_3(attributeID),
	PRIMARY KEY (dataID)
) ;


CREATE TABLE tclassextend (
	subTypeID char (35)  NOT NULL ,
	siteID varchar (25)  NULL ,
	baseTable varchar (50) NULL ,
	baseKeyField varchar (50) NULL ,
	dataTable varchar (50) NULL ,
	type varchar (50) NULL ,
	subType varchar (50) NULL ,
	isActive tinyint(3) NULL ,
	notes longtext ,
	lastUpdate datetime NULL ,
	dateCreated datetime NULL ,
	lastUpdateBy varchar (100)  NULL ,
	PRIMARY KEY (subTypeID)
) ;


CREATE TABLE tclassextendattributes (
	attributeID INTEGER NOT NULL AUTO_INCREMENT,	
	extendSetID char (35)  NULL ,
	siteID varchar (25) NULL ,
	name varchar (100) NULL ,
	label text  NULL ,
	hint text  NULL ,
	type varchar (100) NULL ,
	orderno int NULL ,
	isActive tinyint(3) NULL ,
	required varchar(50) NULL ,
	validation varchar (50) NULL ,
	regex text  NULL ,
	message text  NULL ,
	defaultValue varchar (100) NULL ,
	optionList longtext ,
	optionLabelList longtext,
	INDEX laIndex_2(extendSetID),
	PRIMARY KEY (attributeID)
) ;


CREATE TABLE tclassextendsets (
	extendSetID char(35) NOT NULL ,
	subTypeID char(35) NULL ,
	categoryID longtext ,
	siteID varchar (25) NULL ,
	name varchar(50)  NULL ,
	orderno int NULL ,
	isActive tinyint(3) NULL,
	INDEX lxIndex_2(subTypeID),
	PRIMARY KEY (extendSetID)
) ;
