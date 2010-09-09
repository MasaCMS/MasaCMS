<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent>
<cfif request.contentBean.getResponseDisplayFields() neq "~">
  <cfset summaryList=listfirst(request.contentBean.getResponseDisplayFields(),"~")>
  <cfset detailList=listLast(request.contentBean.getResponseDisplayFields(),"~")>
  <cfelse>
  <cfset summaryList=fieldnames>
  <cfset detailList=fieldnames>
</cfif>
<cfhtmlhead text='<script src="js/manageData.js?coreversion=#application.coreversion#" type="text/javascript"></script>'>
</cfsilent>
<script language="javascript" type="text/javascript">
function setFields(){
document.getElementById('responseDisplayFields').value=document.getElementById('summaryList2').value + '~' + document.getElementById('detailList2').value;
}
</script>

<cfoutput>
  <form name="frmDisplayFields" method="post" action="index.cfm">
  <dl class="oneColumn">
  <dt class="first">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfields')#</dt>
  <dd><table>
    <tr>
      <td valign="top">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablefields')#<br/>
        <select name="availableFields" size="10" id="availableFields" class="multiSelect">
          <cfloop list="#attributes.fieldnames#" index="f">
            <option value="#f#">#f#</option>
          </cfloop>
        </select></td>
      <td><table>
          <tr>
            <td class="nested"><input type="button" value=">>" onclick="addObject('availableFields','summaryList','summaryList2');setFields();" class="objectNav">
              <br />
              <input type="button" value="<<" onclick="deleteObject('summaryList','summaryList2');setFields();" class="objectNav">            </td>
            <td class="nested"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.summarydisplayfields')#<br />
              <select name="summaryList" id="summaryList" size="4" class="multiSelect">
                <cfif summaryList neq "">
                  <cfloop list="#summaryList#" delimiters="^" index="f">
                    <option value="#f#">#f#</option>
                  </cfloop>
                </cfif>
              </select>
              <input style="display:none" type="text" name="summaryList2" id="summaryList2" value="#summaryList#" class="multiSelect">            </td>
            <td  class="nested"><input type="button" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.up')#" onclick="moveUp('summaryList','summaryList2');setFields();" class="objectNav">
              <br />
              <input type="button" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.down')#" onclick="moveDown('summaryList','summaryList2');setFields();" class="objectNav">            </td>
          </tr>
          <tr>
            <td class="nested"><input type="button" value=">>" onclick="addObject('availableFields','detailList','detailList2');setFields();" class="objectNav">
              <br />
              <input type="button" value="<<" onclick="deleteObject('detailList','detailList2');setFields();" class="objectNav">            </td>
            <td class="nested"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.detaildisplayfields')#<br />
              <select name="detailList"  id="detailList" size="4" style="width:310px;">
                <cfif detailList neq "">
                  <cfloop list="#detailList#" delimiters="^" index="f">
                    <option value="#f#">#f#</option>
                  </cfloop>
                </cfif>
              </select>
              <input style="display:none" type="text" name="detailList2" id="detailList2" value="#detailList#">            </td>
            <td  class="nested"><input type="button" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.up')#" onclick="moveUp('detailList','detailList2');setFields();" class="objectNav">
              <br />
              <input type="button" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.down')#" onclick="moveDown('detailList','detailList2');setFields();" class="objectNav">            </td>
          </tr>
        </table>
        <input style="display:none" type="text" name="responseDisplayFields" id="responseDisplayFields" value="#request.contentBean.getResponseDisplayFields()#"/></td>
    </tr>
  </table>
  </dd>
  <dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.recordsperpage')#</dt>
  <dd><select name="nextN" class="dropdown">
          <cfloop from="5" to="50" step="5" index="r">
            <option value="#r#" <cfif r eq request.contentBean.getNextN()>selected</cfif>>#r#</option>
          </cfloop>
        </select></dd>
  <dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sortby')#:</dt>
  <dd><select name="sortBy" class="dropdown">
          <cfloop list="#attributes.fieldnames#" index="f">
            <option value="#f#" <cfif f eq request.contentBean.getSortBy()>selected</cfif>>#f#</option>
          </cfloop>
        </select>
        <select name="sortDirection" class="dropdown">
          <option value="asc" <cfif request.contentBean.getSortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ascending')#</option>
          <option value="desc" <cfif request.contentBean.getSortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.descending')#</option>
        </select></dd>
  </dl>
  <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.frmDisplayFields,'setDisplay');"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.update')#</span></a>
<input type="hidden" value="setDisplay" name="action">
<input type="hidden" name="fuseaction" value="cArch.datamanager" />
<input type="hidden" name="contentid" value="#HTMLEditFormat(attributes.contentid)#" />
<input type="hidden" name="siteid" value="#HTMLEditFormat(session.siteid)#" />
<input type="hidden" name="moduleid" value="#attributes.moduleid#" />
</cfoutput>
</form>
