/*
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

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
*/
component persistent="false" accessors="true" output="false" extends="mura.cfobject" {

	property name='contentManager';
	property name='configBean';
	property name='debug';

	public any function init(required contentManager, required configBean) {
		setContentManager(arguments.contentManager);
		setConfigBean(arguments.configBean);
		setDebug(getConfigBean().getDebuggingEnabled());
		return this;
	}


	public any function getComments(
		string siteid='default'
		, string commentid
		, string contentid
		, string parentid
		, string remoteid
		, string ip
		, string email
		, string name
		, boolean isapproved
		, boolean isspam
		, boolean isdeleted
		, string sortby='entered'
		, string sortdirection='asc'
		, boolean returnCountOnly=false
		, numeric maxItems=1000
	) {
		var local = {};
		var qComments = new Query(datasource=getConfigBean().getReadOnlyDatasource());
		var rsComments = '';
		var dbtype=getConfigBean().getDbType();
		
		local.qryStr='';

		if(dbtype eq "mssql" and arguments.maxItems){
			local.qryStr='SELECT top ' & arguments.maxItems
				& ' * FROM tcontentcomments
				WHERE 0=0 ';
		} else if(dbtype eq "oracle" and arguments.maxItems){
			local.qryStr='select * from (
				SELECT * FROM tcontentcomments
				WHERE 0=0 ';
		} else {
			local.qryStr='SELECT *
				FROM tcontentcomments
				WHERE 0=0 ';
		}
		// siteid
		if ( StructKeyExists(arguments, 'siteid') ) {
			local.qryStr &= ' AND siteid = ( :siteid ) ';
			qComments.addParam(name='siteid', value=arguments.siteid, cfsqltype='cf_sql_varchar');
		}

		// commentid
		if ( StructKeyExists(arguments, 'commentid') ) {
			local.qryStr &= ' AND commentid = ( :commentid ) ';
			qComments.addParam(name='commentid', value=arguments.commentid, cfsqltype='cf_sql_varchar');
		}

		// keywords
		if ( StructKeyExists(arguments, 'keywords') ) {
			local.qryStr &= ' AND (comments like ( :comments ) ';
			qComments.addParam(name='comments', value="%#arguments.keywords#%", cfsqltype='cf_sql_varchar');
			local.qryStr &= ' OR name like ( :name )) ';
			qComments.addParam(name='name', value="%#arguments.keywords#%", cfsqltype='cf_sql_varchar');
		}

		//contentid
		if ( StructKeyExists(arguments, 'contentid') and len(arguments.contentid)) {
			local.qryStr &= ' AND contentid = ( :contentid ) ';
			qComments.addParam(name='contentid', value=arguments.contentid, cfsqltype='cf_sql_varchar');
		}

		// parentid
		if ( StructKeyExists(arguments, 'parentid') ) {
			local.qryStr &= ' AND parentid = ( :parentid ) ';
			qComments.addParam(name='parentid', value=arguments.parentid, cfsqltype='cf_sql_varchar');
		}

		// remoteid
		if ( StructKeyExists(arguments, 'remoteid') ) {
			local.qryStr &= ' AND remoteid = ( :remoteid ) ';
			qComments.addParam(name='remoteid', value=arguments.remoteid, cfsqltype='cf_sql_varchar');
		}

		// ip
		if ( StructKeyExists(arguments, 'ip') ) {
			local.qryStr &= ' AND ip = ( :ip ) ';
			qComments.addParam(name='ip', value=arguments.ip, cfsqltype='cf_sql_varchar');
		}

		// email
		if ( StructKeyExists(arguments, 'email') ) {
			local.qryStr &= ' AND email = ( :email ) ';
			qComments.addParam(name='email', value=arguments.email, cfsqltype='cf_sql_varchar');
		}

		// name
		if ( StructKeyExists(arguments, 'name') ) {
			local.qryStr &= ' AND name = ( :name ) ';
			qComments.addParam(name='name', value=arguments.name, cfsqltype='cf_sql_varchar');
		}

		// isapproved
		if ( StructKeyExists(arguments, 'isapproved') ) {
			local.qryStr &= ' AND isapproved = ( :isapproved ) ';
			qComments.addParam(name='isapproved', value=arguments.isapproved, cfsqltype='cf_sql_integer');
		}

		// isspam
		if ( StructKeyExists(arguments, 'isspam') ) {
			local.qryStr &= ' AND isspam = ( :isspam ) ';
			qComments.addParam(name='isspam', value=arguments.isspam, cfsqltype='cf_sql_integer');
		}

		// isdeleted
		if ( StructKeyExists(arguments, 'isdeleted') ) {
			local.qryStr &= ' AND isdeleted = ( :isdeleted ) ';
			qComments.addParam(name='isdeleted', value=arguments.isdeleted, cfsqltype='cf_sql_integer');
		}

		// startdate
		if ( StructKeyExists(arguments, 'startdate') && isDate(arguments.startdate) ) {
			local.qryStr &= ' AND entered >= :startdate ';
			qComments.addParam(name='startdate', value=arguments.startdate, cfsqltype='cf_sql_date');
		}

		// enddate
		if ( StructKeyExists(arguments, 'enddate') && isDate(arguments.enddate) ) {
			local.qryStr &= ' AND entered <= :enddate ';
			qComments.addParam(name='enddate', value=createODBCDateTime(createDateTime(year(arguments.enddate), month(arguments.enddate), day(arguments.enddate), 23, 59, 59)), cfsqltype='cf_sql_timestamp');
		}

		// categoryID
		if ( StructKeyExists(arguments, 'categoryID') && len(arguments.categoryID) ) {
			local.qryStr &= ' AND contentID in ( select distinct contentID from tcontentcategoryassign where categoryID in ( :categoryID ) ) ';
			qComments.addParam(name='categoryID', value=arguments.categoryID, cfsqltype='cf_sql_varchar', list='true');
		}

		local.qryStr &= ' ORDER BY ' & arguments.sortby & ' ' & arguments.sortdirection;

		
		if(dbType eq "nuodb" and arguments.maxItems){
			local.qryStr=local.qryStr & ' fetch ' & arguments.maxItems;
		}

		if(listFindNoCase("mysql,postgresql", dbType) and arguments.maxItems){
			local.qryStr=local.qryStr & ' limit ' & arguments.maxItems;
		}

		if(dbType eq "oracle" and arguments.maxItems){
			local.qryStr=local.qryStr & ' ) where ROWNUM <=  ' & arguments.maxItems;
		}

		//rsComments = qComments.setSQL(local.qryStr).execute().getResult(); // breaks in ACF9: https://github.com/stevewithington/MuraComments/issues/2 .. using workaround instead
		qComments.setSQL(local.qryStr);
		rsComments = qComments.execute().getResult();

		if ( arguments.returnCountOnly ) {
			return rsComments.recordcount;
		} else {
			return rsComments;
		}
	}


	public any function getCommentsIterator() {
		var local = {};
		local.rsComments = getComments(argumentCollection=arguments);
		local.iterator = getBean('contentCommentIterator');
		local.iterator.setQuery(local.rsComments);
		return local.iterator;
	}


	public boolean function approve(required string commentid) {
		var commentBean = getCommentBeanByCommentID(arguments.commentid);

		try {
			getContentManager().approveComment(arguments.commentid);
		} catch(any e) {
			handleError(e);
		}

		try {
			commentBean.notifySubscribers();
		} catch(any e) {
			// handleError(e);
			// this will break on versions prior to 6.0.5238
			// so instead of tossing an error...just skip the notifications
		}

		return true;
	}

	public boolean function markAsSpam(required string commentid) {
		var commentBean = getCommentBeanByCommentID(arguments.commentid);

		try {
			getContentManager().markCommentAsSpam(arguments.commentid);
		} catch(any e) {
			handleError(e);
		}

		return true;
	}

	public boolean function unmarkAsSpam(required string commentid) {
		var commentBean = getCommentBeanByCommentID(arguments.commentid);

		try {
			getContentManager().unmarkCommentAsSpam(arguments.commentid);
		} catch(any e) {
			handleError(e);
		}

		return true;
	}


	public any function getCommentBeanByCommentID(required string commentid) {
		return getContentManager().getCommentBean().setCommentID(arguments.commentID).load();
	}


	public boolean function unapprove(required string commentid) {
		try {
			getContentManager().unapproveComment(arguments.commentid);
		} catch(any e) {
			handleError(e);
		}
		return true;
	}


	public boolean function delete(required string commentid) {
		try {
			getContentManager().deleteComment(arguments.commentid);
		} catch(any e) {
			handleError(e);
		}
		return true;
	}

	public boolean function undelete(required string commentid) {
		try {
			getContentManager().undeleteComment(arguments.commentid);
		} catch(any e) {
			handleError(e);
		}
		return true;
	}

	private any function handleError(required any error) {
		if ( getDebug() ) {
			WriteDump(arguments.error);
			abort;
		} else {
			return false;
		}
	}

	public string function dspCategoriesNestSelect(string siteID, string parentID, string categoryID, numeric nestLevel, numeric useID, string elementName){
		var rsList = getBean('categoryManager').getCategories(arguments.siteID, arguments.parentID, "");
		var row = "";
		var o = "";
		var elemID = "";
		var elemClass = "";
		var classList = "categories";
		var elemChecked = "";
		
		if (rsList.recordCount) {
			if (arguments.useID) {
				elemID = ' id="mura-nodes"';
			}
			if (arguments.nestLevel eq 0) {
				classList = listAppend(classList, "checkboxTree", " ");
			}
			elemClass = ' class="' & classList & '"';
			o &= "<ul#elemID##elemClass#>";
			
			for (row =1; row lte rsList.recordcount; row=row+1) {
				o &= "<li>";
				if (rsList.isOpen[row] eq 1) {
					if (listfind(arguments.categoryID, rslist.categoryID[row])) {
						elemChecked = " checked";
					} else {
						elemChecked = "";
					}
					o &= '<input type="checkbox" name="#esapiEncode('html_attr',arguments.elementName)#" class="checkbox" value="#esapiEncode('html_attr',rsList.categoryID[row])#"#elemChecked#/> ';
				}
				o &= esapiEncode('html',rsList.name[row]);
				if (rsList.hasKids[row]) {
					o &= dspCategoriesNestSelect(arguments.siteID, rsList.categoryID[row], arguments.categoryID, ++arguments.nestLevel, 0, arguments.elementName);
				}
				o &= "</li>";
			}
			o &= "</ul>";
		}
		return o;
	}

	public boolean function purgeDeletedComments(string siteid) {
		var local = {};
		var qDeleted = new Query(datasource=getConfigBean().getReadOnlyDatasource());
		var purged = true;

		local.qryStr = '
			DELETE
			FROM tcontentcomments
			WHERE 0=0
				AND isdeleted = 1
		';

		// siteid
		if ( StructKeyExists(arguments, 'siteid') ) {
			local.qryStr &= ' AND siteid = ( :siteid ) ';
			qDeleted.addParam(name='siteid', value=arguments.siteid, cfsqltype='cf_sql_varchar');
		}

		qDeleted.setSQL(local.qryStr);

		try {
			qDeleted.execute().getResult();
		} catch(any e) {
			purged = false;
		}

		return purged;
	}

}