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
<h2><cfif rc.changesetID neq ''>#application.rbFactory.getKeyValue(session.rb,'changesets.editchangeset')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'changesets.addchangeset')#</cfif></h2>
#application.utility.displayErrors(rc.changeset.getErrors())#

<ul id="navTask">
<li><a  title="#application.rbFactory.getKeyValue(session.rb,'changesets.backtochangesets')#" href="index.cfm?fuseaction=cChangesets.list&siteid=#URLEncodedFormat(rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'changesets.backtochangesets')#</a></li>
<cfif not rc.changeset.getIsNew()>
<li><a  title="#application.rbFactory.getKeyValue(session.rb,'changesets.viewassignments')#" href="index.cfm?fuseaction=cChangesets.assignments&siteid=#URLEncodedFormat(rc.siteid)#&changesetID=#rc.changeset.getChangesetID()#">#application.rbFactory.getKeyValue(session.rb,'changesets.viewassignments')#</a></li>
</cfif>
</ul>

<cfif rc.changeset.getPublished()>
<p class="notice">
#application.rbFactory.getKeyValue(session.rb,'changesets.publishednotice')#
</p>
</cfif>

<span id="msg">
#application.pluginManager.renderEvent("onChangesetEditMessageRender", request.event)#
</span>

<form novalidate="novalidate" action="index.cfm?fuseaction=cChangesets.save&siteid=#URLEncodedFormat(rc.siteid)#" method="post" name="form1" onsubmit="return validate(this);">
<dl class="oneColumn">
<dt class="first separate">#application.rbFactory.getKeyValue(session.rb,'changesets.name')#</dt>
<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'changesets.titlerequired')#" value="#HTMLEditFormat(rc.changeset.getName())#" maxlength="50"></dd>
<dt class="divide">#application.rbFactory.getKeyValue(session.rb,'changesets.description')#</dt>
<dd><textarea name="description">#HTMLEditFormat(rc.changeset.getDescription())#</textarea></dd>
<dt class="divide"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'changesets.publishdate')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.changesetpublishdate")#</span></a></dt>
<dd><cfif rc.changeset.getPublished()>
	#LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"medium")#
	<cfelse>
	<input type="text" name="publishDate" value="#LSDateFormat(rc.changeset.getpublishdate(),session.dateKeyFormat)#"  maxlength="12" class="textAlt datepicker" /><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=publishDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
	<select name="publishhour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.changeset.getpublishDate())  and h eq 12 or (LSisDate(rc.changeset.getpublishDate()) and (hour(rc.changeset.getpublishDate()) eq h or (hour(rc.changeset.getpublishDate()) - 12) eq h or hour(rc.changeset.getpublishDate()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
	<select name="publishMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.changeset.getpublishDate()) and minute(rc.changeset.getpublishDate()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
	<select name="publishDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.changeset.getpublishDate()) and hour(rc.changeset.getpublishDate()) gte 12>selected</cfif>>PM</option></select>
	</cfif>
</dd>
</dl>

<cfif rc.changesetID eq ''>
<div id="actionButtons">
<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.add')#" /><input type=hidden name="changesetID" value="">
<cfelse>
<input type="button" class="submit" value="#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#" onclick="confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'changesets.deleteconfirm'))#','index.cfm?fuseaction=cChangesets.delete&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#')" /> 
<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.update')#" />
<cfif not rc.changeset.getPublished()>
<input type="button" class="submit" value="#application.rbFactory.getKeyValue(session.rb,'changesets.publishnow')#" onclick="confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'changesets.publishnowconfirm'))#','index.cfm?fuseaction=cChangesets.publish&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#')" /> 
</cfif>
<input type=hidden name="changesetID" value="#rc.changeset.getchangesetID()#">
</cfif><input type="hidden" name="action" value="">
</div>
</form>
</cfoutput>

