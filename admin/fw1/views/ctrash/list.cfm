<cfsavecontent variable="rc.layout">
<cfparam name="rc.keywords" default="">
<cfoutput>
<h2>Trash Bin</h2>

<ul id="navTask"
<li><a href="index.cfm?fuseaction=cSettings.editSite&siteID=#URLEncodedFormat(rc.siteID)#">Back to Site</a></li>
<li><a href="index.cfm?fuseaction=cTrash.empty&siteID=#URLEncodedFormat(rc.siteID)#" onclick="return confirmDialog('Empty Site Trash?', this.href);">Empty Trash</a></li>
</ul>

<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
   <h3>Keyword Search</h3>
    <input name="keywords" value="#HTMLEditFormat(rc.keywords)#" type="text" class="text" align="absmiddle" />
    <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>Search</span></a>
    <input type="hidden" name="fuseaction" value="cTrash.list">
    <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
 </form>

<table class="stripe"> 
<tr>
<th class="varWidth">Label</th>
<th>Type</th>
<th>SubType</th>
<th>SiteID</th>
<th>Date Deleted</th>
<th>Date By</th>
<th class="administration">&nbsp;</th>
</tr>
<cfset rc.trashIterator.setPage(rc.pageNum)>
<cfif rc.trashIterator.hasNext()>
<cfloop condition="rc.trashIterator.hasNext()">
<cfset trashItem=rc.trashIterator.next()>
<tr>
<td class="varWidth"><a href="?fuseaction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#URLEncodedFormat(rc.pageNum)#">#htmlEditFormat(left(trashItem.getObjectLabel(),80))#</a></td>
<td>#htmlEditFormat(trashItem.getObjectType())#</td>
<td>#htmlEditFormat(trashItem.getObjectSubType())#</td>
<td>#htmlEditFormat(trashItem.getSiteID())#</td>
<td>#LSDateFormat(trashItem.getDeletedDate(),session.dateKeyFormat)# #LSTimeFormat(trashItem.getDeletedDate(),"short")#</td>
<td>#htmlEditFormat(trashItem.getDeletedBy())#</td>
<td class="administration"><ul><li class="edit"><a href="?fuseaction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#URLEncodedFormat(rc.pageNum)#">View Detail</a></li></ul></td>
</tr>
</cfloop>
<cfelse>
<tr><td colspan="7">The trash is currently empty.</tr>
</cfif>
</table>

<cfif rc.trashIterator.pageCount() gt 1>
<p class="moreResults">More Results: 
<cfif rc.pageNum gt 1>
	<a href="?fuseaction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#evaluate('rc.pageNum-1')#">&laquo;&nbsp;Previous</a> 
</cfif>
<cfloop from="1"  to="#rc.trashIterator.pageCount()#" index="i">
	<cfif rc.pageNum eq i>
		<strong>#i#</strong>
	<cfelse>
		<a href="?fuseaction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#i#">#i#</a> 
	</cfif>
</cfloop>
<cfif rc.pageNum lt rc.trashIterator.pageCount()>
	<a href="?fuseaction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#evaluate('rc.pageNum+1')#">Next&nbsp;&raquo;</a> 
</cfif> 
</p>
</cfif>

</cfoutput>
</cfsavecontent>
