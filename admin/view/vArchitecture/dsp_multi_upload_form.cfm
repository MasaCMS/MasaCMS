<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsavecontent variable="str"><cfoutput>
<link href="#application.configBean.getContext()#/admin/js/fileuploader/fileuploader.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css">
<script src="#application.configBean.getContext()#/admin/js/fileuploader/fileuploader.js?coreversion=#application.coreversion#s" type="text/javascript"></script>	
#session.dateKey#
</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#str#">
<cfset attributes.type="File">
<cfsilent>
<cfset request.perm=application.permUtility.getnodePerm(request.crumbdata)>

<cfset fileExt=''/>

</cfsilent>

<!--- check to see if the site has reached it's maximum amount of pages --->
<cfif (request.rsPageCount.counter lt application.settingsManager.getSite(attributes.siteid).getpagelimit() and  attributes.contentid eq '') or attributes.contentid neq ''>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.mullifileupload")#</h2>
<cfif attributes.compactDisplay neq "true">
#application.contentRenderer.dspZoom(request.crumbdata,fileExt)#
</cfif>

<p>
Please select images to upload. You may select multiple, and they will begin 
as soon as you click Ok on the Open Dialog box.
</p>

<div id="newfile">
<noscript>
<p>Please enable JavaScript to use file uploader.</p>
<!-- or put a simple form for upload here -->
</noscript>
</div>
    <script>
       jQuery(document).ready(function(){
            var uploader = new qq.FileUploader({
                element: document.getElementById('newfile'),
                action: '#application.configBean.getContext()#/admin/index.cfm',
                debug: true,
                allowedExtensions: ["png","jpg","gif","jpeg"],
				params:{
							fuseaction:'cArch.update',
							action:'multiFileUpload',
							siteid:'#jsStringFormat(attributes.siteid)#',
							moduleid:'#jsStringFormat(attributes.moduleid)#',
							topid:'#jsStringFormat(attributes.topid)#',
							ptype:'#jsStringFormat(attributes.ptype)#',
							parentid:'#jsStringFormat(attributes.parentid)#',
							contentid:'',
							type:'File',
							subtype:'Default',
							startrow:#attributes.startrow#,
							orderno:0,
							approved:<cfif request.perm eq "editor">1<cfelse>0</cfif>
									
						}
            });
        });
        
    </script> 
</cfoutput>
<cfelse>
<div>
<cfinclude template="form/dsp_full.cfm">
</div>
</cfif>