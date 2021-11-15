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
<cfparam name="objectparams" default="#structNew()#">
<cfparam name="objectparams.displayRSS" default="false">
<cfparam name="useRss" default="#objectparams.displayRSS#">
<cfif not isValid('uuid',arguments.objectid)>
	<cfset crumbIterator=$.content().getCrumbIterator()>

	<cfloop condition="crumbIterator.hasNext()">
		<cfset crumb=crumbIterator.next()>
		<cfif listFindNoCase('Folder',crumb.getType())>
			<cfset arguments.objectid=crumb.getContentID()>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>
<cfset section=$.getBean('content').loadBy(contentid=arguments.objectid)>
<cfif section.exists()>
	<cfsilent>
	<cfif section.gettype() neq "Calendar">
	<cfset today=now() />
	<cfelse>
	<cfset today=createDate($.event('year'),$.event('month'),1) />
	</cfif>
	<cfset rs=section.getKidsCategoryQuery()>

	<cfset viewAllURL="#$.siteConfig('context')##getURLStem($.event('siteID'),section.getFilename())#">
	<cfif len($.event('relatedID'))>
		<cfset viewAllURL=viewAllURL & "?relatedID=#HTMLEditFormat($.event('relatedID'))#">
	</cfif>
</cfsilent>
	<cfif rs.recordcount>
	<cfoutput>
	<div class="svCatSummary mura-category-summary #this.navWrapperClass#">
	<cfif len(this.navCategoryWrapperBodyClass)><div class="#this.navCategoryWrapperBodyClass#"></cfif>
	<#$.getHeaderTag('subHead1')#>#$.rbKey('list.categories')#</#$.getHeaderTag('subHead1')#>
	<ul class="#this.ulTopClass#"><cfloop query="rs">
		<cfsilent>
		<cfif len(rs.filename)>
			<cfset categoryURL="#$.siteConfig('context')##getURLStem($.event('siteID'),section.getFilename() & '/category/' & rs.filename)#">
			<cfif len($.event('relatedID'))>
				<cfset categoryURL=categoryURL & "?relatedID=#HTMLEditFormat($.event('relatedID'))#">
			</cfif>
		<cfelse>
			<cfset categoryURL="#$.siteConfig('context')##getURLStem($.event('siteID'),section.getFilename())#?categoryID=#rs.categoryID#">
			<cfif len($.event('relatedID'))>
				<cfset categoryURL=categoryURL & "&relatedID=#HTMLEditFormat($.event('relatedID'))#">
			</cfif>
		</cfif>
		</cfsilent>
		<cfset class=iif(rs.currentrow eq 1,de('first'),de(''))>
			<li class="#this.navLiClass#<cfif len(class)> #class#</cfif><cfif listFind($.event('categoryID'),rs.categoryID)> #this.liCurrentClass#</cfif>">
				<a <cfif listFind($.event('categoryID'),rs.categoryID)>class="#this.aCurrentClass#"<cfelse>class="#this.aNotCurrentClass#"</cfif> href="#categoryURL#">#rs.name# <span>(#rs.count#)</span></a>
				<cfif useRss>
					<a class="rss" href="#$.globalConfig('context')#/index.cfm/feed/v1/?siteid=#$.event('siteID')#&contentID=#section.getContentID()#&categoryID=#rs.categoryID#"
					<cfif listFind($.event('categoryID'),rs.categoryID)>class="#this.aCurrentClass#"<cfelse>class="#this.aNotCurrentClass#"</cfif>>RSS</a>
				</cfif>
			</li>
		</cfloop>
		<li class="last #this.navLiClass#"><a href="#viewAllURL#" <cfif not len($.event('categoryID'))>class="#this.aCurrentClass#"<cfelse>class="#this.aNotCurrentClass#"</cfif>>#$.rbKey('list.viewall')#</a><cfif useRss><a class="rss" href="#$.globalConfig('context')#/index.cfm/feed/v1/?siteid=#$.event('siteID')#&contentID=#rsSection.contentid#">RSS</a></cfif></li>
	</ul>
	</div>
	<cfif len(this.navCategoryWrapperBodyClass)></div></cfif>
	</cfoutput>
	</cfif>
</cfif>
