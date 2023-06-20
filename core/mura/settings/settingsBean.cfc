/*  
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exc©©eption, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
/**
 * Site settings bean
 */
component extends="mura.bean.beanExtendable" entityName="site" table="tsettings" output="false" hint="Site settings bean" {
	property name="siteID" fieldtype="id" type="string" default="" required="true";
	property name="site" type="string" default="";
	property name="tagLine" type="string" default="";
	property name="pageLimit" type="string" default="1000" required="true";
	property name="locking" type="string" default="none" required="true";
	property name="domain" type="string" default="";
	property name="domainAlias" type="string" default="";
	property name="enforcePrimaryDomain" type="int" default="0" required="true";
	property name="contact" type="string" default="";
	property name="mailServerIP" type="string" default="";
	property name="mailServerSMTPPort" type="string" default="25" required="true";
	property name="mailServerPOPPort" type="string" default="110" required="true";
	property name="mailserverTLS" type="string" default="false" required="true";
	property name="mailserverSSL" type="string" default="false" required="true";
	property name="mailServerUsername" type="string" default="";
	property name="mailServerUsernameEmail" type="string" default="";
	property name="mailServerPassword" type="string" default="";
	property name="useDefaultSMTPServer" type="numeric" default="1" required="true";
	property name="EmailBroadcaster" type="numeric" default="0" required="false";
	property name="EmailBroadcasterLimit" type="numeric" default="0" required="true";
	property name="extranet" type="numeric" default="0" required="true";
	property name="extranetSSL" type="numeric" default="0" required="true" hint="deprecated";
	property name="cache" type="numeric" default="0" required="true";
	property name="cacheCapacity" type="numeric" default="0" required="true";
	property name="cacheFreeMemoryThreshold" type="numeric" default="60" required="true";
	property name="viewDepth" type="numeric" default="1" required="true";
	property name="nextN" type="numeric" default="20" required="true";
	property name="dataCollection" type="numeric" default="1" required="true";
	property name="columnCount" type="numeric" default="3" required="true";
	property name="columnNames" type="string" default="Left Column^Main Content^Right Column" required="true";
	property name="ExtranetPublicReg" type="numeric" default="0" required="true";
	property name="primaryColumn" type="numeric" default="2" required="true";
	property name="contactName" type="string" default="";
	property name="contactAddress" type="string" default="";
	property name="contactCity" type="string" default="";
	property name="contactState" type="string" default="";
	property name="contactZip" type="string" default="";
	property name="contactEmail" type="string" default="";
	property name="contactPhone" type="string" default="";
	property name="publicUserPoolID" type="string" default="";
	property name="privateUserPoolID" type="string" default="";	
	property name="displayPoolID" type="string" default="";
	property name="contentPoolID" type="string" default="";
	property name="categoryPoolID" type="string" default="";
	property name="filePoolID" type="string" default="";
	property name="placeholderImgID" type="string" default="";
	property name="feedManager" type="numeric" default="1" required="true";
	property name="largeImageHeight" type="string" default="AUTO" required="true";
	property name="largeImageWidth" type="numeric" default="600" required="true";
	property name="smallImageHeight" type="string" default="80" required="true";
	property name="smallImageWidth" type="numeric" default="80" required="true";
	property name="mediumImageHeight" type="string" default="180" required="true";
	property name="mediumImageWidth" type="numeric" default="180" required="true";
	property name="sendLoginScript" type="string" default="";
	property name="sendAuthCodeScript" type="string" default="";
	property name="mailingListConfirmScript" type="string" default="";
	property name="reminderScript" type="string" default="";
	property name="ExtranetPublicRegNotify" type="string" default="";
	property name="exportLocation" type="string" default="";
	property name="loginURL" type="string" default="";
	property name="editProfileURL" type="string" default="";
	property name="commentApprovalDefault" type="numeric" default="1" required="true";
	property name="display" type="numeric" default="1" required="true";
	property name="lastDeployment" type="date" default="";
	property name="accountActivationScript" type="string" default="";
	property name="googleAPIKey" type="string" default="";
	property name="siteLocale" type="string" default="";
	property name="hasChangesets" type="numeric" default="1" required="true";
	property name="theme" type="string" default="";
	property name="javaLocale" type="string" default="";
	property name="orderno" type="numeric" default="0" required="true";
	property name="enforceChangesets" type="numeric" default="0" required="true";
	property name="contentPendingScript" type="string" default="";
	property name="contentApprovalScript" type="string" default="";
	property name="contentRejectionScript" type="string" default="";
	property name="contentCanceledScript" type="string" default="";
	property name="enableLockdown" type="string" default="";
	property name="customTagGroups" type="string" default="";
	property name="hasComments" type="numeric" default="1" required="true";
	property name="hasLockableNodes" type="numeric" default="0" required="true";
	property name="reCAPTCHASiteKey" type="string" default="";
	property name="reCAPTCHASecret" type="string" default="";
	property name="reCAPTCHALanguage" type="string" default="en";
	property name="JSONApi" type="numeric" default="0";
	property name="useSSL" type="numeric" default="0";
	property name="isRemote" type="numeric" default="0";
	property name="RemoteContext" type="string" default="";
	property name="RemotePort" type="numeric" default="0";
	property name="resourceSSL" type="numeric" default="0";
	property name="resourceDomain" type="string" default="";
	property name="showDashboard" type="numeric" default="0";
	property name="scaffolding" type="numeric" default="1";

	variables.primaryKey = 'siteid';
	variables.entityName = 'site';
	variables.instanceName= 'site';

	public function init() output=false {
		super.init(argumentCollection=arguments);
		variables.instance.SiteID="";
		variables.instance.Site="";
		variables.instance.TagLine="";
		variables.instance.pageLimit=1000;
		variables.instance.Locking="None";
		variables.instance.Domain="";
		variables.instance.DomainAlias="";
		variables.instance.enforcePrimaryDomain=0;
		variables.instance.Contact="";
		variables.instance.MailServerIP="";
		variables.instance.MailServerSMTPPort="25";
		variables.instance.MailServerPOPPort="110";
		variables.instance.MailServerTLS="false";
		variables.instance.MailServerSSL="false";
		variables.instance.MailServerUsername="";
		variables.instance.MailServerUsernameEmail="";
		variables.instance.MailServerPassword="";
		variables.instance.useDefaultSMTPServer=1;
		variables.instance.EmailBroadcaster=0;
		variables.instance.EmailBroadcasterLimit=0;
		variables.instance.Extranet=0;
		variables.instance.ExtranetSSL=0;
		variables.instance.cache=0;
		variables.instance.cacheFactories=structNew();
		variables.instance.cacheCapacity=0;
		variables.instance.cacheFreeMemoryThreshold=60;
		variables.instance.ViewDepth=1;
		variables.instance.nextN=20;
		variables.instance.DataCollection=1;
		variables.instance.ColumnCount=3;
		variables.instance.ColumnNames="Left Column^Main Content^Right Column";
		variables.instance.ExtranetPublicReg=0;
		variables.instance.PrimaryColumn=2;
		variables.instance.PublicSubmission=0;		
		variables.instance.ContactName="";
		variables.instance.ContactAddress="";
		variables.instance.ContactCity="";
		variables.instance.ContactState="";
		variables.instance.ContactZip="";
		variables.instance.ContactEmail="";
		variables.instance.ContactPhone="";
		variables.instance.PublicUserPoolID="";
		variables.instance.PrivateUserPoolID="";		
		variables.instance.DisplayPoolID="";
		variables.instance.ContentPoolID="";
		variables.instance.CategoryPoolID="";
		variables.instance.FilePoolID="";
		variables.instance.placeholderImgID="";
		variables.instance.feedManager=1;
		variables.instance.largeImageHeight='AUTO';
		variables.instance.largeImageWidth='600';
		variables.instance.smallImageHeight='80';
		variables.instance.smallImageWidth='80';
		variables.instance.mediumImageHeight='180';
		variables.instance.mediumImageWidth='180';
		variables.instance.sendLoginScript="";
		variables.instance.sendAuthCodeScript="";
		variables.instance.mailingListConfirmScript="";
		variables.instance.publicSubmissionApprovalScript="";
		variables.instance.reminderScript="";
		variables.instance.ExtranetPublicRegNotify="";
		variables.instance.exportLocation="";
		variables.instance.loginURL="";
		variables.instance.editProfileURL="";
		variables.instance.commentApprovalDefault=1;
		variables.instance.deploy=1;
		variables.instance.lastDeployment="";
		variables.instance.accountActivationScript="";
		variables.instance.googleAPIKey="";
		variables.instance.siteLocale="";
		variables.instance.rbFactory="";
		variables.instance.javaLocale="";
		variables.instance.jsDateKey="";
		variables.instance.jsDateKeyObjInc="";
		variables.instance.theme="";
		variables.instance.contentRenderer="";
		variables.instance.themeRenderer="";
		variables.instance.hasChangesets=1;
		variables.instance.type="Site";
		variables.instance.subtype="Default";
		variables.instance.baseID=createUUID();
		variables.instance.orderno=0;
		variables.instance.enforceChangesets=0;
		variables.instance.contentPendingScript="";
		variables.instance.contentApprovalScript="";
		variables.instance.contentRejectionScript="";
		variables.instance.contentCanceledScript="";
		variables.instance.enableLockdown="";
		variables.instance.customTagGroups="";
		variables.instance.hasSharedFilePool="";
		variables.instance.hasComments=1;
		variables.instance.hasLockableNodes=0;
		variables.instance.reCAPTCHASiteKey="";
		variables.instance.reCAPTCHASecret="";
		variables.instance.reCAPTCHALanguage="en";
		variables.instance.JSONApi=0;
		variables.instance.useSSL=0;
		variables.instance.isRemote=0;
		variables.instance.RemoteContext="";
		variables.instance.RemotePort=80;
		variables.instance.resourceSSL=0;
		variables.instance.resourceDomain="";
		variables.instance.contentTypeFilePathLookup={};
		variables.instance.contentTypeLoopUpArray=[];
		variables.instance.displayObjectLookup={};
		variables.instance.displayObjectFilePathLookup={};
		variables.instance.displayObjectLookUpArray=[];
		variables.instance.htmlQueueFilePathLookup={};
		variables.instance.showDashboard=0;
		variables.instance.themeLookup={};
		variables.instance.scaffolding=1;
		return this;
	}

	public function validate() output=false {
		variables.instance.errors=structnew();
		if ( variables.instance.siteID == "" ) {
			variables.instance.errors.siteid="The 'SiteID' variable == required.";
		}
		if ( variables.instance.siteID == "admin" || variables.instance.siteID == "tasks" ) {
			variables.instance.errors.siteid="The 'SiteID' variable == invalid.";
		}
		/*
			if (not getBean('utility').isValidCFVariableName(variables.instance.siteID)){
				variables.instance.errors.siteid="The 'SiteID' variable is invalid.";
			}
		*/
		return this;
	}

	public function set(required property, propertyValue) output=false {
		if ( !isDefined('arguments.config') ) {
			if ( isSimpleValue(arguments.property) ) {
				return setValue(argumentCollection=arguments);
			}
			arguments.data=arguments.property;
		}
		var prop="";
		if ( isQuery(arguments.data) && arguments.data.recordcount ) {

			for(prop in ListToArray(arguments.data.columnlist)){
				setValue(prop,arguments.data[prop][1]);
			}

		} else if ( isStruct(arguments.data) ) {
			for ( prop in arguments.data ) {
				setValue(prop,arguments.data[prop]);
			}
		}
		if ( variables.instance.privateUserPoolID == '' ) {
			variables.instance.privateUserPoolID=variables.instance.siteID;
		}
		if ( variables.instance.publicUserPoolID == '' ) {
			variables.instance.publicUserPoolID=variables.instance.siteID;
		}		
		if ( variables.instance.displayPoolID == '' ) {
			variables.instance.displayPoolID=variables.instance.siteID;
		}
		if ( variables.instance.filePoolID == '' ) {
			variables.instance.filePoolID=variables.instance.siteID;
		}
		if ( variables.instance.categoryPoolID == '' ) {
			variables.instance.categoryPoolID=variables.instance.siteID;
		}
		if ( variables.instance.contentPoolID == '' ) {
			variables.instance.contentPoolID=variables.instance.siteID;
		}
		return this;
	}

	public function setConfigBean(configBean) output=false {
		variables.configBean=arguments.configBean;
		return this;
	}

	public function setBaseID(baseID) output=false {
		if ( len(arguments.baseID) ) {
			variables.instance.baseID=arguments.baseID;
		}
	}

	public function setScaffolding(scaffolding) output=false {
		if ( isNumeric(arguments.scaffolding) ) {
			variables.instance.scaffolding=arguments.scaffolding;
		}
	}

	public function getExtendBaseID() output=false {
		return variables.instance.baseID;
	}

	public function setTheme(theme) output=false {
		if ( arguments.theme != variables.instance.theme ) {
			variables.instance.theme=arguments.theme;
		}
	}

	public function getDomain(required String mode="") output=false {
		var temp="";
		if ( arguments.mode == 'preview' ) {
			if ( isDefined('request.muraPreviewDomain') && len(request.muraPreviewDomain) ) {
				return request.muraPreviewDomain;
			} else {
				return variables.instance.Domain;
			}
		} else {
			return variables.instance.Domain;
		}
	}

	public function setEnforcePrimaryDomain(enforcePrimaryDomain) output=false {
		if ( isNumeric(arguments.enforcePrimaryDomain) ) {
			variables.instance.enforcePrimaryDomain = arguments.enforcePrimaryDomain;
		}
		return this;
	}

	public function getUseSSL() output=false {
		if ( variables.instance.useSSL || variables.instance.extranetSSL ) {
			return 1;
		} else {
			return 0;
		}
	}

	public function setEnforceChangesets(enforceChangesets) output=false {
		if ( isNumeric(arguments.enforceChangesets) ) {
			variables.instance.enforceChangesets = arguments.enforceChangesets;
		}
		return this;
	}

	public function setHasFeedManager(feedManager) output=false {
		variables.instance.feedManager=arguments.feedManager;
		return this;
	}

	public function getHasFeedManager() output=false {
		return variables.instance.feedManager;
	}

	public function setExportLocation(String ExportLocation) output=false {
		if ( arguments.ExportLocation != "export1" ) {
			variables.instance.ExportLocation = arguments.ExportLocation;
		}
		return this;
	}

	public function getDataCollection() output=false {
		if ( !variables.configBean.getDataCollection() ) {
			return 0;
		} else {
			return variables.instance.dataCollection;
		}
	}
	
	public function getEmailBroadcaster() output=false {
		if ( !variables.configBean.getEmailBroadcaster() ) {
			return 0;
		} else {
			return variables.instance.EmailBroadcaster;
		}
	}

	public function setMailServerUsernameEmail(String MailServerUsernameEmail) output=false {
		if ( find("@",arguments.MailServerUsernameEmail) ) {
			variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail;
		} else if ( find("+",arguments.MailServerUsernameEmail) ) {
			variables.instance.MailServerUsernameEmail=replace(arguments.MailServerUsernameEmail,"+","@");
		} else if ( len(arguments.MailServerUsernameEmail) ) {
			variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail & "@" & listRest(variables.instance.MailServerIP,".");
		} else {
			variables.instance.MailServerUsernameEmail=variables.instance.contact;
		}
		return this;
	}

	public function getMailServerUsername(required forLogin="false") output=false {
		if ( !arguments.forLogin || len(variables.instance.mailServerPassword) ) {
			return variables.instance.mailServerUsername;
		} else {
			return "";
		}
	}

	public function setMailServerUsername(String MailServerUsername) output=false {
		setMailServerUsernameEmail(arguments.MailServerUsername);
		variables.instance.mailServerUsername = arguments.MailServerUsername;
		return this;
	}

	public function setCacheCapacity(cacheCapacity) output=false {
		if ( isNumeric(arguments.cacheCapacity) ) {
			variables.instance.cacheCapacity = arguments.cacheCapacity;
		}
		return this;
	}

	public function setCacheFreeMemoryThreshold(cacheFreeMemoryThreshold) output=false {
		if ( isNumeric(arguments.cacheFreeMemoryThreshold) && arguments.cacheFreeMemoryThreshold ) {
			variables.instance.cacheFreeMemoryThreshold = arguments.cacheFreeMemoryThreshold;
		}
		return this;
	}

	public function setSmallImageWidth(required any smallImageWidth="0") output=true {
		if ( isNumeric(arguments.smallImageWidth) && arguments.smallImageWidth || arguments.smallImageWidth == 'AUTO' ) {
			variables.instance.smallImageWidth = arguments.smallImageWidth;
		}
		return this;
	}

	public function setSmallImageHeight(required any smallImageHeight="0") output=true {
		if ( isNumeric(arguments.smallImageHeight) && arguments.smallImageHeight || arguments.smallImageHeight == 'AUTO' ) {
			variables.instance.smallImageHeight = arguments.smallImageHeight;
		}
		return this;
	}

	public function setMediumImageWidth(required any mediumImageWidth="0") output=true {
		if ( isNumeric(arguments.mediumImageWidth) && arguments.mediumImageWidth || arguments.mediumImageWidth == 'AUTO' ) {
			variables.instance.mediumImageWidth = arguments.mediumImageWidth;
		}
		return this;
	}

	public function setMediumImageHeight(required any mediumImageHeight="0") output=true {
		if ( isNumeric(arguments.mediumImageHeight) && arguments.mediumImageHeight || arguments.mediumImageHeight == 'AUTO' ) {
			variables.instance.mediumImageHeight = arguments.mediumImageHeight;
		}
		return this;
	}

	public function setLargeImageWidth(required any largeImageWidth="0") output=true {
		if ( isNumeric(arguments.largeImageWidth) &&  arguments.largeImageWidth || arguments.largeImageWidth == 'AUTO' ) {
			variables.instance.largeImageWidth = arguments.largeImageWidth;
		}
		return this;
	}

	public function setLargeImageHeight(required any largeImageHeight="0") output=true {
		if ( isNumeric(arguments.largeImageHeight) &&  arguments.largeImageHeight || arguments.largeImageHeight == 'AUTO' ) {
			variables.instance.largeImageHeight = arguments.largeImageHeight;
		}
		return this;
	}

	/**
	 * for legacy compatability
	 */
	public function getGallerySmallScale() output=false {
		return variables.instance.smallImageWidth;
	}

	/**
	 * for legacy compatability
	 */
	public function getGalleryMediumScale() output=false {
		return variables.instance.mediumImageWidth;
	}

	/**
	 * for legacy compatability
	 */
	public function getGalleryMainScale() output=false {
		return variables.instance.largeImageWidth;
	}

	public function getLoginURL(parseMuraTag="true") output=false {
		if ( variables.instance.loginURL != '' ) {
			if ( arguments.parseMuraTag ) {
				return getContentRenderer().setDynamicContent(variables.instance.LoginURL);
			} else {
				return variables.instance.LoginURL;
			}
		} else {
			return "#variables.configBean.getIndexFile()#?display=login";
		}
	}

	public function getEditProfileURL(parseMuraTag="true") output=false {
		if ( variables.instance.EditProfileURL != '' ) {
			if ( arguments.parseMuraTag ) {
				return getContentRenderer().setDynamicContent(variables.instance.EditProfileURL);
			} else {
				return variables.instance.EditProfileURL;
			}
		} else {
			return "#variables.configBean.getIndexFile()#?display=editProfile";
		}
	}

	public function setLastDeployment(String LastDeployment) output=false {
		variables.instance.LastDeployment = parseDateArg(arguments.LastDeployment);
		return this;
	}

	public function setHasComments(hasComments) output=false {
		if ( isNumeric(arguments.hasComments) ) {
			variables.instance.hasComments = arguments.hasComments;
		}
		return this;
	}

	public function setUseDefaultSMTPServer(UseDefaultSMTPServer) output=false {
		if ( isNumeric(arguments.UseDefaultSMTPServer) ) {
			variables.instance.UseDefaultSMTPServer = arguments.UseDefaultSMTPServer;
		}
		return this;
	}

	public function setMailServerSMTPPort(String MailServerSMTPPort) output=false {
		if ( isNumeric(arguments.MailServerSMTPPort) ) {
			variables.instance.mailServerSMTPPort = arguments.MailServerSMTPPort;
		}
		return this;
	}

	public function setMailServerPOPPort(String MailServerPOPPort) output=false {
		if ( isNumeric(arguments.MailServerPOPPort) ) {
			variables.instance.mailServerPOPPort = arguments.MailServerPOPPort;
		}
		return this;
	}

	public function setMailServerTLS(String mailServerTLS) output=false {
		if ( isBoolean(arguments.mailServerTLS) ) {
			variables.instance.mailServerTLS = arguments.mailServerTLS;
		}
		return this;
	}

	public function setMailServerSSL(String mailServerSSL) output=false {
		if ( isBoolean(arguments.mailServerSSL) ) {
			variables.instance.mailServerSSL = arguments.mailServerSSL;
		}
		return this;
	}

	public function getCacheFactory(name="output") output=false {
		if ( !isDefined("arguments.name") ) {
			arguments.name="output";
		}
		if ( !isDefined("variables.instance.cacheFactories") ) {
			variables.instance.cacheFactories=structNew();
		}
		if ( structKeyExists(variables.instance.cacheFactories,arguments.name) ) {
			return variables.instance.cacheFactories["#arguments.name#"];
		} else {
			// if not variables.instance.cacheCapacity
			variables.instance.cacheFactories["#arguments.name#"]=getBean("settingsManager").createCacheFactory(freeMemoryThreshold=variables.instance.cacheFreeMemoryThreshold,name=arguments.name,siteID=variables.instance.siteID);
			/*
			}
				variables.instance.cacheFactories["#arguments.name#"]=getBean("settingsManager").createCacheFactory(capacity=variables.instance.cacheCapacity,freeMemoryThreshold=variables.instance.cacheFreeMemoryThreshold,name=arguments.name,siteID=variables.instance.siteID);
			}
		*/
			return variables.instance.cacheFactories["#arguments.name#"];
		}
	}

	public function purgeCache(name="output", broadcast="true") output=false {
		getCacheFactory(name=arguments.name).purgeAll();
		if ( arguments.broadcast ) {
			getBean("clusterManager").purgeCache(siteID=variables.instance.siteID,name=arguments.name);
		}
		return this;
	}

	public function getJavaLocale() output=false {
		if ( len(variables.instance.siteLocale) ) {
			variables.instance.javaLocale=application.rbFactory.CF2Java(variables.instance.siteLocale);
		} else {
			variables.instance.javaLocale=application.rbFactory.CF2Java(variables.configBean.getDefaultLocale());
		}
		return variables.instance.javaLocale;
	}

	public function getRBFactory() output=false {
		if (!isObject(variables.instance.rbFactory)) {

			if(isDefined('request.muraBaseRBFactory') && isObject(request.muraBaseRBFactory)){
					var tmpFactory = request.muraBaseRBFactory;
			} else {
				//Get core admin RB factory
				if (!isDefined('application.rbFactory') ) {
					variables.tracepoint = initTracepoint("Instantiating resourceBundleFactory");
					application.rbFactory = new mura.resourceBundle.resourceBundleFactory();
					commitTracepoint(variables.tracepoint);
				}

				var tmpFactory = application.rbFactory;

				//Get core v1 module RB factory
				var dirCoreV1 = '/muraWRM/core/modules/v1/core_assets/resource_bundles/';
				if ( directoryExists(expandPath('/muraWRM/core/modules/v1/core_assets/resource_bundles/')) ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,expandPath("/muraWRM/core/modules/v1/core_assets/resource_bundles/"),getJavaLocale());
				}

				//Get global level RB factory
				if ( directoryExists(expandPath('/muraWRM/resourceBundles/')) ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,expandPath("/muraWRM/resourceBundles/"),getJavaLocale());
				} else if ( directoryExists(expandPath('/muraWRM/resource_bundles/')) ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,expandPath("/muraWRM/resource_bundles/"),getJavaLocale());
				}
			}

			if(!get('isNew')){
				//Get site level RB factory
				if ( directoryExists('#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/resourceBundles/') ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,"#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/resourceBundles/",getJavaLocale());
				} else if ( directoryExists('#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/resource_bundles/') ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,"#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/resource_bundles/",getJavaLocale());
				} else if ( directoryExists('#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/includes/resourceBundles/') ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,"#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/includes/resourceBundles/",getJavaLocale());
				} else if ( directoryExists('#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/includes/resource_bundles/') ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,"#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/includes/resource_bundles/",getJavaLocale());
				}

				//Get theme level RB factory
				var themeRBDir1=expandPath(getThemeIncludePath()) & "/resourceBundles/";
				var themeRBDir2=expandPath(getThemeIncludePath()) & "/resource_bundles/";

				if ( directoryExists(themeRBDir1) ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,themeRBDir1,getJavaLocale());
				} else if ( directoryExists(themeRBDir2) ) {
					tmpFactory = createObject("component","mura.resourceBundle.resourceBundleFactory").init(tmpFactory,themeRBDir2,getJavaLocale());
				}

				variables.instance.rbFactory = tmpFactory;
				//writeDump(getKey("layout.contentmanager"));abort;
				//Additional module level RB factories will be added when discovering modules
			} else {
				variables.instance.rbFactory = tmpFactory;
			}

		}
		return variables.instance.rbFactory;
	}

	public function setRBFactory(rbFactory) output=false {
		if ( isObject(arguments.rbFactory) ) {
			variables.instance.rbFactory=arguments.rbFactory;
		}
		return this;
	}

	public function getJSDateKey() output=false {
		if ( !len(variables.instance.jsDateKey) ) {
			variables.instance.jsDateKey=getLocaleUtils().getJSDateKey();
		}
		return variables.instance.jsDateKey;
	}

	public function getJSDateKeyObjInc() output=false {
		if ( !len(variables.instance.jsDateKeyObjInc) ) {
			variables.instance.jsDateKeyObjInc=getLocaleUtils().getJsDateKeyObjInc();
		}
		return variables.instance.jsDateKeyObjInc;
	}

	public function getLocaleUtils() output=false {
		return getRBFactory().getUtils();
	}

	public function getAssetPath(complete="0", domain="#getValue('domain')#") output=false {
		return getResourcePath(argumentCollection=arguments) & "#variables.configBean.getSiteAssetPath()#/#variables.instance.displayPoolID#";
	}

	public function getSiteAssetPath(complete="0", domain="#getValue('domain')#") output=false {
		return getAssetPath(argumentCollection=arguments);
	}

	public function getFileAssetPath(complete="0", domain="#getValue('domain')#") output=false {
		if(len(variables.configBean.getValue('fileAssetPath'))){
			return variables.configBean.getValue('fileAssetPath')  & "/" & variables.instance.filepoolID;
		} else {
			return getResourcePath(argumentCollection=arguments) & "#variables.configBean.getSiteAssetPath()#/#variables.instance.filepoolID#";
		}
	}

	public function getFileDir() output=false {
		return variables.configBean.getFileDir()  & variables.configBean.getFileDelim() & variables.instance.filepoolID;
	}

	public function getAssetDir() output=false {
		return variables.configBean.getAssetDir()  & variables.configBean.getFileDelim() & variables.instance.filepoolID;
	}

	public function getIncludePath() output=false {
		return "#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#";
	}

	public function getAssetMap() output=false {
		return "#variables.configBean.getSiteMap()#.#variables.instance.displayPoolID#";
	}

	public function getDisplayObjectAssetPath(theme="#request.altTheme#", complete="0", domain="#getValue('domain')#") output=false {
		var key="displayObjectAssetPath" & YesNoFormat(arguments.complete) & replace(arguments.domain,".","all");
		if ( structKeyExists(variables.instance,'#key#') ) {
			return variables.instance[key];
		} else {
			var path="";
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/modules');
			if ( directoryExists(path) ) {
				variables.instance[key]=getAssetPath(argumentCollection=arguments) & "/modules";
				return variables.instance[key];
			}
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/display_objects');
			if ( directoryExists(path) ) {
				variables.instance[key]=getAssetPath(argumentCollection=arguments) & "/display_objects";
				return variables.instance[key];
			}
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/includes/modules');
			if ( directoryExists(path) ) {
				variables.instance[key]=getAssetPath(argumentCollection=arguments) & "/includes/modules";
				return variables.instance[key];
			}
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/includes/display_objects');
			if ( directoryExists(path) ) {
				variables.instance[key]=getAssetPath(argumentCollection=arguments) & "/includes/display_objects";
				return variables.instance[key];
			}
			path=expandPath('muraWRM/modules');
			if ( directoryExists(path) ) {
				variables.instance[key]=variables.configBean.getRootPath(argumentCollection=arguments) & "/modules";
				return variables.instance[key];
			}
			path=expandPath('muraWRM/display_objects');
			if ( directoryExists(path) ) {
				variables.instance[key]=variables.configBean.getRootPath(argumentCollection=arguments) & "/display_objects";
				return variables.instance[key];
			}
			path=expandPath('muraWRM/core/modules/v1');
			if ( directoryExists(path) ) {
				variables.instance[key]=variables.configBean.getRootPath(argumentCollection=arguments) & "/core/modules/v1";
				return variables.instance[key];
			}
			variables.instance[key]=getThemeAssetPath(argumentCollection=arguments) & "/core/modules/v1";
			return variables.instance[key];
		}
	}

	public function getThemeAssetPath(theme="#request.altTheme#", complete="0", domain="#getValue('domain')#") output=false {
		if ( !len(arguments.theme) || !directoryExists(getTemplateIncludeDir(arguments.theme)) ) {
			arguments.theme=variables.instance.theme;
		}
		var key="themeAssetPath" & YesNoFormat(arguments.complete) & replace(arguments.domain,".","all");
		if ( !structKeyExists(variables.instance.themeLookup,'#arguments.theme#') ) {
			variables.instance.themeLookup['#arguments.theme#']={};
		}
		if ( structKeyExists(variables.instance.themeLookup['#arguments.theme#'],'#key#') ) {
			return variables.instance.themeLookup['#arguments.theme#'][key];
		} else {
			var path="";
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'][key]=getAssetPath(argumentCollection=arguments) & "/themes/#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'][key];
			}
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/includes/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'][key]=getAssetPath(argumentCollection=arguments) & "/includes/themes/#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'][key];
			}
			path=expandPath('/#variables.configBean.getWebRootMap()#/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'][key]=getResourcePath(argumentCollection=arguments) & "/themes/#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'][key];
			}
			variables.instance.themeLookup['#arguments.theme#'][key]=getAssetPath(argumentCollection=arguments);
			return variables.instance.themeLookup['#arguments.theme#'][key];
		}
	}

	public function getThemeIncludePath(theme="#request.altTheme#") output=false {
		if ( !len(arguments.theme) ) {
			arguments.theme=variables.instance.theme;
		}
		if ( !structKeyExists(variables.instance.themeLookup,'#arguments.theme#') ) {
			variables.instance.themeLookup['#arguments.theme#']={};
		}
		if ( structKeyExists(variables.instance.themeLookup['#arguments.theme#'],'themeIncludePath') ) {
			return variables.instance.themeLookup['#arguments.theme#'].themeIncludePath;
		} else {
			var path="";
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'].themeIncludePath="#getIncludePath()#/themes/#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'].themeIncludePath;
			}
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/includes/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'].themeIncludePath="#getIncludePath()#/includes/themes/#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'].themeIncludePath;
			}
			path=expandPath('/#variables.configBean.getWebRootMap()#/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'].themeIncludePath="/muraWRM/themes/#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'].themeIncludePath;
			}
			variables.instance.themeLookup['#arguments.theme#'].themeIncludePath=getIncludePath();
			return variables.instance.themeLookup['#arguments.theme#'].themeIncludePath;
		}
	}

	public function getThemeAssetMap(theme="#request.altTheme#") output=false {
		if ( !len(arguments.theme) || !directoryExists(getTemplateIncludeDir(arguments.theme)) ) {
			arguments.theme=variables.instance.theme;
		}
		if ( !structKeyExists(variables.instance.themeLookup,'#arguments.theme#') ) {
			variables.instance.themeLookup['#arguments.theme#']={};
		}
		if ( structKeyExists(variables.instance.themeLookup['#arguments.theme#'],'themeAssetMap') ) {
			return variables.instance.themeLookup['#arguments.theme#'].themeAssetMap;
		} else {
			var path="";
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'].themeAssetMap="#getAssetMap()#.themes.#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'].themeAssetMap;
			}
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/includes/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'].themeAssetMap="#getAssetMap()#.includes.themes.#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'].themeAssetMap;
			}
			path=expandPath('/#variables.configBean.getWebRootMap()#/themes/#arguments.theme#');
			if ( directoryExists(path) ) {
				variables.instance.themeLookup['#arguments.theme#'].themeAssetMap="muraWRM.themes.#arguments.theme#";
				return variables.instance.themeLookup['#arguments.theme#'].themeAssetMap;
			}
			variables.instance.themeLookup['#arguments.theme#'].themeAssetMap=getAssetMap();
			return variables.instance.themeLookup['#arguments.theme#'].themeAssetMap;
		}
	}

	public function getTemplateIncludePath(theme="#request.altTheme#") output=false {
		if ( !len(arguments.theme) || !directoryExists(getTemplateIncludeDir(arguments.theme)) ) {
			arguments.theme=variables.instance.theme;
		}
		return getThemeIncludePath(arguments.theme) & "/templates";
	}

	public function hasNonThemeTemplates() output=false {
		return directoryExists(expandPath("#getIncludePath()#/includes/templates"));
	}

	public function getTemplateIncludeDir(theme="#request.altTheme#") output=false {
		return expandPath(getThemeIncludePath(arguments.theme) & "/templates");
	}

	public function getThemeDir(theme="#request.altTheme#") output=false {
		if ( !len(arguments.theme) ) {
			arguments.theme=variables.instance.theme;
		}
		if ( !structKeyExists(variables.instance.themeLookup,'#arguments.theme#') ) {
			variables.instance.themeLookup['#arguments.theme#']={};
		}
		if ( structKeyExists(variables.instance.themeLookup['#arguments.theme#'],'themeDir') ) {
			return variables.instance.themeLookup['#arguments.theme#'].themeDir;
		} else {
			var path="";
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/themes/#arguments.theme#');
			if ( directoryExists(path & "/templates") ) {
				variables.instance.themeLookup['#arguments.theme#'].themeDir=path;
				return path;
			}
			path=expandPath('#variables.configBean.getSiteIncludePath()#/#variables.instance.displayPoolID#/includes/themes/#arguments.theme#');
			if ( directoryExists(path & "/templates") ) {
				variables.instance.themeLookup['#arguments.theme#'].themeDir=path;
				return path;
			}
			path=expandPath('/#variables.configBean.getWebRootMap()#/themes/#arguments.theme#');
			if ( directoryExists(path & "/templates") ) {
				variables.instance.themeLookup['#arguments.theme#'].themeDir=path;
				return path;
			}
			variables.instance.themeLookup['#arguments.theme#'].themeDir= "#expandPath('/#variables.configBean.getWebRootMap()#')#/#variables.instance.displayPoolID#/";
			return variables.instance.themeLookup['#arguments.theme#'].themeDir;
		}
	}

	public function getThemes() output=false {
		var rs = queryNew("empty");
		var themeDir="";
		var rsDirs="";
		var rs="";
		var qs="";
		var sql="";

		if ( len(variables.instance.displayPoolID) ) {

			themeDir="#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/themes";
			if ( directoryExists(themeDir) ) {
				rsDirs=getBean('fileWriter').getDirectoryList(directory=themeDir, type='dir');
				qs=getQueryService();
				qs.setAttributes(rsDirs=rsDirs);
				qs.setDbType('query');
				if(isQuery(rs)){
					qs.setAttributes(rs=rs);
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
						union
						select * from rs
					").getResult();
				}else {
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
					").getResult();
				}
			}
			themeDir="#variables.configBean.getSiteDir()#/#variables.instance.displayPoolID#/includes/themes";
			if ( directoryExists(themeDir) ) {
				rsDirs=getBean('fileWriter').getDirectoryList(directory=themeDir, type='dir');
				qs=getQueryService();
				qs.setAttributes(rsDirs=rsDirs);
				qs.setDbType('query');
				if(isQuery(rs)){
					qs.setAttributes(rs=rs);
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
						union
						select * from rs
					").getResult();
				}else {
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
					").getResult();
				}
			}

			themeDir="#expandPath('/#variables.configBean.getWebRootMap()#')#/themes";

			if ( directoryExists(themeDir) ) {
				rsDirs=getBean('fileWriter').getDirectoryList(directory=themeDir, type='dir');
				qs=getQueryService();
				qs.setAttributes(rsDirs=rsDirs);
				qs.setDbType('query');
				if(isQuery(rs)){
					qs.setAttributes(rs=rs);
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
						union
						select * from rs
					").getResult();
				}else {
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
					").getResult();
				}
			}
		} else {
			themeDir="#variables.configBean.getSiteDir()#/default/themes";
			if ( directoryExists(themeDir) ) {
				rsDirs=getBean('fileWriter').getDirectoryList(directory=themeDir, type='dir');
				qs=getQueryService();
				qs.setAttributes(rsDirs=rsDirs);
				qs.setDbType('query');
				if(isQuery(rs)){
					qs.setAttributes(rs=rs);
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
						union
						select * from rs
					").getResult();
				}else {
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
					").getResult();
				}
			}
			themeDir="#variables.configBean.getSiteDir()#/default/includes/themes";
			if ( directoryExists(themeDir) ) {
				rsDirs=getBean('fileWriter').getDirectoryList(directory=themeDir, type='dir');
				qs=getQueryService();
				qs.setAttributes(rsDirs=rsDirs);
				qs.setDbType('query');
				if(isQuery(rs)){
					qs.setAttributes(rs=rs);
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
						union
						select * from rs
					").getResult();
				}else {
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
					").getResult();
				}
			}
			themeDir="#expandPath('/#variables.configBean.getWebRootMap()#')#/themes";

			if ( directoryExists(themeDir) ) {
				rsDirs=getBean('fileWriter').getDirectoryList(directory=themeDir, type='dir');
				qs=getQueryService();
				qs.setAttributes(rsDirs=rsDirs);
				qs.setDbType('query');
				if(isQuery(rs)){
					qs.setAttributes(rs=rs);
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
						union
						select * from rs
					").getResult();
				}else {
					rs=qs.execute(sql="
						select * from rsDirs where type='Dir' and name not like '%.svn'
					").getResult();
				}
			}
		}

		if(!isQuery(rs)){
			rs=queryNew("empty");
		}

		return rs;
	}

	public function getTemplates(required type="") output=false {
		var rs = "";
		var dir="";
		var qs="";
		switch ( arguments.type ) {
			case  "Component":
			case  "Email":
				dir="#getTemplateIncludeDir()#/#lcase(arguments.type)#s";
				if ( directoryExists(dir) ) {
					rs=getBean('fileWriter').getDirectoryList( filter="*.cfm|*.html|*.htm|*.hbs", directory=dir );
					qs=getQueryService();
					qs.setAttributes(rs=rs);
					qs.setDbType('query');
					rs=qs.execute(sql="
						select * from rs order by name
					").getResult();
				} else {
					rs=queryNew("empty");
				}
				break;
			default:
				if(directoryExists(getTemplateIncludeDir())){
					rs=getBean('fileWriter').getDirectoryList( filter="*.cfm|*.html|*.htm|*.hbs", directory=getTemplateIncludeDir() );
					qs=getQueryService();
					qs.setAttributes(rs=rs);
					qs.setDbType('query');
					rs=qs.execute(sql="
						select * from rs order by name
					").getResult();
				} else {
					rs=queryNew("empty");
				}
				break;
		}
		return rs;
	}

	public function getLayouts(required type="collection/layouts") output=false {
		param name="variables.instance.collectionLayouts" default="";
		if ( !isQuery(variables.instance.collectionLayouts) ) {
			var rsFinal = queryNew('name','varchar');
			var rs = queryNew('name','varchar');
			var qs = "";
			var dir = "";

			for ( dir in variables.instance.displayObjectLookUpArray ) {
				dir=expandPath('#dir##trim(arguments.type)#');
				if ( directoryExists(dir) ) {
					rs=getBean('fileWriter').getDirectoryList( directory=dir ,type='dir');
					if ( rs.recordcount ) {
						qs=getQueryService();
						qs.setAttributes(rs=rs);
						qs.setAttributes(rsFinal=rsFinal);
						qs.setDbType('query');
						rsFinal=qs.execute(sql="
						select name from rsFinal
						union
						select name from rs
						").getResult();
					}
				}
			}

			var externalLayoutArray=getContentRenderer().collectionLayoutArray;

			if(arrayLen(externalLayoutArray)){
				var existingLookup={};
				for(var i=1;i<=rsFinal.recordcount;i++){
					existingLookup[rsFinal.name[i]]=true;
				}

				for(var l in externalLayoutArray){
					if(!structKeyExists(existingLookup,l)){
						queryAddRow(rsFinal,{name=l});
					}
				}
			}

			qs=getQueryService();
			qs.setAttributes(rsFinal=rsFinal);
			qs.setDbType('query');
			rsFinal=qs.execute(sql="
			select distinct name from rsFinal
			order by name asc
			").getResult();
			variables.instance.collectionLayouts=rsFinal;
		}
		return variables.instance.collectionLayouts;
	}

	public boolean function isValidDomain(domain, required mode="either", enforcePrimaryDomain="false") output=false {
		var i="";
		var lineBreak=chr(13)&chr(10);
		if ( arguments.enforcePrimaryDomain && variables.instance.enforcePrimaryDomain ) {
			if ( arguments.domain == getDomain() ) {
				return true;
			}
		} else {
			if ( arguments.mode != "partial" ) {
				if ( arguments.domain == getDomain() ) {
					return true;
				} else if ( len(variables.instance.domainAlias) ) {
					for(i in ListToArray(variables.instance.domainAlias, lineBreak)){
						if(arguments.domain eq i){
							return true;
						}
					}
				}
			}
			if ( arguments.mode != "complete" ) {
				if ( find(arguments.domain,getDomain()) ) {
					return true;
				} else if ( len(variables.instance.domainAlias) ) {
					for(i in ListToArray(variables.instance.domainAlias, lineBreak)){
						if(find(arguments.domain,i)){
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	public function getLocalHandler() output=false {
		var localHandler="";
		if ( fileExists(application.configBean.getSiteDir() & "/#getValue('siteid')#/eventHandler.cfc") ) {
			localHandler=createObject("component","#application.configBean.getSiteMap()#.#getValue('siteid')#.eventHandler").init();
			localHandler.setValue("_objectName","#application.configBean.getSiteMap()#.#getValue('siteid')#.eventHandler");
		} else if ( fileExists(application.configBean.getSiteDir() & "/#getValue('siteid')#/includes/eventHandler.cfc") ){
			localHandler=createObject("component","#application.configBean.getSiteMap()#.#getValue('siteid')#.includes.eventHandler").init();
			localHandler.setValue("_objectName","#application.configBean.getSiteMap()#.#getValue('siteid')#.includes.eventHandler");
		} else if ( getValue('displaypoolid') != getValue('siteid') && fileExists(application.configBean.getSiteDir()  & "/#getValue('displaypoolid')#/eventHandler.cfc") ) {
				localHandler=createObject("component","#application.configBean.getSiteMap()#.#getValue('displaypoolid')#.eventHandler").init();
				localHandler.setValue("_objectName","#application.configBean.getWebRootMap()#.#getValue('displaypoolid')#.eventHandler");
		} else if ( getValue('displaypoolid') != getValue('siteid') && fileExists(application.configBean.getSiteDir()  & "/#getValue('displaypoolid')#/includes/eventHandler.cfc") ) {
			localHandler=createObject("component","#application.configBean.getSiteMap()#.#getValue('displaypoolid')#.includes.eventHandler").init();
			localHandler.setValue("_objectName","#application.configBean.getSiteMap()#.#getValue('displaypoolid')#.includes.eventHandler");
		}
		return localHandler;
	}

	public function getContentRenderer($="") output=false {
		if ( !isObject(variables.instance.contentRenderer) ) {
			arguments.$=getBean("$").init(getValue('siteid'));
			variables.instance.contentRenderer=arguments.$.getContentRenderer(force=true);
		}
		return variables.instance.contentRenderer;
	}

	public function getApi(type="json", version="v1") output=false {
		if ( !isDefined('variables.instance.api#arguments.type##arguments.version#') ) {
			variables.instance['api#arguments.type##arguments.version#']=evaluate('new mura.client.api.#arguments.type#.#arguments.version#.apiUtility(siteid=getValue("siteid"))');
		}
		return variables.instance['api#arguments.type##arguments.version#'];
	}

	/**
	 * deprecated: use getContentRenderer()
	 */
	public function getThemeRenderer() output=false {
		return getContentRenderer();
	}

	public function exportHTML(exportDir="") output=false {
		if ( len(arguments.exportdir) ) {
			getBean("HTMLExporter").export(variables.instance.siteID,arguments.exportDir);
		} else {
			getBean("HTMLExporter").export(variables.instance.siteID,variables.instance.exportLocation);
		}
	}

	public function save() output=false {
		setAllValues(application.settingsManager.save(this).getAllValues());
		return this;
	}

	public function getCustomImageSizeQuery(reset="false") output=false {
		var rsCustomImageSizeQuery="";
		var qs=getQueryService(readOnly=true);
		qs.addParam(name="siteid", cfsqltype="cf_sql_varchar", value=variables.instance.siteid );
		rsCustomImageSizeQuery=qs.execute(sql="
		select sizeid,siteid,name,height,width from timagesizes where siteID= :siteid
		").getResult();
		return rsCustomImageSizeQuery;
	}

	public function getCustomImageSizeIterator() output=false {
		return getBean("imageSizeIterator").setQuery(getCustomImageSizeQuery());
	}

	public function loadBy() output=false {
		if ( !structKeyExists(arguments,"siteID") ) {
			arguments.siteID=variables.instance.siteID;
		}
		arguments.settingsBean=this;
		return application.settingsManager.read(argumentCollection=arguments);
	}

	public function getScheme(secure=false) output=false {
		return (arguments.secure || YesNoFormat(getValue('useSSL'))  || getBean('utility').isHTTPS()) ? 'https' : 'http';
	}

	public function getProtocol(secure=false) output=false {
		return UCase(getScheme(arguments.secure));
	}

	public function getRazunaSettings() output=false {
		if ( !structKeyExists(variables,'razunaSettings') ) {
			variables.razunaSettings=getBean('razunaSettings').loadBy(siteid=getValue('siteid'));
		}
		return variables.razunaSettings;
	}

	public function getContentPoolID() output=false {
		if ( !listFindNoCase(variables.instance.contentPoolID,getValue('siteid')) ) {
			//variables.instance.contentPoolID=listAppend(arguments.contentPoolID,getValue('siteid'));
		}
		return variables.instance.contentPoolID;
	}

	public function getHasSharedFilePool() output=false {
		if ( !isBoolean(variables.instance.hasSharedFilePool) ) {
			if ( getValue('siteid') != getValue('filePoolID') ) {
				variables.instance.hasSharedFilePool=true;
			} else {
				var rs="";
				var qs=getQueryService(readOnly=true);
				qs.addParam(name="siteid", cfsqltype="cf_sql_varchar", value=getValue('siteid'));
				qs.addParam(name="filepoolid", cfsqltype="cf_sql_varchar", value=getValue('siteid'));
				variables.instance.hasSharedFilePool=qs.execute(sql="select count(*) as counter from tsettings
				where filePoolID= :filePoolID and siteid!= :siteid").getResult().counter;
			}
		}
		return variables.instance.hasSharedFilePool;
	}

	public function setHasLockableNodes(String hasLockableNodes) output=false {
		if ( isNumeric(arguments.hasLockableNodes) ) {
			variables.instance.hasLockableNodes = arguments.hasLockableNodes;
		}
		return this;
	}

	public function setJSONApi(String JSONApi) output=false {
		if ( isNumeric(arguments.JSONApi) ) {
			variables.instance.JSONApi = arguments.JSONApi;
		}
		return this;
	}

	public function setIsRemote(String isRemote) output=false {
		if ( isNumeric(arguments.isRemote) ) {
			variables.instance.isRemote = arguments.isRemote;
		}
		return this;
	}

	public function setResourceSSL(String resourceSSL) output=false {
		if ( isNumeric(arguments.resourceSSL) ) {
			variables.instance.resourceSSL = arguments.resourceSSL;
		}
		return this;
	}

	public function setRemotePort(String RemotePort) output=false {
		if ( isNumeric(arguments.RemotePort) ) {
			variables.instance.RemotePort = arguments.RemotePort;
		}
		return this;
	}

	public function setUseSSL(useSSL) output=false {
		if ( isBoolean(arguments.useSSL) ) {
			if ( arguments.useSSL ) {
				variables.instance.useSSL=1;
				variables.instance.extranetSSL=1;
			} else {
				variables.instance.useSSL=0;
				variables.instance.extranetSSL=0;
			}
		}
		return this;
	}

	public function setShowDashboard(showDashboard) output=false {
		if ( isBoolean(arguments.showDashboard) ) {
			if ( arguments.showDashboard ) {
				variables.instance.showDashboard=1;
			} else {
				variables.instance.showDashboard=0;
			}
		}
		return this;
	}

	public function getContext() output=false {
		if ( getValue('isRemote') ) {
			return getValue('RemoteContext');
		} else {
			return application.configBean.getContext();
		}
	}

	public function getServerPort() output=false {
		if ( getValue('isRemote') ) {
			var port=getValue('RemotePort');
			if ( isNumeric(port) && !ListFind('80,443', port) ) {
				return ":" & port;
			} else {
				return "";
			}
		} else {
			return application.configBean.getServerPort();
		}
	}

	public function getAdminPath(useProtocol="1",complete="0",domain="",secure="#getValue('useSSL')#") output=false {
		if(len(application.configBean.getAdminDomain())){
			arguments.domain=application.configBean.getAdminDomain();
			arguments.complete=1;
		}
		if(!(getValue('isRemote') && len(getValue('resourceDomain'))) && len(application.configBean.getAdminDomain())){
			arguments.useProtocol=1;
			arguments.complete=1;
			return application.configBean.getAdminPath(argumentCollection=arguments);
		} else {
			if(application.configBean.getAdminSSL()){
				arguments.useProtocol=1;
				arguments.complete=1;
			}
			return getResourcePath(argumentCollection=arguments) & application.configBean.getAdminDir();
		}

	}

	public function getWebPath(secure="#getValue('useSSL')#", complete="0", domain="", useProtocol="1") output=false {
		if ( arguments.secure || arguments.complete ) {
			if ( len(request.muraPreviewDomain) && isValidDomain(domain=request.muraPreviewDomain,mode='complete') ) {
				arguments.domain=request.muraPreviewDomain;
			}
			if ( !isDefined('arguments.domain') || !len(arguments.domain) ) {
				if(getValue('isRemote') ){
					arguments.domain=getValue('domain');
				} else {
					if ( len(cgi.server_name) && !get('EnforcePrimaryDomain') && isValidDomain(domain=cgi.server_name,mode='complete') ) {
						arguments.domain=cgi.server_name;
					} else {
						arguments.domain=getValue('domain');
					}
				}
			}
			if ( arguments.useProtocol ) {
				if ( arguments.secure ) {
					return 'https://' & arguments.domain & getServerPort() & getContext();
				} else {
					return getScheme(arguments.secure) & '://' & arguments.domain & getServerPort() & getContext();
				}
			} else {
				return '//' & arguments.domain & getServerPort() & getContext();
			}
		} else {
			return getContext();
		}
	}

	public function getEndpoint(secure="#getValue('useSSL')#", complete="0", domain="", useProtocol="1") output=false {
		return getResourcePath(argumentCollection=arguments);
	}

	public function getRootPath(secure="#getValue('useSSL')#", complete="0", domain="", useProtocol="1") output=false {
		return getResourcePath(argumentCollection=arguments);
	}

	public function getResourcePath(complete="0", domain="", useProtocol="1",secure="#getValue('useSSL')#") output=false {

		if ( len(request.muraPreviewDomain) && isValidDomain(domain=request.muraPreviewDomain,mode='complete') ) {
			arguments.domain=request.muraPreviewDomain;
		}
		if ( !isDefined('arguments.domain') || !len(arguments.domain) ) {
			if ( len(cgi.server_name) && !get('EnforcePrimaryDomain') && isValidDomain(domain=cgi.server_name,mode='complete') ) {
				arguments.domain=cgi.server_name;
			} else {
				arguments.domain=getValue('domain');
			}
		}
		if ( getValue('isRemote') && len(getValue('resourceDomain')) ) {
			var configBean=getBean('configBean');
			if ( arguments.useProtocol ) {
				if (getValue('resourceSSL') || getValue('useSSL')  ) {
					return "https://" & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext();
				} else {
					return getScheme(arguments.secure) & '://' & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext();
				}
			} else {
				return "//" & getValue('resourceDomain') & configBean.getServerPort() & configBean.getContext();
			}
		} else if ( arguments.complete ) {
			return getWebPath(argumentCollection=arguments);
		} else {
			return getContext();
		}
	}

	public function getRequirementsPath(secure="#getValue('useSSL')#", complete="0", useProtocol="1") output=false {
		return getResourcePath(argumentCollection=arguments) & "/core/vendor";
	}

	public function getCorePath(secure="#getValue('useSSL')#", complete="0", useProtocol="1") output=false {
		if(!(getValue('isRemote') && len(getValue('resourceDomain'))) && len(application.configBean.getAdminDomain())){
			arguments.complete=1;
			return application.configBean.getCorePath(argumentCollection=arguments);
		} else {
			if(application.configBean.getAdminSSL()){
				arguments.complete=1;
			}
			return getResourcePath(argumentCollection=arguments) & "/core";
		}
	}

	public function getPluginsPath(secure="#getValue('useSSL')#", complete="0", useProtocol="1") output=false {
		if(!(getValue('isRemote') && len(getValue('resourceDomain'))) && len(application.configBean.getAdminDomain())){
			arguments.complete=1;
			return application.configBean.getPluginsPath(argumentCollection=arguments);
		} else {
			if(application.configBean.getAdminSSL()){
				arguments.complete=1;
			}
			return getResourcePath(argumentCollection=arguments) & "/plugins";
		}
	}

	public function getAccessControlOriginDomainList() output=false {
		var thelist=getValue('domain');
		var i="";
		var lineBreak=chr(13)&chr(10);

		if ( len(application.configBean.getAdminDomain()) ) {
			if ( !ListFindNoCase(thelist, application.configBean.getAdminDomain()) ) {
				thelist = listAppend(thelist,application.configBean.getAdminDomain());
			}
		}

		if ( getValue("isRemote") && len(getValue("resourceDomain")) ) {
			if ( !ListFindNoCase(thelist, getValue("resourceDomain")) ) {
				thelist = listAppend(thelist,getValue("resourceDomain"));
			}
		}

		if ( len(getValue('domainAlias')) ) {
			for(i in listToArray(getValue('domainAlias'),lineBreak) ){
				if ( !ListFindNoCase(thelist, i ) ) {
					thelist = listAppend(thelist,i);
				}
			}
		}
		return thelist;
	}

	//This is no longer used
	public function getAccessControlOriginList() output=false {
		var thelist="http://#getValue('domain')#,https://#getValue('domain')#";
		var adminSSL=application.configBean.getAdminSSL();
		var i="";
		var lineBreak=chr(13)&chr(10);
		var theurl = "#getValue('domain')##application.configBean.getServerPort()#";
		if ( !ListFindNoCase(thelist, 'http://#theurl#') ) {
			thelist = listAppend(thelist,'http://#theurl#');
		}
		if ( !ListFindNoCase(thelist, 'https://#theurl#') ) {
			thelist = listAppend(thelist,'https://#theurl#');
		}
		theurl = "#getValue('domain')#:#cgi.server_port#";
		if ( !ListFindNoCase(thelist, 'http://#theurl#') ) {
			thelist = listAppend(thelist,'http://#theurl#');
		}
		if ( !ListFindNoCase(thelist, 'https://#theurl#') ) {
			thelist = listAppend(thelist,'https://#theurl#');
		}
		if ( len(application.configBean.getAdminDomain()) ) {
			theurl="#application.configBean.getAdminDomain()#";
			if ( !ListFindNoCase(thelist, 'http://#theurl#') ) {
				thelist = listAppend(thelist,theurl);
			}
			if ( !ListFindNoCase(thelist, 'https://#theurl#') ) {
				thelist = listAppend(thelist,theurl);
			}
			theurl="#application.configBean.getAdminDomain()##application.configBean.getServerPort()#";
			if ( !ListFindNoCase(thelist, 'http://#theurl#') ) {
				thelist = listAppend(thelist,theurl);
			}
			if ( !ListFindNoCase(thelist, 'https://#theurl#') ) {
				thelist = listAppend(thelist,theurl);
			}
			theurl="#application.configBean.getAdminDomain()#:#cgi.server_port#";
			if ( !ListFindNoCase(thelist, 'http://#theurl#') ) {
				thelist = listAppend(thelist,theurl);
			}
			if ( !ListFindNoCase(thelist, 'https://#theurl#') ) {
				thelist = listAppend(thelist,theurl);
			}
		}
		if ( len(getValue('domainAlias')) ) {
			for(i in listToArray(getValue('domainAlias'),lineBreak)){
				theurl = "#i##getServerPort()#";
				if ( !ListFindNoCase(thelist, 'http://#theurl#') ) {
					thelist = listAppend(thelist,"http://#theurl#");
				}
				if ( !ListFindNoCase(thelist, 'https://#theurl#') ) {
					thelist = listAppend(thelist,"https://#theurl#");
				}
				theurl = "#i#:#cgi.server_port#";
				if ( !ListFindNoCase(thelist, 'http://#theurl#') ) {
					thelist = listAppend(thelist,"http://#theurl#");
				}
				if ( !ListFindNoCase(thelist, 'https://#theurl#') ) {
					thelist = listAppend(thelist,"https://#theurl#");
				}
			}
		}
		return thelist;
	}

	public function getVersion() output=false {
		return getBean('configBean').getVersion();
	}

	public function registerDisplayObject(object, name="", displaymethod="", displayObjectFile="", configuratorInit="", configuratorJS="", contenttypes="", omitcontenttypes="", condition="true", legacyObjectFile="", custom="true", iconclass="mi-cog", cacheoutput="true", external="false" ,configurator="") output=false {

		if(!structKeyExists(arguments,'condition')){
			arguments.condition=true;
		}
		if(!structKeyExists(arguments,'contenttypes')){
			arguments.contenttypes="";
		}
		if(!structKeyExists(arguments,'omitcontenttypes')){
			arguments.omitcontenttypes='';
		}
		if(!structKeyExists(arguments,'iconclass')){
			arguments.iconclass="mi-cog";
		}
		if(!structKeyExists(arguments,'custom')){
			arguments.custom="mi-cog";
		}
		if(!structKeyExists(arguments,'cacheoutput')){
			arguments.cacheoutput=true;
		}
		//Used with external modules
		if(!structKeyExists(arguments,'external')){
			arguments.external=false;
		}
		if(!structKeyExists(arguments,'configurator')){
			arguments.configurator="";
		}

		arguments.objectid=arguments.object;
		variables.instance.displayObjectLookup['#arguments.object#']=arguments;
		return this;
	}

	public function clearFilePaths() output=false {
		variables.instance.displayObjectFilePathLookup=structNew();
		variables.instance.contentTypeFilePathLookup=structNew();
		variables.instance.htmlQueueFilePathLookup=structNew();
	}

	public function lookupContentTypeFilePath(filePath, customOnly="false") output=false {
		arguments.filePath=REReplace(listFirst(Replace(arguments.filePath, "\", "/", "ALL"),"/"), "[^a-zA-Z0-9_]", "", "ALL") & "/index.cfm";
		if ( len(request.altTheme) ) {
			var altThemePath=getThemeIncludePath(request.altTheme) & "/content_types/" & arguments.filePath;
			if ( fileExists(expandPath(altThemePath)) ) {
				return altThemePath;
			}
		}
		if ( hasContentTypeFilePath(arguments.filePath) ) {
			return getContentTypeFilePath(arguments.filePath);
		}
		var dir="";
		var result="";
		var coreIndex=arrayLen(variables.instance.contentTypeLoopUpArray)-2;
		var dirIndex=0;
		var utility=getBean('utility');
		for ( dir in variables.instance.contentTypeLoopUpArray ) {
			dirIndex=dirIndex+1;
			if ( !arguments.customonly || dirIndex < coreIndex ) {
				result=dir & arguments.filePath;
				if ( fileExists(expandPath(result)) && utility.isPathLegal(result)) {
					setContentTypeFilePath(arguments.filePath,result);
					return result;
				}
			}
		}
		setContentTypeFilePath(arguments.filePath,"");
		return "";
	}

	public function hasContentTypeFilePath(filepath) output=false {
		return structKeyExists(variables.instance.contentTypeFilePathLookup,'#arguments.filepath#');
	}

	public function getContentTypeFilePath(filepath) output=false {
		return variables.instance.contentTypeFilePathLookup['#arguments.filepath#'];
	}

	public function setContentTypeFilePath(filepath, result) output=false {
		variables.instance.contentTypeFilePathLookup['#arguments.filepath#']=arguments.result;
		return this;
	}

	public function discoverGlobalContentTypes(deferred=[]) output=false {
		var lookupArray=[
			'/muraWRM/core/content_types',
			'/muraWRM/content_types'
		];
		var dir="";
		for ( dir in lookupArray ) {
			arguments.deferred=registerContentTypeDir(dir=dir,deferred=arguments.deferred);
		}
		return arguments.deferred;
	}

	public function discoverContentTypes() output=false {
		var lookupArray=[
			getIncludePath()  & "/includes/content_types",
			getIncludePath()  & "/content_types",
			getThemeIncludePath(getValue('theme')) & "/content_types"
		];
		var dir="";
		for ( dir in lookupArray ) {
			registerContentTypeDir(dir=dir);
		}
		var qs=getQueryService(readOnly=true);
		qs.addParam(name="siteid",cfsqltype="cf_sql_varchar",value=getValue('siteid'));

		var rs=qs.execute(sql="
		select tplugins.package
		from tplugins inner join tcontent on tplugins.moduleid = tcontent.contentid
		where tcontent.siteid= :siteid
		and tplugins.deployed=1
		order by tplugins.loadPriority desc
		").getResult();

		if(rs.recordcount){
			for(var row=1;row <= rs.recordcount;row++){
				registerContentTypeDir('/' & rs.package[row] & '/content_types');
			}
		}
		return this;
	}

	public function getContentTypeLookupArray() output=false {
		return variables.instance.contentTypeLoopUpArray;
	}

	public function registerContentTypeDir(dir,package="",deferred=[]) output=false {
		var rs="";
		var config="";
		var expandedDir="";
		var deferredModule={};

		if(reFindNoCase("^[a-zA-Z]:\\",arguments.dir)){
			expandedDir=arguments.dir;
		} else {
			expandedDir=expandPath(arguments.dir);
		}

		if ( directoryExists(expandedDir) ) {
			rs=getBean('fileWriter').getDirectoryList( directory=expandedDir, type="dir");

			if(rs.recordcount){
				for(var row=1;row <= rs.recordcount;row++){
					try{
						if(get('isNew')){
							deferredModule={};
						}
						if ( fileExists('#expandedDir#/#rs.name[row]#/config.xml.cfm') ) {
							config=new mura.executor().execute('#arguments.dir#/#rs.name[row]#/config.xml.cfm');
						} else if ( fileExists('#expandedDir#/#rs.name[row]#/config.xml') ) {
							config=fileRead("#rs.directory[row]#/#rs.name[row]#/config.xml");
						} else {
							config="";
						}
						if ( isXML(config) ) {
							config=parseXML(config);
							if(get('isNew')){
								deferred.config=config;
							} else {
								variables.configBean.getClassExtensionManager().loadConfigXML(config,getValue('siteid'));
							}
						}
						if(directoryExists('#rs.directory[row]#/#rs.name[row]#/model')) {
							if(get('isNew')){
								deferredModule.modelDir="#arguments.dir#/#rs.name[row]#/model";
								deferredModule.package=arguments.package;
							} else {
								variables.configBean.registerBeanDir(dir='#arguments.dir#/#rs.name[row]#/model',siteid=getValue('siteid'),package=arguments.package);
							}
						} else if ( get('isNew') ){
							deferredModule.modelDir="";
							deferredModule.package="";
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/display_objects') ) {
							arguments.deferred=registerDisplayObjectDir(dir='#arguments.dir#/#rs.name[row]#/display_objects',deferred=arguments.deferred);
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/modules') ) {
							arguments.deferred=registerDisplayObjectDir(dir='#arguments.dir#/#rs.name[row]#/modules',conditional=true,deferred=arguments.deferred);
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/content_types') ) {
							arguments.deferred=registerContentTypeDir(dir='#arguments.dir#/#rs.name[row]#/content_types',deferred=arguments.deferred);
						}
						if ( directoryExists('#rs.directory#/#rs.name[row]#/resource_bundles') ) {
							variables.instance.rbFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(getRBFactory(),'#rs.directory[row]#/#rs.name[row]#/resource_bundles',getJavaLocale());
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/resourceBundles') ) {
							variables.instance.rbFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(getRBFactory(),'#rs.directory[row]#/#rs.name[row]#/resourceBundles',getJavaLocale());
						}

						if(get('isNew') && ( isDefined('deferredModule.config') || isDefined('deferredModule.modelDir') ) ){
							arrayAppend(arguments.deferred,duplicate(deferredModule));
						}

					} catch(any e){
						commitTracepoint(initTracepoint("Error Registering Content Type #arguments.package#.#rs.name[row]#, check error log for details"));
						var logData={stacktrace=e.stacktrace};
						if(structKeyExists(e,'message')){
							logData.message=e.message;
						}
						writeLog( text="Error Registering Content Type: #serializeJSON(logData)#", file="exception", type="Error" );

						param name="request.muraDeferredModuleErrors" default=[];
						ArrayAppend(request.muraDeferredModuleErrors,logData);

						if(!isBoolean(variables.configBean.getValue('debuggingenabled')) || variables.configBean.getValue('debuggingenabled')){
							rethrow;
						}
					}
				}
			}

			if ( !listFind('/,\',right(arguments.dir,1)) ) {
				arguments.dir=arguments.dir & getBean('configBean').getFileDelim();
			}
			arrayPrepend(variables.instance.contentTypeLoopUpArray,arguments.dir);
		}
		return arguments.deferred;
	}

	public function registerDisplayObjectDir(dir, conditional="true", package="", custom="true",deferred=[]) output=false {
		var rs="";
		var config="";
		var objectArgs={};
		var o="";
		var tempVal="";
		var objectfound=(arguments.conditional) ? false : true;
		var expandedDir="";
		var utility=getBean('utility');
		var deferredModule={};

		if(reFindNoCase("^[a-zA-Z]:\\",arguments.dir)){
			expandedDir=arguments.dir;
		} else {
			expandedDir=expandPath(arguments.dir);
		}

		if(reFindNoCase("^[a-zA-Z]:\\",arguments.dir)){
			expandedDir=arguments.dir;
		} else {
			expandedDir=expandPath(arguments.dir);
		}

		if ( directoryExists(expandedDir) ) {
			rs=getBean('fileWriter').getDirectoryList( directory=expandedDir, type="dir");
			
			if(rs.recordcount){
				if(get('isNew')){
					deferredModule={};
				}

				for(var row=1;row <= rs.recordcount;row++){
					try{
						config='';
						if ( fileExists('#expandedDir#/#rs.name[row]#/config.xml.cfm') ) {
							config=new mura.executor().execute('#arguments.dir#/#rs.name[row]#/config.xml.cfm');
						} else if ( fileExists('#expandedDir#/#rs.name[row]#/config.xml') ) {
							config=fileRead("#expandedDir#/#rs.name[row]#/config.xml");
						} else {
							config="";
						}
						if ( isXML(config) ) {
							config=parseXML(config);

							if ( isDefined('config.displayobject') ) {
								var baseXML=config.displayobject;
							} else {
								var baseXML=config.mura;
							}
							if ( isDefined('baseXML.xmlAttributes.name') || isDefined('baseXML.name') ) {
								objectArgs={
												object=rs.name[row],
												custom=arguments.custom
												};
								tempVal=utility.getXMLKeyValue(baseXML,'name');
								if ( len(tempVal) ) {
									objectArgs.name=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'condition',true);
								if ( len(tempVal) ) {
									objectArgs.condition=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'contenttypes');
								if ( len(tempVal) ) {
									objectArgs.contenttypes=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'legacyObjectFile');
								if ( len(tempVal) ) {
									objectArgs.legacyObjectFile=rs.name[row] & "/" & tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'configuratorInit');
								if ( len(tempVal) ) {
									objectArgs.configuratorInit=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'configuratorJS');
								if ( len(tempVal) ) {
									objectArgs.configuratorJS=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'omitcontenttypes');
								if ( len(tempVal) ) {
									objectArgs.omitcontenttypes=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'custom',true);
								if ( len(tempVal) ) {
									objectArgs.custom=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'iconclass','mi-cog');
								if ( len(tempVal) ) {
									objectArgs.custom=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'cacheoutput',true);
								if ( len(tempVal) ) {
									objectArgs.custom=tempVal;
								}
								tempVal=utility.getXMLKeyValue(baseXML,'displayObjectFile');
								if ( len(tempVal) ) {
									objectArgs.displayObjectFile=rs.name[row] & "/" & tempVal;
								} else {
									tempVal=utility.getXMLKeyValue(baseXML,'component');
									if(len(tempVal)){
										objectArgs.displayObjectFile=tempVal;
									} else {
										objectArgs.displayObjectFile=rs.name[row] & "/index.cfm";
									}
								}

								for ( o in baseXML.xmlAttributes ) {
									if ( !structKeyExists(objectArgs,o) ) {
										objectArgs[o]=baseXML.xmlAttributes[o];
									}
								}

								objectfound=true;

								registerDisplayObject(
									argumentCollection=objectArgs
								);

								if(get('isNew')){
									deferredModule.config=config;
								} else {
									variables.configBean.getClassExtensionManager().loadConfigXML(config,getValue('siteid'));
								}
							}
						}

						if(directoryExists('#rs.directory[row]#/#rs.name[row]#/model')) {
							if(get('isNew')){
								deferredModule.modelDir="#arguments.dir#/#rs.name[row]#/model";
								deferredModule.package=arguments.package;
							} else {
								variables.configBean.registerBeanDir(dir='#arguments.dir#/#rs.name[row]#/model',siteid=getValue('siteid'),package=arguments.package);
							}
						} else if ( get('isNew') ){
							deferredModule.modelDir="";
							deferredModule.package="";
						}

						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/display_objects') ) {
							arguments.deferred=registerDisplayObjectDir(dir='#arguments.dir#/#rs.name[row]#/display_objects',deferred=arguments.deferred);
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/modules') ) {
							arguments.deferred=registerDisplayObjectDir(dir='#arguments.dir#/#rs.name[row]#/modules',conditional=true,deferred=arguments.deferred);
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/content_types') ) {
							arguments.deferred=registerContentTypeDir(dir='#arguments.dir#/#rs.name[row]#/content_types',deferred=arguments.deferred);
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/resource_bundles') ) {
							variables.instance.rbFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(getRBFactory(),'#rs.directory[row]#/#rs.name[row]#/resource_bundles',getJavaLocale());
						}
						if ( directoryExists('#rs.directory[row]#/#rs.name[row]#/resourceBundles') ) {
							variables.instance.rbFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(getRBFactory(),'#rs.directory[row]#/#rs.name[row]#/resourceBundles',getJavaLocale());
						}

						if(get('isNew') && ( isDefined('deferredModule.config') || isDefined('deferredModule.modelDir') ) ){
							arrayAppend(arguments.deferred,duplicate(deferredModule));
						}
					} catch(any e){
						commitTracepoint(initTracepoint("Error Registering Module #arguments.package#.#rs.name[row]#, check error log for details"));
						var logData={stacktrace=e.stacktrace};
						if(structKeyExists(e,'message')){
							logData.message=e.message;
						}
						writeLog( text="Error Registering Module: #serializeJSON(logData)#", file="exception", type="Error" );

						param name="request.muraDeferredModuleErrors" default=[];
						ArrayAppend(request.muraDeferredModuleErrors,logData);

						if(!isBoolean(variables.configBean.getValue('debuggingenabled')) || variables.configBean.getValue('debuggingenabled')){
							rethrow;
						}
					}
				}
			}

			if ( objectfound ) {
				if ( !listFind('/,\',right(arguments.dir,1)) ) {
					arguments.dir=arguments.dir & getBean('configBean').getFileDelim();
				}
				arrayPrepend(variables.instance.displayObjectLookUpArray,arguments.dir);
			}
		}

		return arguments.deferred;
	}

	public function registerModuleDir(dir, conditional="true", package="", custom="true",deferred=[]) output=false {
		return registerDisplayObjectDir(arguments=arguments);
	}

	public function getDispayObjectLookupArray() output=false {
		return variables.instance.displayObjectLookUpArray;
	}

	public function lookupDisplayObjectFilePath(filePath, customOnly="false") output=false {
		arguments.filePath=Replace(arguments.filePath, "\", "/", "ALL");
		if ( len(request.altTheme) ) {
			var altThemePath=getThemeIncludePath(request.altTheme) & "/display_objects/" & arguments.filePath;
			if ( fileExists(expandPath(altThemePath)) ) {
				return altThemePath;
			}
			altThemePath=getThemeIncludePath(request.altTheme) & "/modules/" & arguments.filePath;
			if ( fileExists(expandPath(altThemePath)) ) {
				return altThemePath;
			}
		}
		if ( hasDisplayObjectFilePath(arguments.filePath) ) {
			return getDisplayObjectFilePath(arguments.filePath);
		}
		var dir="";
		var result="";
		var coreIndex=arrayLen(variables.instance.displayObjectLookUpArray)-2;
		var dirIndex=0;
		var utility=getBean('utility');
		for ( dir in variables.instance.displayObjectLookUpArray ) {
			dirIndex=dirIndex+1;
			if ( !arguments.customonly || dirIndex < coreIndex ) {
				result=dir & arguments.filePath;
				if ( fileExists(expandPath(result)) && utility.isPathLegal(result)) {
					setDisplayObjectFilePath(arguments.filePath,result);
					return result;
				}
			}
		}
		setDisplayObjectFilePath(arguments.filePath,"");
		return "";
	}

	public function lookupModuleFilePath(filePath, customOnly="false") output=false {
		return lookupDisplayObjectFilePath(argumentCollection=arguments);
	}

	public function hasDisplayObject(object) output=false {
		return structKeyExists(variables.instance.displayObjectLookup,'#arguments.object#');
	}

	public function hasModule(object) output=false {
		return hasDisplayObject(argumentCollection=arguments);
	}

	public function getDisplayObject(object) output=false {
		return variables.instance.displayObjectLookup['#arguments.object#'];
	}

	public function getModule(object) output=false {
		return getDisplayObject(argumentCollection=arguments);
	}

	public function hasDisplayObjectFilePath(filepath) output=false {
		return structKeyExists(variables.instance.displayObjectFilePathLookup,'#arguments.filepath#');
	}

	public function hasModuleFilePath(filepath) output=false {
		return hasDisplayObjectFilePath(argumentCollection=arguments);
	}

	public function getDisplayObjectFilePath(filepath) output=false {
		return variables.instance.displayObjectFilePathLookup['#arguments.filepath#'];
	}

	public function getModuleFilePath(filepath) output=false {
		return getDisplayObjectFilePath(argumentCollection=arguments);
	}

	public function setDisplayObjectFilePath(filepath, result) output=false {
		variables.instance.displayObjectFilePathLookup['#arguments.filepath#']=arguments.result;
		return this;
	}

	ublic function setModuleFilePath(filepath, result) output=false {
		setDisplayObjectFilePath(argumentCollection=arguments);
		return this;
	}

	public function discoverGlobalModules(deferred=[]) output=false {
		var lookupArray=[
			"/muraWRM/core/modules/v1",
			"/muraWRM/modules",
			"/muraWRM/display_objects"
		];

		var dir="";
		var custom=true;
		for ( dir in lookupArray ) {
			custom= listFindNoCase('/muraWRM/modules,/muraWRM/display_objects',dir);
			conditional=false;
			arguments.deferred=registerDisplayObjectDir(dir=dir,conditional=conditional,custom=custom,deferred=arguments.deferred);
		}

		return arguments.deferred;
	}

	public function discoverModules() output=false {
		var lookupArray=[
			getIncludePath()  & "/includes/display_objects",
			getIncludePath()  & "/includes/modules",
			getIncludePath()  & "/includes/display_objects/custom",
			getIncludePath()  & "/display_objects",
			getIncludePath()  & "/modules",
			getThemeIncludePath(getValue('theme')) & "/display_objects",
			getThemeIncludePath(getValue('theme')) & "/modules"
		];

		var dir="";
		var dirIndex=0;
		var custom=true;
		var conditional=false;
		for ( dir in lookupArray ) {
			dirIndex=dirIndex+1;
			custom= listFindNoCase('/muraWRM/modules,/muraWRM/display_objects',dir);
			conditional=false;
			registerDisplayObjectDir(dir=dir,conditional=conditional,custom=custom);
		}
		var qs=getQueryService(readOnly=true);
		qs.addParam(name="siteid",cfsqltype="cf_sql_varchar",value=getValue('siteid'));
		var rs=qs.execute(sql="
		select tplugins.package
		from tplugins inner join tcontent on tplugins.moduleid = tcontent.contentid
		where tcontent.siteid= :siteid
		and tplugins.deployed=1
		order by tplugins.loadPriority desc
		").getResult();

		if(rs.recordcount){
			for(var row=1;row <= rs.recordcount;row++){
				registerDisplayObjectDir('/' & rs.package[row] & '/display_objects',true);
				registerDisplayObjectDir('/' & rs.package[row] & '/modules',true);
				registerContentTypeDir('/' & rs.package[row] & '/content_types',true);
			}
		}

		return this;
	}

	public function getDisplayObjects() {
		return variables.instance.displayObjectLookup;
	}

	public function discoverBeans() output=false {

		var lookups=[
		'/muraWRM/#getValue('siteid')#/includes',
		'/muraWRM/#getValue('siteid')#',
		'/muraWRM/#getValue('siteid')#/themes/#getValue('theme')#',
		'/muraWRM/#getValue('siteid')#/includes/themes/#getValue('theme')#',
		'/muraWRM/sites/#getValue('siteid')#/includes',
		'/muraWRM/sites/#getValue('siteid')#',
		'/muraWRM/sites/#getValue('siteid')#/themes/#getValue('theme')#',
		'/muraWRM/sites/#getValue('siteid')#/includes/themes/#getValue('theme')#',
		'/muraWRM/themes/#getValue('theme')#'
		];
		var i=1;
		for ( i in lookups ) {
			variables.configBean.registerBeanDir(dir='#i#/model',siteid=getValue('siteid'));
		}
		return this;
	}

	public function getFileMetaData(property="fileid") output=false {
		return getBean('fileMetaData').loadBy(siteID=getValue('siteid'),fileid=getValue(arguments.property));
	}

	function addEventHandler(component){
		if(!isObject(arguments.component) && isStruct(arguments.component)){
			for(var e in arguments.component){
				on(e,component[e]);
			}
		} else {
			getBean('pluginManager').addEventHandler(component=arguments.component,siteid=get('siteid'));
		}
		return this;
	}

	function on(eventName,fn){
		var handler=new mura.baseobject();

		if(left(arguments.eventName,2)!='on' && left(arguments.eventName,8)!='standard'){
			arguments.eventName="on" & arguments.eventName;
		}

		handler.injectMethod(arguments.eventName,arguments.fn);
		getBean('pluginManager').addEventHandler(component=handler,siteid=get('siteid'));
		return this;
	}

	function trigger(eventName){
		if(left(arguments.eventName,2)!='on'){
			arguments.eventName="on" & arguments.eventName;
		}
		getBean('pluginManager').announceEvent(
			eventToAnnounce=arguments.eventName,
			currentEventObject=new mura.event({siteid=get('siteid')})
			);

		return this;
	}

	function getDSPIncludePath(){
		if(isDefined('variables.dspincludepath')){
			return variables.dspincludepath;
		} else {
			variables.dspincludepath="#getIncludePath()#/includes";
			if(!directoryExists(expandPath(variables.dspincludepath))){
				variables.dspincludepath=getIncludePath();
			}
			return variables.dspincludepath;
		}
	}

	public function lookupHTMLHeadQueueFilePath(filePath, customOnly="false") output=false {
		arguments.filePath=Replace(arguments.filePath, "\", "/", "ALL");

		if ( hasHTMLQueueFilePath(arguments.filePath) ) {
			return getHTMLQueueFilePath(arguments.filePath);
		}

		var displaypoolid=getValue('displaypoolid');
		var theme=getValue('theme');
		var pluginbasePath='';
		var i='';
		var headerFound=false;
		var pluginPath='';
		var pathData={};

		if ( !refind('[\\/]',arguments.filePath) ) {
			pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/themes/#theme#/display_objects/htmlhead/";
			if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
				pathData={
					pluginPath=application.configBean.getContext() & pluginBasePath,
					filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
				};
				setHTMLQueueFilePath(arguments.filePath,pathData);
				headerFound=true;
			}
			pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/themes/#theme#/modules/htmlhead/";
			if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
				pathData={
					pluginPath=application.configBean.getContext() & pluginBasePath,
					filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
				};
				setHTMLQueueFilePath(arguments.filePath,pathData);
				headerFound=true;
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/themes/#theme#/display_objects/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/themes/#theme#/modules/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}

			if ( !headerFound ) {
				pluginBasePath="/themes/#theme#/display_objects/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/themes/#theme#/modules/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/display_objects/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};

					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/modules/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/display_objects/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/modules/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/display_objects/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/modules/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/core/modules/v1/htmlhead/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			//  if not found, try the path that was passed
			if ( !headerFound && fileExists(expandPath("/muraWRM/" & arguments.filePath)) ) {
				pathData={
					pluginPath=arguments.filePath,
					filePath=arguments.filePath
				};
				setHTMLQueueFilePath(arguments.filePath,pathData);
				headerFound=true;
			}

			//  If not found, look in global plugins directory
			if ( !headerFound ) {
				pluginBasePath="/plugins/";
				if ( fileExists(expandPath("#pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginID=listLast(listFirst(arguments.filePath,"/"),"_"),
						pluginPath="",
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
		} else {
			pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/themes/#theme#/display_objects/";
			if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
				pathData={
					pluginPath=application.configBean.getContext() & pluginBasePath,
					filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
				};
				setHTMLQueueFilePath(arguments.filePath,pathData);
				headerFound=true;
			}
			pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/themes/#theme#/modules/";
			if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
				pathData={
					pluginPath=application.configBean.getContext() & pluginBasePath,
					filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
				};
				setHTMLQueueFilePath(arguments.filePath,pathData);
				headerFound=true;
			}

			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/themes/#theme#/display_objects/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/themes/#theme#/modules/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/themes/#theme#/display_objects/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/themes/#theme#/modules/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}

			//  if not found, try the path that was passed
			if ( !headerFound && fileExists(expandPath("/muraWRM/" & arguments.filePath)) ) {
				pathData={
					pluginPath=arguments.filePath,
					filePath=arguments.filePath
				};
				setHTMLQueueFilePath(arguments.filePath,pathData);
				headerFound=true;
			}
			//  If not found, look in display_objects directory
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/display_objects/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/display_objects/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/display_objects/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			if ( !headerFound ) {
				pluginBasePath="/modules/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
			//  If not found, look in includes directory
			if ( !headerFound ) {
				pluginBasePath="#application.configBean.getSiteAssetPath()#/#displayPoolID#/includes/";
				if ( fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginPath=application.configBean.getContext() & pluginBasePath,
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}

			//  If not found, look in global plugins directory
			if ( !headerFound ) {
				pluginBasePath="/plugins/";
				if ( fileExists(expandPath("#pluginbasePath##arguments.filepath#")) ) {
					pathData={
						pluginID=listLast(listFirst(arguments.filePath,"/"),"_"),
						pluginPath="",
						filePath="/#application.configBean.getWebRootMap()##pluginbasePath##arguments.filepath#"
					};
					setHTMLQueueFilePath(arguments.filePath,pathData);
					headerFound=true;
				}
			}
		}

		if(! headerFound ) {
			setHTMLQueueFilePath(arguments.filePath,{});
		}

		return getHTMLQueueFilePath(arguments.filePath);
	}

	public function hasHTMLQueueFilePath(filepath) output=false {
		return structKeyExists(variables.instance.HTMLQueueFilePathLookup,'#arguments.filepath#');
	}

	public function getHTMLQueueFilePath(filepath) output=false {
		return variables.instance.HTMLQueueFilePathLookup['#arguments.filepath#'];
	}

	public function setHTMLQueueFilePath(filepath, result) output=false {
		variables.instance.HTMLQueueFilePathLookup['#arguments.filepath#']=arguments.result;
		return this;
	}

}
