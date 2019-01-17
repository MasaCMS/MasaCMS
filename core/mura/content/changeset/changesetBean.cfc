/**
 * This provides changeset bean functionality
 */
component extends="mura.bean.bean" entityName="changeset" table="tchangesets" output="false" hint="This provides changeset bean functionality" {
	property name="changesetID" fieldtype="id" type="string" default="" required="true";
	property name="siteID" type="string" default="" required="true";
	property name="name" type="string" default="" required="true";
	property name="created" type="date" default="";
	property name="description" type="string" default="";
	property name="publishDate" type="date" default="";
	property name="published" type="numeric" default="0" required="true";
	property name="remoteID" type="string" default="";
	property name="remoteSourceURL" type="string" default="";
	property name="remotePubDate" type="date" default="";
	property name="lastUpdate" type="date" default="";
	property name="lastUpdateBy" type="string" default="";
	property name="closeDate" type="date" default="";
	property name="categoryID" type="string" default="";
	property name="tags" type="string" default="";
	property name="isNew" type="numeric" default="1" required="true" persistent="false";
	property name="categoryAssignments" fieldtype="one-to-many" cfc="changesetCategoryAssignment";
	property name="contentAssignments" fieldtype="one-to-many" cfc="content";
	variables.primaryKey = 'changesetID';
	variables.entityName = 'changeset';

	public function init() output=false {
		super.init(argumentCollection=arguments);

		var sessionData=getSession();

		variables.instance.changesetID="";
		variables.instance.siteID="";
		variables.instance.name="";
		variables.instance.created=now();
		variables.instance.description="";
		variables.instance.publishDate="";
		variables.instance.published=0;
		variables.instance.remoteID = "";
		variables.instance.remoteSourceURL = "";
		variables.instance.remotePubDate = "";
		variables.instance.lastUpdate="#now()#";
		variables.instance.lastUpdateBy="";
		variables.instance.closeDate="";
		variables.instance.isNew=1;
		variables.instance.categoryID="";
		variables.instance.tags="";
		variables.instance.errors=structNew();
		if ( isDefined("sessionData.mura") && sessionData.mura.isLoggedIn ) {
			variables.instance.LastUpdateBy = left(sessionData.mura.fname & " " & sessionData.mura.lname,50);
			variables.instance.LastUpdateByID = sessionData.mura.userID;
		} else {
			variables.instance.LastUpdateBy = "";
			variables.instance.LastUpdateByID = "";
		}
		return this;
	}

	public function setConfigBean(configBean) output=false {
		variables.configBean=arguments.configBean;
		return this;
	}

	public function setChangesetManager(changesetManager) output=false {
		variables.changesetManager=arguments.changesetManager;
		return this;
	}

	public function set(required property, propertyValue) output=false {
		if ( !isDefined('arguments.data') ) {
			if ( isSimpleValue(arguments.property) ) {
				return setValue(argumentCollection=arguments);
			}
			arguments.data=arguments.property;
		}
		var prop="";
		var publishhour="";
		if ( isquery(arguments.data) ) {
			for(prop in listToArray(arguments.data.columnlist)){
				setValue(prop,arguments.data[prop][1]);
			}
		} else if ( isStruct(arguments.data) ) {
			for ( prop in arguments.data ) {
				setValue(prop,arguments.data[prop]);
			}
		}
		return this;
	}

	public function getChangesetID() output=false {
		if ( !len(variables.instance.changesetID) ) {
			variables.instance.changesetID=createUUID();
		}
		return variables.instance.changesetID;
	}

	public function setCreated(required string created) output=false {
		variables.instance.created = parseDateArg(arguments.created);
		return this;
	}

	public function setPublishDate(required string publishDate) output=false {
		variables.instance.publishDate = parseDateArg(arguments.publishDate);
		return this;
	}

	public function setPublished(published) output=false {
		if ( isNumeric(arguments.published) ) {
			variables.instance.published=arguments.published;
		}
		return this;
	}

	public function getIsNew() output=false {
		return variables.instance.IsNew;
	}

	public function setLastUpdate(String lastUpdate) output=false {
		variables.instance.lastUpdate = parseDateArg(arguments.lastUpdate);
		return this;
	}

	public function setCloseDate(String closeDate) output=false {
		variables.instance.closeDate = parseDateArg(arguments.closeDate);
		return this;
	}

	public function setLastUpdateBy(String lastUpdateBy) output=false {
		variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50);
		return this;
	}

	public function setRemotePubDate(required string RemotePubDate) output=false {
		variables.instance.RemotePubDate = parseDateArg(arguments.RemotePubDate);
		return this;
	}

	public function loadBy() output=false {
		if ( !structKeyExists(arguments,"siteID") ) {
			arguments.siteID=variables.instance.siteID;
		}
		arguments.changesetBean=this;
		return variables.changesetManager.read(argumentCollection=arguments);
	}

	public function save() output=false {
		var sessionData=getSession();
		if (isDefined('sessionData.mura') && sessionData.mura.isLoggedIn ) {
			set('LastUpdateBy',left(sessionData.mura.fname & " " &  sessionData.mura.lname,50));
			set('LastUpdateByID',sessionData.mura.userID);
		}
		setAllValues(variables.changesetManager.save(this).getAllValues());
		return this;
	}

	public function delete() output=false {
		variables.changesetManager.delete(getChangesetID());
	}

	public function getPrimaryKey() output=false {
		return "changesetID";
	}

	public function setCategoryID(String categoryID, required boolean append="false") output=false {
		var i="";
		if ( !arguments.append ) {
			variables.instance.categoryID = trim(arguments.categoryID);
		} else {
			for(i in listToArray(arguments.categoryID)){
				if (not listFindNoCase(variables.instance.categoryID,trim(i))){
			    	variables.instance.categoryID = listAppend(variables.instance.categoryID,trim(i));
				}
			}

		}
		return this;
	}

	public function hasPendingApprovals() output=false {
		return variables.changesetManager.hasPendingApprovals(getValue('changesetID'));
	}

	public function getAssignmentsIterator() output=false {
		return variables.changesetManager.getAssignmentsIterator(getValue('changesetID'));
	}

	public function getAssignmentsQuery() output=false {
		return variables.changesetManager.getAssignmentsQuery(getValue('changesetID'));
	}

	public function getContentAssignmentsIterator() output=false {
		return variables.changesetManager.getAssignmentsIterator(getValue('changesetID'));
	}

	public function getContentAssignmentsQuery() output=false {
		return variables.changesetManager.getAssignmentsQuery(getValue('changesetID'));
	}

	public function rollback() output=false {
		if ( variables.instance.published ) {
			var it=getBean('changesetRollBack')
			.getFeed()
			.setNextN(0)
			.setSiteID(getValue('siteID'))
			.addParam(column='changesetID',criteria=getValue('changesetID'))
			.getIterator();
			if ( it.hasNext() ) {
				while ( it.hasNext() ) {
					it.next().rollback();
				}
			}
		}
		variables.instance.published=0;
		variables.instance.publishDate="";
		save();
		// <cfdump var="#variables.instance.published#" abort="true">
		return this;
	}

	public function getFeed() output=false {
		return getBean("beanFeed")
		.setSiteID(getValue('siteid'))
		.setEntityName('changeset')
		.setTable('tchangesets')
		.setOrderBy('name asc')
		.setFieldAliases({'tag'={field='tchangesettagassign.tag',datatype='varchar'}});
	}

}
