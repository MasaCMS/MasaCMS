<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent>
<cfset userBean=application.userManager.read(attributes.baseID)/>
<cfset extendSets=application.classExtensionManager.getSubTypeByName(attributes.type,attributes.subtype,attributes.siteid).getExtendSets(true) />
<cfif userBean.getType() eq 2>
	<cfset started=false />
<cfelse>
	<cfset started=true />
</cfif>
<cfset style="" />
</cfsilent>
<cfif arrayLen(extendSets)>
<dl class="oneColumn"   id="extendDL">
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
<cfset extendSetBean=extendSets[s]/>
<cfoutput><cfif  userBean.getType() eq 2><cfset style=extendSetBean.getStyle()/><cfif not len(style)><cfset started=true/></cfif></cfif>
	<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
	<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
	<dt <cfif not started>class="first"<cfset started=true/><cfelse>class="separate"</cfif>>#extendSetBean.getName()#</dt>
	<cfsilent>
	<cfset attributesArray=extendSetBean.getAttributes() />
	</cfsilent>
	<dd><dl><cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
		<cfset attributeBean=attributesArray[a]/>
		<cfset attributeValue=userBean.getExtendedAttribute(attributeBean.getAttributeID(),true) />
		<dt>
		<cfif len(attributeBean.getHint())>
		<a href="##" class="tooltip">#attributeBean.getLabel()# <span>#attributeBean.gethint()#</span></a>
		<cfelse>
		#attributeBean.getLabel()#
		</cfif>
		<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'> <a href="#application.configBean.getContext()#/tasks/render/file/?fileID=#attributeValue#" target="_blank">[Download]</a> <input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/> Delete</cfif>
		</dt>
		<dd>#attributeBean.renderAttribute(attributeValue)#</dd>
	</cfloop></dl></dd>
</cfoutput>
</cfloop>
</dl>
</cfif>
<cfoutput>
<dl class="oneColumn"  id="extendMessage" <cfif started>style="display:none"</cfif>>
<dd><br/><em>There are currently no extended attributes available.</em></dd></dl></cfoutput>
