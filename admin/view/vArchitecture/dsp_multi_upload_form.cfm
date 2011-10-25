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
<cfsavecontent variable="str"><cfoutput>
<link href="#application.configBean.getContext()#/admin/js/fileuploader/fileuploader.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css">
<!---<script src="#application.configBean.getContext()#/admin/js/fileuploader/fileuploader.js?coreversion=#application.coreversion#s" type="text/javascript"></script>--->
<script src="#application.configBean.getContext()#/admin/js/fileuploader/ajaxupload.js?coreversion=#application.coreversion#s" type="text/javascript"></script>		
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
Please select one image at a time to upload. Uploading will begin as soon as you click Ok on the Open Dialog box.
</p>
<!---
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
--->


<script type="text/javascript">/*<![CDATA[*/
jQuery(document).ready(function(){
	new AjaxUpload('uploadbutton', {
            action: './index.cfm',
            multiple: false,
            name:'newfile1',
			data:{
				'fuseaction':'cArch.update',
				'action':'multiFileUpload',
				'siteid':'#jsStringFormat(attributes.siteid)#',
				'moduleid':'#jsStringFormat(attributes.moduleid)#',
				'topid':'#jsStringFormat(attributes.topid)#',
				'ptype':'#jsStringFormat(attributes.ptype)#',
				'parentid':'#jsStringFormat(attributes.parentid)#',
				'contentid':'',
				'type':'File',
				'subtype':'Default',
				'startrow':#attributes.startrow#,
				'orderno':0,
				'approved':<cfif request.perm eq "editor">1<cfelse>0</cfif>
			},
			onSubmit : function(file , ext){
			                // Allow only images. You should add security check on the server-side.
			if (ext && /^(jpg|png|jpeg|gif|JPG|PNG|JPEG|GIF|Jpg|Png|Jpeg|Gif)$/i.test(ext)){
				jQuery('<li><img src="#application.configBean.getContext()#/admin/images/progress_bar.gif"></li>').appendTo('##uploader .files');	
			} else {
			// extension is not allowed
				alertDialog('Error: only jpg, png, or gif images are allowed');
				// cancel upload
				return false;
			}
			},
			onComplete : function(file){
				jQuery('.files li:last').html(file);	
			}
		});

});/*]]>*/
</script>
<div id="uploader">
<p><input type="button" class="submit" id="uploadbutton" value="Upload Image" /></p>
<ol class="files"></ol>
</div>
</cfoutput>
<cfelse>
<div>
<cfinclude template="form/dsp_full.cfm">
</div>
</cfif>