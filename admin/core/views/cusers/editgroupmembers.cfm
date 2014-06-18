<cfset event=request.event>
<cfhtmlhead text="#session.dateKey#">
<cfset userPoolID=application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=1,siteid=userPoolID,activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>

<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>

<!--- <cfset pluginEventMappings=duplicate($.getBean('pluginManager').getEventMappings(eventName='onGroupEdit',siteid=rc.siteid))>
 <cfif arrayLen(pluginEventMappings)>
		<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
				<cfset pluginEventMappings[i].eventName='onGroupEdit'>
		</cfloop>
 </cfif> --->

<!--- <cfset tabLabelList='#rc.$.rbKey('user.basic')#'>
<cfset tablist="tabBasic">
<cfif rsSubTypes.recordcount>
	<cfset tabLabelList=listAppend(tabLabelList,rc.$.rbKey('user.extendedattributes'))>
	<cfset tabList=listAppend(tabList,"tabExtendedattributes")>
</cfif> --->

<!--- Header --->
	<cfoutput>
		<h1>#rc.$.rbKey('user.groupform')#</h1>
		<div id="nav-module-specific" class="btn-group">
			<a class="btn" href="##" title="#HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#" onclick="window.history.back(); return false;">
				<i class="icon-circle-arrow-left"></i> 
				#HTMLEditFormat(rc.$.rbKey('sitemanager.back'))#
			</a>

			<a class="btn" href="#buildURL(action='cusers.list')#">
				<i class="icon-eye-open"></i>
				View All Groups
			</a>

			<a class="btn" href="#buildURL(action='cusers.editgroup', querystring='userid=#rc.userid#&siteid=#URLEncodedFormat(rc.siteid)#')#">
				<i class="icon-pencil"></i>
				Edit Group Settings
			</a>
		</div>

		<h2>
			<strong>#rc.userBean.getgroupname()#</strong> Users
		</h2>
	</cfoutput>

<!--- Group Members --->
	<cfif rc.userid neq ''>
		<cfoutput> 
			<table class="mura-table-grid">
				<tr> 
					<th class="var-width">#rc.$.rbKey('user.name')#</th>
					<th>#rc.$.rbKey('user.email')#</th>
					<th>#rc.$.rbKey('user.update')#</th>
					<th>#rc.$.rbKey('user.time')#</th>
					<th>#rc.$.rbKey('user.authoreditor')#</th>
					<th>&nbsp;</th>
				</tr>
			</cfoutput>

			<cfif rc.rsgrouplist.recordcount>
				<cfoutput query="rc.rsgrouplist" maxrows="#rc.nextN.recordsperPage#" startrow="#rc.startrow#"> 
					<tr> 
						<td class="var-width">
							<a href="./?muraAction=cUsers.edituser&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#">
								#rc.rsgrouplist.lname#, #rc.rsgrouplist.fname# 
								<cfif rc.rsgrouplist.company neq ''> (#rc.rsgrouplist.company#)</cfif>
							</a>
						</td>
						<td>
							<cfif rc.rsgrouplist.email gt "">
								<a href="mailto:#rc.rsgrouplist.email#">
									#rc.rsgrouplist.email#
								</a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>#LSDateFormat(rc.rsgrouplist.lastupdate,session.dateKeyFormat)#</td>
						<td>#LSTimeFormat(rc.rsgrouplist.lastupdate,"short")#</td>
						<td>#rc.rsgrouplist.LastUpdateBy#</td>

						<!--- Actions --->
						<td class="actions">
							<ul class="group">
								<li class="edit">
									<a href="./?muraAction=cUsers.edituser&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#" rel="tooltip" title="#rc.$.rbKey('user.edit')#">
										<i class="icon-pencil"></i>
									</a>
								</li>
								<li class="remove">
									<a href="./?muraAction=cUsers.removefromgroup&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;groupid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('#jsStringFormat(rc.$.rbKey('user.removeconfirm'))#',this.href)" rel="tooltip" title="#rc.$.rbKey('user.removeconfirm')#">
										<i class="icon-minus-sign"></i>
									</a>
								</li>
								<li class="delete">
									<a href="./?muraAction=cUsers.update&amp;action=delete&amp;userid=#rc.rsgrouplist.UserID#&amp;routeid=#rc.userid#&amp;groupid=#rc.userid#&amp;siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('#jsStringFormat(rc.$.rbKey('user.deleteuserconfirm'))#',this.href)" rel="tooltip" title="#rc.$.rbKey('user.delete')#">
										<i class="icon-remove-sign"></i>
									</a>
								</li>
							</ul>
						</td>
					</tr>
				</cfoutput> 
			<cfelse>
				<tr> 
					<td class="noResults" colspan="6">
						<cfoutput>#rc.$.rbKey('user.nogroupmembers')#</cfoutput>
					</td>
				</tr>
			</cfif>
		</table>
	</cfif>
<!--- /Group Members --->

<!--- Pagination --->
	<cfif rc.nextN.numberofpages gt 1> 
		<cfoutput>
			<cfset args=arrayNew(1)>
			<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
			<cfset args[2]=rc.nextn.totalrecords>
			<div class="mura-results-wrapper">
				<p class="clearfix search-showing">
					#application.rbFactory.getResourceBundle(session.rb).messageFormat(rc.$.rbKey("sitemanager.paginationmeta"),args)#
				</p> 
				<div class="pagination">
					<ul>
						<cfif rc.nextN.currentpagenumber gt 1>
							<li>
					 			<a href="./?muraAction=cUsers.editgroup&amp;startrow=#rc.nextN.previous#&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#">&laquo;&nbsp;#rc.$.rbKey('user.prev')#</a>
					 		</li> 
						</cfif>
						<cfloop from="#rc.nextn.firstPage#"  to="#rc.nextN.lastPage#" index="i">
							<cfif rc.nextN.currentpagenumber eq i>
								<li class="active"><a href="##">#i#</a></li>
							<cfelse> 
								<li>
									<a href="./?muraAction=cUsers.editgroup&amp;startrow=#evaluate('(#i#*#rc.nextN.recordsperpage#)-#rc.nextN.recordsperpage#+1')#&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#">#i#</a> 
								</li>
							</cfif>
						</cfloop>
						<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
							<li>
								<a href="./?muraAction=cUsers.editgroup&amp;startrow=#rc.nextN.next#&amp;userid=#URLEncodedFormat(rc.userid)#&amp;siteid=#URLEncodedFormat(rc.siteid)#">#rc.$.rbKey('user.next')#&nbsp;&raquo;</a>
							</li>
						</cfif>
					</ul>
				</div>
			</div>
		</cfoutput>
	</cfif>
<!--- /Pagination --->