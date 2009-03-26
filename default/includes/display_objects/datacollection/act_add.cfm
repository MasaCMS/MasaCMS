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

<cfparam name="request.copyEmail" default="false">
<cfparam name="request.sendto" default="">
<cfparam name="request.email" default="">
<cfparam name="request.hkey" default="">
<cfparam name="request.ukey" default="">
<cfparam name="acceptError" default="">

<cfif request.hkey eq '' or request.hKey eq hash(lcase(request.ukey))>
<cfif rsform.responseChart>
	<cfif refind("Mac",cgi.HTTP_USER_AGENT) and refind("MSIE 5",cgi.HTTP_USER_AGENT)>
		<cfset acceptdata=0>
		<cfset acceptError="Browser">  
	<cfelse>
	
		<cfif not isdefined('cookie.poll')>
			<cfset cookie.poll="#arguments.objectid#">
		<cfelseif isdefined('client.poll') and listfind(cookie.poll,arguments.objectid)>
			<cfset acceptdata=0> 
			<cfset acceptError="Duplicate"> 
		<cfelseif isdefined('cookie.poll') and not listfind(cookie.poll,arguments.objectid)>
			<cfset templist=cookie.poll>
			<cfif listlen(templist) eq 6>
				<cfset templist=listdeleteat(templist,1)>
			</cfif>
			<cfset templist=listappend(templist,arguments.objectid)>
			<cfset cookie.poll="#templist#">
		</cfif>
	
	</cfif>
</cfif>
<cfelse>
	<cfset acceptdata=0>
	<cfset acceptError="Captcha"> 
</cfif>

<cfif not structKeyExists(request,"fieldnames")>
<cfset request.fieldnames=""/>
<cfloop collection="#form#" item="fn">
	<cfset request.fieldnames=listAppend(request.fieldnames,fn) />
</cfloop>
</cfif>

<cfif acceptdata>
<cfset info=application.dataCollectionManager.update(structCopy(request))/>
	
	<cfif request.copyEmail eq 'true' and request.email neq ''>
		<cfset request.sendto=listappend(request.sendto,request.email) />
	</cfif>
	
	<cfif request.sendto neq  ''>
			<cfset variables.sendto=listappend(rsform.responsesendto,request.sendto) />
		<cfelse>
			<cfset variables.sendto=rsform.responsesendto />
	</cfif>
	
	<cfparam name="request.subject" default="#rsForm.title#">
			
	<cfif not StructIsEmpty(info) and variables.sendto neq ''> 
			<cfset email=application.serviceFactory.getBean('mailer')/>
			<cfset email.send(info,'#variables.sendto#','#rsForm.title#','#request.subject#','#request.siteid#','#request.email#')>
	</cfif>
			
</cfif>