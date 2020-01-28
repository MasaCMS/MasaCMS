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
	/core/
	/Application.cfc
	/index.cfm

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
		this.layoutmanager=true;
		this.validateCSRFTokens=false;

		//this.hideRestrictedNav=false;
		//this.navOffSet=0;
		//this.navDepthLimit=1000;
		//this.navParentIdx=2;
		//this.navGrandParentIdx=3;
		//this.navDepthAdjust=0;
		//this.navSelfIdx=1;
		//this.jslib="jquery";
		//this.jsLibLoaded=false;
		//this.suppressWhitespace = true;
		//this.longDateFormat="long";
		//this.shortDateFormat="short";
		//this.showMetaList="jpg,jpeg,png,gif";
		//this.imageInList="jpg,jpeg,png,gif";
		//this.defaultCollectionDisplayList="Date,Title,Image,Summary,Credits";
		//this.directImages=true;
		//this.personalization="user";
		//this.showAdminToolBar=true;
		//this.showMemberToolBar=false;
		//this.showEditableObjects=false;
		//this.showInlineEditor=true;
		//this.deferMuraJS=false;

		//Queue async display objects to render when scrolled into view
		//this.queueObjects=true;

		//Set these to a boolean value to override settings.ini.cfm value
		//this.siteIDInURLS="";
		//this.indexFileInURLS="";
		//this.hashURLS="";

		//this.renderHTMLHead=true;
		//this.renderHTMLQueues=true;
		//this.listFormat="dl"; //deprecated
		//this.headline="h1";
		//this.subHead1="h2";
		//this.subHead2="h3";
		//this.subHead3="h4";
		//this.subHead4="h5";
		//this.subHead5="h6";
		//this.navWrapperClass="sidebar-nav well";
		//this.liHasKidsClass="";
		//this.liHasKidsAttributes="";
		//this.liCurrentClass="current";
		//this.liCurrentAttributes="";
		//this.liHasKidsNestedClass="";
		//this.aHasKidsClass="";
		//this.aHasKidsAttributes="";
		//this.aCurrentClass="current";
		//this.aNotCurrentClass="";
		//this.aCurrentAttributes="";
		//this.ulNestedClass="";
		//this.ulNestedAttributes="";
		//this.ulTopClass="navSecondary";
		//this.ulPaginationClass="navSequential";
		//this.ulPaginationWrapperClass="pagination";
		//this.liPaginationCurrentClass="";
		//this.liPaginationNotCurrentClass="";
		//this.aPaginationCurrentClass="";
		//this.aPaginationNotCurrentClass="";
		//this.generalWrapperClass="well";
		//this.generalWrapperBodyClass="";

		//These are used as primary form settings as well as in the form builder.
		//this.formWrapperClass="well";
		//this.formWrapperClass=this.generalWrapperClass;
		//this.formWrapperBodyClass=this.generalWrapperBodyClass;
		//this.formErrorWrapperClass = "";
		//this.formResponseWrapperClass = ";
		//this.formFieldWrapperClass = "control-group";
		//this.formFieldLabelClass = "control-label";
		//this.formGeneralControlClass = "form-control";
		//this.formInputClass=this.formGeneralControlClass;
		//this.formSelectClass = this.formGeneralControlClass;
		//this.formTextareaClass = this.formGeneralControlClass;
		//this.formFileClass = this.formGeneralControlClass;
		//this.formCheckboxClass = "";
		//this.formCheckboxLabelClass = "checkbox";
		//this.formCheckboxWrapperClass = "";
		//this.formRadioWrapperClass = "";
		//this.formRadioClass = "";
		//this.formRadioLabelClass = "radio";
		//this.formButtonWrapperClass = "btn-group";
		//this.formButtonInnerClass="";
		//this.formButtonClass = "btn btn-default";
		//this.formRequiredWrapperClass="";
		//this.formButtonSubmitclass = "form-submit  btn-primary";
		//this.formButtomSubmitclass = this.formButtonSubmitclass; //deprecated
		//this.formButtonSubmitLabel = "Submit";
		//this.formButtonNextClass = "form-nav";
		//this.formButtonNextLabel = "Next";
		//this.formButtonBackClass = "form-nav";
		//this.formButtonBackLabel = "Back";
		//this.formButtonCancelLabel = "Cancel";
		//this.formButtonCancelClass = "form-cancel btn-primary pull-right";
		//this.formRequiredLabel = "Required";

		//this.enablemuratag=true;
		//this.bodyMetaImageSizeArgs={size="medium"};
		//this.defaultnavsize=50;

		this.shadowboxattribute="data-rel"; //This is the new value and will not be needed overriding.

		//this.navSubWrapperClass=this.navWrapperClass;
		//this.navSubWrapperBodyClass=this.navWrapperBodyClass;
		//this.navPeerWrapperClass=this.navWrapperClass;
		//this.navPeerWrapperBodyClass=this.navWrapperBodyClass;
		//this.navFolderWrapperClass=this.navWrapperClass;
		//this.navFolderWrapperBodyClass=this.navWrapperBodyClass;
		//this.navStandardWrapperClass=this.navWrapperClass;
		//this.navStandardWrapperBodyClass=this.navWrapperBodyClass;
		//this.navMultiLevelWrapperClass=this.navWrapperClass;
		//this.navMultiLevelWrapperBodyClass=this.navWrapperBodyClass;
		//this.navArchiveWrapperClass=this.navWrapperClass;
		//this.navArchiveWrapperBodyClass=this.navWrapperBodyClass;
		//this.navCategoryWrapperClass=this.navWrapperClass;
		//this.navCategoryWrapperBodyClass=this.navWrapperBodyClass;
		//this.navNextDecoration="&nbsp;&raquo;";
		//this.navPrevDecoration="&laquo;&nbsp;";

		this.alertSuccessClass = "";
		this.alertInfoClass = "";
		this.alertWarningClass = "";
		this.alertDangerClass = "";

		//Display Objects
		//Use these variables to pass-in specific classes without having to create custom versions

		//calendar/dsp_showMonth.cfm
		this.calendarWrapperClass="";
		this.calendarTableClass="";
		this.calendarTableHeaderClass="";

		//calendar/dspList.cfm
		this.calendarListWrapperClass="";

		//	calendar/index.cfm
		/*
		this.calendarcolors=[
			{background='##3a87ad',text='white'},
			{background='blue',text='white'}
		];
		*/

		//comments/index.cfm
		this.allowPublicComments=true;
		this.commentsWrapperClass="";
		this.commentsWrapperBodyClass="";
		this.commentSortContainerClass="";
		this.commentSortWrapperClass="";
		this.commentSortSelectClass=this.formInputClass;
		this.commentFormWrapperClass=this.generalWrapperClass;
		this.commentFormWrapperBodyClass=this.generalWrapperBodyClass;
		this.commentFormClass="";
		this.commentNewClass=this.formButtonClass;
		this.commentFieldWrapperClass=this.formFieldWrapperClass;
		this.commentFieldLabelClass=this.formFieldLabelClass;
		this.commentInputWrapperClass="";
		this.commentInputClass=this.formInputClass;
		this.commentCheckboxClass="";
		this.commentCheckboxWrapperClass="";
		this.commentPrefsInputWrapperClass="";
		this.commentSubmitButtonWrapperClass="";
		this.commentSubmitButtonClass=this.formButtonClass;
		this.commentMoreCommentsUpClass="";
		this.commentMoreCommentsDownClass="";
		this.commentMoreCommentsContainer="";
		this.commentRequiredWrapperClass="";
		this.commentThumbClass="";
		this.commentSpamClass="";
		this.commentSpamLinkClass="";
		this.commentClass="";
		this.commentDateTimeClass="";
		this.commentReplyClass="";
		this.commentAwaitingApproval="";
		this.commentAdminButtonWrapperClass="";
		this.commentUserEmailClass="";
		this.commentDeleteButtonClass="";
		this.commentEditButtonClass="";
		this.commentApproveButtonClass="";

		//comments/dsp_comment.cfm
		this.emailLinkClass="";
		this.commentsLinkClass="";
		this.approveCommentLinkClass="";
		this.deleteCommentLinkClass="";

		//cookie_consent/modules/cookie_consent_cta/index.cfm
		this.cookieConsentEnabled=false;
		this.cookieConsentType='drawer';
		this.cookieConsentButtonClass="btn btn-primary";
		this.cookieConsentWrapperClass="";
		this.cookieConsentWidth="sm"; //sm,md,lg,full

		//dsp_categories_nest.cfm
		this.categoriesNestCheckboxClass="";

		this.contentGridStyleMap={
				'1 Column'='mura-grid-one',
				'2 Column'='mura-grid-two',
				'3 Column'='mura-grid-three',
				'4 Column'='mura-grid-four',
				'5 Column'='mura-grid-five',
				'6 Column'='mura-grid-six',
				'7 Column'='mura-grid-seven',
				'8 Column'='mura-grid-eight',
				'9 Column'='mura-grid-nine'
			};

		this.contentGridPropertyMap={
				itemEl={tag="div",class="mura-item-meta"},
				labelEl={tag="span"},
				title={tag="div"},
				date={tag="div"},
				credits={tag="div",showLabel=true,labelDelim=":",rbkey="list.by"},
				tags={tag="div",showLabel=true,labelDelim=":",rbkey="tagcloud.tags"},
				rating={tag="div",showLabel=true,labelDelim=":",rbkey="list.rating"},
				'default'={tag="div"}
			};

		//dsp_content_list.cfm
		this.contentListImageStyles=true;
		this.contentListImagePadding=20; //must be pixels
		this.contentListWrapperDivClass="";
		this.contentListItemImageLinkClass="";

		/* this.contentListPropertyMap={
				containerEl={tag="div"},
				itemEl={tag="dl"},
				labelEl={tag="span"},
				title={tag="dt"},
				date={tag="dt"},
				credits={tag="dd",showLabel=true,rbkey="list.by"},
				tags={tag="dd",showLabel=true,labelDelim=":",rbkey="tagcloud.tags"},
				rating={tag="dd",showLabel=true,labelDelim=":",rbkey="list.rating"},
				'default'={tag="dd"}
			};*/

		this.aContentListCurrentClass=this.aCurrentClass;
		this.aContentListCurrentAttributes=this.aCurrentAttributes;
		this.aContentListNotCurrentClass=this.aNotCurrentClass;

		//dsp_meta_list.cfm
		this.aMetaListCurrentClass=this.aContentListCurrentClass;
		this.aMetaListCurrentAttributes=this.aContentListCurrentAttributes;
		this.aMetaListNotCurrentClass=this.aContentListNotCurrentClass;

		//dsp_folder.cfm
		this.folderWrapperClass="";

		//dsp_edit_profile.cfm
		this.editProfileWrapperClass="";
		this.editProfileFormClass="";
		this.editProfileFormGroupWrapperClass="";
		this.editProfileFieldLabelClass="";
		this.editProfileFormFieldsWrapperClass="";
		this.editProfileFormFieldsClass="";
		this.editProfileHelpBlockClass="";
		this.editProfileExtAttributeFileWrapperClass="";
		this.editProfileExtAttributeFileCheckboxClass="";
		this.editProfileExtAttributeDownloadClass="";
		this.editProfileExtAttributeDownloadButtonClass="";
		this.editProfileSubmitButtonWrapperClass="";
		this.editProfileSubmitButtonClass="";
		this.editProfileSuccessMessageClass="";
		this.editProfileErrorMessageClass="";
		this.editProfileInfoMessageClass="";

		//dsp_email_dropdown.cfm
		this.emailDropdownSelectClass="";

		//dsp_event_reminder_form.cfm
		this.eventReminderFormWrapperClass="";
		this.eventReminderFormClass="";
		this.eventReminderFieldWrapperClass="";
		this.eventReminderFormLabelsClass="";
		this.eventReminderSubmitClass="";

		//dsp_features.cfm
		this.featuresWrapperClass="";

		//dsp_feed.cfm
		this.localIndexWrapperClass="";
		this.remoteFeedWrapperClass="";

		//dsp_login.cfm
		this.loginWrapperClass="";
		this.loginWrapperInnerClass="";
		this.loginFormClass="";
		this.forgotPasswordFormClass="";
		this.loginFormGroupWrapperClass="";
		this.loginFormErrorClass="";
		this.loginFormFieldLabelClass="";
		this.loginFormFieldWrapperClass="";
		this.loginFormFieldClass="";
		this.loginFormPrefsClass="";
		this.loginFormCheckboxClass="";
		this.loginFormCheckboxWrapperClass="";
		this.loginFormSubmitWrapperClass="";
		this.loginFormSubmitClass="";
		this.notRegisteredLinkClass="";

		//dsp_mailing_list_master.cfm
		this.mailingListWrapperClass="";
		this.mailingListFormClass="";
		this.mailingListFormGroupWrapperClass="";
		this.mailingListFormLabelClass="";
		this.mailingListFormFieldWrapperClass="";
		this.mailingListFormInputClass="";
		this.mailingListCheckboxWrapperClass="";
		this.mailingListCheckboxClass="";
		this.mailingListSubmitClass="";

		//dsp_nextN.cfm
		this.nextNWrapperClass="";
		this.nextNInnerClass="";

		//dsp_search_form.cfm
		this.searchFormClass="";
		this.searchFormInputWrapperClass="";
		this.searchFormInputClass="";
		this.searchFormSubmitWrapperClass="";
		this.searchFormSubmitClass="";

		//search/index.cfm
		this.searchShowNumbers=1;
		this.searchResultWrapperClass="";
		this.searchResultInnerClass="";
		this.searchResultsRowClass="";
		this.searchResultsMoreResultsRowClass="";
		this.searchResultsListClass="";
		this.searchResultsPagerClass="";
		this.searchAgainRowClass="";
		this.searchAgainInnerClass="";
		this.searchAgainFormClass="";
		this.searchAgainInputWrapperClass="";
		this.searchAgainFormInputClass="";
		this.searchAgainButtonWrapperClass="";
		this.searchAgainSubmitClass="";

		//dsp_user_tools.cfm
		this.userToolsLoginWrapperClass="";
		this.userToolsLoginFormClass="";
		this.userToolsFormGroupWrapperClass="";
		this.userToolsLoginFormLabelClass="";
		this.userToolsLoginFormInputWrapperClass="";
		this.userToolsLoginFormInputClass="";
		this.userToolsLoginFormFieldInnerClass="";
		this.userToolsLoginFormCheckboxClass="";
		this.userToolsLoginFormSubmitClass="";
		this.userToolsNotRegisteredLinkClass="";
		this.userToolsWrapperClass="";
		this.userToolsEditProfileLinkClass="";
		this.userToolsLogoutLinkClass="";

		// favorites/index.cfm
		this.userFavoritesWrapperClass="";
		this.userFavoritesWrapperBodyClass="";
		this.pageToolsWrapperClass="";
		this.pageToolsWrapperBodyClass="";

		//formbuilder/dsp_form.cfm
		this.formBuilderFieldWrapperClass="";
		this.formBuilderButtonWrapperClass="";
		this.formBuilderSubmitClass="";

		//formbuilder/fields/dsp_checkbox.cfm
		//formbuilder/fields/dsp_dropdown.cfm
		//formbuilder/fields/dsp_file.cfm
		//formbuilder/fields/dsp_radio.cfm
		//formbuilder/fields/dsp_textfield.cfm

		this.formBuilderFormFieldsClass="";

		//formbuilder/fields/field_dropdown.cfm
		this.formBuilderTabHeaderClass="";
		this.formBuilderDisabledInputClass="";
		this.formBuilderCheckboxClass="";

		//gallery/index.cfm
		this.galleryImageStyles=true;
		this.galleryWrapperClass="";
		this.galleryULClass="";
		this.galleryLIClass="";
		this.galleryThumbnailClass="";

		//nav/calendarNav/navTools.cfc
		this.navCalendarWrapperClass="";
		this.navCalendarTableClass="";

		//nav/dsp_sequential.cfm
		this.navSequentialWrapperClass="";
		this.navSequentialULClass="";

		//nav/dsp_tag_cloud.cfm
		this.tagCloudWrapperClass="";

		//navBreadcrumb
		this.navBreadcrumbULClass="breadcrumb";
		this.liBreadcrumbCurrentClass="";
		this.liBreadcrumbNotCurrentClass="";
		this.aBreadcrumbCurrentClass="";
		this.aBreadcrumbNotCurrentClass="";

		//rater/index.cfm
		this.raterObjectWrapperClass="";
		this.raterWrapperClass="";
		this.avgRatingWrapperClass="";


	</cfscript>

</cfcomponent>
