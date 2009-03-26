<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.isNew" default="1">
<cfset counter=0 />
<cfoutput>
<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforcontent')#</h3>
	<input id="parentSearch" name="parentSearch" value="#attributes.keywords#" type="text" class="text" maxlength="50"/><a class="submit" href="javascript:;" onclick="loadRelatedContent('#attributes.siteid#',document.getElementById('parentSearch').value,0);return false;"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.search')#</span></a>
</cfoutput>
<br/><br/><cfif not attributes.isNew>
<cfset request.rsList=application.contentManager.getPrivateSearch(attributes.siteid,attributes.keywords)/>
 <table class="stripe">
    <tr> 
      <th class="varWidth"><cfoutput><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addrelatedcontent')#<span>#application.rbFactory.getKeyValue(session.rb,'tooltip.addRelatedContent')#</span></a></cfoutput></th>
	  <th class="administration">&nbsp;</th>
    </tr><cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" startrow="1" maxrows="100">	
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <cfif not listFind(arraytolist(crumbdata[1].parentArray),attributes.contentid)>
		<cfset counter=counter+1/>
		<tr <cfif not(counter mod 2)>class="alt"</cfif>>  
          <td class="varWidth">#application.contentRenderer.dspZoomNoLinks(crumbdata,request.rslist.fileExt)#</td>
		  <td class="administration"><ul class="one"><li class="add"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')#" href="javascript:;" onClick="addRelatedContent('#request.rslist.contentid#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#request.rslist.type#')#','#JSStringFormat(request.rslist.menuTitle)#'); return false;">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')#</a></li></ul>
		  </td>
		</tr>
	 	</cfif>
       </cfoutput>
	 	<cfelse>
		<tr class="alt"><cfoutput>  
		  <td class="noResults" colspan="2">#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</td>
		</tr></cfoutput>
		</cfif>
  </table>
</td></tr></table>
</cfif>