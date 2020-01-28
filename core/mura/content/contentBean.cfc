/*  This file is part of Mura CMS.

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

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
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
 * This provides content functionality
 */
component extends="mura.bean.beanExtendable" entityName="content" table="tcontent" output="false" hint="This provides content functionality" {
	property name="contentHistID" fieldtype="id" type="string" default="" comparable="false";
	property name="contentID" type="string" default="" comparable="false";
	property name="kids" fieldtype="one-to-many" cfc="content" nested=true fkcolumn="contentid" orderby="created asc" cascade="delete";
	property name="parent" fieldtype="many-to-one" cfc="content" fkcolumn="parentid"  required="true";
	property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID"  required="true";
	property name="categoryAssignments" fieldtype="one-to-many" cfc="contentCategoryAssign" loadkey="contenthistid";
	property name="changeset" fieldtype="many-to-one" cfc="changeset" fkcolumn="changesetid";
	property name="comments" fieldtype="one-to-many" cfc="comment" fkcolumn="contentid";
	property name="stats" fieldtype="one-to-one" cfc="stats" fkcolumn="contentid";
	property name="preserveID" type="string" default="" comparable="false" persistent="false";
	property name="active" type="numeric" default="0" comparable="false";
	property name="approved" type="numeric" default="0" comparable="false";
	property name="orderno" type="numeric" default="0" comparable="false";
	property name="metaDesc" type="string" default="";
	property name="metaKeyWords" type="string" default="";
	property name="displayStart" type="date" default="";
	property name="displayStop" type="date" default="";
	property name="body" type="string" default="" html="true";
	property name="title" type="string" default="" required="true";
	property name="menuTitle" type="string" default="" listview=true;
	property name="URLTitle" type="string" default="";
	property name="HTMLTitle" type="string" default="";
	property name="filename" type="string" default="";
	property name="oldfilename" type="string" default="";
	property name="lastUpdate" type="date" default="" comparable="false";
	property name="display" type="numeric" default="";
	property name="type" type="string" default="Page";
	property name="newfile" type="string" default="";
	property name="lastUpdateBy" type="string" default="";
	property name="lastUpdateByID" type="string" default="" comparable="false";
	property name="summary" type="string" default="" html="true";
	property name="moduleID" type="string" default="00000000000000000000000000000000000";
	property name="isNav" type="numeric" default="1";
	property name="restricted" type="numeric" default="0";
	property name="target" type="string" default="_self";
	property name="restrictGroups" type="string" default="";
	property name="template" type="string" default="";
	property name="childTemplate" type="string" default="";
	property name="responseMessage" type="string" default="" html="true";
	property name="responseChart" type="numeric" default="0";
	property name="responseSendTo" type="string" default="";
	property name="responseDisplayFields" type="string" default="";
	property name="moduleAssign" type="string" default="";
	property name="notes" type="string" default="";
	property name="inheritObjects" type="string" default="Inherit";
	property name="isFeature" type="numeric" default="0";
	property name="isNew" type="numeric" default="1" persistent="false";
	property name="releaseDate" type="date" default="";
	property name="isLocked" type="numeric" default="0" persistent="false";
	property name="nextN" type="numeric" default="10";
	property name="sortBy" type="string" default="orderno";
	property name="sortDirection" type="string" default="asc";
	property name="featureStart" type="date" default="";
	property name="featureStop" type="date" default="";
	property name="fileID" type="string" default="";
	property name="fileSize" type="any" default="0" persistent="false";
	property name="fileExt" type="string" default="" persistent="false";
	property name="contentType" type="string" default="" persistent="false";
	property name="contentSubType" type="string" default="" persistent="false";
	property name="forceSSL" type="numeric" default="0";
	property name="remoteURL" type="string" default="";
	property name="remoteID" type="string" default="";
	property name="remotePubDate" type="string" default="";
	property name="remoteSource" type="string" default="";
	property name="remoteSourceURL" type="string" default="";
	property name="credits" type="string" default="";
	property name="audience" type="string" default="";
	property name="keyPoints" type="string" default="" persistent="false";
	property name="searchExclude" type="numeric" default="0";
	property name="displayTitle" type="numeric" default="1";
	property name="path" type="string" default="";
	property name="tags" type="string" default="";
	property name="doCache" type="numeric" default="1" persistent="false";
	property name="created" type="date" default="";
	property name="mobileExclude" type="numeric" default="0";
	property name="changesetID" type="string" default="" comparable="false";
	property name="imageSize" type="string" default="small";
	property name="imageHeight" type="string" default="AUTO";
	property name="imageWidth" type="string" default="AUTO";
	property name="majorVersion" type="numeric" default="0" persistent="false";
	property name="minorVersion" type="numeric" default="0" persistent="false";
	property name="expires" type="date" default="";
	property name="assocFilename" type="string" default="" persistent="false";
	property name="displayInterval" type="any" default="Daily";
	property name="requestID" type="string" default="" comparable="false";
	property name="approvalStatus" type="string" default="" persistent="false";
	property name="approvalGroupID" type="string" default="" comparable="false" persistent="false";
	property name="approvalChainOverride" type="boolean" default="false" comparable="false" persistent="false";
	property name="relatedContentSetData" type="any" persistent="false";
	variables.primaryKey = 'contentid';
	variables.entityName = 'content';
	variables.instanceName= 'title';

	public function init() output=false {
		super.init(argumentCollection=arguments);
		variables.instance.ContentHistID = "";
		variables.instance.Contentid = "";
		variables.instance.Active = 0;
		variables.instance.OrderNo = 1;
		variables.instance.MetaDesc = "";
		variables.instance.MetaKeyWords = "";
		variables.instance.Approved = 0;
		variables.instance.DisplayStart = "";
		variables.instance.Displaystop = "";
		variables.instance.Body = "";
		variables.instance.Title = "";
		variables.instance.MenuTitle = "";
		variables.instance.URLTitle="";
		variables.instance.HTMLTitle="";
		variables.instance.Filename = "";
		variables.instance.OldFilename = "";
		variables.instance.LastUpdate = now();
		variables.instance.Display = 1;
		variables.instance.ParentID = "";
		variables.instance.newFile = "";
		variables.instance.type = "Page";
		variables.instance.subType = "Default";
		var sessionData=getSession();
		if ( isDefined("sessionData.mura") && sessionData.mura.isLoggedIn ) {
			variables.instance.LastUpdateBy = left(sessionData.mura.fname & " " & sessionData.mura.lname,50);
			variables.instance.LastUpdateByID = sessionData.mura.userID;
		}
		// allow for these settings to be set programmatically
		if ( !StructKeyExists(variables.instance, 'LastUpdateBy') ) {
			variables.instance.LastUpdateBy = '';
		}
		if ( !StructKeyExists(variables.instance, 'LastUpdateByID') ) {
			variables.instance.LastUpdateByID = '';
		}
		variables.instance.Summary = "";
		variables.instance.SiteID = "";
		variables.instance.ModuleID = "00000000000000000000000000000000000";
		variables.instance.IsNav = 1;
		variables.instance.Restricted = 0;
		variables.instance.Target = "_self";
		variables.instance.RestrictGroups = "";
		variables.instance.Template = "";
		variables.instance.childTemplate="";
		variables.instance.ResponseMessage = "";
		variables.instance.ResponseChart = 0;
		variables.instance.ResponseSendTo = "";
		variables.instance.ResponseDisplayFields = "";
		variables.instance.ModuleAssign = "";
		variables.instance.notes = "";
		variables.instance.inheritObjects = "Inherit";
		variables.instance.isFeature = 0;
		variables.instance.isNew = 1;
		variables.instance.releaseDate = "";
		variables.instance.targetParams = "";
		variables.instance.IsLocked = 0;
		variables.instance.nextN = 10;
		variables.instance.sortBy = "orderno";
		variables.instance.sortDirection = "asc";
		variables.instance.FeatureStart = "";
		variables.instance.FeatureStop = "";
		variables.instance.FileID = "";
		variables.instance.FileSize = 0;
		variables.instance.FileExt = "";
		variables.instance.ContentType = "";
		variables.instance.ContentSubType = "";
		variables.instance.forceSSL = 0;
		variables.instance.remoteURL = "";
		variables.instance.remoteID = "";
		variables.instance.remotePubDate = "";
		variables.instance.remoteSource = "";
		variables.instance.remoteSourceURL = "";
		variables.instance.credits = "";
		variables.instance.audience = "";
		variables.instance.keyPoints = "";
		variables.instance.searchExclude = 0;
		variables.instance.displayTitle = 1;
		variables.instance.Path = "";
		variables.instance.tags = "";
		variables.instance.doCache = 1;
		variables.instance.created = now();
		variables.instance.mobileExclude = 0;
		variables.instance.changesetID = "";
		variables.instance.tcontent_id = 0;
		variables.instance.imageSize = "small";
		variables.instance.imageHeight = "AUTO";
		variables.instance.imageWidth = "AUTO";
		variables.instance.majorVersion = 0;
		variables.instance.minorVersion = 0;
		variables.instance.expires = "";
		variables.instance.assocFilename = "";
		variables.instance.displayInterval = "Daily";
		variables.instance.errors=structnew();
		variables.instance.categoryID = "";
		variables.instance.requestID = "";
		variables.instance.approvalStatus = "";
		variables.instance.approvalGroupID = "";
		variables.instance.approvalChainOverride = false;
		variables.instance.approvingChainRequest = false;
		variables.instance.relatedContentSetData = "";
		variables.instance.objectParams={};
		variables.displayRegions = structNew();
		return this;
	}

	public function setContentManager(contentManager) {
		variables.contentManager=arguments.contentManager;
		return this;
	}

	public function setConfigBean(configBean) {
		variables.configBean=arguments.configBean;
		return this;
	}

	public function setSettingsManager(settingsManager) {
		variables.settingsManager=arguments.settingsManager;
		return settingsManager;
	}

	public function set(property, propertyValue) output=false {
		if ( !isDefined('arguments.content') ) {
			if ( isSimpleValue(arguments.property) ) {
				return setValue(argumentCollection=arguments);
			}
			arguments.content=arguments.property;
		}
		var starthour = 0;
		var stophour = 0;
		var pageNum = 2;
		var featurestophour="";
		var featurestarthour="";
		var releasehour="";
		var expireshour="";
		var prop="";
		var sessionData=getSession();

		if ( isQuery(arguments.content) && arguments.content.recordcount ) {

			for(prop in listToArray(arguments.content.columnlist)){
				setValue(prop,arguments.content[prop][1]);
			}

		} else if ( isStruct(arguments.content) ) {
			for ( prop in arguments.content ) {
				setValue(prop,arguments.content[prop]);
			}
			if ( variables.instance.display == 2
			AND isDate(variables.instance.displayStart) ) {
				if ( isdefined("arguments.content.starthour")
			and isdefined("arguments.content.startMinute") ) {
					param name="arguments.content.startDayPart" default="";
					if ( arguments.content.startdaypart == "PM" ) {
						starthour = arguments.content.starthour + 12;
						if ( starthour == 24 ) {
							starthour = 12;
						}
					} else if ( arguments.content.startdaypart == "AM" ) {
						starthour = arguments.content.starthour;
						if ( starthour == 12 ) {
							starthour = 0;
						}
					} else {
						starthour = arguments.content.starthour;
					}
					setDisplayStart(createDateTime(year(variables.instance.displayStart), month(variables.instance.displayStart), day(variables.instance.displayStart),starthour, arguments.content.startMinute, "0"));
				}
			} else if ( variables.instance.display == 2 ) {
				variables.instance.display=1;
				variables.instance.displayStart="";
				variables.instance.displayStop="";
			}
			if ( variables.instance.display == 2
			AND isDate(variables.instance.displayStop) ) {
				if ( isdefined("arguments.content.Stophour")
			and isdefined("arguments.content.StopMinute") ) {
					param name="arguments.content.stopDayPart" default="";
					if ( arguments.content.stopdaypart == "PM" ) {
						stophour = arguments.content.stophour + 12;
						if ( stophour == 24 ) {
							stophour = 12;
						}
					} else if ( arguments.content.stopdaypart == "AM" ) {
						stophour = arguments.content.stophour;
						if ( stophour == 12 ) {
							stophour = 0;
						}
					} else {
						stophour = arguments.content.stophour;
					}
					setDisplayStop(createDateTime(year(variables.instance.displayStop), month(variables.instance.displayStop), day(variables.instance.displayStop),stophour, arguments.content.StopMinute, "0"));
				}
			}
			if ( variables.instance.isFeature == 2
			AND isDate(variables.instance.featureStart)
			and isdefined("arguments.content.featurestarthour")
			and isdefined("arguments.content.featurestartMinute") ) {
				param name="arguments.content.featureStartDayPart" default="";
				if ( arguments.content.featureStartdaypart == "PM" ) {
					featurestarthour = arguments.content.featurestarthour + 12;
					if ( featurestarthour == 24 ) {
						featurestarthour = 12;
					}
				} else if ( arguments.content.featureStartdaypart == "AM" ) {
					featurestarthour = arguments.content.featurestarthour;
					if ( featurestarthour == 12 ) {
						featurestarthour = 0;
					}
				} else {
					featurestarthour = arguments.content.featurestarthour;
				}
				setFeatureStart(createDateTime(year(variables.instance.featureStart), month(variables.instance.featureStart), day(variables.instance.featureStart),Featurestarthour, arguments.content.featurestartMinute, "0"));
			}
			if ( variables.instance.isFeature == 2
			AND isDate(variables.instance.featureStop)
			and isdefined("arguments.content.featurestophour")
			and isdefined("arguments.content.featurestopMinute") ) {
				param name="arguments.content.featureStopDayPart" default="";
				if ( arguments.content.featureStopdaypart == "PM" ) {
					featurestophour = arguments.content.featurestophour + 12;
					if ( featurestophour == 24 ) {
						featurestophour = 12;
					}
				} else if ( arguments.content.featureStopdaypart == "AM" ) {
					featurestophour = arguments.content.featurestophour;
					if ( featurestophour == 12 ) {
						featurestophour = 0;
					}
				} else {
					featurestophour = arguments.content.featurestophour;
				}
				setFeatureStop(createDateTime(year(variables.instance.featureStop), month(variables.instance.featureStop), day(variables.instance.featureStop),Featurestophour, arguments.content.featurestopMinute, "0"));
			}
			if ( isDate(variables.instance.releaseDate) ) {
				if ( isdefined("arguments.content.releasehour")
			and isdefined("arguments.content.releaseMinute") ) {
					param name="arguments.content.releaseDayPart" default="";
					if ( arguments.content.releasedaypart == "PM" ) {
						releasehour = arguments.content.releasehour + 12;
						if ( releasehour == 24 ) {
							releasehour = 12;
						}
					} else if ( arguments.content.releasedaypart == "AM" ) {
						releasehour = arguments.content.releasehour;
						if ( releasehour == 12 ) {
							releasehour = 0;
						}
					} else {
						releasehour = arguments.content.releasehour;
					}
					setReleaseDate(createDateTime(year(variables.instance.releaseDate), month(variables.instance.releaseDate), day(variables.instance.releaseDate), releasehour, arguments.content.releaseMinute, "0"));
				}
			}
			if ( isDate(variables.instance.expires) ) {
				if ( isdefined("arguments.content.expireshour")
			and isdefined("arguments.content.expiresMinute") ) {
					param name="arguments.content.expiresDayPart" default="";
					if ( arguments.content.expiresdaypart == "PM" ) {
						expireshour = arguments.content.expireshour + 12;
						if ( expireshour == 24 ) {
							expireshour = 12;
						}
					} else if ( arguments.content.expiresdaypart == "AM" ) {
						expireshour = arguments.content.expireshour;
						if ( expireshour == 12 ) {
							expireshour = 0;
						}
					} else {
						expireshour = arguments.content.expireshour;
					}
					setExpires(createDateTime(year(variables.instance.expires), month(variables.instance.expires), day(variables.instance.expires), expireshour, arguments.content.expiresMinute, "0"));
				}
			}
			if ( isDefined("sessionData.mura") && sessionData.mura.isLoggedIn ) {
				variables.instance.LastUpdateBy = left(sessionData.mura.fname & " " & sessionData.mura.lname,50);
				variables.instance.LastUpdateByID = sessionData.mura.userID;
			}
			// allow for these settings to be set programmatically
			if ( !StructKeyExists(variables.instance, 'LastUpdateBy') ) {
				variables.instance.LastUpdateBy = '';
			}
			if ( !StructKeyExists(variables.instance, 'LastUpdateByID') ) {
				variables.instance.LastUpdateByID = '';
			}
		}

		variables.instance.statusid = getStatusID();
		variables.instance.status = getStatus();
		variables.instance.ishome = getIsHome();
		variables.instance.depth = getDepth();
		return this;
	}

	public function validate() output=false {
		var extErrors=structNew();
		if ( len(variables.instance.siteID) ) {
			extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues());
		}
		super.validate();
		if ( !structIsEmpty(extErrors) ) {
			structAppend(variables.instance.errors,extErrors);
		}
		if ( listFindNoCase('Form,Component',variables.instance.type)
		and variables.contentManager.doesLoadKeyExist(this,'title',variables.instance.title) ) {
			variables.instance.errors.titleconflict=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.titlenotunique");
		}
		if ( getValue('display') == 2 && getDisplayConflicts().hasNext() ) {
			variables.instance.errors.displayconflict=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.displayconflict");
		}
		if ( variables.instance.isNew
		and listFindNoCase('File',variables.instance.type)
		and !(len(variables.instance.newfile) || len(variables.instance.fileID)) ) {
			variables.instance.errors.filemissing=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.filemissing");
		}

		if(not application.configBean.getValue(property='keepMetaKeywords',defaultValue=false)
			&& len(getCanonicalURL())
			&& !isValid('url',getCanonicalURL())){
			variables.instance.errors.canonicalurl=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.canonicalurlinvalid");
		}

		if(!application.settingsManager.getSite(variables.instance.siteID).getContentRenderer().siteidinurls 
			&& getValue('parentid') == '00000000000000000000000000000000001'){
			var incomingFirstFilenameEntry=getBean('contentUtility').formatFilename(getValue('urltitle'));
			if(variables.settingsManager.siteExists(incomingFirstFilenameEntry)) {
				variables.instance.errors.filename=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.content.filenamesiteidconflict");
			}
		}

		var errorCheck={};
		var checknum=1;
		var checkfound=false;

		if(arrayLen(variables.instance.addObjects)){
			for(var obj in variables.instance.addObjects){
				errorCheck=obj.validate().getErrors();
				if(!structIsEmpty(errorCheck)){
					do{
						if( !structKeyExists(variables.instance.errors,obj.getEntityName() & checknum) ){
							variables.instance.errors[obj.getEntityName()  & checknum ]=errorCheck;
							checkfound=true;
						}
					} while (!checkfound);
				}

			}
		}
		return this;
	}

	public struct function getAllValues(required autocomplete="#variables.instance.extendAutoComplete#") output=false {
		var i="";
		var extData="";
		if ( arguments.autocomplete ) {
			extData=getExtendedData().getAllExtendSetData();
			if ( !structIsEmpty(extData) ) {
				structAppend(variables.instance,extData.data,false);

				for(i in listToArray(extData.extendSetID)){
					if (not listFind(variables.instance.extendSetID,i)){
						variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i);
					}
				}

			}
			if ( !structIsEmpty(variables.displayRegions) ) {
				for ( i in variables.displayRegions ) {
					variables.instance[i]=variables.contentManager.formatRegionObjectsString(variables.displayRegions[i]);
				}
			}
		}
		purgeExtendedData();
		variables.displayRegions=structNew();
		return variables.instance;
	}

	public function getContentHistID() output=false {
		if ( !len(variables.instance.ContentHistID) ) {
			variables.instance.ContentHistID = createUUID();
		}
		return variables.instance.ContentHistID;
	}

	public function getContentID() output=false {
		if ( !len(variables.instance.contentid) ) {
			variables.instance.contentid = createUUID();
		}
		return variables.instance.contentid;
	}

	public function setDisplayStart(required string DisplayStart) output=false {
		variables.instance.displayStart = parseDateArg(arguments.displayStart);
		return this;
	}

	public function setDisplaystop(required string Displaystop) output=false {
		variables.instance.Displaystop = parseDateArg(arguments.Displaystop);
		return this;
	}

	public function setExpires(required string expires) output=false {
		variables.instance.expires = parseDateArg(arguments.expires);
		return this;
	}

	public function setLastUpdate(required string LastUpdate) output=false {
		variables.instance.LastUpdate = parseDateArg(arguments.LastUpdate);
		return this;
	}

	public function setType(required string Type) output=false {
		if ( arguments.type == 'Portal' ) {
			arguments.type='Folder';
		}
		arguments.Type=trim(arguments.Type);
		if ( len(arguments.Type) && variables.instance.Type != arguments.Type && listFindNoCase('Page,Folder,Calendar,Gallery,File,Link,Form,Component,Variation,Module',arguments.type) ) {
			variables.instance.Type = arguments.Type;
			purgeExtendedData();
			if ( variables.instance.Type == "Form" ) {
				variables.instance.moduleID="00000000000000000000000000000000004";
				if ( !isValid('uuid',variables.instance.ParentID) ) {
					variables.instance.ParentID="00000000000000000000000000000000004";
				}
			} else if ( variables.instance.Type == "Component" ) {
				variables.instance.moduleID="00000000000000000000000000000000003";
				if ( !isValid('uuid',variables.instance.ParentID) ) {
					variables.instance.ParentID="00000000000000000000000000000000003";
				}
			} else if ( variables.instance.Type == "Variation" ) {
				variables.instance.moduleID="00000000000000000000000000000000099";
				if ( !isValid('uuid',variables.instance.ParentID) ) {
					variables.instance.ParentID="00000000000000000000000000000000099";
				}
			}
		}
		return this;
	}

	public function setTitle(required string title) output=false {
		arguments.title=trim(arguments.title);
		if ( len(arguments.title) ) {
			variables.instance.title =arguments.title;
		}
		return this;
	}

	public function setFilename(filename) output=false {
		variables.instance.filename=left(arguments.filename,255);
		return this;
	}

	public function setLastUpdateBy(String lastUpdateBy) output=false {
		variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50);
		return this;
	}

	public function setReleaseDate(required string releaseDate) output=false {
		variables.instance.releaseDate = parseDateArg(arguments.releaseDate);
		return this;
	}

	public function setNextN(required any NextN) output=false {
		if ( isNumeric(arguments.NextN) ) {
			variables.instance.NextN = arguments.NextN;
		}
		return this;
	}

	public function setFeatureStop(required string FeatureStop) output=false {
		variables.instance.FeatureStop = parseDateArg(arguments.FeatureStop);
		return this;
	}

	public function setFeatureStart(required string FeatureStart) output=false {
		variables.instance.FeatureStart = parseDateArg(arguments.FeatureStart);
		return this;
	}

	public function setRemotePubDate(required string RemotePubDate) output=false {
		variables.instance.RemotePubDate = parseDateArg(arguments.RemotePubDate);
		return this;
	}

	public function setDisplayTitle(required DisplayTitle) output=false {
		if ( isNumeric(arguments.DisplayTitle) ) {
			variables.instance.DisplayTitle = arguments.DisplayTitle;
		}
		return this;
	}

	public function setMajorVersion(required majorVersion) output=false {
		if ( isNumeric(arguments.majorVersion) ) {
			variables.instance.majorVersion = arguments.majorVersion;
		}
		return this;
	}

	public function setMinorVersion(required minorVersion) output=false {
		if ( isNumeric(arguments.minorVersion) ) {
			variables.instance.minorVersion = arguments.minorVersion;
		}
		return this;
	}

	public function setDoCache(required doCache) output=false {
		if ( isNumeric(arguments.doCache) ) {
			variables.instance.doCache = arguments.doCache;
		}
		return this;
	}

	public function setMobileExclude(required mobileExclude) output=false {
		if ( isNumeric(arguments.mobileExclude) ) {
			variables.instance.mobileExclude = arguments.mobileExclude;
		}
		return this;
	}

	public function setCreated(required string Created) output=false {
		variables.instance.Created = parseDateArg(arguments.Created);
		return this;
	}

	public function setImageSize(imageSize) output=false {
		if ( len(arguments.imageSize) ) {
			variables.instance.imageSize = arguments.imageSize;
		}
		return this;
	}

	public function getImageSize() output=false {
		if ( variables.instance.imageSize == "Custom"
	and variables.instance.ImageHeight == "AUTO"
	and variables.instance.ImageWidth == "AUTO" ) {
			return "small";
		} else {
			return variables.instance.imageSize;
		}
	}

	public function setImageHeight(required ImageHeight) output=false {
		if ( isNumeric(arguments.ImageHeight) ) {
			variables.instance.ImageHeight = arguments.ImageHeight;
		}
		return this;
	}

	public function getImageHeight() output=false {
		if ( variables.instance.imageSize == "Custom" ) {
			return variables.instance.ImageHeight;
		} else {
			return "AUTO";
		}
	}

	public function setImageWidth(required ImageWidth) output=false {
		if ( isNumeric(arguments.ImageWidth) ) {
			variables.instance.ImageWidth = arguments.ImageWidth;
		}
		return this;
	}

	public function getImageWidth() output=false {
		if ( variables.instance.imageSize == "Custom" ) {
			return variables.instance.ImageWidth;
		} else {
			return "AUTO";
		}
	}

	public function setTarget(string target="_self") output=false {
		if ( len(arguments.target) ) {
			variables.instance.target=arguments.target;
		}
		return this;
	}
	//  for variations

	public function getInitJS() output=false {
		return variables.instance.responseMessage;
	}

	public function setInitJS(initjs) output=false {
		variables.instance.responseMessage=arguments.initjs;
		return this;
	}
	//

	public function getDisplayStart(timezone="") output=false {
		if ( len(arguments.timezone) && isDate(variables.instance.displaystart) ) {
			return convertTimezone(datetime=variables.instance.displaystart,to=arguments.timezone);
		} else {
			return variables.instance.displaystart;
		}
		return this;
	}

	public function getDisplayStop(timezone="") output=false {
		if ( len(arguments.timezone) && isDate(variables.instance.displaystop) ) {
			return convertTimezone(datetime=variables.instance.displaystop,to=arguments.timezone);
		} else {
			return variables.instance.displaystop;
		}
		return this;
	}

	public function setDisplayList(displayList) output=false {
		variables.instance.responseDisplayFields=arguments.displayList;
		return this;
	}

	public function getDisplayList() output=false {
		if ( !len(variables.instance.responseDisplayFields) ) {
			var renderer=getBean('settingsManager').getSite(get('siteid')).getContentRenderer();
			if(structKeyExists(renderer,'defaultCollectionDisplayList')){
				return renderer.defaultCollectionDisplayList;
			} else {
				return "Date,Title,Image,Summary,Credits,Tags";
			}
		} else {
			return variables.instance.responseDisplayFields;
		}
	}

	public function setDisplayInterval(displayInterval) output=false {
		if ( isJSON(arguments.displayInterval) ) {
			arguments.displayInterval=deserializeJSON(arguments.displayInterval);
		}
		if ( !isSimpleValue(arguments.displayInterval) ) {
			if ( isValid('component',arguments.displayInterval) ) {
				arguments.displayInterval=arguments.displayInterval.getAllValues();
			} else if ( isdefined('arguments.displayInterval.endon') ) {
				arguments.displayInterval.endon=parseDateArg(arguments.displayInterval.endon);
			}
			if ( isDefined('arguments.displayInterval.end') ) {
				if ( arguments.displayInterval.end == 'on'
			and isDefined('arguments.displayInterval.endon')
			and isDate(arguments.displayInterval.endon) ) {
					if ( !isDate(getValue('displayStop')) ) {
						setValue('displayStop',arguments.displayInterval.endon);
					} else if ( dateFormat(getValue('displayStop'),'yyyymmdd') != dateFormat(arguments.displayInterval.endon,'yyyymmdd') ) {
						var current=getValue('displayStop');
						if ( isDate(current) ) {
							setValue('displayStop',createDateTime(year(arguments.displayInterval.endon), month(arguments.displayInterval.endon), day(arguments.displayInterval.endon), hour(current), minute(current), 0));
						} else {
							setValue('displayStop',arguments.displayInterval.endon);
						}
					}
				} else if ( arguments.displayInterval.end == 'after'
				and isDefined('arguments.displayInterval.endafter')
				and isNumeric(arguments.displayInterval.endafter)
				or arguments.displayInterval.end == 'never' ) {
					var tempdate=now();
					if(isDate(getValue('displayStop'))){
						var current=getValue('displayStop');
					} else {
						var current=tempdate;
					}
					setValue('displayStop',dateAdd('yyyy',100,createDateTime(year(tempdate), month(tempdate), day(tempdate), hour(current), minute(current), 0)));
				}
			}
			if ( isDefined('arguments.displayInterval.end') && arguments.displayInterval.end == 'on'
			and (!isDefined('arguments.displayInterval.endon') || !isDate(arguments.displayInterval.endon)) ) {
				writeDump( var=getValue('displayStart') );
				writeDump( var=arguments );
				setValue('displayStop',dateAdd('yyyy',100,now()));
				arguments.displayInterval.endon='never';
			}
			arguments.displayInterval=serializeJSON(arguments.displayInterval);
		}
		variables.instance.displayInterval=arguments.displayInterval;
		return this;
	}

	public function getDisplayIntervalDesc(showTitle="true") output=false {
		return getBean('settingsManager').getSite(getValue('siteid')).getContentRenderer().renderIntervalDesc(content=this,showTitle=arguments.showTitle);
	}

	public function getDisplayInterval(serialize="false") output=false {
		if ( !arguments.serialize ) {
			return getBean('contentDisplayInterval').set(getBean('contentIntervalManager').deserializeInterval(
			interval=variables.instance.displayInterval,
			displayStart=getValue('displayStart'),
			displayStop=getValue('displayStop')
		)).setContent(this);
		} else {
			return variables.instance.displayInterval;
		}
	}

	public function getDisplayConflicts() output=false {
		return getBean('contentIntervalManager').findConflicts(this);
	}

	public function getAvailableDisplayList() output=false {
		var returnList="";
		var i=0;
		var finder=0;
		var rsExtend=variables.configBean.getClassExtensionManager().getExtendedAttributeList(variables.instance.siteID,"tcontent");

		if ( variables.instance.type != "Gallery" ) {
			returnList="Date,Title,Image,Summary,Body,ReadMore,Credits,Comments,Tags,Rating";
		} else {
			returnList="Date,Title,Image,Summary,ReadMore,Credits,Comments,Tags,Rating";
		}
		if ( rsExtend.recordcount ) {
			var qs=getQueryService();
			qs.setDbType('query');
			qs.setAttributes(rsExtend=rsExtend);

			rsExtend=qs.execute(sql="select attribute from rsExtend
				group by attribute
				order by attribute").getResult();

			returnList=returnList & "," & valueList(rsExtend.attribute);
		}

		for(i in listToArray(variables.instance.responseDisplayFields)){
			finder=listFindNoCase(returnList,i);
			if (finder){
				returnList=listDeleteAt(returnList,finder);
			}
		}

		return returnList;
	}

	public function removeCategory(required categoryID="", required name="") output=false {
		setCategory(arguments.categoryid,'');
		return this;
	}

	public function setCategory(required categoryID="", required membership="0", required featureStart="", required featureStop="", required name="") output=false {
		if ( len(arguments.name) ) {
			arguments.categoryid=getBean('category').loadBy(name=arguments.name,siteid=getValue('siteid')).getCategoryID();
		} else if ( len(arguments.categoryid) && !isValid('uuid',arguments.categoryid) ) {
			arguments.categoryid=getBean('category').loadBy(name=arguments.categoryid,siteid=getValue('siteid')).getCategoryID();
		}
		if ( isDefined('arguments.isFeature') ) {
			arguments.membership=arguments.isFeature;
		}
		var catTrim=replace(arguments.categoryID,'-','','ALL');
		variables.instance["categoryAssign#catTrim#"]=arguments.membership;
		if ( isNumeric(arguments.membership) ) {
			if ( !listFind(variables.instance.categoryID,arguments.categoryID) ) {
				variables.instance.categoryID=listAppend(variables.instance.categoryID,arguments.categoryID);
			}
		} else {
			var catPOS=listFind(variables.instance.categoryID,arguments.categoryID);
			if ( catPOS ) {
				variables.instance.categoryID=listDeleteAt(variables.instance.categoryID,catPOS);
			}
		}
		if ( arguments.membership == "2" ) {
			if ( isdate(arguments.featureStart) ) {
				variables.instance['featureStart#catTrim#']=arguments.featureStart;
				variables.instance['startDayPart#catTrim#']=timeFormat(arguments.featureStart,"tt");
				variables.instance['starthour#catTrim#']=hour(arguments.featureStart);
				if ( variables.instance['startDayPart#catTrim#'] == 'pm' ) {
					variables.instance['starthour#catTrim#']=variables.instance['starthour#catTrim#']-12;
				}
				variables.instance['startMinute#catTrim#']=minute(arguments.featureStart);
			} else {
				variables.instance["categoryAssign#catTrim#"]=1;
			}
			if ( isdate(arguments.featureStop) ) {
				variables.instance['featureStop#catTrim#']=arguments.featureStop;
				variables.instance['stopDayPart#catTrim#']=timeFormat(arguments.featureStop,"tt");
				variables.instance['stophour#catTrim#']=hour(arguments.featureStop);
				if ( variables.instance['stopDayPart#catTrim#'] == 'pm' ) {
					variables.instance['stophour#catTrim#']=variables.instance['stophour#catTrim#']-12;
				}
				variables.instance['stopMinute#catTrim#']=minute(arguments.featureStop);
			} else {
				variables.instance['featureStop#catTrim#']="";
				variables.instance['stopDayPart#catTrim#']="";
				variables.instance['stophour#catTrim#']="";
				variables.instance['stopMinute#catTrim#']="";
			}
		}
		return this;
	}

	public function setCategories(required categoryList="", required membership="0", required featureStart="", required featureStop="") output=false {
		var cat = "";

		for(cat in ListToArray(arguments.categoryList)){
			setCategory(
				cat,
				arguments.membership,
				arguments.featureStart,
				arguments.featureStop
			);
		}

		return this;
	}

	public function setAllValues(instance) output=false {
		super.setAllValues(argumentCollection=arguments);
		variables.displayRegions=structNew();
		return this;
	}

	public function getHTMLTitle() output=false {
		if ( len(variables.instance.HTMLTitle) ) {
			return variables.instance.HTMLTitle;
		} else {
			return variables.instance.MenuTitle;
		}
	}

	public function getKidsQuery(required aggregation="false", required applyPermFilter="false", required size="0", required sortBy="#getValue('sortBy')#", required sortDirection="#getValue('sortDirection')#", required nextN="#getValue('nextN')#", today=now(), categoryid='', useCategoryIntersect=false ) output=false {
		arguments.parentid=getContentID();
		arguments.siteid=getValue('siteid');
		return variables.contentManager.getKidsQuery(argumentCollection=arguments);
	}

	public function getKidsIterator(required liveOnly="true", required aggregation="false", required applyPermFilter="false", required size="0", required sortBy="#getValue('sortBy')#", required sortDirection="#getValue('sortDirection')#", required nextN="#getValue('nextN')#", today=now(), categoryid='', useCategoryIntersect=false)output=false {
		var q="";

		var it=getBean("contentIterator");
		if ( arguments.liveOnly ) {
			q=getKidsQuery(argumentCollection=arguments);
		} else {
			arguments.parentid=getContentID();
			arguments.siteid=getValue('siteid');
			q=variables.contentManager.getNest(argumentCollection=arguments);
		}
		it.setQuery(q,variables.instance.nextn);
		return it;
	}

	public function getEventsQuery() output=false {
		if ( getValue('type') != 'Calendar' ) {
			throw( message="The method is only for calendars" );
		}
		arguments.calendarid=getValue('contentid');
		arguments.siteid=getValue('siteid');
		return getBean('$')
		.init(getValue('siteid'))
		.getCalendarUtility()
		.getCalendarItems(argumentCollection=arguments);
	}

	public function getEventsIterator() {

		var q = getEventsQuery(argumentCollection=arguments);
		var it = getBean('contentIterator').init();
		it.setQuery(q);
		return it;
	}

	public function getKidsCategoryQuery(siteid="#variables.instance.siteID#", parentid="#getContentID()#", categoryid="", categorypathid="") output=false {
		return variables.contentManager.getCategoriesByParentID(argumentCollection=arguments);
	}

	public function getKidsCategoryIterator() {

		var q = getKidsCategoryQuery(argumentCollection=arguments);
		var it = getBean('categoryIterator').init();
		it.setQuery(q);
		return it;
	}

	public function getVersionHistoryQuery() output=false {
		return variables.contentManager.getHist(getContentID(), variables.instance.siteID);
	}

	public function getVersionHistoryIterator() output=false {
		var q=getVersionHistoryQuery();
		var it=getBean("contentIterator");
		it.setQuery(q);
		return it;
	}

	public function getCategoriesQuery() output=false {
		return variables.contentManager.getCategoriesByHistID(getContentHistID());
	}

	public function getCategoriesIterator() output=false {
		var q=getCategoriesQuery();
		var it=getBean("categoryIterator").init();
		it.setQuery(q);
		return it;
	}

	public function getRelatedContentQuery(required boolean liveOnly="true", required date today="#now()#", string sortBy="orderno", string sortDirection="asc", string relatedContentSetID="", string name="", boolean reverse="false", required boolean navOnly="false", required any cachedWithin="#createTimeSpan(0,0,0,0)#") output=false {
		return variables.contentManager.getRelatedContent(variables.instance.siteID, getContentHistID(), arguments.liveOnly, arguments.today, arguments.sortBy, arguments.sortDirection, arguments.relatedContentSetID, arguments.name, arguments.reverse, getContentID(),arguments.navOnly,arguments.cachedWithin,'',this);
	}

	public function getRelatedContentIterator(required boolean liveOnly="true", required date today="#now()#", string sortBy="orderno", string sortDirection="asc", string relatedContentSetID="", string name="", boolean reverse="false", required boolean navOnly="false", required any cachedWithin="#createTimeSpan(0,0,0,0)#",entitytype="content") output=false {
		return variables.contentManager.getRelatedContentIterator(variables.instance.siteID, getContentHistID(), arguments.liveOnly, arguments.today, arguments.sortBy, arguments.sortDirection, arguments.relatedContentSetID, arguments.name, arguments.reverse, getContentID(),arguments.navOnly,arguments.cachedWithin,'',this);
	}


	public function save() output=false {
		var obj="";
		var i="";
		setAllValues(variables.contentManager.save(this).getAllValues());
		return this;
	}

	public function addObject(obj) output=false {
		arguments.obj.setSiteID(variables.instance.siteID);
		arguments.obj.setContentID(getContentID());
		arguments.obj.setContentHistID(getContentHistID());
		arguments.obj.setModuleID(variables.instance.moduleID);
		arrayAppend(variables.instance.addObjects,arguments.obj);
		return this;
	}

	public function addChild(child) output=false {
		arguments.child.setSiteID(variables.instance.siteID);
		arguments.child.setParentID(getContentID());
		arguments.child.setModuleID(variables.instance.moduleID);
		arrayAppend(variables.instance.addObjects,arguments.child);
		return this;
	}

	/**
	 * This is used when content nodes are configurable as display objects
	 */
	public function setObjectParams(objectParams) output=false {
		if ( isSimpleValue(arguments.objectParams) && len(arguments.objectParams) && isJSON(arguments.objectParams) ) {
			var val=deserializeJSON(arguments.objectParams);
			if ( isStruct(val) ) {
				variables.instance.objectParams=val;
			}
		} else if ( !isSimpleValue(arguments.objectParams) ) {
			variables.instance.objectParams=arguments.objectParams;
		}
		return this;
	}

	/**
	 * This is used when content nodes are configurable as display objects
	 */
	public function getObjectParams(serialize="false") output=false {
		if ( arguments.serialize ) {
			return serializeJSON(variables.instance.objectParams);
		} else {
			return variables.instance.objectParams;
		}
	}

	/**
	 * This is used when content nodes are configurable as display objects
	 */
	public function getObjectParam(param, defaultValue) output=false {
		var val=getValue('param');
		if ( len(val) ) {
			return val;
		} else {
			var params=getObjectParams();
			if ( structKeyExists(params,arguments.param) ) {
				return params['#arguments.param#'];
			} else if ( isDefined('arguments.defaultValue') ) {
				return arguments.defaultValue;
			} else {
				return '';
			}
		}
	}

	public function addDisplayObject(regionID, object, objectID, name, params="", orderno="") output=false {
		var rs=getDisplayRegion(arguments.regionID);
		var rows=0;
		var i=1;

		if ( isNumeric(arguments.orderno) ) {

			if(rs.recordcount){
				for(i=1;i <= rs.recordcount;i++){
					if (rs.objectID eq arguments.objectID
						and rs.object eq arguments.object
						and rs.orderno eq arguments.orderno){
						 querysetcell(rs,"objectid",arguments.objectID,rs.currentrow);
						querysetcell(rs,"object",arguments.object,rs.currentrow);
						querysetcell(rs,"name",arguments.name,rs.currentrow);
						querysetcell(rs,"params",arguments.params,rs.currentrow);
						variables.instance.extendAutoComplete = true;
						return this;
					}
				}
			}
		}

		if ( !hasDisplayObject(argumentCollection=arguments) ) {
			queryAddRow(rs,1);
			rows =rs.recordcount;
			querysetcell(rs,"objectid",arguments.objectID,rows);
			querysetcell(rs,"object",arguments.object,rows);
			querysetcell(rs,"name",arguments.name,rows);
			querysetcell(rs,"params",arguments.params,rows);
			variables.instance.extendAutoComplete = true;
		}
		return this;
	}

	public function removeDisplayObject(regionID, object, objectID) output=false {
		var rs=getDisplayRegion(arguments.regionID);
		var rows=0;

		if ( hasDisplayObject(argumentCollection=arguments) ) {
			var qs=getQueryService();
			qs.setDbType('query');
			qs.setAttributes(rs=rs);

			variables["displayRegions.objectlist#arguments.regionID#"]=qs.execute(sql="select * from rs where
				not (objectID='#arguments.objectID#'
				and object='#arguments.object#')").getResult();

			variables.instance.extendAutoComplete = true;
		}
		return this;
	}

	public boolean function hasDisplayObject(regionID, object, objectID) output=false {
		var rs=getDisplayRegion(arguments.regionID);
		var qs=getQueryService();

		qs.setDbType('query');
		qs.setAttributes(rs=rs);

		rs=qs.execute(sql="select * from rs where
		objectID='#arguments.objectID#'
		and object='#arguments.object#'").getResult();

		return rs.recordcount;
	}

	public function getDisplayRegion(regionID) output=false {
		var rs="";
		if ( !structKeyExists(variables.displayRegions,"objectlist#arguments.regionID#") ) {
			variables.displayRegions["objectlist#arguments.regionID#"]=variables.contentManager.getRegionObjects(getContentHistID(), variables.instance.siteID, arguments.regionID);
		}
		return variables.displayRegions["objectlist#arguments.regionID#"];
	}

	public function deleteVersion() output=false {
		if ( !getValue('active') ) {
			variables.contentManager.delete(getAllValues());
			return true;
		} else {
			return false;
		}
	}

	public function deleteVersionHistory() output=false {
		variables.contentManager.deleteHistAll(getAllValues());
	}

	public function delete() output=false {
		variables.contentManager.deleteAll(getAllValues());
	}

	public function loadBy() output=false {
		if ( !structKeyExists(arguments,"siteID") ) {
			arguments.siteID=variables.instance.siteID;
		}
		arguments.contentBean=this;
		return variables.contentManager.read(argumentCollection=arguments);
	}

	public function getStats() output=false {
		var statsBean=getBean("stats");
		statsBean.setSiteID(variables.instance.siteID);
		statsBean.setContentID(getContentID());
		statsBean.load();
		return statsBean;
	}

	public function getCommentsQuery(required boolean isEditor="false", required string sortOrder="asc", required string parentID="") output=false {
		return variables.contentManager.readComments(getContentID(), variables.instance.siteID, arguments.isEditor, arguments.sortOrder, arguments.parentID);
	}

	public function getCommentsIterator(required boolean isEditor="false", required string sortOrder="asc", required string parentID="") output=false {
		var q=getCommentsQuery(arguments.isEditor, arguments.sortOrder, arguments.parentID);
		var it=getBean("contentCommentIterator");
		it.setQuery(q);
		return it;
	}

	public function getParent() output=false {
		if ( getContentID() != '00000000000000000000000000000000001' ) {
			return variables.contentManager.read(contentID=variables.instance.parentID,siteID=variables.instance.siteID);
		} else {
			throw( message="Parent content does not exist." );
		}
	}

	public function getCrumbArray(required sort="asc", required boolean setInheritance="false") output=false {
		if ( getValue('isNew') && getValue('contentid') != '00000000000000000000000000000000001' ) {
			return variables.contentManager.getCrumbList(contentID=variables.instance.parentid, siteID=variables.instance.siteID, setInheritance=arguments.setInheritance, sort=arguments.sort);
		} else {
			return variables.contentManager.getCrumbList(contentID=getContentID(), siteID=variables.instance.siteID, setInheritance=arguments.setInheritance, path=variables.instance.path, sort=arguments.sort);
		}
	}

	public function getCrumbIterator(required sort="asc", required boolean setInheritance="false") output=false {
		var a=getCrumbArray(setInheritance=arguments.setInheritance,sort=arguments.sort);
		var it=getBean("contentIterator");
		it.setArray(a);
		return it;
	}

	public function hasDrafts() output=false {
		return variables.contentManager.getHasDrafts(getContentID(),variables.instance.siteID);
	}

	public function getURL(required querystring="", required boolean complete="false", required string showMeta="0", required string secure="0") output=false {
		return variables.contentManager.getURL(this, arguments.queryString,arguments.complete, arguments.showMeta,arguments.secure);
	}

	public function getAssocURL() output=false {
		if ( variables.instance.type == 'Link' ) {
			return variables.instance.body;
		} else {
			return variables.contentManager.getURL(this,'',true);
		}
	}

	public function setBody(body) output=false {
		if ( getValue('type') == 'Variation' ) {
			if ( !isSimpleValue(arguments.body) ) {
				arguments.body=serializeJSON(arguments.body);
			}
			if ( !isJSON(arguments.body) ) {
				arguments.body=urlDecode(arguments.body);
				if ( !isJSON(arguments.body) ) {
					arguments.body="[]";
				}
			}
		}
		variables.instance.body=arguments.body;
		return this;
	}

	public function setAssocURL(assocURL) output=false {
		if ( variables.instance.type == 'Link' ) {
			variables.instance.body=arguments.assocURL;
		}
		return this;
	}

	//This is duplicated in the contentNavBean
	public function getEditUrl(required boolean compactDisplay="false", tab, required complete="false", required hash="false", required instanceid='') output=false {
		var returnStr="";
		var topID="00000000000000000000000000000000001";
		if ( listFindNoCase("Form,Component", getValue('type')) ) {
			topID=getValue('moduleid');
		}
		if ( arguments.compactDisplay ) {
			arguments.compactDisplay='true';
		}

		if(len(arguments.instanceid)){
			returnStr= "#getBean('configBean').getAdminPath(complete=arguments.complete)#/?muraAction=cArch.editLive&contentId=#esapiEncode('url',getValue('contentid'))#&type=#esapiEncode('url',getValue('type'))#&siteId=#esapiEncode('url',getValue('siteid'))#&instanceid=#esapiEncode('url',arguments.instanceid)#&compactDisplay=#esapiEncode('url',arguments.compactdisplay)#";
		} else {
			returnStr= "#getBean('configBean').getAdminPath(complete=arguments.complete)#/?muraAction=cArch.edit&contenthistid=#esapiEncode('url',getValue('contenthistid'))#&contentid=#esapiEncode('url',getValue('contentid'))#&type=#esapiEncode('url',getValue('type'))#&siteid=#esapiEncode('url',getValue('siteid'))#&topid=#esapiEncode('url',topID)#&parentid=#esapiEncode('url',getValue('parentid'))#&moduleid=#esapiEncode('url',getValue('moduleid'))#&compactdisplay=#esapiEncode('url',arguments.compactdisplay)#";
		}

		if ( structKeyExists(arguments,"tab") ) {
			returnStr=returnStr & "##" & arguments.tab;
		}
		if ( arguments.hash ) {
			var redirectid=getBean('utility').createRedirectId(returnStr);
			returnStr=getBean('settingsManager').getSite(getValue('siteid')).getContentRenderer().createHREF(complete=arguments.complete,filename=redirectid);
		}
		return returnStr;
	}

	public function hasParent() output=false {
		return listLen(variables.instance.path) > 1;
	}

	public function getIsOnDisplay() output=false {

		var nowAdjusted='';

		if(request.muraChangesetPreview){
			nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate;
		}

		if(isDate(request.muraPointInTime)){
			nowAdjusted=request.muraPointInTime;
		}

		if(not isdate(nowAdjusted)){
			nowAdjusted=now();
		}

		return variables.instance.display == 1 or
			(
				variables.instance.display == 2 && variables.instance.displayStart <= nowAdjusted
				AND (variables.instance.displayStop == "" || variables.instance.displayStop >= nowAdjusted)
			)
			and (listFind("Page,Folder,Gallery,File,Calendar,Link,Form",variables.instance.type) || listFind(variables.instance.moduleAssign,'00000000000000000000000000000000000'));
	}

	public function getImageURL(required size="undefined", direct="true", complete="false", height="", width="", defaultURL="", useProtocol="true", secure="false") {
		arguments.bean=this;
		if(isDefined('arguments.default')){
			arguments.defaultURL=arguments.default;
		}
		return variables.contentManager.getImageURL(argumentCollection=arguments);
	}

	public function clone() {
		return getBean("content").setAllValues(structCopy(getAllValues()));
	}

	public function getExtendBaseID() {
		return getContentHistID();
	}

	public function requiresApproval(applyExemptions="true") {
		var crumbs=getCrumbIterator();
		var crumb="";
		var chain="";
		var i="";
		var permUtility=getBean('permUtility');
		var sessionData=getSession();
		var privateUserPool=getBean('settingsManager').getSite(getValue('siteid')).getPrivateUserPoolID();
		if ( !arguments.applyExemptions || !( permUtility.isS2() || permUtility.isUserInGroup('admin',privateUserPool,0) ) ) {
			while ( crumbs.hasNext() ) {
				crumb=crumbs.next();
				if ( len(crumb.getChainID()) ) {
					chain=getBean('approvalChain').loadBy(chainID=crumb.getChainID());
					if ( !chain.getIsNew() ) {
						if ( arguments.applyExemptions && len(crumb.getExemptID()) && isdefined('sessionData.mura.membershipids') ) {

							for(i in ListToArray(crumb.getExemptID())){
								if (listFind(sessionData.mura.membershipids,i)){
									return false;
								}
							}

						}
						setValue('chainID',crumb.getChainID());
						return true;
					}
				}
			}
		}
		return false;
	}

	public function getApprovalRequest() output=false {
		return getBean('approvalRequest').loadBy(contenthistid=getValue('contenthistid'),chainID=getValue('chainID'),siteID=getValue('siteID'));
	}

	public function getSource() output=false {
		var map=getBean('contentSourceMap').loadBy(contenthistid=getValue('contenthistID'),siteid=getValue('siteid'));
		var source=map.getSource();
		if ( source.getIsNew() && !map.getIsNew() ) {
			while ( source.getIsNew() && !map.getIsNew() ) {
				map=getBean('contentSourceMap').loadBy(contenthistid=map.getSourceID(),siteid=map.getSiteID());
				source=map.getSource();
			}
		}
		return source;
	}

	public function getUser() output=false {
		return getBean('user').loadBy(userID=getValue('LastUpdateByID'));
	}

	public function getClassExtension() output=false {
		return variables.configBean.getClassExtensionManager().getSubTypeByName(getValue('type'),getValue('subtype'),getValue('siteid'));
	}

	public function getFileMetaData(property="fileid") output=false {
		return getBean('fileMetaData').loadBy(contentid=getValue('contentid'),contentHistID=getValue('contentHistID'),siteID=getValue('siteid'),fileid=getValue(arguments.property));
	}

	public function setRelatedContentID(required contentIDs="", relatedContentSetID="", name="") output=false {
		var relatedContentSets = variables.configBean.getClassExtensionManager().getSubTypeByName(variables.instance.type, variables.instance.subtype, variables.instance.siteid).getRelatedContentSets();
		var rcs = "";
		var i = "";
		var q = "";
		var qi = "";
		variables.instance.relatedContentSetData = arrayNew(1);
		for ( i=1 ; i<=arrayLen(relatedContentSets) ; i++ ) {
			rcs = structNew();
			rcs.items = arrayNew(1);
			rcs.relatedContentSetID = relatedContentSets[i].getRelatedContentSetID();
			q = relatedContentSets[i].getRelatedContentQuery(getValue('contentHistID'));

			if(q.recordcount){
				for(qi=1;qi <= q.recordcount;qi++){
					arrayAppend(rcs.items, q.contentID);
				}
			}

			arrayAppend(variables.instance.relatedContentSetData, rcs);
		}
		rcs = structNew();
		rcs.items = arrayNew(1);
		rcs.relatedContentSetID = "00000000000000000000000000000000000";

		for(i in listToArray(arguments.contentIDs)){
			arrayAppend(rcs.items, i);
		}

		if ( len(arguments.relatedContentSetID) ) {
			rcs.relatedContentSetID = arguments.relatedContentSetID;
		} else if ( len(arguments.name) ) {
			for ( i=1 ; i<=arrayLen(relatedContentSets) ; i++ ) {
				if ( relatedContentSets[i].getName() == trim(arguments.name) ) {
					rcs.relatedContentSetID = relatedContentSets[i].getRelatedContentSetID();
				}
			}
		}
		for ( i=1 ; i<=arrayLen(variables.instance.relatedContentSetData) ; i++ ) {
			if ( variables.instance.relatedContentSetData[i].relatedContentSetID == rcs.relatedContentSetID ) {
				variables.instance.relatedContentSetData[i] = rcs;
			}
		}
	}

	public function hasImage(usePlaceholder="true") {
		return variables.contentManager.hasImage(bean=this,usePlaceholder=arguments.usePlaceholder);
	}

	public function getStatusID() output=false {
		var statusid = '';
		if ( variables.instance.active > 0 && variables.instance.approved > 0 ) {
			//  2: Published
			statusid = 2;
		} else if ( len(variables.instance.approvalstatus) && requiresApproval() ) {
			//  1: Pending Approval
			statusid = 1;
		} else if ( variables.instance.approved < 1 ) {
			//  0: Draft
			statusid = 0;
		} else {
			//  3: Archived
			statusid = 3;
		}
		return statusid;
	}

	public function getStatus() output=false {
		var status = '';
		var sessionData=getSession();
		param name="sessionData.rb" default="en_US";
		switch ( getStatusID() ) {
			case  0:
				status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.draft");
				break;
			case  1:
				status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.#variables.instance.approvalstatus#");
				break;
			case  2:
				status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.published");
				break;
			default:
				status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.archived");
				break;
		}

		return status;
	}

	public boolean function getIsHome() {
		return Right(variables.instance.parentid, 3) == 'end';
	}

	public numeric function getDepth() {
		return ListLen(variables.instance.path) - 1;
	}

	function setCanonicalURL(CanonicalURL){
		if(isValid('URL',arguments.canonicalURL) || !len(arguments.canonicalURL)){
			variables.instance.metakeywords=arguments.canonicalURL;
		}

		return this;
	}

	function getCanonicalURL(CanonicalURL){
		if(isValid('URL',variables.instance.metakeywords)){
			return variables.instance.metakeywords;
		} else {
			return '';
		}
	}

	function getMetaKeywords(conditional=true){
		if(!arguments.conditional || !isValid('URL',variables.instance.metakeywords)){
			return variables.instance.metakeywords;
		} else {
			return '';
		}
	}

}
