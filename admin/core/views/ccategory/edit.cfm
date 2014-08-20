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
<cfset event=request.event>
<cfinclude template="js.cfm">
<cfoutput>
<h1><cfif rc.categoryID neq ''>#application.rbFactory.getKeyValue(session.rb,'categorymanager.editcontentcategory')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'categorymanager.addcontentcategory')#</cfif></h1>

<cfinclude template="dsp_secondary_menu.cfm">

<cfif not structIsEmpty(rc.categoryBean.getErrors())>
  <p class="alert alert-error">#application.utility.displayErrors(rc.categoryBean.getErrors())#</p>
</cfif>

<span id="msg">
#application.pluginManager.renderEvent("onCategoryEditMessageRender", event)#
</span>

<form class="fieldset-wrap" novalidate="novalidate" action="./?muraAction=cCategory.update&siteid=#esapiEncode('url',rc.siteid)#" method="post" name="form1" onsubmit="return validate(this);">

#$.renderEvent("onCategoryBasicTopRender")#

<div class="fieldset">
<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'categorymanager.name')#
  </label>
  <div class="controls">
    <input type="text" name="name" class="span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'categorymanager.namerequired')#" value="#esapiEncode('html_attr',rc.categoryBean.getName())#" maxlength="50">
  </div>
</div>

<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'categorymanager.urltitle')#
  </label>
  <div class="controls">
    <input type="text" name="urltitle" class="span12" value="#esapiEncode('html_attr',rc.categoryBean.getURLTitle())#" maxlength="255">
  </div>
</div>

<div class="control-group">
<div class="span6">
<label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'categorymanager.parentcategory')#
  </label>
  <div class="controls">
    <select name="parentID">
      <option value="">#application.rbFactory.getKeyValue(session.rb,'categorymanager.primary')#</option>
     <cf_dsp_parents siteID="#rc.siteID#" categoryID="#rc.categoryID#" parentID="" actualParentID="#rc.parentID#" nestLevel="1" >
      </select>
    </div>
</div>

<div class="span6">
  <label class="control-label">
    CategoryID
  </label>
  <div class="controls">
    <cfif len(rc.categoryID) and len(rc.categoryBean.getCategoryID())>
      #rc.categoryBean.getCategoryID()#
    <cfelse>
      #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#
    </cfif>
  </div>
</div>

</div>

<div class="control-group">


<div class="span3">  <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'categorymanager.isinterestgroup')#</label>
  <div class="controls">
  	<label class="radio inline" for="isInterestGroupYes">
      <input name="isInterestGroup" id="isInterestGroupYes" type="radio" value="1" <cfif rc.categoryBean.getIsInterestGroup()>checked</cfif>> 
      #application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#
    </label>
    <label class="radio inline" for="isInterestGroupNo"> 
      <input name="isInterestGroup" id="isInterestGroupNo" type="radio" value="0" <cfif not rc.categoryBean.getIsInterestGroup()>checked</cfif>> 
      #application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#
    </label>
  </div></div>



<div class="span3">  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'categorymanager.allowcontentassignments')#
  </label>
  <div class="controls">
  	<label class="radio inline" for="isOpenYes">
      <input name="isOpen" id="isOpenYes" type="radio" value="1" <cfif rc.categoryBean.getIsOpen()>checked</cfif>> #application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#
    </label> 
    <label class="radio inline" for="isOpenNo">
     <input name="isOpen" id="isOpenNo" type="radio" value="0" <cfif not rc.categoryBean.getIsOpen()>checked</cfif>> #application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#
    </label> 
  </div></div>
  
  
  
<div class="span3">  <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'categorymanager.isfeatureable')#</label>
  <div class="controls">
  	<label class="radio inline" for="isfeatureableYes">
      <input name="isfeatureable" id="isfeatureableYes" type="radio" value="1" <cfif rc.categoryBean.getIsfeatureable()>checked</cfif>> 
      #application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#
    </label>
    <label class="radio inline" for="isfeatureableNo"> 
      <input name="isfeatureable" id="isfeatureableNo" type="radio" value="0" <cfif not rc.categoryBean.getIsfeatureable()>checked</cfif>> 
      #application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#
    </label> 
  </div></div>

<div class="span3">  <label class="control-label">Active?</label>
  <div class="controls">
    <label class="radio inline" for="isActiveYes">
      <input name="isActive" id="isActiveYes" type="radio" value="1" <cfif rc.categoryBean.getIsActive()>checked</cfif>> 
      #application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#
    </label>
    <label class="radio inline" for="isActiveNo"> 
      <input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not rc.categoryBean.getIsActive()>checked</cfif>> 
      #application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#
    </label> 
  </div></div>

  
</div>

		
<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#
  </label>
  <div class="controls">
    	<select name="restrictgroups" size="8" multiple="multiple" id="restrictGroups" class="span4">
	       <optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
	       <option value="" <cfif rc.categoryBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
	       <option value="RestrictAll" <cfif rc.categoryBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>	
	       </optgroup>
	       <cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=1</cfquery>	
      	<cfif rsGroups.recordcount>
      	<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
      	<cfloop query="rsGroups">
      	<option value="#rsGroups.groupname#" <cfif listFindNoCase(rc.categoryBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
      	</cfloop>
      	</optgroup>
      	</cfif>
      	<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=0</cfquery>	
      	<cfif rsGroups.recordcount>
      	<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
      	<cfloop query="rsGroups">
      	<option value="#rsGroups.groupname#" <cfif listFindNoCase(rc.categoryBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
      	</cfloop>
      	</optgroup>
      	</cfif>
	   </select>
	</div>
</div>

	<div class="control-group">
	  <label class="control-label">
	    #application.rbFactory.getKeyValue(session.rb,'categorymanager.notes')#
	  </label>
	  <div class="controls">
	    <textarea name="notes" class="span12" rows="8">#esapiEncode('html',rc.categoryBean.getNotes())#</textarea>
	  </div>
	</div>
	
</div>


 #$.renderEvent("onCategoryBasicBottomRender")#

<div class="form-actions">
  <cfif rc.categoryID eq ''>
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'categorymanager.add')#" />
    <input type=hidden name="categoryID" value="#rc.categoryBean.getCategoryID()#">
  <cfelse> 
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'categorymanager.deleteconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'categorymanager.delete')#" /> 
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'categorymanager.update')#" />
    <input type=hidden name="categoryID" value="#rc.categoryBean.getCategoryID()#">
  </cfif>
  <input type="hidden" name="action" value="">
  #rc.$.renderCSRFTokens(context=rc.categoryBean.getCategoryID(),format="form")#
</div>
</form>
</cfoutput>

