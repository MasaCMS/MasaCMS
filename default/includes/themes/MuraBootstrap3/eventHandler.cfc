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
<cfcomponent extends="mura.cfobject" output="false">

	<!---
			This is the THEME eventHandler.cfc 

			* Add theme-specific eventHandlers here
			* This file is much like a controller in a MVC application 
			* Reload the application when additions/changes are made to THIS file!
	--->

	<cffunction name="onSiteRequestStart" access="public" output="false" returntype="any">
		<cfargument name="$" hint="mura scope" />
		<cfscript>
			// http://dominicwatson.github.io/cfstatic/full-guide.html (See Configuration section)
			// if in production, set checkForUpdates=false
			arguments.$.static(
				outputDirectory = 'compiled'
				, checkForUpdates = !arguments.$.siteConfig('cache')
				, lessGlobals = ExpandPath($.siteConfig('themeAssetPath') & '/css/less-globals/globals.less')
			);
		</cfscript>
	</cffunction>

	<cffunction name="onSiteCKEditorConfigRender" access="public" output="false" returntype="any">
		<cfargument name="$" hint="mura scope" />
		<cfset var str = '' />
		<cfsavecontent variable="str"><cfoutput>
			// heading vars
			config.format_h1 = { element : 'h2' };
			config.format_h2 = { element : 'h3' };
			config.format_h3 = { element : 'h4' };
			config.format_h4 = { element : 'h5' };
			config.format_h5 = { element : 'h6' };
		</cfoutput></cfsavecontent>
		<cfreturn str />
	</cffunction>

	<cffunction name="onRenderStart" access="public" output="false" returntype="any">
		<cfargument name="$" hint="mura scope" />
		<cfscript>
			var renderer = arguments.$.getContentRenderer();

			// general vars
			renderer.jsLib = 'jquery';
			renderer.jsLibLoaded = true;
			renderer.generalWrapperClass = 'well';
			
			// headings
			renderer.headline = 'h1';
			renderer.subHead1 = 'h2';
			renderer.subHead2 = 'h3';
			renderer.subHead3 = 'h4';
			renderer.subHead4 = 'h5';

			// nav and list item vars
			renderer.navWrapperClass = 'well';
			renderer.liHasKidsClass = '';
			renderer.liHasKidsCustomString = '';
			renderer.liCurrentClass = 'active';
			renderer.liCurrentCustomString = '';
			renderer.aHasKidsClass = '';
			renderer.aHasKidsCustomString = '';
			renderer.aCurrentClass = 'active';
			renderer.aCurrentCustomString = '';
			renderer.ulTopClass = 'nav nav-list';
			renderer.ulNestedClass = 'nav nav-list';
			renderer.ulNestedCustomString = '';
			renderer.liNestedClass = '';

			// pagination vars
			renderer.ulPaginationClass = 'pagination';
			renderer.ulPaginationWrapperClass = 'pagination';

			// form vars
			renderer.formWrapperClass = 'well';
			
			// Display Objects
			// Use these variables to pass-in specific classes without having to create custom versions
			
			// calendar/dsp_showMonth.cfm
			 renderer.calendarWrapperClass="mura-Calendar";
			 renderer.calendarTableClass="table table-bordered";
			 //renderer.calendarTableHeaderClass="";
			
			// calendar/dspList.cfm
			 renderer.calendarListWrapperClass="mura-Calendar";
			
			// comments/index.cfm
			 renderer.commentsWrapperClass="mura-Comments";
			 renderer.commentFormWrapperClass="well";
			 renderer.commentFormClass="form-horizontal";
			 renderer.commentNewClass="btn btn-default";
			 renderer.commentFieldWrapperClass="form-group";
			 renderer.commentFieldLabelClass="control-label col-lg-3";
			 renderer.commentInputWrapperClass="col-lg-9";
			 renderer.commentInputClass="form-control";
			 renderer.commentCheckboxClass="checkbox";
			 renderer.commentPrefsInputWrapperClass="col-lg-offset-3 col-lg-9";
			 renderer.commentSubmitButtonWrapperClass="col-lg-offset-3 col-lg-9";
			 renderer.commentSubmitButtonClass="btn btn-default";
			 renderer.commentRequiredWrapperClass="col-lg-offset-3 col-lg-9";
			 //renderer.commentUserEmailClass="";
			 //renderer.commentDeleteButtonClass="";
			
			// comments/dsp_comment.cfm
			 renderer.emailLinkClass="btn btn-default";
			 renderer.commentsLinkClass="btn btn-default";
			 renderer.approveCommentLinkClass="btn btn-default";
			 renderer.deleteCommentLinkClass="btn btn-default";
			
			// datacollection/dsp_response.cfm
			 renderer.datacollectionErrorPClass="alert alert-danger";
			 renderer.datacollectionErrorDivClass="alert alert-danger";
			 renderer.datacollectionSuccessPClass="alert alert-success";
			
			// dataresponses/dsp_detail.cfm
			 renderer.dataResponseListClass="dl-horizontal";
			
			// dataresponses/dsp_list.cfm
			 renderer.dataResponseTableClass="table table-hover";
			 renderer.dataResponsePaginationClass="pagination";
			
			// draggablefeeds/index.cfm
			 renderer.draggableBoxWrapperClass="row";
			 renderer.draggableBoxHeaderClass="col-lg-12";
			 renderer.draggableBoxRSSWrapperClass="mura-RSSFeeds";
			 renderer.draggableBoxHeaderButtonClass="btn btn-default";
			 //renderer.draggableBoxRSSeditFormClass="";
			 renderer.draggableBoxAddFeedWrapperClass="well clearfix";
			 renderer.draggableBoxNewFeedFormClass="form-horizontal";
			 renderer.draggableBoxSelectFeedWrapperClass="col-lg-6";
			 renderer.draggableBoxSelectFeedRowClass="row";
			 renderer.draggableBoxSelectFeedMenuClass="form-group";
			 renderer.draggableBoxSelectFeedMenuDivClass="col-lg-10";
			 renderer.draggableFeedMenuSelectFieldClass="form-control";
			 renderer.addFeedButtonWrapperDivClass="form-group";
			 renderer.addFeedButtonWrapperDivInnerClass="col-lg-2";
			 renderer.addFeedButtonClass="btn btn-default";
			
			// dsp_categories_nest.cfm
			 renderer.categoriesNestCheckboxClass="checkbox";
			
			// dsp_content_list.cfm
			renderer.contentListImageStyles=true;
			renderer.contentListPropertyMap={
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
			 renderer.contentListWrapperDivClass="";
			 renderer.contentListItemImageLinkClass="";
			
			// dsp_folder.cfm
			renderer.folderWrapperClass="mura-Index";
			
			// dsp_edit_profile.cfm
			 renderer.editProfileWrapperClass="mura-EditProfile";
			 renderer.editProfileFormClass="form-horizontal";
			 renderer.editProfileFormGroupWrapperClass="form-group";
			 renderer.editProfileFieldLabelClass="control-label col-lg-3";
			 renderer.editProfileFormFieldsWrapperClass="col-lg-9";
			 renderer.editProfileFormFieldsClass="form-control";
			 renderer.editProfileExtAttributeDownloadClass="col-lg-3";
			 renderer.editProfileHelpBlockClass="help-block";
			 renderer.editProfileExtAttributeFileWrapperClass="col-lg-offset-3 col-lg-6";
			 renderer.editProfileExtAttributeDownloadClass="col-lg-3";
			 renderer.editProfileExtAttributeDownloadButtonClass="btn btn-default";
			 renderer.editProfileSubmitButtonWrapperClass="col-lg-offset-3 col-lg-9";
			 renderer.editProfileSubmitButtonClass="btn btn-primary";
			 renderer.editProfileSuccessMessageClass="alert alert-success";
			
			// dsp_email_dropdown.cfm
			 renderer.emailDropdownSelectClass="dropdown";
			
			// dsp_event_reminder_form.cfm
			 renderer.eventReminderFormWrapperClass="mura-EventReminderForm";
			 renderer.eventReminderFormClass="well";
			 renderer.eventReminderFieldWrapperClass="";
			 renderer.eventReminderFormLabelsClass="control-label";
			 renderer.eventReminderSubmitClass="btn btn-default";
			
			// dsp_features.cfm
			 renderer.featuresWrapperClass="mura-SyndLocal mura-Index clearfix";
			
			// dsp_feed.cfm
			 renderer.localIndexWrapperClass="mura-SyndLocal mura-Feed mura-Index clearfix";
			 renderer.remoteFeedWrapperClass="mura-SyndRemote mura-Index mura-Feed clearfix";
			
			// dsp_login.cfm
			 renderer.loginWrapperClass="container";
			 renderer.loginWrapperInnerClass="row";
			 renderer.loginErrorMessageClass="alert alert-danger";
			 renderer.loginFormClass="form-horizontal form-signin";
			 renderer.forgotPasswordFormClass="form-horizontal form-sendlogin";
			 renderer.loginFormGroupWrapperClass="form-group";
			 renderer.loginFormFieldLabelClass="control-label col-lg-3";
			 renderer.loginFormFieldWrapperClass="col-lg-9";
			 renderer.loginFormFieldClass="form-control";
			 renderer.loginFormPrefsClass="col-lg-offset-3 col-lg-10";
			 renderer.loginFormCheckboxClass="checkbox";
			 renderer.loginFormSubmitWrapperClass="col-lg-offset-3 col-lg-10";
			 renderer.loginFormSubmitClass="btn btn-default";
			 renderer.loginFormAlertClass="alert alert-success";
			 renderer.loginFormErrorClass="alert alert-danger";
			 renderer.notRegisteredLinkClass="btn btn-primary";
			
			// dsp_mailing_list_master.cfm
			 renderer.mailingListWrapperClass="well";
			 renderer.mailingListSuccessClass="alert alert-success";
			 renderer.mailingListErrorClass="alert alert-error";
			 renderer.mailingListFormClass="form-horizontal";
			 renderer.mailingListFormGroupWrapperClass="form-group";
			 renderer.mailingListFormLabelClass="control-label col-lg-2";
			 renderer.mailingListFormFieldWrapperClass="col-lg-10";
			 renderer.mailingListFormInputClass="text form-control";
			 renderer.mailingListCheckboxWrapperClass="col-lg-offset-2 col-lg-10";
			 renderer.mailingListCheckboxClass="checkbox";
			 renderer.mailingListSubmitWrapperClass="col-lg-offset-2 col-lg-10";
			 renderer.mailingListSubmitClass="submit btn btn-default";
			
			// dsp_nextN.cfm
			 renderer.nextNWrapperClass="container";
			 renderer.nextNInnerClass="row";
			
			// dsp_search_form.cfm
			 renderer.searchFormClass="navbar-form";
			 renderer.searchFormInputWrapperClass="input-group";
			 renderer.searchFormInputClass="form-control";
			 renderer.searchFormSubmitWrapperClass="input-group-btn";
			 renderer.searchFormSubmitClass="btn btn-default";
			
			// dsp_search_results.cfm
			 renderer.searchResultWrapperClass="mura-SearchResults container";
			 renderer.searchResultInnerClass="row";
			 renderer.searchResultsRowClass="row";
			 renderer.searchResultsMoreResultsRowClass="row";
			 renderer.searchReultsListClass="mura-Index";
			 renderer.searchReultsPagerClass="pager";
			 renderer.searchAgainRowClass="row";
			 renderer.searchAgainInnerClass="col-md-8";
			 renderer.searchAgainFormClass="navbar-form";
			 renderer.searchAgainInputWrapperClass="input-group";
			 renderer.searchAgainFormInputClass="form-control";
			 renderer.searchAgainButtonWrapperClass="input-group-btn";
			 renderer.searchAgainSubmitClass="btn btn-default";
			
			// dsp_user_tools.cfm
			 renderer.userToolsLoginWrapperClass="well clearfix";
			 renderer.userToolsLoginFormClass="form-horizontal";
			 renderer.userToolsFormGroupWrapperClass="form-group";
			 renderer.userToolsLoginFormLabelClass="control-label col-lg-2";
			 renderer.userToolsLoginFormInputWrapperClass="col-lg-10";
			 renderer.userToolsLoginFormInputClass="form-control";
			 renderer.userToolsLoginFormFieldInnerClass="col-lg-offset-2 col-lg-10";
			 renderer.userToolsLoginFormCheckboxClass="checkbox";
			 renderer.userToolsLoginFormSubmitClass="btn btn-default";
			 renderer.userToolsNotRegisteredLinkClass="btn btn-primary";
			 renderer.userToolsWrapperClass="clearfix";
			 renderer.userToolsEditProfileLinkClass="btn btn-default";
			 renderer.userToolsLogoutLinkClass="btn btn-default";
			
			// formbuilder/dsp_form.cfm
			 renderer.formBuilderFieldWrapperClass="form-group";
			 renderer.formBuilderButtonWrapperClass="form-actions buttons";
			 renderer.formBuilderSubmitClass="btn btn-default";
			
			// formbuilder/fields/dsp_checkbox.cfm
			// formbuilder/fields/dsp_dropdown.cfm 
			// formbuilder/fields/dsp_file.cfm
			// formbuilder/fields/dsp_radio.cfm
			// formbuilder/fields/dsp_textfield.cfm
			
			 renderer.formBuilderFormFieldsClass="form-control";
			
			// formbuilder/fields/field_dropdown.cfm
			 renderer.formBuilderTabHeaderClass="dropdown";
			 renderer.formBuilderDisabledInputClass="disabled";
			 renderer.formBuilderCheckboxClass="checkbox";
			
			// gallery/index.cfm
			 renderer.galleryWrapperClass="mura-Gallery";
			 renderer.galleryULClass="clearfix";
			 renderer.galleryThumbnailClass="thumbnail";
			
			// nav/calendarNav/index.cfm
			renderer.navCalendarWrapperClass="mura-Calendar mura-CalendarNav";
			
			// nav/calendarNav/navTools.cfc
			 renderer.navCalendarTableClass="table table-bordered";
			
			// nav/dsp_sequential.cfm
			 renderer.navSequentialWrapperClass="container";
			 renderer.navSequentialInnerClass="row";
			
			// nav/dsp_tag_cloud.cfm
			 renderer.tagCloudWrapperClass="mura-TagCloud";
			
			// navArchive
			 //renderer.navArchiveWrapperClass="";
			 //renderer.navArchiveListClass="";
			
			
			// rater/index.cfm
			 renderer.raterObjectWrapperClass="row mura-Ratings clearfix";
			 renderer.raterWrapperClass="col-lg-12";
			 renderer.avgRatingWrapperClass="col-lg-12";
			
			// sendToLink/SendLink.cfm
			 renderer.sendToFriendSuccessClass="alert alert-success";
			 renderer.sendToFriendErrorClass="alert alert-danger";
			
			// Generic form vars
				renderer.formWrapperClass = "";

			// for code syntax highlighting
			try {
				arguments.$.loadPrettify();
			} catch(any e) {
				// Mura CMS version is probably older than 6.1
			}
		</cfscript>
	</cffunction>

</cfcomponent>