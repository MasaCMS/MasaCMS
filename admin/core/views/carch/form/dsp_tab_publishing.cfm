
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.publishing"))/>
<cfset tabList=listAppend(tabList,"tabPublishing")>
<cfoutput>
  <div id="tabPublishing" class="tab-pane fade">


  	<cfif listFindNoCase('Page,Portal,Calendar,Gallery,File,Link',rc.type)>
  		

  				<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.credits')#</label>
			      <div class="controls"><input type="text" id="credits" name="credits" value="#HTMLEditFormat(rc.contentBean.getCredits())#"  maxlength="255" class="textLong"></div>
			    </div>
				
				<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
					<div class="control-group">
			      	<div class="controls"><label for="Restricted" class="checkbox"><input name="restricted" id="Restricted" type="checkbox" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#</label>
					</div> 
			      	<div class="controls"id="rg"<cfif rc.contentBean.getrestricted() NEQ 1> style="display:none;"</cfif>>
					<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
					<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
					<option value="" <cfif rc.contentBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
					<option value="RestrictAll" <cfif rc.contentBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
					</optgroup>
					<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=1</cfquery>	
					<cfif rsGroups.recordcount>
						<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
						<cfloop query="rsGroups">
							<option value="#rsGroups.groupname#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
						</cfloop>
						</optgroup>
					</cfif>
					<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=0</cfquery>	
					<cfif rsGroups.recordcount>
						<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
						<cfloop query="rsGroups">
							<option value="#rsGroups.groupname#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
						</cfloop>
						</optgroup>
					</cfif>
					</select>
					</div>
			    </div>
			</cfif>

  		<div class="control-group">
		     <div class="controls">
		      	<label for="isNav" class="checkbox">
		      		<input name="isnav" id="isNav" type="CHECKBOX" value="1" <cfif rc.contentBean.getisnav() eq 1 or rc.contentBean.getisNew() eq 1>checked</cfif> class="checkbox"> 
		      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#
		      		 <i class="icon-info-sign"></i></a>
		      	</label>
		    </div>
		</div>

		<div class="control-group">
		    <div class="controls">
		     	<label for="Target" class="checkbox">
		     	<input  name="target" id="Target" type="CHECKBOX" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" > 
		     		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#
		     		 <i class="icon-info-sign"></i></a>
		     	</label>
		     </div>  
		</div>

		<div class="control-group">
			 <div class="controls"><label for="searchExclude" class="checkbox"><input name="searchExclude" id="searchExclude" type="CHECKBOX" value="1" <cfif rc.contentBean.getSearchExclude() eq "">checked <cfelseif rc.contentBean.getSearchExclude() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchexclude')#</label> 
			</div>
		</div>
	
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#
	      		 <i class="icon-info-sign"></i></a>
	      	</label>
	      	<div class="controls">
				<input type="text" class="datepicker textAlt" name="releaseDate" value="#LSDateFormat(rc.contentBean.getreleasedate(),session.dateKeyFormat)#"  maxlength="12" >
				<select name="releasehour" class="dropdown span1"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getReleaseDate())  and h eq 12 or (LSisDate(rc.contentBean.getReleaseDate()) and (hour(rc.contentBean.getReleaseDate()) eq h or (hour(rc.contentBean.getReleaseDate()) - 12) eq h or hour(rc.contentBean.getReleaseDate()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
				<select name="releaseMinute" class="dropdown span1"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getReleaseDate()) and minute(rc.contentBean.getReleaseDate()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
				<select name="releaseDayPart" class="dropdown span1"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getReleaseDate()) and hour(rc.contentBean.getReleaseDate()) gte 12>selected</cfif>>PM</option></select>
			</div>
		</div>
	</cfif>	
		
	<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>
		<cfset bydate=iif(rc.contentBean.getdisplay() EQ 2 or (rc.ptype eq 'Calendar' and rc.contentBean.getIsNew()),de('true'),de('false'))>
		
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#
	      		 <i class="icon-info-sign"></i></a>
	      	</label>
	      	<div class="controls">
	      		<select name="display" class="dropdown" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
					<option value="1"  <cfif  rc.contentBean.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
					<option value="0"  <cfif  rc.contentBean.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
					<option value="2"  <cfif  bydate> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
				</select>
			</div>
			<div class="controls" id="editDates" <cfif  not bydate>style="display: none;"</cfif>>
				<div class="control-group">
					<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="displayStart" value="#LSDateFormat(rc.contentBean.getdisplaystart(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="starthour" class="dropdown span1"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystart())  and h eq 12 or (LSisDate(rc.contentBean.getdisplaystart()) and (hour(rc.contentBean.getdisplaystart()) eq h or (hour(rc.contentBean.getdisplaystart()) - 12) eq h or hour(rc.contentBean.getdisplaystart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="startMinute" class="dropdown span1"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getdisplaystart()) and minute(rc.contentBean.getdisplaystart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="startDayPart" class="dropdown span1"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getdisplaystart()) and hour(rc.contentBean.getdisplaystart()) gte 12>selected</cfif>>PM</option></select>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="displayStop" value="#LSDateFormat(rc.contentBean.getdisplaystop(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="stophour" class="dropdown span1"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystop())  and h eq 11 or (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) eq h or (hour(rc.contentBean.getdisplaystop()) - 12) eq h or hour(rc.contentBean.getdisplaystop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="stopMinute" class="dropdown span1"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getdisplaystop()) and m eq 59) or (LSisDate(rc.contentBean.getdisplaystop()) and minute(rc.contentBean.getdisplaystop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="stopDayPart" class="dropdown span1"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) gte 12)) or not LSisDate(rc.contentBean.getdisplaystop())>selected</cfif>>PM</option></select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval')#
					</label>
					<div class="controls">
						<select name="displayInterval">
							<cfloop list="Daily,Weekly,Bi-Weekly,Monthly,WeekDays,WeekEnds,Week1,Week2,Week3,Week4,WeekLast" index="i">
							<option value="#i#"<cfif rc.contentBean.getDisplayInterval() eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
							</cfloop>
						</select>
					</div>
				</div>
			</div>
		</div>
		
		<cfif rc.type neq 'Component' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all' and rc.type neq 'Form'>
			<div class="control-group">
	      		<label class="control-label">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#:
	      			<span id="move" class="text"> 
	      				<cfif rc.contentBean.getIsNew()>
	      					"#rc.crumbData[1].menutitle#"<cfelse>"#rc.crumbData[2].menutitle#"
	      				</cfif>
						&nbsp;&nbsp;<a href="javascript:##;" onclick="javascript: siteManager.loadSiteParents('#rc.siteid#','#rc.contentid#','#rc.parentid#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent')#]</a>
						<input type="hidden" name="parentid" value="#rc.parentid#">
					</span>
				</label>
			</div>
		<cfelse>
		 	<input type="hidden" name="parentid" value="#rc.parentid#">
		</cfif>
	<cfelse>
		<cfif rc.type neq 'Component' and rc.type neq 'Form'>	
			<input type="hidden" name="display" value="#rc.contentBean.getdisplay()#">
				<cfif rc.contentid eq '00000000000000000000000000000000001' or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'top') or application.settingsManager.getSite(rc.siteid).getlocking() eq 'all'>
					<input type="hidden" name="parentid" value="#rc.parentid#">
				</cfif>
			<input type="hidden" name="displayStart" value="">
			<input type="hidden" name="displayStop" value="">
		<cfelse>
			<input type="hidden" name="display" value="1">
			<input type="hidden" name="parentid" value="#rc.parentid#">
		</cfif>
		
	</cfif>

	<cfif listFind("Page,Portal,Calendar,Gallery,Link,File,Link",rc.type)>
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')#
	      	</label>
	     	<div class="controls" id="expires-date-selector">
					<input type="text" name="expires" value="#LSDateFormat(rc.contentBean.getExpires(),session.dateKeyFormat)#" class="textAlt datepicker">
					<select name="expireshour" class="dropdown span1"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getExpires())  and h eq 12 or (LSisDate(rc.contentBean.getExpires()) and (hour(rc.contentBean.getExpires()) eq h or (hour(rc.contentBean.getExpires()) - 12) eq h or hour(rc.contentBean.getExpires()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
					<select name="expiresMinute" class="dropdown span1"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getExpires()) and minute(rc.contentBean.getExpires()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
					<select name="expiresDayPart" class="dropdown span1"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getExpires()) and hour(rc.contentBean.getExpires()) gte 12>selected</cfif>>PM</option></select>
			</div>
			<div class="controls" id="expires-notify">
				<label for="dspexpiresnotify" class="checkbox">
					<input type="checkbox" name="dspExpiresNotify" id="dspexpiresnotify" onclick="siteManager.loadExpiresNotify('#rc.siteid#','#rc.contenthistid#','#rc.parentid#');"  class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expiresnotify')#
				</label>
			</div>
			<div class="controls" id="selectExpiresNotify" style="display: none;"></div>
		</div>
	</cfif>

	<cfif rc.type neq 'Component' and rc.type neq 'Form' and  rc.contentid neq '00000000000000000000000000000000001'>
		<div class="control-group">
		    <label class="control-label">
		     	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isfeature')#
		    </label>
		    <div class="controls">
		    	<select name="isFeature" class="dropdown" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editFeatureDates',true):toggleDisplay2('editFeatureDates',false);">
					<option value="0"  <cfif  rc.contentBean.getisfeature() EQ 0> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
					<option value="1"  <cfif  rc.contentBean.getisfeature() EQ 1> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
					<option value="2"  <cfif rc.contentBean.getisfeature() EQ 2> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
				</select>
			</div>
			<div class="controls" id="editFeatureDates" <cfif rc.contentBean.getisfeature() NEQ 2>style="display: none;"</cfif>>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="featureStart" value="#LSDateFormat(rc.contentBean.getFeatureStart(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="featureStartHour" class="dropdown span1"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStart())  and h eq 12 or (LSisDate(rc.contentBean.getFeatureStart()) and (hour(rc.contentBean.getFeatureStart()) eq h or (hour(rc.contentBean.getFeatureStart()) - 12) eq h or hour(rc.contentBean.getFeatureStart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="featureStartMinute" class="dropdown span1"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getFeatureStart()) and minute(rc.contentBean.getFeatureStart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="featureStartDayPart" class="dropdown span1"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getFeatureStart()) and hour(rc.contentBean.getFeatureStart()) gte 12>selected</cfif>>PM</option></select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="featureStop" value="#LSDateFormat(rc.contentBean.getFeatureStop(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="featureStophour" class="dropdown span1"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStop())  and h eq 11 or (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) eq h or (hour(rc.contentBean.getFeatureStop()) - 12) eq h or hour(rc.contentBean.getFeatureStop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="featureStopMinute" class="dropdown span1"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getFeatureStop()) and m eq 59) or (LSisDate(rc.contentBean.getFeatureStop()) and minute(rc.contentBean.getFeatureStop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="featureStopDayPart" class="dropdown span1"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) gte 12)) or not LSisDate(rc.contentBean.getFeatureStop())>selected</cfif>>PM</option></select>
					</div>
				</div>
			</div>
		</div>

		
	</cfif>

	<div class="control-group">
		<div class="controls">
	   		<label for="dspnotify" class="checkbox">
	      		<input type="checkbox" name="dspNotify"  id="dspnotify" onclick="siteManager.loadNotify('#rc.siteid#','#rc.contentid#','#rc.parentid#');"  class="checkbox"> 
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreview')#
	      		 <i class="icon-info-sign"></i></a>
	      	</label>
	  	</div>
	     <div class="controls" id="selectNotify" style="display: none;"></div>
	</div>

	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addnotes')# <a href="" id="editNoteLink" onclick="toggleDisplay('editNote','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#]</a>
		</label>
		<div class="controls" id="editNote" style="display: none;">
			<textarea name="notes" rows="8" class="alt" id="abstract"></textarea>	
		</div>
	</div>

  <span id="extendset-container-publishing" class="extendset-container"></span>

</div></cfoutput>