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
<cfsilent>
<cfset detailList = Left(rc.contentBean.getResponseDisplayFields(), 1) neq '~' ? ListFirst(rc.contentBean.getResponseDisplayFields(), '~') : ''>
<cfset summaryList = Right(rc.contentBean.getResponseDisplayFields(), 1) neq '~' ? ListLast(rc.contentBean.getResponseDisplayFields(), '~') : ''>
<cfhtmlhead text='<script src="assets/js/manageData.js?coreversion=#application.coreversion#" type="text/javascript"></script>'>
</cfsilent>
<script type="text/javascript">
function setFields(){
document.getElementById('responseDisplayFields').value=document.getElementById('summaryList2').value + '~' + document.getElementById('detailList2').value;
}
</script>

<cfoutput>
  <form novalidate="novalidate" name="frmDisplayFields" method="post" action="index.cfm">

<div class="mura-control-group">
<!---   <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfields')#</label> --->
  <div class="mura-control-group half">
  <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablefields')#</label>
    <select name="availableFields" size="10" id="availableFields" class="multiSelect">
      <cfloop list="#rc.fieldnames#" index="f">
        <option value="#esapiEncode('html_attr',f)#">#esapiEncode('html',f)#</option>
      </cfloop>
    </select>
  </div>
  <div class="mura-control-group half">
    <table class="mura-control-table">
      <tr>
        <td class="nested"><input type="button" class="btn btn-sm" value=">>" onclick="dataManager.addObject('availableFields','summaryList','summaryList2');" class="objectNav btn">
          <br />
          <input type="button" class="btn btn-sm" value="<<" onclick="dataManager.deleteObject('summaryList','summaryList2');" class="objectNav btn">            </td>
        <td class="nested" style="width:76%;"> <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.summarydisplayfields')#</label><br />
          <select name="summaryList" id="summaryList" size="4" style="width:100%;" class="multiSelect">
            <cfif summaryList neq "">
              <cfloop list="#summaryList#" delimiters="^" index="f">
                <option value="#esapiEncode('html_attr',f)#">#esapiEncode('html',f)#</option>
              </cfloop>
            </cfif>
          </select>
          <input type="hidden" name="summaryList2" id="summaryList2" value="#summaryList#" class="multiSelect"></td>
        <td  class="nested"><input type="button" class="btn btn-sm" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.up')#" onclick="dataManager.moveUp('summaryList','summaryList2');" class="objectNav btn">
          <br />
          <input type="button" class="btn btn-sm" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.down')#" onclick="dataManager.moveDown('summaryList','summaryList2');" class="objectNav btn"></td>
      </tr>
      <tr>
        <td class="nested"><input type="button" class="btn btn-sm" value=">>" onclick="dataManager.addObject('availableFields','detailList','detailList2');" class="objectNav btn">
          <br />
          <input type="button" class="btn btn-sm" value="<<" onclick="dataManager.deleteObject('detailList','detailList2');" class="objectNav btn"></td>
        <td class="nested"><label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.detaildisplayfields')#</label><br />
          <select name="detailList"  id="detailList" size="4" style="width:100%;">
            <cfif detailList neq "">
              <cfloop list="#detailList#" delimiters="^" index="f">
                <option value="#esapiEncode('html_attr',f)#">#esapiEncode('html',f)#</option>
              </cfloop>
            </cfif>
          </select>
          <input type="hidden" name="detailList2" id="detailList2" value="#detailList#"></td>
        <td  class="nested"><input type="button" class="btn btn-sm" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.up')#" onclick="dataManager.moveUp('detailList','detailList2');" class="objectNav btn">
          <br />
          <input type="button" class="btn btn-sm" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.down')#" onclick="dataManager.moveDown('detailList','detailList2');" class="objectNav btn"></td>
      </tr>
    </table>
  </div>
</div>

<div class="mura-control-group">
  <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.recordsperpage')#
  </label>
  <select name="nextN" class="dropdown mura-constrain mura-numeric">
    <cfloop from="5" to="50" step="5" index="r">
      <option value="#r#" <cfif r eq rc.contentBean.getNextN()>selected</cfif>>#r#</option>
    </cfloop>
  </select>
</div>

<div class="mura-control-group">
  <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sortby')#</label>
  <select name="sortBy" class="dropdown mura-constrain">
    <cfloop list="#rc.fieldnames#" index="f">
      <option value="#esapiEncode('html_attr',f)#" <cfif f eq rc.contentBean.getSortBy()>selected</cfif>>#esapiEncode('html',f)#</option>
    </cfloop>
  </select>
  <select name="sortDirection" class="dropdown mura-constrain">
    <option value="asc" <cfif rc.contentBean.getSortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ascending')#</option>
    <option value="desc" <cfif rc.contentBean.getSortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.descending')#</option>
  </select>
</div>

<div class="mura-actions">
  <div class="form-actions">
    <button class="btn mura-primary" onclick="submitForm(document.forms.frmDisplayFields,'setDisplay');"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.update')#</button>
  </div>
</div>

<input type="hidden" value="setDisplay" name="action">
<input type="hidden" name="muraAction" value="cArch.datamanager" />
<input type="hidden" name="contentid" value="#esapiEncode('html_attr',rc.contentid)#" />
<input type="hidden" name="siteid" value="#esapiEncode('html_attr',session.siteid)#" />
<input type="hidden" name="moduleid" value="#esapiEncode('html_attr',rc.moduleid)#" />
</cfoutput>
</form>
