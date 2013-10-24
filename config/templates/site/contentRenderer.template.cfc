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
<cfcomponent extends="mura.content.contentRenderer" output="false">

	<!---
			This is the SITE contentRenderer.cfc

			* Add site-specific methods here
			* You can override Mura's contentRenderer methods in here as well!
			* Any methods here will be accessible with the following notation:
				$.yourFunctionName()
			* You can also adjust various rendering settings on a per-site basis
			  by editing any of the 'this.' settings below.
			  
			* If you wish to customize display object classes at the theme level,
			  You may do so in the theme's eventHandler.cfc  
	--->

	<cfscript>
		//this.navOffSet=0;
		//this.navDepthLimit=1000;
		//this.navParentIdx=2;
		//this.navGrandParentIdx=3;
		//this.navDepthAjust=0;
		//this.navSelfIdx=1;
		//this.jslib="jquery";
		//this.jsLibLoaded=false;
		//this.longDateFormat="long";
		//this.shortDateFormat="short";
		//this.showMetaList="jpg,jpeg,png,gif";
		//this.imageInList="jpg,jpeg,png,gif";
		//this.directImages=true;
		//this.personalization="user";
		//this.showAdminToolBar=true;
		//this.showMemberToolBar=false;
		//this.showEditableObjects=false;
		//this.showInlineEditor=true;
		//this.renderHTMLHead=true;
		//this.renderHTMLQueues=true;
		//this.listFormat="dl";
		//this.headline="h1";
		//this.subHead1="h2";
		//this.subHead2="h3";
		//this.subHead3="h4";
		//this.subHead4="h5";
		//this.subHead5="h6";
		//this.navWrapperClass="sidebar-nav well";
		//this.liHasKidsClass="";
		//this.liHasKidsCustomString="";
		//this.liCurrentClass="current";
		//this.liCurrentCustomString="";
		//this.liHasKidsNestedClass="";
		//this.aHasKidsClass="";
		//this.aHasKidsCustomString="";
		//this.aCurrentClass="current";
		//this.aCurrentCustomString="";
		//this.ulNestedClass="";
		//this.ulNestedCustomString="";
		//this.ulTopClass="navSecondary";
		//this.ulPaginationClass="navSequential";
		//this.ulPaginationWrapperClass="pagination";
		//this.formWrapperClass="well";
		//this.generalWrapperClass="well";
		//this.aNotCurrentClass="";
		//this.enablemuratag=true;
		//this.bodyMetaImageSizeArgs={size="medium"};
		//this.size=50;
		
		// Display Objects
		// calendar/dsp_showMonth.cfm
		// this.calendarWrapper="";
		// this.calendarTable="table table-bordered";
		// this.calendarTableHeader="";
		
		// calendar/dspList.cfm
		// this.calendarListWrapper="";
		
		// Comments/index.cfm
		// this.commentsWrapper="";
		// this.commentFormWrapper="";
		// this.commentForm="form-horizontal";
		// this.commentFieldWrapper="";
		// this.commentFieldLabel="";
		// this.commentInputWrapper="";
		// this.commentInput="";
		// this.commentSubmitButton="btn";
		// this.commentUserEmail="";
		// this.commentDeleteButton="";
		
		// Comments/dsp_comment.cfm
		// this.emailLink="btn";
		// this.commentsLink="btn";
		// this.approveCommentLink="btn";
		// this.deleteCommentLink="btn";
		
		// Datacollection/dsp_response.cfm
		// this.datacollectionErrorP="error";
		// this.datacollectionErrorDiv="alert";
		// this.datacollectionSuccessP="success";
		
		// Dataresponses/dsp_detail.cfm
		// this.dataResponseList="dl-horizontal";
		
		// Dataresponses/dsp_list.cfm
		// this.dataResponseTable="table table-hover";
		// this.dataResponsePagination="pagination";
		
		// Draggablefeeds/index.cfm
		// this.draggableBoxHeader="";
		// this.draggableBoxHeaderButton="btn btn-default";
		// this.draggableBoxRSSeditForm="";
		// this.draggableBoxAddFeedWrapper="well clearfix";
		// this.draggableBoxNewFeedForm="form-horizontal";
		// this.draggableBoxSelectFeedWrapper="";
		// this.draggableBoxSelectFeedRow="row";
		// this.draggableBoxSelectFeedMenu="";
		// this.draggableBoxSelectFeedMenuDiv="";
		// this.draggableFeedMenuSelectField="";
		// this.addFeedButtonWrapperDiv="";
		// this.addFeedButtonWrapperDivInner="";
		// this.addFeedButton="btn btn-default";
		
		// Dsp_categories_nest.cfm
		// this.categoriesNestCheckbox="checkbox";
		
		// Dsp_content_list.cfm
		// this.contentListWrapperDiv="";
		// this.contentList="clearfix";
		// this.contentListItemTitle="";
		// this.contentListItemSummary="";
		// this.contentListItemCredits="";
		// this.contentListItemComments="";
		// this.contentListItemRating="";
		// this.contentListItemImageLink="thumbnail";
		// this.contentListItemImage="";
		
		// Dsp_edit_profile.cfm
		// this.editProfileForm="form-horizontal";
		// this.editProfileFormGroupWrapper="control-group";
		// this.editProfileFieldLabel="control-label";
		// this.editProfileFormFieldsWrapper="";
		// this.editProfileFormFields="";
		// this.editProfileHelpBlock="help-block";
		// this.editProfileSubmitButton="btn btn-primary";
		// this.editProfileSuccessMessage="success";
		// this.editProfileErrorMessage="alert";
		
		// Dsp_email_dropdown.cfm
		// this.emailDropdownSelect="dropdown";
		
		// Dsp_event_reminder_form.cfm
		// this.eventReminderForm="well";
		// this.eventReminderFieldWrapper="control-group";
		// this.eventReminderFormLabels="control-label";
		// this.eventReminderSubmit="btn";
		
		// Dsp_features.cfm
		// this.featuresWrapper="clearfix";
		
		// Dsp_feed.cfm
		// this.localIndexWrapper="clearfix";
		// this.remoteFeedWrapper="clearfix";
		
		// Dsp_login.cfm
		// this.loginWrapper="container";
		// this.loginWrapperInner="row";
		// this.loginErrorMessage="error";
		// this.loginForm="form-horizontal";
		// this.forgotPasswordForm="form-horizontal";
		// this.loginFormGroupWrapper="";
		// this.loginFormFieldLabel="control-label";
		// this.loginFormFieldWrapper="";
		// this.loginFormField="";
		// this.loginFormCheckbox="checkbox";
		// this.loginFormSubmit="btn btn-default";
		// this.loginFormAlert="alert";
		// this.loginFormError="error";
		// this.notRegisteredLink="btn btn-primary";
		
		// Dsp_mailing_list_master.cfm
		// this.mailingListWrapper="well";
		// this.mailingListSuccess="success";
		// this.mailingListError="error";
		// this.mailingListForm="form-horizontal";
		// this.mailingListFormGroupWrapper="";
		// this.mailingListFormLabel="control-label";
		// this.mailingListFormFieldWrapper="";
		// this.mailingListFormInput="";
		// this.mailingListCheckboxWrapper="";
		// this.mailingListCheckbox="checkbox";
		// this.mailingListSubmit="btn btn-default";
		
		// Dsp_nextN.cfm
		// this.nextNWrapper="container";
		// this.nextNInner="row";
		
		// Dsp_search_form.cfm
		// this.searchForm="";
		// this.searchFormInputWrapper="";
		// this.searchFormInput="";
		// this.searchFormSubmitWrapper="";
		// this.searchFormSubmit="btn btn-default";
		
		// Dsp_search_results.cfm
		// this.searchResultWrapper="container";
		// this.searchResultInner="row";
		// this.searchResultsRow="row";
		// this.searchResultsMoreResultsRow="row";
		// this.searchReultsPager="pager";
		// this.searchAgainRow="row";
		// this.searchAgainInner="";
		// this.searchAgainForm="";
		// this.searchAgainInputWrapper="";
		// this.searchAgainFormInput="";
		// this.searchAgainButtonWrapper="";
		// this.searchAgainSubmit="btn btn-default";
		
		// Dsp_user_tools.cfm
		// this.userToolsWrapper="well clearfix";
		// this.userToolsLoginForm="form-horizontal";
		// this.userToolsFormGroupWrapper="";
		// this.userToolsLoginFormLabel="control-label";
		// this.userToolsLoginFormInputWrapper="";
		// this.userToolsLoginFormInput="";
		// this.userToolsLoginFormFieldInner="";
		// this.userToolsLoginFormSubmit="btn btn-default";
		// this.userToolsNotRegisteredLink="btn btn-primary";
		// this.userToolsWrapper="clearfix";
		// this.userToolsEditProfileLink="btn btn-default";
		// this.userToolsLogoutLink="btn btn-default";
		
		// Formbuilder/Dsp_form.cfm
		// this.formBuilderFieldWrapper="";
		// this.formBuilderButtonWrapper="form-actions";
		// this.formBuilderSubmit="btn btn-default";
		
		// Formbuilder/Fields/Dsp_checkbox.cfm
		// Formbuilder/Fields/Dsp_dropdown.cfm 
		// Formbuilder/Fields/Dsp_file.cfm
		// Formbuilder/Fields/Dsp_radio.cfm
		// Formbuilder/Fields/Dsp_textfield.cfm
		
		// this.formBuilderFormFields="control-group";
		
		// Formbuilder/Fields/field_dropdown.cfm
		// this.formBuilderTabHeader="dropdown";
		// this.formBuilderDisabledInput="disabled";
		// this.formBuilderCheckbox="checkbox";
		
		// Gallery/Index.cfm
		// this.galleryUL="clearfix";
		// this.galleryThumbnail="thumbnail";
		
		// Nav/CalendarNav/NavTools.cfc
		// this.navCalendarWrapper="";
		// this.navCalendarTable="table table-bordered";
		
		// Nav/Dsp_sequential.cfm
		// this.navSequentialWrapper="container";
		// this.navSequentialInner="row";
		
		// Nav/dsp_tag_cloud.cfm
		// this.tagCloudWrapper="";
		
		// NavArchive
		// this.navArchiveWrapper="";
		// this.navArchiveList="";
		
		
		// Rater/Index.cfm
		// this.raterObjectWrapper="row clearfix";
		// this.raterWrapper="";
		// this.avgRatingWrapper="";
		
		// SendToLink/SendLink.cfm
		// this.sendToFriendSuccess="success";
		// this.sendToFriendError="error";
	</cfscript>

</cfcomponent>