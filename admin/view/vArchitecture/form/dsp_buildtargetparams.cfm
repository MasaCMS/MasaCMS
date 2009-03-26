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