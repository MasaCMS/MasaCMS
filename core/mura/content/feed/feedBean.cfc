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
 * This provides content feed bean functionality
 */
component extends="mura.bean.beanFeed" entityName="feed" table="tcontentfeeds" output="false" hint="This provides content feed bean functionality" {
	property name="feedID" fieldtype="id" type="string" default="";
	property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";
	property name="dateCreated" type="date" default="";
	property name="lastUpdate" type="date" default="";
	property name="lastUpdateBy" type="string" default="";
	property name="name" type="string" default="";
	property name="altName" type="string" default="";
	property name="lang" type="string" default="en-us" required="true";
	property name="isActive" type="numeric" default="1" required="true";
	property name="showNavOnly" type="numeric" default="1" required="true";
	property name="showExcludeSearch" type="numeric" default="0" required="true";
	property name="isPublic" type="numeric" default="0" required="true";
	property name="isDefault" type="numeric" default="0" required="true";
	property name="description" type="string" default="";
	property name="contentID" type="string" default="";
	property name="categoryID" type="string" default="";
	property name="maxItems" type="numeric" default="20" required="true";
	property name="allowHTML" type="numeric" default="1" required="true";
	property name="isFeaturesOnly" type="numeric" default="0" required="true";
	property name="featureType" type="string" default="either";
	property name="restricted" type="numeric" default="0" required="true";
	property name="restrictGroups" type="string" default="";
	property name="version" type="string" default="RSS 2.0" required="true";
	property name="channelLink" type="string" default="";
	property name="authtype" type="string" default="DEFAULT";
	property name="type" type="string" default="local" required="true";
	property name="sortBy" type="string" default="lastUpdate" required="false";
	property name="sortDirection" type="string" default="desc" required="true";
	property name="parentID" type="string" default="";
	property name="nextN" type="numeric" default="20" required="true";
	property name="displayName" type="numeric" default="0" required="true";
	property name="displayRatings" type="numeric" default="0" required="true";
	property name="displayComments" type="numeric" default="0" required="true";
	property name="displayKids" type="numeric" default="0" required="true";
	property name="isNew" type="numeric" default="0" required="true" persistent="false";
	property name="params" type="query" default="" persistent="false";
	property name="remoteID" type="string" default="";
	property name="remoteSourceURL" type="string" default="";
	property name="remotePubDAte" type="string" default="";
	property name="imageSize" type="string" default="small" required="true";
	property name="imageHeight" type="string" default="AUTO" required="true";
	property name="imageWidth" type="string" default="AUTO" required="true";
	property name="displayList" type="string" default="Title,Date,Image,Summary,Tags,Credits" required="true";
	property name="liveOnly" type="numeric" default="1" required="true";
	property name="entityName" type="string" default="content";
	property name="viewalllabel" type="string" default="";
	property name="viewalllink" type="string" default="View All";
	property name="autoimport" type="numeric" default="0" required="true";
	property name="isLocked" type="numeric" default="0" required="true";
	property name="cssClass" type="string" default="";
	property name="useCategoryIntersect" type="numeric" default="0";
	property name="altTable" type="string" default="";
	property name="contentpoolid" type="string" default="";
	property name="includeHomePage" type="numeric" default="0";
	variables.primaryKey = 'feedid';
	variables.entityName = 'feed';

	public function init() output=false {
		super.init(argumentCollection=arguments);
		variables.instance.feedID="";
		variables.instance.siteID="";
		variables.instance.dateCreated="#now()#";
		variables.instance.lastUpdate="#now()#";
		variables.instance.lastUpdateBy="";
		variables.instance.name="";
		variables.instance.altName="";
		variables.instance.Lang="en-us";
		variables.instance.isActive=1;
		variables.instance.showNavOnly=1;
		variables.instance.showExcludeSearch=0;
		variables.instance.isPublic=0;
		variables.instance.isDefault=0;
		variables.instance.description="";
		variables.instance.contentID="";
		variables.instance.categoryID="";
		variables.instance.MaxItems=20;
		variables.instance.allowHTML=1;
		variables.instance.isFeaturesOnly=0;
		variables.instance.featureType='either';
		variables.instance.restricted=0;
		variables.instance.restrictGroups="";
		variables.instance.Version="RSS 2.0";
		variables.instance.ChannelLink="";
		variables.instance.authtype="DEFAULT";
		variables.instance.type="local";
		variables.instance.sortBy="lastUpdate";
		variables.instance.sortDirection="desc";
		variables.instance.parentID="";
		variables.instance.nextN=20;
		variables.instance.displayName=0;
		variables.instance.displayRatings=0;
		variables.instance.displayComments=0;
		variables.instance.displaySummaries=1;
		variables.instance.displayKids=0;
		variables.instance.isNew=1;
		variables.instance.params=queryNew("feedID,param,relationship,field,condition,criteria,dataType","varchar,integer,varchar,varchar,varchar,varchar,varchar" );
		variables.instance.errors=structnew();
		variables.instance.remoteID = "";
		variables.instance.remoteSourceURL = "";
		variables.instance.remotePubDate = "";
		variables.instance.imageSize="small";
		variables.instance.imageHeight="AUTO";
		variables.instance.imageWidth="AUTO";
		variables.instance.displayList="Date,Title,Image,Summary,Credits,Tags";
		variables.instance.liveOnly=1;
		variables.instance.activeOnly=1;
		variables.instance.entityName="content";
		variables.instance.table="tcontent";
		variables.instance.viewalllink="";
		variables.instance.viewalllabel="";
		variables.instance.autoimport=0;
		variables.instance.isLocked=0;
		variables.instance.cssClass="";
		variables.instance.useCategoryIntersect=0;
		variables.instance.altTable="";
		variables.instance.contentpoolid="";
		variables.instance.fieldAliases={'tag'={field='tcontenttags.tag',datatype='varchar'},'taggroup'={field='tcontenttags.taggroup',datatype='varchar'}};
		variables.instance.cachedWithin=createTimeSpan(0,0,0,0);
		variables.instance.includeHomePage=0;
		return this;
	}

	public function setFeedManager(feedManager) {
		variables.feedManager=arguments.feedManager;
		return this;
	}

	public function set(required property, propertyValue) output=false {
		if ( !isDefined('arguments.feed') ) {
			if ( isSimpleValue(arguments.property) ) {
				return setValue(argumentCollection=arguments);
			}
			arguments.feed=arguments.property;
		}
		var prop="";
		if ( isQuery(arguments.feed) && arguments.feed.recordcount ) {
			for(prop in listToArray(arguments.feed.columnlist)){
				setValue(prop,arguments.feed[prop][1]);
			}

		} else if ( isStruct(arguments.feed) ) {
			for ( prop in arguments.feed ) {
				setValue(prop,arguments.feed[prop]);
			}
			setAdvancedParams(arguments.feed);
		}
		return this;
	}

	public function type(String type) output=false {
		variables.instance.type = arguments.type;
		return this;
	}

	public function setDateCreated(String dateCreated) output=false {
		variables.instance.dateCreated = parseDateArg(arguments.dateCreated);
		return this;
	}

	public function setLastUpdate(String lastUpdate) output=false {
		variables.instance.lastUpdate = parseDateArg(arguments.lastUpdate);
		return this;
	}

	public function setContentID(String contentID, required boolean append="false") output=false {
		var i="";
		if ( !arguments.append ) {
			variables.instance.contentID = trim(arguments.contentID);
		} else {
			for(i in listToArray(arguments.contentID)){
				if(not listFindNoCase(variables.instance.contentID,trim(i))){
			    	variables.instance.contentID = listAppend(variables.instance.contentID,trim(i));
				}
			}
		}
		return this;
	}

	public function removeContentID(String contentID) output=false {
		var i=0;
		var offset=0;
		if ( len(arguments.contentID) ) {
			for ( i=1 ; i<=listLen(arguments.contentID) ; i++ ) {
				if ( listFindNoCase(variables.instance.contentID,listGetAt(arguments.contentID,i)) ) {
					variables.instance.contentID = listDeleteAt(variables.instance.contentID,i-offset);
					offset=offset+1;
				}
			}
		}
		return this;
	}

	public function getContentPoolID() output=false {
		if ( !len(variables.instance.contentpoolid) ) {
			variables.instance.contentpoolid=variables.instance.siteid;
		} else if ( variables.instance.contentpoolid == '*' ) {
			variables.instance.contentpoolid=getBean('settingsManager').getSite(variables.instance.siteid).getContentPoolID();
		}
		return variables.instance.contentpoolid;
	}

	public function setCategoryID(String categoryID, required boolean append="false") output=false {
		var i="";
		if ( !arguments.append ) {
			variables.instance.categoryID = trim(arguments.categoryID);
		} else {

			for(i in ListToArray(arguments.categoryID)){
				if (not listFindNoCase(variables.instance.categoryID,trim(i))){
			    	variables.instance.categoryID = listAppend(variables.instance.categoryID,trim(i));
			  }
			}

		}
		return this;
	}

	public function removeCategoryID(String categoryID) output=false {
		var i=0;
		var offset=0;
		if ( len(arguments.categoryID) ) {
			for ( i=1 ; i<=listLen(arguments.categoryID) ; i++ ) {
				if ( listFindNoCase(variables.instance.categoryID,listGetAt(arguments.categoryID,i)) ) {
					variables.instance.categoryID = listDeleteAt(variables.instance.categoryID,i-offset);
					offset=offset+1;
				}
			}
		}
		return this;
	}

	public function setDisplayName(any DisplayName) output=false {
		if ( isBoolean(arguments.DisplayName) ) {
			if(arguments.DisplayName){
				variables.instance.DisplayName = 1;
			} else {
				variables.instance.DisplayName = 0;
			}
		}
		return this;
	}

	public function setDisplayRatings(any DisplayRatings) output=false {
		if ( isBoolean(arguments.DisplayRatings) ) {
			if(arguments.DisplayRatings){
				variables.instance.DisplayRatings = 1;
			} else {
				variables.instance.DisplayRatings = 0;
			}
		}
		return this;
	}

	public function setDisplayComments(any DisplayComments) output=false {
		if ( isBoolean(arguments.DisplayComments) ) {
			if(arguments.DisplayComments){
				variables.instance.DisplayComments = 1;
			} else {
				variables.instance.DisplayComments = 0;
			}
		}
		return this;
	}

	public function setDisplayKids(any DisplayKids) output=false {
		if ( isBoolean(arguments.DisplayKids) ) {
			if(arguments.DisplayKids){
				variables.instance.DisplayKids = 1;
			} else {
				variables.instance.DisplayKids = 0;
			}
		}
		return this;
	}

	public function setIncludeHomePage(any includeHomePage) output=false {
		if ( isBoolean(arguments.includeHomePage) ) {
			if(arguments.includeHomePage){
				variables.instance.includeHomePage = 1;
			} else {
				variables.instance.includeHomePage = 0;
			}
		}
		return this;
	}

	public function includeHomePage(any value) output=false {
		return setIncludeHomePage(arguments.value);
	}

	public function contentPools(any value) output=false {
		return set('contentPoolID', arguments.value);
	}

	public function altTable(any value) output=false {
		return setAltTable(arguments.value);
	}

	public function isFeaturesOnly(any value) output=false {
		return set('isFeaturesOnly', arguments.value);
	}

	public function setLiveOnly(any liveOnly) output=false {
		if ( isBoolean(arguments.liveOnly) ) {
			if(arguments.liveOnly){
				variables.instance.liveOnly = 1;
			} else {
				variables.instance.liveOnly = 0;
			}
		}
		return this;
	}

	public function liveOnly(any value) output=false {
		return setLiveOnly(arguments.value);
	}

	public function setShowNavOnly(any showNavOnly) output=false {
		if ( isBoolean(arguments.showNavOnly) ) {
			if(arguments.showNavOnly){
				variables.instance.showNavOnly = 1;
			} else {
				variables.instance.showNavOnly = 0;
			}
		}
		return this;
	}

	public function showNavOnly(any value) output=false {
		return setShowNavOnly(arguments.value);
	}

	public function setIsLocked(any isLocked) output=false {
		if ( isBoolean(arguments.isLocked) ) {
			if(arguments.isLocked){
				variables.instance.isLocked = 1;
			} else {
				variables.instance.isLocked = 0;
			}
		}
		return this;
	}

	public function setUseCategoryIntersect(any useCategoryIntersect) output=false {
		if ( isBoolean(arguments.useCategoryIntersect) ) {
			if(arguments.useCategoryIntersect){
				variables.instance.useCategoryIntersect = 1;
			} else {
				variables.instance.useCategoryIntersect = 0;
			}
		}
		return this;
	}

	public function useCategoryIntersect(any value) output=false {
		return setUseCategoryIntersect(arguments.value);
	}

	public function setShowExcludeSearch(any showExcludeSearch) output=false {
		if ( isBoolean(arguments.showExcludeSearch) ) {
			if(arguments.showExcludeSearch){
				variables.instance.showExcludeSearch = 1;
			} else {
				variables.instance.showExcludeSearch = 0;
			}
		}
		return this;
	}

	public function showExcludeSearch(any value) output=false {
		return setShowExcludeSearch(arguments.value);
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

	public function setAutoImport(required autoimport) output=false {
		if ( isBoolean(arguments.autoimport) ) {
			if(arguments.autoimport){
				variables.instance.autoimport = 1;
			} else {
				variables.instance.autoimport = 0;
			}
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

	public function setParams(required any params) output=false {
		var rows=0;
		var I = 0;
		if ( isquery(arguments.params) ) {
			variables.instance.params=arguments.params;
		} else if ( isdefined('arguments.params.param') ) {
			clearParams();
			for ( i=1 ; i<=listLen(arguments.params.param) ; i++ ) {
				addParam(
					listFirst(arguments.params['paramField#i#'],'^'),
					arguments.params['paramRelationship#i#'],
					arguments.params['paramCriteria#i#'],
					arguments.params['paramCondition#i#'],
					listLast(arguments.params['paramField#i#'],'^')
					);
			}
		}
		return this;
	}

	public function addParam(required string field="", required string relationship="and", required string criteria="", required string condition="EQUALS", required string datatype="") output=false {

		if ( structKeyExists(arguments,'column') ) {
			arguments.field=arguments.column;
		}
		if ( structKeyExists(arguments,'name') ) {
			arguments.field=arguments.name;
		}
		if ( structKeyExists(arguments,'value') ) {
			arguments.criteria=arguments.value;
		}

		if(!listFind('categoryid,contentid',arguments.field ) && isValid('variablename',arguments.field) && isdefined('set#arguments.field#')){
				setValue(arguments.field,arguments.criteria);
				return this;
		}

		if ( listFindNoCase('tcontentcategories.categoryid,categoryid,category',arguments.field) ) {
			arguments.field='tcontentcategoryassign.categoryid';
		} else if ( arguments.field == 'categorypathid' ) {
			arguments.field='tcontentcategories.path';
		}
		if ( len(arguments.criteria) && ListFindNoCase('tcontentcategories.path,tcontentcategoryassign.categoryid,tcontentcategories.parentid',arguments.field) && !IsValid('uuid',listFirst(arguments.criteria)) ) {
			if ( listLast(arguments.field,'.') == 'categoryid' ) {
				arguments.field='tcontentcategories.name';
			} else {
				if ( listLen(arguments.criteria) > 1 ) {
					var rs=getBean('category').getFeed()
						.setSiteID(get('siteid'))
						.itemsPerPage(0)
						.maxItems(0)
						.where()
						.prop('name')
						.isIn(arguments.criteria)
						.getQuery();
					arguments.criteria=valueList(rs.categoryid);
				} else {
					arguments.criteria=getBean('category').loadBy(name=arguments.criteria,siteid=get('siteid')).getCategoryID();
				}
			}
		} else if ( arguments.field == 'tag' ) {
			arguments.field='tcontenttags.tag';
		}
		arguments.column=arguments.field;

		if ( structKeyExists(variables.instance.fieldAliases,arguments.field) ) {
			arguments.datatype=variables.instance.fieldAliases[arguments.field].datatype;
			arguments.field=variables.instance.fieldAliases[arguments.field].field;
		}
		if ( !len(arguments.dataType) ) {
			loadTableMetaData();
			if ( !structKeyExists(variables, "dbUtility") ) {
				variables.dbUtility = getBean('dbUtility');
			}
			var tempField=listLast(arguments.field,'.');
			if ( structKeyExists(application.objectMappings[variables.instance.entityName].columns,tempField) ) {
				arguments.dataType=variables.dbUtility.transformParamType(application.objectMappings[variables.instance.entityName].columns[tempField].dataType);
			} else {
				arguments.dataType="varchar";
			}
		}
		queryAddRow(variables.instance.params,1);
		rows = variables.instance.params.recordcount;
		querysetcell(variables.instance.params,"param",rows,rows);
		querysetcell(variables.instance.params,"field",formatField(arguments.field),rows);
		querysetcell(variables.instance.params,"relationship",arguments.relationship,rows);
		querysetcell(variables.instance.params,"criteria",arguments.criteria,rows);
		querysetcell(variables.instance.params,"condition",arguments.condition,rows);
		querysetcell(variables.instance.params,"dataType",arguments.datatype,rows);
		return this;
	}

	public function setAdvancedParams(required any params) output=false {
		return setParams(argumentCollection=arguments);
	}

	public function renderName() output=false {
		if ( len(variables.instance.altName) ) {
			return variables.instance.altName;
		} else {
			return variables.instance.name;
		}
	}

	public function getQuery(required aggregation="false", required applyPermFilter="false", countOnly="false", menuType="default", required from="", required to="", required cachedWithin="#variables.instance.cachedWithin#") output=false {
		variables.instance.cachedWithin=arguments.cachedWithin;
		arguments.tag='';
		arguments.feedBean=this;
		return variables.feedManager.getFeed(argumentCollection=arguments);
	}

	public function getIterator(required aggregation="false", required applyPermFilter="false", required from="", required to="", required cachedWithin="#variables.instance.cachedWithin#", countOnly="false", menuType="default") output=false {
		var q=getQuery(argumentCollection=arguments);

		//When selecting distinct generic iterators and beans are used
		if(isAggregateQuery() ||  getDistinct() || arguments.countOnly){
			var it=getBean("beanIterator");
		} else {
			var it=getBean("contentIterator");
		}

		it.setQuery(q,variables.instance.nextn);
		return it;
	}

	public function save() output=false {
		setAllValues(variables.feedManager.save(this).getAllValues());
		return this;
	}

	public function delete() output=false {
		variables.feedManager.delete(variables.instance.feedID);
	}

	public function loadBy() output=false {
		if ( !structKeyExists(arguments,"siteID") ) {
			arguments.siteID=variables.instance.siteID;
		}
		arguments.feedBean=this;
		return variables.feedManager.read(argumentCollection=arguments);
	}

	public function setRemotePubDate(required string RemotePubDate) output=false {
		if ( lsisDate(arguments.RemotePubDate) ) {
			try {
				variables.instance.RemotePubDate = lsparseDateTime(arguments.RemotePubDate);
			} catch (any cfcatch) {
				variables.instance.RemotePubDate = arguments.RemotePubDate;
			}
		} else {
			variables.instance.RemotePubDate = "";
		}
		return this;
	}

	public function setAltTable(any altTable) output=false {
		if ( len(arguments.altTable) ) {
			variables.instance.altTable = arguments.altTable;
		}
		return this;
	}

	public function getEditUrl(required any compactDisplay="false") output=false {
		var returnStr="";
		returnStr= "#variables.configBean.getAdminPath()#/?muraAction=cFeed.edit&feedID=#variables.instance.feedID#&siteid=#variables.instance.siteID#&type=#variables.instance.type#&compactDisplay=#arguments.compactdisplay#";
		return returnStr;
	}

	public function getDisplayList() output=false {
		var hasRating=false;
		var hasComments=false;
		if ( !len(variables.instance.displayList) ) {
			variables.instance.displayList="Date,Title,Image,Summary,Credits";
			hasRating=listFindNoCase(variables.instance.displayList,"Rating");
			hasComments=listFindNoCase(variables.instance.displayList,"Comments");
			if ( variables.instance.displayComments && !hasComments ) {
				variables.instance.displayList=listAppend(variables.instance.displayList,"Comments");
			} else if ( !variables.instance.displayComments && hasComments ) {
				variables.instance.displayList=listDeleteAt(variables.instance.displayList,hasComments);
			}
			variables.instance.displayList=listAppend(variables.instance.displayList,"Tags");
			if ( variables.instance.displayRatings && !hasRating ) {
				variables.instance.displayList=listAppend(variables.instance.displayList,"Rating");
			} else if ( !variables.instance.displayRatings && hasRating ) {
				variables.instance.displayList=listDeleteAt(variables.instance.displayList,hasRating);
			}
		}
		return variables.instance.displayList;
	}

	public function getAvailableDisplayList() output=false {
		var returnList="Date,Title,Image,Summary,Body,ReadMore,Credits,Comments,Tags,Rating";
		var i=0;
		var finder=0;
		var rsExtend=variables.configBean.getClassExtensionManager().getExtendedAttributeList(variables.instance.siteid,"tcontent");
		if ( rsExtend.recordcount ) {

			var qs=new Query();
			qs.setDbType('query');
			qs.setAttributes(rsExtend=rsExtend);

			rsExtend=qs.execute(sql="select attribute from rsExtend
				group by attribute
				order by attribute").getResult();

			returnList=returnList & "," & valueList(rsExtend.attribute);
		}

		for(i in ListToArray(variables.instance.displayList)){
			finder=listFindNoCase(returnList,i);
			if (finder){
				returnList=listDeleteAt(returnList,finder);
			}
		}

		return returnList;
	}

	public function getPrimaryKey() output=false {
		return "feedID";
	}

	public function getEntityName(useProxyName="true") output=false {
		variables.entityName='feed';
		if ( arguments.useProxyName ) {
			return "content";
		} else {
			return "feed";
		}
	}

	public function getAvailableCount() output=false {
		return getQuery(countOnly=true).count;
	}

	public function clone() output=false {
		return getBean("feed").setAllValues(structCopy(getAllValues()));
	}

	public function getRemoteData() output=false {
		return getBean('feedManager').getRemoteFeedData(feedURL=variables.instance.channellink,maxItems=variables.instance.maxitems,authtype=variables.instance.authtype,siteid=variables.instance.siteid);
	}

	function getFeed(){
		var feed=getBean('beanFeed').setEntityName('feed').setTable('tcontentfeeds');

		if(hasProperty('siteid')){
			feed.setSiteID(getValue('siteID'));
		}

		if(len(getOrderBy())){
			feed.setOrderBy(getOrderBy());
		}

		return feed;
	}

	function transformFields(fields){

		if(!listFind(arguments.fields,'tcontent.displayInterval')){
			arguments.fields=listAppend(arguments.fields,'tcontent.displayInterval');
		}
		if(!listFind(arguments.fields,'tcontent.displayStart')){
			arguments.fields=listAppend(arguments.fields,'tcontent.displayStart');
		}
		if(!listFind(arguments.fields,'tcontent.displayStop')){
			arguments.fields=listAppend(arguments.fields,'tcontent.displayStop');
		}
		if(!listFind(arguments.fields,'tcontent.display')){
			arguments.fields=listAppend(arguments.fields,'tcontent.display');
		}
		if(!listFind(arguments.fields,'tcontent.siteid')){
			arguments.fields=listAppend(arguments.fields,'tcontent.siteid');
		}
		if(!(listFind(arguments.fields,'tcontent.contentid') || listFind(arguments.fields,'tcontent.contenthistid'))){
			arguments.fields=listAppend(arguments.fields,'tcontent.contentid');
		}
		if(!listFind(arguments.fields,'tparent.type parentType')){
			arguments.fields=listAppend(arguments.fields,'tparent.type parentType');
		}

		return arguments.fields;
	}

	function transformFieldName(fieldname){
		if(!structKeyExists(application.objectMappings[getEntityName()],'columns')){
			loadTableMetaData();
		}
		arguments.fieldname=trim(arguments.fieldname);

		if(arguments.fieldname==application.objectMappings[getEntityName()].table & ".*"){
			return arguments.fieldname;
		}

		if ( listLen(arguments.fieldname,'.') == 2 ) {
			var fieldArray=listToArray(arguments.fieldname,'.');
			if(structKeyExists(application.objectMappings,fieldArray[1])){
				arguments.fieldname=application.objectMappings[fieldArray[1]].table & '.' & fieldArray[2];
			}
		} else if(structKeyExists(application.objectMappings[getEntityName()].columns,arguments.fieldname)){
			arguments.fieldname=application.objectMappings[getEntityName()].table & '.' & arguments.fieldname;
		}

		return arguments.fieldname;
	}

}
