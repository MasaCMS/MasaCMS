<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfparam name="request.#attributes.parentlabels#" default="">
<cfparam name="request.#attributes.parentlist#" default="">
<cfparam name="attributes.parentlabels" default="">
<cfparam name="attributes.parentlist" default="">
<cfparam name="attributes.moduleid" default="">
<cfparam name="attributes.sortDirection" default="asc">
<cfparam name="attributes.sortBy" default="orderno">
<cfparam name="attributes.contentid" default="">

<cfset rsNest=application.contentManager.getNest('#attributes.parentid#','#attributes.siteid#','#attributes.sortBy#','#attributes.sortDirection#')>
<cfoutput query="rsNest">
<cfif attributes.contentid neq rsnest.contentid>
	<cfset variables.title=replace(rsNest.menutitle,",","","ALL")>
	<cfif (rsnest.type eq 'Page' or rsnest.type eq 'Portal' or rsnest.type eq 'Calendar')>
	<cfset "request.#attributes.parentlist#"=listappend(evaluate("request.#attributes.parentlist#"),"#rsnest.contentid#")>
	<cfsavecontent variable="templabel"><cfif attributes.nestlevel><cfloop  from="1" to="#attributes.NestLevel#" index="I">&nbsp;&nbsp;</cfloop></cfif>#variables.title#</cfsavecontent>
	<cfset "request.#attributes.parentlabels#"=listappend(evaluate("request.#attributes.parentlabels#"),templabel)>
	</cfif><cfif rsNest.hasKids>
	 <cf_siteParentsGenerate parentid="#rsnest.contentid#" 
	  nestlevel="#evaluate(attributes.nestlevel + 1)#" 
	  siteid="#attributes.siteid#"
	  moduleid="#attributes.moduleid#"
	  parentlabels="#attributes.parentlabels#"
	  parentlist="#attributes.parentlist#"
	  sortBy="#rsNest.sortBy#"
	  sortDirection="#rsNest.sortDirection#"
	  contentid="#attributes.contentid#"></cfif>
	  </cfif>
  </cfoutput>
