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
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="contenID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="views" type="numeric" default="0" required="true" />
<cfproperty name="rating" type="numeric" default="0" required="true" />
<cfproperty name="totalVotes" type="numeric" default="0" required="true" />
<cfproperty name="upVotes" type="numeric" default="0" required="true" />
<cfproperty name="downVotes" type="numeric" default="0" required="true" />
<cfproperty name="comments" type="numeric" default="0" required="true" />
<cfproperty name="majorVersion" type="numeric" default="0" required="true" />
<cfproperty name="minorVersion" type="numeric" default="0" required="true" />
<cfproperty name="lockID" type="string" default="" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset variables.instance.contentID="" />
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.views=0/>
	<cfset variables.instance.rating=0/>
	<cfset variables.instance.totalVotes=0/>
	<cfset variables.instance.upVotes=0/>
	<cfset variables.instance.downVotes=0/>
	<cfset variables.instance.comments=0/>
	<cfset variables.instance.majorVersion=0/>
	<cfset variables.instance.minorVersion=0/>
	<cfset variables.instance.lockID=""/>
	
	<cfreturn this />
</cffunction>

<cffunction name="setConfigBean">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="setViews" access="public" output="false">
	<cfargument name="views" />
	<cfif isNumeric(arguments.views)>
	<cfset variables.instance.views = arguments.views />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getRating" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.rating />
</cffunction>

<cffunction name="setRating" access="public" output="false">
	<cfargument name="rating" />
	<cfif isNumeric(arguments.rating)>
	<cfset variables.instance.rating = arguments.rating />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMajorVersion" access="public" output="false">
	<cfargument name="majorVersion" />
	<cfif isNumeric(arguments.majorVersion)>
	<cfset variables.instance.majorVersion = arguments.majorVersion />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMinorVersion" access="public" output="false">
	<cfargument name="minorVersion" />
	<cfif isNumeric(arguments.minorVersion)>
	<cfset variables.instance.minorVersion = arguments.minorVersion />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setTotalVotes" access="public" output="false">
	<cfargument name="TotalVotes" />
	<cfif isNumeric(arguments.TotalVotes)>
	<cfset variables.instance.TotalVotes = arguments.TotalVotes />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setUpVotes" access="public" output="false">
	<cfargument name="UpVotes" />
	<cfif isNumeric(arguments.UpVotes)>
	<cfset variables.instance.UpVotes = arguments.UpVotes />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDownVotes" access="public" output="false">
	<cfargument name="DownVotes" />
	<cfif isNumeric(arguments.DownVotes)>
	<cfset variables.instance.DownVotes = arguments.DownVotes />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setComments" access="public" output="false">
	<cfargument name="Comments" />
	<cfif isNumeric(arguments.Comments)>
	<cfset variables.instance.Comments = arguments.Comments />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="load"  access="public" output="false">
	<cfset var rs=getQuery()>
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select * from tcontentstats 
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentstats
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false">
<cfset var rs=""/>
	
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentstats set
		rating=<cfqueryparam cfsqltype="cf_sql_float" value="#variables.instance.rating#">,
		views=#variables.instance.views#,
		totalVotes=#variables.instance.totalVotes#,
		upVotes=#variables.instance.upVotes#,
		downVotes=#variables.instance.downVotes#,
		comments=#variables.instance.comments#,
		majorVersion=#variables.instance.majorVersion#,
		minorVersion=#variables.instance.minorVersion#,
		lockID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.lockID neq '',de('no'),de('yes'))#" value="#variables.instance.lockID#">
		where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentstats (contentID,siteID,rating,views,totalVotes,upVotes,downVotes,comments,majorVersion,minorVersion,lockID)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#variables.instance.rating#">,
		#variables.instance.views#,
		#variables.instance.totalVotes#,
		#variables.instance.upVotes#,
		#variables.instance.downVotes#,
		#variables.instance.comments#,
		#variables.instance.majorVersion#,
		#variables.instance.minorVersion#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.lockID neq '',de('no'),de('yes'))#" value="#variables.instance.lockID#">
		)
		</cfquery>
		
	</cfif>
	<cfreturn this>
</cffunction>

</cfcomponent>