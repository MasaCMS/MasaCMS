<cfset request.layout=false>
<cfset currentChangeset=application.changesetManager.read(rc.changesetID)>
<cfset changesets=application.changesetManager.getIterator(siteID=rc.siteID,published=0,publishdate=now(),publishDateOnly=false)>
<cfoutput>
<table class="stripe">
<tr>
<th>&nbsp;</th>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"changesets.name")#</th>
</tr>
<cfif changesets.hasNext()>
<cfloop condition="changesets.hasNext()">
<cfset changeset=changesets.next()>
<tr>
<td><input name="_changesetID" type="radio" onclick="removeChangesetPrompt(this.value);" value="#changeset.getChangesetID()#"<cfif changeset.getChangesetID() eq rc.changesetid> checked="true"</cfif>/></td>
<td class="varWidth">#HTMLEditFormat(changeset.getName())#</td>
</tr>
</cfloop>
<!---<cfif not currentChangeset.getIsNew()>--->
<tr>
<td><input name="_changesetID" type="radio" onclick="removeChangesetPrompt(this.value);" value=""<cfif not len(rc.changesetID)> checked="true"</cfif>/></td>
<td class="varWidth">#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.none"))#</td>
</tr>
<!---</cfif>--->
<cfelse>
<tr>
<td colspan="2">#application.rbFactory.getKeyValue(session.rb,'changesets.nochangesets')#</td>
</tr>
</cfif>
</table>
<div style="display:none" id="removeChangesetContainer">
<input type="checkbox" id="_removePreviousChangeset" value="true"/>&nbsp;#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.removechangeset"),'<em>"#HTMLEditFormat(currentChangeset.getName())#"</em>')#
</div>
</cfoutput>