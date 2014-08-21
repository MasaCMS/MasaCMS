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
<cfoutput>
<h1><cfif rc.changesetID neq ''>#application.rbFactory.getKeyValue(session.rb,'changesets.editchangeset')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'changesets.addchangeset')#</cfif></h1>
<cfset csrfTokens= #rc.$.renderCSRFTokens(context=rc.changeset.getchangesetID(),format="url")#>
<cfinclude template="dsp_secondary_menu.cfm">

<cfif not structIsEmpty(rc.changeset.getErrors())>
  <p class="alert alert-error">#application.utility.displayErrors(rc.changeset.getErrors())#</p>
</cfif>

<cfif rc.changeset.getPublished()>
<p class="alert">
#application.rbFactory.getKeyValue(session.rb,'changesets.publishednotice')#
</p>
<cfelse>
  <cfset hasPendingApprovals=rc.changeset.hasPendingApprovals()>
  <cfif hasPendingApprovals>
    <div class="alert alert-error">
        #application.rbFactory.getKeyValue(session.rb,'changesets.haspendingapprovals')# 
    </div>  
  </cfif>
</cfif>

<span id="msg">
#application.pluginManager.renderEvent("onChangesetEditMessageRender", request.event)#
</span>

<form novalidate="novalidate" action="./?muraAction=cChangesets.save&siteid=#esapiEncode('url',rc.siteid)#" method="post" name="form1" onsubmit="return validate(this);">

<cfset tablist="tabBasic">
<cfset tablabellist="Basic">
<cfset hasCategories=application.categoryManager.getCategoryCount(rc.siteid)>
<cfif hasCategories>
    <cfset tablist=listAppend(tablist,'tabCategorization')>
    <cfset tablabellist=listAppend(tablabellist,'Categorization')>
</cfif>
 <cfset tablist=listAppend(tablist,'tabTags')>
<cfset tablabellist=listAppend(tablabellist,'Tags')>

<div class="tabbable tabs-left mura-ui">
    <ul class="nav nav-tabs tabs initActiveTab">
    <cfloop from="1" to="#listlen(tabList)#" index="t">
    <li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
    </cfloop>
    </ul>
    <div class="tab-content">
    <div id="tabBasic" class="tab-pane fade">
      <div class="fieldset">
      <div class="control-group">
        <label class="control-label">
          #application.rbFactory.getKeyValue(session.rb,'changesets.name')#
        </label>
        <div class="controls">
        <input name="name" type="text" class="span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'changesets.titlerequired')#" value="#esapiEncode('html_attr',rc.changeset.getName())#" maxlength="50">
         </div>
      </div>

      <div class="control-group">
        <label class="control-label">
          #application.rbFactory.getKeyValue(session.rb,'changesets.description')#
        </label>
        <div class="controls">
        <textarea name="description" class="span12" rows="6">#esapiEncode('html',rc.changeset.getDescription())#</textarea>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">
          <a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.changesetclosedate"))#" data-container="body">#application.rbFactory.getKeyValue(session.rb,'changesets.closedate')# <i class="icon-question-sign"></i></a>
          </label>
        <div class="controls">
           <cfif rc.changeset.getPublished()>
              <cfif lsIsDate(rc.changeset.getCloseDate())>
                #LSDateFormat(rc.changeset.getCloseDate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getCloseDate(),"medium")#
              <cfelse>
                 #LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"medium")#
              </cfif>
          <cfelse>
             <cf_datetimeselector name="closeDate" datetime="#rc.changeset.getCloseDate()#" defaulthour="23" defaultminute="59">
          
        </cfif>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">
          <a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.changesetpublishdate"))#" data-container="body">#application.rbFactory.getKeyValue(session.rb,'changesets.publishdate')# <i class="icon-question-sign"></i></a>
          </label>
        <div class="controls">
          <cfif rc.changeset.getPublished()>
          #LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"medium")#
        <cfelse>
         
          <cf_datetimeselector name="publishDate" datetime="#rc.changeset.getpublishdate()#">
         
        </cfif>

        </div>
      </div>

      </div>

    </div>

    <cfif hasCategories> 
      <div id="tabCategorization" class="tab-pane fade">
        <div class="fieldset">
          <div class="control-group">
            <!--- Category Filters --->
            <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'changesets.categoryassignments')#</label>
            <div id="mura-list-tree" class="controls">
              <cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" categoryid="#rc.changeset.getCategoryID()#">
            </div>
          </div>
        </div>
      </div>
    </cfif>

   
    <div id="tabTags" class="tab-pane fade">
      <div class="fieldset">
        <div class="control-group"> 
          <label class="control-label">
          #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tags')#
          </label>      
          <div class="controls">
              <div id="tags" class="tagSelector">
              <cfif len(rc.changeset.getTags())>
                <cfloop list="#rc.changeset.getTags()#" index="i">
                  <span class="tag">
                  #esapiEncode('html',i)# <a><i class="icon-remove-sign"></i></a>
                  <input name="tags" type="hidden" value="#esapiEncode('html_attr',i)#">
                  </span>
                </cfloop>
              </cfif>
              <input type="text" name="tags">
            </div>
          </div>

          <script>
          $(document).ready(function(){
            $.get('?muraAction=cChangesets.loadtagarray&siteid=' + siteid).done(function(data){
            var tagArray=eval('(' + data + ')'); 
            $('##tags').tagSelector(tagArray, 'tags');
            });
          });
        </script>
      </div>
    </div>
  </div>

<div class="form-actions">
  <cfif rc.changesetID eq ''>
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.add')#" /><input type=hidden name="changesetID" value="#rc.changeset.getchangesetID()#">
  <cfelse>
    <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#" onclick="confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'changesets.deleteconfirm'))#','./?muraAction=cChangesets.delete&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())##csrfTokens#')" /> 
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.update')#" />
    <cfif not rc.changeset.getPublished() and not hasPendingApprovals>
      <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.publishnow')#" onclick="confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'changesets.publishnowconfirm'))#','./?muraAction=cChangesets.publish&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())##csrfTokens#')" /> 
    </cfif>
    <cfif rc.changeset.getPublished()>
        <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.rollback')#" onclick="confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'changesets.rollbackconfirm'))#','./?muraAction=cChangesets.rollback&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())##csrfTokens#')" /> 
    </cfif>
     <input type=hidden name="changesetID" value="#rc.changeset.getchangesetID()#">
  </cfif>
  <input type="hidden" name="action" value="">
  #rc.$.renderCSRFTokens(context=rc.changeset.getchangesetID(),format="form")#
</div>
</form>
</cfoutput>
