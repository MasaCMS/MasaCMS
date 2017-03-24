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
<!--- At t his point this is experimental --->
<cfsilent>
<cfparam name="rc.fileid" default="">
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfquery name="rsImages">
	select distinct tfiles.fileid,tfiles.siteid from tfiles
	left join tcontent on (tfiles.contentid=tcontent.contentid)
	where tfiles.fileext in ('png','jpg','jpeg','svg')
	and tfiles.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.siteConfig().getFilePoolID()#">
	and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.siteConfig().getSiteID()#">
	and tcontent.active=1

	and (
		tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.contentid#">

		or tcontent.parentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.contentid#">

		or tcontent.parentid in (select tcontent.contentid from tcontent
								where tcontent.parentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.contentid#">
								and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.siteConfig().getSiteID()#">
								and tcontent.active=1
								)
		)
</cfquery>
</cfsilent>
<cfinclude template="js.cfm">
<cfoutput>
<div class="mura-header">
	<h1>Select Image</h1>

	<!---
		<div class="nav-module-specific btn-toolbar">
			<div class="btn-group">
				<a class="btn" href="javascript:frontEndProxy.post({cmd:'close'});"><i class="mi-arrow-left"></i>  #application.rbFactory.getKeyValue(session.rb,'collections.back')#</a>
			</div>
		</div><!-- /.nav-module-specific -->
	--->
</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
	  	<div class="block-content">
			<div class="mura-control-group">
				<div class="mura-control">
					<cfif rsImages.recordcount>
						<cfloop query="rsImages">
							<div class="image-option" style="float:left" data-fileid="#rsImages.fileid#">
								<img src="#$.getURLForImage(fileid=rsImages.fileid,size='small')#"/>
							</div>
						</cfloop>
					<cfelse>
						<div class="help-block-empty">There are currently no related images available.</div>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
$(function(){
	$('.image-option').click(function(){
		//alert($('input[name="fileid"]').val())
		//return;
		frontEndProxy.post({
			cmd:'setObjectParams',
			reinit:true,
			instanceid:'#esapiEncode("javascript",rc.instanceid)#',
			params:{
				fileid:$(this).data('fileid')
				}
			});
	});

	if($("##ProxyIFrame").length){
		$("##ProxyIFrame").load(
			function(){
				frontEndProxy.post({cmd:'setWidth',width:600});
			}
		);
	} else {
		frontEndProxy.post({cmd:'setWidth',width:600});
	}


});
</script>
</cfoutput>
