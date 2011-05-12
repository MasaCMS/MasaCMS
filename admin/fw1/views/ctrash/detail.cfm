<cfsavecontent variable="rc.ajax">
<cfoutput>
<script src="js/architecture.js?coreversion=#application.coreversion#" type="text/javascript" language="Javascript" ></script>
</cfoutput>
</cfsavecontent>
<cfsavecontent variable="rc.layout">
<cfoutput>
<h2>Trash Detail</h2>

<ul id="navTask"
<li><a href="index.cfm?fuseaction=cTrash.list&siteID=#URLEncodedFormat(rc.trashItem.getSiteID())#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#URLEncodedFormat(rc.pageNum)#">Back to Trash Bin</a></li>
</ul>

<ul class="metadata">
<li><strong>Label:</strong> #htmlEditFormat(rc.trashItem.getObjectLabel())#</li>
<li><strong>Type:</strong> #htmlEditFormat(rc.trashItem.getObjectType())#</li>
<li><strong>SubType:</strong> #htmlEditFormat(rc.trashItem.getObjectSubType())#</li>
<li><strong>ObjectID:</strong> #htmlEditFormat(rc.trashItem.getObjectID())#</li>
<li><strong>SiteID:</strong> #htmlEditFormat(rc.trashItem.getSiteID())#</li>
<li><strong>ParentID:</strong> #htmlEditFormat(rc.trashItem.getParentID())#</li>
<li><strong>Object Class:</strong> #htmlEditFormat(rc.trashItem.getObjectClass())#</li>
<li><strong>Deleted Date:</strong> #LSDateFormat(rc.trashItem.getDeletedDate(),session.dateKeyFormat)# #LSTimeFormat(rc.trashItem.getDeletedDate(),"short")#</li>
<li><strong>Deleted By:</strong> #htmlEditFormat(rc.trashItem.getDeletedBy())#</li>
</ul>

<cfif not listFindNoCase("Page,Portal,File,Link,Gallery,Calender",rc.trashItem.getObjectType())>
<div class="clearfix" id="actionButtons">
<a class="submit" href="?fuseaction=cTrash.restore&objectID=#rc.trashItem.getObjectID()#&siteid=#rc.trashItem.getSiteID()#" onclick="return confirmDialog('Restore Item From Trash?',this.href);">Restore Item</a>
</div>
<cfelse>
<cfset parentBean=application.serviceFactory.getBean("content").loadBy(contentID=rc.trashItem.getParentID(),siteID=rc.trashItem.getSiteID())>
<div id="selectNewParent">
<strong>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#</strong>:
	<span id="move" class="text"><cfif parentBean.getIsNew()>NA<cfelse>#htmlEditFormat(parentBean.getMenuTitle())#</cfif>
	&nbsp;&nbsp;<a href="javascript:##;" onclick="javascript: loadSiteParents('#rc.trashItem.getSiteID()#','#rc.trashItem.getObjectID()#','#rc.trashItem.getParentID()#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent')#]</a>
	<input type="hidden" id="parentid" name="parentid" value="#rc.trashItem.getParentID()#">
	</span>
</div>
<div class="clearfix" id="actionButtons">
<a class="submit" href="" onclick="restoreContent(); return false;"><span>Restore Item</span></a>
</div>

<script>
function restoreContent(){
	var parentid="";

	if(typeof(jQuery('##parentid').val()) != 'undefined' ){
		parentid=jQuery('##parentid').val();
	}else{
		parentid=jQuery('input:radio[name=parentid]:checked').val();
		
	}
	
	if(parentid.length==35){
		confirmDialog('Restore Item From Trash?',"?fuseaction=cTrash.restore&siteID=#rc.trashItem.getSiteID()#&objectID=#rc.trashItem.getObjectID()#&parentid=" + parentid);
	}else{
		alertDialog('Please select a valid content parent.');
	}
}
</script>

</cfif>
</cfoutput>
</cfsavecontent>