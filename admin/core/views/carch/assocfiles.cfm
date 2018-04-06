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
<cfsilent>
	<cfset request.layout=false>
	<cfparam name="rc.keywords" default="">
	<cfparam name="rc.isNew" default="1">

	<cfset rc.rsList=application.contentManager.getPrivateSearch(rc.siteid,rc.keywords,'','',rc.type)/>
	<cfif rc.type eq 'file'>
		<cfquery name="rsImages" dbtype="query">
			select * from rc.rslist
			where lower(fileExt) in ('png','jpg','jpeg','gif')
		</cfquery>
		<cfquery name="rsFiles" dbtype="query">
			select * from rc.rslist
			where lower(fileExt) not in ('png','jpg','jpeg','gif')
		</cfquery>
	<cfelse>
		<cfset rsImages=rc.rsList>
	</cfif>

	<cfset filtered=structNew()>
</cfsilent>
<cfoutput>

<div class="mura-control-group">
		<div class="mura-input-set">
			<input class="filesearch mura-3 mura-constrain" value="#esapiEncode('html_attr',rc.keywords)#" type="text" maxlength="50" placeholder="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforexistingfiles'))#" />
			<button type="button" class="btn"><i class="mi-search"></i></button>
		</div>
</div>
</cfoutput>

<cfif len(rc.keywords)>
	<cfoutput>

	<div class="selectAssocImageResults block" id="selectAssocImageResults-#esapiEncode('html',rc.property)#">
		<ul class="mura-tabs nav-tabs" data-toggle="tabs">
			<li><a href="##mura-assoc-images-#esapiEncode('html',rc.property)#" data-toggle="tab" onclick="return false;"><i class="mi-picture-o"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.images')#</a></li>
			<cfif rc.type eq 'file'><li><a href="##mura-assoc-files-#esapiEncode('html',rc.property)#" data-toggle="tab" onclick="return false;"><i class="mi-file-text-o"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.otherfiles')#</a></li></cfif>
		</ul>
		</cfoutput>
		<div class="tab-content">
			<cfoutput>
			<div id="mura-assoc-images-#esapiEncode('html',rc.property)#" class="tab-pane mura-assoc-images"></cfoutput>
				<ul>
					<cfset counter=0 />
				    <cfif rsimages.recordcount>
				     <cfoutput query="rsimages" startrow="1" maxrows="100">
						<cfif not structKeyExists(filtered,'#rsimages.fileid#')>
							<cfsilent>
								<cfset crumbdata=application.contentManager.getCrumbList(rsimages.contentid, rc.siteid)/>
					       		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
					       		<cfset hasImage=listFindNoCase("png,gif,jpg,jpeg",rsimages.fileExt)>
							</cfsilent>
							<cfif verdict neq 'none'>
								<cfset filtered['#rsimages.fileid#']=true>
								<cfset counter=counter+1/>
						        <li>
						        <cfif hasImage>
						        <img src="#application.configBean.getContext()#/index.cfm/_api/render/small/?fileID=#rsimages.fileid#"/><br/>
						        <cfelse>
						        <i class="mi-file-text-o"></i><br/>#rsimages.assocfilename#<br>
						        </cfif>
						        <input type="radio" name="#esapiEncode('html_attr',rc.property)#" value="#rsimages.fileid#"/></li>
						 	</cfif>
					 	</cfif>
				      </cfoutput>
					 </cfif>
					 <cfif not counter>
						<cfoutput>
						<div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</alert>
						</cfoutput>
					</cfif>
				</ul>
			</div>
			<cfif rc.type eq 'file'>
			<cfoutput>
			<div id="mura-assoc-files-#esapiEncode('html',rc.property)#" class="tab-pane mura-assoc-files"></cfoutput>
				<ul>
					<cfset counter=0 />
					<cfif rsfiles.recordcount>
				     <cfoutput query="rsfiles" startrow="1" maxrows="100">
						<cfif not structKeyExists(filtered,'#rsfiles.fileid#')>
							<cfsilent>
								<cfset crumbdata=application.contentManager.getCrumbList(rsfiles.contentid, rc.siteid)/>
					       		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
					       		<cfset hasImage=listFindNoCase("png,gif,jpg,jpeg",rsfiles.fileExt)>
							</cfsilent>
							<cfif verdict neq 'none'>
								<cfset filtered['#rsfiles.fileid#']=true>
								<cfset counter=counter+1/>
						        <li><input type="radio" name="#esapiEncode('html_attr',rc.property)#" value="#rsfiles.fileid#"/>&nbsp;<i class="mi-file-text-o"></i>&nbsp;#esapiEncode('html',rsfiles.assocfilename)#</li>
						 	</cfif>
					 	</cfif>
				      </cfoutput>
					 </cfif>
					 <cfif not counter>
						<cfoutput>
						<div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</div>
						</cfoutput>
					</cfif>
				</ul>
			</div>
			</cfif>
		</div>
	</div>
</cfif>
