
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.publishing"))/>
<cfset tabList=listAppend(tabList,"tabPublishing")>
<cfoutput>
<div id="tabPublishing" class="tab-pane">

	<!-- block -->
  <div class="block block-bordered">
  	<!-- block header -->
    <div class="block-header">
			<h3 class="block-title">Publishing</h3>
    </div>
    <!-- /block header -->

	<!-- block content -->
	<div class="block-content">

	<span id="extendset-container-tabpublishingtop" class="extendset-container"></span>


  	<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>

			<div class="mura-control-group">
	      <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.credits')#</label>
	      <input type="text" id="credits" name="credits" value="#esapiEncode('html_attr',rc.contentBean.getCredits())#"  maxlength="255">
	    </div>

		<cfif rc.moduleid eq '00000000000000000000000000000000000' and not len(tabAssignments) or listFindNocase(tabAssignments,'SEO')>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.description')#</label>
				<textarea name="metadesc" rows="3" id="metadesc">#esapiEncode('html',rc.contentBean.getMETADesc())#</textarea>
			</div>
			<cfif application.configBean.getValue(property='keepMetaKeywords',defaultValue=false)>
				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywords')#</label>
					<textarea name="metakeywords" rows="3" id="metakeywords">#esapiEncode('html',rc.contentBean.getMetaKeywords())#</textarea>
				</div>
			<cfelse>
				<div class="mura-control-group">
					<label>Canonical URL</label>
					<input type="text" id="canonicalURL" name="canonicalURL" value="#esapiEncode('html_attr',rc.contentBean.getCanonicalURL())#"  maxlength="255">
	  		</div>
			</cfif>
  	</cfif>

		<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
			<div class="mura-control-group">
		      	<label for="Restricted" class="checkbox"><input name="restricted" id="Restricted" type="checkbox" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#
				</label>
			</div>
	      	<div class="mura-control=group" id="rg"<cfif rc.contentBean.getrestricted() NEQ 1> style="display:none;"</cfif>>
				<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
				<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
				<option value="" <cfif rc.contentBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
				<option value="RestrictAll" <cfif rc.contentBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
				</optgroup>
				<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=1</cfquery>
				<cfif rsGroups.recordcount>
					<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
					<cfloop query="rsGroups">
						<option value="#rsGroups.userid#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname) or listfind(rc.contentBean.getrestrictgroups(),rsGroups.userid)>Selected</cfif>>#rsGroups.groupname#</option>
					</cfloop>
					</optgroup>
				</cfif>
				<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=0</cfquery>
				<cfif rsGroups.recordcount>
					<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
					<cfloop query="rsGroups">
						<option value="#rsGroups.userid#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname) or listfind(rc.contentBean.getrestrictgroups(),rsGroups.userid)>Selected</cfif>>#rsGroups.groupname#</option>
					</cfloop>
					</optgroup>
				</cfif>
				</select>
			</div> <!--- /end mura-control-group --->
	    </cfif>

		 <div class="mura-control-group">
	      	<label for="isNav" class="checkbox">
	      		<input name="isnav" id="isNav" type="CHECKBOX" value="1" <cfif rc.contentBean.getisnav() eq 1 or rc.contentBean.getisNew() eq 1>checked</cfif> class="checkbox">
				    	<span data-toggle="popover" title="" data-placement="right"
					    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav"))#"
					    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.isnav"))#"
					    	>
					      #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#
			    		 <i class="mi-question-circle"></i>
	      	</label>
		</div> <!--- /end mura-control-group --->

		<div class="mura-control-group">
			<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude')#</label>
			<div class="radio-group">
				<label class="radio"><input type="radio" name="mobileExclude" value="0" checked<!---<cfif rc.contentBean.getMobileExclude() eq 0> selected</cfif>--->>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.always')#</label>
				<label class="radio"><input type="radio" name="mobileExclude" value="2"<cfif rc.contentBean.getMobileExclude() eq 2> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.mobile')#</label>
				<label class="radio"><input type="radio" name="mobileExclude" value="1"<cfif rc.contentBean.getMobileExclude() eq 1> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.standard')#</label>
			</div>
		</div>

		<div class="mura-control-group">
	     	<label for="Target" class="checkbox">
	     	<input  name="target" id="Target" type="CHECKBOX" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" >
		    		<span data-toggle="popover" title="" data-placement="right"
			    		data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow"))#"
			    		data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.newWindow"))#"
			    		>
			     		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#
			     		 <i class="mi-question-circle"></i>
	     	</label>
		</div> <!--- /end mura-control-group --->

		<div class="mura-control-group">
				 <label for="searchExclude" class="checkbox"><input name="searchExclude" id="searchExclude" type="CHECKBOX" value="1" <cfif rc.contentBean.getSearchExclude() eq "">checked <cfelseif rc.contentBean.getSearchExclude() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchexclude')#</label>
		</div> <!--- /end mura-control-group --->

		<div class="mura-control-group">
		    <label>
		    	<span data-toggle="popover" title="" data-placement="right"
			    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate"))#"
			    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.releasedate"))#"
			    	>
	      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#
		      	 <i class="mi-question-circle"></i>
	      	</label>
	      	<cf_datetimeselector name="releaseDate" datetime="#rc.contentBean.getReleaseDate()#">
		</div> <!--- /end mura-control-group --->
	</cfif>

	<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>

		<cfif rc.parentBean.getType() neq 'Calendar'>
			<cfinclude template="dsp_displaycontent.cfm">
		</cfif>
		<cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
			<div class="mura-control-group">
	      		<label>
		  			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#:
		  			<span id="mover1" class="text">
		  				<cfif arrayLen(rc.crumbData) gt 1>
			      			<cfif rc.contentBean.getIsNew()>
			      				"#rc.crumbData[1].menutitle#"<cfelse>"#rc.crumbData[2].menutitle#"
		  					</cfif>
		  				</cfif>
						<button id="selectParent" name="selectParent" class="btn">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent')#
						</button>
					</span>
			    <span id="mover2" style="display:none"><input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#"></span>
      			</label>
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

			</div> <!--- /end mura-control-group --->
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
		<div class="mura-control-group">
			<label>
	      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')#
	      	</label>
	     	<cf_datetimeselector name="expires" datetime="#rc.contentBean.getExpires()#" defaulthour="23" defaultminute="59">
			<div class="mura-control justify" id="expires-notify">
				<label for="dspexpiresnotify" class="checkbox">
					<input type="checkbox" name="dspExpiresNotify" id="dspexpiresnotify" onclick="siteManager.loadExpiresNotify('#esapiEncode('javascript',rc.siteid)#','#esapiEncode('javascript',rc.contenthistid)#','#esapiEncode('javascript',rc.parentid)#');"  class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expiresnotify')#
				</label>
			</div>
		</div> <!--- /end mura-control-group --->
		<div class="mura-control-group" id="selectExpiresNotify" style="display: none;"></div>
	</cfif>

	<cfif not listFindNoCase('Component,Form,Variation',rc.type) and rc.contentid neq '00000000000000000000000000000000001'>
		<div class="mura-control-group">
			 <label>
			     	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isfeature')#
			</label>
	    	<select name="isFeature" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editFeatureDates',true):toggleDisplay2('editFeatureDates',false);">
				<option value="0"  <cfif  rc.contentBean.getisfeature() EQ 0> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
				<option value="1"  <cfif  rc.contentBean.getisfeature() EQ 1> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
				<option value="2"  <cfif rc.contentBean.getisfeature() EQ 2> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perschedule')#</option>
			</select>
		</div>
		<div id="editFeatureDates" <cfif rc.contentBean.getisfeature() NEQ 2>style="display: none;"</cfif>>
			<div class="mura-control-group">
				<label class="date-span">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.from')#</label>
					<cf_datetimeselector name="featureStart" datespanclass="time" datetime="#rc.contentBean.getFeatureStart()#">
			</div>
			<div class="mura-control-group">
					<label class="date-span">
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.to')#
					</label>
					<cf_datetimeselector name="featureStop" datespanclass="time" datetime="#rc.contentBean.getFeatureStop()#" defaulthour="23" defaultminute="59">
			</div>
		</div>
	</cfif>

	<div class="mura-control-group">
   		<label for="dspnotify" class="checkbox">
      		<input type="checkbox" name="dspNotify"  id="dspnotify" onclick="siteManager.loadNotify('#esapiEncode('javascript',rc.siteid)#','#esapiEncode('javascript',rc.contentid)#','#esapiEncode('javascript',rc.parentid)#');"  class="checkbox">
			<span data-toggle="popover" title="" data-placement="right"
				data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview"))#"
				data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.notifyforreview"))#">
  			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreview')#
	      		 <i class="mi-question-circle"></i>
			 </span>
      	</label>
		<div id="selectNotify" class="mura-control justify" style="display: none;"></div>
	</div> <!--- /end mura-control-group --->

	<div class="mura-control-group">
		<label>
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addnotes')#
		</label>
		<textarea name="notes" rows="8" id="abstract">#esapiEncode('html',rc.contentBean.getNotes())#</textarea>
	</div> <!--- /end mura-control-group --->

   <span id="extendset-container-publishing" class="extendset-container"></span>

   <span id="extendset-container-tabpublishingbottom" class="extendset-container"></span>

		</div> <!--- /.block-content --->
	</div> <!--- /.block --->
</div> <!--- /.tab-pane --->
</cfoutput>
