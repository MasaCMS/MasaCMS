
		<cfset bydate=iif(rc.contentBean.getdisplay() EQ 2 or (rc.ptype eq 'Calendar' and rc.contentBean.getIsNew()),de('true'),de('false'))>
		<cfoutput>
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#
	      		 <i class="icon-question-sign"></i></a>
	      	</label>
	      	<div class="controls">
	      		<select name="display" class="span3" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
					<option value="1"  <cfif  rc.contentBean.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
					<option value="0"  <cfif  rc.contentBean.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
					<option value="2"  <cfif  bydate> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
				</select>
			</div>
			<div id="editDates" <cfif  not bydate>style="display: none;"</cfif>>
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</label>
					<div class="controls">
						<cf_datetimeselector name="displayStart" datetime="#rc.contentBean.getDisplayStart()#">
					</div>			
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<cf_datetimeselector name="displayStop" datetime="#rc.contentBean.getDisplayStop()#" defaulthour="23" defaultminute="59">
					</div>
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval')#
					</label>
					<div class="controls">
						<select name="displayInterval" class="span2">
							<cfloop list="Daily,Weekly,Bi-Weekly,Monthly,WeekDays,WeekEnds,Week1,Week2,Week3,Week4,WeekLast,Yearly" index="i">
							<option value="#i#"<cfif rc.contentBean.getDisplayInterval() eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
							</cfloop>
						</select>
					</div>
				</div>
			</div>
			</cfoutput>