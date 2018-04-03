<!--- This file is part of Mura CMS.

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
--->
<cfcomponent extends="mura.bean.bean" entityName="stats" table="tcontentstats" output="false" hint="This provides content stats functionality">
<cfproperty name="content" fieldtype="many-to-one" fkcolumn="contentid" cfc="content">
<cfproperty name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid">
<cfproperty name="views" type="numeric" default="0" required="true">
<cfproperty name="rating" type="numeric" default="0" required="true">
<cfproperty name="totalvotes" type="numeric" default="0" required="true">
<cfproperty name="upvotes" type="numeric" default="0" required="true">
<cfproperty name="downvotes" type="numeric" default="0" required="true">
<cfproperty name="comments" type="numeric" default="0" required="true">
<cfproperty name="disablecomments" type="numeric" default="0" required="true">
<cfproperty name="majorversion" type="numeric" default="0" required="true">
<cfproperty name="minorversion" type="numeric" default="0" required="true">
<cfproperty name="lockid" type="string" default="" required="true">
<cfproperty name="locktype" type="string" default="" required="true">

<cfscript>

variables.primaryKey = 'contentid';
variables.entityName = 'stats';

function init() output=false {
variables.instance.contentID="";
variables.instance.siteID="";
variables.instance.views=0;
variables.instance.rating=0;
variables.instance.totalVotes=0;
variables.instance.upVotes=0;
variables.instance.downVotes=0;
variables.instance.comments=0;
variables.instance.disableComments=0;
variables.instance.majorVersion=0;
variables.instance.minorVersion=0;
variables.instance.lockID="";
variables.instance.lockType="";
variables.instance.disableComments=0;
return this;
}

function setConfigBean(configBean) {
variables.configBean=arguments.configBean;
return this;
}

function setViews(views) output=false {
if ( isNumeric(arguments.views) ) {
	variables.instance.views = arguments.views;
}
return this;
}

function getRating() output=false {
return variables.instance.rating;
}

function setRating(rating) output=false {
if ( isNumeric(arguments.rating) ) {
	variables.instance.rating = arguments.rating;
}
return this;
}

function setMajorVersion(majorVersion) output=false {
if ( isNumeric(arguments.majorVersion) ) {
	variables.instance.majorVersion = arguments.majorVersion;
}
return this;
}

function setMinorVersion(minorVersion) output=false {
if ( isNumeric(arguments.minorVersion) ) {
	variables.instance.minorVersion = arguments.minorVersion;
}
return this;
}

function setTotalVotes(TotalVotes) output=false {
if ( isNumeric(arguments.TotalVotes) ) {
	variables.instance.TotalVotes = arguments.TotalVotes;
}
return this;
}

function setUpVotes(UpVotes) output=false {
if ( isNumeric(arguments.UpVotes) ) {
	variables.instance.UpVotes = arguments.UpVotes;
}
return this;
}

function setDownVotes(DownVotes) output=false {
if ( isNumeric(arguments.DownVotes) ) {
	variables.instance.DownVotes = arguments.DownVotes;
}
return this;
}

function setComments(Comments) output=false {
if ( isNumeric(arguments.Comments) ) {
	variables.instance.Comments = arguments.Comments;
}
return this;
}

function setDisableComments(disableComments) output=false {
if ( isNumeric(arguments.disableComments) ) {
	variables.instance.disableComments = arguments.disableComments;
}
return this;
}

function load() output=false {
var rs=getQuery();
if ( rs.recordcount ) {
	set(rs);
}
return this;
}
</cfscript>

<cffunction name="getQuery"  output="false">
	<cfset var rs=""/>
	<cfquery name="rs">
	select * from tcontentstats
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>

	<cfreturn rs/>
</cffunction>

<cffunction name="delete">
	<cfquery>
	delete from tcontentstats
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
</cffunction>

<cffunction name="save"  output="false">
<cfset var rs=""/>


	<cfif getQuery().recordcount>

		<cfquery>
		update tcontentstats set
		rating=<cfqueryparam cfsqltype="cf_sql_float" value="#variables.instance.rating#">,
		views=#variables.instance.views#,
		totalVotes=#variables.instance.totalVotes#,
		upVotes=#variables.instance.upVotes#,
		downVotes=#variables.instance.downVotes#,
		comments=#variables.instance.comments#,
		disableComments=#variables.instance.disableComments#,
		majorVersion=#variables.instance.majorVersion#,
		minorVersion=#variables.instance.minorVersion#,
		lockID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.lockID neq '',de('no'),de('yes'))#" value="#variables.instance.lockID#">,
		lockType=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.lockType neq '',de('no'),de('yes'))#" value="#variables.instance.lockType#">
		where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
		</cfquery>

	<cfelse>

		<cfquery>
		insert into tcontentstats (contentID,siteID,rating,views,totalVotes,upVotes,downVotes,comments,disableComments,majorVersion,minorVersion,lockID,lockType)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#variables.instance.rating#">,
		#variables.instance.views#,
		#variables.instance.totalVotes#,
		#variables.instance.upVotes#,
		#variables.instance.downVotes#,
		#variables.instance.comments#,
		#variables.instance.disableComments#,
		#variables.instance.majorVersion#,
		#variables.instance.minorVersion#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.lockID neq '',de('no'),de('yes'))#" value="#variables.instance.lockID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.lockType neq '',de('no'),de('yes'))#" value="#variables.instance.lockType#">
		)
		</cfquery>

	</cfif>
	<cfreturn this>
</cffunction>

</cfcomponent>
