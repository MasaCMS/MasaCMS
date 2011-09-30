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
<h2>#application.rbFactory.getKeyValue(session.rb,"changesets")#</h2>

<ul id="navTask"><li><a  title="#application.rbFactory.getKeyValue(session.rb,'changesets.addchangeset')#" href="index.cfm?fuseaction=cChangesets.edit&changesetID=&siteid=#URLEncodedFormat(rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'changesets.addchangeset')#</a></li></ul>

<!--- <h3>#application.rbFactory.getKeyValue(session.rb,'changesets.filterview')#:</h3> --->
<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'changesets.filterviewnotice')#</h3>

<form novalidate="novalidate" id="changesetSearch" name="changesetSearch" method="get">
	<input name="keywords" value="#HTMLEditFormat(rc.keywords)#" type="text" class="text" maxlength="50" />
	<input type="button" class="submit" onclick="submitForm(document.forms.changesetSearch);" value="Search" />
	<input type="hidden" name="fuseaction" value="cChangesets.list">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
</form>

<table class="mura-table-grid stripe"> 
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'changesets.name')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'changesets.datetopublish')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'changesets.lastupdate')#</th>
<th>&nbsp;</th>
</tr>
<cfif rc.changesets.hasNext()>
<cfloop condition="rc.changesets.hasNext()">
<cfset rc.changeset=rc.changesets.next()>
<tr>
	<td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cChangesets.edit&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.siteID)#">#HTMLEditFormat(rc.changeset.getName())#</a></td>
	<td><cfif isDate(rc.changeset.getPublishDate())>#LSDateFormat(rc.changeset.getPublishDate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getPublishDate(),"medium")#<cfelse>NA</cfif></td>
	<td>#LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"medium")#</td>
	<td class="administration">
		<ul class="four">
			<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.edit')#" href="index.cfm?fuseaction=cChangesets.edit&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#">#application.rbFactory.getKeyValue(session.rb,'changesets.edit')#</a></li>
			<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.preview')#" href="javascript:preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?changesetID=#JSStringFormat(rc.changeset.getChangesetID())#','');">#application.rbFactory.getKeyValue(session.rb,'changesets.preview')#</a></li>
			<li class="changeSets"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.assignments')#" href="index.cfm?fuseaction=cChangesets.assignments&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#">#application.rbFactory.getKeyValue(session.rb,'changesets.assignments')#</a></li>
			<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#" href="index.cfm?fuseaction=cChangesets.delete&changesetID=#rc.changeset.getchangesetID()#&siteid=#URLEncodedFormat(rc.changeset.getSiteID())#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'changesets.deleteconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#</a></li>
		</ul>
	</td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="4">#application.rbFactory.getKeyValue(session.rb,'changesets.nochangesets')#</td>
</tr>
</cfif>
</table>

<cfif rc.changesets.pageCount() gt 1> 
<p class="moreResults">#application.rbFactory.getKeyValue(session.rb,'changesets.moreresults')#:
<cfif rc.changesets.getPageIndex() gt 1>
<a href="index.cfm?fuseaction=cChangesets.list&page=#evaluate('#rc.changesets.getPageIndex()#-1')#&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.prev')#</a> 
</cfif>
<cfloop from="1"  to="#rc.changesets.pageCount()#" index="i"><cfif rc.changesets.getPageIndex() eq i> <strong>#i#</strong> <cfelse> <a href="index.cfm?fuseaction=cChangesets.list&page=#i#&siteid=#URLEncodedFormat(rc.siteid)#keywords=#URLEncodedFormat(rc.keywords)#">#i#</a></cfif></cfloop>
<cfif rc.changesets.getPageIndex() lt rc.changesets.pagecount()>
<a href="index.cfm?fuseaction=cChangesets.list&page=#evaluate('#rc.changesets.getPageIndex()#+1')#&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.next')#</a> 
</cfif>
</p>
</cfif>
</cfoutput>