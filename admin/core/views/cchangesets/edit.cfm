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

<cfinclude template="dsp_secondary_menu.cfm">

#application.utility.displayErrors(rc.changeset.getErrors())#



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

<form class="fieldset-wrap" novalidate="novalidate" action="./?muraAction=cChangesets.save&siteid=#URLEncodedFormat(rc.siteid)#" method="post" name="form1" onsubmit="return validate(this);">
<div class="fieldset">
<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'changesets.name')#
  </label>
  <div class="controls">
  <input name="name" type="text" class="span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'changesets.titlerequired')#" value="#HTMLEditFormat(rc.changeset.getName())#" maxlength="50">
   </div>
</div>

<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'changesets.description')#
  </label>
  <div class="controls">
  <textarea name="description" class="span12" rows="6">#HTMLEditFormat(rc.changeset.getDescription())#</textarea>
  </div>
</div>

<div class="control-group">
  <label class="control-label">
    <a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.changesetclosedate"))#">#application.rbFactory.getKeyValue(session.rb,'changesets.closedate')# <i class="icon-question-sign"></i></a>
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
       <!---
      <input type="text" name="closeDate" value="#LSDateFormat(rc.changeset.getCloseDate(),session.dateKeyFormat)#"  maxlength="12" class="textAlt datepicker" />

       <cf_timeselector name="close" time="#rc.changeset.getCloseDate()#" defaulthour="23" defaultminute="59">

     
      <cfif session.localeHasDayParts>
        <select name="closehour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.changeset.getCloseDate())  and h eq 12 or (LSisDate(rc.changeset.getCloseDate()) and (hour(rc.changeset.getCloseDate()) eq h or (hour(rc.changeset.getCloseDate()) - 12) eq h or hour(rc.changeset.getCloseDate()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
      <cfelse>
        <select name="closeHour" class="time"><cfloop from="0" to="23" index="h"><option value="#h#" <cfif LSisDate(rc.changeset.getCloseDate())  and hour(rc.changeset.getCloseDate()) eq h >selected</cfif>>#h#</option></cfloop></select>
      </cfif>

      <select name="closeMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.changeset.getCloseDate()) and minute(rc.changeset.getCloseDate()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>

      <cfif session.localeHasDayParts>
        <select name="closeDayPart" class="time"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.changeset.getCloseDate()) and hour(rc.changeset.getCloseDate()) gte 12>selected</cfif>>PM</option></select>
      </cfif>
      --->
  </cfif>
  </div>
</div>

<div class="control-group">
  <label class="control-label">
    <a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.changesetpublishdate"))#">#application.rbFactory.getKeyValue(session.rb,'changesets.publishdate')# <i class="icon-question-sign"></i></a>
    </label>
  <div class="controls">
    <cfif rc.changeset.getPublished()>
    #LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"medium")#
  <cfelse>
   
    <cf_datetimeselector name="publishDate" datetime="#rc.changeset.getpublishdate()#">
    <!---
    <input type="text" name="publishDate" value="#LSDateFormat(rc.changeset.getpublishdate(),session.dateKeyFormat)#"  maxlength="12" class="textAlt datepicker" />

    <cf_timeselector name="publish" time="#rc.changeset.getpublishdate()#">
  
    <cfif session.localeHasDayParts>
      <select name="publishhour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.changeset.getpublishDate())  and h eq 12 or (LSisDate(rc.changeset.getpublishDate()) and (hour(rc.changeset.getpublishDate()) eq h or (hour(rc.changeset.getpublishDate()) - 12) eq h or hour(rc.changeset.getpublishDate()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
    <cfelse>
       <select name="publishhour" class="time"><cfloop from="0" to="23" index="h"><option value="#h#" <cfif LSisDate(rc.changeset.getpublishDate())  and hour(rc.changeset.getpublishDate()) eq h >selected</cfif>>#h#</option></cfloop></select>
    </cfif>

   <select name="publishMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.changeset.getpublishDate()) and minute(rc.changeset.getpublishDate()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>

   <cfif session.localeHasDayParts>
     <select name="publishDayPart" class="time"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.changeset.getpublishDate()) and hour(rc.changeset.getpublishDate()) gte 12>selected</cfif>>PM</option></select>
    </cfif>  
  --->
  </cfif>

  </div>
</div>

</div>
<div class="form-actions">
  <cfif rc.changesetID eq ''>
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.add')#" /><input type=hidden name="changesetID" value="">
  <cfelse>
    <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#" onclick="confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'changesets.deleteconfirm'))#','./?muraAction=cChangesets.delete&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#')" /> 
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.update')#" />
    <cfif not rc.changeset.getPublished() and not hasPendingApprovals>
      <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.publishnow')#" onclick="confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'changesets.publishnowconfirm'))#','./?muraAction=cChangesets.publish&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#')" /> 
    </cfif>
    <cfif rc.changeset.getPublished()>
        <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.rollback')#" onclick="confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'changesets.rollbackconfirm'))#','./?muraAction=cChangesets.rollback&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#')" /> 
    </cfif>
     <input type=hidden name="changesetID" value="#rc.changeset.getchangesetID()#">
  </cfif>
  <input type="hidden" name="action" value="">
</div>
</form>
</cfoutput>
