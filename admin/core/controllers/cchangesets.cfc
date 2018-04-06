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
component extends="controller" output="false" {

	public function setChangesetManager(changesetManager) output=false {
		variables.changesetManager=arguments.changesetManager;
	}

	public function before(rc) output=false {
		if ( (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') && !listFind(session.mura.memberships,'S2')) && !( variables.permUtility.getModulePerm('00000000000000000000000000000000014',arguments.rc.siteid) && variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid)) ) {
			secure(arguments.rc);
		}
		param default=1 name="arguments.rc.startrow";
		param default="" name="arguments.rc.startdate";
		param default="" name="arguments.rc.stopdate";
		param default=1 name="arguments.rc.page";
		param default="" name="arguments.rc.keywords";
		param default="" name="arguments.rc.categoryid";
		param default="" name="arguments.rc.tags";
	}

	public function list(rc) output=false {
		var feed=variables.changesetManager.getFeed(argumentCollection=arguments.rc);
		feed.setSiteID(arguments.rc.siteid);
		if ( isDate(rc.startdate) ) {
			feed.addParam(column='publishdate',datatype='date',criteria=arguments.rc.startdate,condition=">=");
		}
		if ( isDate(rc.stopdate) ) {
			arguments.rc.stopdate = DateAdd("d", 1, arguments.rc.stopdate);
			feed.addParam(column='publishdate',datatype='date',criteria=arguments.rc.stopdate,condition="<=");
			if ( !isDate(rc.startdate) ) {
				feed.addParam(column='publishdate',datatype='date',criteria=dateAdd('yyyy',100,now()),condition=">=");
			}
		}
		if ( len(rc.keywords) ) {
			feed.addParam(column='name',criteria=arguments.rc.keywords,condition="contains");
		}
		if ( len(rc.tags) ) {
			cfquery( name="local.rstags" ) { //Note: queryExecute() is the preferred syntax but this syntax is easier to convert generically

				writeOutput("select changesetid from tchangesettagassign where tag in (");
				cfqueryparam( list=true, cfsqltype="cf_sql_varchar", value=arguments.rc.tags );

				writeOutput(")");
			}
			if ( local.rstags.recordcount ) {
				feed.addParam(column='changesetid',criteria=valuelist(local.rstags.changesetid),condition="in");
			} else {
				feed.addParam(column='changesetid',criteria='none');
			}
		}
		if ( len(rc.categoryid) ) {
			cfquery( name="local.rscats" ) { //Note: queryExecute() is the preferred syntax but this syntax is easier to convert generically

				writeOutput("select changesetid from tchangesetcategoryassign where categoryid in (");
				cfqueryparam( list=true, cfsqltype="cf_sql_varchar", value=arguments.rc.categoryid );

				writeOutput(")");
			}
			if ( local.rscats.recordcount ) {
				feed.addParam(column='changesetid',criteria=valuelist(local.rscats.changesetid),condition="in");
			} else {
				feed.addParam(column='changesetid',criteria='none');
			}
		}
		arguments.rc.changesets=feed.getIterator();
		arguments.rc.changesets.setNextN(20);
		arguments.rc.changesets.setPage(arguments.rc.page);
	}

	public function publish(rc) output=false {
		variables.changesetManager.publish(rc.changesetID);
		variables.fw.redirect(action="cChangesets.edit",append="changesetID,siteID",path="./");
	}

	public function rollback(rc) output=false {
		if ( rc.$.validateCSRFTokens(context=arguments.rc.changesetid) ) {
			variables.changesetManager.rollback(rc.changesetID);
		}
		variables.fw.redirect(action="cChangesets.edit",append="changesetID,siteID",path="./");
	}

	public function assignments(rc) output=false {
		arguments.rc.siteAssignments=variables.changesetManager.getAssignmentsIterator(arguments.rc.changesetID,arguments.rc.keywords,'00000000000000000000000000000000000');
		arguments.rc.componentAssignments=variables.changesetManager.getAssignmentsIterator(arguments.rc.changesetID,arguments.rc.keywords,'00000000000000000000000000000000003');
		arguments.rc.formAssignments=variables.changesetManager.getAssignmentsIterator(arguments.rc.changesetID,arguments.rc.keywords,'00000000000000000000000000000000004');
		if ( application.configBean.getValue(property='variations',defaultValue=false) ) {
			arguments.rc.variationAssignments=variables.changesetManager.getAssignmentsIterator(arguments.rc.changesetID,arguments.rc.keywords,'00000000000000000000000000000000099');
		}
		arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID);
	}

	public function removeitem(rc) output=false {
		if ( rc.$.validateCSRFTokens(context=arguments.rc.changesetid) ) {
			variables.changesetManager.removeItem(rc.changesetID,rc.contenthistID);
		}
		variables.fw.redirect(action="cChangesets.assignments",append="changesetID,siteID,keywords",path="./");
	}

	public function edit(rc) output=false {
		arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID);
	}

	public function save(rc) output=false {
		if ( rc.$.validateCSRFTokens(context=arguments.rc.changesetid) ) {
			arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID).set(arguments.rc).save();
			arguments.rc.changesetID=arguments.rc.changeset.getChangesetID();
		}
		if ( isDefined('arguments.rc.changeset') && !arguments.rc.changeset.hasErrors() ) {
			variables.fw.redirect(action="cChangesets.list",append="changesetID,siteID",path="./");
		}
	}

	public function delete(rc) output=false {
		if ( rc.$.validateCSRFTokens(context=arguments.rc.changesetid) ) {
			arguments.rc.changeset=variables.changesetManager.read(arguments.rc.changesetID).delete();
		}
		variables.fw.redirect(action="cChangesets.list",append="changesetID,siteID",path="./");
	}

}
