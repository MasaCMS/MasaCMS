
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.publishing"))/>
<cfset tabList=listAppend(tabList,"tabPublishing")>
<cfoutput>
  <div id="tabPublishing" class="tab-pane fade">
		
	<span id="extendset-container-tabpublishingtop" class="extendset-container"></span>

	<div class="fieldset">

  	<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>
		<div class="control-group">
  				
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.credits')#</label>
			      <div class="controls"><input type="text" id="credits" name="credits" value="#esapiEncode('html_attr',rc.contentBean.getCredits())#"  maxlength="255" class="span12"></div>
			    </div> <!--- /end control-group --->
					
		<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
		<div class="control-group">
	      	<div class="controls">
				      	<label for="Restricted" class="checkbox"><input name="restricted" id="Restricted" type="checkbox" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#
						</label>
					</div> 
	      	<div class="controls" id="rg"<cfif rc.contentBean.getrestricted() NEQ 1> style="display:none;"</cfif>>
						<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
						<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
						<option value="" <cfif rc.contentBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
						<option value="RestrictAll" <cfif rc.contentBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
						</optgroup>
						<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=1</cfquery>	
						<cfif rsGroups.recordcount>
							<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
							<cfloop query="rsGroups">
								<option value="#rsGroups.groupname#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
							</cfloop>
							</optgroup>
						</cfif>
						<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=0</cfquery>	
						<cfif rsGroups.recordcount>
							<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
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
		      		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#
		      		 <i class="icon-question-sign"></i></a>
		      	</label>
		    </div>
		</div> <!--- /end control-group --->

		<div class="control-group">
		    <div class="controls">
		     	<label for="Target" class="checkbox">
		     	<input  name="target" id="Target" type="CHECKBOX" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" > 
		     		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#
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
	      		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#
	      		 <i class="icon-question-sign"></i></a>
	      	</label>
	      	<div class="controls">
	      		<cf_datetimeselector name="releaseDate" datetime="#rc.contentBean.getReleaseDate()#">
			</div>
		</div> <!--- /end control-group --->
	</cfif>	
		
	<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>
		
		<cfif rc.parentBean.getType() neq 'Calendar'>
			<cfinclude template="dsp_displaycontent.cfm">
		</cfif>
		<cfif rc.type neq 'Component' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all' and rc.type neq 'Form'>
			<div class="control-group">
	      		<label class="control-label">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#:
	      			<span id="mover1" class="text"> 
	      				<cfif rc.contentBean.getIsNew()>
	      					"#rc.crumbData[1].menutitle#"<cfelse>"#rc.crumbData[2].menutitle#"
	      				</cfif>

						<button id="selectParent" name="selectParent" class="btn btn-inverse btn-small">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent')#
						</button>
					</span>
	      		</label>
	      		<div class="controls" id="mover2" style="display:none"><input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#"></div>	
				<script>
					jQuery(document).ready(function(){
						$('##selectParent').click(function(e){
							e.preventDefault();
							siteManager.loadSiteParents(
								'#esapiEncode('javascript',rc.siteid)#'
								,'#esapiEncode('javascript',rc.contentid)#'
								,'#esapiEncode('javascript',rc.parentid)#'
								,''
								,1
							);
							return false;
						});
					});
				</script>
				
			</div> <!--- /end control-group --->
		<cfelse>
		 	<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
		</cfif>
	<cfelse>
		<cfif rc.type neq 'Component' and rc.type neq 'Form'>	
			<input type="hidden" name="display" value="#rc.contentBean.getdisplay()#">
				<cfif rc.contentid eq '00000000000000000000000000000000001' or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'top') or application.settingsManager.getSite(rc.siteid).getlocking() eq 'all'>
					<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
				</cfif>
			<input type="hidden" name="displayStart" value="">
			<input type="hidden" name="displayStop" value="">
		<cfelse>
			<input type="hidden" name="display" value="1">
			<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
		</cfif>
		
	</cfif>

	<cfif listFind("Page,Folder,Calendar,Gallery,Link,File,Link",rc.type)>
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')#
	      	</label>
	     	<div class="controls" id="expires-date-selector">
	     			<cf_datetimeselector name="expires" datetime="#rc.contentBean.getExpires()#" defaulthour="23" defaultminute="59">
			</div>
			<div class="controls" id="expires-notify">
				<label for="dspexpiresnotify" class="checkbox">
					<input type="checkbox" name="dspExpiresNotify" id="dspexpiresnotify" onclick="siteManager.loadExpiresNotify('#esapiEncode('javascript',rc.siteid)#','#esapiEncode('javascript',rc.contenthistid)#','#esapiEncode('javascript',rc.parentid)#');"  class="checkbox">
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
						
						<cf_datetimeselector name="featureStart" datetime="#rc.contentBean.getFeatureStart()#">

					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<cf_datetimeselector name="featureStop" datetime="#rc.contentBean.getFeatureStop()#" defaulthour="23" defaultminute="59">
					</div>
				</div>
			</div>
		</div> <!--- /end control-group --->
	</cfif>

	<div class="control-group">
		<div class="controls">
			<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreviewlabel')#</label>
	   		<label for="dspnotify" class="checkbox">
	      		<input type="checkbox" name="dspNotify"  id="dspnotify" onclick="siteManager.loadNotify('#esapiEncode('javascript',rc.siteid)#','#esapiEncode('javascript',rc.contentid)#','#esapiEncode('javascript',rc.parentid)#');"  class="checkbox"> 
	      		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview"))#">
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