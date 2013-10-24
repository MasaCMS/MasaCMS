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
			renderer.calendarWrapper="";
			renderer.calendarTable="table table-bordered";
			renderer.calendarTableHeader="";
			
			// calendar/dspList.cfm
			renderer.calendarListWrapper="";
			
			// Comments/index.cfm
			renderer.commentsWrapper="";
			renderer.commentFormWrapper="";
			renderer.commentForm="form-horizontal";
			renderer.commentFieldWrapper="";
			renderer.commentFieldLabel="";
			renderer.commentInputWrapper="";
			renderer.commentInput="";
			renderer.commentSubmitButton="btn";
			renderer.commentUserEmail="";
			renderer.commentDeleteButton="";
			
			// Comments/dsp_comment.cfm
			renderer.emailLink="btn";
			renderer.commentsLink="btn";
			renderer.approveCommentLink="btn";
			renderer.deleteCommentLink="btn";
			
			// Datacollection/dsp_response.cfm
			renderer.datacollectionErrorP="error";
			renderer.datacollectionErrorDiv="alert";
			renderer.datacollectionSuccessP="success";
			
			// Dataresponses/dsp_detail.cfm
			renderer.dataResponseList="dl-horizontal";
			
			// Dataresponses/dsp_list.cfm
			renderer.dataResponseTable="table table-hover";
			renderer.dataResponsePagination="pagination";
			
			// Draggablefeeds/index.cfm
			renderer.draggableBoxHeader="";
			renderer.draggableBoxHeaderButton="btn btn-default";
			renderer.draggableBoxRSSeditForm="";
			renderer.draggableBoxAddFeedWrapper="well clearfix";
			renderer.draggableBoxNewFeedForm="form-horizontal";
			renderer.draggableBoxSelectFeedWrapper="";
			renderer.draggableBoxSelectFeedRow="row";
			renderer.draggableBoxSelectFeedMenu="";
			renderer.draggableBoxSelectFeedMenuDiv="";
			renderer.draggableFeedMenuSelectField="";
			renderer.addFeedButtonWrapperDiv="";
			renderer.addFeedButtonWrapperDivInner="";
			renderer.addFeedButton="btn btn-default";
			
			// Dsp_categories_nest.cfm
			renderer.categoriesNestCheckbox="checkbox";
			
			// Dsp_content_list.cfm
			renderer.contentListWrapperDiv="";
			renderer.contentList="clearfix";
			renderer.contentListItemTitle="";
			renderer.contentListItemSummary="";
			renderer.contentListItemCredits="";
			renderer.contentListItemComments="";
			renderer.contentListItemRating="";
			renderer.contentListItemImageLink="thumbnail";
			renderer.contentListItemImage="";
			
			// Dsp_edit_profile.cfm
			renderer.editProfileForm="form-horizontal";
			renderer.editProfileFormGroupWrapper="control-group";
			renderer.editProfileFieldLabel="control-label";
			renderer.editProfileFormFieldsWrapper="";
			renderer.editProfileFormFields="";
			renderer.editProfileHelpBlock="help-block";
			renderer.editProfileSubmitButton="btn btn-primary";
			renderer.editProfileSuccessMessage="success";
			renderer.editProfileErrorMessage="alert";
			
			// Dsp_email_dropdown.cfm
			renderer.emailDropdownSelect="dropdown";
			
			// Dsp_event_reminder_form.cfm
			renderer.eventReminderForm="well";
			renderer.eventReminderFieldWrapper="control-group";
			renderer.eventReminderFormLabels="control-label";
			renderer.eventReminderSubmit="btn";
			
			// Dsp_features.cfm
			renderer.featuresWrapper="clearfix";
			
			// Dsp_feed.cfm
			renderer.localIndexWrapper="clearfix";
			renderer.remoteFeedWrapper="clearfix";
			
			// Dsp_login.cfm
			renderer.loginWrapper="container";
			renderer.loginWrapperInner="row";
			renderer.loginErrorMessage="error";
			renderer.loginForm="form-horizontal";
			renderer.forgotPasswordForm="form-horizontal";
			renderer.loginFormGroupWrapper="";
			renderer.loginFormFieldLabel="control-label";
			renderer.loginFormFieldWrapper="";
			renderer.loginFormField="";
			renderer.loginFormCheckbox="checkbox";
			renderer.loginFormSubmit="btn btn-default";
			renderer.loginFormAlert="alert";
			renderer.loginFormError="error";
			renderer.notRegisteredLink="btn btn-primary";
			
			// Dsp_mailing_list_master.cfm
			renderer.mailingListWrapper="well";
			renderer.mailingListSuccess="success";
			renderer.mailingListError="error";
			renderer.mailingListForm="form-horizontal";
			renderer.mailingListFormGroupWrapper="";
			renderer.mailingListFormLabel="control-label";
			renderer.mailingListFormFieldWrapper="";
			renderer.mailingListFormInput="";
			renderer.mailingListCheckboxWrapper="";
			renderer.mailingListCheckbox="checkbox";
			renderer.mailingListSubmit="btn btn-default";
			
			// Dsp_nextN.cfm
			renderer.nextNWrapper="container";
			renderer.nextNInner="row";
			
			// Dsp_search_form.cfm
			renderer.searchForm="";
			renderer.searchFormInputWrapper="";
			renderer.searchFormInput="";
			renderer.searchFormSubmitWrapper="";
			renderer.searchFormSubmit="btn btn-default";
			
			// Dsp_search_results.cfm
			renderer.searchResultWrapper="container";
			renderer.searchResultInner="row";
			renderer.searchResultsRow="row";
			renderer.searchResultsMoreResultsRow="row";
			renderer.searchReultsPager="pager";
			renderer.searchAgainRow="row";
			renderer.searchAgainInner="";
			renderer.searchAgainForm="";
			renderer.searchAgainInputWrapper="";
			renderer.searchAgainFormInput="";
			renderer.searchAgainButtonWrapper="";
			renderer.searchAgainSubmit="btn btn-default";
			
			// Dsp_user_tools.cfm
			renderer.userToolsWrapper="well clearfix";
			renderer.userToolsLoginForm="form-horizontal";
			renderer.userToolsFormGroupWrapper="";
			renderer.userToolsLoginFormLabel="control-label";
			renderer.userToolsLoginFormInputWrapper="";
			renderer.userToolsLoginFormInput="";
			renderer.userToolsLoginFormFieldInner="";
			renderer.userToolsLoginFormSubmit="btn btn-default";
			renderer.userToolsNotRegisteredLink="btn btn-primary";
			renderer.userToolsWrapper="clearfix";
			renderer.userToolsEditProfileLink="btn btn-default";
			renderer.userToolsLogoutLink="btn btn-default";
			
			// Formbuilder/Dsp_form.cfm
			renderer.formBuilderFieldWrapper="";
			renderer.formBuilderButtonWrapper="form-actions";
			renderer.formBuilderSubmit="btn btn-default";
			
			// Formbuilder/Fields/Dsp_checkbox.cfm
			// Formbuilder/Fields/Dsp_dropdown.cfm 
			// Formbuilder/Fields/Dsp_file.cfm
			// Formbuilder/Fields/Dsp_radio.cfm
			// Formbuilder/Fields/Dsp_textfield.cfm
			
			renderer.formBuilderFormFields="control-group";
			
			// Formbuilder/Fields/field_dropdown.cfm
			renderer.formBuilderTabHeader="dropdown";
			renderer.formBuilderDisabledInput="disabled";
			renderer.formBuilderCheckbox="checkbox";
			
			// Gallery/Index.cfm
			renderer.galleryUL="clearfix";
			renderer.galleryThumbnail="thumbnail";
			
			// Nav/CalendarNav/NavTools.cfc
			renderer.navCalendarWrapper="";
			renderer.navCalendarTable="table table-bordered";
			
			// Nav/Dsp_sequential.cfm
			renderer.navSequentialWrapper="container";
			renderer.navSequentialInner="row";
			
			// Nav/dsp_tag_cloud.cfm
			renderer.tagCloudWrapper="";
			
			// NavArchive
			renderer.navArchiveWrapper="";
			renderer.navArchiveList="";
			
			
			// Rater/Index.cfm
			renderer.raterObjectWrapper="row clearfix";
			renderer.raterWrapper="";
			renderer.avgRatingWrapper="";
			
			// SendToLink/SendLink.cfm
			renderer.sendToFriendSuccess="success";
			renderer.sendToFriendError="error";

			// form vars
			renderer.formWrapperClass = 'well';

			// for code syntax highlighting
			try {
				arguments.$.loadPrettify();
			} catch(any e) {
				// Mura CMS version is probably older than 6.1
			}
		</cfscript>
	</cffunction>

</cfcomponent>