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
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.tags"))/>
<cfset tabList=listAppend(tabList,"tabTags")>
<cfset tags=$.getBean('contentGateway').getTagCloud(siteid=$.event('siteID')) />
<div id="tabTags" class="tab-pane fade">

<span id="extendset-container-tabtagstop" class="extendset-container"></span>

<div class="fieldset">
<cfoutput>
<div class="control-group">
   	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tags')#</label>	    
   	<div class="controls">
   		<cfif tags.recordcount>
   		<div id="svTagCloud">	
			<cfsilent>
				<cfset tags=$.getBean('contentGateway').getTagCloud($.event('siteID')) />
				<cfset tagValueArray = ListToArray(ValueList(tags.tagCount))>
				<cfset max = ArrayMax(tagValueArray)>
				<cfset min = ArrayMin(tagValueArray)>
				<cfset diff = max - min>
				<cfset distribution = diff>
				<cfset rbFactory=$.siteConfig().getRBFactory()>
			</cfsilent>	
			<ol>
				<cfloop query="tags"><cfsilent>
						<cfif tags.tagCount EQ min>
						<cfset class="not-popular">
					<cfelseif tags.tagCount EQ max>
						<cfset class="ultra-popular">
					<cfelseif tags.tagCount GT (min + (distribution/2))>
						<cfset class="somewhat-popular">
					<cfelseif tags.tagCount GT (min + distribution)>
						<cfset class="mediumTag">
					<cfelse>
						<cfset class="not-very-popular">
					</cfif>
				
					<cfset args = ArrayNew(1)>
				    <cfset args[1] = tags.tagcount>
				</cfsilent><li class="#class#"><span><cfif tags.tagcount gt 1> #rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemsare'), args)#<cfelse>#rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemis'), args)#</cfif> tagged with </span><a class="tag<cfif listFind(rc.contentBean.getTags(),tags.tag)> active</cfif>">#HTMLEditFormat(tags.tag)#</a></li>
				</cfloop>
			</ol>
		</div>
		</cfif>
   		<div id=tags class=tagSelector>
		<cfloop list="#rc.contentBean.getTags()#" index="i">
			<span class="tag">
			#HTMLEditFormat(i)# <a><i class="icon-remove-sign"></i></a>
			<input name="tags" type="hidden" value="#HTMLEditFormat(i)#">
			</span>
		</cfloop>
		<input type="text" name="tags">
		</div>
   </div>
</div>

<script>
	<cfif tags.recordcount>
	$(document).ready(function(){
		var tags = [
			<cfloop query="tags">
			{ id: '#JSStringFormat(tags.tag)#', toString: function() { return '#JSStringFormat(tags.tag)#'; } }<cfif tags.currentrow lt tags.recordcount>,</cfif>
			</cfloop>
		];
		$('##tags').tagSelector(tags, 'tags');
	});
	</cfif>
</script>

</div>

<span id="extendset-container-tags" class="extendset-container"></span>
<span id="extendset-container-tabtagsbottom" class="extendset-container"></span>

 </div>
 </cfoutput>