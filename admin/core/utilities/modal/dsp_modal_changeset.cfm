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
<cfset previewData=$.currentUser("ChangesetPreviewData")>
<cfoutput>
	<link href="#$.globalConfig('context')#/admin/assets/css/changeset.css" rel="stylesheet" type="text/css" media="all" />
	
	<!--[if LTE IE 8]>
	
	<style>
	##m-changesets {
	background: transparent;
	-ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=##F2AAAAAA,endColorstr=##F2AAAAAA)"; /* IE8 */
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=##F2AAAAAA,endColorstr=##F2AAAAAA);   /* IE6 & 7 */
    zoom: 1;
	}

	##m-changesets h1 {
	color: ##fff;
	background: transparent;
	-ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=##4C000000,endColorstr=##4C000000)"; /* IE8 */
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=##4C000000,endColorstr=##4C000000);   /* IE6 & 7 */
      zoom: 1;
	}

	##m-changesets ##m-cs-utility li a {
	line-height: 12px;
	padding: 0 0 0 10px;
	background: transparent;
	color: ##fff;
	}
	
	##m-changesets ##m-cs-utility li a:hover {
	text-decoration: underline;
	background: transparent;
	}

	##m-changesets dt { color: rgb(0,0,0); }
	##m-changesets dd { color: rgb(0,0,0); }
	</style>
	
	<![endif]-->
	
	<!--[if IE 8]>
	<style>
	##m-changesets h1 {
	color: ##fff;
	background-color: rgb(100,100,100);
	}
	</style>
	<![endif]-->
	
	
	<!--[if IE 7]>
	<style>
	##m-changesets ##m-cs-status dd {
	max-width: 85%;
	}
	</style>
	<![endif]-->
	
	<!--[if IE 6]>
	<script src="#$.globalConfig('context')#/admin/assets/js/DD_belatedPNG.js"></script>
	<script>
	  DD_belatedPNG.fix('##m-changesets dl,##m-cs-status ##m-cs-included,##m-cs-status ##m-cs-other');
	</script>
	<style>
	##m-changesets {
	position: absolute;
	padding-bottom: 0;
	background: ##ccc;
	}
	
	##m-changesets h1 {
	background: ##666;
	}
	
	##m-changesets ##m-cs-utility {
	width: 273px;
	padding: 0;
	height: 12px;
	line-height: 1;
	background: transparent;
	top: 0px;
	}
	
	##m-changesets ##m-cs-utility li {
	width: 130px;
	line-height: 12px;
	}
	
	##m-changesets dl {
	height: 50px;
	}
	
	</style>
	<![endif]-->
	<script type="text/javascript" src="#$.globalConfig('context')#/admin/assets/js/jquery/jquery.equalheights.js"></script>
	
	<script>
	$(document).ready(function() {
	$("##m-changesets dl").equalHeights();
	});
	</script>
	
	<div id="m-changesets">
	<h1>Change Sets</h1>
	
	<dl id="m-cs-changeset">
		<dt>#application.rbFactory.getKeyValue(session.rb,'changesets.previewchangeset')#</dt>
		<dd>
		<cfset rsChangesets=application.changesetManager.getQuery(siteID=$.event('siteID'),published=0,sortby="PublishDate")>
		<select id="changesetSelector" onchange="location.href='?changesetID=' + this.value">
		<cfloop query="rsChangesets">
		<option value="#rsChangesets.changesetID#"<cfif previewdata.changesetID eq rsChangesets.changesetID> selected="true"</cfif>>#HTMLEditFormat(rsChangesets.name)#<cfif isDate(rsChangesets.publishDate)> (#LSDateFormat(rsChangesets.publishDate,session.dateKeyFormat)#)</cfif></option>
		</cfloop>
		</select>
		</dd>
	</dl>
	
	<cfset changesetMembers=application.changesetManager.getAssignmentsIterator(changesetID=previewData.changesetID,moduleID='00000000000000000000000000000000000')>
	<dl id="m-cs-assignments">
		<dt>Items in Change Set</dt>
		<dd>
			<select id="changesetMemberSelector" onchange="location.href=this.value">
				<option>Change Set Assignments</option>
				<cfloop condition="changesetMembers.hasNext()">
				<cfset changesetMember=changesetMembers.next()>
				<option value="#HTMLEditFormat(changesetMember.getURL())#">#HTMLEditFormat(changesetMember.getMenuTitle())#</option>
				</cfloop>
			</select>
		</dd>
	</dl>
	<dl id="m-cs-status">
		<dt>Item Status</dt>
		<cfif structKeyExists(previewData.previewmap,$.content("contentID")) >
			<cfif previewData.previewmap[$.content("contentID")].changesetID eq previewData.changesetID>
			<dd id="m-cs-included">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"changesets.previewnodemembership"),'<strong>"#HTMLEDitFormat(previewData.previewmap[$.content("contentID")].changesetName)#"</strong>')#</dd>
			<cfelse>
			<dd id="m-cs-other">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"changesets.previewnodemembership"),'<strong>"#HTMLEDitFormat(previewData.previewmap[$.content("contentID")].changesetName)#"</strong>')#</dd>
			</cfif>
		<cfelse>
			<dd id="m-cs-none">#application.rbFactory.getKeyValue(session.rb,"changesets.previewnodenotinchangeset")#</dd>
		</cfif>
	</dl>	

	<cfif previewData.prereqs.recordcount>
	<dl id="m-cs-dependencies">
		<dt>#application.rbFactory.getKeyValue(session.rb,'changesets.previewdependencies')#</dt>
		<dd><cfloop query="previewData.prereqs">#HTMLEditFormat(previewData.prereqs.name)# (#LSDateFormat(previewData.prereqs.publishDate,session.dateKeyFormat)#)<cfif previewData.prereqs.currentrow lt previewData.prereqs.recordcount>, </cfif> </cfloop></dd>
	</dl>
	</cfif>
	
	<ul id="m-cs-utility">
		<li id="m-cs-refresh"><a href="?changesetID=#previewdata.changesetID#">Refresh Change Sets</a></li>
		<li id="m-cs-exit"><a href="?changesetID=">Exit Change Set Preview</a>
	</ul>
		
	</div>
</cfoutput>