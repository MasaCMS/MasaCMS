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
			This is the THEME contentRenderer.cfc

			* Add theme-specific methods here
			* Any methods here will be accessible with the following notation:
				$.yourFunctionName()
	--->

	<cfscript>
		// general vars
		this.jsLib = 'jquery';
		this.jsLibLoaded = true;
		this.generalWrapperClass = 'well';
		
		// headings
		this.headline = 'h1';
		this.subHead1 = 'h2';
		this.subHead2 = 'h3';
		this.subHead3 = 'h4';
		this.subHead4 = 'h5';

		// nav and list item vars
		this.navWrapperClass = 'well';
		this.liHasKidsClass = '';
		this.liHasKidsCustomString = '';
		this.liCurrentClass = 'active';
		this.liCurrentCustomString = '';
		this.aHasKidsClass = '';
		this.aHasKidsCustomString = '';
		this.aCurrentClass = 'active';
		this.aCurrentCustomString = '';
		this.ulTopClass = 'nav nav-list';
		this.ulNestedClass = 'nav nav-list';
		this.ulNestedCustomString = '';
		this.liNestedClass = '';

		// pagination vars
		this.ulPaginationClass = 'pagination';
		this.ulPaginationWrapperClass = 'pagination';

		// form vars
		this.formWrapperClass = 'well';
		
		// alerts
		this.alertSuccessClass = "alert alert-success";
		this.alertInfoClass = "alert alert-info";
		this.alertWarningClass = "alert alert-warning";
		this.alertDangerClass = "alert alert-danger";
		
		// Display Objects
		// Use these variables to pass-in specific classes without having to create custom versions
		
		// calendar/dsp_showMonth.cfm
		this.calendarWrapperClass="";
		this.calendarTableClass="table table-bordered";
		//this.calendarTableHeaderClass="";
		
		// calendar/dspList.cfm
		this.calendarListWrapperClass="";
		
		// comments/index.cfm
		 this.commentsWrapperClass="";
		 this.commentSortContainerClass="row";
		 this.commentSortWrapperClass="col-xs-5";
		 this.commentSortSelectClass="form-control";
		 this.commentFormWrapperClass="well";
		 this.commentFormClass="";
		 this.commentNewClass="";
		 this.commentFieldWrapperClass="form-group";
		 this.commentFieldLabelClass="control-label";
		 this.commentInputWrapperClass="";
		 this.commentInputClass="form-control";
		 this.commentCheckboxClass="";
		 this.commentPrefsInputWrapperClass="";
		 this.commentSubmitButtonWrapperClass="";
		 this.commentSubmitButtonClass="btn btn-default";
		 this.commentMoreCommentsUpClass="btn btn-default icon-arrow-up"
		 this.commentMoreCommentsDownClass="btn btn-default icon-arrow-down"
		 this.commentRequiredWrapperClass="";
		 this.commentThumbClass="img-thumbnail";
		 this.commentSpamClass="";
		 this.commentSpamLinkClass="";
		 this.commentClass="";
		 this.commentDateTimeClass="";
		 this.commentReplyClass="";
		 this.commentAwaitingApproval=""; //
	 
		 
		 // !!! These need to have deafult styles in mura.6.1.css since no guarantee of BS3 loaded?
		 this.commentAdminButtonWrapperClass="btn-group pull-right"
		 this.commentUserEmailClass="btn btn-default btn-sm";
		 this.commentDeleteButtonClass="btn btn-default btn-sm";
		 this.commentEditButtonClass="btn btn-default btn-sm";
		 this.commentApproveButtonClass="btn btn-default btn-sm";	
		 	
		// comments/dsp_comment.cfm
	 	this.emailLinkClass="btn btn-default";
		this.commentsLinkClass="btn btn-default";
		this.approveCommentLinkClass="btn btn-default";
		this.deleteCommentLinkClass="btn btn-default";
		
		// datacollection/dsp_response.cfm
		this.datacollectionErrorPClass="alert alert-danger";
		this.datacollectionErrorDivClass="alert alert-danger";
		this.datacollectionSuccessPClass="alert alert-success";
		
		// dataresponses/dsp_detail.cfm
		this.dataResponseListClass="dl-horizontal";
		
		// dataresponses/dsp_list.cfm
		this.dataResponseTableClass="table table-hover";
		this.dataResponsePaginationClass="pagination";
		
		// draggablefeeds/index.cfm
		this.draggableBoxWrapperClass="row";
		this.draggableBoxHeaderClass="col-lg-12";
		this.draggableBoxRSSWrapperClass="";
		this.draggableBoxHeaderButtonClass="btn btn-default";
		//this.draggableBoxRSSeditFormClass="";
		this.draggableBoxAddFeedWrapperClass="well clearfix";
		this.draggableBoxNewFeedFormClass="form-horizontal";
		this.draggableBoxSelectFeedWrapperClass="col-lg-6";
		this.draggableBoxSelectFeedRowClass="row";
		this.draggableBoxSelectFeedMenuClass="form-group";
		this.draggableBoxSelectFeedMenuDivClass="col-lg-10";
		this.draggableFeedMenuSelectFieldClass="form-control";
		this.addFeedButtonWrapperDivClass="form-group";
		this.addFeedButtonWrapperDivInnerClass="col-lg-2";
		this.addFeedButtonClass="btn btn-default";
		
		// dsp_categories_nest.cfm
		this.categoriesNestCheckboxClass="checkbox";
		
		// dsp_content_list.cfm
		this.contentListImageStyles=true;
		this.contentListPropertyMap={
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
		this.contentListWrapperDivClass="";
		this.contentListItemImageLinkClass="";
		
		// dsp_folder.cfm
		this.folderWrapperClass="";
		
		// dsp_edit_profile.cfm
		this.editProfileWrapperClass="";
		this.editProfileFormClass="form-horizontal";
		this.editProfileFormGroupWrapperClass="form-group";
		this.editProfileFieldLabelClass="control-label col-lg-3";
		this.editProfileFormFieldsWrapperClass="col-lg-9";
		this.editProfileFormFieldsClass="form-control";
		this.editProfileExtAttributeDownloadClass="col-lg-3";
		this.editProfileHelpBlockClass="help-block";
		this.editProfileExtAttributeFileWrapperClass="col-lg-offset-3 col-lg-6";
		this.editProfileExtAttributeDownloadClass="col-lg-3";
		this.editProfileExtAttributeDownloadButtonClass="btn btn-default";
		this.editProfileSubmitButtonWrapperClass="col-lg-offset-3 col-lg-9";
		this.editProfileSubmitButtonClass="btn btn-primary";
		this.editProfileSuccessMessageClass="alert alert-success";
		
		// dsp_email_dropdown.cfm
		this.emailDropdownSelectClass="dropdown";
		
		// dsp_event_reminder_form.cfm
		this.eventReminderFormWrapperClass="";
		this.eventReminderFormClass="well";
		this.eventReminderFieldWrapperClass="";
		this.eventReminderFormLabelsClass="control-label";
		this.eventReminderSubmitClass="btn btn-default";
		
		// dsp_features.cfm
		this.featuresWrapperClass="clearfix";
		
		// dsp_feed.cfm
		this.localIndexWrapperClass="clearfix";
		this.remoteFeedWrapperClass="clearfix";
		
		// dsp_login.cfm
		this.loginWrapperClass="";
		this.loginWrapperInnerClass="row";
		this.loginErrorMessageClass="alert alert-danger";
		this.loginFormClass="form-horizontal form-signin";
		this.forgotPasswordFormClass="form-horizontal form-sendlogin";
		this.loginFormGroupWrapperClass="form-group";
		this.loginFormFieldLabelClass="control-label col-lg-3";
		this.loginFormFieldWrapperClass="col-lg-9";
		this.loginFormFieldClass="form-control";
		this.loginFormPrefsClass="col-lg-offset-3 col-lg-10";
		this.loginFormCheckboxClass="checkbox";
		this.loginFormSubmitWrapperClass="col-lg-offset-3 col-lg-10";
		this.loginFormSubmitClass="btn btn-default";
		this.loginFormAlertClass="alert alert-success";
		this.loginFormErrorClass="alert alert-danger";
		this.notRegisteredLinkClass="btn btn-primary";
		
		// dsp_mailing_list_master.cfm
		this.mailingListWrapperClass="well";
		this.mailingListSuccessClass="alert alert-success";
		this.mailingListErrorClass="alert alert-error";
		this.mailingListFormClass="form-horizontal";
		this.mailingListFormGroupWrapperClass="form-group";
		this.mailingListFormLabelClass="control-label col-lg-2";
		this.mailingListFormFieldWrapperClass="col-lg-10";
		this.mailingListFormInputClass="form-control";
		this.mailingListCheckboxWrapperClass="col-lg-offset-2 col-lg-10";
		this.mailingListCheckboxClass="checkbox";
		this.mailingListSubmitWrapperClass="col-lg-offset-2 col-lg-10";
		this.mailingListSubmitClass="submit btn btn-default";
		
		// dsp_nextN.cfm
		this.nextNWrapperClass="";
		this.nextNInnerClass="row";
		
		// dsp_search_form.cfm
		this.searchFormClass="navbar-form";
		this.searchFormInputWrapperClass="input-group";
		this.searchFormInputClass="form-control";
		this.searchFormSubmitWrapperClass="input-group-btn";
		this.searchFormSubmitClass="btn btn-default fa fa-search";
		
		// dsp_search_results.cfm
		this.searchResultWrapperClass="";
		this.searchResultInnerClass="row";
		this.searchResultsRowClass="row";
		this.searchResultsMoreResultsRowClass="row";
		this.searchResultsListClass="";
		this.searchResultsPagerClass="pager";
		this.searchAgainRowClass="row";
		this.searchAgainInnerClass="col-md-8";
		this.searchAgainFormClass="navbar-form";
		this.searchAgainInputWrapperClass="input-group";
		this.searchAgainFormInputClass="form-control";
		this.searchAgainButtonWrapperClass="input-group-btn";
		this.searchAgainSubmitClass="btn btn-default";
		
		// dsp_user_tools.cfm
		this.userToolsLoginWrapperClass="well clearfix";
		this.userToolsLoginFormClass="form-horizontal";
		this.userToolsFormGroupWrapperClass="form-group";
		this.userToolsLoginFormLabelClass="control-label col-lg-2";
		this.userToolsLoginFormInputWrapperClass="col-lg-10";
		this.userToolsLoginFormInputClass="form-control";
		this.userToolsLoginFormFieldInnerClass="col-lg-offset-2 col-lg-10";
		this.userToolsLoginFormCheckboxClass="checkbox";
		this.userToolsLoginFormSubmitClass="btn btn-default";
		this.userToolsNotRegisteredLinkClass="btn btn-primary";
		this.userToolsWrapperClass="clearfix";
		this.userToolsEditProfileLinkClass="btn btn-default fa fa-user";
		this.userToolsLogoutLinkClass="btn btn-default fa fa-sign-out";
		
		// formbuilder/dsp_form.cfm
		this.formBuilderFieldWrapperClass="form-group";
		this.formBuilderButtonWrapperClass="form-actions buttons";
		this.formBuilderSubmitClass="btn btn-default";
		
		// formbuilder/fields/dsp_checkbox.cfm
		// formbuilder/fields/dsp_dropdown.cfm 
		// formbuilder/fields/dsp_file.cfm
		// formbuilder/fields/dsp_radio.cfm
		// formbuilder/fields/dsp_textfield.cfm
		
		this.formBuilderFormFieldsClass="form-control";
		
		// formbuilder/fields/field_dropdown.cfm
		this.formBuilderTabHeaderClass="dropdown";
		this.formBuilderDisabledInputClass="disabled";
		this.formBuilderCheckboxClass="checkbox";
		
		// gallery/index.cfm
		this.galleryWrapperClass="";
		this.galleryULClass="clearfix";
		this.galleryThumbnailClass="thumbnail";
		
		// nav/calendarNav/index.cfm
		this.navCalendarWrapperClass="";
		
		// nav/calendarNav/navTools.cfc
		this.navCalendarTableClass="table table-bordered";
		
		// nav/dsp_sequential.cfm
		this.navSequentialWrapperClass="";
		this.navSequentialInnerClass="row";
		
		// nav/dsp_tag_cloud.cfm
		this.tagCloudWrapperClass="";
		
		// navArchive
		//this.navArchiveWrapperClass="";
		//this.navArchiveListClass="";
		
		
		// rater/index.cfm
		this.raterObjectWrapperClass="row clearfix";
		this.raterWrapperClass="col-lg-12";
		this.avgRatingWrapperClass="col-lg-12";
		
		// sendToLink/SendLink.cfm
		this.sendToFriendSuccessClass="alert alert-success";
		this.sendToFriendErrorClass="alert alert-danger";
		
		// Generic form vars
		this.formWrapperClass = "";
	</cfscript>

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