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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="fileManager" type="any" required="yes"/>
<!--- 	<cfargument name="contentRenderer" type="any" required="yes"/> --->
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.fileManager=arguments.fileManager />
		<cfset variables.dsn=variables.configBean.getDatasource()/>
		<!--- <cfset variables.contentRenderer=arguments.contentRenderer /> --->
		
<cfreturn this />
</cffunction>

<cffunction name="update" returntype="struct" access="public" output="true">
<cfargument name="data" type="struct">
	<cfset var responseid="">
	<cfset var action="create">
	<cfset var info=structnew()>
	<cfset var templist=''>
	<cfset var theFileStruct=structnew()>
	<cfset var formid=arguments.data.formid>
	<cfset var siteid=arguments.data.siteid>
	<cfset var fieldlist="">
	<cfset var fileID="">
	<cfset var entered="#now()#">
	<cfset var rf = "" />
	<cfset var thefield = "" />
	<cfset var f = "" />
	<cfset var theXml = "" />
	
	<cfparam name="info.fieldnames" default=""/>
	
	<cfif isdefined('arguments.data.responseid')>
		<cfset responseid=arguments.data.responseid>
		<cfset action="Update">
		<cfset fieldlist=arguments.data.fieldlist>
		<cfset entered=arguments.data.entered>
		<cfset delete('#responseid#',false)/>
	<cfelse>
		<cfset responseid=createuuid()>
		<cfset fieldlist=arguments.data.fieldnames>
	</cfif> 
	
	<cfloop list="#fieldlist#" index="f">
	<cfif f neq 'DOACTION' and f neq 'SUBMIT' and f neq 'MLID' and f neq 'SITEID' and f neq 'FORMID' and f neq 'POLLLIST' and f neq 'REDIRECT_URL' and f neq 'REDIRECT_LABEL' and f neq 'X' and f neq 'Y' and f neq 'UKEY' and f neq 'HKEY'
		and f neq 'formfield1234567891' and f neq 'formfield1234567892' and f neq 'formfield1234567893' and f neq 'formfield1234567894' and f neq 'useProtect' and f neq "linkservid">
	
		<cfif action eq 'create' and right(f,8) eq '_default'>
			<cfset rf=left(f,len(f)-8)>
			<cfif not listFindNoCase(arguments.data.fieldnames,rf)>
				<cfset arguments.data['#rf#']=arguments.data['#f#']>
				<cfset thefield=rf>
				<cfset info.fieldnames=listappend(info.fieldnames,thefield)>
			<cfelse>
				<cfset thefield=''>
			</cfif>
		<cfelse>
			<cfset thefield=f>
			<cfset info.fieldnames=listappend(info.fieldnames,thefield)>
		</cfif>
		
			<cfif thefield neq '' and structkeyexists(arguments.data, thefield)>
				
				<cfif findNoCase('attachment',theField) and arguments.data['#thefield#'] neq ''>
					<cftry>
					<cffile action="upload" filefield="#thefield#" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#">
					<cfset theFileStruct=variables.fileManager.process(file,siteID) />
					<cfset arguments.data['#thefield#']=variables.fileManager.create(theFileStruct.fileObj,formid,siteID,file.ClientFile,file.ContentType,file.ContentSubType,file.FileSize,'00000000000000000000000000000000004',file.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium,createUUID(),theFileStruct.fileObjSource) />
					<cfcatch></cfcatch>
					</cftry>
					<cfset info['#thefield#']=arguments.data['#thefield#']>
				</cfif>
					
					<cfset info['#thefield#']=trim(arguments.data['#thefield#'])>
					<cfset info['#thefield#']=REREplaceNoCase(info['#thefield#'], "<script|<form",  "<noscript" ,  "ALL")/>
					<cfset info['#thefield#']=REREplaceNoCase(info['#thefield#'], "script>|form>",  "noscript>" ,  "ALL")/>		
					
					<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
						insert into tformresponsequestions (responseid,formid,formField,formValue,pollValue)
						values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#responseID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#formID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#thefield#">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#info['#thefield#']#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(info['#thefield#'],255)#">)
					</cfquery>
					
			</cfif>
	</cfif>
	
	</cfloop>
	
	
	<cfif not StructIsEmpty(info)>
	
		<cfwddx action="cfml2wddx" input="#info#" output="theXml">
		
			<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into tformresponsepackets (responseid,formid,siteid,entered,Data,fieldlist)
				values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#responseID#"/>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#formID#"/>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#siteID#"/>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#entered#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#theXML#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#info.fieldnames#">)
			</cfquery>
	
		</cfif>
	
	<cfreturn info />
</cffunction>

<cffunction name="delete" returntype="void" output="true" access="public">
<cfargument name="responseID" type="string">
<cfargument name="deleteFiles" type="boolean" default="true">
<cfset var rs = ''/>
	
	<cfif deleteFiles>
		<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			Select * from tformresponsequestions 
			where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#"/>
		</cfquery>
		
		<cfloop query="rs">
			<cfif findNoCase('attachment',rs.formField) and isValid("UUID",rs.formValue)>
				<cfset variables.filemanager.deleteVersion(rs.formValue)/>
			</cfif>
		</cfloop>
		</cfif>
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tformresponsequestions 
		where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#"/>
	</cfquery>
					
					
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tformresponsepackets 
		where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#"/>
	</cfquery>

</cffunction>

<cffunction name="read" returntype="query" output="true" access="public">
<cfargument name="responseID" type="string">

<cfset var rs=""/>
					
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select *  from tformresponsepackets 
		where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#"/>
	</cfquery>

<cfreturn rs/>
</cffunction>

<cffunction name="getCurrentFieldList" returntype="string" output="true" access="public">
<cfargument name="formID" type="string">

<cfset var rs=""/>
<cfset var dbType=variables.configBean.getDbType() />					
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select distinct formField from tformresponsequestions
		where formID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formID#"/>
		order by formField asc
	</cfquery>

	<cfreturn valueList(rs.formField) />
</cffunction>

<cffunction name="getData" returntype="query" access="public" output="false">
<cfargument name="data" type="struct">

<cfset var rs=""/>
<cfset var extend= arguments.data.sortby neq '' and arguments.data.sortBy neq 'Entered' and listFind(arguments.data.fieldnames,arguments.data.sortBy)>
<cfset var start="" />
<cfset var stop="" />
<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select tformresponsepackets.* from tformresponsepackets 
<cfif extend or arguments.data.keywords neq ''>
left join tformresponsequestions on tformresponsepackets.responseid= tformresponsequestions.responseid
</cfif>
where tformresponsepackets.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteID#"/> and tformresponsepackets.formid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/>
<cfif extend>
and tformresponsequestions.formField= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.sortBy#"/>
</cfif>
<cfif isdefined('arguments.data.date1') and lsIsDate(arguments.data.date1)>
<cfset start=lsParseDateTime(arguments.data.date1) />
and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),arguments.data.hour1,arguments.data.minute1,0)#">
</cfif>

<cfif isdefined('arguments.data.date2') and lsIsDate(arguments.data.date2)>
<cfset stop=lsParseDateTime(arguments.data.date2) />
and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),arguments.data.hour2,arguments.data.minute2,59)#">
</cfif>
<cfif arguments.data.keywords neq ''>
and tformresponsequestions.pollValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.keywords#">

<cfif listFind(arguments.data.fieldnames,arguments.data.filterBy) and arguments.data.filterBy neq ''>
and tformresponsequestions.formField = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.filterBy#">
</cfif>

</cfif>

<cfif  arguments.data.sortBy eq 'Entered' or (listFind(arguments.data.fieldnames,arguments.data.sortBy) and arguments.data.sortby neq '')>
order by <cfif arguments.data.sortBy eq 'Entered'>tformresponsepackets.entered<cfelse>tformresponsequestions.pollValue</cfif> #arguments.data.sortDirection#
<cfelse>
order by tformresponsepackets.entered asc
</cfif>
</cfquery>

<cfreturn rs/>
</cffunction>

<cffunction name="renderForm" access="public" output="false" returntype="string">
<cfargument name="formid" type="string">
<cfargument name="siteid" type="string">
<cfargument name="preBody" type="string">
<cfargument name="responseChart" type="numeric" required="yes" default="0">
<cfargument name="linkServID" type="string" required="yes" default="">

<cfset var frm=""/>
<cfset var finder=""/>
<cfset var frmID="frm" & replace(arguments.formID,"-","","ALL") />
<cfset var formHTML='<input type="hidden" name="siteid" value="#arguments.siteid#"><input type="hidden" name="formid" value="#arguments.formid#">'>
<cfset var body=""/>

<cfif len(arguments.linkServID)>
	<cfset formHTML='#formHTML#<input type="hidden" name="linkservid" value="#arguments.linkServID#">'>
</cfif>
<!--- dynamic content set by 
<cfset body=variables.contentRenderer.setDynamicContent(body) />
 --->
<!--- Backwards compatability --->
<cfset finder=refind('\svalue="##.+?##"\s',body,1,"true")>

<cfloop condition="#finder.len[1]#">
<cftry>
<cfset body=replace(body,mid(body, finder.pos[1], finder.len[1]),' value="#trim(evaluate(mid(body, finder.pos[1], finder.len[1])))#" ')>
<cfcatch><cfset body=replace(body,mid(body, finder.pos[1], finder.len[1]),' value="undefined" ')></cfcatch></cftry>
<cfset finder=refind('\svalue="##.+?##"\s',body,1,"true")>
</cfloop>

<cfset body=rereplacenocase(arguments.preBody,'</form>','#formHTML#</form>')>
<cfif not find(frmID,body)>
	<cfset body=rereplacenocase(body,'<form','<form id="#frmID#" ')>
</cfif>

<cfsavecontent variable="frm"><cfoutput>
#body#
<script type="text/javascript">
		var frm=document.getElementById('#frmID#');
			frm.setAttribute('action','?nocache=1');
			frm.setAttribute('method','post');
			if( frm.getAttribute('onsubmit') == null || frm.getAttribute('onsubmit')==''){
				frm.onsubmit=function(){return validateForm(this);}
			}
		<cfif not(refind("Mac",cgi.HTTP_USER_AGENT) and refind("MSIE 5",cgi.HTTP_USER_AGENT))>	
			<cfif arguments.responseChart>
				polllist=new Array();
				poll=frm.elements;
					for (p=0; p < poll.length; p++) {
							if(poll[p].type =='radio'){polllist.push(escape(poll[p].value));}
						}
				if(polllist.length > 0) {frm.setAttribute('action','?nocache=1&polllist='+ polllist.toString());}		
			</cfif>
		</cfif>
		if( !(typeof(window.jQuery) != 'undefined' && typeof(window.jQuery.mobile) != 'undefined') ){
			frm.setAttribute('action',frm.getAttribute('action') + '###frmID#');
		}
</script></cfoutput>
</cfsavecontent>

<cfreturn trim(frm) />
</cffunction>

<cffunction name="setDisplay" output="false" returntype="void" access="public">
<cfargument name="contentBean" type="any" >

	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set 
	responseDisplayFields=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getResponseDisplayFields()#"/>,
	sortBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSortBy()#"/>,
	sortDirection=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSortDirection()#"/>,
	nextN=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.contentBean.getNextN()#"/>
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#"/>
	and type='Form'
	and contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#"/>
	</cfquery>

	<cfset getBean("contentManager").purgeContentCache(contentBean=arguments.contentBean)>

</cffunction>
</cfcomponent>