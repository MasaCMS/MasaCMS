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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfset request.layout=false>
<cfparam name="rc.keywords" default="">
<cfparam name="rc.isNew" default="1">
<cfset counter=0 />
<cfoutput>
<a onclick="jQuery('##selectAssocImageReInit > input').attr('name','fileid');jQuery('##selectAssocImage').html(jQuery('##selectAssocImageReInit').html());jQuery('##selectAssocImageReInit > input').attr('name','fileidReInit');">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforassocimagecancel')#]</a>
<br/><br/>
<cfif rc.isNew>
<div style="display:none" id="selectAssocImageResults">
</cfif>
<dl>
<dt><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforassocimage')#<span>#application.rbFactory.getKeyValue(session.rb,'tooltip.searchforassocimage')#</span></a></dt>
<dd><input id="imageSearch" name="imageSearch" value="#HTMLEditFormat(rc.keywords)#" type="text" class="text" maxlength="50"/><a class="submit" href="javascript:;" onclick="loadAssocImages('#rc.siteid#','#htmlEditFormat(rc.fileid)#','#htmlEditFormat(rc.contentid)#',document.getElementById('imageSearch').value,0);return false;"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.search')#</span></a></dd>
</dl>
<cfif rc.isNew>
</div>
</cfif>
</cfoutput>
<cfif not rc.isNew>
<div style="display:none; overflow: auto;" id="selectAssocImageResults">
<cfset request.rsList=application.contentManager.getPrivateSearch(rc.siteid,rc.keywords,'','','image')/>
<!---<cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#</cfoutput>--->
<table>
<tr>
    <cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" startrow="1" maxrows="100">
		<cfsilent>
			<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, rc.siteid)/>
       		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
		</cfsilent>
		<cfif verdict neq 'none'>
			<cfset counter=counter+1/> 
	        <td><img src="#application.configBean.getContext()#/tasks/render/small/?fileID=#request.rslist.fileid#"><input type="radio" name="fileid" value="#request.rslist.fileid#"></td>
	 	</cfif>
      </cfoutput>
	 </cfif>
	 <cfif not counter>
		<cfoutput>
		<td>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</td>
		</cfoutput>
	</cfif>
</td>
</table>
</div>
<cfelse>
<cfoutput><input type="hidden" name="fileid" value="#htmlEditFormat(rc.fileid)#" /></cfoutput>
</cfif>