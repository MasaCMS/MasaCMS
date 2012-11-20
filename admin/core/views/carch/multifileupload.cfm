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
<cfinclude template="js.cfm">
<cfsavecontent variable="str"><cfoutput>
<link href="#application.configBean.getContext()#/admin/assets/css/jquery/jquery.fileupload-ui.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css">
#session.dateKey#
<cfif rc.compactDisplay eq "true">
<script type="text/javascript">
jQuery(document).ready(function(){
    if (top.location != self.location) {
        if(jQuery("##ProxyIFrame").length){
            jQuery("##ProxyIFrame").load(
                function(){
                    frontEndProxy.post({cmd:'setWidth',width:'standard'});
                }
            );  
        } else {
            frontEndProxy.post({cmd:'setWidth',width:'standard'});
        }
    }
});
</script>
</cfif> 
</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#str#">
<cfset rc.type="File">
<cfsilent>
<cfset rc.perm=application.permUtility.getnodePerm(rc.crumbdata)>

<cfset fileExt=''/>

</cfsilent>

<!--- check to see if the site has reached it's maximum amount of pages --->
<cfif (rc.rsPageCount.counter lt application.settingsManager.getSite(rc.siteid).getpagelimit() and  rc.contentid eq '') or rc.contentid neq ''>
<cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.multifileupload")#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<cfif rc.compactDisplay neq "true">
    #application.contentRenderer.dspZoom(crumbdata=rc.crumbdata,class="navZoom alt")#
</cfif>

    <!--- <h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.multifileuploadinstructions")#</h2> --->

    <!-- The file upload form used as target for the file upload widget -->
    <form id="fileupload" action="#application.configBean.getContext()#/admin/" method="POST" enctype="multipart/form-data">
    	<!-- Creating a visual target for files. Doesn't actually do anything. Pure eye candy. -->
    	<div id="fileupload-target" class="alert alert-info"><p><i class="icon-plus-sign"></i>Drag and drop files to upload.</p></div>
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
        <div class="fileupload-buttonbar">
            <div class="span7">
                <!-- The fileinput-button span is used to style the file input field as button -->
                <span class="btn fileinput-button">
                    <i class="icon-plus icon-white"></i>
                    <span>Add files...</span>
                    <input type="file" name="files" multiple>
                </span>
                <button type="submit" class="btn start">
                    <i class="icon-upload icon-white"></i>
                    <span>Start upload</span>
                </button>
                <button type="reset" class="btn cancel">
                    <i class="icon-ban-circle icon-white"></i>
                    <span>Cancel upload</span>
                </button>
                <!---
                <button type="button" class="btn btn-danger delete">
                    <i class="icon-trash icon-white"></i>
                    <span>Delete</span>
                </button>
                <input type="checkbox" class="toggle">
                --->
            </div>
            <!-- The global progress information -->
            <div class="span5 fileupload-progress fade">
                <!-- The global progress bar -->
                <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                    <div class="bar" style="width:0%;"></div>
                </div>
                <!-- The extended global progress information -->
                <div class="progress-extended">&nbsp;</div>
            </div>
        </div>
        <!-- The loading indicator is shown during file processing -->
        <div class="fileupload-loading"></div>
        <br>
        <!-- The table listing the files available for upload/download -->
        <table role="presentation" class="table table-striped"><tbody class="files" data-toggle="modal-gallery" data-target="##modal-gallery"></tbody></table>
      <input type="hidden" name="muraAction" value="cArch.update"/>
      <input type="hidden" name="action" value="multiFileUpload"/>
      <input type="hidden" name="siteid" value="#htmlEditFormat(rc.siteid)#"/>
      <input type="hidden" name="moduleid" value="#htmlEditFormat(rc.moduleid)#"/>
      <input type="hidden" name="topid" value="#htmlEditFormat(rc.topid)#"/>
      <input type="hidden" name="ptype" value="#htmlEditFormat(rc.ptype)#"/>
      <input type="hidden" name="parentid" value="#htmlEditFormat(rc.parentid)#"/>
      <input type="hidden" name="contentid" value=""/>
      <input type="hidden" name="type" value="File"/>
      <input type="hidden" name="subtype" value="Default"/>
      <input type="hidden" name="startrow" value="#rc.startrow#"/>
      <input type="hidden" name="orderno" value="0"/>
      <input type="hidden" name="approved" value="<cfif rc.perm eq 'editor'>1<cfelse>0</cfif>" />
    </form>
   
</div>

<!---
<!-- modal-gallery is the modal dialog used for the image gallery -->
<div id="modal-gallery" class="modal modal-gallery hide fade" data-filter=":odd">
    <div class="modal-header">
        <a class="close" data-dismiss="modal">&times;</a>
        <h3 class="modal-title"></h3>
    </div>
    <div class="modal-body"><div class="modal-image"></div></div>
    <div class="modal-footer">
        <a class="btn modal-download" target="_blank">
            <i class="icon-download"></i>
            <span>Download</span>
        </a>
        <a class="btn btn-success modal-play modal-slideshow" data-slideshow="5000">
            <i class="icon-play icon-white"></i>
            <span>Slideshow</span>
        </a>
        <a class="btn btn-info modal-prev">
            <i class="icon-arrow-left icon-white"></i>
            <span>Previous</span>
        </a>
        <a class="btn btn-primary modal-next">
            <span>Next</span>
            <i class="icon-arrow-right icon-white"></i>
        </a>
    </div>
</div>
--->

<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td class="preview"><span class="fade"></span></td>
        <td class="name"><span>{%=file.name%}</span></td>
        <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
        {% if (file.error) { %}
            <td class="alert-error" colspan="2"><span class="label label-important">{%=locale.fileupload.error%}</span> {%=locale.fileupload.errors[file.error] || file.error%}</td>
        {% } else if (o.files.valid && !i) { %}
            <td>
                <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>
            </td>
            <td class="start">{% if (!o.options.autoUpload) { %}
                <button class="btn">
                    <i class="icon-upload icon-white"></i>
                    <span>{%=locale.fileupload.start%}</span>
                </button>
            {% } %}</td>
        {% } else { %}
            <td colspan="2"></td>
        {% } %}
        <td class="cancel">{% if (!i) { %}
            <button class="btn">
                <i class="icon-ban-circle icon-white"></i>
                <span>{%=locale.fileupload.cancel%}</span>
            </button>
        {% } %}</td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        {% if (file.error) { %}
            <td></td>
            <td class="name"><span>{%=file.name%}</span></td>
            <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
            <td class="alert-error" colspan="2"><span class="label label-important">{%=locale.fileupload.error%}</span> {%=locale.fileupload.errors[file.error] || file.error%}</td>
        {% } else { %}
            <td class="preview">{% if (file.thumbnail_url) { %}
                <a href="{%=file.edit_url%}" title="{%=file.name%}"<!--- rel="gallery" download="{%=file.name%}"--->><img src="{%=file.thumbnail_url%}"></a>
            {% } %}</td>
            <td class="name">
                <a href="{%=file.edit_url%}" title="{%=file.name%}"<!---rel="{%=file.thumbnail_url&&'gallery'%}" download="{%=file.name%}"--->>{%=file.name%}</a>
            </td>
            <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
            <td colspan="2"></td>
        {% } %}
        <td class="delete">
           <!---
            <button class="btn btn-danger" data-type="{%=file.delete_type%}" data-url="{%=file.delete_url%}">
                <i class="icon-trash icon-white"></i>
                <span>{%=locale.fileupload.destroy%}</span>
            </button>
            <input type="checkbox" name="delete" value="1">
            --->
        </td>
    </tr>
{% } %}
</script>

<script src="#application.configBean.getContext()#/admin/assets/js/jquery/tmpl.min.js?coreversion=#application.coreversion#"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/load-image.min.js?coreversion=#application.coreversion#"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/canvas-to-blob.min.js?coreversion=#application.coreversion#"></script>
<!-- Bootstrap JS and Bootstrap Image Gallery are not required, but included for the demo 
<script src="http://blueimp.github.com/cdn/js/bootstrap.min.js"></script>
<script src="http://blueimp.github.com/Bootstrap-Image-Gallery/js/bootstrap-image-gallery.min.js"></script>
-->

<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.iframe-transport.js?coreversion=#application.coreversion#"></script>
<!-- The basic File Upload plugin -->
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.fileupload.js?coreversion=#application.coreversion#"></script>
<!-- The File Upload file processing plugin -->
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.fileupload-fp.js?coreversion=#application.coreversion#"></script>
<!-- The File Upload user interface plugin -->
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.fileupload-ui.js?coreversion=#application.coreversion#"></script>
<!-- The localization script -->
<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.fileupload.locale.js?coreversion=#application.coreversion#"></script>
<!-- The main application script -->
<script>
$(function () {
    'use strict';

    // Initialize the jQuery File Upload widget:
    $('##fileupload').fileupload({url:'#application.configBean.getContext()#/admin/index.cfm'});

});
</script>
</cfoutput>
<cfelse>
<div>
<cfinclude template="form/dsp_full.cfm">
</div>
</cfif>
		