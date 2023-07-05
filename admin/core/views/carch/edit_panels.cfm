<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
<cfoutput>
	<div class="mura__edit__controls" <cfif not $.event('compactDisplay')>style="width: #cookie.ADMINCONTROLWIDTH#px"</cfif>>
		<!--- accordion panels --->
		<div class="mura__edit__controls__scrollable">

			<!--- todo: rb key for placeholder --->
			<!--- filter settings --->
			<div id="mura__edit__settings__filter">
	  		<input type="text" class="form-control" id="mura__edit__settings__filter__input" placeholder="Type to Find Settings">
			</div>
			<!--- settings --->
			<div class="mura__edit__controls__objects">
				<div id="mura-edit-tabs" class="mura__edit__controls__tabs">

					<div class="mura-panel-group" id="content-panels" role="tablist" aria-multiselectable="true">

						<!--- basic --->
						<cfif rc.type eq "Form">
							<cfif rc.contentBean.getIsNew() and not (isdefined("url.formType") and url.formType eq "editor")>
								<cfset rc.contentBean.setBody( application.serviceFactory.getBean('formBuilderManager').createJSONForm( rc.contentBean.getContentID() ) ) />
							</cfif>
							<cfif isJSON(rc.contentBean.getBody())>
								<cfinclude template="form/dsp_panel_formbuilder.cfm">
							<cfelse>
								<cfinclude template="form/dsp_panel_basic.cfm">
								<cfinclude template="form/dsp_panel_summary.cfm">
								<cfinclude template="form/dsp_panel_assocfile.cfm">
							</cfif>
						<cfelse>
							<cfinclude template="form/dsp_panel_basic.cfm">
							<cfinclude template="form/dsp_panel_summary.cfm">
							<cfinclude template="form/dsp_panel_assocfile.cfm">
						</cfif>
						<!--- /basic --->

						<!--- publishing --->
						<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Publishing')>
								<cfinclude template="form/dsp_panel_publishing.cfm">
						</cfif>
						<!--- /publishing --->

						<!--- scheduling --->
						<!--- todo: add Scheduling to tab assignments list, change value here --->
						<cfif (not len(tabAssignments) or listFindNocase(tabAssignments,'Publishing')) and rc.contentBean.getcontentID() neq '00000000000000000000000000000000001'>
								<cfinclude template="form/dsp_panel_scheduling.cfm">
						</cfif>
						<!--- /scheduling --->

						<!--- layoutobjects,categories,related_content,tags,usage --->
						<cfswitch expression="#rc.type#">
							<cfcase value="Page,Folder,Calendar,Gallery">
								<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Layout & Objects'))>
									<cfif listFind(session.mura.memberships,'S2IsPrivate')>
										<cfinclude template="form/dsp_panel_layoutobjects.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content'))>
									<cfinclude template="form/dsp_panel_related_content.cfm">
								<cfelse>
									<input type="hidden" name="ommitRelatedContentTab" value="true">
								</cfif>
							</cfcase>
							<cfcase value="Link,File">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteid)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content'))>
									<cfinclude template="form/dsp_panel_related_content.cfm">
								<cfelse>
									<input type="hidden" name="ommitRelatedContentTab" value="true">
								</cfif>
							</cfcase>
							<cfcase value="Variation">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
							</cfcase>
							<cfcase value="Component">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and (not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report'))>
									<cfif not rc.contentBean.getIsNew()>
										<cfinclude template="form/dsp_panel_usage.cfm">
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="Form">
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
									<cfif application.categoryManager.getCategoryCount(rc.siteID)>
										<cfinclude template="form/dsp_panel_categories.cfm">
									</cfif>
								</cfif>
								<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
									<cfinclude template="form/dsp_panel_tags.cfm">
								</cfif>
								<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and (not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report'))>
									<cfif not rc.contentBean.getIsNew()>
										<cfinclude template="form/dsp_panel_usage.cfm">
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
						<!--- /layoutobjects,categories,related_content,tags,usage  --->

						<!--- extended attributes --->
						<cfif listFindNoCase(rc.$.getBean('contentManager').ExtendableList,rc.type)>
							<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Extended Attributes')>
								<cfset extendSets=application.classExtensionManager.getSubTypeByName(rc.type,rc.contentBean.getSubType(),rc.siteid).getExtendSets(inherit=true, activeOnly=true) />
								<cfif arrayLen(extendSets)>
									<cfinclude template="form/dsp_panel_extended_attributes.cfm">
								</cfif>
							</cfif>
						</cfif>
						<!--- /extended attributes --->

						<!--- Remote --->
						<!--- todo: change "advanced" to "remote" in other locations --->
						<cfif (rc.type neq 'Component' and rc.type neq 'Form') and rc.contentBean.getcontentID() neq '00000000000000000000000000000000001'>
							<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Remote')>
								<cfif listFind(session.mura.memberships,'S2IsPrivate')>
									<cfinclude template="form/dsp_panel_Remote.cfm">
								<cfelse>
									<!--- todo correct "ommit" --> "omit" --->
									<input type="hidden" name="ommitRemoteTab" value="true">
								</cfif>
							</cfif>
						</cfif>
						<!--- /Remote --->

						<!--- plugin rendering --->
						<cfif arrayLen(pluginEventMappings)>
							<cfoutput>
								<cfset renderedEvents = '' />
								<cfset eventIdx = 0 />
								<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
									<cfset eventToRender = pluginEventMappings[i].eventName />

									<cfif ListFindNoCase(renderedEvents, eventToRender)>
										<cfset eventIdx++ />
									<cfelse>
										<cfset renderedEvents = ListAppend(renderedEvents, eventToRender) />
										<cfset eventIdx=1 />
									</cfif>

									<cfset renderedEvent=$.getBean('pluginManager').renderEvent(eventToRender=eventToRender,currentEventObject=$,index=eventIdx)>
									<cfif len(trim(renderedEvent))>
										<cfset tabLabel = Len($.event('tabLabel')) and !ListFindNoCase(tabLabelList, $.event('tabLabel')) ? $.event('tabLabel') : pluginEventMappings[i].pluginName />
										<cfset tabLabelList=listAppend(tabLabelList, tabLabel)/>
										<cfset tabID="tab" & $.createCSSID(tabLabel)>
										<cfif ListFind(tabList,tabID)>
											<cfset tabID = tabID & i />
										</cfif>
										<cfset pluginEvent.setValue("tabList",tabLabelList)>
										<div class="mura-panel panel">
											<div class="mura-panel-heading" role="tab" id="heading-#tabID#">
												<h4 class="mura-panel-title">
													<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-#tabID#" aria-expanded="false" aria-controls="panel-#tabID#">#tablabel#</a>
												</h4>
											</div>
											<div id="panel-#tabID#" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-#tabID#" aria-expanded="false" style="height: 0px;">
												<div class="mura-panel-body">
													#renderedEvent#
												</div>
											</div>
										</div>
									</cfif>
								</cfloop>
							</cfoutput>
						</cfif>
						<!--- /plugin rendering --->
					</div>	<!--- /.mura__edit__controls__scrollable --->

				</div>
			</div>
		</div>
	</div>

</cfoutput>

<script type="text/javascript">
$(document).ready(function(){

	// custom case-insensitive :contains method
    $.expr[":"].contains = $.expr.createPseudo(function (arg) {
        return function (elem) {
            return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
        };
    });

	// open tab via url hash
	if(window.location.hash.substring(1,7) == 'panel-'){
		$('.mura-panel-heading a[href$="' + window.location.hash + '"]').trigger('click');
		window.location.hash = "";
	}

	// filter settings in side panels
	filterSettings=function(fstr){

		// minimum string length for action
		if(fstr.length > 2){

			// if matching a panel name
			$("#content-panels a.collapse:contains('" + fstr + "')").each(function(){
				if ($(this).parents('.mura-panel.panel').has('.panel-collapse.collapse.in').length == 0){
					$(this).parents('.mura-panel.panel').siblings('.mura-panel.panel').has('.panel-collapse.collapse.in').find('a.collapse').trigger('click');
					$(this).trigger('click');
				}
			});

			// also match contents
			$("#content-panels .mura-panel label:contains('" + fstr + "')").addClass('control-matched').parents('.mura-control-group').addClass('control-matched');
				if ($('#content-panels .panel-collapse.collapse.in').length == 0){
					$('.mura-control-group.control-matched').parents('.mura-panel.panel').find('a.collapse').trigger('click');
				}

		// reset on short length
		} else {
			$("#content-panels .panel-collapse.collapse").collapse("hide","fast");
			$('#content-panels .mura-panel .control-matched').removeClass('control-matched');
		}
	}

	// apply filter by typing, with delay
	$("#mura__edit__settings__filter__input").keyup(function(){
		var timeout = null;
		clearTimeout(timeout);
	    timeout = setTimeout(function () {
			var filterStr = $("#mura__edit__settings__filter__input").val();
				//	console.log(filterStr);
					filterSettings(filterStr)	;
	    }, 500);
	});

	// focus on input filter on page load
	<cfif not $.content().getIsNew()>
	setTimeout(function () {
		$("#mura__edit__settings__filter__input").focus();
	 }, 500);
	</cfif>

});
</script>
