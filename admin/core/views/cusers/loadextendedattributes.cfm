<!--- 
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

<cfsilent>
<cfset request.layout=false>
<cfset returnsets=structNew()>
<cfif isDefined("session.mura.editBean") and isInstanceOf(session.mura.editBean, "mura.user.userBean") and session.mura.editBean.getUserID() eq rc.baseID>
	<cfset userBean=session.mura.editBean>
<cfelse>
	<cfset userBean=application.userManager.read(userid=rc.baseID, siteid=rc.siteid)/>
</cfif>
<cfset structDelete(session.mura,"editBean")>
<cfset extendSets=application.classExtensionManager.getSubTypeByName(rc.type,rc.subtype,rc.siteid).getExtendSets(inherit=true,container="Default",activeOnly=true) />
<!---
<cfif userBean.getType() eq 2>
	<cfset started=false />
<cfelse>
	<cfset started=true />
</cfif
--->
<cfset started=false />
<cfset style="" />
</cfsilent>
<cfsavecontent variable="returnsets.extended">
<cfoutput>
<cfif arrayLen(extendSets)>
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
<cfset extendSetBean=extendSets[s]/>
<cfif  userBean.getType() eq 2><cfset style=extendSetBean.getStyle()/><cfif not len(style)><cfset started=true/></cfif></cfif>
	<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
	<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
	<div class="fieldset">
		<h2>#extendSetBean.getName()#</h2>
	<cfsilent>
	<cfset attributesArray=extendSetBean.getAttributes() />
	</cfsilent>
	<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
		<cfset attributeBean=attributesArray[a]/>
		<cfset attributeValue=userBean.getvalue(attributeBean.getName(),'useMuraDefault') />
		<div class="control-group">
	      	<label class="control-label">
			<cfif len(attributeBean.getHint())>
			<a href="##" rel="tooltip" title="#esapiEncode('html',attributeBean.gethint())#">#attributeBean.getLabel()# <i class="icon-question-sign"></i></a>
			<cfelse>
			#attributeBean.getLabel()#
			</cfif>
			<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'> 

				<cfif listFindNoCase("png,jpg,jpeg",application.serviceFactory.getBean("fileManager").readMeta(attributeValue).fileExt)>
					<a href="./index.cfm?muraAction=cArch.imagedetails&amp;userid=#userBean.getUserID()#&amp;siteid=#userBean.getSiteID()#&amp;fileid=#attributeValue#"><img id="assocImage" src="#application.configBean.getContext()#//index.cfm/_api/render/small/?fileid=#attributeValue#&amp;cacheID=#createUUID()#" /></a>
				</cfif>

				<a href="#application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#attributeValue#" target="_blank">[#rbKey('user.download')#]</a> <input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/> #rbKey('user.delete')# </cfif>
			</label>
			<!--- if it's an hidden type attribute then flip it to be a textbox so it can be editable through the admin --->
			<cfif attributeBean.getType() IS "Hidden">
				<cfset attributeBean.setType( "TextBox" ) />
			</cfif>	
			<div class="controls">
				#attributeBean.renderAttribute(attributeValue)#
			</div>
		</div>
	</cfloop>
	</div>
	</span>
</cfloop>
</cfif>
</cfoutput>
</cfsavecontent>
<cfset returnsets.extended=trim(returnsets.extended)>
<cfsilent>
<cfset extendSets=application.classExtensionManager.getSubTypeByName(rc.type,rc.subtype,rc.siteid).getExtendSets(inherit=true,container="Basic",activeOnly=true) />
<cfif userBean.getType() eq 2>
	<cfset started=false />
<cfelse>
	<cfset started=true />
</cfif>
<cfset style="" />
</cfsilent>
<cfsavecontent variable="returnsets.basic">
<cfoutput>
<cfif arrayLen(extendSets)>
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
<cfset extendSetBean=extendSets[s]/>
<cfif  userBean.getType() eq 2><cfset style=extendSetBean.getStyle()/><cfif not len(style)><cfset started=true/></cfif></cfif>
	<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
	<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
	<div class="fieldset">
		<h2>#extendSetBean.getName()#</h2>
	<cfsilent>
	<cfset attributesArray=extendSetBean.getAttributes() />
	</cfsilent>
	<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
		<cfset attributeBean=attributesArray[a]/>
		<cfset attributeValue=userBean.getvalue(attributeBean.getName(),'useMuraDefault') />
		<div class="control-group">
	      	<label class="control-label">
			<cfif len(attributeBean.getHint())>
			<a href="##" rel="tooltip" title="#esapiEncode('html',attributeBean.gethint())#">#attributeBean.getLabel()# <i class="icon-question-sign"></i></a>
			<cfelse>
			#attributeBean.getLabel()#
			</cfif>
			<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'> 

				<cfif listFindNoCase("png,jpg,jpeg",application.serviceFactory.getBean("fileManager").readMeta(attributeValue).fileExt)>
					<a href="./index.cfm?muraAction=cArch.imagedetails&amp;userid=#userBean.getUserID()#&amp;siteid=#userBean.getSiteID()#&amp;fileid=#attributeValue#"><img id="assocImage" src="#application.configBean.getContext()#/index.cfm/_api/render/small/?fileid=#attributeValue#&amp;cacheID=#createUUID()#" /></a>
				</cfif>

				<a href="#application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#attributeValue#" target="_blank">[#rbKey('user.download')#]</a> <input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/> #rbKey('user.delete')#</cfif>
			</label>
			<!--- if it's an hidden type attribute then flip it to be a textbox so it can be editable through the admin --->
			<cfif attributeBean.getType() IS "Hidden">
				<cfset attributeBean.setType( "TextBox" ) />
			</cfif>	
			<div class="controls">
				#attributeBean.renderAttribute(attributeValue)#
			</div>
		</div>
	</cfloop>
	</div>
	</span>
</cfloop>
</cfif>
</cfoutput>
</cfsavecontent>
<cfset returnsets.basic=trim(returnsets.basic)>
<cfoutput>#createObject("component","mura.json").encode(returnsets)#</cfoutput>