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
			
			// Display Objects
			// calendar/dsp_showMonth.cfm
			renderer.calendarWrapperClass="";
			renderer.calendarTableClass="table table-bordered";
			renderer.calendarTableHeaderClass="";
			
			// calendar/dspList.cfm
			renderer.calendarListWrapperClass="";
			
			// Comments/index.cfm
			renderer.commentsWrapperClass="";
			renderer.commentFormWrapperClass="";
			renderer.commentFormClass="form-horizontal";
			renderer.commentFieldWrapperClass="";
			renderer.commentFieldLabelClass="";
			renderer.commentInputWrapperClass="";
			renderer.commentInputClass="";
			renderer.commentSubmitButtonClass="btn";
			renderer.commentUserEmailClass="";
			renderer.commentDeleteButtonClass="";
			
			// Comments/dsp_comment.cfm
			renderer.emailLinkClass="btn";
			renderer.commentsLinkClass="btn";
			renderer.approveCommentLinkClass="btn";
			renderer.deleteCommentLinkClass="btn";
			
			// Datacollection/dsp_response.cfm
			renderer.datacollectionErrorPClass="error";
			renderer.datacollectionErrorDivClass="alert";
			renderer.datacollectionSuccessPClass="success";
			
			// Dataresponses/dsp_detail.cfm
			renderer.dataResponseListClass="dl-horizontal";
			
			// Dataresponses/dsp_list.cfm
			renderer.dataResponseTableClass="table table-hover";
			renderer.dataResponsePaginationClass="pagination";
			
			// Draggablefeeds/index.cfm
			renderer.draggableBoxHeaderClass="";
			renderer.draggableBoxHeaderButtonClass="btn btn-default";
			renderer.draggableBoxRSSeditFormClass="";
			renderer.draggableBoxAddFeedWrapperClass="well clearfix";
			renderer.draggableBoxNewFeedFormClass="form-horizontal";
			renderer.draggableBoxSelectFeedWrapperClass="";
			renderer.draggableBoxSelectFeedRowClass="row";
			renderer.draggableBoxSelectFeedMenuClass="";
			renderer.draggableBoxSelectFeedMenuDivClass="";
			renderer.draggableFeedMenuSelectFieldClass="";
			renderer.addFeedButtonWrapperDivClass="";
			renderer.addFeedButtonWrapperDivInnerClass="";
			renderer.addFeedButtonClass="btn btn-default";
			
			// Dsp_categories_nest.cfm
			renderer.categoriesNestCheckboxClass="checkbox";
			
			// Dsp_content_list.cfm
			renderer.contentListWrapperDivClass="";
			renderer.contentListClass="clearfix";
			renderer.contentListItemTitleClass="";
			renderer.contentListItemSummaryClass="";
			renderer.contentListItemCreditsClass="";
			renderer.contentListItemCommentsClass="";
			renderer.contentListItemRatingClass="";
			renderer.contentListItemImageLinkClass="thumbnail";
			renderer.contentListItemImageClass="";
			
			// Dsp_edit_profile.cfm
			renderer.editProfileFormClass="form-horizontal";
			renderer.editProfileFormGroupWrapperClass="control-group";
			renderer.editProfileFieldLabelClass="control-label";
			renderer.editProfileFormFieldsWrapperClass="";
			renderer.editProfileFormFieldsClass="";
			renderer.editProfileHelpBlockClass="help-block";
			renderer.editProfileSubmitButtonClass="btn btn-primary";
			renderer.editProfileSuccessMessageClass="success";
			renderer.editProfileErrorMessageClass="alert";
			
			// Dsp_email_dropdown.cfm
			renderer.emailDropdownSelectClass="dropdown";
			
			// Dsp_event_reminder_form.cfm
			renderer.eventReminderFormClass="well";
			renderer.eventReminderFieldWrapperClass="control-group";
			renderer.eventReminderFormLabelsClass="control-label";
			renderer.eventReminderSubmitClass="btn";
			
			// Dsp_features.cfm
			renderer.featuresWrapperClass="clearfix";
			
			// Dsp_feed.cfm
			renderer.localIndexWrapperClass="clearfix";
			renderer.remoteFeedWrapperClass="clearfix";
			
			// Dsp_login.cfm
			renderer.loginWrapperClass="container";
			renderer.loginWrapperInnerClass="row";
			renderer.loginErrorMessageClass="error";
			renderer.loginFormClass="form-horizontal";
			renderer.forgotPasswordFormClass="form-horizontal";
			renderer.loginFormGroupWrapperClass="";
			renderer.loginFormFieldLabelClass="control-label";
			renderer.loginFormFieldWrapperClass="";
			renderer.loginFormFieldClass="";
			renderer.loginFormCheckboxClass="checkbox";
			renderer.loginFormSubmitClass="btn btn-default";
			renderer.loginFormAlertClass="alert";
			renderer.loginFormErrorClass="error";
			renderer.notRegisteredLinkClass="btn btn-primary";
			
			// Dsp_mailing_list_master.cfm
			renderer.mailingListWrapperClass="well";
			renderer.mailingListSuccessClass="success";
			renderer.mailingListErrorClass="error";
			renderer.mailingListFormClass="form-horizontal";
			renderer.mailingListFormGroupWrapperClass="";
			renderer.mailingListFormLabelClass="control-label";
			renderer.mailingListFormFieldWrapperClass="";
			renderer.mailingListFormInputClass="";
			renderer.mailingListCheckboxWrapperClass="";
			renderer.mailingListCheckboxClass="checkbox";
			renderer.mailingListSubmitClass="btn btn-default";
			
			// Dsp_nextN.cfm
			renderer.nextNWrapperClass="container";
			renderer.nextNInnerClass="row";
			
			// Dsp_search_form.cfm
			renderer.searchFormClass="";
			renderer.searchFormInputWrapperClass="";
			renderer.searchFormInputClass="";
			renderer.searchFormSubmitWrapperClass="";
			renderer.searchFormSubmitClass="btn btn-default";
			
			// Dsp_search_results.cfm
			renderer.searchResultWrapperClass="container";
			renderer.searchResultInnerClass="row";
			renderer.searchResultsRowClass="row";
			renderer.searchResultsMoreResultsRowClass="row";
			renderer.searchReultsPagerClass="pager";
			renderer.searchAgainRowClass="row";
			renderer.searchAgainInnerClass="";
			renderer.searchAgainFormClass="";
			renderer.searchAgainInputWrapperClass="";
			renderer.searchAgainFormInputClass="";
			renderer.searchAgainButtonWrapperClass="";
			renderer.searchAgainSubmitClass="btn btn-default";
			
			// Dsp_user_tools.cfm
			renderer.userToolsWrapperClass="well clearfix";
			renderer.userToolsLoginFormClass="form-horizontal";
			renderer.userToolsFormGroupWrapperClass="";
			renderer.userToolsLoginFormLabelClass="control-label";
			renderer.userToolsLoginFormInputWrapperClass="";
			renderer.userToolsLoginFormInputClass="";
			renderer.userToolsLoginFormFieldInnerClass="";
			renderer.userToolsLoginFormSubmitClass="btn btn-default";
			renderer.userToolsNotRegisteredLinkClass="btn btn-primary";
			renderer.userToolsWrapperClass="clearfix";
			renderer.userToolsEditProfileLinkClass="btn btn-default";
			renderer.userToolsLogoutLinkClass="btn btn-default";
			
			// Formbuilder/Dsp_form.cfm
			renderer.formBuilderFieldWrapperClass="";
			renderer.formBuilderButtonWrapperClass="form-actions";
			renderer.formBuilderSubmitClass="btn btn-default";
			
			// Formbuilder/Fields/Dsp_checkbox.cfm
			// Formbuilder/Fields/Dsp_dropdown.cfm 
			// Formbuilder/Fields/Dsp_file.cfm
			// Formbuilder/Fields/Dsp_radio.cfm
			// Formbuilder/Fields/Dsp_textfield.cfm
			
			renderer.formBuilderFormFieldsClass="control-group";
			
			// Formbuilder/Fields/field_dropdown.cfm
			renderer.formBuilderTabHeaderClass="dropdown";
			renderer.formBuilderDisabledInputClass="disabled";
			renderer.formBuilderCheckboxClass="checkbox";
			
			// Gallery/Index.cfm
			renderer.galleryULClass="clearfix";
			renderer.galleryThumbnailClass="thumbnail";
			
			// Nav/CalendarNav/NavTools.cfc
			renderer.navCalendarWrapperClass="";
			renderer.navCalendarTableClass="table table-bordered";
			
			// Nav/Dsp_sequential.cfm
			renderer.navSequentialWrapperClass="container";
			renderer.navSequentialInnerClass="row";
			
			// Nav/dsp_tag_cloud.cfm
			renderer.tagCloudWrapperClass="";
			
			// NavArchive
			renderer.navArchiveWrapperClass="";
			renderer.navArchiveListClass="";
			
			
			// Rater/Index.cfm
			renderer.raterObjectWrapperClass="row clearfix";
			renderer.raterWrapperClass="";
			renderer.avgRatingWrapperClass="";
			
			// SendToLink/SendLink.cfm
			renderer.sendToFriendSuccessClass="success";
			renderer.sendToFriendErrorClass="error";

			// form vars
			renderer.formWrapperClass = "well";

			// for code syntax highlighting
			try {
				arguments.$.loadPrettify();
			} catch(any e) {
				// Mura CMS version is probably older than 6.1
			}
		</cfscript>
	</cffunction>

</cfcomponent>