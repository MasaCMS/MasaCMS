<cfsilent>
	<cfparam name="rc.relatedcontentsetid" default="">
	<cfparam name="rc.relateditems" default="[]">
	<cfset rc.contentBean=$.getBean('content').loadBy(contenthistid=rc.contenthistid,siteid=rc.siteid)>
	<cfset subtype = application.classExtensionManager.getSubTypeByName(rc.type, rc.subtype, rc.siteid)>
	<cfset relatedContentSets = subtype.getRelatedContentSets()>
	<cfset request.layout=false>

	<cfif len(rc.relatedcontentsetid)>
		<cfif rc.relatedcontentsetid eq 'custom' or rc.relatedcontentsetid eq 'calendar'>
			<cfset rcsBean=subtype.getRelatedContentSetBean()>
			<cfset rcsBean.setName('Custom')>
			<cfset rcsBean.setRelatedContentSetId('custom')>
			<cfset relatedContentSets=[rcsBean]>
		<cfelse>
			<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="i">
				<cfif relatedContentSets[i].getRelatedContentSetId() eq rc.relatedcontentsetid>
					<cfset relatedContentSets=[relatedContentSets[i]]>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>

	</cfif>
</cfsilent>

<cfoutput>
	<div id="mura-rc-quickedit" style="display:none;">
		<h3>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.relatedcontentsets')#</h3>
		<button class="btn" type="button" onclick="$('##mura-rc-quickedit').hide()"><i class="mi-times-circle"></i></button>
		<ul>
		<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="s">
			<cfset rcsBean = relatedContentSets[s]/>
			<li><input id="mura-rc-option-label#s#" type="checkbox" class="mura-rc-quickassign" value="#rcsBean.getRelatedContentSetID()#"/> <label for="mura-rc-option-label#s#">#esapiEncode('html',rcsBean.getName())#</label></li>
		</cfloop>
		</ul>
	</div>

	<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="s">
		<cfset rcsBean = relatedContentSets[s]/>
		<cfif rcsBean.exists()>
			<cfset rcsRs = rcsBean.getRelatedContentQuery(rc.contentBean.getContentHistID())>
		<cfelse>
			<cfset rcsRs=queryNew('contentid,siteid,type,subtype,url,title')>
			<cfif not isArray(rc.relateditems)>
				<cfif isJSON(rc.relateditems)>
					<cfset rc.relateditems=deserializeJSON(rc.relateditems)>
				</cfif>
				<cfif not isArray(rc.relateditems)>
					<cfset rc.relateditems=listToArray(rc.relateditems)>
				</cfif>
			</cfif>

			<cfloop from="1" to="#arrayLen(rc.relateditems)#" index="i">
				<cfset item=rc.relateditems[i]>
				<cfif isSimpleValue(item)>
					<cfset itemBean=rc.$.getBean('content').loadBy(contentid=item)>
					<cfif itemBean.exists()>
						<cfif itemBean.getContentID() neq rc.contentBean.getContentID()>
							<cfset queryAddRow(rcsRs,1)>
							<cfloop list="#rcsRs.columnlist#" index="c">
								<cfset querySetCell(rcsRs, lcase(c), itemBean.getValue(c), rcsRs.recordcount)>
							</cfloop>
						</cfif>
					</cfif>
				<cfelse>
					<cfif item.contentid neq rc.contentBean.getContentID()>
	 					<cfset queryAddRow(rcsRs,1)>
						<cfloop list="#rcsRs.columnlist#" index="c">
							<cfset querySetCell(rcsRs, lcase(c),item[c], rcsRs.recordcount)>
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
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
