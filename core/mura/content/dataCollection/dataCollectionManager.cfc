<!--- 
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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides data collection service level logic functionality">

	<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		<cfargument name="fileManager" type="any" required="yes"/>

		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.fileManager=arguments.fileManager />
		<cfset variables.dsn=variables.configBean.getDatasource()/>

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
		<cfset var ignoreList = '_P,CSSCLASS,ASYNC,CSS,CSSID,CSRF_TOKEN,CSRF_TOKEN_EXPIRES,INSTANCEID,OBJECTID,PERM,OBJECT,OBJECTNAME,OBJECTICONCLASS,VIEW,INITED,LABEL,ASYNC,REPONSECHART,ISCONFIGURATOR,CONTENTID,CONTENTHISTID,NOCACHE,DOACTION,SUBMIT,MLID,SITEID,FORMID,POLLLIST,REDIRECT_URL,REDIRECT_LABEL,X,Y,UKEY,HKEY,formfield1234567891,formfield1234567892,formfield1234567893,formfield1234567894,INITED,useProtect,linkservid,useReCAPTCHA,g-recaptcha,response,grecaptcharesponse,RENDER,RESPONSECHART,CSSSTYLES,CONTENTCSSSTYLES,METACSSSTYLES,CONTENTCSSCLASS,CONTENTCSSID,METACSSCLASS,METACSSID,CLASS' />
		<cfset var scopeCheck=structNew()>

		<cfparam name="info.fieldnames" default=""/>

		<cfif IsDefined('arguments.data.ignoreFields') and IsSimpleValue(arguments.data.ignoreFields) and Len(arguments.data.ignoreFields)>
			<cfset ignoreList = ListAppend(ignoreList, arguments.data.ignoreFields) />
		</cfif>

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

		<cfset info['responseid'] = responseid />

		<cfloop list="#fieldlist#" index="f">
			<cfif Not ListFindNoCase(ignoreList, f)>
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
						<cfset scopeCheck={test=arguments.data['#thefield#']}>
						<cfif not variables.fileManager.requestHasRestrictedFiles(scope=scopeCheck,allowedExtensions=variables.configBean.getFMPublicAllowedExtensions())>
							<cftry>
							<cffile action="upload" filefield="#thefield#" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#">
							<cfset theFileStruct=variables.fileManager.process(file,siteID) />
							<cfset arguments.data['#thefield#']=variables.fileManager.create(theFileStruct.fileObj,formid,siteID,file.ClientFile,file.ContentType,file.ContentSubType,file.FileSize,'00000000000000000000000000000000004',file.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium,createUUID(),theFileStruct.fileObjSource) />
							<cfcatch></cfcatch>
							</cftry>
							<cfset info['#thefield#']=arguments.data['#thefield#']>
						<cfelse>
							<cfset info['#thefield#']="">
						</cfif>
					</cfif>

					<cfset info['#thefield#']=trim(arguments.data['#thefield#'])>
					<cfset info['#thefield#']=REREplaceNoCase(info['#thefield#'], "<script|<form",  "<noscript" ,  "ALL")/>
					<cfset info['#thefield#']=REREplaceNoCase(info['#thefield#'], "script>|form>",  "noscript>" ,  "ALL")/>

					<cfquery>
						insert into tformresponsequestions (responseid,formid,formField,formValue,pollValue)
						values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#responseID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#formID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(thefield,255)#">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#info['#thefield#']#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(info['#thefield#'],255)#">)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>

		<cfif not StructIsEmpty(info)>
			<cfwddx action="cfml2wddx" input="#info#" output="theXml">
			<cfquery>
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
			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
				Select * from tformresponsequestions
				where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#"/>
			</cfquery>

			<cfloop query="rs">
				<cfif findNoCase('attachment',rs.formField) and isValid("UUID",rs.formValue)>
					<cfset variables.filemanager.deleteVersion(rs.formValue)/>
				</cfif>
			</cfloop>
			</cfif>

		<cfquery>
			delete from tformresponsequestions
			where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#"/>
		</cfquery>


		<cfquery>
			delete from tformresponsepackets
			where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#"/>
		</cfquery>

	</cffunction>

	<cffunction name="read" returntype="query" output="true" access="public">
		<cfargument name="responseID" type="string">
		<cfset var rs="">

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
			select *  from tformresponsepackets
			where responseID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.responseID#">
		</cfquery>

		<cfreturn rs>
	</cffunction>

	<cffunction name="getFullFieldList" returntype="string" output="true" access="public">
		<cfargument name="formID" type="string">
		<cfset var rs="">

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
			select distinct formField from tformresponsequestions
			where formID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formID#">
			order by formField asc
		</cfquery>

		<cfreturn valueList(rs.formField) />

	</cffunction>

	<cffunction name="getCurrentFieldList" returntype="string" output="true" access="public">
		<cfargument name="formID" type="string">
		<cfset var rs="">

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
			SELECT responseDisplayFields
			FROM tcontent
			WHERE ContentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formID#">
			AND active = 1
		</cfquery>

		<cfset var responseDisplayFields=listFirst(rs.responseDisplayFields,'~')>

		<cfif len(responseDisplayFields)>
			<cfreturn replace(responseDisplayFields, "^", ",","all") />
		<cfelse>
			<cfreturn getFullFieldList(arguments.formid) />
		</cfif>
	</cffunction>

	<cffunction name="getData" returntype="query" access="public" output="false">
		<cfargument name="data" type="struct">
		<cfset var rs=""/>
		<cfset var extend= arguments.data.sortby neq '' and arguments.data.sortBy neq 'Entered' and listFind(arguments.data.fieldnames,arguments.data.sortBy)>
		<cfset var start="" />
		<cfset var stop="" />

		<cfif isdefined('arguments.data.date1') and lsIsDate(arguments.data.date1)>
			<cfset start = lsParseDateTime(arguments.data.date1) />
			<cfset start = createdatetime(year(start),month(start),day(start),arguments.data.hour1,arguments.data.minute1,0)>
		</cfif>

		<cfif isdefined('arguments.data.date2') and lsIsDate(arguments.data.date2)>
			<cfset stop = lsParseDateTime(arguments.data.date2) />
			<cfset stop = createdatetime(year(stop),month(stop),day(stop),arguments.data.hour2,arguments.data.minute2,59)>
		</cfif>

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
			select tformresponsepackets.* from tformresponsepackets
			<cfif extend>
				left join tformresponsequestions extend on tformresponsepackets.responseid= extend.responseid
			</cfif>
			<cfif arguments.data.keywords neq ''>
				left join tformresponsequestions keywords on tformresponsepackets.responseid= keywords.responseid
			</cfif>
			where tformresponsepackets.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteID#"/> and tformresponsepackets.formid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#"/>
			<cfif extend>
				and extend.formField= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.sortBy#"/>
			</cfif>
			<cfif lsIsDate(start)>
				and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start#">
			</cfif>
			<cfif lsIsDate(stop)>
				and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#stop#">
			</cfif>
			<cfif arguments.data.keywords neq ''>
				and keywords.pollValue like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.keywords#">

				<cfif listFind(arguments.data.fieldnames,arguments.data.filterBy) and arguments.data.filterBy neq ''>
					and keywords.formField = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.filterBy#">
				</cfif>

			</cfif>

			<cfif  arguments.data.sortBy eq 'Entered' or (listFind(arguments.data.fieldnames,arguments.data.sortBy) and arguments.data.sortby neq '')>
				order by <cfif arguments.data.sortBy eq 'Entered'>tformresponsepackets.entered<cfelse>extend.pollValue</cfif> #arguments.data.sortDirection#
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
		<cfargument name="$">

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

		<cfset body=rereplacenocase(arguments.preBody,'</form>','#formHTML##arguments.$.renderCSRFTokens(format="form",context=arguments.formID)#</form>')>
		<cfif not find(frmID,body)>
			<cfset body=rereplacenocase(body,'<form','<form id="#frmID#" ')>
		</cfif>


		<cfsavecontent variable="frm"><cfoutput>
		#body#
		<cfif request.muraFrontEndRequest>
		<script type="text/javascript">
			$(function(){
				var frm=$('###frmID#');
				var action=frm.attr('action');

				if(typeof action != 'undefined'){
					if(action.indexOf('?') > -1){
						action=action + '&nocache=1';
					} else {
						action=action + '?nocache=1';
					}
				} else {
					action='?nocache=1';
				}

				if(frm.attr('onsubmit') == undefined){
					frm.on('submit',function(){return validateForm(this);})
				}
				<cfif arguments.responseChart>
					var polllist=new Array();
					frm.find("input[type='radio']").each(function(){
						polllist.push($(this).val());
					});
					if(polllist.length > 0) {action += '&polllist='+ polllist.toString();}
				</cfif>

				frm.attr('action',action + '###frmID#');
				frm.attr('method','post');
			});
		</script></cfif></cfoutput>
		</cfsavecontent>

		<cfreturn trim(frm) />
	</cffunction>

	<cffunction name="setDisplay" output="false" returntype="void" access="public">
		<cfargument name="contentBean" type="any" >

		<cfquery>
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

	<cffunction name="_deserializeWDDX" output="false">
		<cfargument name="wddx">
		<cfwddx action="wddx2cfml" input="#arguments.wddx#" output="local.data">

		<cfreturn local.data>
	</cffunction>
</cfcomponent>
