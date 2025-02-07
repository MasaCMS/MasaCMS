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
<cfset rsUsage=application.contentGateway.getUsage(rc.contentID,session.siteid)>
<cfset tabList=listAppend(tabList,"tabUsagereport")>
<cfoutput>
<div class="mura-panel panel">
  <div class="mura-panel-heading" role="tab" id="heading-usagereport">
    <h4 class="mura-panel-title">
      <a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-usagereport" aria-expanded="false" aria-controls="panel-usagereport">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.usagereport")#</a>
    </h4>
  </div>
    <div id="panel-usagereport" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-usagereport" aria-expanded="false" style="height: 0px;">
      <div class="mura-panel-body">
    <span id="extendset-container-tabusagereporttop" class="extendset-container"></span>

    <div class="mura-control-group">


      <div id="usage__totals"></div>
      <!--- 'big ui' flyout panel --->
      <!--- todo: resource bundle key for 'see usage details' --->
      <div class="bigui" id="bigui__usage" data-label="<cfif rsUsage.recordcount>See Usage Details</cfif>">
        <div class="bigui__title">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.usagereport")#</div>
        <div class="bigui__controls">

          <div class="mura-control-group">
          <cfif rsUsage.recordcount>
              <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.usagedescription')#:</label>
              <table class="mura-table-grid" id="table__usage__report">
              <tr>
                <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#</th>
                <th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#</th>
                <th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.update')#</th>
                <th class="actions">&nbsp;</th>
              </tr>
               <cfloop query="rsUsage">
          		<cfset crumbdata=application.contentManager.getCrumbList(rsUsage.contentid, rc.siteid)/>
          		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
                  <tr>
                  <td class="var-width">#$.dspZoom(crumbdata)#</td>
          		<td>
          	    <cfif rsUsage.Display and (rsUsage.Display eq 1 and rsUsage.approved)>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#<cfelseif (rsUsage.Display eq 2 and rsUsage.approved)>#LSDateFormat(rsUsage.displaystart,session.dateKeyFormat)# - #LSDateFormat(rsUsage.displaystop,session.dateKeyFormat)#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</cfif></td>
          		<td>#LSDateFormat(rsUsage.lastupdate,session.dateKeyFormat)#</td>
                  <td nowrap class="actions"><ul><cfif verdict neq 'none'><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.edit')#" href="./?muraAction=cArch.edit&contenthistid=#rsUsage.ContentHistID#&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#"><i class="mi-pencil"></i></a></li><li class="version-history"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="./?muraAction=cArch.hist&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#"><i class="mi-history"></i></a></li><cfelse><li class="edit disabled">#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#</li><li class="version-history disabled">#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#</li></cfif></ul></td>
                  </tr>
              </cfloop>
             </table>
           <cfelse>
               <div class="help-block-empty">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.nousage'),lcase(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.contentBean.getType()#')))#</div>
          </cfif>

          </div> <!--- / .mura-control-group --->


        </div>
      </div> <!--- /.bigui --->
    </div> <!--- /.mura-control-group --->

    <span id="extendset-container-usagereport" class="extendset-usagereport"></span>
    <span id="extendset-container-tabusagereportbottom" class="extendset-container"></span>

    </div>
  </div>
</div> 
</cfoutput>

<script type="text/javascript">
  var showUsageTotal = function(){
    var usageStr = 'Not used';
    var usageTotal = <cfoutput>#rsUsage.recordcount#</cfoutput>;
    if (usageTotal == 1){
      usageStr = "Used in 1 location";
    } else if (usageTotal > 1) {
      usageStr = "Used in " + usageTotal + " locations";
    }
    $('#usage__totals').html(usageStr);
  }

  showUsageTotal();
</script> 