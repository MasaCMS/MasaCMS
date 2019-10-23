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
<cfset request.layout=false>
<cfparam name="rc.keywords" default="">
<cfparam name="rc.isNew" default="1">
<cfset counter=0 />
<cfset hasParentID=false />
<cfoutput>
<div class="form-inline">
<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforcontent')#</h2>
<div class="mura-input-set">
	<input id="parentSearch" name="parentSearch" value="" type="text" class="text" maxlength="50" onclick="return false;">
	<input id="parentSearchSubmit" type="button" class="btn" onclick="siteManager.loadSiteParents('#rc.siteid#','#rc.contentid#','#rc.parentid#',document.getElementById('parentSearch').value,0);return false;" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.search')#">
</div>
</cfoutput>
</div>
<cfif not rc.isNew>
<cfset parentBean=application.serviceFactory.getBean("content").loadBy(contentID=rc.parentID,siteID=rc.siteID)>
<cfset rc.rsList=application.contentManager.getPrivateSearch(siteid=rc.siteid,keywords=rc.keywords,moduleid=parentBean.getModuleID())/>
<cfif not parentBean.getIsNew()>
<cfset parentCrumb=application.contentManager.getCrumbList(rc.parentid, rc.siteid)/>
</cfif>
 <table class="mura-table-grid">
  <cfif not parentBean.getIsNew()>
		<tr>
		  <th class="actions"></th>
	    <th class="var-width"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewcontentparent')#</cfoutput></th>
    </tr>
	</cfif>
	<cfif rc.rslist.recordcount or listFind('00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000099',parentBean.getModuleID())>
		<cfif not parentBean.getIsNew() and not listFind('00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000099',rc.parentid)>
			<tr class="alt"><cfoutput>
				<td class="actions"><input type="radio" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#" checked="checked"></td>
				 <td class="var-width">#$.dspZoomNoLinks(parentCrumb)#</td>
			</tr></cfoutput>
			<cfset hasParentID=true />
		</cfif>
		<cfif listFind('00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000099',parentBean.getModuleID())>
			<cfset rstop=application.serviceFactory.getBean('contentGateway').getTop(siteid=rc.siteid,topid=parentBean.getModuleID())>
			<cfif reFindNoCase(rc.keywords,rstop.title)>
				<tr class="alt"><cfoutput>
					<td class="actions"><input type="radio" name="parentid" value="#esapiEncode('html_attr',parentBean.getModuleID())#" <cfif rc.parentid eq parentBean.getModuleID()>checked="checked"</cfif>></td>
					 <td class="var-width"><ul class="navZoom"><li class="mi-cog "> #esapiEncode('html',rstop.title)#</li></ul></td>
				</tr></cfoutput>
				<cfset hasParentID=true />
				<cfset counter=counter+1/>
			</cfif>
		</cfif>
    	<cfoutput query="rc.rslist" startrow="1" maxrows="150">
				<cfif rc.rslist.contentid neq rc.parentid>
					<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid)/>
			    <cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
					<cfif verdict neq 'none' and arrayLen(crumbdata) and structKeyExists(crumbdata[1],"parentArray") and not listFind(arraytolist(crumbdata[1].parentArray),rc.contentid)>
						<cfset counter=counter+1/>
						<cfset hasParentID=true />
						<tr <cfif not(counter mod 2)>class="alt"</cfif>>
						  <td class="actions"><input type="radio" name="parentid" value="#rc.rslist.contentid#"></td>
			        <td class="var-width">#$.dspZoomNoLinks(crumbdata)#</td>
						</tr>
				 	</cfif>
				</cfif>
      </cfoutput>
	 	</cfif>
	 	<cfif not counter>
			<tr class="alt"><cfoutput>
			  <td class="noResults" colspan="2">#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#<!---<input type="hidden" id="parentid" name="parentid" value="#rc.parentid#" />---> </td>
			</tr></cfoutput>
		</cfif>
  </table>
</td></tr></table>
<cfif not hasParentID>
	<cfoutput><input type="hidden" id="parentid" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#" /></cfoutput>
</cfif>
<cfelse>
<cfoutput><input type="hidden" id="parentid" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#" /></cfoutput>
</cfif>

<script type="text/javascript">
	$(document).ready(function(){	
		$('#parentSearch').on('keypress',function(e){
			if(e.which == 13) {
				var pval = $(this).val();
				$('#parentSearchSubmit').trigger('click');
				setTimeout(function(){						
				$('#parentSearch').focus();	
				},'250')	
				return false;
		  	}
		})
	})
</script>