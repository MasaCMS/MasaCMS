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

<cfproperty name="creativeID" type="string" default="" required="true" />
<cfproperty name="userID" type="string" default="" required="true" />
<cfproperty name="dateCreated" type="date" default="" required="true" />
<cfproperty name="lastUpdate" type="date" default="" required="true" />
<cfproperty name="lastUpdateBy" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="creativeType" type="string" default="" required="true" />
<cfproperty name="fileID" type="string" default="" required="true" />
<cfproperty name="mediaType" type="string" default="" required="true" />
<cfproperty name="redirectURL" type="string" default="" required="true" />
<cfproperty name="altText" type="string" default="" required="true" />
<cfproperty name="notes" type="string" default="" required="true" />
<cfproperty name="isActive" type="numeric" default="1" required="true" />
<cfproperty name="height" type="numeric" default="0" required="true" />
<cfproperty name="width" type="numeric" default="0" required="true" />
<cfproperty name="textBody" type="string" default="" required="true" />
<cfproperty name="title" type="string" default="" required="true" />
<cfproperty name="linkTitle" type="string" default="" required="true" />
<cfproperty name="fileEXT" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="target" type="string" default="_blank" required="true" />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.creativeID=""/>
	<cfset variables.instance.userID=""/>
	<cfset variables.instance.dateCreated="#now()#"/>
	<cfset variables.instance.lastUpdate="#now()#"/>
	<cfset variables.instance.lastUpdateBy=""/>
	<cfset variables.instance.name=""/>
	<cfset variables.instance.creativeType=""/>
	<cfset variables.instance.fileID=""/>
	<cfset variables.instance.mediaType=""/>
	<cfset variables.instance.redirectURL=""/>
	<cfset variables.instance.altText=""/>
	<cfset variables.instance.notes=""/>
	<cfset variables.instance.isActive=1/>
	<cfset variables.instance.height=0/>
	<cfset variables.instance.width=0/>
	<cfset variables.instance.textBody=""/>
	<cfset variables.instance.title=""/>
	<cfset variables.instance.linkTitle=""/>
	<cfset variables.instance.fileExt=""/>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.target="_blank"/>
	
	<cfreturn this />
</cffunction>

<cffunction name="setAdvertiserManager">
	<cfargument name="advertiserManager">
	<cfset variables.advertiserManager=arguments.advertiserManager>
	<cfreturn this>
</cffunction>

<cffunction name="getCreativeID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.creativeID)>
		<cfset variables.instance.creativeID = createUUID() />
	</cfif>
	<cfreturn variables.instance.creativeID />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfif isDate(arguments.dateCreated)>
	<cfset variables.instance.dateCreated = parseDateTime(arguments.dateCreated) />
	</cfif>
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	</cfif>
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
</cffunction>

<cffunction name="setTarget" access="public" output="false">
	<cfargument name="target" type="String" />
	<cfif len(arguments.target)>
	<cfset variables.instance.target = trim(arguments.target) />
	</cfif>
</cffunction>

<cffunction name="save" output="false">
<cfset setAllValues(variables.advertiserManager.saveCreative(this).getAllValues())>
<cfreturn this>
</cffunction>

<cffunction name="delete" output="false">
<cfset variables.advertiserManager.deleteCreative(getCreativeID())>
</cffunction>
</cfcomponent>