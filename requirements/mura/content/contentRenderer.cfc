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

• Must not alter any" default objects in the Mura CMS database and
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

<cfset this.navOffSet=0/>
<cfset this.navDepthLimit=1000/>
<cfset this.navParentIdx=2/>
<cfset this.navGrandParentIdx=3/>
<cfset this.navDepthAdjust=0/>
<cfset this.navSelfIdx=1/>
<cfset this.jslib="jquery"/>
<cfset this.jsLibLoaded=false/>
<cfset this.longDateFormat="long"/>
<cfset this.shortDateFormat="short"/>
<cfset this.showMetaList="jpg,jpeg,png,gif">
<cfset this.imageInList="jpg,jpeg,png,gif">
<cfset this.directImages=true/>
<cfset this.personalization="user">
<cfset this.hasEditableObjects=false>
<cfif isDefined('url.muraadminpreview')>
	<cfset this.showAdminToolBar=false/>
	<cfset this.showMemberToolBar=false/>
	<cfset this.showEditableObjects=false/>
	<cfset this.showInlineEditor=false/>
<cfelse>
	<cfset this.showAdminToolBar=true/>
	<cfset this.showMemberToolBar=true/>
	<cfset this.showEditableObjects=true/>
	<cfset this.showInlineEditor=true/>
</cfif>
<!--- renderHTMLHead has been deprecated in favor of renderHTMLQueues---->
<cfset this.renderHTMLHead=true/>
<cfset this.renderHTMLQueues=true/>
<cfset this.crumbdata=arrayNew(1)/>
<cfset this.listFormat="dl">
<cfset this.headline="h2"/>
<cfset this.subHead1="h3"/>
<cfset this.subHead2="h4"/>
<cfset this.subHead3="h5"/>
<cfset this.subHead4="h6">
<!--- This is duplicated for when the page title gets set to h1 ---> 
<cfset this.subHead5="h6">
<!--- These settings are for navigational display objects --->
<cfset this.navWrapperClass="sidebar-nav well">
<cfset this.liHasKidsClass="">
<cfset this.liHasKidsCustomString="">
<cfset this.liCurrentClass="current">
<cfset this.liCurrentCustomString="">
<cfset this.liHasKidsNestedClass="">
<cfset this.aHasKidsClass="">
<cfset this.aHasKidsCustomString="">
<cfset this.aCurrentClass="current">
<cfset this.aCurrentCustomString="">
<cfset this.ulNestedClass="">
<cfset this.ulNestedCustomString="">
<cfset this.ulTopClass="navSecondary">
<cfset this.ulPaginationClass="navSequential">
<cfset this.ulPaginationWrapperClass="pagination">
<cfset this.formWrapperClass="well">
<cfset this.generalWrapperClass="well">
<cfset this.aNotCurrentClass="">


<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="event" required="true" default="">

	<cfif isObject(arguments.event)>
		<cfset variables.event=arguments.event>
	<cfelse>
		<cfset variables.event=createObject("component","mura.servletEvent")>
	</cfif>
	<cfset variables.$=variables.event.getValue("muraScope")>
	<cfset variables.mura=variables.$>
	
	<cfif request.muraExportHtml>
		<cfset this.showEditableObjects=false>
		<cfset this.showAdminToolBar=false>
		<cfset this.showMemberToolBar=false>
	</cfif>

	<cfset variables.contentGateway=getBean('contentGateway')>

	<cfif not isDefined('this.enableMuraTag')>
		<cfset this.enableMuraTag=getConfigBean().getEnableMuraTag() />
	</cfif>
	
<cfreturn this />
</cffunction>

<cffunction name="getHeaderTag" returntype="string" output="false">
<cfargument name="header">
	<cfif listFindNoCase("headline,subHead1,subHead2,subHead3,subHead4,subHead5",arguments.header)>
	<cfreturn this["#arguments.header#"]/>
	<cfelse>
	<cfreturn "Invalid Argument. Must be one of 'headline, subHead1, subHead2, subHead3, subHead4, subHead5'">
	</cfif>
</cffunction>

<cffunction name="setJsLib" returntype="void" output="false">
<cfargument name="jsLib">
	<cfset this.jsLib=arguments.jsLib />
</cffunction>

<cffunction name="getJsLib" returntype="string" output="false">
	<cfreturn this.jsLib />
</cffunction>

<cffunction name="setRenderHTMLQueues" returntype="void" output="false">
<cfargument name="renderHTMLQueues">
	<cfset this.renderHTMLQueues=arguments.renderHTMLQueues />
</cffunction>

<cffunction name="getRenderHTMLQueues" returntype="string" output="false">
	<cfreturn this.renderHTMLQueues and this.renderHTMLHead />
</cffunction>

<cffunction name="setRenderHTMLHead" returntype="void" output="false" hint="This is deprecated.">
<cfargument name="renderHTMLHead">
	<cfset this.renderHTMLQueues=arguments.renderHTMLHead />
</cffunction>

<cffunction name="getRenderHTMLHead" returntype="string" output="false" hint="This is deprecated.">
	<cfreturn this.renderHTMLQueues />
</cffunction>

<cffunction name="setShowAdminToolBar" returntype="void" output="false">
<cfargument name="showAdminToolBar">
	<cfset this.showAdminToolBar=arguments.showAdminToolBar />
</cffunction>

<cffunction name="getShowAdminToolBar" returntype="string" output="false">
	<cfreturn this.showAdminToolBar />
</cffunction>

<cffunction name="getPersonalization" returntype="string" output="false">
	<cfreturn this.personalization />
</cffunction>

<cffunction name="getPersonalizationID" returntype="string" output="false">
	<cfif getPersonalization() eq "user">
	<cfreturn session.mura.userID />
	<cfelse>
	<cfif not structKeyExists(cookie,"pid")>
	<cfcookie name="pid" expires="never" value="#application.utility.getUUID()#">
	</cfif>
	<cfreturn cookie.pid />
	</cfif>
</cffunction>

<cffunction name="getListFormat" returntype="string" output="false">
	<cfreturn this.listFormat />
</cffunction>

<cffunction name="setListFormat" output="false">
	<cfargument name="listFormat">
	<cfset this.listFormat=arguments.listFormat>
	<cfreturn this/>
</cffunction>

<cffunction name="loadJSLib" returntype="void" output="false">
	<cfif not this.jsLibLoaded>
	<cfswitch expression="#getJsLib()#">
		<cfcase value="prototype">
			<cfset addToHTMLHeadQueue("prototype.cfm","prepend")>
			<cfset addToHTMLHeadQueue("scriptaculous.cfm","prepend")>
		</cfcase>
		<cfdefaultcase>
			<cfset addToHTMLHeadQueue("jquery.cfm","prepend")>
		</cfdefaultcase>
		</cfswitch>
	</cfif>
</cffunction>

<cffunction name="loadShadowboxJS" returntype="void" output="false">
	<cfif not cookie.mobileFormat>
		<cfset loadJSLib() />
		<cfswitch expression="#getJsLib()#">
			<cfcase value="prototype">
				<cfset addToHTMLHeadQueue("shadowbox-prototype.cfm")>
			</cfcase>
			<cfdefaultcase>
				<cfset addToHTMLHeadQueue("shadowbox-jquery.cfm")>
			</cfdefaultcase>
		</cfswitch>			
		<cfset addToHTMLHeadQueue("shadowbox.cfm")>
	</cfif>
</cffunction>

<cffunction name="setLongDateFormat" returntype="void" output="false">
<cfargument name="longDateFormat">
	<cfset this.longDateFormat=arguments.longDateFormat />
</cffunction>

<cffunction name="getLongDateFormat" returntype="string" output="false">
	<cfreturn this.longDateFormat />
</cffunction>

<cffunction name="setShortDateFormat" returntype="void" output="false">
<cfargument name="shortDateFormat">
	<cfset this.shortDateFormat=arguments.shortDateFormat />
</cffunction>

<cffunction name="getShortDateFormat" returntype="string" output="false">
	<cfreturn this.shortDateFormat />
</cffunction>

<cffunction name="setNavOffSet" returntype="void" output="false">
<cfargument name="navOffSet">
	<cfif not variables.event.getValue('contentBean').getIsNew()>
		<cfset this.navOffSet=arguments.navOffSet />
	</cfif>
</cffunction>

<cffunction name="setNavDepthLimit" returntype="void" output="false">
<cfargument name="navDepthLimit">

	<cfset this.navDepthLimit=arguments.navDepthLimit />
	
	<cfif arrayLen(this.crumbdata) gt this.navDepthLimit >
		<cfset this.navDepthAdjust=arraylen(this.crumbdata)-this.navDepthLimit />
		<cfset this.navGrandParentIdx= 3 + this.navDepthAdjust />
		<cfset this.navParentIdx=2 + this.navDepthAdjust />
		<cfset this.navSelfIdx= 1 + this.navDepthAdjust />
	</cfif>

</cffunction>

<cffunction name="showItemMeta" returntype="any" output="false">
<cfargument name="fileExt">
	<cfif listFind(this.showMetaList,lcase(arguments.fileExt))>
	<cfreturn 1>
	<cfelse>
	<cfreturn variables.event.getValue('showMeta')>
	</cfif>
</cffunction>

<cffunction name="showImageInList" returntype="any" output="false">
<cfargument name="fileExt">
	<cfreturn listFind(this.imageInList,lcase(arguments.fileExt))>
</cffunction>

<cffunction name="allowLink" output="false" returntype="boolean">
			<cfargument name="restrict" type="numeric"  default=0>
			<cfargument name="restrictgroups" type="string" default="" />
			<cfargument name="loggedIn"  type="numeric" default=0 />
			<cfargument name="rspage"  type="query" />
		
			<cfset var allowLink=true>
			<cfset var G = 0 />
			<cfif  arguments.loggedIn and (arguments.restrict)>
						<cfif arguments.restrictgroups eq '' or listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite(variables.event.getValue('siteID')).getPrivateUserPoolID()#') or listFind(session.mura.memberships,'S2')>
									<cfset allowLink=True>
							<cfelseif arguments.restrictgroups neq ''>
									<cfset allowLink=False>
									<cfloop list="#arguments.restrictgroups#" index="G">
										<cfif listFind(session.mura.memberships,'#G#;#application.settingsManager.getSite(variables.event.getValue('siteID')).getPublicUserPoolID()#;1')>
										<cfset allowLink=true>
										</cfif>
									</cfloop>
							</cfif>
			</cfif>
			
		<cfreturn allowLink>
</cffunction>

<cffunction name="getTopId" output="false" returntype="string">
	<cfargument name="useNavOffset" required="true" default="false"/>
		<cfset var id="homepage">
		<cfset var topId="">
		<cfset var offset=1>

		<cfif arguments.useNavOffset>
			<cfset offset=1+this.navOffset/>
		</cfif>
		
		<cfif arrayLen(this.crumbdata) gt offset>
			<cfset topID = replace(getCrumbVarByLevel("filename",offset),"_"," ","ALL")>
			<cfset topID = setCamelback(topID)>
			<cfset id = Left(LCase(topID), 1)>
			<cfif len(topID) gt 1>
				<cfset id=id & Right(topID, Len(topID)-1)>
			</cfif>
		</cfif>
		
		<cfif variables.event.getValue('contentBean').getIsNew() eq 1>
			<cfset id = "fourzerofour">
		</cfif>
		
		<cfreturn id>
</cffunction>

<cffunction name="getTopVar" output="false" returntype="string">
	<cfargument name="topVar" required="true" default="" type="String">
	<cfargument name="useNavOffset" required="true" type="boolean" default="false">
		<cfset var theVar="">
		<cfset var offset=1>
		
		<cfif arguments.useNavOffset>
			<cfset offset=offset+this.navOffset/>
		</cfif>

		<cfreturn getCrumbVarByLevel(arguments.topVar,offset)>
				
</cffunction>

<cffunction name="getCrumbVarByLevel" output="false" returntype="string">
	<cfargument name="theVar" required="true" default="" type="String">
	<cfargument name="level" required="true" type="numeric" default="1">
						
		<cfif arrayLen(this.crumbData) gt arguments.level>
			<cfreturn this.crumbData[arrayLen(this.crumbData)-arguments.level][arguments.theVar]>
		<cfelse>
			<cfreturn "">
		</cfif>
			
</cffunction>

<cffunction name="dspZoomText" returntype="string" output="false">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfargument name="separator" required="yes" default=">">
		<cfset var crumbLen=arrayLen(arguments.crumbdata)>
		<cfset var I = 0 />
		<cfset var content="">
		<cfsavecontent variable="content">
		<cfoutput>
		<cfloop from="#crumbLen#" to="2" index="I" step="-1">
		#arguments.crumbdata[I].menutitle#  #arguments.separator#
		</cfloop>
		#arguments.crumbdata[1].menutitle#
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
</cffunction>

<cffunction name="dspZoom" returntype="string" output="false">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfargument name="fileExt" type="string" default="" hint="deprecated, this is now in the crumbData">
		<cfargument name="ajax" type="boolean" default="false">
		<cfargument name="class" type="string" default="navZoom">
		<cfset var content = "">
		<cfset var locked = "">
		<cfset var lastlocked = "">
		<cfset var crumbLen=arrayLen(arguments.crumbdata)>
		<cfset var I = 0 />
		<cfset var anchorString="">
		
		<cfsavecontent variable="content">
		<cfoutput>
			 <ul class="#arguments.class#">
		<cfloop from="#crumbLen#" to="2" index="I" step="-1">
		<cfsilent>
		<cfif arguments.crumbdata[i].restricted eq 1><cfset locked="locked"></cfif>
		</cfsilent>
		<li class="#renderIcon(arguments.crumbdata[i])# #locked#<cfif arguments.crumbdata[i].type eq 'File'> file</cfif>"<cfif arguments.crumbdata[i].type eq 'File'> data-filetype="#renderIcon(arguments.crumbdata[i])#"</cfif>>
		<a <cfif arguments.ajax> 
			href="" onclick="return siteManager.loadSiteManagerInTab(function(){siteManager.loadSiteManager('#arguments.crumbdata[I].siteid#','#arguments.crumbdata[I].contentid#','00000000000000000000000000000000000','','','#arguments.crumbdata[I].type#',1)});"
		<cfelse>
			href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list&siteid=#arguments.crumbdata[I].siteid#&topid=#arguments.crumbdata[I].contentid#&moduleid=00000000000000000000000000000000000&activeTab=0"
		</cfif>>#HTMLEditformat(arguments.crumbdata[I].menutitle)#</a> &raquo;</li>
		</cfloop>
		<cfsilent>
		<cfif locked eq "locked" or arguments.crumbdata[1].restricted eq 1>
			<cfset lastlocked="locked">
		</cfif>
		</cfsilent>
		<li class="#renderIcon(arguments.crumbdata[1])# #lastlocked#<cfif arguments.crumbdata[i].type eq 'File'> file</cfif>"<cfif arguments.crumbdata[i].type eq 'File'> data-filetype="#renderIcon(arguments.crumbdata[i])#"</cfif>><strong>
		<a <cfif arguments.ajax> 
			href="" onclick="return siteManager.loadSiteManagerInTab(function(){siteManager.loadSiteManager('#arguments.crumbdata[1].siteid#','#arguments.crumbdata[1].contentid#','00000000000000000000000000000000000','','','#arguments.crumbdata[1].type#',1)});"
		<cfelse>
			href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list&siteid=#arguments.crumbdata[1].siteid#&topid=#arguments.crumbdata[1].contentid#&moduleid=00000000000000000000000000000000000&activeTab=0"
		</cfif>>#HTMLEditformat(arguments.crumbdata[1].menutitle)#</a></strong></li></ul>
	
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
</cffunction>

<cffunction name="dspZoomNoLinks" returntype="string" output="false">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfargument name="fileExt" type="string" default="" hint="deprecated, this is now in the crumbData">
		<cfargument name="class" type="string" default="navZoom">
		<cfset var content = "">
		<cfset var locked = "">
		<cfset var lastlocked = "">
		<cfset var crumbLen=arrayLen(arguments.crumbdata)>
		<cfset var I = 0 />
		<cfsavecontent variable="content">
		<cfoutput>
		 <ul class="#arguments.class#">
		<cfloop from="#crumbLen#" to="2" index="I" step="-1">
		<cfif arguments.crumbdata[i].restricted eq 1><cfset locked="locked"></cfif>
		<li class="#renderIcon(arguments.crumbdata[i])# #locked#<cfif arguments.crumbdata[i].type eq 'File'> file</cfif>"<cfif arguments.crumbdata[i].type eq 'File'> data-filetype="#renderIcon(arguments.crumbdata[i])#"</cfif>> #HTMLEditformat(arguments.crumbdata[I].menutitle)# &raquo;</li>
		</cfloop>
		<cfif locked eq "locked" or arguments.crumbdata[1].restricted eq 1><cfset lastlocked="locked"></cfif>
		<li class="#renderIcon(arguments.crumbdata[1])# #lastlocked#<cfif arguments.crumbdata[i].type eq 'File'> file</cfif>"<cfif arguments.crumbdata[i].type eq 'File'> data-filetype="#renderIcon(arguments.crumbdata[i])#"</cfif>><strong><cfif arguments.crumbdata[1].type eq 'Page' or arguments.crumbdata[1].type eq 'Folder' or arguments.crumbdata[1].type eq 'Calendar'> #HTMLEditformat(arguments.crumbdata[1].menutitle)#<cfelse> #HTMLEditformat(crumbdata[1].menutitle)#</cfif></strong></li></ul></cfoutput></cfsavecontent>
		<cfreturn content />
</cffunction>

<cffunction name="dspNestedNav" output="false" returntype="string">
		<cfargument name="contentid" type="string" >
		<cfargument name="viewDepth" type="numeric" required="true" default="1">
		<cfargument name="currDepth" type="numeric"  required="true"  default="1">
		<cfargument name="type" type="string"  default="default">
		<cfargument name="today" type="date"  default="#now()#">
		<cfargument name="class" type="string" default="#this.ulTopClass#">
		<cfargument name="querystring" type="string" default="">
		<cfargument name="sortBy" type="string" default="orderno">
		<cfargument name="sortDirection" type="string" default="asc">
		<cfargument name="context" type="string" default="#application.configBean.getContext()#">
		<cfargument name="stub" type="string" default="#application.configBean.getStub()#">
		<cfargument name="categoryID" type="string" default="">
		<cfargument name="relatedID" type="string" default="">
		<cfargument name="rs" required="true" default="">
		<cfargument name="subNavExpression" required="true" default="">
		<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
		<cfargument name="liHasKidsCustomString" required="true" default="#this.liHasKidsCustomString#">
		<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
		<cfargument name="liCurrentCustomString" required="true" default="#this.liCurrentCustomString#">
		<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
		<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
		<cfargument name="aHasKidsCustomString" required="true" default="#this.aHasKidsCustomString#">
		<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
		<cfargument name="aCurrentCustomString" required="true" default="#this.aCurrentCustomString#">
		<cfargument name="ulNestedClass" required="true" default="#this.ulNestedClass#">
		<cfargument name="ulNestedCustomString" required="true" default="#this.ulNestedCustomString#">
		<cfargument name="openCurrentOnly" required="true" default="false">
		<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">

		<cfset var rsSection=arguments.rs>
		<cfset var adjust=0>
		<cfset var current=0>
		<cfset var link=''>
		<cfset var itemClass=''>
		<cfset var isCurrent=false>
		<cfset var nest=''>
		<cfset var subnav=false>
		<cfset var theNav="">
		<cfset var nestedArgs=structNew()>
		<cfset var linkArgs=structNew()>
		<cfset var started=false>
		
		<cfif not isQuery(rsSection)>
			<cfset rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000',variables.event.getValue('siteID'),arguments.contentid,arguments.type,arguments.today,50,'',0,arguments.sortBy,arguments.sortDirection,arguments.categoryID,arguments.relatedID)>
		</cfif>

		<cfif isDefined("arguments.ulTopClass") and arguments.currDepth eq 1>
			<cfset arguments.class=arguments.ulTopClass>
		</cfif>
		
		<cfif rsSection.recordcount and ((variables.event.getValue('r').restrict and variables.event.getValue('r').allow) or (not variables.event.getValue('r').restrict))>
			<cfset adjust=rsSection.recordcount>

			<cfsavecontent variable="theNav">
			<cfoutput>
			<cfloop query="rsSection">
			<cfif allowLink(rssection.restricted,rssection.restrictgroups,variables.event.getValue('r').loggedIn)>
			<cfsilent>
				<cfif len(arguments.subNavExpression)>
					<cfset subnav=evaluate(arguments.subNavExpression)>
				<cfelse>
					<cfset subnav=(((ListFind("Page,Folder,Calendar",rsSection.type)) and arguments.openCurrentOnly and (this.crumbData[this.navSelfIdx].contentID eq rsSection.contentid or this.crumbData[this.navSelfIdx].parentID eq rsSection.contentid) ) or ((listFindNoCase("Page,Calendar",rsSection.type)) and not arguments.openCurrentOnly)) and arguments.currDepth lt arguments.viewDepth and rsSection.type neq 'Gallery' and not (rsSection.restricted and not session.mura.isLoggedIn) >
				</cfif>
			
				<cfset current=current+1>
				<cfset nest=''>
				<cfif subnav>
					<cfset nestedArgs.contentID=rssection.contentid>
					<cfset nestedArgs.currDepth=arguments.currDepth+1>
					<cfset nestedArgs.type=iif(rssection.type eq 'calendar',de('fixed'),de('default'))>
					<cfset nestedArgs.sortBy=rsSection.sortBy>
					<cfset nestedArgs.sortDirection=rsSection.sortDirection>
					<cfset nestedArgs.class="">
					<cfset nestedArgs.ulTopClass="">
					<cfset structAppend(nestedArgs,arguments,false)>
					<cfset nest=dspNestedNav(argumentCollection=nestedArgs) />
					<cfset subnav=subnav and find("<li",nest)>
				</cfif>
				
				<cfif subnav and arguments.currDepth gt 1 and len(arguments.liHasKidsNestedClass)>
					<cfset itemClass=arguments.liHasKidsNestedClass>
				<cfelse>
					<cfset itemClass="">
				</cfif>

				<cfif current eq 1>
					<cfset itemClass=listAppend(itemClass,'first',' ')>
				</cfif>
				<cfif current eq adjust>
					<cfset itemClass=listAppend(itemClass,'last',' ')>
				</cfif>
				
				<cfset isCurrent=listFind(variables.event.getValue('contentBean').getPath(),"#rsSection.contentid#") />
			
				<cfif isCurrent and len(arguments.liCurrentClass)>
					<cfset itemClass=listAppend(itemClass,arguments.liCurrentClass," ")>
				</cfif>
				<cfif subnav and len(arguments.liHasKidsClass)>
					<cfset itemClass=listAppend(itemClass,arguments.liHasKidsClass," ")/>
				</cfif>

				<cfset linkArgs=structNew()>
				<cfset linkArgs.aHasKidsClass=arguments.aHasKidsClass>
				<cfset linkArgs.aHasKidsCustomString=arguments.aHasKidsCustomString>
				<cfset linkArgs.aNotCurrentClass=arguments.aNotCurrentClass>
				<cfset linkArgs.aCurrentClass=arguments.aCurrentClass>
				<cfset linkArgs.aCurrentCustomString=arguments.aCurrentCustomString>
				<cfset linkArgs.type=rsSection.type>
				<cfset linkArgs.filename=rsSection.filename>
				<cfset linkArgs.title=rsSection.menutitle>
				<cfset linkArgs.contentid=rsSection.contentid>
				<cfset linkArgs.target=rsSection.target>
				<cfset linkArgs.targetParams=rsSection.targetParams>
				<cfset linkArgs.siteID=variables.event.getValue('siteID')>
				<cfset linkArgs.querystring=arguments.querystring>
				<cfset linkArgs.isParent=subnav>
				<cfset link=addlink(argumentCollection=linkArgs)>
			</cfsilent>
			<cfif not started>
				<cfset started=true>
				<ul<cfif arguments.currDepth eq 1 and len(arguments.class)> class="#arguments.class#"<cfelse><cfif len(arguments.ulNestedClass)> class="#arguments.ulNestedClass#"</cfif><cfif len(arguments.ulNestedCustomString)> #arguments.ulNestedCustomString#</cfif></cfif>>
			</cfif>
			<li<cfif len(itemClass)> class="#itemClass#"</cfif><cfif len(arguments.liCurrentCustomString)> #arguments.liCurrentCustomString#</cfif>>#link#<cfif subnav>#nest#</cfif></li><cfelse><cfset adjust=adjust-1></cfif></cfloop>
			<cfif started></ul></cfif></cfoutput>
			</cfsavecontent>
		</cfif>
		<cfreturn theNav />
</cffunction>

<cffunction name="dspCrumblistLinks"  output="false" returntype="string"> 
<cfargument name="id" type="string" default="crumblist">
<cfargument name="separator" type="string" default="">
<cfargument name="class" type="string" default="">
<cfset var thenav="" />
<cfset var theOffset=arrayLen(this.crumbdata)- this.navOffSet />
<cfset var I = 0 />
<cfif arrayLen(this.crumbdata) gt (1 + this.navOffSet)>
	<cfsavecontent variable="theNav">
		<cfoutput><ul<cfif len(arguments.id)> id="#arguments.id#"</cfif><cfif len(arguments.class)> class="#arguments.class#"</cfif>>
			<cfloop from="#theOffset#" to="1" index="I" step="-1"><cfif I neq 1><li class="#iif(I eq theOffset,de('first'),de(''))#"><cfif i neq theOffset>#arguments.separator#</cfif>#addlink(this.crumbdata[I].type,this.crumbdata[I].filename,this.crumbdata[I].menutitle,'_self','',this.crumbdata[I].contentid,this.crumbdata[I].siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile(),variables.event.getValue('showMeta'),0)#</li><cfelse><li class="#iif(arraylen(this.crumbdata),de('last'),de('first'))#">#arguments.separator##addlink(this.crumbdata[1].type,this.crumbdata[1].filename,this.crumbdata[1].menutitle,'_self','',this.crumbdata[1].contentid,this.crumbdata[1].siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile(),variables.event.getValue('showMeta'),0)#</li></cfif></cfloop>
		</ul></cfoutput>
	</cfsavecontent>
</cfif>

<cfreturn trim(theNav)>
</cffunction>

<cffunction name="renderIcon" returntype="string" output="false">
<cfargument name="data">

<cfif arguments.data.type eq 'File'>
	<cfif structKeyExists(arguments.data,"fileExt")>
		<cfreturn lcase(arguments.data.fileExt)>
	<cfelse>
		<cfreturn "page">
	</cfif>
	
<cfelse>
	<cfreturn lcase(arguments.data.type)>
</cfif>

</cffunction>

<!--- For backward compatibility --->
<cffunction name="dspPortalNav" output="false" returntype="string">
	<cfreturn dspFolderNav(argumentCollection=arguments)>
</cffunction>
<!--- --->

<cffunction name="dspFolderNav" output="false" returntype="string">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsCustomString" required="true" default="#this.liHasKidsCustomString#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentCustomString" required="true" default="#this.liCurrentCustomString#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsCustomString" required="true" default="#this.aHasKidsCustomString#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentCustomString" required="true" default="#this.aCurrentCustomString#">
	<cfargument name="ulNestedClass" required="true" default="#this.ulNestedClass#">
	<cfargument name="ulNestedCustomString" required="true" default="#this.ulNestedCustomString#">

	<cfset var thenav="" />
	<cfset var menutype="" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspFolderNav")>

	<cfset nestedArgs.openCurrentOnly=true>
	""
	<cfif variables.event.getValue('contentBean').getType() eq 'Folder' or variables.event.getValue('contentBean').getType() eq 'Gallery'>
		<cfif arraylen(this.crumbdata) gt (this.navParentIdx+this.navOffSet)>
			<cfif arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and (this.crumbdata[this.navGrandParentIdx].type neq 'Folder' or this.crumbdata[this.navGrandParentIdx].type neq 'Gallery') and not variables.contentGateway.getCount(variables.event.getValue('siteID'),this.crumbdata[this.navSelfIdx].contentID)>
				<cfset nestedArgs.contentID=this.crumbdata[this.navGrandParentIdx].contentid>
				<cfset nestedArgs.viewDepth=2>
				<cfset nestedArgs.currDepth=1>
				<cfset nestedArgs.sortBy=this.crumbdata[this.navGrandParentIdx].sortBy>
				<cfset nestedArgs.sortDirection=this.crumbdata[this.navGrandParentIdx].sortDirection>
				<cfset nestedArgs.categoryID=variables.event.getValue('categoryID')>
				<cfset structAppend(nestedArgs,arguments,false)>
				<cfset theNav = dspNestedNav(argumentCollection=nestedArgs) />
			<cfelse>
				<cfset thenav=dspPeerNav(argumentCollection=arguments) />
			</cfif>
		</cfif>
	<cfelseif arrayLen(this.crumbdata) gt (this.navSelfIdx+this.navOffSet) and this.crumbdata[this.navParentIdx].type eq 'Folder' or (arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and this.crumbdata[this.navGrandParentIdx].type eq 'Folder')>
		<cfif arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and this.crumbdata[this.navGrandParentIdx].type neq 'Folder' and not variables.contentGateway.getCount(variables.event.getValue('siteID'),this.crumbdata[this.navSelfIdx].contentID)>
			<cfset nestedArgs.contentID=this.crumbdata[this.navGrandParentIdx].contentid>
			<cfset nestedArgs.viewDepth=1>
			<cfset nestedArgs.currDepth=1>
			<cfset nestedArgs.sortBy=this.crumbdata[this.navGrandParentIdx].sortBy>
			<cfset nestedArgs.sortDirection=this.crumbdata[this.navGrandParentIdx].sortDirection>
			<cfset nestedArgs.categoryID=variables.event.getValue('categoryID')>
			<cfset structAppend(nestedArgs,arguments,false)>

			<cfset theNav = dspNestedNav(argumentCollection=nestedArgs) />
		<cfelse>
			<cfset thenav=dspSubNav(argumentCollection=nestedArgs) />
		</cfif>
	<cfelse>
		<cfset thenav=dspStandardNav(argumentCollection=nestedArgs) />
	</cfif>
	<cfset commitTracePoint(tracePoint)>

	<cfreturn thenav />
</cffunction>

<cffunction name="dspStandardNav" output="false" returntype="string">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsCustomString" required="true" default="#this.liHasKidsCustomString#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentCustomString" required="true" default="#this.liCurrentCustomString#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsCustomString" required="true" default="#this.aHasKidsCustomString#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentCustomString" required="true" default="#this.aCurrentCustomString#">
	<cfargument name="ulNestedClass" required="true" default="#this.ulNestedClass#">
	<cfargument name="ulNestedCustomString" required="true" default="#this.ulNestedCustomString#">
	<cfset var thenav="" />
	<cfset var menutype="" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspStandardNav")>

	<cfset nestedArgs.openCurrentOnly=true>

	<cfif variables.event.getValue('contentBean').getType() neq 'Gallery'>
			<cfif arraylen(this.crumbdata) gt (this.navParentIdx+this.navOffSet)>
				<cfif this.crumbdata[this.navParentIdx].type eq 'calendar'>
					<cfset menutype='fixed'>
				<cfelse>
					<cfset menutype='default'>
				</cfif>
				<cfif arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and not variables.contentGateway.getCount(variables.event.getValue('siteID'),this.crumbdata[this.navSelfIdx].contentID)>
					<cfset nestedArgs.contentID=this.crumbdata[this.navGrandParentIdx].contentid>
					<cfset nestedArgs.viewDepth=2>
					<cfset nestedArgs.currDepth=1>
					<cfset nestedArgs.type=menutype>
					<cfset nestedArgs.sortBy=this.crumbdata[this.navGrandParentIdx].sortBy>
					<cfset nestedArgs.sortDirection=this.crumbdata[this.navGrandParentIdx].sortDirection>
					<cfset structAppend(nestedArgs,arguments,false)>
					<cfset theNav = dspNestedNav(argumentCollection=nestedArgs) />	
				<cfelse>
					<cfset nestedArgs.contentID=this.crumbdata[this.navParentIdx].contentid>
					<cfset nestedArgs.viewDepth=2>
					<cfset nestedArgs.currDepth=1>
					<cfset nestedArgs.type=menutype>
					<cfset nestedArgs.sortBy=this.crumbdata[this.navParentIdx].sortBy>
					<cfset nestedArgs.sortDirection=this.crumbdata[this.navParentIdx].sortDirection>
					<cfset structAppend(nestedArgs,arguments,false)>
					<cfset theNav = dspNestedNav(argumentCollection=nestedArgs) />
				</cfif>			
			<cfelse>
				<cfset theNav=dspSubNav(argumentCollection=arguments) />
			</cfif>	
	<cfelse>
			<cfset thenav=dspFolderNav(argumentCollection=arguments) />
	</cfif>

	<cfset commitTracePoint(tracePoint)>

	<cfreturn thenav>
</cffunction>

<cffunction name="dspSubNav" output="false" returntype="string">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsCustomString" required="true" default="#this.liHasKidsCustomString#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentCustomString" required="true" default="#this.liCurrentCustomString#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsCustomString" required="true" default="#this.aHasKidsCustomString#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentCustomString" required="true" default="#this.aCurrentCustomString#">

	<cfset var thenav="" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspSubNav")>

	<cfset nestedArgs.openCurrentOnly=true>

	<cfif arraylen(this.crumbdata) gt (this.navSelfIdx+this.navOffSet)>	
		<cfset nestedArgs.contentID=this.crumbdata[this.navSelfIdx].contentID>
		<cfset nestedArgs.viewDepth=1>
		<cfset nestedArgs.currDepth=1>
		<cfif this.crumbdata[this.navSelfIdx].type eq 'Calendar'>
			<cfset nestedArgs.type='fixed'>
		<cfelse>
			<cfset nestedArgs.type='default'>
		</cfif>
		<cfset nestedArgs.sortBy=this.crumbdata[this.navSelfIdx].sortBy>
		<cfset nestedArgs.sortDirection=this.crumbdata[this.navSelfIdx].sortDirection>
		<cfset structAppend(nestedArgs,arguments,false)>
		<cfset theNav = dspNestedNav(argumentCollection=nestedArgs) />
	</cfif>
			
	<cfset commitTracePoint(tracePoint)>

	<cfreturn thenav />
</cffunction>

<cffunction name="dspPeerNav" output="false" returntype="string">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsCustomString" required="true" default="#this.liHasKidsCustomString#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentCustomString" required="true" default="#this.liCurrentCustomString#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsCustomString" required="true" default="#this.aHasKidsCustomString#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentCustomString" required="true" default="#this.aCurrentCustomString#">
	
	<cfset var thenav="" />
	<cfset var menutype = "" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspPeerNav")>

	<cfset nestedArgs.openCurrentOnly=true>

	<cfif variables.event.getContentBean().getContentID() neq '00000000000000000000000000000000001'
		 and arraylen(this.crumbdata) gt (this.navParentIdx+this.navOffSet)>
		<cfset nestedArgs.contentID=this.crumbdata[this.navParentIdx].contentID>
		<cfset nestedArgs.viewDepth=1>
		<cfset nestedArgs.currDepth=1>
		<cfif this.crumbdata[this.navParentIdx].type eq 'calendar'>
			<cfset nestedArgs.type='fixed'>
		<cfelse>
			<cfset nestedArgs.type='default'>
		</cfif>
		<cfset nestedArgs.sortBy=this.crumbdata[this.navParentIdx].sortBy>
		<cfset nestedArgs.sortDirection=this.crumbdata[this.navParentIdx].sortDirection>
		<cfset structAppend(nestedArgs,arguments,false)>
		<cfset theNav = dspNestedNav(argumentCollection=nestedArgs) />
	</cfif>
	
	<cfset commitTracePoint(tracePoint)>

	<cfreturn theNav />
</cffunction>

<cffunction name="dspSequentialNav" output="false" returntype="string">
		<cfset var rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000','#variables.event.getValue('siteID')#','#variables.event.getValue('contentBean').getparentid()#','default',now(),0,'',0,'#this.crumbdata[2].sortBy#','#this.crumbdata[2].sortDirection#')>
		<cfset var link=''>
		<cfset var class=''>
		<cfset var itemClass=''>
		<cfset var theNav="">
		<cfset var current=1>
		<cfset var next=1>
		<cfset var prev=1>
		<cfset var tracepoint=initTracepoint("contentRenderer.dspSequentialNav")>

		<cfif rsSection.recordcount and ((variables.event.getValue('r').restrict and variables.event.getValue('r').allow) or (not variables.event.getValue('r').restrict))>
			<cfloop query="rsSection">
			<cfif rssection.filename eq variables.event.getValue('contentBean').getfilename()>
				<cfset prev=iif((rsSection.currentrow - 1) lt 1,de(rsSection.recordcount),de(rsSection.currentrow-1)) />
				<cfset current=rsSection.currentrow />
				<cfset next=iif((rsSection.currentrow + 1) gt rsSection.recordcount,de(1),de(rsSection.currentrow + 1)) />
			</cfif>
			</cfloop>

			<cfsavecontent variable="theNav">
			<cfoutput>
			<ul class="#this.ulPaginationClass#">
			<cfif rsSection.contentID[1] neq variables.event.getValue('contentBean').getContentID()>
			<li ><a href="./?linkServID=#rsSection.contentID[prev]#">&laquo; #getSite().getRBFactory().getKey("sitemanager.prev")#</a></li>
			</cfif>
			<cfloop query="rsSection">
			<cfsilent>
				<cfset itemClass=iif(variables.event.getValue('contentBean').getfilename() eq rsSection.filename,de('#this.liCurrentClass#'),de('')) />
				<cfset link=addlink(rsSection.type,rsSection.filename,rssection.currentrow,'','',rsSection.contentid,variables.event.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile(),showItemMeta(rsSection.fileExt))>
			</cfsilent>
			<li<cfif len(itemClass)> class="#itemClass#"</cfif>>#link#</li>
			</cfloop>
			<cfif rsSection.contentID[rsSection.recordcount] neq variables.event.getValue('contentBean').getContentID()>
			<li><a href="./?linkServID=#rsSection.contentID[next]#">#getSite().getRBFactory().getKey("sitemanager.next")# &raquo;</a></li>
			</cfif>
			</ul></cfoutput>
			</cfsavecontent>
		</cfif>

		<cfset commitTracePoint(tracePoint)>

		<cfreturn trim(theNav) />
</cffunction>

<cffunction name="dspGalleryNav" output="false" returntype="string">
		<cfset var rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000',variables.event.getValue('siteID'),variables.event.getValue('contentBean').getcontentID(),'default',now(),0,'',0,variables.event.getValue('contentBean').getsortBy(),variables.event.getValue('contentBean').getsortDirection(),variables.event.getValue('categoryID'),variables.event.getValue('relatedID'))>
		<cfset var link=''>
		<cfset var class=''>
		<cfset var itemClass=''>
		<cfset var theNav="">
		<cfset var current=1>
		<cfset var next=1>
		<cfset var prev=1>
		<cfset var tracepoint=initTracepoint("contentRenderer.dspGalleryNav")>
		
		<cfif rsSection.recordcount and ((variables.event.getValue('r').restrict and variables.event.getValue('r').allow) or (not variables.event.getValue('r').restrict))>
			
			<cfloop query="rsSection">
			<cfif rssection.contentID eq variables.event.getValue('galleryItemID')>
				<cfset prev=iif((rsSection.currentrow - 1) lt 1,de(rsSection.recordcount),de(rsSection.currentrow-1)) />
				<cfset current=rsSection.currentrow />
				<cfset next=iif((rsSection.currentrow + 1) gt rsSection.recordcount,de(1),de(rsSection.currentrow + 1)) />
			</cfif>
			</cfloop>
			
			<cfsavecontent variable="theNav">
			<cfoutput>
			<ul class="navSequential">
			<li class="first">
			 <a href="#application.configBean.getIndexFile()#?startrow=#variables.event.getValue('startRow')#&galleryItemID=#rsSection.contentid[prev]#&categoryID=#variables.event.getValue('categoryID')#&relatedID=#variables.event.getValue('relatedID')#">&laquo; Prev</a>
			</li>
			<cfloop query="rsSection">
			<cfsilent>
				<cfset itemClass=iif(variables.event.getValue('galleryItemID') eq rsSection.contentID,de('current'),de('')) />
				<cfset link='<a href="#application.configBean.getIndexFile()#?startrow=#variables.event.getValue('startRow')#&galleryItemID=#rsSection.contentID#&categoryID=#variables.event.getValue('categoryID')#">#rsSection.currentRow#</a>'>
			</cfsilent>
			<li class="#itemClass#">#link#</li>
			</cfloop>
			<li class="last"> <a href="#application.configBean.getIndexFile()#?startrow=#variables.event.getValue('startRow')#&galleryItemID=#rsSection.contentid[next]#&categoryID=#variables.event.getValue('categoryID')#">Next &raquo;</a></li>
			</ul></cfoutput>
			</cfsavecontent>
		</cfif>

		<cfset commitTracePoint(tracePoint)>
		
		<cfreturn trim(theNav) />
</cffunction>

<cffunction name="dspSessionNav" output="false" returntype="string">
	<cfargument name="id" type="string" default="">
	<cfset var returnUrl = "" />
	<cfset var thenav = "" />

	<cfif variables.event.getValue('returnURL') neq "">
		<cfset returnUrl = variables.event.getValue('returnURL')>
	<cfelse>
		<cfset returnURL = URLEncodedFormat(getCurrentURL())>
	</cfif>
		
	<cfsavecontent variable="theNav">
		<cfif getSite().getExtranet() eq 1 and session.mura.isLoggedIn>
			<cfoutput><ul id="#arguments.id#"><li><a href="#application.configBean.getIndexFile()#?doaction=logout&nocache=1">Log Out #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#</a></li><li><a href="#application.settingsManager.getSite(variables.event.getValue('siteID')).getEditProfileURL()#&returnURL=#returnURL#&nocache=1">Edit Profile</a></li></ul></cfoutput>
		</cfif>
	</cfsavecontent>
			
	<cfreturn trim(thenav) />
</cffunction>

<cffunction name="dspTagCloud" access="public" output="false" returntype="string">
<cfargument name="parentID" type="any"  required="true" default="" />
<cfargument name="categoryID"  type="any" required="true" default="" />
<cfargument name="rsContent"  type="any"  required="true"  default="" />
	<cfset var theIncludePath = variables.event.getSite().getIncludePath() />
	<cfset var fileDelim = application.configBean.getFileDelim() />
	<cfset var filePath = theIncludePath  & fileDelim & "includes" & fileDelim />
	<cfset var theContent = "" />
	<cfset var theme =variables.$.siteConfig("theme")>
	<cfset var expandedPath=expandPath(filePath)>
	<cfset var str="">
	<cfset var tracePoint=0>
	
	<cfsavecontent variable="str">
	<cfif fileExists(expandedPath & "themes/"  & theme & "/display_objects/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#filePath#themes/#theme#/display_objects/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#themes/#theme#/display_objects/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandedPath & "display_objects/custom/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#filePath#display_objects/custom/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#display_objects/custom/nav/dsp_tag_cloud.cfm" />
	<cfelse>
		<cfset tracePoint=initTracePoint("#filePath#display_objects/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#display_objects/nav/dsp_tag_cloud.cfm" />
	</cfif>
	</cfsavecontent>
	
	<cfset commitTracePoint(tracePoint)>
	
<cfreturn str />
</cffunction>

<cffunction name="getURLStem" access="public" output="false" returntype="string">
	<cfargument name="siteID">
	<cfargument name="filename">
	<cfreturn application.contentServer.getURLStem(argumentCollection=arguments)>
</cffunction>

<cffunction name="createHREF" returntype="string" output="false" access="public">
	<cfargument name="type" required="true" default="Page">
	<cfargument name="filename" required="true">
	<cfargument name="siteid" required="true" default="">
	<cfargument name="contentid" required="true" default="">
	<cfargument name="target" required="true" default="">
	<cfargument name="targetParams" required="true" default="" hint="deprecated, does not do anything.  May come be re-introduced for modal params">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#">
	<cfargument name="indexFile" type="string" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="showMeta" type="string" required="true" default="0">
	
	<cfset var href=""/>
	<cfset var tp=""/>
	<cfset var begin=iif(arguments.complete or isDefined('variables.$') and len(variables.$.event('siteID')) and variables.$.event('siteID') neq arguments.siteID,de('http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#'),de('')) />
	<cfset var lookUpBean="">

	<cfif len(arguments.querystring) and not left(arguments.querystring,1) eq "?">
		<cfset arguments.querystring="?" & arguments.querystring>
	</cfif>
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="Link,File">
			<cfif not request.muraExportHTML>
				<cfset href=HTMLEditFormat("#begin##arguments.context##getURLStem(arguments.siteid,'#arguments.filename#')##arguments.querystring#") />
			<cfelseif arguments.type eq "Link">
				<cfset lookUpBean=application.serviceFactory.getBean("content").loadBy(contentID=arguments.contentID,siteID=arguments.siteID)>
				<cfset href=lookUpBean.getBody()>
			<cfelse>
				<cfset lookUpBean=application.serviceFactory.getBean("content").loadBy(contentID=arguments.contentID,siteID=arguments.siteID)>
				<cfset href="#arguments.context#/#arguments.siteID#/cache/file/#lookUpBean.getFileID()#/#lookUpBean.getBody()#">
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset href=HTMLEditFormat("#begin##arguments.context##getURLStem(arguments.siteid,'#arguments.filename#')##arguments.querystring#") />
		</cfdefaultcase>
	</cfswitch>
		
	<cfif arguments.target eq "_blank" and arguments.showMeta eq 0>
		<cfset href="javascript:newWin=window.open('#href#','NewWin#replace('#rand()#','.','')#');newWin.focus();void(0);" />
	</cfif>

<cfreturn href />
</cffunction>

<cffunction name="createHREFforRSS" returntype="string" output="false" access="public">
	<cfargument name="type" required="true" default="Page">
	<cfargument name="filename" required="true">
	<cfargument name="siteid" required="true">
	<cfargument name="contentid" required="true" default="">
	<cfargument name="target" required="true" default="">
	<cfargument name="targetParams" required="true" default="">
	<cfargument name="context" type="string" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" default="#application.configBean.getStub()#">
	<cfargument name="indexFile" type="string" default="">
	<cfargument name="showMeta" type="string" default="0">
	<cfargument name="fileExt" type="string" default="" required="true">
	
	<cfset var href=""/>
	<cfset var tp=""/>
	<cfset var begin="http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#" />
	
		<cfswitch expression="#arguments.type#">
				<cfcase value="Link">
					<cfset href="#begin##arguments.context##getURLStem(arguments.siteid,'')#?LinkServID=#arguments.contentid#&showMeta=#arguments.showMeta#"/>
				</cfcase>
				<cfcase value="File">
					<cfset href="#begin##arguments.context##getURLStem(arguments.siteid,'')#?LinkServID=#arguments.contentid#&showMeta=#arguments.showMeta#&fileExt=.#arguments.fileExt#"/>
				</cfcase>
				<cfdefaultcase>
					<cfset href="#begin##arguments.context##getURLStem(arguments.siteid,'#arguments.filename#')#" />
				</cfdefaultcase>
		</cfswitch>
		

<cfreturn href />
</cffunction>

<cffunction name="createHREFForImage" output="false" returntype="any">
<cfargument name="siteID">
<cfargument name="fileID">
<cfargument name="fileExt">
<cfargument name="size" required="true" default="undefined">
<cfargument name="direct" required="true" default="#this.directImages#">
<cfargument name="complete" type="boolean" required="true" default="false">
<cfargument name="height" default=""/>
<cfargument name="width" default=""/>

	<cfreturn getBean("fileManager").createHREFForImage(argumentCollection=arguments)>
	
</cffunction>

<cffunction name="addlink" output="false" returntype="string">
	<cfargument name="type" required="true">
	<cfargument name="filename" required="true">
	<cfargument name="title" required="true">
	<cfargument name="target" type="string"  default="">
	<cfargument name="targetParams" type="string"  default="">
	<cfargument name="contentid" required="true">
	<cfargument name="siteid" required="true">
	<cfargument name="querystring" type="string" required="true" default="">
	<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#">
	<cfargument name="indexFile" type="string" required="true" default="">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfargument name="showCurrent" type="string" required="true" default="1">
	<cfargument name="class" type="string" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="id" type="string" required="true" default="">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsCustomString" required="true" default="#this.aHasKidsCustomString#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentCustomString" required="true" default="#this.aCurrentCustomString#">
	<cfargument name="isParent" required="true" default="false">
	<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">
			
	<cfset var link ="">
	<cfset var href ="">
	<cfset var theClass =arguments.class>

	<cfif arguments.showCurrent>
		<cfset arguments.showCurrent=listFind(variables.event.getValue('contentBean').getPath(),"#arguments.contentID#")>
	</cfif>
	<cfif arguments.showCurrent>					
		<cfset theClass=listAppend(theClass,arguments.aCurrentClass," ") />
	<cfelseif len(arguments.aNotCurrentClass)>
		<cfset theClass=listAppend(theClass,arguments.aNotCurrentClass," ") />
	</cfif>
	<cfif arguments.isParent>					
		<cfset theClass=listAppend(theClass,arguments.aHasKidsClass," ") />
	</cfif>
		
	<cfset href=createHREF(arguments.type,arguments.filename,arguments.siteid,arguments.contentid,arguments.target,iif(arguments.filename eq variables.event.getValue('contentBean').getfilename(),de(''),de(arguments.targetParams)),arguments.queryString,arguments.context,arguments.stub,arguments.indexFile,arguments.complete,arguments.showMeta)>
	<cfset link='<a href="#href#"#iif(len(theClass),de(' class="#theClass#"'),de(""))##iif(len(arguments.id),de(' id="#arguments.id#"'),de(""))##iif(arguments.showCurrent,de(' #replace(arguments.aCurrentCustomString,"##","####","all")#'),de(""))##iif(arguments.isParent and len(arguments.aHasKidsCustomString),de(' #replace(arguments.aHasKidsCustomString,"##","####","all")#'),de(""))#>#HTMLEditFormat(arguments.title)#</a>' />
	<cfreturn link>
</cffunction>

<cffunction name="dspObject_Render" access="public" output="false" returntype="string">
	<cfargument name="siteid" type="string" />
	<cfargument name="object" type="string" />
	<cfargument name="objectid" type="string" />
	<cfargument name="fileName" type="string" />
	<cfargument name="cacheKey" type="string" required="false"  />
	<cfargument name="hasSummary" type="boolean" required="false" default="true" />
	<cfargument name="useRss" type="boolean" required="false" default="false" />
	<cfargument name="params" type="string" required="false" default="" />
	<cfargument name="assignmentID" type="string" required="true" default="">
	<cfargument name="regionID" required="true" default="0">
	<cfargument name="orderno" required="true" default="0">
	<cfargument name="showEditable" required="true" default="false">

	<cfset var theContent=""/>
	<cfset var objectPerm="none">

	<cfif StructKeyExists(arguments,"cacheKey") and not arguments.showEditable>
		<cfsavecontent variable="theContent">
		<cf_CacheOMatic key="#arguments.cacheKey#" nocache="#variables.event.getValue('nocache')#">
			<cfoutput>#dspObject_Include(arguments.siteid,arguments.object,arguments.objectid,arguments.fileName,arguments.hasSummary,arguments.useRss,"none",arguments.params,arguments.assignmentID,arguments.regionID,arguments.orderno)#</cfoutput>
		</cf_cacheomatic>
		</cfsavecontent>
	<cfelse>
		<cfset theContent = dspObject_Include(arguments.siteid,arguments.object,arguments.objectid,arguments.fileName,arguments.hasSummary,arguments.useRss,objectPerm,arguments.params,arguments.assignmentID,arguments.regionID,arguments.orderno) />
	</cfif>
	<cfreturn theContent />

</cffunction>

<cffunction name="dspObject_Include" access="public" output="false" returntype="string">
	<cfargument name="siteid" type="string" />
	<cfargument name="object" type="string" />
	<cfargument name="objectid" type="string" />
	<cfargument name="theFile" type="string" />
	<cfargument name="hasSummary" type="boolean" required="true" default="false"/>
	<cfargument name="RSS" type="boolean" required="true" default="false" />
	<cfargument name="objectPerm" type="string" required="true" default="none" />
	<cfargument name="params" type="string" required="true" default="" />
	<cfargument name="assignmentID" type="string" required="true" default="">
	<cfargument name="regionID" required="true" default="0">
	<cfargument name="orderno" required="true" default="0">
	<cfargument name="contentHistID" required="true" default="0">
	
	<cfset var fileDelim = application.configBean.getFileDelim() />
	<cfset var displayObjectPath = variables.$.siteConfig('IncludePath') & fileDelim & "includes"  & fileDelim & "display_objects"/>
	<cfset var themeObjectPath = variables.$.siteConfig('ThemeIncludePath') & fileDelim & "display_objects"/>
	<cfset var themePath = variables.$.siteConfig('themeAssetPath') />
	<cfset var useRss = arguments.RSS />
	<cfset var bean = "" />
	<cfset var theContent = "" />
	<cfset var editableControl = structNew()>
	<cfset var expandedDisplayObjectPath=expandPath(displayObjectPath)>
	<cfset var expandedThemeObjectPath=expandPath(themeObjectPath)>
	<cfset var tracePoint=0>
	<cfset var objectParams="">
	
	<cfif isJSON(arguments.params)>
		<cfset objectParams=deserializeJSON(arguments.params)>
	<cfelse>
		<cfset objectParams=structNew()>
	</cfif>

	<!--- For backward compatability with old dsp_feed.cfm files --->
	<cfif arguments.thefile eq "dsp_feed.cfm">
		<cfparam name="objectParams.displaySummaries" default="#arguments.hasSummary#">	
	</cfif>
	
	<cfsavecontent variable="theContent">
	<cfif fileExists(expandedThemeObjectPath & fileDelim & arguments.theFile)>
		<cfset tracePoint=initTracePoint("#themeObjectPath#/#arguments.theFile#")>
		<cfinclude template="#themeObjectPath#/#arguments.theFile#" />
		<cfset commitTracePoint(tracePoint)>
	<cfelseif fileExists(expandedDisplayObjectPath & fileDelim & "custom" & fileDelim & arguments.theFile)>
		<cfset tracePoint=initTracePoint("#displayObjectPath#/custom/#arguments.theFile#")>
		<cfinclude template="#displayObjectPath#/custom/#arguments.theFile#" />
		<cfset commitTracePoint(tracePoint)>
	<cfelse>
		<cfset tracePoint=initTracePoint("#displayObjectPath#/#arguments.theFile#")>
		<cfinclude template="#displayObjectPath#/#arguments.theFile#" />
		<cfset commitTracePoint(tracePoint)>
	</cfif>
	</cfsavecontent>
	<cfreturn theContent />

</cffunction>

<cffunction name="dspObject" access="public" output="false" returntype="string">
<cfargument name="object" type="string">
<cfargument name="objectid" type="string" required="true" default="">
<cfargument name="siteid" type="string" required="true" default="#variables.event.getValue('siteID')#">
<cfargument name="params" type="string" required="true" default="">
<cfargument name="assignmentID" type="string" required="true" default="">
<cfargument name="regionID" required="true" default="0">
<cfargument name="orderno" required="true" default="0">
<cfargument name="hasConfigurator" required="true" default="false">
<cfargument name="assignmentPerm" required="true" default="none">

	<cfset var theObject = "" />
	<cfset var cacheKeyContentId = arguments.object & variables.event.getValue('contentBean').getcontentID() />
	<cfset var cacheKeyObjectId = arguments.object & arguments.objectid />
	<cfset var showEditable=false/>
	<cfset var editableControl=structNew()>
	<cfset var historyID="">
	<cfset var tempObject="">
	
	<cfswitch expression="#arguments.object#">
		<cfcase value="plugin">
			<cfif session.mura.isLoggedIn and this.showEditableObjects >
				<cfset showEditable=arguments.hasConfigurator and listFindNoCase("editor,author",arguments.assignmentPerm)>		
				<cfif showEditable>
					<cfset editableControl.class="editablePlugin">
					<cfset editableControl.editLink = "#variables.$.globalConfig('context')#/admin/index.cfm?muraAction=cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="feed,feed_slideshow,feed_no_summary,feed_slideshow_no_summary">
			<cfset addToHTMLHeadQueue("listImageStyles.cfm")>
			<cfif session.mura.isLoggedIn and this.showEditableObjects >
				<cfset showEditable=this.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>		
				<cfif showEditable>
					<cfset editableControl.class="editableFeed">
					<cfset editableControl.editLink =  "#variables.$.globalConfig('context')#/admin/index.cfm?muraAction=cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="category_summary,category_summary_rss">
			<cfif session.mura.isLoggedIn and this.showEditableObjects >	
				<cfset showEditable=this.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>		
				<cfif showEditable>
					<cfset editableControl.class="editableCategorySummary">
					<cfset editableControl.editLink =  "#variables.$.globalConfig('context')#/admin/index.cfm?muraAction=cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="related_content,related_section_content">
			<cfset addToHTMLHeadQueue("listImageStyles.cfm")>
			<cfif session.mura.isLoggedIn and this.showEditableObjects >	
				<cfset showEditable=this.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>		
				<cfif showEditable>
					<cfset editableControl.class="editableRelatedContent">
					<cfset editableControl.editLink =  "#variables.$.globalConfig('context')#/admin/index.cfm?muraAction=cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="component,form">
			<cfif session.mura.isLoggedIn and this.showEditableObjects>	
				<cfset showEditable=listFindNoCase("editor,author",application.permUtility.getDisplayObjectPerm(arguments.siteID,arguments.object,arguments.objectID))>		
				<cfif showEditable>
					<cfset historyID = variables.$.getBean("contentGateway").getContentHistIDFromContentID(contentID=arguments.objectID,siteID=arguments.siteID)>
					<cfif arguments.object eq "component">
						<cfset editableControl.class="editableComponent">
					<cfelse>
						<cfset editableControl.class="editableForm">
					</cfif>
					<cfset editableControl.editLink = "#variables.$.globalConfig('context')#/admin/index.cfm?muraAction=cArch.edit">
					<cfif len(variables.$.event('previewID'))>
						<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistid=" & variables.$.event('previewID')>
					<cfelse>
						<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistid=" & historyID>
					</cfif>	
					<cfset editableControl.editLink = editableControl.editLink & "&amp;siteid=" & arguments.siteID>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;contentid=" & arguments.objectID>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;topid=00000000000000000000000000000000001">
					<cfif arguments.object eq "component">
						<cfset editableControl.editLink = editableControl.editLink & "&amp;type=Component">
						<cfset editableControl.editLink = editableControl.editLink & "&amp;moduleid=00000000000000000000000000000000003">
						<cfset editableControl.editLink = editableControl.editLink & "&amp;parentid=00000000000000000000000000000000003">
					<cfelse>
						<cfset editableControl.editLink = editableControl.editLink & "&amp;type=Form">
						<cfset editableControl.editLink = editableControl.editLink & "&amp;moduleid=00000000000000000000000000000000004">
						<cfset editableControl.editLink = editableControl.editLink & "&amp;parentid=00000000000000000000000000000000004">
					</cfif>		
					<cfset editableControl.isConfigurator=false>
				</cfif>
			</cfif>
		</cfcase>
	</cfswitch>	
				
	<cfif showEditable>
		<cfif len(application.configBean.getAdminDomain())>
			<cfif application.configBean.getAdminSSL()>
				<cfset editableControl.editLink="https://#application.configBean.getAdminDomain()#" & editableControl.editLink/>
			<cfelse>
				<cfset editableControl.editLink="http://#application.configBean.getAdminDomain()#" & editableControl.editLink/>
			</cfif>
		</cfif>
			
		<cfset variables.$.loadShadowBoxJS()>
		<!---<cfset variables.$.addToHTMLHeadQueue('editableObjects.cfm')>--->
			
		<cfset editableControl.editLink = editableControl.editLink & "&amp;compactDisplay=true">
		<cfset editableControl.editLink = editableControl.editLink & "&amp;homeID=" & variables.$.content("contentID")>
		
		<cfif not listFindNoCase("Form,Component",arguments.object)>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistID=" & arguments.assignmentID>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;regionID=" & arguments.regionID>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;orderno=" & arguments.orderno>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;siteID=" & arguments.siteID>
		</cfif>

		<cfset this.hasEditableObjects=true>
	
		<cfset theObject=variables.$.renderEditableObjectHeader(editableControl.class)>
	</cfif>

	<cfswitch expression="#arguments.object#">
		<cfcase value="sub_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_sub.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="peer_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_peer.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="standard_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_standard.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="portal_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_portal.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="folder_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_folder.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="multilevel_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_multilevel.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="seq_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_sequential.cfm",cacheKeyContentId & variables.event.getValue('startRow'))></cfcase>
		<cfcase value="top_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_top.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="contact"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_contact.cfm")></cfcase>
		<cfcase value="calendar_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/calendarNav/index.cfm")></cfcase>
		<cfcase value="plugin">
			<cfset theObject=theObject & application.pluginManager.displayObject(object=arguments.objectid,event=variables.event,params=arguments.params)>
		</cfcase>
		<cfcase value="mailing_list"><cfset theObject=theObject & dspObject_Render(siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,fileName="dsp_mailing_list.cfm")></cfcase>
		<cfcase value="mailing_list_master"><cfset theObject=theObject & dspObject_Render(siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,fileName="dsp_mailing_list_master.cfm")></cfcase>
		<cfcase value="site_map"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_site_map.cfm",cacheKeyObjectId)></cfcase>							
		<cfcase value="category_summary"><cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_category_summary.cfm",cacheKey=cacheKeyObjectId & variables.event.getValue('categoryID'),params=arguments.params)></cfcase>
		<cfcase value="archive_nav"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"nav/dsp_archive.cfm",cacheKeyObjectId)></cfcase>
		<cfcase value="form"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"datacollection/index.cfm",cacheKeyObjectId)></cfcase>
		<cfcase value="form_responses"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dataresponses/index.cfm",cacheKeyObjectId & variables.event.getValue("responseID") & variables.event.getValue("startrow"))></cfcase>
		<cfcase value="component"><cfset theObject=theObject & dspObject_Render(siteid=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_template.cfm",cacheKey=cacheKeyObjectId,showEditable=showEditable)></cfcase>
		<cfcase value="ad"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_ad.cfm")></cfcase>
		<cfcase value="comments"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_comments.cfm")></cfcase>
		<cfcase value="event_reminder_form"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_event_reminder_form.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="forward_email"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_forward_email.cfm")></cfcase>
		<cfcase value="adzone"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_adZone.cfm")></cfcase>
		<cfcase value="feed">
			<cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_feed.cfm",cacheKey=cacheKeyObjectId  & getListFormat() & "startrow#request.startrow#",params=arguments.params,showEditable=showEditable)>
		</cfcase>	
		<cfcase value="feed_slideshow">
			<cfif not cookie.mobileFormat>	
				<cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="feedslideshow/index.cfm",params=arguments.params,showEditable=showEditable)>
			<cfelse>
				<cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_feed.cfm",params=arguments.params,showEditable=showEditable)>
			</cfif>
		</cfcase>
		<cfcase value="feed_table"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"feedtable/index.cfm",arguments.object,false)></cfcase>
		<cfcase value="payPalCart"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"paypalcart/index.cfm")></cfcase>
		<cfcase value="rater"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"rater/index.cfm")></cfcase>
		<cfcase value="favorites"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"favorites/index.cfm")></cfcase>
			<cfcase value="dragable_feeds"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dragablefeeds/index.cfm")></cfcase>
		<cfcase value="related_content">
			<cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_related_content.cfm",cacheKey=cacheKeyContentId & getListFormat(),params=arguments.params,showEditable=showEditable)>
		</cfcase>
		<cfcase value="related_section_content">
			<cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_related_section_content.cfm",cachekey=cacheKeyContentId & getListFormat(),params=arguments.params,showEditable=showEditable)>
		</cfcase>
		<cfcase value="user_tools"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_user_tools.cfm")></cfcase>
		<cfcase value="tag_cloud">
			<cfsavecontent variable="tempObject"><cf_CacheOMatic key="#arguments.siteid##arguments.object#" nocache="#variables.event.getValue('nocache')#"><cfoutput>#dspTagCloud()#</cfoutput></cf_CacheOMatic></cfsavecontent>
			<cfset theObject=theObject & tempObject> 
		</cfcase>
		<cfcase value="goToFirstChild"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"act_goToFirstChild.cfm")></cfcase>
		<!--- BEGIN DEPRICATED --->
		<cfcase value="submit_event"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_submit_event.cfm",cacheKeyContentId)></cfcase>
		<cfcase value="promo"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_promo.cfm")></cfcase>
		<cfcase value="public_content_form"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_public_content_form.cfm")></cfcase>
		<cfcase value="category_summary_rss"><cfset theObject=theObject & dspObject_Render(siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,fileName="dsp_category_summary.cfm",cacheKey=cacheKeyObjectId & variables.event.getValue('categoryID'),useRss=true)></cfcase>
		<cfcase value="feed_no_summary">
			<cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,fileName="dsp_feed.cfm",cacheKey=cacheKeyObjectId & "startrow#request.startrow#",hasSummary=false,params=arguments.params,showEditable=showEditable)>
		</cfcase>
		<cfcase value="feed_slideshow_no_summary">
			<cfif not cookie.mobileFormat>
				<cfset theObject=theObject & dspObject_Render(siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,fileName="feedslideshow/index.cfm",hasSummary=false,params=arguments.params,showEditable=showEditable)>
			<cfelse>
				<cfset theObject=theObject & dspObject_Render(siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,fileName="dsp_feed.cfm",cacheKey=cacheKeyObjectId & "startrow#request.startrow#",hasSummary=false,params=arguments.params,showEditable=showEditable)>
			</cfif>
		</cfcase>
		<cfcase value="related_section_content_no_summary">
			<cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_related_section_content.cfm",cacheKeyContentId,false)>
		</cfcase>	
		<cfcase value="features">
			<cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_features.cfm",cacheKeyObjectId)>
		</cfcase>
		<cfcase value="features_no_summary">
			<cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_features.cfm",cacheKeyObjectId,false)>
		</cfcase>		
		<cfcase value="category_features"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_category_features.cfm",cacheKeyObjectId)></cfcase>
		<cfcase value="category_features_no_summary"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_category_features.cfm",cacheKeyObjectId,false)></cfcase>
		<cfcase value="category_Folder_features"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_category_Folder_features.cfm",cacheKeyObjectId)></cfcase>
		<cfcase value="category_Folder_features_no_summary"><cfset theObject=theObject & dspObject_Render(arguments.siteid,arguments.object,arguments.objectid,"dsp_category_Folder_features.cfm",cacheKeyObjectId,false)></cfcase>
		<!--- END DEPRICATED --->
	</cfswitch>
	<cfif showEditable>
		<cfset theObject=theObject & renderEditableObjectFooter(variables.$.generateEditableObjectControl(editableControl.editLink,editableControl.isConfigurator))>
	</cfif>

	<cfreturn trim(theObject) />
</cffunction>

<cffunction name="dspObjects" access="public" output="false" returntype="string">
<cfargument name="columnID" required="yes" type="numeric" default="1">
<cfargument name="ContentHistID" required="yes" type="string" default="#variables.event.getValue('contentBean').getcontenthistid()#">
<cfset var rsObjects="">	
<cfset var theRegion= ""/>

<cfif (variables.event.getValue('isOnDisplay') 
		and ((not variables.event.getValue('r').restrict) 
			or (variables.event.getValue('r').restrict and variables.event.getValue('r').allow))) 
				and not (variables.event.getValue('display') neq '' and  getSite().getPrimaryColumn() eq arguments.columnid)>

	<cfif variables.event.getValue('contentBean').getinheritObjects() eq 'inherit' 
		and variables.event.getValue('inheritedObjects') neq ''
		and variables.event.getValue('contentBean').getcontenthistid() eq arguments.contentHistID>
			<cfset rsObjects=variables.contentGateway.getObjectInheritance(arguments.columnID,variables.event.getValue('inheritedObjects'),variables.event.getValue('siteID'))>	
			<cfloop query="rsObjects">
				<cfset theRegion = theRegion & dspObject(rsObjects.object,rsObjects.objectid,variables.event.getValue('siteID'), rsObjects.params, variables.event.getValue('inheritedObjects'), arguments.columnID, rsObjects.orderno, len(rsObjects.configuratorInit),variables.event.getValue("inheritedObjectsPerm")) />
			</cfloop>	
	</cfif>

	<cfset rsObjects=variables.contentGateway.getObjects(arguments.columnID,arguments.contentHistID,variables.event.getValue('siteID'))>	
	<cfloop query="rsObjects">
		<cfset theRegion = theRegion & dspObject(rsObjects.object,rsObjects.objectid,variables.event.getValue('siteID'), rsObjects.params, arguments.contentHistID, arguments.columnID, rsObjects.orderno, len(rsObjects.configuratorInit),variables.$.event('r').perm) />
	</cfloop>
</cfif>

<cfreturn trim(theRegion) />
</cffunction>

<cffunction name="dspBody"  output="false" returntype="string">
	<cfargument name="body" type="string" default="">
	<cfargument name="pagetitle" type="string" default="">
	<cfargument name="crumblist" type="numeric" default="1">
	<cfargument name="crumbseparator" type="string" default="&raquo;&nbsp;">
	<cfargument name="showMetaImage" type="numeric" default="1">
	<cfargument name="includeMetaHREF" type="boolean" default="true" />
	<cfargument name="bodyAttribute">
	<cfargument name="titleAttribute">
	
	<cfset var theIncludePath = variables.event.getSite().getIncludePath() />
	<cfset var str = "" />
	<cfset var fileDelim= application.configBean.getFileDelim() />
	<cfset var eventOutput="" />
	<cfset var rsPages="">
	<cfset var cacheStub="#variables.event.getValue('contentBean').getcontentID()##variables.event.getValue('pageNum')##variables.event.getValue('startrow')##variables.event.getValue('year')##variables.event.getValue('month')##variables.event.getValue('day')##variables.event.getValue('filterby')##variables.event.getValue('categoryID')##variables.event.getValue('relatedID')#">
	<cfset variables.event.setValue("BodyRenderArgs",arguments)>
	
	<cfsavecontent variable="str">
		<cfif (variables.event.getValue('isOnDisplay') and (not variables.event.getValue('r').restrict or (variables.event.getValue('r').restrict and variables.event.getValue('r').allow)))
			or (getSite().getextranetpublicreg() and variables.event.getValue('display') eq 'editprofile' and not session.mura.isLoggedIn) 
			or (variables.event.getValue('display') eq 'editprofile' and session.mura.isLoggedIn)>
			<cfif variables.event.getValue('display') neq ''>
				<cfswitch expression="#variables.event.getValue('display')#">
					<cfcase value="editprofile">
						<cfset variables.event.setValue('noCache',1)>
						<cfset variables.event.setValue('forceSSL',getSite().getExtranetSSL())/>
						<cfset eventOutput=application.pluginManager.renderEvent("onSiteEditProfileRender",variables.event)>
						<cfif len(eventOutput)>
						<cfoutput>#eventOutput#</cfoutput>
						<cfelse>
						<cfoutput>#dspObject_Include(thefile='dsp_edit_profile.cfm')#</cfoutput>
						</cfif>
					</cfcase>
					<cfcase value="search">
						<cfset variables.event.setValue('noCache',1)>
						<cfset eventOutput=application.pluginManager.renderEvent("onSiteSearchRender",variables.event)>
						<cfif len(eventOutput)>
						<cfoutput>#eventOutput#</cfoutput>
						<cfelse>
						<cfoutput>#dspObject_Include(thefile='dsp_search_results.cfm')#</cfoutput>
						</cfif>
					</cfcase> 
					<cfcase value="login">
						<cfset variables.event.setValue('noCache',1)>
						<cfset eventOutput=application.pluginManager.renderEvent("onSiteLoginPromptRender",variables.event)>
						<cfif len(eventOutput)>
						<cfoutput>#eventOutput#</cfoutput>
						<cfelse>
						<cfoutput>#dspObject_Include(thefile='dsp_login.cfm')#</cfoutput>
						</cfif>
					</cfcase>
				</cfswitch>
			<cfelse>
				 <cfoutput>
				 	<cfif structKeyExists(arguments,'titleAttribute')>
				 		<#getHeaderTag('headline')# class="pageTitle">#renderEditableAttribute(attribute=arguments.titleAttribute,required=true)#</#getHeaderTag('headline')#>
					<cfelseif arguments.pageTitle neq ''>
						<#getHeaderTag('headline')# class="pageTitle"><cfif arguments.pageTitle eq $.content('title')>#renderEditableAttribute(attribute='title',required=true)#<cfelse>#arguments.pageTitle#</cfif></#getHeaderTag('headline')#>
					</cfif>
					<cfif arguments.crumblist>
						#dspCrumbListLinks("crumblist",arguments.crumbseparator)#
					</cfif>			
				</cfoutput>

				<!--- For backwards compatibility --->
				<cfif variables.event.getContentBean().getType() eq 'Folder'>
					<cfset eventOutput=application.pluginManager.renderEvent("onPortalBodyRender",variables.event)>
					<cfif not len(eventOutput)>
						<cfset eventOutput=application.pluginManager.renderEvent("onPortal#variables.event.getContentBean().getSubType()#BodyRender",variables.event)>
					</cfif>
				</cfif>
				<!--- --->
				
				<cfif not len(eventOutput)>
					<cfset eventOutput=application.pluginManager.renderEvent("on#variables.event.getContentBean().getType()#BodyRender",variables.event)>
				</cfif>
				<cfif not len(eventOutput)>
					<cfset eventOutput=application.pluginManager.renderEvent("on#variables.event.getContentBean().getType()##variables.event.getContentBean().getSubType()#BodyRender",variables.event)>
				</cfif>
				<cfif not len(eventOutput)>
					<cfset eventOutput=application.pluginManager.renderEvent("on#variables.event.getContentBean().getType()#BodyRender",variables.event)>
				</cfif>
				
				<cfif len(eventOutput)>
					<cfoutput>#eventOutput#</cfoutput>
				<cfelseif $.content('type') eq 'Folder' and fileExists(expandPath(theIncludePath)  & fileDelim & "includes" & fileDelim & "themes" & fileDelim & variables.$.siteConfig("theme") & fileDelim & "display_objects" & fileDelim & "custom" & fileDelim & "extensions" & fileDelim & "dsp_Portal_" & variables.event.getValue('contentBean').getSubType() & ".cfm")>
					 <cfinclude template="#theIncludePath#/includes/themes/#variables.$.siteConfig('theme')#/display_objects/custom/extensions/dsp_#variables.event.getValue('contentBean').getType()#_#variables.event.getValue('contentBean').getSubType()#.cfm">
				<cfelseif $.content('type') eq 'Folder' and fileExists(expandPath(theIncludePath)  & fileDelim & "includes" & fileDelim & "themes" & fileDelim & variables.$.siteConfig("theme") & fileDelim & "display_objects" & fileDelim & "extensions" & fileDelim & "dsp_Portal_" & variables.event.getValue('contentBean').getSubType() & ".cfm")>
					 <cfinclude template="#theIncludePath#/includes/themes/#variables.$.siteConfig('theme')#/display_objects/custom/extensions/dsp_#variables.event.getValue('contentBean').getType()#_#variables.event.getValue('contentBean').getSubType()#.cfm">
				<cfelseif $.content('type') eq 'Folder' and fileExists(expandPath(theIncludePath)  & fileDelim & "includes" & fileDelim & "display_objects" & fileDelim & "custom" & fileDelim & "extensions" & fileDelim & "dsp_Portal_" & variables.event.getValue('contentBean').getSubType() & ".cfm")>
					 <cfinclude template="#theIncludePath#/includes/display_objects/custom/extensions/dsp_#variables.event.getValue('contentBean').getType()#_#variables.event.getValue('contentBean').getSubType()#.cfm">
				<cfelseif fileExists(expandPath(theIncludePath)  & fileDelim & "includes" & fileDelim & "themes" & fileDelim & variables.$.siteConfig("theme") & fileDelim & "display_objects" & fileDelim & "custom" & fileDelim & "extensions" & fileDelim & "dsp_" & variables.event.getValue('contentBean').getType() & "_" & variables.event.getValue('contentBean').getSubType() & ".cfm")>
					 <cfinclude template="#theIncludePath#/includes/themes/#variables.$.siteConfig('theme')#/display_objects/custom/extensions/dsp_#variables.event.getValue('contentBean').getType()#_#variables.event.getValue('contentBean').getSubType()#.cfm">
				<cfelseif fileExists(expandPath(theIncludePath)  & fileDelim & "includes" & fileDelim & "themes" & fileDelim & variables.$.siteConfig("theme") & fileDelim & "display_objects" & fileDelim & "extensions" & fileDelim & "dsp_" & variables.event.getValue('contentBean').getType() & "_" & variables.event.getValue('contentBean').getSubType() & ".cfm")>
					 <cfinclude template="#theIncludePath#/includes/themes/#variables.$.siteConfig('theme')#/display_objects/custom/extensions/dsp_#variables.event.getValue('contentBean').getType()#_#variables.event.getValue('contentBean').getSubType()#.cfm">
				<cfelseif fileExists(expandPath(theIncludePath)  & fileDelim & "includes" & fileDelim & "display_objects" & fileDelim & "custom" & fileDelim & "extensions" & fileDelim & "dsp_" & variables.event.getValue('contentBean').getType() & "_" & variables.event.getValue('contentBean').getSubType() & ".cfm")>
					 <cfinclude template="#theIncludePath#/includes/display_objects/custom/extensions/dsp_#variables.event.getValue('contentBean').getType()#_#variables.event.getValue('contentBean').getSubType()#.cfm">
				<cfelse>
					<cfswitch expression="#variables.event.getValue('contentBean').getType()#">
					<cfcase value="File">
						<cfif variables.event.getValue('contentBean').getContentType() eq "Image" 
							and listFind("jpg,jpeg,gif,png",lcase(variables.event.getValue('contentBean').getFileExt()))>
								<cfset loadShadowBoxJS() />
								<cfoutput>
								<div id="svAssetDetail" class="image">
								<a href="#variables.$.content().getImageURL(size='large')#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" rel="shadowbox[body]" id="svAsset"><img src="#variables.$.content().getImageURL(size='medium')#" class="imgMed thumbnail" alt="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" /></a>
								#renderEditableAttribute(attribute="summary",type="htmlEditor")#
								</div>
								</cfoutput>
						<cfelse>
								<cfoutput>
								<div id="svAssetDetail" class="file">
								#renderEditableAttribute(attribute="summary",type="htmlEditor")#
								<a href="#application.configBean.getContext()#/#variables.event.getValue('siteID')#/?linkServID=#variables.event.getValue('contentBean').getContentID()#&amp;showMeta=2&amp;ext=.#variables.event.getValue('contentBean').getFileExt()#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" id="svAsset" class="#lcase(variables.event.getValue('contentBean').getFileExt())#">Download File</a>							
								</div>
								</cfoutput>
						</cfif>				
					</cfcase>
					<cfcase value="Link">
						<cfoutput>
						<div id="svAssetDetail" class="link">
							#renderEditableAttribute(attribute="summary",type="htmlEditor")#	
							<a href="#application.configBean.getContext()#/#variables.event.getValue('siteID')#/?linkServID=#variables.event.getValue('contentBean').getContentID()#&amp;showMeta=2" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" id="svAsset" class="url">View Link</a>							
						</div>
						</cfoutput>
					</cfcase>
					<cfdefaultcase>
						<cfif arguments.showMetaImage
							and len(variables.event.getValue('contentBean').getFileID()) 
							and variables.event.getValue('contentBean').getContentType() eq "Image" 
							and listFind("jpg,jpeg,gif,png",lcase(variables.event.getValue('contentBean').getFileExt()))>
								<cfset loadShadowBoxJS() />
								<cfoutput>
								<cfif arguments.includeMetaHREF>
									<a href="#variables.$.content().getImageURL(size='large')#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" rel="shadowbox[body]" id="svAsset"><img src="#variables.$.content().getImageURL(size='medium')#" class="imgMed thumbnail" alt="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" /></a>
									<cfelse>
									<div id="svAsset">
									<img src="#variables.$.content().getImageURL(size='medium')#" class="imgMed thumbnail" alt="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" />
									</div>
								</cfif>
								</cfoutput>	
						</cfif>		
						<cfoutput>
							<cfif structKeyExists(arguments,'bodyAttribute')>
								#renderEditableAttribute(attribute=arguments.bodyAttribute,type="htmlEditor")#
							<cfelseif $.content('body') eq arguments.body>
								#renderEditableAttribute(attribute="body",type="htmlEditor")#
							<cfelse>
								#setDynamicContent(arguments.body)#
							</cfif>		
						</cfoutput>
					</cfdefaultcase>
					</cfswitch>
					<cfswitch expression="#variables.event.getValue('contentBean').gettype()#">
					<cfcase value="Folder">
						<cfset addToHTMLHeadQueue("listImageStyles.cfm")>
						<cf_CacheOMatic key="FolderBody#cacheStub##getListFormat()#" nocache="#variables.event.getValue('r').restrict#">
						 <cfoutput>#dspObject_Include(thefile='dsp_portal.cfm')#</cfoutput>
						</cf_CacheOMatic>
					</cfcase> 
					<cfcase value="Calendar">
						<cfset addToHTMLHeadQueue("listImageStyles.cfm")>
						 <cf_CacheOMatic key="calendarBody#cacheStub##getListFormat()#" nocache="#variables.event.getValue('r').restrict#">
						 <cfoutput>#dspObject_Include(thefile='calendar/index.cfm')#</cfoutput>
						 </cf_CacheOMatic>
					</cfcase> 
					<cfcase value="Gallery">
						<cfset loadShadowBoxJS() />
						<cfset addToHTMLHeadQueue("gallery/htmlhead/gallery.cfm")>
						<cfif not variables.event.valueExists('galleryItemID')><cfset variables.event.setValue('galleryItemID','')></cfif>
						<cf_CacheOMatic key="galleryBody#cacheStub##variables.event.getValue('galleryItemID')##getListFormat()#" nocache="#variables.event.getValue('r').restrict#">
						<cfoutput>#dspObject_Include(thefile='gallery/index.cfm')#</cfoutput>
						</cf_CacheOMatic>
					</cfcase> 
				</cfswitch>
				</cfif>		
			</cfif> 
		<cfelseif variables.event.getValue('isOnDisplay') and variables.event.getValue('r').restrict and variables.event.getValue('r').loggedIn and not variables.event.getValue('r').allow >
			<cfset eventOutput=application.pluginManager.renderEvent("onContentDenialRender",variables.event)>
			<cfif len(eventOutput)>
			<cfoutput>#eventOutput#</cfoutput>
			<cfelse>
			<cfoutput>#dspObject_Include(thefile='dsp_deny.cfm')#</cfoutput>
			</cfif>
		<cfelseif variables.event.getValue('isOnDisplay') and variables.event.getValue('r').restrict and not variables.event.getValue('r').loggedIn>
			<cfset variables.event.setValue('noCache',1)>
			<cfset eventOutput=application.pluginManager.renderEvent("onSiteLoginPromptRender",variables.event)>
			<cfif len(eventOutput)>
			<cfoutput>#eventOutput#</cfoutput>
			<cfelse>
			<cfoutput>#dspObject_Include(thefile='dsp_login.cfm')#</cfoutput>
			</cfif>
		<cfelse>
			<cfset eventOutput=application.pluginManager.renderEvent("onContentOfflineRender",variables.event)>
			<cfif len(eventOutput)>
			<cfoutput>#eventOutput#</cfoutput>
			<cfelse>
			<cfoutput>#dspObject_Include(thefile='dsp_offline.cfm')#</cfoutput>
			</cfif>
		</cfif>
	</cfsavecontent>
	
	<cfreturn str />
</cffunction>

<cffunction name="queryPermFilter" returntype="query" access="public" output="false">
	<cfargument name="rawQuery" type="query">
	
	<cfreturn application.permUtility.queryPermFilter(arguments.rawQuery,'',variables.event.getValue('siteID'),variables.event.getValue('r').hasModuleAccess)/>
</cffunction>
	
<cffunction name="newResultQuery" returntype="query" access="public" output="false">
	<cfreturn application.permUtility.newResultQuery() />
</cffunction>

<cffunction name="setParagraphs" access="public" output="false" returntype="string">
<cfargument name="theString" type="string">

<cfset var str=arguments.thestring/>
<cfset var finder=""/>
<cfset var item=""/>
<cfset var start=1/>

	<cfset str = replace(str,chr(13)&chr(10),chr(10),"ALL")/>
	//now make Macintosh style into Unix style
	<cfset str = replace(str,chr(13),chr(10),"ALL")/>
	//now fix tabs
	<cfset str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL")/>
	
	<cfset finder=refindnocase('https?:\/\/\S+',str,start,"true")>
	
	<cfloop condition="#finder.len[1]#">
	<cfset item=trim(mid(str, finder.pos[1], finder.len[1])) />
	<cfset str=replace(str,mid(str, finder.pos[1], finder.len[1]),'<a href="#item#" target="_blank">#item#</a>')>
	<cfset start=finder.pos[1] + len('<a href="#item#" target="_blank">#item#</a>') >
	<cfset finder=refindnocase('https?:\/\/\S+',str,start,"true")>
	</cfloop>
	
	<cfset start=1/>
	<cfset finder=refindnocase("[\w.]+@[\w.]+\.\w+",str,start,"true")>
	
	<cfloop condition="#finder.len[1]#">
	<cfset item=trim(mid(str, finder.pos[1], finder.len[1])) />
	<cfset str=replace(str,mid(str, finder.pos[1], finder.len[1]),'<a href="mailto:#item#" target="_blank">#item#</a>')>
	<cfset start=finder.pos[1] + len('<a href="mailto:#item#" target="_blank">#item#</a>') >
	<cfset finder=refindnocase("[\w.]+@[\w.]+\.\w+",str,start,"true")>
	</cfloop>
	
	<cfset str="<p>" & str & "</p>"/>
	<cfset str = replace(str,chr(10),"</p><p>","ALL") />
	
	//now return the text formatted in HTML
	<cfreturn str />
</cffunction>

<cffunction name="createCSSID"  output="false" returntype="string">
		<cfargument name="title" type="string" required="true" default="">
		<cfset var id=setProperCase(arguments.title)>
		<cfreturn "sys" & rereplace(id,"[^a-zA-Z0-9]","","ALL")>	
</cffunction>

<cffunction name="getTemplate"  output="false" returntype="string">
		<cfset var I = 0 />
		
		<cfif variables.event.getValue('contentBean').getIsNew() neq 1>
			<cfif len(variables.event.getValue('contentBean').getTemplate())>
				<cfreturn variables.event.getValue('contentBean').getTemplate() />
			<cfelseif arrayLen(this.crumbdata) gt 1> 
				<cfloop from="2" to="#arrayLen(this.crumbdata)#" index="I">
					<cfif  this.crumbdata[I].template neq ''>
						<cfreturn this.crumbdata[I].template />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<cfreturn "default.cfm" />
</cffunction>

<cffunction name="getMetaDesc"  output="false" returntype="string">
		<cfset var I = 0 />

		<cfloop from="1" to="#arrayLen(this.crumbdata)#" index="I">
		<cfif  this.crumbdata[I].metaDesc neq ''>
		<cfreturn this.crumbdata[I].metaDesc />
		</cfif>
		</cfloop>
		
		<cfreturn "" />
</cffunction>

<cffunction name="getMetaKeyWords"  output="false" returntype="string">
		<cfset var I = 0 />

		<cfloop from="1" to="#arrayLen(this.crumbdata)#" index="I">
		<cfif  this.crumbdata[I].metaKeyWords neq ''>
		<cfreturn this.crumbdata[I].metaKeyWords />
		</cfif>
		</cfloop>
		
		<cfreturn "" />
</cffunction>

<cffunction name="stripHTML" returntype="string" output="false">
	<cfargument name="str" type="string">	
	<cfreturn ReReplace(arguments.str, "<[^>]*>","","all") />
</cffunction>

<cffunction name="addCompletePath" returntype="string" output="false">
	<cfargument name="str" type="string">
	<cfargument name="siteID" type="string">
	<cfset var returnstring=arguments.str/>
	
	<cfset returnstring=replaceNoCase(returnstring,'src="/','src="http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
	<cfset returnstring=replaceNoCase(returnstring,"src='/",'src="http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
	<cfset returnstring=replaceNoCase(returnstring,'href="/','href="http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
	<cfset returnstring=replaceNoCase(returnstring,"href='/",'href="http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
	<cfreturn returnstring />
</cffunction>

<cffunction name="getSite" returntype="any" output="false">
	<cfreturn application.settingsManager.getSite(variables.event.getValue('siteID')) />
</cffunction>

<cffunction name="dspNestedNavPrimary" output="false" returntype="string">
		<cfargument name="contentid" type="string" >
		<cfargument name="viewDepth" type="numeric" required="true" default="1">
		<cfargument name="currDepth" type="numeric"  required="true"  default="1">
		<cfargument name="type" type="string"  default="default">
		<cfargument name="today" type="date"  default="#now()#">
		<cfargument name="id" type="string" default="">
		<cfargument name="querystring" type="string" default="">
		<cfargument name="sortBy" type="string" default="orderno">
		<cfargument name="sortDirection" type="string" default="asc">
		<cfargument name="context" type="string" default="#application.configBean.getContext()#">
		<cfargument name="stub" type="string" default="#application.configBean.getStub()#">
		<cfargument name="displayHome" type="string" default="conditional">
		<cfargument name="closeFolders" type="string" default="">
		<cfargument name="openFolders" type="string" default="">	
		<cfargument name="menuClass" type="string" default="">
		<cfargument name="showCurrentChildrenOnly" type="boolean" default="false">
		<cfargument name="liHasKidsClass" required="true" default="">
		<cfargument name="liHasKidsCustomString" required="true" default="">
		<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
		<cfargument name="liCurrentCustomString" required="true" default="">
		<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
		<cfargument name="aHasKidsClass" required="true" default="">
		<cfargument name="aHasKidsCustomString" required="true" default="">
		<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
		<cfargument name="aCurrentCustomString" required="true" default="">
		<cfargument name="ulNestedClass" required="true" default="">
		<cfargument name="ulNestedCustomString" required="true" default="">
		<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">

		<cfset var rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000',variables.event.getValue('siteID'),arguments.contentid,arguments.type,arguments.today,0,'',0,arguments.sortBy,arguments.sortDirection,'','','',true)>
		<cfset var adjust=0>
		<cfset var current=0>
		<cfset var link=''>
		<cfset var itemClass=''>
		<cfset var itemId=''>
		<cfset var nest=''>
		<cfset var subnav=false>
		<cfset var theNav="">
		<cfset var topIndex= arrayLen(this.crumbdata)-this.navOffSet />
		<cfset var rsHome=0>
		<cfset var homeLink = "" />
		<cfset var isLimitingOn = false>
		<cfset var isNotLimited = false>
		<cfset var limitingBy = "">
		<cfset var isNavSecondary=arguments.showCurrentChildrenOnly or (arguments.id eq 'navSecondary' or arguments.menuClass eq 'navSecondary')>
		<cfset var homeDisplayed = false>
		<cfset var nestedArgs=structNew()>
		<cfset var linkArgs=structNew()>
		<cfset var started=false>

		<cfif isDefined("arguments.closePortals")>
			<cfset arguments.closeLocaRepos=arguments.closePortals>
		</cfif>

		<cfif isDefined("arguments.openPortals")>
			<cfset arguments.openFolders=arguments.openPortals>
		</cfif>

		<cfif isDefined("arguments.ulTopClass")>
			<cfset arguments.menuclass=arguments.ulTopClass>
		</cfif>

		<cfif len(arguments.closeFolders)>
			<cfset limitingBy="closed">	
			<cfif isBoolean(arguments.closeFolders)>	
				<cfset isLimitingOn=arguments.closeFolders />
			</cfif>
		</cfif>
		
		<cfif len(arguments.openFolders)>
			<cfset limitingBy="open">			
			<cfif isBoolean(arguments.openFolders)>	
				<cfif arguments.openFolders>
					<cfset isLimitingOn=false />
				<cfelse>
					<cfset isLimitingOn=true />
				</cfif>
			</cfif>
		</cfif>
			
		<cfif rsSection.recordcount>
			<cfset adjust=rsSection.recordcount>
			<cfsavecontent variable="theNav"><cfoutput>

			<cfif not homeDisplayed and arguments.currDepth eq 1 and (arguments.displayHome eq "Always" or (arguments.displayHome eq "Conditional" and variables.event.getValue('contentBean').getcontentid() neq "00000000000000000000000000000000001"))>
				<cfsilent>
					<cfquery name="rsHome" datasource="#application.configBean.getReadOnlyDatasource()#" username="#application.configBean.getReadOnlyDbUsername()#" password="#application.configBean.getReadOnlyDbPassword()#">
					select menutitle,filename from tcontent where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.event.getValue('siteID')#"> and active=1
					</cfquery>
					<cfset homeLink="#application.configBean.getContext()##getURLStem(variables.event.getValue('siteID'),rsHome.filename)#">
					<cfset homeDisplayed = true>
				</cfsilent>

				<cfset started=true>
				<ul<cfif arguments.currDepth eq 1>#iif(arguments.id neq '',de(' id="#arguments.id#"'),de(''))##iif(arguments.menuClass neq '',de(' class="#arguments.menuClass#"'),de(''))#<cfelse><cfif len(arguments.ulNestedClass)> class="#arguments.ulNestedClass#"</cfif><cfif len(arguments.ulNestedCustomString)> #arguments.ulNestedCustomString#</cfif></cfif>>
				<li class="first<cfif variables.event.getValue('contentBean').getcontentid() eq arguments.contentid> #arguments.liCurrentClass#</cfif>" id="navHome"<cfif len(arguments.liCurrentCustomString)> #arguments.liCurrentCustomString#</cfif>><a href="#homeLink#"<cfif len(arguments.aCurrentClass) and $.content('contentID') eq '00000000000000000000000000000000001'> class="#arguments.aCurrentClass#"<cfelseif len(arguments.aNotCurrentClass)> class="#arguments.aNotCurrentClass#"</cfif><cfif len(arguments.aCurrentCustomString)> #arguments.aCurrentCustomString#</cfif>>#HTMLEditFormat(rsHome.menuTitle)#</a></li>
			</cfif>
			
			<cfloop query="rsSection">
			<cfif allowLink(rssection.restricted,rssection.restrictgroups,variables.event.getValue('r').loggedIn)>
			<cfsilent>
			
			<cfset current=current+1>
			<cfset nest=''>
			
			<cfset isNotLimited= rsSection.type eq "Page" or 
			not (
				rsSection.type eq "Folder" and 
					(isLimitingOn or (
										(limitingBy eq "closed" and listFind(arguments.closeFolders,rsSection.contentid))
									or  
										(limitingBy eq "open" and not listFind(arguments.openFolders,rsSection.contentid))
									)
										
					) 
					or listFindNoCase("Calendar,Gallery,Link,File",rsSection.type)
				)
			/>	
				
			<cfset subnav= isNumeric(rsSection.kids) and rsSection.kids and arguments.currDepth lt arguments.viewDepth 
			and (
					(
					isNotLimited and isNavSecondary and (
														listFind(variables.event.getValue('contentBean').getPath(),"#rsSection.contentID#") 
														and
														listLen(rsSection.path) lte listLen(variables.event.getValue('contentBean').getPath()) 	
														)
					) 
				or (
					isNotLimited and not isNavSecondary
					)
				) 
				and not (rsSection.restricted and not session.mura.isLoggedIn) 
			/>
			
			<cfif subnav>
				<cfset nestedArgs.contentID=rssection.contentid>
				<cfset nestedArgs.currDepth=arguments.currDepth+1>
				<cfset nestedArgs.type=iif(rssection.type eq 'calendar',de('fixed'),de('default'))>
				<cfset nestedArgs.sortBy=rssection.sortBy>
				<cfset nestedArgs.sortDirection=rssection.sortDirection>
				<cfset nestedArgs.menuClass="">
				<cfset nestedArgs.ulTopClass="">
				<cfset structAppend(nestedArgs,arguments,false)>
				<cfset nest=dspNestedNavPrimary(argumentCollection=nestedArgs) />
				<cfset subnav=subnav and find("<li",nest)>
			</cfif>

			<cfif subnav and arguments.currDepth gt 1 and len(arguments.liHasKidsNestedClass)>
				<cfset itemClass=arguments.liHasKidsNestedClass>
			<cfelse>
				<cfset itemClass="">
			</cfif>
			
			<cfif current eq adjust>
				<cfset itemClass=listAppend(itemClass, "last",' ')>
			</cfif>

			<cfif listFind(variables.event.getValue('contentBean').getPath(),"#rsSection.contentid#") and len(arguments.liCurrentClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liCurrentClass," ")/>
			</cfif>

			<cfif subnav and len(arguments.liHasKidsClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liHasKidsClass," ")/>
			</cfif>
			
			<cfset itemId="nav" & setCamelback(rsSection.menutitle)>
			
			<cfset linkArgs=structNew()>
			<cfset linkArgs.aHasKidsClass=arguments.aHasKidsClass>
			<cfset linkArgs.aCurrentClass=arguments.aCurrentClass>
			<cfset linkArgs.aCurrentCustomString=arguments.aCurrentCustomString>
			<cfset linkArgs.type=rsSection.type>
			<cfset linkArgs.filename=rsSection.filename>
			<cfset linkArgs.title=rsSection.menutitle>
			<cfset linkArgs.contentid=rsSection.contentid>
			<cfset linkArgs.target=rsSection.target>
			<cfset linkArgs.targetParams=rsSection.targetParams>
			<cfset linkArgs.siteID=variables.event.getValue('siteID')>
			<cfset linkArgs.querystring=arguments.querystring>
			<cfset linkArgs.isParent=subnav>
			<cfset link=addlink(argumentCollection=linkArgs)>
			
			</cfsilent>
			
			<cfif not started>
				<cfset started=true>
				<cfset itemClass=listAppend(itemClass, "first",' ')>
				<ul<cfif arguments.currDepth eq 1>#iif(arguments.id neq '',de(' id="#arguments.id#"'),de(''))##iif(arguments.menuClass neq '',de(' class="#arguments.menuClass#"'),de(''))#<cfelse><cfif len(arguments.ulNestedClass)> class="#arguments.ulNestedClass#"</cfif><cfif len(arguments.ulNestedCustomString)> #arguments.ulNestedCustomString#</cfif></cfif>>
			</cfif>
			<li<cfif len(itemClass)> class="#itemClass#"</cfif> id="#itemId#"<cfif len(arguments.liCurrentCustomString)> #arguments.liCurrentCustomString#</cfif>>#link#<cfif subnav>#nest#</cfif></li>
			<cfelse><cfset adjust=adjust-1></cfif></cfloop>
			<cfif started></ul></cfif>
			</cfoutput></cfsavecontent>
		</cfif>
		<cfreturn theNav />
</cffunction>

<cffunction name="dspPrimaryNav" returntype="string" access="public">
	<cfargument name="viewDepth" type="numeric" default="1" required="true">
	<cfargument name="id" type="string" required="true" default="navPrimary">
	<cfargument name="displayHome" type="string" required="true" default="conditional">
	<cfargument name="closeFolders" type="string" default="">
	<cfargument name="openFolders" type="string" default="">
	<cfargument name="class" type="string" default="">
	<cfargument name="showCurrentChildrenOnly" type="boolean" default="false">
	<cfargument name="aHasKidsClass" type="string" default="">
	<cfargument name="aHasKidsCustomString" type="string" default="">

	<cfset var thenav="" />
	<cfset var topIndex= arrayLen(this.crumbdata)-this.navOffSet />
	<cfset var tracePoint=0>

	<!--- hack or issue with bootstrap that breaks link with kids --->
	<cfif arguments.aHasKidsClass eq 'dropdown-toggle' and arguments.aHasKidsCustomString eq 'role="button" data-toggle="dropdown" data-target="##"'>
		<cfset arguments.aHasKidsCustomString=''>
	</cfif>

	<cfif isDefined("arguments.closePortals")>
		<cfset arguments.closeFolders=arguments.closePortals>
	</cfif>

	<cfif isDefined("arguments.openPortals")>
		<cfset arguments.openFolders=arguments.openPortals>
	</cfif>

	<cfset arguments.contentid=this.crumbdata[topIndex].contentID>
	<cfset arguments.viewDepth=arguments.viewDepth+1>
	<cfset arguments.currDepth=1>
	<cfset arguments.sortBy="orderno">
	<cfset arguments.sortDirection="asc">
	<cfset arguments.menuClass=arguments.class>
	<cfset tracepoint=initTracepoint("contentRenderer.dspPrimaryNav")>
	<cfset theNav = dspNestedNavPrimary(argumentCollection=arguments) />
	<cfset commitTracePoint(tracePoint)>
	<cfreturn thenav />
</cffunction>

<cffunction name="setCamelback" access="public" output="false" returntype="string">
	<cfargument name="theString" type="string">

	<cfset var str=arguments.thestring/>
	
	<cfset str=setProperCase(str)>
	<cfset str=REReplace(str, "[^0-9a-zA-Z]", "", "ALL")>

	<cfreturn str />
</cffunction>

<cffunction name="setProperCase" access="public" output="false" returntype="string">
<cfargument name="theString" type="string">

<cfset var str=arguments.thestring/>
<cfset var newString=""/>
<cfset var frontpointer=0/>
<cfset var strlen = len(str) />
<cfset var counter=0 />

	<cfif strLen gt 0>
		<cfscript>
		 for (counter=1;counter LTE strlen;counter=counter + 1)
		 {
		 		frontpointer = counter + 1;
				
				if (Mid(str, counter, 1) is " ")
				{
				  	newstring = newstring & ' ' & ucase(Mid(str, frontpointer, 1)); 
				    counter = counter + 1;
				}
			    else 
				{
					if (counter is 1)
					   newstring = newstring & ucase(Mid(str, counter, 1));
					else
					   newstring = newstring & lcase(Mid(str, counter, 1));
				}
		      
		 }//for statement
		</cfscript>
	</cfif>	

	<cfreturn newstring />
</cffunction>

<cffunction name="renderFile" output="true" access="public">
<cfargument name="fileID" type="string">
<cfargument name="method" type="string" required="true" default="inline">
<cfargument name="size" type="string" required="true" default="">
	<cfset getBean('fileManager').renderFile(arguments.fileid,arguments.method,arguments.size) />
</cffunction>

<cffunction name="renderSmall" output="true" access="public">
<cfargument name="fileID" type="string">
	<cfset getBean('fileManager').renderSmall(arguments.fileid) />
</cffunction>

<cffunction name="renderMedium" output="true" access="public">
<cfargument name="fileID" type="string">
	<cfset getBean('fileManager').renderMedium(arguments.fileid) />
</cffunction>

<cffunction name="jsonencode" access="public" output="false" returntype="string">
<cfargument name="arg" default="" required="yes" type="any"/>

<cfreturn createObject("component","mura.json").init().jsonencode(arguments.arg)>

</cffunction>

<cffunction name="getCurrentURL" access="public" returntype="string" output="false">
<cfargument name="complete" required="true" type="boolean" default="true" />
<cfargument name="injectVars" required="true" type="string" default="" />
<cfargument name="filterVars" required="true" type="boolean" default="true" />
	<cfset var qrystr=''>
	<cfset var host=''>
	<cfset var item = "" />
	
	<cfloop collection="#url#" item="item">
		<cfif not arguments.filterVars and item neq 'path' or (not listFindNoCase('NOCACHE,PATH,DELETECOMMENTID,APPROVEDCOMMENTID,LOADLIST,INIT,SITEID,DISPLAY,#ucase(application.appReloadKey)#',item) 
			 and not (item eq 'doaction' and url[item] eq 'logout')) >	
			<cftry>
			<cfif len(qrystr)>	
					<cfset qrystr="#qrystr#&#item#=#url[item]#">	
			<cfelse>	
				<cfset qrystr="?#item#=#url[item]#">
			</cfif>
			<cfcatch ></cfcatch>
			</cftry>
		</cfif>
		
	</cfloop>
	
	<cfif len(arguments.injectVars)>
			<cfif len(qrystr)>
				<cfset qrystr=qrystr & "&#arguments.injectVars#">
			<cfelse>
				<cfset qrystr="?#arguments.injectVars#">
			</cfif>
	</cfif>
	
	<cfif arguments.complete>
		<cfif application.utility.isHTTPS()>
			<cfset host='https://#listFirst(cgi.http_host,":")##application.configBean.getServerPort()#'>
		<cfelse>
			<cfset host='http://#listFirst(cgi.http_host,":")##application.configBean.getServerPort()#'>
		</cfif>
	</cfif>
	
	<cfif variables.event.valueExists("contentBean") and not listFind("Link,File",variables.event.getValue('contentBean').getType())>		
		<cfreturn host & application.configBean.getContext() & getURLStem(variables.event.getValue('siteID'),variables.event.getValue('currentFilename')) & qrystr >
	<cfelse>
		<!--- If the current node is a link of file you need to make sure that the linkServID is in the URL --->
		<cfif not len(qrystr)>
			<cfreturn host &  application.configBean.getContext() & getURLStem(variables.event.getValue('siteID'),variables.event.getValue('currentFilename')) & "?linkServID=" & variables.event.getValue("contentBean").getContentID() >
		<cfelseif not findNocase("linkServID",qrystr)>
			<cfreturn host &  application.configBean.getContext() & getURLStem(variables.event.getValue('siteID'),variables.event.getValue('currentFilename')) & qrystr & "&linkServID=" & variables.event.getValue("contentBean").getContentID() >
		<cfelse>
			<cfreturn host &  application.configBean.getContext() & getURLStem(variables.event.getValue('siteID'),variables.event.getValue('currentFilename')) & qrystr >
		</cfif>
	</cfif>
	
	
</cffunction>

<cffunction name="renderFileSize" output="false" access="public" return="String">
	<cfargument name="size" type="any">

	<cftry>
		<cfreturn round(arguments.size/1024) & "k" />
		<cfcatch>
			<cfreturn "0k">
		</cfcatch>
	</cftry>

</cffunction>

<cffunction name="dspUserTools" access="public" output="false" returntype="string">

	<cfset var theObject = "" />
	<cfset var theIncludePath = variables.event.getSite().getIncludePath() />

	<cfsavecontent variable="theObject">
		<cfinclude template="#theIncludePath#/includes/display_objects/dsp_user_tools.cfm">
	</cfsavecontent>

	<cfreturn theObject />
	
</cffunction>

<cffunction name="dspSection" access="public" output="false" returntype="string">
	<cfargument name="level" default="1" required="true">		
	<cftry>
		<cfreturn this.crumbdata[arrayLen(this.crumbdata)-arguments.level].menutitle >
		<cfcatch>
			<cfreturn "">
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="setDynamicContent" returntype="string" output="false">
	<cfargument name="str">

	<cfset var body=arguments.str>
	<cfset var errorStr="">
	<cfset var regex1="(\{{|\[sava\]|\[mura\]).+?(\[/sava\]|\[/mura\]|}})">
	<cfset var regex2="">
	<cfset var finder=reFindNoCase(regex1,body,1,"true")>
	<cfset var tempValue="">
	
	<cfparam name="this.enableMuraTag" default="true" />
	
	<!--- It the Mura tag is not enabled just return the submitted string --->
	<cfif not this.enableMuraTag>
		<cfreturn str />
	</cfif>
	
	<!---  still looks for the Sava tag for backward compatibility --->
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset tempValue=mid(body, finder.pos[1], finder.len[1])>
			
			<cfif left(tempValue,2) eq "{{">
				<cfset tempValue=evaluate("##" & mid(tempValue, 3, len(tempValue)-4) & "##")>
			<cfelse>
				<cfset tempValue=evaluate("##" & mid(tempValue, 7, len(tempValue)-13) & "##")>
			</cfif>
			
			<cfif not isDefined("tempValue") or not isSimpleValue(tempValue)>
				<cfset tempValue="">
			</cfif>
			
			<cfset body=replaceNoCase(body,mid(body, finder.pos[1], finder.len[1]),'#trim(tempValue)#')>
			<cfcatch>
				<cfif application.configBean.getDebuggingEnabled()>
					<cfset request.muraDynamicContentError=true>
					<cfsavecontent variable="errorStr"><cfdump var="#cfcatch#"></cfsavecontent>
					<cfset body=replaceNoCase(body,mid(body, finder.pos[1], finder.len[1]),errorStr)>
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>
		<cfset finder=reFindNoCase(regex1,body,1,"true")>
		<cfset request.cacheItem=false>
	</cfloop>
	
	<cfreturn body />
</cffunction>

<cffunction name="dspCaptcha" returntype="string" output="false">
	<cfset var theObject = "" />
	<cfset var theIncludePath = variables.event.getSite().getIncludePath() />
	
	<cfsavecontent variable="theObject">
		<cfinclude template="#theIncludePath#/includes/display_objects/dsp_captcha.cfm">
	</cfsavecontent>
	
	<cfreturn trim(theObject)>
</cffunction>

<cffunction name="dspInclude" returntype="string" access="public">
	<cfargument name="template" default="" required="true">
	<cfargument name="baseDir" default="#variables.event.getSite().getIncludePath()#/includes" required="true">
	<cfset var str='' />
	<cfset var tracePoint=0>
	<cfif arguments.template neq ''>
		<cfset tracePoint=initTracePoint("#arguments.baseDir#/#arguments.template#")>
		<cfsavecontent variable="str">
			<cfinclude template="#arguments.baseDir#/#arguments.template#">
		</cfsavecontent>
		<cfset commitTracePoint(tracePoint)>
	</cfif>
	
	<cfreturn trim(str) />
</cffunction>

<cffunction name="dspThemeInclude" returntype="string" access="public">
	<cfargument name="template" default="" required="true">
	<cfset var str='' />
	<cfset var tracePoint=0>
	<cfif arguments.template neq ''>
		<cfset tracePoint=initTracePoint("#variables.$.siteConfig('themeIncludePath')#/#arguments.template#")>
		<cfsavecontent variable="str">
			<cfinclude template="#variables.$.siteConfig('themeIncludePath')#/#arguments.template#">
		</cfsavecontent>
		<cfset commitTracePoint(tracePoint)>
	</cfif>
	
	<cfreturn trim(str) />
</cffunction>
 
<cffunction name="sendToFriendLink" output="false" returnType="String">
<cfreturn "javascript:sendtofriend=window.open('#variables.event.getSite().getAssetPath()#/utilities/sendtofriend.cfm?link=#urlEncodedFormat(getCurrentURL())#&siteID=#variables.event.getValue('siteID')#', 'sendtofriend', 'scrollbars=yes,resizable=yes,screenX=0,screenY=0,width=570,height=390');sendtofriend.focus();void(0);"/>
</cffunction>

<cffunction name="addToHTMLHeadQueue" output="false">
	<cfargument name="text">
	<cfargument name="action" default="append">
	<cfif not listFind(variables.event.getValue('HTMLHeadQueue'),arguments.text)>
		<cfif arguments.action eq "append">
			<cfset variables.event.setValue('HTMLHeadQueue',listappend(variables.event.getValue('HTMLHeadQueue'),arguments.text)) />
		<cfelse>
			<cfset variables.event.setValue('HTMLHeadQueue',listprepend(variables.event.getValue('HTMLHeadQueue'),arguments.text)) />
		</cfif>
	</cfif>
</cffunction>

<cffunction name="addToHTMLFootQueue" output="false">
	<cfargument name="text">
	<cfargument name="action" default="append">	
	<cfif not listFind(variables.event.getValue('HTMLFootQueue'),arguments.text)>
		<cfif arguments.action eq "append">
			<cfset variables.event.setValue('HTMLFootQueue',listappend(variables.event.getValue('HTMLFootQueue'),arguments.text)) />
		<cfelse>
			<cfset variables.event.setValue('HTMLFootQueue',listprepend(variables.event.getValue('HTMLFootQueue'),arguments.text)) />
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getShowModal" output="false">
<cfreturn getShowToolbar() or (this.showEditableObjects and this.hasEditableObjects and not request.muraExportHTML) />
</cffunction>

<cffunction name="getShowToolbar" output="false">
<cfreturn ((listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite(variables.event.getValue('siteID')).getPrivateUserPoolID()#') or listFind(session.mura.memberships,'S2')) or (listFindNoCase("editor,author",variables.event.getValue('r').perm) and this.showMemberToolBar)) and getShowAdminToolBar() and not request.muraExportHTML />
</cffunction>

<cffunction name="hasFETools" output="false">
<cfreturn getShowToolbar() />
</cffunction>

<cffunction name="getShowInlineEditor" output="false">
<cfreturn  getShowToolbar() and this.showInlineEditor/>
</cffunction>

<cffunction name="renderHTMLQueue" output="false">
	<cfargument name="queueType">
	<cfset var headerStr="" />
	<cfset var itemStr="" />
	<cfset var HTMLQueue="" />
	<cfset var i = "" />
	<cfset var iLen = 0 />
	<cfset var headerFound=false />	
	<cfset var pluginBasePath="" />
	<cfset var pluginPath="" />
	<cfset var pluginID=0 />
	<cfset var pluginConfig="" />
	<cfset var displayPoolID=application.settingsManager.getSite(variables.event.getValue('siteID')).getDisplayPoolID()>
	<cfset var theme=application.settingsManager.getSite(variables.event.getValue('siteID')).getTheme()>
	<cfset var tracePoint=0>
	
	<cfif getRenderHTMLQueues()>
		
		<cfif arguments.queueType eq "HEAD">
			
			<!--- Add global.js --->
			<cfset addToHTMLHEADQueue('global.cfm',"prepend")>

			<!--- ensure that the js lb is always there --->
			<cfset loadJSLib() />
					
			<!--- Add modal edit --->
			<cfif getShowModal()>
				<cfif getJSLib() eq "prototype">
					<cfset loadShadowboxJS() />
				</cfif>
				<cfif this.showEditableObjects>
					<cfsavecontent variable="headerStr">
					<cfoutput>
					<link href="#variables.$.globalConfig('context')#/admin/assets/css/editableObjects.min.css" rel="stylesheet" type="text/css" />
					</cfoutput>
					</cfsavecontent>
				</cfif>
			</cfif>
		<cfelseif arguments.queueType eq "FOOT">
				<cfif (getShowModal() or variables.event.getValue("muraChangesetPreview")) and not request.muraExportHTML>
					<cfsavecontent variable="headerStr">
						<cfif getShowModal()>
							<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()#/admin/core/utilities/modal/dsp_modal_edit.cfm")>
							<cfinclude template="/#application.configBean.getWebRootMap()#/admin/core/utilities/modal/dsp_modal_edit.cfm">
							<cfset commitTracePoint(tracePoint)>
						</cfif>	
						<cfif variables.event.getValue("muraChangesetPreview")>
							<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()#/admin/core/utilities/modal/dsp_modal_changeset.cfm")>
							<cfinclude template="/#application.configBean.getWebRootMap()#/admin/core/utilities/modal/dsp_modal_changeset.cfm">
							<cfset commitTracePoint(tracePoint)>
						</cfif>
					</cfsavecontent>
				</cfif>
		</cfif>
		<!--- Loop through the HTML Head Que--->
		<cfset HTMLQueue=variables.event.getValue('HTML#arguments.queueType#Queue') />
		
		<cfloop list="#HTMLQueue#" index="i">
		<cfset headerFound=false/>
		<cfsavecontent variable="itemStr">
			<!--- look in default htmlHead directory --->
			<cfif not refind('[\\/]',i)>
				
				<cfset pluginBasePath="/#displayPoolID#/includes/themes/#theme#/display_objects/htmlhead/">
				<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##i#"))>
					<cfset pluginPath= application.configBean.getContext() & pluginBasePath >
					<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()##pluginbasePath##i#")>
					<cfinclude template="/#application.configBean.getWebRootMap()##pluginbasePath##i#">
					<cfset commitTracePoint(tracePoint)>
					<cfset headerFound=true />
				</cfif>
				
				<cfif not headerFound>
					<cfset pluginBasePath="/#displayPoolID#/includes/display_objects/htmlhead/">
					<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##i#"))>
						<cfset pluginPath= application.configBean.getContext() & pluginBasePath >
						<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()##pluginbasePath##i#")>
						<cfinclude template="/#application.configBean.getWebRootMap()##pluginbasePath##i#">
						<cfset commitTracePoint(tracePoint)>
						<cfset headerFound=true />
					</cfif>
				</cfif>
			
			<cfelse>
			
				<!--- If not found, look in look in your theme --->
				<cfset pluginBasePath="/#displayPoolID#/includes/themes/#theme#/display_objects/">
				<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##i#"))>
					<cfset pluginPath= application.configBean.getContext() & pluginBasePath >	
					<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()##pluginbasePath##i#")>
					<cfinclude template="/#application.configBean.getWebRootMap()##pluginBasePath##i#">
					<cfset commitTracePoint(tracePoint)>
					<cfset headerFound=true />
				</cfif>

				<!--- if not found, try the path that was passed --->
				<cfif not headerFound and fileExists(expandPath(i))>
					<cfinclude template="#i#" />
					<cfset headerFound = true />
				</cfif>
						
				<!--- If not found, look in display_objects directory --->
				<cfif not headerFound>
					<cfset pluginBasePath="/#displayPoolID#/includes/display_objects/">
					<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##i#"))>
						<cfset pluginPath= application.configBean.getContext() & pluginBasePath >	
						<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()##pluginbasePath##i#")>
						<cfinclude template="/#application.configBean.getWebRootMap()##pluginBasePath##i#">
						<cfset commitTracePoint(tracePoint)>
						<cfset headerFound=true />
					</cfif>
				</cfif>
				
				<!--- If not found, look in top of theme directory
				<cfif not headerFound>
					<cfset pluginBasePath="/#displayPoolID#/includes/themes/#theme#/">
					<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath#") & i)>
						<cfset pluginPath= application.configBean.getContext() & pluginBasePath >	
						<cfinclude  template="/#application.configBean.getWebRootMap()##pluginBasePath##i#">
						<cfset headerFound=true />
					</cfif>
				</cfif>
				 --->
				 
				<!--- If not found, look in includes directory --->
				<cfif not headerFound>
					<cfset pluginBasePath="/#displayPoolID#/includes/">
					<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##i#"))>
						<cfset pluginPath= application.configBean.getContext() & pluginBasePath >	
						<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()##pluginbasePath##i#")>
						<cfinclude  template="/#application.configBean.getWebRootMap()##pluginBasePath##i#">
						<cfset commitTracePoint(tracePoint)>
						<cfset headerFound=true />
					</cfif>
				</cfif>
				
				<!--- If not found, look in local plugins directory --->
				<cfif not headerFound>
					<cfset pluginBasePath="/#displayPoolID#/includes/plugins/">		
					<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()##pluginbasePath##i#"))>
						<cfset pluginID=listLast(listFirst(i,"/"),"_")>
						<cfset variables.event.setValue('pluginConfig',application.pluginManager.getConfig(pluginID))>
						<cfset pluginConfig=variables.event.getValue('pluginConfig')>
						<cfset pluginPath= application.configBean.getContext() & pluginBasePath & pluginConfig.getDirectory() & "/" >		
						<cfset variables.event.setValue('pluginPath',pluginPath)>		
						<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()##pluginbasePath##i#")>
						<cfinclude  template="/#application.configBean.getWebRootMap()##pluginBasePath##i#">
						<cfset commitTracePoint(tracePoint)>
						<cfset headerFound=true />
						<cfset variables.event.removeValue("pluginPath")>
						<cfset variables.event.removeValue("pluginConfig")>
					</cfif>
				</cfif>
				
				<!--- If not found, look in global plugins directory --->
				<cfif not headerFound>
					<cfset pluginBasePath="/plugins/">
					<cfif fileExists(expandPath("#pluginbasePath##i#"))>
						<cfset pluginID=listLast(listFirst(i,"/"),"_")>
						<cfset variables.event.setValue('pluginConfig',application.pluginManager.getConfig(pluginID))>
						<cfset pluginConfig=variables.event.getValue('pluginConfig')>
						<cfset pluginPath= application.configBean.getContext() & pluginBasePath & pluginConfig.getDirectory() & "/" >		
						<cfset variables.event.setValue('pluginPath',pluginPath)>
						<cfset tracePoint=initTracePoint("#pluginbasePath##i#")>
						<cfinclude  template="#pluginBasePath##i#">
						<cfset commitTracePoint(tracePoint)>
						<cfset headerFound=true />
						<cfset variables.event.removeValue("pluginPath")>
						<cfset variables.event.removeValue("pluginConfig")>
					</cfif>
				</cfif>
			</cfif>
			<cfif not headerFound>
			<cfoutput><!-- missing header include- #i# --></cfoutput>
			</cfif>
		</cfsavecontent>
		<cfset headerStr=headerStr & " " & trim(itemStr)>
		</cfloop>
	</cfif>	
	<cfreturn headerStr>
</cffunction>

<cffunction name="renderHTMLHeadQueue" output="false" hint="deprecated">
	<cfreturn renderHTMLQueue("Head")>
</cffunction>

<cffunction name="redirect" output="false" returntype="void">
	<cfargument name="location">
	<cfargument name="addToken" required="true" default="false">
	<cfargument name="statusCode" required="true" default="301">
	<cflocation url="#arguments.location#" addtoken="#arguments.addToken#" statusCode="#arguments.statusCode#">
</cffunction>

<cffunction name="getPagesQuery" returntype="query" output="false">
	<cfargument name="str">

	<cfset var pageList=replaceNocase(arguments.str,"[mura:pagebreak]","murapagebreak","ALL")>
	<cfset var rs=queryNew("page")>
	<cfset var i=1>
	<cfset var pageArray=ArrayNew(1)>
	<cfset pageList=replaceNocase(pageList,"${pagebreak}","murapagebreak","ALL")>
	<cftry>
		<cfset pageArray=pageList.split("murapagebreak",-1)>
		<cfcatch>
		<cfset pageArray[1]=arguments.str>
		</cfcatch>
	</cftry>
	
	<cfloop from="1" to="#arrayLen(pageArray)#"index="i">	
    	<cfset queryAddRow(rs,1)/>
		<cfset querysetcell(rs,"page",pageArray[i],rs.recordcount)/>
	</cfloop>
	<cfreturn rs>
</cffunction>

<cffunction name="dspMultiPageContent" returntype="any" output="false">
<cfargument name="body">
<cfset var str="">
<cfset var rsPages=getPagesQuery(arguments.body)>
<cfset var currentNextNIndex=1>

<cfset variables.event.setValue("currentNextNID",variables.event.getContentBean().getContentID())>

<cfif not len(variables.event.getValue("nextNID")) or variables.event.getValue("nextNID") eq variables.event.getValue("currentNextNID")>
	<cfset currentNextNIndex=variables.event.getValue("pageNum")>
</cfif>

<cfset variables.nextN=application.utility.getNextN(rsPages,1,currentNextNIndex,5,false)>

<cfsavecontent variable="str">
<cfoutput query="rsPages"  startrow="#request.pageNum#" maxrows="#variables.nextn.RecordsPerPage#">
	#setDynamicContent(rsPages.page)#
</cfoutput>
<cfif variables.nextn.numberofpages gt 1>
	<cfoutput>#dspObject_Include(thefile='dsp_nextN.cfm')#</cfoutput>
</cfif>
</cfsavecontent>

<cfreturn str>
</cffunction>

<cffunction name="generateEditableHook" output="false">
	<cfif getJSLib() eq "prototype">
		<cfreturn 'rel="shadowbox;width=1050;"'>
	<cfelse>
		<cfreturn 'class="frontEndToolsModal"'>
	</cfif>
</cffunction>

<cffunction name="generateEditableObjectControl" access="public" output="no" returntype="string">
		<cfargument name="editLink" required="yes" default="">
		<cfargument name="isConfigurator" default="false">
		<cfset var str = "">
		
		<cfif this.showEditableObjects>		
		<cfsavecontent variable="str">
			<cfoutput>
			<ul class="editableObjectControl">
				<li class="edit"><a href="#arguments.editLink#" data-configurator="#arguments.isConfigurator#" title="#htmlEditFormat('Edit')#" #generateEditableHook()#></a></li>
			</ul>
			</cfoutput>
		</cfsavecontent>
		</cfif>
		
		<cfreturn str>
</cffunction>

<cffunction name="renderEditableObjectHeader" access="public" output="no" returntype="string">
		<cfargument name="class" required="yes" default="">
		<cfargument name="customWrapperString" required="yes" default="">
		<cfset var str = "">
		
		<cfif this.showEditableObjects>		
		<cfsavecontent variable="str">
			<cfoutput>
			<span class="editableObject #arguments.class#" #customWrapperString#><span class="editableObjectContents">
			</cfoutput>
		</cfsavecontent>
		</cfif>
		
		<cfreturn str>
</cffunction>

<cffunction name="renderEditableObjectfooter" access="public" output="no" returntype="string">
		<cfargument name="control" required="yes" default="">
		<cfset var str = "">
		
		<cfif this.showEditableObjects>		
		<cfsavecontent variable="str">
			<cfoutput>
			<cfoutput></span>#arguments.control#</cfoutput></span>
			</cfoutput>
		</cfsavecontent>
		</cfif>
		
		<cfreturn str>
</cffunction>

<cffunction name="generateListImageSyles" output="false">
	<cfargument name="size" default="small">
	<cfargument name="height" default="auto">
	<cfargument name="width" default="auto">
	<cfargument name="padding" default="20">
	<cfargument name="setHeight" default="true">
	<cfargument name="setWidth" default="true">
	
	<cfset var imageStyles=structNew()>
	<cfset var customImageSize="">
	<cfset imageStyles.markup="">

	<cfif arguments.size eq "" or 
		(arguments.size eq "Custom"
		and arguments.width eq "auto"
		and arguments.height eq "auto")>
		<cfset arguments.size="small">
	</cfif>
	<cfif arguments.size eq "large">
		<cfset arguments.size = "main" />
	</cfif>
		
	<cfif listFindNoCase('small,medium,large',arguments.size)>
		<cfif isNumeric(variables.$.siteConfig('#arguments.size#ImageWidth'))>
			<cfset imageStyles.paddingLeft=variables.$.siteConfig('#arguments.size#ImageWidth') + arguments.padding>
		<cfelse>
			<cfset imageStyles.paddingLeft="auto">
		</cfif>
		<cfif isNumeric(variables.$.siteConfig('#arguments.size#ImageHeight'))>
			<cfset imageStyles.minHeight=variables.$.siteConfig('#arguments.size#ImageHeight') + arguments.padding>
		<cfelse>
			<cfset imageStyles.minHeight="auto">
		</cfif>
	<cfelseif arguments.size eq 'custom'>
		<cfif isNumeric(arguments.width)>
			<cfset imageStyles.paddingLeft=arguments.width + arguments.padding>
		<cfelse>
			<cfset imageStyles.paddingLeft="auto">
		</cfif>
		<cfif isNumeric(arguments.height)>
			<cfset imageStyles.minHeight=arguments.height + arguments.padding>
		<cfelse>
			<cfset imageStyles.minHeight="auto">
		</cfif>
	<cfelse>
		<cfset customImageSize=getBean('imageSize').loadBy(name=arguments.size,siteID=variables.$.event('siteID'))>
		<cfset arguments.Width=customImageSize.getWidth() />
		<cfset arguments.Height=customImageSize.getHeight() />
		
		<cfif isNumeric(arguments.width)>
			<cfset imageStyles.paddingLeft=arguments.width + arguments.padding>
		<cfelse>
			<cfset imageStyles.paddingLeft="auto">
		</cfif>
		<cfif isNumeric(arguments.height)>
			<cfset imageStyles.minHeight=arguments.height + arguments.padding>
		<cfelse>
			<cfset imageStyles.minHeight="auto">
		</cfif>
	</cfif>
		
	<cfif imageStyles.minHeight neq "auto" and arguments.setHeight>
		<cfset imageStyles.markup="#imageStyles.markup#min-height:#imageStyles.minHeight#px;">
	</cfif>
	<cfif imageStyles.paddingLeft neq "auto" and arguments.setWidth>
		<cfset imageStyles.markup="#imageStyles.markup#padding-left:#imageStyles.paddingLeft#px;">
	</cfif>
		
	<cfreturn imageStyles.markup>

</cffunction>

<cffunction name="getURLForFile" access="public" output="false" returntype="string">
	<cfargument name="fileid" required="false" default="" />
	<cfargument name="method" required="false" default="inline" />
	<cfscript>
		var rsFileData = getBean('fileManager').read(arguments.fileid);
		if ( not rsFileData.recordcount ) {
			return '';
		} else {
			return '#application.configBean.getContext()#/tasks/render/file/?method=#arguments.method#&amp;fileID=#arguments.fileid#';
		}
	</cfscript>
</cffunction>

<cffunction name="getURLForImage" access="public" output="false" returntype="string">
	<cfargument name="fileid" required="false" default="" />
	<cfargument name="size" required="false" default="large" />
	<cfargument name="direct" required="false" default="#this.directImages#" />
	<cfargument name="complete" type="boolean" required="false" default="false" />
	<cfargument name="height" required="false" default="AUTO" />
	<cfargument name="width" required="false" default="AUTO" />
	<cfargument name="siteID" required="false" default="#variables.$.event('siteID')#" />
	<cfscript>
		var imageURL = getBean('fileManager').createHREFForImage(argumentCollection=arguments);
		if ( IsSimpleValue(imageURL) ) {
			return imageURL;
		} else {
			return '';
		};
	</cfscript>
</cffunction>

<cffunction name="iconClassByContentType" output="false">
	<cfargument name="type">
	<cfargument name="subtype" default="Default">

	<cfswitch expression="#arguments.type#">
	<cfcase value="Folder">
		<cfreturn "icon-folder-open-alt">
	</cfcase>
	<cfcase value="Calendar">
		<cfreturn "icon-calendar">
	</cfcase>
	<cfcase value="Gallery">
		<cfreturn "icon-th">
	</cfcase>
	<cfcase value="GalleryItem">
		<cfreturn "icon-picture">
	</cfcase>
	<cfcase value="Link">
		<cfreturn "icon-link">
	</cfcase>
	<cfcase value="Quick">
		<cfreturn "icon-upload-alt">
	</cfcase>
	<cfcase value="File">
		<cfreturn "icon-file-alt">
	</cfcase>
	<cfdefaultcase>
		<cfreturn "icon-file">
	</cfdefaultcase>
	</cfswitch>

</cffunction>

<cffunction name="renderEditableAttribute" output="false">
	<cfargument name="attribute">
	<cfargument name="type" default="text">
	<cfargument name="required" default="false">
	<cfargument name="validation" default="">
	<cfargument name="message" default="">
	<cfargument name="label">
	<cfargument name="value">
	<cfargument name="enableMuraTag" default="true">
	<cfscript>
		var dataString='';
		var inline=' inline';
		if(not structKeyExists(arguments,'label')){
			arguments.label=arguments.attribute;
		}

		arguments.attribute=lcase(arguments.attribute);

		if(not structKeyExists(arguments,'value')){
			arguments.value=variables.$.content(arguments.attribute);
		}

		if(arguments.enableMuraTag){
			arguments.value=setDynamicContent(arguments.value);
		}
		
		if(hasFETools() and this.showInlineEditor and (listFindNoCase('editor,author',variables.$.event('r').perm) or listFind(session.mura.memberships,'S2')) and not (reFindNoCase('(MSIE 8|MSIE 7|MSIE 6)', cgi.http_user_agent))){
			
			dataString=' data-attribute="#arguments.attribute#" data-type="#arguments.type#"';
			
			if(yesNoFormat(arguments.required)){
				dataString=dataString & ' data-required="true"';
			} else {
				dataString=dataString & ' data-required="false"';
			}
			
			if(len(arguments.validation)){
				dataString=dataString & ' data-validate="#arguments.validation#"';
			}
			dataString=dataString & ' data-message="#HTMLEditFormat(arguments.message)#"';
			dataString=dataString & ' data-label="#HTMLEditFormat(arguments.label)#"';

			if(arguments.type eq 'HTMLEditor' ){
				inline='';

				if(not len(arguments.value)){
					arguments.value="<p></p>";
				}
			}
			
			return '<div class="mura-editable inactive#inline#">
						<label class="mura-editable-label">#ucase(arguments.label)#</label>
						<div contenteditable="false" id="mura-editable-attribute-#arguments.attribute#" class="mura-editable inactive mura-editable-attribute#inline#" #dataString#>#arguments.value#</div>
					</div>';
			
		} else {
			return arguments.value;
		}
	</cfscript>
</cffunction>

</cfcomponent>
