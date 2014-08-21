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
<cfset rsData=application.dataCollectionManager.read(rc.responseid)/>
</cfsilent>
<cfoutput>
<form novalidate="novalidate" name="form1" action="index.cfm" method="post">



<cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>

<div class="control-group">
  <label class="control-label">Date/Time Entered</label>
  <div class="controls">#rsdata.entered#</div>
</div>

<cfloop list="#rc.fieldnames#" index="f">
	<cftry>
		<cfset fValue=info['#f#']>
		<cfcatch>
			<cfset fValue="">
		</cfcatch>
	</cftry>
	<cfif findNoCase('attachment',f) and isValid("UUID",fvalue)>
		<input type="hidden" name="#esapiEncode('html_attr',f)#" value="#fvalue#">
	<cfelse>
		<div class="control-group">
  			<label class="control-label">#esapiEncode('html',f)#</label>
  			<div class="controls">
  				<cfif len(fValue) gt 100>
  					<textarea name="#esapiEncode('html_attr',f)#">#esapiEncode('html',fvalue)#</textarea>
  				<cfelse>
  					<input type="text" name="#esapiEncode('html_attr',f)#" value="#esapiEncode('html_attr',fvalue)#">
  			</cfif>
  		    </div>
 		 </div>
	</cfif>
</cfloop>

<div class="form-actions">
<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.update')#" /><input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','This');" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponse')#" />
</div>
<input type="hidden" name="formid" value="#esapiEncode('html_attr',rc.contentid)#">
<input type="hidden" name="contentid" value="#esapiEncode('html_attr',rc.contentid)#">
<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
<input type="hidden" name="muraAction" value="cArch.datamanager">
<input type="hidden" name="responseID" value="#rsdata.responseID#">
<input type="hidden" name="hour1" value="#esapiEncode('html_attr',rc.hour1)#">
<input type="hidden" name="hour2" value="#esapiEncode('html_attr',rc.hour2)#">
<input type="hidden" name="minute1" value="#esapiEncode('html_attr',rc.minute1)#">
<input type="hidden" name="minute2" value="#esapiEncode('html_attr',rc.minute2)#">
<input type="hidden" name="date1" value="#esapiEncode('html_attr',rc.date1)#">
<input type="hidden" name="date2" value="#esapiEncode('html_attr',rc.date2)#">
<input type="hidden" name="fieldlist" value="#esapiEncode('html_attr',rc.fieldnames)#">
<input type="hidden" name="sortBy" value="#esapiEncode('html_attr',rc.sortBy)#">
<input type="hidden" name="sortDirection" value="#esapiEncode('html_attr',rc.sortDirection)#">
<input type="hidden" name="filterBy" value="#esapiEncode('html_attr',rc.filterBy)#">
<input type="hidden" name="keywords" value="#esapiEncode('html_attr',rc.keywords)#">
<input type="hidden" name="entered" value="#rsData.entered#">
<input type="hidden" name="moduleid" value="#esapiEncode('html_attr',rc.moduleid)#">
<input type="hidden" name="action" value="update">
#rc.$.renderCSRFTokens(context=rsdata.responseID,format="form")#
</form>
</cfoutput>