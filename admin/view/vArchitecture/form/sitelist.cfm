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

<cfparam name="request.#attributes.linklist#" default="">
<cfparam name="request.#attributes.labellist#" default="">
<cfparam name="attributes.linklist" default="">
<cfparam name="attributes.labellist" default="">
<cfparam name="attributes.moduleid" default="">
<cfparam name="attributes.sort" default="asc">
<cfparam name="attributes.context" default="">
<cfparam name="attributes.stub" default="">
<cfparam name="attributes.indexFile" default="index.cfm">

<cfset rsNest=application.contentManager.getNest('#attributes.parentid#','#attributes.siteid#')>
<cfoutput query="rsNest">
<cfset link=application.contentRenderer.createHREF(rsNest.type,rsNest.filename,attributes.siteid,rsnest.contentid,rsNest.target,rsnest.targetParams,'',attributes.context,attributes.stub,attributes.indexFile) />
<cfset "request.#attributes.linklist#"=listappend(evaluate("request.#attributes.linklist#"),"#link#","^")>
<cfsavecontent variable="templabel"><cfif attributes.nestlevel><cfloop  from="1" to="#attributes.NestLevel#" index="I">&nbsp;&nbsp;</cfloop></cfif>#rsnest.menutitle#</cfsavecontent>
<cfset "request.#attributes.labellist#"=listappend(evaluate("request.#attributes.labellist#"),templabel,"^")>
<cfif rsNest.hasKids><cf_sitelist parentid="#rsnest.contentid#" 
  nestlevel="#evaluate(attributes.nestlevel + 1)#" 
  siteid="#attributes.siteid#"
  moduleid="#attributes.moduleid#"
  linklist="#attributes.linklist#"
  labellist="#attributes.labellist#"
  sort="#attributes.sort#"
  context="#attributes.context#"
  stub="#attributes.stub#"
  indexFile="#attributes.indexFile#"></cfif></cfoutput>
  