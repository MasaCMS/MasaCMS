
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.publishing"))/>
<cfset tabList=listAppend(tabList,"tabPublishing")>
<cfoutput>
  <div id="tabPublishing" class="tab-pane fade">
		
	<span id="extendset-container-tabpublishingtop" class="extendset-container"></span>

	<div class="fieldset">

  	<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>
		<div class="control-group">
  				
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.credits')#</label>
			      <div class="controls"><input type="text" id="credits" name="credits" value="#HTMLEditFormat(rc.contentBean.getCredits())#"  maxlength="255" class="span12"></div>
			    </div> <!--- /end control-group --->
					
		<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
		<div class="control-group">
	      	<div class="controls">
				      	<label for="Restricted" class="checkbox"><input name="restricted" id="Restricted" type="checkbox" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#
						</label>
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
      	</div> <!--- /end control-group --->
    </cfif>

  		<div class="control-group">
		     <div class="controls">
		      	<label for="isNav" class="checkbox">
		      		<input name="isnav" id="isNav" type="CHECKBOX" value="1" <cfif rc.contentBean.getisnav() eq 1 or rc.contentBean.getisNew() eq 1>checked</cfif> class="checkbox"> 
		      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#
		      		 <i class="icon-question-sign"></i></a>
		      	</label>
		    </div>
		</div> <!--- /end control-group --->

		<div class="control-group">
		    <div class="controls">
		     	<label for="Target" class="checkbox">
		     	<input  name="target" id="Target" type="CHECKBOX" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" > 
		     		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#
		     		 <i class="icon-question-sign"></i></a>
		     	</label>
		     </div>  
		</div> <!--- /end control-group --->

		<div class="control-group">
			 <div class="controls"><label for="searchExclude" class="checkbox"><input name="searchExclude" id="searchExclude" type="CHECKBOX" value="1" <cfif rc.contentBean.getSearchExclude() eq "">checked <cfelseif rc.contentBean.getSearchExclude() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchexclude')#</label> 
			</div>
		</div> <!--- /end control-group --->
	
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#
	      		 <i class="icon-question-sign"></i></a>
	      	</label>
	      	<div class="controls">
				<input type="text" class="datepicker span3" name="releaseDate" value="#LSDateFormat(rc.contentBean.getreleasedate(),session.dateKeyFormat)#"  maxlength="12" >
				<select name="releasehour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getReleaseDate())  and h eq 12 or (LSisDate(rc.contentBean.getReleaseDate()) and (hour(rc.contentBean.getReleaseDate()) eq h or (hour(rc.contentBean.getReleaseDate()) - 12) eq h or hour(rc.contentBean.getReleaseDate()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
					<select name="releaseMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getReleaseDate()) and minute(rc.contentBean.getReleaseDate()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
					<select name="releaseDayPart" class="time"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getReleaseDate()) and hour(rc.contentBean.getReleaseDate()) gte 12>selected</cfif>>PM</option></select>
					</div>
				</div> <!--- /end control-group --->
	</cfif>	
		
	<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>
		
		<cfif rc.ptype neq 'Calendar'>
			<cfinclude template="dsp_displaycontent.cfm">
		</cfif>
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
			</div> <!--- /end control-group --->
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

	<cfif listFind("Page,Folder,Calendar,Gallery,Link,File,Link",rc.type)>
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')#
	      	</label>
	     	<div class="controls" id="expires-date-selector">
					<input type="text" name="expires" value="#LSDateFormat(rc.contentBean.getExpires(),session.dateKeyFormat)#" class="span3 datepicker">
					<select name="expireshour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getExpires())  and h eq 12 or (LSisDate(rc.contentBean.getExpires()) and (hour(rc.contentBean.getExpires()) eq h or (hour(rc.contentBean.getExpires()) - 12) eq h or hour(rc.contentBean.getExpires()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
					<select name="expiresMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getExpires()) and minute(rc.contentBean.getExpires()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
					<select name="expiresDayPart" class="time"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getExpires()) and hour(rc.contentBean.getExpires()) gte 12>selected</cfif>>PM</option></select>
			</div>
			<div class="controls" id="expires-notify">
				<label for="dspexpiresnotify" class="checkbox">
					<input type="checkbox" name="dspExpiresNotify" id="dspexpiresnotify" onclick="siteManager.loadExpiresNotify('#rc.siteid#','#rc.contenthistid#','#rc.parentid#');"  class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expiresnotify')#
				</label>
			</div>
			<div class="controls" id="selectExpiresNotify" style="display: none;"></div>
		</div> <!--- /end control-group --->
	</cfif>

	<cfif rc.type neq 'Component' and rc.type neq 'Form' and  rc.contentid neq '00000000000000000000000000000000001'>
		<div class="control-group">
		    <label class="control-label">
		     	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isfeature')#
		    </label>
		    <div class="controls">
		    	<select name="isFeature" class="span3" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editFeatureDates',true):toggleDisplay2('editFeatureDates',false);">
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
						<input type="text" name="featureStart" value="#LSDateFormat(rc.contentBean.getFeatureStart(),session.dateKeyFormat)#" class="span2 datepicker">
						<select name="featureStartHour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStart())  and h eq 12 or (LSisDate(rc.contentBean.getFeatureStart()) and (hour(rc.contentBean.getFeatureStart()) eq h or (hour(rc.contentBean.getFeatureStart()) - 12) eq h or hour(rc.contentBean.getFeatureStart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="featureStartMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getFeatureStart()) and minute(rc.contentBean.getFeatureStart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="featureStartDayPart"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getFeatureStart()) and hour(rc.contentBean.getFeatureStart()) gte 12>selected</cfif>>PM</option></select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="featureStop" value="#LSDateFormat(rc.contentBean.getFeatureStop(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="featureStophour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStop())  and h eq 11 or (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) eq h or (hour(rc.contentBean.getFeatureStop()) - 12) eq h or hour(rc.contentBean.getFeatureStop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="featureStopMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getFeatureStop()) and m eq 59) or (LSisDate(rc.contentBean.getFeatureStop()) and minute(rc.contentBean.getFeatureStop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="featureStopDayPart" class="time"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) gte 12)) or not LSisDate(rc.contentBean.getFeatureStop())>selected</cfif>>PM</option></select>
					</div>
				</div>
			</div>
		</div> <!--- /end control-group --->
	</cfif>

	<div class="control-group">
		<div class="controls">
			<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreviewlabel')#</label>
	   		<label for="dspnotify" class="checkbox">
	      		<input type="checkbox" name="dspNotify"  id="dspnotify" onclick="siteManager.loadNotify('#rc.siteid#','#rc.contentid#','#rc.parentid#');"  class="checkbox"> 
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreview')#
	      		 <i class="icon-question-sign"></i></a>
	      	</label>
	  	</div>
	     <div class="controls" id="selectNotify" style="display: none;"></div>
	</div> <!--- /end control-group --->

	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addnotes')# <!--- <a href="" id="editNoteLink" onclick="toggleDisplay('editNote','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#]</a> --->
		</label>
		<div class="controls" id="editNote">
			<textarea name="notes" rows="8" class="span12" id="abstract"></textarea>	
		</div>
	</div> <!--- /end control-group --->

  </div>

   <span id="extendset-container-publishing" class="extendset-container"></span>

   <span id="extendset-container-tabpublishingbottom" class="extendset-container"></span>


</div></cfoutput>