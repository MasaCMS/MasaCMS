<!---
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

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfcomponent extends="mura.cfobject">

	<!---
			This is the THEME contentsiteRenderer.cfc

			* Add theme-specific methods here
			* Any methods here will be accessible with the following notation:
				$.yourFunctionName()
	--->

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="$" hint="mura scope" />
		<cfscript>
			var siteRenderer = arguments.$.getSiteRenderer();

			// general vars
			siteRenderer.jsLib = 'jquery';
			siteRenderer.jsLibLoaded = true;
			siteRenderer.generalWrapperClass = 'well';
			
			// headings
			siteRenderer.headline = 'h1';
			siteRenderer.subHead1 = 'h2';
			siteRenderer.subHead2 = 'h3';
			siteRenderer.subHead3 = 'h4';
			siteRenderer.subHead4 = 'h5';

			// nav and list item vars
			siteRenderer.navWrapperClass = 'well';
			siteRenderer.liHasKidsClass = '';
			siteRenderer.liHasKidsCustomString = '';
			siteRenderer.liCurrentClass = 'active';
			siteRenderer.liCurrentCustomString = '';
			siteRenderer.aHasKidsClass = '';
			siteRenderer.aHasKidsCustomString = '';
			siteRenderer.aCurrentClass = 'active';
			siteRenderer.aCurrentCustomString = '';
			siteRenderer.ulTopClass = 'nav nav-list';
			siteRenderer.ulNestedClass = 'nav nav-list';
			siteRenderer.ulNestedCustomString = '';
			siteRenderer.liNestedClass = '';

			// pagination vars
			siteRenderer.ulPaginationClass = 'pagination';
			siteRenderer.ulPaginationWrapperClass = 'pagination';

			// form vars
			siteRenderer.formWrapperClass = 'well';
			
			// Display Objects
			// Use these variables to pass-in specific classes without having to create custom versions
			
			// calendar/dsp_showMonth.cfm
			siteRenderer.calendarWrapperClass="";
			siteRenderer.calendarTableClass="table table-bordered";
			//siteRenderer.calendarTableHeaderClass="";
			
			// calendar/dspList.cfm
			siteRenderer.calendarListWrapperClass="";
			
			// comments/index.cfm
			siteRenderer.commentsWrapperClass="";
			siteRenderer.commentFormWrapperClass="well";
			siteRenderer.commentFormClass="form-horizontal";
			siteRenderer.commentNewClass="btn btn-default";
			siteRenderer.commentFieldWrapperClass="form-group";
			siteRenderer.commentFieldLabelClass="control-label col-lg-3";
			siteRenderer.commentInputWrapperClass="col-lg-9";
			siteRenderer.commentInputClass="form-control";
			siteRenderer.commentCheckboxClass="checkbox";
			siteRenderer.commentPrefsInputWrapperClass="col-lg-offset-3 col-lg-9";
			siteRenderer.commentSubmitButtonWrapperClass="col-lg-offset-3 col-lg-9";
			siteRenderer.commentSubmitButtonClass="btn btn-default";
			siteRenderer.commentRequiredWrapperClass="col-lg-offset-3 col-lg-9";
			//siteRenderer.commentUserEmailClass="";
			//siteRenderer.commentDeleteButtonClass="";
			
			// comments/dsp_comment.cfm
		 	siteRenderer.emailLinkClass="btn btn-default";
			siteRenderer.commentsLinkClass="btn btn-default";
			siteRenderer.approveCommentLinkClass="btn btn-default";
			siteRenderer.deleteCommentLinkClass="btn btn-default";
			
			// datacollection/dsp_response.cfm
			siteRenderer.datacollectionErrorPClass="alert alert-danger";
			siteRenderer.datacollectionErrorDivClass="alert alert-danger";
			siteRenderer.datacollectionSuccessPClass="alert alert-success";
			
			// dataresponses/dsp_detail.cfm
			siteRenderer.dataResponseListClass="dl-horizontal";
			
			// dataresponses/dsp_list.cfm
			siteRenderer.dataResponseTableClass="table table-hover";
			siteRenderer.dataResponsePaginationClass="pagination";
			
			// draggablefeeds/index.cfm
			siteRenderer.draggableBoxWrapperClass="row";
			siteRenderer.draggableBoxHeaderClass="col-lg-12";
			siteRenderer.draggableBoxRSSWrapperClass="";
			siteRenderer.draggableBoxHeaderButtonClass="btn btn-default";
			//siteRenderer.draggableBoxRSSeditFormClass="";
			siteRenderer.draggableBoxAddFeedWrapperClass="well clearfix";
			siteRenderer.draggableBoxNewFeedFormClass="form-horizontal";
			siteRenderer.draggableBoxSelectFeedWrapperClass="col-lg-6";
			siteRenderer.draggableBoxSelectFeedRowClass="row";
			siteRenderer.draggableBoxSelectFeedMenuClass="form-group";
			siteRenderer.draggableBoxSelectFeedMenuDivClass="col-lg-10";
			siteRenderer.draggableFeedMenuSelectFieldClass="form-control";
			siteRenderer.addFeedButtonWrapperDivClass="form-group";
			siteRenderer.addFeedButtonWrapperDivInnerClass="col-lg-2";
			siteRenderer.addFeedButtonClass="btn btn-default";
			
			// dsp_categories_nest.cfm
			siteRenderer.categoriesNestCheckboxClass="checkbox";
			
			// dsp_content_list.cfm
			siteRenderer.contentListImageStyles=true;
			siteRenderer.contentListPropertyMap={
											containerEl={tag="div"},
											itemEl={tag="dl"},
											labelEl={tag="span"},
											title={tag="dt"},
											date={tag="dt"},
											credits={tag="dd",showLabel=true,rbkey="list.by"},
											tags={tag="dd",showLabel=true,labelDelim=":",rbkey="tagcloud.tags"},
											rating={tag="dd",showLabel=true,labelDelim=":",rbkey="list.rating"},
											'default'={tag="dd"}
										};
			siteRenderer.contentListWrapperDivClass="";
			siteRenderer.contentListItemImageLinkClass="";
			
			// dsp_folder.cfm
			siteRenderer.folderWrapperClass="";
			
			// dsp_edit_profile.cfm
			siteRenderer.editProfileWrapperClass="";
			siteRenderer.editProfileFormClass="form-horizontal";
			siteRenderer.editProfileFormGroupWrapperClass="form-group";
			siteRenderer.editProfileFieldLabelClass="control-label col-lg-3";
			siteRenderer.editProfileFormFieldsWrapperClass="col-lg-9";
			siteRenderer.editProfileFormFieldsClass="form-control";
			siteRenderer.editProfileExtAttributeDownloadClass="col-lg-3";
			siteRenderer.editProfileHelpBlockClass="help-block";
			siteRenderer.editProfileExtAttributeFileWrapperClass="col-lg-offset-3 col-lg-6";
			siteRenderer.editProfileExtAttributeDownloadClass="col-lg-3";
			siteRenderer.editProfileExtAttributeDownloadButtonClass="btn btn-default";
			siteRenderer.editProfileSubmitButtonWrapperClass="col-lg-offset-3 col-lg-9";
			siteRenderer.editProfileSubmitButtonClass="btn btn-primary";
			siteRenderer.editProfileSuccessMessageClass="alert alert-success";
			
			// dsp_email_dropdown.cfm
			siteRenderer.emailDropdownSelectClass="dropdown";
			
			// dsp_event_reminder_form.cfm
			siteRenderer.eventReminderFormWrapperClass="";
			siteRenderer.eventReminderFormClass="well";
			siteRenderer.eventReminderFieldWrapperClass="";
			siteRenderer.eventReminderFormLabelsClass="control-label";
			siteRenderer.eventReminderSubmitClass="btn btn-default";
			
			// dsp_features.cfm
			siteRenderer.featuresWrapperClass="clearfix";
			
			// dsp_feed.cfm
			siteRenderer.localIndexWrapperClass="clearfix";
			siteRenderer.remoteFeedWrapperClass="clearfix";
			
			// dsp_login.cfm
			siteRenderer.loginWrapperClass="";
			siteRenderer.loginWrapperInnerClass="row";
			siteRenderer.loginErrorMessageClass="alert alert-danger";
			siteRenderer.loginFormClass="form-horizontal form-signin";
			siteRenderer.forgotPasswordFormClass="form-horizontal form-sendlogin";
			siteRenderer.loginFormGroupWrapperClass="form-group";
			siteRenderer.loginFormFieldLabelClass="control-label col-lg-3";
			siteRenderer.loginFormFieldWrapperClass="col-lg-9";
			siteRenderer.loginFormFieldClass="form-control";
			siteRenderer.loginFormPrefsClass="col-lg-offset-3 col-lg-10";
			siteRenderer.loginFormCheckboxClass="checkbox";
			siteRenderer.loginFormSubmitWrapperClass="col-lg-offset-3 col-lg-10";
			siteRenderer.loginFormSubmitClass="btn btn-default";
			siteRenderer.loginFormAlertClass="alert alert-success";
			siteRenderer.loginFormErrorClass="alert alert-danger";
			siteRenderer.notRegisteredLinkClass="btn btn-primary";
			
			// dsp_mailing_list_master.cfm
			siteRenderer.mailingListWrapperClass="well";
			siteRenderer.mailingListSuccessClass="alert alert-success";
			siteRenderer.mailingListErrorClass="alert alert-error";
			siteRenderer.mailingListFormClass="form-horizontal";
			siteRenderer.mailingListFormGroupWrapperClass="form-group";
			siteRenderer.mailingListFormLabelClass="control-label col-lg-2";
			siteRenderer.mailingListFormFieldWrapperClass="col-lg-10";
			siteRenderer.mailingListFormInputClass="text form-control";
			siteRenderer.mailingListCheckboxWrapperClass="col-lg-offset-2 col-lg-10";
			siteRenderer.mailingListCheckboxClass="checkbox";
			siteRenderer.mailingListSubmitWrapperClass="col-lg-offset-2 col-lg-10";
			siteRenderer.mailingListSubmitClass="submit btn btn-default";
			
			// dsp_nextN.cfm
			siteRenderer.nextNWrapperClass="";
			siteRenderer.nextNInnerClass="row";
			
			// dsp_search_form.cfm
			siteRenderer.searchFormClass="navbar-form";
			siteRenderer.searchFormInputWrapperClass="input-group";
			siteRenderer.searchFormInputClass="form-control";
			siteRenderer.searchFormSubmitWrapperClass="input-group-btn";
			siteRenderer.searchFormSubmitClass="btn btn-default fa fa-search";
			
			// dsp_search_results.cfm
			siteRenderer.searchResultWrapperClass="";
			siteRenderer.searchResultInnerClass="row";
			siteRenderer.searchResultsRowClass="row";
			siteRenderer.searchResultsMoreResultsRowClass="row";
			siteRenderer.searchReultsListClass="";
			siteRenderer.searchReultsPagerClass="pager";
			siteRenderer.searchAgainRowClass="row";
			siteRenderer.searchAgainInnerClass="col-md-8";
			siteRenderer.searchAgainFormClass="navbar-form";
			siteRenderer.searchAgainInputWrapperClass="input-group";
			siteRenderer.searchAgainFormInputClass="form-control";
			siteRenderer.searchAgainButtonWrapperClass="input-group-btn";
			siteRenderer.searchAgainSubmitClass="btn btn-default";
			
			// dsp_user_tools.cfm
			siteRenderer.userToolsLoginWrapperClass="well clearfix";
			siteRenderer.userToolsLoginFormClass="form-horizontal";
			siteRenderer.userToolsFormGroupWrapperClass="form-group";
			siteRenderer.userToolsLoginFormLabelClass="control-label col-lg-2";
			siteRenderer.userToolsLoginFormInputWrapperClass="col-lg-10";
			siteRenderer.userToolsLoginFormInputClass="form-control";
			siteRenderer.userToolsLoginFormFieldInnerClass="col-lg-offset-2 col-lg-10";
			siteRenderer.userToolsLoginFormCheckboxClass="checkbox";
			siteRenderer.userToolsLoginFormSubmitClass="btn btn-default";
			siteRenderer.userToolsNotRegisteredLinkClass="btn btn-primary";
			siteRenderer.userToolsWrapperClass="clearfix";
			siteRenderer.userToolsEditProfileLinkClass="btn btn-default fa fa-user";
			siteRenderer.userToolsLogoutLinkClass="btn btn-default fa fa-sign-out";
			
			// formbuilder/dsp_form.cfm
			siteRenderer.formBuilderFieldWrapperClass="form-group";
			siteRenderer.formBuilderButtonWrapperClass="form-actions buttons";
			siteRenderer.formBuilderSubmitClass="btn btn-default";
			
			// formbuilder/fields/dsp_checkbox.cfm
			// formbuilder/fields/dsp_dropdown.cfm 
			// formbuilder/fields/dsp_file.cfm
			// formbuilder/fields/dsp_radio.cfm
			// formbuilder/fields/dsp_textfield.cfm
			
			siteRenderer.formBuilderFormFieldsClass="form-control";
			
			// formbuilder/fields/field_dropdown.cfm
			siteRenderer.formBuilderTabHeaderClass="dropdown";
			siteRenderer.formBuilderDisabledInputClass="disabled";
			siteRenderer.formBuilderCheckboxClass="checkbox";
			
			// gallery/index.cfm
			siteRenderer.galleryWrapperClass="";
			siteRenderer.galleryULClass="clearfix";
			siteRenderer.galleryThumbnailClass="thumbnail";
			
			// nav/calendarNav/index.cfm
			siteRenderer.navCalendarWrapperClass="";
			
			// nav/calendarNav/navTools.cfc
			siteRenderer.navCalendarTableClass="table table-bordered";
			
			// nav/dsp_sequential.cfm
			siteRenderer.navSequentialWrapperClass="";
			siteRenderer.navSequentialInnerClass="row";
			
			// nav/dsp_tag_cloud.cfm
			siteRenderer.tagCloudWrapperClass="";
			
			// navArchive
			//siteRenderer.navArchiveWrapperClass="";
			//siteRenderer.navArchiveListClass="";
			
			
			// rater/index.cfm
			siteRenderer.raterObjectWrapperClass="row clearfix";
			siteRenderer.raterWrapperClass="col-lg-12";
			siteRenderer.avgRatingWrapperClass="col-lg-12";
			
			// sendToLink/SendLink.cfm
			siteRenderer.sendToFriendSuccessClass="alert alert-success";
			siteRenderer.sendToFriendErrorClass="alert alert-danger";
			
			// Generic form vars
			siteRenderer.formWrapperClass = "";

			return this;
		</cfscript>
	</cffunction>

	<cffunction name="dspCarouselByFeedName" output="false">
		<cfargument name="feedName" type="string" default="Slideshow" />
		<cfargument name="showCaption" type="boolean" default="true" />
		<cfargument name="cssID" type="string" default="myCarousel" />
		<cfargument name="size" type="string" default="custom" hint="If you want to use a custom height/width, then use 'custom' ... otherwise, you can use 'small, medium, large' OR any other predefined custom image size 'name' you created via the back-end administrator." />
		<cfargument name="width" type="numeric" default="1280" hint="width in pixels" />
		<cfargument name="height" type="numeric" default="500" hint="height in pixels" />
		<cfargument name="interval" type="any" default="5000" hint="Use either milliseconds OR use 'false' to NOT auto-advance to next slide." />
		<cfargument name="autoStart" type="boolean" default="true" />
		<cfargument name="showIndicators" type="boolean" default="true" />
		<cfscript>
			var local = {};
			local.imageArgs = {};

			if ( not ListFindNoCase('small,medium,large,custom', arguments.size) and variables.$.getBean('imageSize').loadBy(name=arguments.size,siteID=variables.$.event('siteID')).getIsNew() ) {
				arguments.size = 'custom';
			};

			if ( not Len(Trim(arguments.size)) or LCase(arguments.size) eq 'custom' ) {
				local.imageArgs.width = Val(arguments.width);
				local.imageArgs.height = Val(arguments.height);
			} else {
				local.imageArgs.size = arguments.size;
			};
		</cfscript>
		<cfsavecontent variable="local.str"><cfoutput>
			<!--- BEGIN: Bootstrap Carousel --->
			<!--- IMPORTANT: This will only output items that have associated images --->
			<cfset local.feed = variables.$.getBean('feed').loadBy(name=arguments.feedName)>
			<cfset local.iterator = local.feed.getIterator()>
			<cfif local.feed.getIsNew()>
				<div class="container">
					<div class="alert alert-info alert-block">
						<button type="button" class="close" data-dismiss="alert"><i class="fa fa-remove"></i></button>
						<h4>Ooops!</h4>
						The <strong>#HTMLEditFormat(arguments.feedName)#</strong> Content Collection/Local Index does not exist.
					</div>
				</div>
			<cfelseif local.iterator.hasNext()>
				<div id="#arguments.cssID#" class="carousel slide" data-interval="#arguments.interval#">

					<!--- Indicators --->
					<cfif arguments.showIndicators>
						<ol class="carousel-indicators">
							<cfset local.iterator.reset()>
							<cfset local.idx = 0>
							<cfloop condition="local.iterator.hasNext()">
								<cfset local.item=iterator.next()>
								<cfif ListFindNoCase('jpg,jpeg,gif,png', ListLast(local.item.getImageURL(), '.'))>
									<li data-target="###arguments.cssID#" data-slide-to="#idx#" class="<cfif local.idx eq 0>active</cfif>"></li>
									<cfset local.idx++>
								</cfif>
							</cfloop>
						</ol>
					</cfif>

					<!--- Wrapper for slides --->
					<div class="row carousel-inner">
						<cfset local.iterator.reset()>
						<cfset local.idx = 0>
						<cfloop condition="local.iterator.hasNext()">
							<cfset local.item=iterator.next()>
							<cfif ListFindNoCase('jpg,jpeg,gif,png', ListLast(local.item.getImageURL(), '.'))>
								<div class="row item<cfif local.idx eq 0> active</cfif>">
									<img src="#local.item.getImageURL(argumentCollection=local.imageArgs)#" alt="#HTMLEditFormat(local.item.getTitle())#">
									<cfif arguments.showCaption>
										<div class="container">
											<div class="carousel-caption">
												<h3><a href="#local.item.getURL()#">#HTMLEditFormat(local.item.getTitle())#</a></h3>
												#local.item.getSummary()#
												<p><a class="btn btn-larg btn-primary" href="#local.item.getURL()#">Read More</a></p>
											</div>
										</div>
									</cfif>
								</div>
								<cfset local.idx++>
							</cfif>
						</cfloop>
					</div>

					<cfif local.idx>
						<!--- Controls --->
						<cfif local.idx gt 1>
							<a class="left carousel-control" href="###arguments.cssID#" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
							<a class="right carousel-control" href="###arguments.cssID#" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
							<!--- AutoStart --->
							<cfif arguments.autoStart>
								<script>jQuery(document).ready(function($){$('###arguments.cssID#').carousel({interval:#arguments.interval#});});</script>
							</cfif>
						</cfif>
					<cfelse>
						<div class="alert alert-info alert-block">
							<button type="button" class="close" data-dismiss="alert"><i class="fa fa-remove"></i></button>
							<h4>Oh snap!</h4>
							Your feed has no items <em>with images</em>.
						</div>
					</cfif>
				</div>
			<cfelse>
				<div class="alert alert-info alert-block">
					<button type="button" class="close" data-dismiss="alert"><i class="fa fa-remove"></i></button>
					<h4>Heads up!</h4>
					Your feed has no items.
				</div>
			</cfif>
			<!--- // END: Bootstrap Carousel --->
		</cfoutput></cfsavecontent>
		<cfreturn local.str />
	</cffunction>

</cfcomponent>