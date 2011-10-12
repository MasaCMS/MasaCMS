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

<cfsilent>
<cfparam name="variables.toolbar" default="">
<cfparam name="variables.location" default="">
<cfparam name="variables.directories" default="">
<cfparam name="variables.status" default="">
<cfparam name="variables.menubar" default="">
<cfparam name="variables.resizable" default="">
<cfparam name="variables.copyhistory" default="">
<cfparam name="variables.scrollbars" default="">
<cfparam name="variables.toolbar" default="">
<cfparam name="variables.height" default="0">
<cfparam name="variables.width" default="0">
<cfparam name="variables.top" default="0">
<cfparam name="variables.left" default="0">
<cfloop list="#request.contentBean.gettargetParams()#" delimiters="," index="p">
  <cfset variables[listfirst(p,"=")]=listlast(p,"=")/>
</cfloop>
</cfsilent>

<cfoutput>
  <ul class="params">
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.height')#<br />
      <input type="text" name="height" value="#HTMLEditFormat(variables.height)#" class="textAlt" size=4 maxlength="4" onChange="setTargetParams(document.contentForm);">
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.width')#<br />
      <input type="text" name="width" value="#HTMLEditFormat(variables.width)#"  class="textAlt" size=4 maxlength="4" onChange="setTargetParams(document.contentForm);">
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.top')#<br />
      <input type="text" name="top" value="#HTMLEditFormat(variables.top)#"  class="textAlt" size=4 maxlength="4" onChange="setTargetParams(document.contentForm);">
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')# <br />
      <input type="text" name="left" value="#HTMLEditFormat(variables.left)#"  class="textAlt" size=4 maxlength="4" onChange="setTargetParams(document.contentForm);">
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.toolbar')#<br />
      <select name="toolbar" class="dropdown" onChange="setTargetParams(document.contentForm);">
        <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option>
		<option value="no" <cfif variables.toolbar eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.toolbar eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
      </select>
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.location')#<br />
      <select name="location" class="dropdown" onChange="setTargetParams(document.contentForm);">
        <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option>
		<option value="no" <cfif variables.location eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.location eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
      </select>
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.directories')# <br />
      <select name="directories" class="dropdown" onChange="setTargetParams(document.contentForm);">
       <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option>
	   <option value="no" <cfif variables.directories eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.directories eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
      </select>
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.status')# <br />
      <select name="status" class="dropdown" onChange="setTargetParams(document.contentForm);">
        <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option>
		 <option value="no" <cfif variables.status eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.status eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
      </select>
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.menubar')# <br />
      <select name="menubar" class="dropdown" onChange="setTargetParams(document.contentForm);">
        <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option> 
		<option value="no" <cfif variables.menubar eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.menubar eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>   
      </select>
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.resizable')# <br />
      <select name="resizable" class="dropdown" onChange="setTargetParams(document.contentForm);">
        <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option>
		<option value="no" <cfif variables.resizable eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.resizable eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
      </select>
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.history')# <br />
      <select name="copyhistory" class="dropdown" onChange="setTargetParams(document.contentForm);">
       <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option>
	    <option value="no" <cfif variables.copyhistory eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.copyhistory eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
      </select>
    </li>
    <li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.scrollbars')# <br />
      <select name="scrollbars" class="dropdown" onChange="setTargetParams(document.contentForm);">
       <option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')#</option>
	   <option value="no" <cfif variables.scrollbars eq 'no'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="yes" <cfif variables.scrollbars eq 'yes'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option> 
      </select>
    </li>
  </ul>
</cfoutput>