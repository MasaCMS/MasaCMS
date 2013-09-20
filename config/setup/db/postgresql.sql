CREATE TABLE tadcampaigns (
	campaignID char(35) NOT NULL ,
	userID char(35) NULL ,
	dateCreated timestamp NULL ,
	lastUpdate timestamp NULL ,
	lastUpdateBy varchar(50) NULL ,
	name varchar(50) NULL ,
	startDate timestamp NULL ,
	endDate timestamp NULL ,
	isActive integer NULL ,
	notes text NULL,
  CONSTRAINT PK_tadcampaigns PRIMARY KEY (campaignID)
);

CREATE TABLE tadcreatives (
	creativeID char(35) NOT NULL ,
	userID char(35) NULL ,
	dateCreated timestamp NULL ,
	lastUpdate timestamp NULL ,
	lastUpdateBy varchar(50) NULL ,
	name varchar(50) NULL ,
	creativeType varchar(50) NULL ,
	fileID varchar(35) NULL ,
	mediaType varchar(50) NULL ,
	redirectURL varchar(200) NULL ,
	altText varchar(200) NULL ,
	notes text NULL ,
	isActive integer NULL ,
	height integer NULL ,
	width integer NULL ,
	textBody text NULL ,
  CONSTRAINT PK_tadcreatives PRIMARY KEY (creativeID)
);

CREATE TABLE tadipwhitelist (
	IP varchar(50) NOT NULL ,
	siteID varchar(50) NOT NULL 
);

CREATE TABLE tadplacementdetails (
	detailID SERIAL ,
	placementID char(35) NOT NULL ,
	PlacementType varchar(50) NOT NULL ,
	PlacementValue integer NOT NULL ,
  CONSTRAINT PK_tadplacementdetails PRIMARY KEY (detailID)
);

CREATE TABLE tadplacements (
	placementID char(35) NOT NULL ,
	campaignID char(35) NULL ,
	adZoneID char(35) NULL ,
	creativeID char(35) NULL ,
	dateCreated timestamp NULL ,
	lastUpdate timestamp NULL ,
	lastUpdateBy varchar(50) NULL ,
	startDate timestamp NULL ,
	endDate timestamp NULL ,
	costPerImp decimal(18, 5) NULL ,
	costPerClick decimal(18, 2) NULL ,
	isExclusive integer NULL ,
	billable decimal(18, 2) NULL ,
	budget integer NULL ,
	isActive integer NULL ,
	notes text NULL ,
  CONSTRAINT PK_tadplacements PRIMARY KEY (placementID)
);

CREATE TABLE tadstats (
	statID SERIAL ,
	PlacementID char(35) NULL ,
	StatHour integer NULL ,
	StatDate timestamp NULL ,
	Type varchar(50) NULL ,
	counter integer NULL ,
  CONSTRAINT PK_tadstats PRIMARY KEY (statID)
);

CREATE TABLE tadzones (
	adZoneID char(35) NOT NULL ,
	siteID varchar(25) NULL ,
	dateCreated timestamp NULL ,
	lastUpdate timestamp NULL ,
	lastUpdateBy varchar(50) NULL ,
	name varchar(50) NULL ,
	creativeType varchar(50) NULL ,
	notes text NULL ,
	isActive integer NULL ,
	height integer NULL ,
	width integer NULL 
);

CREATE TABLE tcaptcha (
	LetterID integer NOT NULL ,
	Letter char(1) NULL ,
	ImageFile varchar(50) NULL 
);

CREATE TABLE tcontent (
	tcontent_ID SERIAL ,
	SiteID varchar(25) NULL ,
	ModuleID char(35) NULL ,
	ParentID char(35) NULL ,
	ContentID char(35) NULL ,
	ContentHistID char(35) NULL ,
	RemoteID varchar(255) NULL ,
	RemoteURL varchar(255) NULL ,
	RemotePubDate varchar(50) NULL ,
	RemoteSourceURL varchar(255) NULL ,
	RemoteSource varchar(255) NULL ,
	Credits varchar(255) NULL ,
	FileID char(35) NULL ,
	Template varchar(50) NULL ,
	Type varchar(25) NULL ,
	subType varchar(25) NULL ,
	Active smallint NULL DEFAULT 0 ,
	OrderNo integer NULL ,
	Title varchar(255) NULL ,
	MenuTitle varchar(255) NULL ,
	Summary text NULL ,
	Filename varchar(255) NULL ,
	MetaDesc text NULL ,
	MetaKeyWords text NULL ,
	Body text NULL ,
	lastUpdate timestamp NULL ,
	lastUpdateBy varchar(50) NULL ,
	lastUpdateByID varchar(50) NULL ,
	DisplayStart timestamp NULL ,
	DisplayStop timestamp NULL ,
	Display smallint NULL ,
	Approved smallint NULL ,
	IsNav smallint NULL ,
	Restricted smallint NULL ,
	RestrictGroups varchar(255) NULL ,
	Target varchar(50) NULL ,
	TargetParams varchar(255) NULL ,
	responseChart smallint NULL ,
	responseMessage text NULL ,
	responseSendTo text NULL ,
	responseDisplayFields text NULL ,
	moduleAssign varchar(255) NULL ,
	displayTitle smallint NULL ,
	Notes text NULL ,
	inheritObjects varchar(25) NULL ,
	isFeature smallint NULL ,
	ReleaseDate timestamp NULL ,
	IsLocked smallint NULL ,
	nextN integer NULL ,
	sortBy varchar(50) NULL ,
	sortDirection varchar(50) NULL ,
	featureStart timestamp NULL ,
	featureStop timestamp NULL ,
	forceSSL smallint NOT NULL DEFAULT 0 ,
	audience varchar(255) NULL ,
	keyPoints text NULL ,
	searchExclude smallint NULL ,
	path text NULL ,
	tags text NULL ,
  CONSTRAINT PK_tcontent_ID PRIMARY KEY (tcontent_ID)
);



CREATE TABLE tcontentstats (
  contentID char(35) NOT NULL,
  siteID varchar(25) NOT NULL,
  views integer  NOT NULL DEFAULT 0,
  rating float NOT NULL DEFAULT 0,
  totalVotes integer  NOT NULL DEFAULT 0,
  upVotes integer  NOT NULL DEFAULT 0,
  downVotes integer  NOT NULL DEFAULT 0,
  comments integer  NOT NULL DEFAULT 0,
  CONSTRAINT PK_tcontentstats PRIMARY KEY (contentID, siteID)
);

CREATE TABLE tcontentassignments (
	contentID char(35) NOT NULL ,
	contentHistID char(35) NOT NULL ,
	siteID varchar(50) NOT NULL ,
	userID char(35) NOT NULL ,
  CONSTRAINT PK_tcontentassignments PRIMARY KEY (contentID,	contentHistID, siteID, userID)
);

CREATE TABLE tcontentcategories (
	categoryID char(35) NOT NULL ,
	siteID varchar(25) NULL ,
	parentID char(35) NULL ,
	dateCreated timestamp NULL ,
	lastUpdate timestamp NULL ,
	lastUpdateBy varchar(50) NULL ,
	name varchar(50) NULL ,
	notes text NULL ,
	isInterestGroup integer NULL ,
	isActive integer NULL ,
	isOpen integer NULL ,
	sortBy varchar(50) NULL ,
	sortDirection varchar(50) NULL ,
	restrictGroups varchar(255) NULL ,
	path text NULL ,
  CONSTRAINT PK_tcontentcategories PRIMARY KEY (categoryID)
);

CREATE TABLE tcontentcategoryassign (
	contentHistID char(35) NOT NULL ,
	categoryID char(35) NOT NULL ,
	contentID char(35) NULL ,
	isFeature integer NULL ,
	orderno integer NULL ,
	siteID varchar(25) NULL ,
	featureStart timestamp NULL ,
	featureStop timestamp NULL ,
  CONSTRAINT PK_tcontentcategoryassign PRIMARY KEY (contentHistID, categoryID)
);

CREATE TABLE tcontentcomments (
	commentid char(35) NOT NULL ,
	contentid char(35) NULL ,
	contenthistid char(35) NULL ,
	url varchar(50) NULL ,
	name varchar(50) NULL ,
	comments text NULL ,
	entered timestamp NULL ,
	email varchar(100) NULL ,
	siteid varchar(25) NULL ,
	ip varchar(50) NULL ,
	isApproved smallint NULL DEFAULT 0 ,
  CONSTRAINT PK_tcontentcomments PRIMARY KEY (commentid)
);

CREATE TABLE tcontenteventreminders (
	contentId char(35) NOT NULL ,
	siteId varchar(25) NOT NULL ,
	email varchar(200) NOT NULL ,
	RemindDate timestamp NULL ,
	RemindHour integer NULL ,
	RemindMinute integer NULL ,
	RemindInterval integer NULL ,
	isSent integer NULL 
);

CREATE TABLE tcontentfeedadvancedparams (
	paramID char(35) NOT NULL ,
	feedID char(35) NOT NULL ,
	param numeric(18, 0) NULL ,
	relationship varchar(50) NULL ,
	field varchar(100) NULL ,
	condition varchar(50) NULL ,
	criteria varchar(200) NULL ,
	dataType varchar(50) NULL ,
  CONSTRAINT PK_tcontentFeedAdvanceParams PRIMARY KEY (paramID)
);

CREATE TABLE tcontentfeeditems (
	feedID char(35) NOT NULL ,
	itemID char(35) NOT NULL ,
	type varchar(50) NULL 
);

CREATE TABLE tcontentfeeds (
	feedID char(35) NOT NULL ,
	siteID varchar(25) NULL ,
	parentID char(35) NULL ,
	name varchar(250) NULL ,
	isActive smallint NULL ,
	isPublic smallint NULL ,
	isDefault smallint NULL ,
	isFeaturesOnly smallint NULL ,
	description text NULL ,
	maxItems integer NULL ,
	allowHTML smallint NULL ,
	lang varchar(50) NULL ,
	lastUpdateBy varchar(100) NULL ,
	lastUpdate timestamp NULL ,
	dateCreated timestamp NULL ,
	restricted smallint NULL ,
	restrictGroups text NULL ,
	version varchar(50) NULL ,
	channelLink varchar(250) NULL ,
	Type varchar(50) NULL ,
	sortBy varchar(50) NULL ,
	sortDirection varchar(50) NULL ,
	nextN integer NULL ,
	displayName smallint NULL ,
	displayRatings smallint NULL ,
	displayComments smallint NULL ,
  CONSTRAINT PK_tcontentfeeds PRIMARY KEY (feedID)
);

CREATE TABLE tcontentobjects (
	ContentHistID char(35) NOT NULL ,
	ObjectID varchar(100) NOT NULL ,
	Object varchar(50) NOT NULL ,
	ContentID char(35) NULL ,
	Name varchar(255) NULL ,
	OrderNo integer NULL ,
	SiteID varchar(25) NULL ,
	ColumnID integer NOT NULL ,
  CONSTRAINT PK_tcontentobjects PRIMARY KEY (ContentHistID, ObjectID, Object, ColumnID)
);

CREATE TABLE tcontentdisplaytitleapprovals (
	contentid char(35) NOT NULL ,
	isApproved smallint NULL ,
	email varchar(150) NULL ,
	siteid varchar(25) NULL 
);

CREATE TABLE tcontentratings (
	contentID char(35) NOT NULL ,
	userID char(35) NOT NULL ,
	siteID char(25) NOT NULL ,
	rate integer NULL ,
	entered timestamp NULL DEFAULT current_timestamp ,
  CONSTRAINT PK_tcontentratings PRIMARY KEY (contentID, userID, siteID)
);

CREATE TABLE tcontentrelated (
	contentHistID char(35) NOT NULL ,
	relatedID char(35) NOT NULL ,
	contentID char(35) NOT NULL ,
	siteID varchar(25) NOT NULL ,
  CONSTRAINT PK_tcontentrelated PRIMARY KEY (contentHistID, relatedID, contentID, siteID)
);

CREATE TABLE temailreturnstats (
	emailID char(35) NULL ,
	email varchar(100) NULL ,
	url varchar(1500) NULL ,
	created timestamp NULL 
);

CREATE TABLE temailstats (
	EmailID char(35) NULL ,
	Email varchar(100) NULL ,
	emailOpen integer NOT NULL DEFAULT 0 ,
	returnClick integer NOT NULL DEFAULT 0 ,
	bounce integer NOT NULL DEFAULT 0 ,
	sent integer NOT NULL DEFAULT 0 ,
	Created timestamp NULL 
);

CREATE TABLE temails (
	EmailID char(35) NOT NULL ,
	siteid varchar(25) NULL ,
	Subject varchar(255) NULL ,
	BodyText text NULL ,
	BodyHtml text NULL ,
	CreatedDate timestamp NULL ,
	DeliveryDate timestamp NULL ,
	status smallint NULL ,
	GroupList text NULL ,
	LastUpdateBy varchar(50) NULL ,
	LastUpdateByID varchar(35) NULL ,
	NumberSent integer NOT NULL DEFAULT 0 ,
	ReplyTo varchar(50) NULL ,
	format varchar(50) NULL ,
	fromLabel varchar(50) NULL ,
	isDeleted smallint NOT NULL DEFAULT 0 ,
  CONSTRAINT PK_temails PRIMARY KEY (EmailID)
);

CREATE TABLE tfiles (
	fileID char(35) NOT NULL ,
	contentID char(35) NULL ,
	siteID varchar(25) NULL ,
	moduleID char(35) NULL ,
	filename varchar(200) NULL ,
	image bytea NULL ,
	imageSmall bytea NULL ,
	imageMedium bytea NULL ,
	fileSize integer NULL ,
	contentType varchar(100) NULL ,
	contentSubType varchar(200) NULL ,
	fileExt varchar(50) NULL ,
	created timestamp NULL ,
  CONSTRAINT PK_tfiles PRIMARY KEY (fileID)
);

CREATE TABLE tformresponsepackets (
	ResponseID char(35) NOT NULL ,
	FormID char(35) NULL ,
	SiteID varchar(25) NULL ,
	FieldList text NULL ,
	Data text NULL ,
	Entered timestamp NULL ,
  CONSTRAINT PK_tformresponsepackets PRIMARY KEY (ResponseID)
);

CREATE TABLE tformresponsequestions (
	responseID char(35) NULL ,
	formID char(35) NULL ,
	formField varchar(50) NULL ,
	formValue text NULL ,
	pollValue varchar(255) NULL 
);

CREATE TABLE tglobals (
	appreload timestamp NULL, 
	loadlist varchar(500) NULL 
);

CREATE TABLE tmailinglist (
	MLID char(35) NULL ,
	SiteID varchar(25) NULL ,
	Name varchar(50) NULL ,
	Description text NULL ,
	LastUpdate timestamp NULL ,
	isPurge integer NULL ,
	isPublic integer NULL 
);

CREATE TABLE tmailinglistmembers (
	MLID char(35) NULL ,
	Email varchar(100) NULL ,
	SiteID varchar(25) NULL ,
	fname varchar(50) NULL ,
	lname varchar(50) NULL ,
	company varchar(50) NULL ,
	isVerified smallint NOT NULL
);

CREATE TABLE tpermissions (
	ContentID char(35) NULL ,
	GroupID char(35) NULL ,
	SiteID varchar(25) NULL ,
	Type varchar(50) NULL 
);

CREATE TABLE tredirects (
	redirectID char(35) NOT NULL ,
	URL varchar(2000) NULL ,
	created timestamp NULL ,
  CONSTRAINT PK_tredirects PRIMARY KEY (redirectID)
);

CREATE TABLE tsessiontracking (
	trackingID SERIAL ,
	contentID char(35) NULL ,
	siteID varchar(25) NULL ,
	userid char(35) NULL ,
	remote_addr varchar(50) NULL ,
	server_name varchar(50) NULL ,
	query_string varchar(300) NULL ,
	referer varchar(255) NULL ,
	user_agent varchar(200) NULL ,
	script_name varchar(200) NULL ,
	urlToken varchar(130) NOT NULL ,
	entered timestamp NOT NULL ,
	country varchar(50) NULL ,
	lang varchar(50) NULL ,
	locale varchar(50) NULL ,
	keywords varchar(200) NULL ,
	originalUrlToken varchar(130) NULL ,
  CONSTRAINT PK_tsessiontracking PRIMARY KEY (trackingID)
);

CREATE TABLE tsettings (
	SiteID varchar(25) NULL ,
	Site varchar(50) NULL ,
	MaxNestLevel integer NULL ,
	PageLimit integer NULL ,
	Locking varchar(50) NULL ,
	Domain varchar(100) NULL ,
	exportLocation varchar(100) NULL ,
	FileDir varchar(50) NULL ,
	Contact varchar(50) NULL ,
	MailserverIP varchar(50) NULL ,
	MailServerUsername varchar(50) NULL ,
	MailServerPassword varchar(50) NULL ,
	EmailBroadcaster integer NULL ,
	Extranet integer NULL ,
	ExtranetPublicReg integer NULL ,
	ExtranetPublicRegNotify varchar(50) NULL ,
	ExtranetSSL integer NULL ,
	Cache integer NULL ,
	ViewDepth integer NULL ,
	NextN integer NULL ,
	DataCollection integer NULL ,
	columnCount integer NULL ,
	columnNames varchar(255) NULL ,
	primaryColumn integer NULL ,
	publicSubmission integer NULL ,
	AdManager integer NULL ,
	archiveDate timestamp NULL ,
	contactName varchar(50) NULL ,
	contactAddress varchar(50) NULL ,
	contactCity varchar(50) NULL ,
	contactState varchar(50) NULL ,
	contactZip varchar(50) NULL ,
	contactEmail varchar(100) NULL ,
	contactPhone varchar(50) NULL ,
	privateUserPoolID varchar(50) NULL ,
	publicUserPoolID varchar(50) NULL ,
	advertiserUserPoolID varchar(50) NULL ,
	orderNo integer NULL ,
	emailBroadcasterLimit integer NOT NULL ,
	feedManager integer NULL ,
	displayPoolID varchar(50) NULL ,
	galleryMainScaleBy varchar(50) NULL ,
	galleryMainScale integer NULL ,
	gallerySmallScaleBy varchar(50) NULL ,
	gallerySmallScale integer NULL ,
	galleryMediumScaleBy varchar(50) NULL ,
	galleryMediumScale integer NULL ,
	sendLoginScript text NULL ,
	mailingListConfirmScript text NULL ,
	publicSubmissionApprovalScript text NULL ,
	reminderScript text NULL ,
	loginURL varchar(255) NULL ,
	editProfileURL varchar(255) NULL ,
	CommentApprovalDefault smallint NULL ,
	deploy smallint NULL ,
	lastDeployment timestamp NULL ,
	accountActivationScript text NULL,
	googleAPIKey varchar(100) NULL ,
	useDefaultSMTPServer smallint NULL,
  theme varchar(50) NULL,
 	mailserverSMTPPort varchar(5) NULL,
 	mailserverPOPPort varchar(5) NULL,
 	mailserverTLS varchar(5) NULL,
 	mailserverSSL varchar(5) NULL
);

CREATE TABLE tsystemobjects (
	Object varchar(50) NULL ,
	SiteID varchar(25) NULL ,
	Name varchar(50) NULL ,
	OrderNo integer NULL 
);

CREATE TABLE tuseraddresses (
	addressID char(35) NOT NULL ,
	userID char(35) NULL ,
	siteID varchar(50) NULL ,
	addressName varchar(50) NULL ,
	address1 varchar(50) NULL ,
	address2 varchar(50) NULL ,
	city varchar(50) NULL ,
	state varchar(50) NULL ,
	zip varchar(50) NULL ,
	country varchar(50) NULL ,
	phone varchar(50) NULL ,
	fax varchar(50) NULL ,
	isPrimary smallint NULL ,
	addressNotes text NULL,
	addressURL varchar(200) NULL,
	longitude float NULL,
  latitude float NULL,
	addressEmail varchar(100) NULL,
	hours text NULL ,
  CONSTRAINT PK_tuseraddresses PRIMARY KEY (addressID)
);

CREATE TABLE tusers (
	UserID char(35) NOT NULL ,
	GroupName varchar(50) NULL ,
	Fname varchar(50) NULL ,
	Lname varchar(50) NULL ,
	UserName varchar(50) NULL ,
	Password varchar(50) NULL ,
	PasswordCreated timestamp NULL ,
	Email varchar(100) NULL ,
	Company varchar(50) NULL ,
	JobTitle varchar(50) NULL ,
	mobilePhone varchar(50) NULL ,
	Website varchar(255) NULL ,
	Type integer NULL ,
	subType varchar(50) NULL ,
	Ext integer NULL ,
	ContactForm text NULL ,
	Admin integer NULL ,
	S2 integer NULL ,
	LastLogin timestamp NULL ,
	LastUpdate timestamp NULL ,
	LastUpdateBy varchar(50) NULL ,
	LastUpdateByID varchar(35) NULL ,
	Perm smallint NULL ,
	InActive smallint NULL ,
	isPublic integer NULL ,
	SiteID varchar(50) NULL ,
	Subscribe integer NULL ,
	notes text NULL ,
	description text NULL ,
	interests text NULL ,
	keepPrivate smallint NULL ,
	photoFileID char(35) NULL ,
	IMName varchar(100) NULL ,
	IMService varchar(50) NULL ,
	created timestamp NULL DEFAULT current_timestamp ,
	remoteID varchar(35) NULL ,
	tags text NULL ,
  CONSTRAINT PK_tusers PRIMARY KEY (userID)
);

CREATE TABLE tusersfavorites (
	favoriteID char(35) NOT NULL ,
	userID char(35) NOT NULL ,
	favoriteName varchar(100) NULL ,
	favorite varchar(1000) NOT NULL ,
	type varchar(30) NOT NULL ,
	siteID varchar(25) NULL ,
	dateCreated timestamp NOT NULL DEFAULT current_timestamp ,
	columnNumber integer NULL ,
	rowNumber integer NULL ,
	maxRSSItems integer NULL ,
  CONSTRAINT PK_tusersfavorites PRIMARY KEY (favoriteID)
);

CREATE TABLE tusersinterests (
	userID char(35) NOT NULL ,
	categoryID char(35) NOT NULL ,
  CONSTRAINT PK_tusersinterests PRIMARY KEY (userID, categoryID)
);

CREATE TABLE tusersmemb (
	UserID char(35) NOT NULL ,
	GroupID char(35) NOT NULL ,
  CONSTRAINT PK_tusersmemb PRIMARY KEY (UserID, GroupID)
);

CREATE TABLE tcontentpublicsubmissionapprovals (
	contentid char(35) NOT NULL ,
	isApproved smallint NULL ,
	email varchar(150) NULL ,
	siteid varchar(25) NULL 
);

CREATE TABLE tcontenttags (
	tagID SERIAL ,
	contentHistID char(35) NOT NULL ,
	contentID char(35) NOT NULL ,
	siteID char(25) NOT NULL ,
	tag varchar(100) NOT NULL ,
  CONSTRAINT PK_tcontenttags PRIMARY KEY (tagID)
);

CREATE TABLE tclassextenddatauseractivity (
	dataID SERIAL ,
	baseID char(35) NOT NULL ,
	attributeID integer NOT NULL ,
	siteID varchar(25) NULL ,
	attributeValue text NULL ,
  CONSTRAINT PK_tclassextenddatauseractivity PRIMARY KEY (dataID)
);

CREATE TABLE tclassextenddata (
	dataID SERIAL ,
	baseID char(35) NOT NULL ,
	attributeID integer NOT NULL ,
	siteID varchar(25) NULL ,
	attributeValue text NULL ,
  CONSTRAINT PK_tclassextenddata PRIMARY KEY (dataID)
);

CREATE TABLE tclassextend (
	subTypeID char(35) NOT NULL ,
	siteID varchar(25) NULL ,
	baseTable varchar(50) NULL ,
	baseKeyField varchar(50) NULL ,
	dataTable varchar(50) NULL ,
	type varchar(50) NULL ,
	subType varchar(50) NULL ,
	isActive smallint NULL ,
	notes text NULL ,
	lastUpdate timestamp NULL ,
	dateCreated timestamp NULL ,
	lastUpdateBy varchar(100) NULL ,
  CONSTRAINT PK_TClassSubTypes PRIMARY KEY (subTypeID)
);

CREATE TABLE tclassextendattributes (
	attributeID SERIAL ,
	extendSetID char(35) NULL ,
	siteID varchar(25) NULL ,
	name varchar(100) NULL ,
	label text NULL ,
	hint text  NULL ,
	type varchar(100) NULL ,
	orderno integer NULL ,
	isActive smallint NULL ,
	required varchar(50) NULL ,
	validation varchar(50) NULL ,
	regex varchar(300) NULL ,
	message varchar(300) NULL ,
	defaultValue varchar(100) NULL ,
	optionList text NULL ,
	optionLabelList text NULL ,
  CONSTRAINT PK_tclassextendattributes PRIMARY KEY (attributeID)
);

CREATE TABLE tclassextendsets (
	extendSetID char(35) NOT NULL ,
	subTypeID char(35) NULL ,
	categoryID text NULL ,
	siteID varchar(25) NULL ,
	name varchar(50) NULL ,
	orderno integer NULL ,
	isActive smallint NULL ,
  CONSTRAINT PK_tclassextendsets PRIMARY KEY (extendSetID)
);

CREATE TABLE tuserstags (
	tagID SERIAL ,
	userID char(35) NULL ,
	siteid varchar(25) NULL ,
	tag varchar(100) NULL ,
  CONSTRAINT PK_tuserstags PRIMARY KEY (tagID)
);



CREATE  INDEX IX_tcontent ON tcontent(ContentID);
CREATE  INDEX IX_tcontent_1 ON tcontent(ContentHistID);
CREATE  INDEX IX_tcontent_2 ON tcontent(SiteID);
CREATE  INDEX IX_tcontent_3 ON tcontent(ParentID);
CREATE  INDEX IX_tcontent_4 ON tcontent(RemoteID);
CREATE  INDEX IX_tcontent_5 ON tcontent(ModuleID);
CREATE  INDEX IX_tcontentcategories ON tcontentcategories(siteID);
CREATE  INDEX IX_tcontentcomments ON tcontentcomments(contentid);
CREATE  INDEX IX_tcontentfeeds ON tcontentfeeds(siteID);
CREATE  INDEX IX_tcontentobjects ON tcontentobjects(SiteID);
CREATE  INDEX IX_tcontentratings ON tcontentratings(entered);
CREATE  INDEX IX_temails ON temails(siteid);
CREATE  INDEX IX_tformresponsepackets ON tformresponsepackets(FormID, SiteID);
CREATE  INDEX IX_tsessiontracking ON tsessiontracking(siteID) WITH (fillfactor = 90);
CREATE  INDEX IX_tsessiontracking_1 ON tsessiontracking(contentID) WITH (fillfactor = 90);
CREATE  INDEX IX_tsessiontracking_2 ON tsessiontracking(urlToken) WITH (fillfactor = 90);
CREATE  INDEX IX_tsessiontracking_3 ON tsessiontracking(userID) WITH (fillfactor = 90);
CREATE  INDEX IX_tsessiontracking_4 ON tsessiontracking(entered) WITH (fillfactor = 90);
CREATE  INDEX IX_tcontentpublicsubmissionapprovals ON tcontentpublicsubmissionapprovals(contentid);
CREATE  INDEX IX_tcontentpublicsubmissionapprovals_1 ON tcontentpublicsubmissionapprovals(siteid);
CREATE  INDEX IX_tcontenttags ON tcontenttags(tag);
CREATE  INDEX IX_tcontenttags_1 ON tcontenttags(contentHistID);
CREATE  INDEX IX_tcontenttags_2 ON tcontenttags(contentID);
CREATE  INDEX IX_tcontenttags_3 ON tcontenttags(siteID);
CREATE  INDEX IX_tuserstags ON tuserstags(userID);
CREATE  INDEX IX_tuserstags_1 ON tuserstags(siteid);
CREATE  INDEX IX_tuserstags_2 ON tuserstags(tag);
CREATE  INDEX IX_tuseraddresses_1 ON tuseraddresses(longitude);
CREATE  INDEX IX_tuseraddresses_2 ON tuseraddresses(latitude);
CREATE  INDEX IX_tuseraddresses_3 ON tuseraddresses(userID);
CREATE  INDEX IX_tclassextenddatauseractivity_1 ON tclassextenddatauseractivity(baseID);
CREATE  INDEX IX_tclassextenddatauseractivity_2 ON tclassextenddatauseractivity(attributeID);
CREATE  INDEX IX_tclassextenddata_1 ON tclassextenddata(baseID);
CREATE  INDEX IX_tclassextenddata_2 ON tclassextenddata(attributeID);
CREATE  INDEX IX_tclassextendattributes_1 ON tclassextendattributes(extendSetID);
CREATE  INDEX IX_tclassextendsets_1 ON tclassextendsets(subTypeID);


INSERT INTO tsystemobjects
  (Object,SiteID,Name,OrderNo)
VALUES
  ('event_reminder_form','default','Event Reminder Form',12)
  ,('forward_email','default','Forward Email',13)
  ,('site_map','default','Site Map',2)
  ,('peer_nav','default','Peer Navigation',3)
  ,('sub_nav','default','Sub Navigation',4)
  ,('standard_nav','default','Standard Navigation',5)
  ,('portal_nav','default','Portal Navigation',6)
  ,('comments','default','Accept Comments',9)
  ,('seq_nav','default','Sequential Nav',8)
  ,('rater','default','Content Rater',16)
  ,('favorites','default','User Favorites',17)
  ,('dragable_feeds','default','Dragable Feeds',18)
  ,('related_content','default','Related Content',19)
  ,('user_tools','default','User Tools',20)
  ,('tag_cloud','default','Tag Cloud',21)
  ,('goToFirstChild','default','Go To First Child',23);

<cfoutput>
INSERT INTO tusers
  (UserID,GroupName,Fname,Lname,UserName,Password,PasswordCreated,Email,Company,JobTitle,mobilePhone,Website,Type,subType,Ext,ContactForm,Admin,S2,LastLogin,LastUpdate,LastUpdateBy,LastUpdateByID,Perm,InActive,isPublic,SiteID,Subscribe,notes,keepPrivate,tags)
VALUES
  ('#adminUserID#',NULL,'Admin','User','admin','21232F297A57A5A743894A0E4A801FC3',current_timestamp,'admin@localhost.com',NULL,NULL,NULL,NULL,2,'Default',NULL,NULL,NULL,1,current_timestamp,current_timestamp,'System','22FC551F-FABE-EA01-C6EDD0885DDC1682',0,0,0,'default',0,NULL,0,NULL)
  ,('#createUUID()#','Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Default',NULL,NULL,NULL,0,NULL,current_timestamp,'System',NULL,1,0,0,'default',0,NULL,0,NULL);
</cfoutput>
INSERT INTO tsettings (SiteID,Site,MaxNestLevel,PageLimit,Locking,Domain,exportLocation,FileDir,Contact,MailserverIP,MailServerUsername,MailServerPassword,EmailBroadcaster,Extranet,ExtranetPublicReg,ExtranetPublicRegNotify,ExtranetSSL,Cache,ViewDepth,NextN,DataCollection,columnCount,columnNames,primaryColumn,publicSubmission,AdManager,archiveDate,contactName,contactAddress,contactCity,contactState,contactZip,contactEmail,contactPhone,privateUserPoolID,publicUserPoolID,advertiserUserPoolID,orderNo,emailBroadcasterLimit,feedManager,displayPoolID,galleryMainScaleBy,galleryMainScale,gallerySmallScaleBy,gallerySmallScale,galleryMediumScaleBy,galleryMediumScale,sendLoginScript,mailingListConfirmScript,publicSubmissionApprovalScript,reminderScript,loginURL,editProfileURL,CommentApprovalDefault,deploy,lastDeployment,useDefaultSMTPServer) VALUES ('default','Default',NULL,1000,'none','localhost',NULL,NULL,'info@getmura.com','mail.server.com','username@server.com','password',1,1,1,null,0,0,1,20,1,3,'Left Column^Main Content^Right Column',2,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default','default','default',1,0,1,'default','y',500,'s',100,'y',250,NULL,NULL,NULL,NULL,'?display=login','?display=editProfile',1,0,NULL,0);


INSERT INTO tcontent
  (SiteID,ModuleID,ParentID,ContentID,ContentHistID,RemoteID,RemoteURL,RemotePubDate,RemoteSourceURL,RemoteSource,Credits,FileID,Template,Type,subType,Active,OrderNo,Title,MenuTitle,Summary,Filename,MetaDesc,MetaKeyWords,Body,lastUpdate,lastUpdateBy,lastUpdateByID,DisplayStart,DisplayStop,Display,Approved,IsNav,Restricted,RestrictGroups,Target,TargetParams,responseChart,responseMessage,responseSendTo,responseDisplayFields,moduleAssign,displayTitle,Notes,inheritObjects,isFeature,ReleaseDate,IsLocked,nextN,sortBy,sortDirection,featureStart,featureStop,forceSSL,audience,keyPoints,searchExclude,path)
VALUES
  ('default','00000000000000000000000000000000003','00000000000000000000000000000000END','00000000000000000000000000000000003','6300ED4A-1320-5CC3-F9D6A2D279E386D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Components',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,null)
  ,('default','00000000000000000000000000000000004','00000000000000000000000000000000END','00000000000000000000000000000000004','6300ED59-1320-5CC3-F9706221E0EFF7A2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Forms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000001','6300ED69-1320-5CC3-F922E3012E2C6BAE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default.cfm','Page','Default',1,1,'Home','Home',NULL,NULL,NULL,NULL,NULL,current_timestamp,'System',NULL,NULL,NULL,1,1,1,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'Cascade',0,NULL,0,10,'orderno','asc',NULL,NULL,0,NULL,NULL,0,'''00000000000000000000000000000000001''')
  ,('default','00000000000000000000000000000000006','00000000000000000000000000000000END','00000000000000000000000000000000006','6300ED79-1320-5CC3-F92E6325C26664B6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Advertising',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000000','00000000000000000000000000000000END','00000000000000000000000000000000000','6300ED88-1320-5CC3-F9E241684D21FEC9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000008','00000000000000000000000000000000END','00000000000000000000000000000000008','6300ED98-1320-5CC3-F9398EB23A57CBD0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Site Members',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000005','00000000000000000000000000000000END','00000000000000000000000000000000005','6300EDA8-1320-5CC3-F93DF074187C935E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Email Broadcaster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000009','00000000000000000000000000000000END','00000000000000000000000000000000009','6300EDB7-1320-5CC3-F9D664F38EBBD2D0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Mailing Lists',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000010','00000000000000000000000000000000END','00000000000000000000000000000000010','6300EDC7-1320-5CC3-F9DB8034C9626B70',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Categories',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000011','00000000000000000000000000000000END','00000000000000000000000000000000011','6300EDD6-1320-5CC3-F9625545444B880F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Content Collections',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null)
  ,('default','00000000000000000000000000000000012','00000000000000000000000000000000END','00000000000000000000000000000000012','6300EDE6-1320-5CC3-F94E2FCEF5DE046D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Module','Default',1,NULL,'Filemanager Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,null);
<cfoutput>
INSERT INTO tmailinglist (MLID,SiteID,Name,Description,LastUpdate,isPurge,isPublic ) VALUES ('#createUUID()#','default','Please Remove Me from All Lists','',current_timestamp,1,1);
</cfoutput>

INSERT INTO tcaptcha
  (LetterID,Letter,ImageFile)
VALUES
  (1,'a','a.gif')
  ,(2,'b','b.gif')
  ,(3,'c','c.gif')
  ,(4,'d','d.gif')
  ,(5,'e','e.gif')
  ,(6,'f','f.gif')
  ,(7,'g','g.gif')
  ,(8,'h','h.gif')
  ,(9,'i','i.gif')
  ,(10,'j','j.gif')
  ,(11,'k','k.gif')
  ,(12,'l','l.gif')
  ,(13,'m','m.gif')
  ,(14,'n','n.gif')
  ,(15,'o','o.gif')
  ,(16,'p','p.gif')
  ,(17,'q','q.gif')
  ,(18,'r','r.gif')
  ,(19,'s','s.gif')
  ,(20,'t','t.gif')
  ,(21,'u','u.gif')
  ,(22,'v','v.gif')
  ,(23,'w','w.gif')
  ,(24,'x','x.gif')
  ,(25,'y','y.gif')
  ,(26,'z','z.gif');