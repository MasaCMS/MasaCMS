<cfset rc.contentBean=$.getBean('content').loadBy(contenthistid=rc.contenthistid,siteid=rc.siteid)>
<cfset subtype = application.classExtensionManager.getSubTypeByName(rc.type, rc.subtype, rc.siteid)>
<cfset relatedContentSets = subtype.getRelatedContentSets()>
<cfset request.layout=false>
<cfoutput>

	<div id="mura-rc-quickedit" style="display:none;">
		<h3>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.relatedcontentsets')#</h3>
		<button class="btn" type="button" onclick="$('##mura-rc-quickedit').hide()"><i class="icon-remove-sign"></i></button>
		<ul>
		<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="s">
			<cfset rcsBean = relatedContentSets[s]/>
			<li><input id="mura-rc-option-label#s#" type="checkbox" class="mura-rc-quickassign" value="#rcsBean.getRelatedContentSetID()#"/> <label for="mura-rc-option-label#s#">#esapiEncode('html',rcsBean.getName())#</label></li>
		</cfloop>
		</ul>
	</div>

	<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="s">
		<cfset rcsBean = relatedContentSets[s]/>
		<cfset rcsRs = rcsBean.getRelatedContentQuery(rc.contentBean.getContentHistID())>
		<cfset emptyClass = "item empty">
		<cfoutput>
			<div id="rcGroup-#rcsBean.getRelatedContentSetID()#" class="list-table">
				<div class="list-table-content-set">#esapiEncode('html',rcsBean.getName())# 
					<cfif len(rcsBean.getAvailableSubTypes()) gt 0>
						<span class="content-type">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.restrictedmessage')#: 
							<cfloop list="#rcsBean.getAvailableSubTypes()#" index="i">
								<cfset st = application.classExtensionManager.getSubTypeByName(listFirst(i, "/"), listLast(i, "/"), rc.contentBean.getSiteID())>
								<a href="##" rel="tooltip" data-original-title="#i#"><i class="#st.getIconClass(includeDefault=true)#"></i></a>
							</cfloop>
						</span>
					</cfif>
				</div>
				<ul id="rcSortable-#rcsBean.getRelatedContentSetID()#" class="list-table-items rcSortable" data-accept="#rcsBean.getAvailableSubTypes()#" data-relatedcontentsetid="#rcsBean.getRelatedContentSetID()#"> 
					<cfif rcsRS.recordCount>
						<cfset emptyClass = emptyClass & " noShow">
						<cfloop query="rcsRs">	
							<cfset crumbdata = application.contentManager.getCrumbList(rcsRs.contentid, rcsRs.siteid)>
							<li class="item" data-contentid="#rcsRs.contentID#" data-content-type="#rcsRs.type#/#rcsRs.subtype#">
								#$.dspZoomNoLinks(crumbdata=crumbdata, charLimit=90, minLevels=2)#
								<a class="delete"></a>
							</li>
						</cfloop>
					</cfif>
			 		<li class="#emptyClass#">
						<p>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.norelatedcontent')#</p>
					</li>
				</ul>
			</div>
		</cfoutput>
	</cfloop>
	
</cfoutput>
