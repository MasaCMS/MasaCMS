<!--- This file is part of Mura CMS.

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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides core rendering functionality">

<cfset this.primaryContentTypes=""/>
<cfset this.validateCSRFTokens=false/>
<cfset this.allowPublicComments=true>
<cfset this.navOffSet=0/>
<cfset this.navDepthLimit=1000/>
<cfset this.navParentIdx=2/>
<cfset this.navGrandParentIdx=3/>
<cfset this.navDepthAdjust=0/>
<cfset this.navSelfIdx=1/>
<cfset this.jslib="jquery"/>
<cfset this.jsLibLoaded=false/>
<cfset this.suppressWhitespace=true/>
<cfset this.longDateFormat="long"/>
<cfset this.shortDateFormat="short"/>
<cfset this.showMetaList="jpg,jpeg,png,gif,svg">
<cfset this.imageInList="jpg,jpeg,png,gif,svg">
<cfset this.defaultCollectionDisplayList="Date,Title,Image,Summary,Credits"/>
<cfset this.directImages=true/>
<cfset this.personalization="user">
<cfset this.hasEditableObjects=false>
<cfset this.asyncObjects=true>
<cfset this.asyncRender=false>
<cfset this.queueObjects=true>
<cfset this.layoutmanager=false>
<cfset this.legacyobjects=true>
<cfset this.deferMuraJS=false>
<cfset this.hideRestrictedNav=false>
<cfset this.templateArray=[]>
<cfset this.collectionLayoutArray=[]>
<cfset this.editableAttributesArray=[]>
<cfset this.imageAttributesArray=[]>
<cfset this.styleLookup={
		'textAlign'='text-align',
		'textDecoration'='text-decoration',
		'textTransform'='text-transform',
		'textIndent'='text-indent',
		'textOverflow'='text-overflow',
		'backgroundImage'='background-image',
		'backgroundColor'='background-color',
		'backgroundOrigin'='background-Origin',
		'backgroundPostition'='background-postition',
		'backgroundRepeat'='background-repeat',
		'borderRadius'='border-radius',
		'borderWidth'='border-width',
		'borderStyle'='border-style',
		'boxSizing'='box-sizing',
		'marginTop'='margin-top',
		'marginLeft'='margin-left',
		'marginBottom'='margin-bottom',
		'marginRight'='margin-right',
		'paddingTop'='padding-top',
		'paddingLeft'='padding-left',
		'paddingBottom'='padding-bottom',
		'paddingRight'='padding-right',
		'fontFamily'='font-family',
		'fontSize'='font-size',
		'fontWeight'='font-weight',
		'fontVariant'='font-variant',
		'outlineStyle'='outline-style',
		'outlineColor'='outline-color',
		'outlineWidth'='outline-width',
		'outlineOffset'='outline-offset',
		'lineHeight'='line-height',
		'letterSpacing'='letter-spacing',
		'wordSpacing'='word-spacing',
		'whiteSpace'='white-space',
		'textShadow'='text-shadow',
		'verticalAlign'='vertical-align',
		'webkitTransition'='-webkit-transition',
		'transitionTimingFunction'='transitionTimingFunction',
		'transitionProperty'='transition-property',
		'transitionDuration'='transition-duration',
		'transitionDelay'='transition-delay',
		'animationName'='animation-name',
		'animationDuration'='animation-duration'
	}>

<!--- Set these to a boolean value to override settings.ini.cfm value--->
<cfset this.siteIDInURLS="">
<cfset this.indexFileInURLS="">
<cfset this.hashURLS="">

<cfset this.generalWrapperClass="well">
<cfset this.generalWrapperBodyClass="">

<cfif isDefined('url.muraadminpreview')>
	<cfset this.showAdminToolBar=false/>
	<cfset this.showMemberToolBar=false/>
	<cfset this.showEditableObjects=false/>
	<cfset this.showInlineEditor=false/>
<cfelse>
	<cfset this.showAdminToolBar=true/>
	<cfset this.showMemberToolBar=true/>
	<cfset this.showEditableObjects=true/>
	<cfset this.showInlineEditor=true/>
</cfif>
<!--- renderHTMLHead has been deprecated in favor of renderHTMLQueues---->
<cfset this.renderHTMLHead=true/>
<cfset this.renderHTMLQueues=true/>
<cfset this.crumbdata=arrayNew(1)/>
<cfset this.listFormat="dl">
<cfset this.headline="h2"/>
<cfset this.subHead1="h3"/>
<cfset this.subHead2="h4"/>
<cfset this.subHead3="h5"/>
<cfset this.subHead4="h6">
<!--- This is duplicated for when the page title gets set to h1 --->
<cfset this.subHead5="h6">
<!--- This is the preloader markup for async objects--->
<cfset this.preloaderMarkup=''>
<!--- These settings are for navigational display objects --->
<cfset this.navWrapperClass="sidebar-nav #this.generalWrapperClass#">
<cfset this.navWrapperBodyClass=this.generalWrapperBodyClass>
<cfset this.navLIClass="">
<cfset this.liHasKidsClass="">
<cfset this.liHasKidsAttributes="">
<cfset this.liCurrentClass="current">
<cfset this.liCurrentAttributes="">
<cfset this.liHasKidsNestedClass="">
<cfset this.aHasKidsClass="">
<cfset this.aHasKidsAttributes="">
<cfset this.aCurrentClass="current">
<cfset this.aNotCurrentClass="">
<cfset this.aCurrentAttributes="">
<cfset this.ulNestedClass="">
<cfset this.ulNestedAttributes="">
<cfset this.ulTopClass="navSecondary">

<cfset this.ulPaginationClass="navSequential">
<cfset this.ulPaginationWrapperClass="pagination">
<cfset this.liPaginationCurrentClass=this.liCurrentClass>
<cfset this.liPaginationNotCurrentClass="">
<cfset this.aPaginationCurrentClass=this.aCurrentClass>
<cfset this.aPaginationNotCurrentClass="">

<cfset this.bodyMetaImageSizeArgs={size="medium"}>
<cfset this.bodyMetaImageClass="thumbnail">
<!--- This is temp only for backward compatibility--->
<cfset this.shadowboxattribute="rel">
<!--- this is legacy--->
<cfset this.size=50>
<!--- use this--->
<cfset this.navsize=this.size>

<!--- ===================
General Classes
=================== --->

<!--- Nav Specfic--->
<cfset this.navSubWrapperClass=this.navWrapperClass>
<cfset this.navSubWrapperBodyClass=this.navWrapperBodyClass>
<cfset this.navPeerWrapperClass=this.navWrapperClass>
<cfset this.navPeerWrapperBodyClass=this.navWrapperBodyClass>
<cfset this.navFolderWrapperClass=this.navWrapperClass>
<cfset this.navFolderWrapperBodyClass=this.navWrapperBodyClass>
<cfset this.navStandardWrapperClass=this.navWrapperClass>
<cfset this.navStandardWrapperBodyClass=this.navWrapperBodyClass>
<cfset this.navMultiLevelWrapperClass=this.navWrapperClass>
<cfset this.navMultiLevelWrapperBodyClass=this.navWrapperBodyClass>
<cfset this.navArchiveWrapperClass=this.navWrapperClass>
<cfset this.navArchiveWrapperBodyClass=this.navWrapperBodyClass>
<cfset this.navCategoryWrapperClass=this.navWrapperClass>
<cfset this.navCategoryWrapperBodyClass=this.navWrapperBodyClass>
<cfset this.navNextDecoration="&nbsp;&raquo;">
<cfset this.navPrevDecoration="&laquo;&nbsp;">

<!--- This may not be used --->
<cfset this.formInputWrapperClass = "input-addon">

<!--- Forms --->
<cfset this.formWrapperClass=this.generalWrapperClass>
<cfset this.formWrapperBodyClass=this.generalWrapperBodyClass>
<cfset this.formFieldWrapperClass = "control-group">
<cfset this.formErrorWrapperClass = "">
<cfset this.formResponseWrapperClass = "">
<cfset this.formFieldLabelClass = "control-label">
<cfset this.formGeneralControlClass = "form-control">
<cfset this.formInputClass=this.formGeneralControlClass>
<cfset this.formSelectClass = this.formGeneralControlClass>
<cfset this.formTextareaClass = this.formGeneralControlClass>
<cfset this.formFileClass = this.formGeneralControlClass>
<cfset this.formCheckboxWrapperClass = "">
<cfset this.formCheckboxClass = "">
<cfset this.formCheckboxLabelClass = "checkbox">
<cfset this.formRadioWrapperClass = "">
<cfset this.formRadioClass = "">
<cfset this.formRadioLabelClass = "radio">
<cfset this.formButtonWrapperClass = "btn-group">
<cfset this.formButtonInnerClass="">
<cfset this.formButtonClass = "btn btn-default">
<cfset this.formRequiredWrapperClass = "">
<cfset this.formButtonSubmitclass = "form-submit  btn-primary">
<cfset this.formButtomSubmitclass = this.formButtonSubmitclass>
<cfset this.formButtonSubmitLabel = "Submit">
<cfset this.formButtonSubmitWaitLabel = "Please Wait...">
<cfset this.formButtonNextlClass = "form-nav">
<cfset this.formButtonNextLabel = "Next">
<cfset this.formButtonBackClass = "form-nav">
<cfset this.formButtonBackLabel = "Back">
<cfset this.formButtonCancelLabel = "Cancel">
<cfset this.formButtonCancelClass = "form-cancel btn-primary pull-right">
<cfset this.formRequiredLabel= "Required">

<cfset this.expandedContentContainerClass="container">

<!--- Images --->
<cfset this.imageClass="img-thumbnail">

<!--- Tables --->
<cfset this.tableClass = "table table-bordered table-striped">
<cfset this.tableHeadClass = "">
<cfset this.tableHeaderClass = "">
<cfset this.tableBodyClass = "">
<cfset this.tableRowClass = "">
<cfset this.tableCellClass = "">
<cfset this.tableFooterClass = "">

<!--- Alerts --->
<cfset this.alertSuccessClass = "alert alert-success">
<cfset this.alertInfoClass = "alert alert-info">
<cfset this.alertWarningClass = "alert">
<cfset this.alertDangerClass = "alert alert-error">


<!--- ===================
Display Objects
=================== --->

<!--- calendar/dsp_showMonth.cfm --->
<cfset this.calendarWrapperClass="svCalendar">
<cfset this.calendarTableClass="table table-bordered">
<cfset this.calendarTableHeaderClass="">

<cfset this.calendarTitleInDesc=true>

<!--- calendar/dspList.cfm --->
<cfset this.calendarListWrapperClass="svCalendar">

<cfset this.calendarcolors=[
		{background='##3a87ad',text='white'},
		{background='blue',text='white'}
	]>

<!--- Comments/index.cfm --->
<cfset this.commentsWrapperClass="">
<cfset this.commentSortContainerClass="">
<cfset this.commentSortWrapperClass="">
<cfset this.commentSortSelectClass="">
<cfset this.commentFormWrapperClass="">
<cfset this.commentFormClass=this.formWrapperClass>
<cfset this.commentFormBodyClass=this.formWrapperBodyClass>
<cfset this.commentNewClass="btn">
<cfset this.commentFieldWrapperClass="">
<cfset this.commentFieldLabelClass="">
<cfset this.commentInputWrapperClass="">
<cfset this.commentInputClass="">
<cfset this.commentCheckboxClass="checkbox">
<cfset this.commentCheckboxWrapperClass="">
<cfset this.commentPrefsInputWrapperClass="">
<cfset this.commentSubmitButtonWrapperClass="">
<cfset this.commentSubmitButtonClass="btn">
<cfset this.commentMoreCommentsUpClass="btn btn-default icon-arrow-up">
<cfset this.commentMoreCommentsDownClass="btn btn-default icon-arrow-down">
<cfset this.commentRequiredWrapperClass="">
<cfset this.commentAdminButtonWrapperClass="">
<cfset this.commentUserEmailClass="btn">
<cfset this.commentDeleteButtonClass="btn">
<cfset this.commentEditButtonClass="btn">
<cfset this.commentApproveButtonClass="btn">
<cfset this.commentThumbClass="img-polaroid">
<cfset this.commentSpamClass="btn">
<cfset this.commentSpamLinkClass="btn">
<cfset this.commentClass="">
<cfset this.commentDateTimeClass="">
<cfset this.commentReplyClass="">
<cfset this.commentAwaitingApproval="">
<cfset this.commentAdminButtonWrapperClass="btn-group pull-right">
<cfset this.commentUserEmailClass="btn btn-default btn-sm">
<cfset this.commentDeleteButtonClass="btn btn-default btn-sm">
<cfset this.commentEditButtonClass="btn btn-default btn-sm">
<cfset this.commentApproveButtonClass="btn btn-default btn-sm">
<cfset this.commentMoreCommentsContainer=this.generalWrapperClass>
<cfset this.commentMoreCommentsContainer=this.generalWrapperBodyClass>

<!--- cookie_consent/modules/cookie_consent_cta/index.cfm --->
<cfset this.cookieConsentEnabled=false>
<cfset this.cookieConsentType='drawer'>
<cfset this.cookieConsentButtonClass="btn btn-primary">
<cfset this.cookieConsentWrapperClass="">
<cfset this.cookieConsentWidth="sm"><!---sm,md,lg,full--->

<!--- Comments/dsp_comment.cfm --->
<cfset this.emailLinkClass="btn">
<cfset this.commentsLinkClass="btn">
<cfset this.approveCommentLinkClass="btn">
<cfset this.deleteCommentLinkClass="btn">

<!--- Dataresponses/dsp_detail.cfm DEPRECATED --->
<cfset this.dataResponseListClass="dl-horizontal">

<!--- Dataresponses/dsp_list.cfm DEPRECATED --->
<cfset this.dataResponseTableClass="table table-hover">
<cfset this.dataResponsePaginationClass="pagination">

<!--- Draggablefeeds/index.cfm DEPRECATED--->
<cfset this.draggableBoxWrapperClass="">
<cfset this.draggableBoxHeaderClass="">
<cfset this.draggableBoxRSSWrapperClass="svRSSFeeds">
<cfset this.draggableBoxHeaderButtonClass="btn btn-default">
<cfset this.draggableBoxRSSeditFormClass="">
<cfset this.draggableBoxAddFeedWrapperClass="well clearfix">
<cfset this.draggableBoxNewFeedFormClass="form-horizontal">
<cfset this.draggableBoxSelectFeedWrapperClass="">
<cfset this.draggableBoxSelectFeedRowClass="row">
<cfset this.draggableBoxSelectFeedMenuClass="">
<cfset this.draggableBoxSelectFeedMenuDivClass="">
<cfset this.draggableFeedMenuSelectFieldClass="">
<cfset this.addFeedButtonWrapperDivClass="">
<cfset this.addFeedButtonWrapperDivInnerClass="">
<cfset this.addFeedButtonClass="btn btn-default">

<!--- Dsp_categories_nest.cfm --->
<cfset this.categoriesNestCheckboxClass="checkbox">

<!--- Dsp_content_list.cfm --->
<cfset this.contentListImageStyles=true>
<cfset this.contentListImagePadding=20>
<cfset this.contentListWrapperDivClass="">
<cfset this.contentListItemImageLinkClass="thumbnail">
<cfset this.contentListPropertyMap={
		containerEl={tag="div"},
		itemEl={tag="dl",class="clearfix"},
		labelEl={tag="span"},
		title={tag="dt"},
		date={tag="dt"},
		credits={tag="dd",showLabel=true,rbkey="list.by"},
		tags={tag="dd",showLabel=true,labelDelim=":",rbkey="tagcloud.tags"},
		rating={tag="dd",showLabel=true,labelDelim=":",rbkey="list.rating"},
		default={tag="dd"}
	}>

<cfset this.aContentListCurrentClass=this.aCurrentClass>
<cfset this.aContentListCurrentAttributes=this.aCurrentAttributes>
<cfset this.aContentListNotCurrentClass=this.aNotCurrentClass>

<cfset this.aMetaListCurrentClass=this.aContentListCurrentClass>
<cfset this.aMetaListCurrentAttributes=this.aContentListCurrentAttributes>
<cfset this.aMetaListNotCurrentClass=this.aContentListNotCurrentClass>

<cfset this.contentGridStyleMap={
		'1 Column'='mura-grid-one',
		'2 Column'='mura-grid-two',
		'3 Column'='mura-grid-three',
		'4 Column'='mura-grid-four',
		'5 Column'='mura-grid-five',
		'6 Column'='mura-grid-six',
		'7 Column'='mura-grid-seven',
		'8 Column'='mura-grid-eight',
		'9 Column'='mura-grid-nine'
	}>

<cfset this.contentGridPropertyMap={
		itemEl={tag="div",class="mura-item-meta"},
		labelEl={tag="span"},
		title={tag="div"},
		date={tag="div"},
		credits={tag="div",showLabel=true,labelDelim=":",rbkey="list.by"},
		tags={tag="div",showLabel=true,labelDelim=":",rbkey="tagcloud.tags"},
		rating={tag="div",showLabel=true,labelDelim=":",rbkey="list.rating"},
		'default'={tag="div"}
	}>

<!--- dsp_folder.cfm --->
<cfset this.folderWrapperClass="svIndex">

<!--- Dsp_edit_profile.cfm --->
<cfset this.editProfileWrapperClass=this.formWrapperClass>
<cfset this.editProfileWrapperBodyClass=this.formWrapperBodyClass>
<cfset this.editProfileFormClass="form-horizontal">
<cfset this.editProfileFormGroupWrapperClass="control-group">
<cfset this.editProfileFieldLabelClass="control-label">
<cfset this.editProfileFormFieldsWrapperClass="">
<cfset this.editProfileFormFieldsClass="">
<cfset this.editProfileHelpBlockClass="help-block">
<cfset this.editProfileExtAttributeFileWrapperClass="">
<cfset this.editProfileExtAttributeFileCheckboxClass="checkbox">
<cfset this.editProfileExtAttributeDownloadClass="">
<cfset this.editProfileExtAttributeDownloadButtonClass="btn btn-default">
<cfset this.editProfileSubmitButtonWrapperClass="">
<cfset this.editProfileSubmitButtonClass="btn btn-primary">
<cfset this.editProfileSuccessMessageClass="alert alert-success">
<cfset this.editProfileErrorMessageClass=this.alertDangerClass>
<cfset this.editProfileInfoMessageClass=this.alertDangerClass>

<!--- Dsp_email_dropdown.cfm --->
<cfset this.emailDropdownSelectClass="dropdown">

<!--- Dsp_event_reminder_form.cfm --->
<cfset this.eventReminderFormWrapperClass="">
<cfset this.eventReminderFormClass=this.generalWrapperClass>
<cfset this.eventReminderFormBodyClass=this.generalWrapperBodyClass>
<cfset this.eventReminderFieldWrapperClass="control-group">
<cfset this.eventReminderFormLabelsClass="control-label">
<cfset this.eventReminderSubmitClass="btn btn-default">

<!--- Dsp_features.cfm --->
<cfset this.featuresWrapperClass="svSyndLocal svIndex clearfix">

<!--- Dsp_feed.cfm --->
<cfset this.localIndexWrapperClass="svSyndLocal svFeed svIndex clearfix">
<cfset this.remoteFeedWrapperClass="svSyndRemote svIndex svFeed clearfix">

<!--- Dsp_login.cfm --->
<cfset this.loginWrapperClass="container">
<cfset this.loginWrapperBodyClass="">
<cfset this.loginWrapperInnerClass="row">
<cfset this.loginFormClass="form-horizontal">
<cfset this.forgotPasswordFormClass="form-horizontal">
<cfset this.loginFormGroupWrapperClass="">
<cfset this.loginFormErrorClass="">
<cfset this.loginFormFieldLabelClass="control-label">
<cfset this.loginFormFieldWrapperClass="">
<cfset this.loginFormFieldClass="">
<cfset this.loginFormPrefsClass="">
<cfset this.loginFormCheckboxClass="">
<cfset this.loginFormCheckboxWrapperClass="">
<cfset this.loginFormSubmitWrapperClass="checkbox">
<cfset this.loginFormSubmitClass="btn btn-default">
<cfset this.notRegisteredLinkClass="btn btn-primary">

<!--- Dsp_mailing_list_master.cfm --->
<cfset this.mailingListWrapperClass=this.generalWrapperClass>
<cfset this.mailingListWrapperBodyClass=this.generalWrapperBodyClass>
<cfset this.mailingListFormClass="form-horizontal">
<cfset this.mailingListFormGroupWrapperClass="">
<cfset this.mailingListFormLabelClass="control-label">
<cfset this.mailingListFormFieldWrapperClass="">
<cfset this.mailingListFormInputClass="">
<cfset this.mailingListCheckboxWrapperClass="">
<cfset this.mailingListCheckboxClass="checkbox">
<cfset this.mailingListSubmitWrapperClass="">
<cfset this.mailingListSubmitClass="btn btn-default">

<!--- Dsp_nextN.cfm --->
<cfset this.nextNWrapperClass="">
<cfset this.nextNInnerClass="pagination">

<!--- Dsp_search_form.cfm --->
<cfset this.searchFormClass="">
<cfset this.searchFormInputWrapperClass="">
<cfset this.searchFormInputClass="">
<cfset this.searchFormSubmitWrapperClass="">
<cfset this.searchFormSubmitClass="btn btn-default">

<!--- Dsp_search_results.cfm --->
<cfset this.searchShowNumbers=1>
<cfset this.searchResultWrapperClass="container">
<cfset this.searchResultInnerClass="row">
<cfset this.searchResultsRowClass="row">
<cfset this.searchResultsMoreResultsRowClass="row">
<cfset this.searchResultsListClass="svIndex">
<cfset this.searchResultsPagerClass="pager">
<cfset this.searchAgainRowClass="row">
<cfset this.searchAgainInnerClass="">
<cfset this.searchAgainFormClass="">
<cfset this.searchAgainInputWrapperClass="">
<cfset this.searchAgainFormInputClass="">
<cfset this.searchAgainButtonWrapperClass="">
<cfset this.searchAgainSubmitClass="btn btn-default">

<!--- Dsp_user_tools.cfm --->
<cfset this.userToolsLoginWrapperClass="#this.generalWrapperClass# clearfix">
<cfset this.userToolsLoginWrapperBodyClass=this.generalWrapperBodyClass>
<cfset this.userToolsLoginFormClass="form-horizontal">
<cfset this.userToolsFormGroupWrapperClass="">
<cfset this.userToolsLoginFormLabelClass="control-label">
<cfset this.userToolsLoginFormInputWrapperClass="">
<cfset this.userToolsLoginFormInputClass="">
<cfset this.userToolsLoginFormFieldInnerClass="">
<cfset this.userToolsLoginFormCheckboxClass="checkbox">
<cfset this.userToolsLoginFormSubmitClass="btn btn-default">
<cfset this.userToolsNotRegisteredLinkClass="btn btn-primary">
<cfset this.userToolsWrapperClass="clearfix">
<cfset this.userToolsEditProfileLinkClass="btn btn-default">
<cfset this.userToolsLogoutLinkClass="btn btn-default">

<!--- Favorites/index.cfm --->
<cfset this.userFavoritesWrapperClass="">
<cfset this.userFavoritesWrapperBodyClass="">
<cfset this.pageToolsWrapperClass="">
<cfset this.pageToolsWrapperBodyClass="">


<!--- Formbuilder/Dsp_form.cfm --->
<cfset this.formBuilderFieldWrapperClass="">
<cfset this.formBuilderButtonWrapperClass="form-actions">
<cfset this.formBuilderSubmitClass="btn btn-default">

<!---
 Formbuilder/Fields/Dsp_checkbox.cfm
 Formbuilder/Fields/Dsp_dropdown.cfm
 Formbuilder/Fields/Dsp_file.cfm
 Formbuilder/Fields/Dsp_radio.cfm
 Formbuilder/Fields/Dsp_textfield.cfm
--->
<cfset this.formBuilderFormFieldsClass="control-group">

<!--- Formbuilder/Fields/field_dropdown.cfm --->
<cfset this.formBuilderTabHeaderClass="dropdown">
<cfset this.formBuilderDisabledInputClass="disabled">
<cfset this.formBuilderCheckboxClass="checkbox">

<!--- Gallery/Index.cfm --->
<cfset this.galleryImageStyles=true>
<cfset this.galleryWrapperClass="">
<cfset this.galleryULClass="clearfix">
<cfset this.galleryLIClass="">
<cfset this.galleryThumbnailClass="thumbnail">

<!--- Nav/CalendarNav/index --->
<cfset this.navCalendarWrapperClass="svCalendar">

<!--- Nav/CalendarNav/NavTools.cfc --->
<cfset this.navCalendarTableClass="table table-bordered">

<!--- Nav/Dsp_sequential.cfm --->
<cfset this.navSequentialWrapperClass="pagination">
<cfset this.navSequentialULClass="">

<!--- Nav/dsp_tag_cloud.cfm --->
<cfset this.tagCloudWrapperClass="svTagCloud">

<!--- NavArchive --->
<cfset this.navArchiveWrapperClass="">
<cfset this.navArchiveListClass="">

<!--- NavBreadcrumb --->
<cfset this.navBreadcrumbULClass="breadcrumb">
<cfset this.liBreadcrumbCurrentClass="">
<cfset this.liBreadcrumbNotCurrentClass="">
<cfset this.aBreadcrumbCurrentClass="">
<cfset this.aBreadcrumbNotCurrentClass="">

<!--- Rater/Index.cfm --->
<cfset this.raterObjectWrapperClass="row clearfix">
<cfset this.raterWrapperClass="">
<cfset this.avgRatingWrapperClass="">

<cffunction name="init" output="false">
	<cfargument name="event" required="true" default="">

	<cfif isObject(arguments.event)>
		<cfset variables.event=arguments.event>
	<cfelse>
		<cfset variables.event=createObject("component","mura.servletEvent")>
	</cfif>

	<cfset variables.$=variables.event.getValue("muraScope")>
	<cfset variables.mura=variables.$>
	<cfset variables.m=variables.$>

	<cfif request.muraExportHtml>
		<cfset this.showEditableObjects=false>
		<cfset this.showAdminToolBar=false>
		<cfset this.showMemberToolBar=false>
	</cfif>

	<cfif not isBoolean(this.hashURLS)>
		<cfset this.hashURLS=application.configBean.getHashURLS()>
	</cfif>

	<!---  Backward support --->
	<cfif structKeyExists(this,'liHasKidsCustomString') and len(this.liHasKidsCustomString)>
		<cfset this.liHasKidsAttributes=this.liHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(this,'liCurrentCustomString') and len(this.liCurrentCustomString)>
		<cfset this.liCurrentAttributes=this.liCurrentCustomString>
	</cfif>
	<cfif structKeyExists(this,'aHasKidsCustomString') and len(this.aHasKidsCustomString)>
		<cfset this.aHasKidsAttributes=this.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(this,'aCurrentCustomString') and len(this.aCurrentCustomString)>
		<cfset this.aCurrentAttributes=this.aCurrentCustomString>
	</cfif>
	<cfif structKeyExists(this,'ulNestedCustomString') and len(this.ulNestedCustomString)>
		<cfset this.ulNestedAttributes=this.ulNestedCustomString>
	</cfif>

	<cfset variables.contentGateway=getBean('contentGateway')>
	<cfset variables.contentRendererUtility=getBean('contentRendererUtility')>

	<cfif not isDefined('this.enableMuraTag')>
		<cfset this.enableMuraTag=getConfigBean().getEnableMuraTag() />
	</cfif>

	<cfif not isDefined('this.enableDynamicContent')>
		<cfset this.enableDynamicContent=getConfigBean().getEnableDynamicContent() />
	</cfif>

	<cfscript>
		this.siteIDInURLs = Len(variables.$.event('siteid')) && variables.$.siteConfig().getValue(property='isRemote',defaultValue=false)
			? false
			: Len(variables.$.event('siteid')) && IsBoolean(this.siteIDInURLs)
				? this.siteIDInURLs
				: application.configBean.getSiteIDInURLs();

		this.indexFileInURLs = Len(variables.$.event('siteid')) && variables.$.siteConfig().getValue(property='isRemote',defaultValue=false)
			? false
			: Len(variables.$.event('siteid')) && IsBoolean(this.indexFileInURLs)
				? this.indexFileInURLs
				: application.configBean.getIndexFileInURLs();

		if(isDefined('url.enableFrontEndTools') && isBoolean(url.enableFrontEndTools)){
			session.enableFrontEndTools = url.enableFrontEndTools;
		}
		
		if(isDEfined('session.enableFrontEndTools') && isBoolean(session.enableFrontEndTools)){
			this.enableFrontEndTools = session.enableFrontEndTools;
		} else {
			this.enableFrontEndTools = IsDefined('this.enableFrontEndTools')
				? this.enableFrontEndTools
				: IsBoolean(getConfigBean().getEnableFrontEndTools())
					? getConfigBean().getEnableFrontEndTools()
					: true;
		}
	</cfscript>

	<cfreturn this />
</cffunction>

<cffunction name="getClientRenderVariables" output="false">
	<cfreturn {
    generalwrapperclass = this.generalwrapperclass,
    generalwrapperbodyclass = this.generalwrapperbodyclass,
    formWrapperClass=this.formWrapperClass,
  	formWrapperBodyClass=this.formWrapperBodyClass,
		formErrorWrapperClass=this.formErrorWrapperClass,
		formResponseWrapperClass=this.formResponseWrapperClass,
  	formFieldWrapperClass = this.formFieldWrapperClass,
  	formFieldLabelClass = this.formFieldLabelClass,
  	formGeneralControlClass = this.formGeneralControlClass,
  	formInputClass=this.formInputClass,
  	formSelectClass = this.formSelectClass,
  	formTextareaClass = this.formTextareaClass,
  	formFileClass = this.formFileClass,
  	formCheckboxClass = this.formCheckboxClass,
  	formCheckboxLabelClass = this.formCheckboxLabelClass,
		formCheckboxWrapperClass = this.formCheckboxWrapperClass,
		formRadioWrapperClass = this.formRadioWrapperClass,
  	formRadioClass = this.formRadioClass,
  	formRadioLabelClass = this.formRadioLabelClass,
  	formButtonWrapperClass = this.formButtonWrapperClass,
  	formButtonInnerClass=this.formButtonInnerClass,
  	formButtonClass = this.formButtonClass,
  	formRequiredWrapperClass = this.formRequiredWrapperClass,
		formButtomSubmitclass = this.formButtomSubmitclass,
		formButtonSubmitclass = this.formButtonSubmitclass,
		formButtonSubmitLabel = this.formButtonSubmitLabel,
		formButtonSubmitWaitLabel = this.formButtonSubmitWaitLabel,
		formButtonNextlClass = this.formButtonNextlClass,
		formButtonNextLabel = this.formButtonNextLabel,
		formButtonBackClass = this.formButtonBackClass,
		formButtonBackLabel = this.formButtonBackLabel,
		formButtonCancelLabel = this.formButtonCancelLabel,
		formButtonCancelClass = this.formButtonCancelClass,
		formRequiredLabel = this.formRequiredLabel
  }>

</cffunction>

<cffunction name="postMergeInit" output="false">
	<cfscript>
		var renderProps='';

		if(isDefined('application.muraExternalConfig.global.rendererProperties')){
			renderProps=application.muraExternalConfig.global.rendererProperties;
			if(isStruct(renderProps)){
				for ( var key in renderProps ) {
					this.injectMethod('#key#',renderProps[key]);
				}
			}
		}
		if(isValid('variableName',variables.event.getValue('siteID')) && isDefined('application.muraExternalConfig.sites.#variables.event.getValue('siteID')#.rendererProperties')){
			renderProps=application.muraExternalConfig.sites[variables.event.getValue('siteID')].rendererProperties;
			if(isStruct(renderProps)){
				for ( var key in renderProps ) {
					this.injectMethod('#key#',renderProps[key]);
				}
			}
		}

		this.asyncObjects=request.muraFrontEndRequest && (this.asyncObjects || this.layoutmanager);
		this.asyncRender=!this.asyncObjects;
		return this;
	</cfscript>
</cffunction>

<cffunction name="OnMissingMethod" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
	<cfscript>
		var prefix=left(arguments.MissingMethodName,3);

		if(listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3){
			var prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3);

			if(prefix eq "get"){
				param name='this.#prop#' default='';
				return this['#prop#'];
			}

			if(not structIsEmpty(arguments.MissingMethodArguments)){
				this['#prop#']=arguments.MissingMethodArguments[1];
				return this;;
			} else {
				throw(message="The method '#arguments.MissingMethodName#' requires a propery value");
			}

		} else {
			throw(message="The method '#arguments.MissingMethodName#' is not defined");
		}
	</cfscript>

</cffunction>

<cffunction name="getHeaderTag" output="false">
<cfargument name="header">
	<cfif listFindNoCase("headline,subHead1,subHead2,subHead3,subHead4,subHead5",arguments.header)>
	<cfreturn this["#arguments.header#"]/>
	<cfelse>
	<cfreturn "Invalid Argument. Must be one of 'headline, subHead1, subHead2, subHead3, subHead4, subHead5'">
	</cfif>
</cffunction>

<cffunction name="setJsLib" output="false">
<cfargument name="jsLib">
	<cfset this.jsLib=arguments.jsLib />
</cffunction>

<cffunction name="setHasEditableObjects" output="false">
<cfargument name="hasEditableObjects">
	<cfset this.hasEditableObjects=arguments.hasEditableObjects />
</cffunction>

<cffunction name="getJsLib" output="false">
	<cfreturn this.jsLib />
</cffunction>

<cffunction name="setRenderHTMLQueues" output="false">
<cfargument name="renderHTMLQueues">
	<cfset this.renderHTMLQueues=arguments.renderHTMLQueues />
</cffunction>

<cffunction name="getRenderHTMLQueues" output="false">
	<cfreturn this.renderHTMLQueues and this.renderHTMLHead />
</cffunction>

<cffunction name="setRenderHTMLHead" output="false" hint="This is deprecated.">
<cfargument name="renderHTMLHead">
	<cfset this.renderHTMLQueues=arguments.renderHTMLHead />
</cffunction>

<cffunction name="getRenderHTMLHead" output="false" hint="This is deprecated.">
	<cfreturn this.renderHTMLQueues />
</cffunction>

<cffunction name="setShowAdminToolBar" output="false">
<cfargument name="showAdminToolBar">
	<cfset this.showAdminToolBar=arguments.showAdminToolBar />
</cffunction>

<cffunction name="getShowAdminToolBar" output="false">
	<cfreturn this.showAdminToolBar />
</cffunction>

<cffunction name="getPersonalization" output="false">
	<cfreturn this.personalization />
</cffunction>

<cffunction name="loadJSLib" output="false">
	<!--- deprecated --->
</cffunction>

<cffunction name="loadPrettify" output="false">
	<cfset addToHTMLHeadQueue("prettify.cfm")>
</cffunction>

<cffunction name="setLongDateFormat" output="false">
<cfargument name="longDateFormat">
	<cfset this.longDateFormat=arguments.longDateFormat />
</cffunction>

<cffunction name="getLongDateFormat" output="false">
	<cfreturn this.longDateFormat />
</cffunction>

<cffunction name="setShortDateFormat" output="false">
<cfargument name="shortDateFormat">
	<cfset this.shortDateFormat=arguments.shortDateFormat />
</cffunction>

<cffunction name="getShortDateFormat" output="false">
	<cfreturn this.shortDateFormat />
</cffunction>

<cffunction name="setNavOffSet" output="false">
<cfargument name="navOffSet">
	<cfif not variables.event.getValue('contentBean').getIsNew()>
		<cfset this.navOffSet=arguments.navOffSet />
	</cfif>
</cffunction>

<cffunction name="getNavOffSet" output="false">
<cfargument name="navOffSet">
		<cfreturn this.navOffSet/>
</cffunction>

<cffunction name="setNavDepthLimit" output="false">
<cfargument name="navDepthLimit">

	<cfset this.navDepthLimit=arguments.navDepthLimit />

	<cfif arrayLen(this.crumbdata) gt this.navDepthLimit >
		<cfset this.navDepthAdjust=arraylen(this.crumbdata)-this.navDepthLimit />
		<cfset this.navGrandParentIdx= 3 + this.navDepthAdjust />
		<cfset this.navParentIdx=2 + this.navDepthAdjust />
		<cfset this.navSelfIdx= 1 + this.navDepthAdjust />
	</cfif>

</cffunction>

<cffunction name="showItemMeta" output="false">
<cfargument name="fileExt">
	<cfif listFindNoCase(this.showMetaList,arguments.fileExt)>
	<cfreturn 1>
	<cfelse>
	<cfreturn variables.event.getValue('showMeta')>
	</cfif>
</cffunction>

<cffunction name="showImageInList" output="false">
<cfargument name="fileExt">
	<cfreturn listFindNoCase(this.imageInList,arguments.fileExt)>
</cffunction>

<cffunction name="dspNestedNav" output="false">
	<cfargument name="contentid" type="string" >
	<cfargument name="viewDepth" type="numeric" required="true" default="1">
	<cfargument name="currDepth" type="numeric"  required="true"  default="1">
	<cfargument name="type" type="string"  default="default">
	<cfargument name="today" type="date"  default="#now()#">
	<cfargument name="class" type="string" default="#this.ulTopClass#">
	<cfargument name="querystring" type="string" default="">
	<cfargument name="sortBy" type="string" default="orderno">
	<cfargument name="sortDirection" type="string" default="asc">
	<cfargument name="context" type="string" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" default="#application.configBean.getStub()#">
	<cfargument name="categoryID" type="string" default="">
	<cfargument name="relatedID" type="string" default="">
	<cfargument name="rs" required="true" default="">
	<cfargument name="subNavExpression" required="true" default="">
	<cfargument name="navLIClass" required="true" default="#this.navLIClass#">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsAttributes" required="true" default="#this.liHasKidsAttributes#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentAttributes" required="true" default="#this.liCurrentAttributes#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">
	<cfargument name="ulNestedClass" required="true" default="#this.ulNestedClass#">
	<cfargument name="ulNestedAttributes" required="true" default="#this.ulNestedAttributes#">
	<cfargument name="openCurrentOnly" required="true" default="false">
	<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">
	<cfargument name="size" required="true" default="#this.navsize#">
	<cfargument name="liClass" type="string" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="setLiIds" type="boolean" default="false">

	<cfif structKeyExists(arguments,'liHasKidsCustomString')>
		<cfset arguments.liHasKidsAttributes=arguments.liHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'liCurrentCustomString')>
		<cfset arguments.liCurrentAttributes=arguments.liCurrentCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aHasKidsCustomString')>
		<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aCurrentCustomString')>
		<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'ulNestedCustomString')>
		<cfset arguments.ulNestedAttributes=arguments.ulNestedCustomString>
	</cfif>

	<cfset var rsSection=arguments.rs>
	<cfset var adjust=0>
	<cfset var current=0>
	<cfset var link=''>
	<cfset var itemClass=''>
	<cfset var isCurrent=false>
	<cfset var nest=''>
	<cfset var subnav=false>
	<cfset var theNav="">
	<cfset var nestedArgs=structNew()>
	<cfset var linkArgs=structNew()>
	<cfset var started=false>
	<cfset var sessionData=getSession()>

	<cfif not isQuery(rsSection)>
		<cfset rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000',variables.event.getValue('siteID'),arguments.contentid,arguments.type,arguments.today,Val(arguments.size),'',0,arguments.sortBy,arguments.sortDirection,arguments.categoryID,arguments.relatedID)>
	</cfif>

	<cfif isDefined("arguments.ulTopClass") and arguments.currDepth eq 1>
		<cfset arguments.class=arguments.ulTopClass>
	</cfif>

	<cfif rsSection.recordcount and ((variables.event.getValue('r').restrict and variables.event.getValue('r').allow) or (not variables.event.getValue('r').restrict))>
		<cfset adjust=rsSection.recordcount>

		<cfsavecontent variable="theNav">
		<cfoutput>
		<cfloop query="rsSection">
		<cfif allowLink(rssection.restricted,rssection.restrictgroups,variables.event.getValue('r').loggedIn)>
		<cfsilent>
			<cfif len(arguments.subNavExpression)>
				<cfset subnav=evaluate(arguments.subNavExpression)>
			<cfelse>
				<cfset subnav=
				(
					(
						ListFind("Page,Folder,Calendar",rsSection.type)
						and arguments.openCurrentOnly
						and ListFindNoCase(ArrayToList(this.crumbData[this.navSelfIdx].parentArray), rsSection.contentid)
					) or (
						ListFindNoCase("Page,Calendar",rsSection.type)
						and not arguments.openCurrentOnly
					)
				)
				and arguments.currDepth lt arguments.viewDepth
				and rsSection.type neq 'Gallery'
				and not (rsSection.restricted and not sessionData.mura.isLoggedIn) />
			</cfif>

			<cfset current=current+1>
			<cfset nest=''>
			<cfif subnav>
				<cfset nestedArgs.contentID=rssection.contentid>
				<cfset nestedArgs.currDepth=arguments.currDepth+1>
				<cfset nestedArgs.type=iif(rssection.type eq 'calendar',de('fixed'),de('default'))>
				<cfset nestedArgs.sortBy=rsSection.sortBy>
				<cfset nestedArgs.sortDirection=rsSection.sortDirection>
				<cfset nestedArgs.class="">
				<cfset nestedArgs.ulTopClass="">
				<cfset structAppend(nestedArgs,arguments,false)>
				<cfset nest=this.dspNestedNav(argumentCollection=nestedArgs)>
				<cfset subnav=subnav and find("<li",nest)>
			</cfif>

			<cfset itemClass="">

			<cfif subnav and arguments.currDepth gt 1 and len(arguments.liHasKidsNestedClass)>
				<cfset itemClass=itemClass & " " & arguments.liHasKidsNestedClass>
			</cfif>

			<cfif Len(arguments.navLIClass)>
				<cfset itemClass=ListAppend(itemClass, arguments.navLIClass, ' ')>
			</cfif>

			<cfif Len(arguments.liClass)>
				<cfset itemClass=ListAppend(itemClass, arguments.liClass, ' ')>
			</cfif>

			<cfif current eq 1>
				<cfset itemClass=listAppend(itemClass,'first',' ')>
			</cfif>

			<cfif current eq adjust>
				<cfset itemClass=listAppend(itemClass,'last',' ')>
			</cfif>

			<cfset isCurrent=listFind(variables.event.getValue('contentBean').getPath(),"#rsSection.contentid#")>

			<cfif isCurrent and len(arguments.liCurrentClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liCurrentClass," ")>
			</cfif>

			<cfif subnav and len(arguments.liHasKidsClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liHasKidsClass," ")>
			</cfif>

			<cfset linkArgs=structNew()>
			<cfset linkArgs.aHasKidsClass=arguments.aHasKidsClass>
			<cfset linkArgs.aHasKidsAttributes=arguments.aHasKidsAttributes>
			<cfset linkArgs.aNotCurrentClass=arguments.aNotCurrentClass>
			<cfset linkArgs.aCurrentClass=arguments.aCurrentClass>
			<cfset linkArgs.aCurrentAttributes=arguments.aCurrentAttributes>
			<cfset linkArgs.type=rsSection.type>
			<cfset linkArgs.filename=rsSection.filename>
			<cfset linkArgs.title=rsSection.menutitle>
			<cfset linkArgs.contentid=rsSection.contentid>
			<cfset linkArgs.target=rsSection.target>
			<cfset linkArgs.targetParams=rsSection.targetParams>
			<cfset linkArgs.siteID=variables.event.getValue('siteID')>
			<cfset linkArgs.querystring=arguments.querystring>
			<cfset linkArgs.isParent=subnav>
			<cfset linkArgs.complete=arguments.complete>
			<cfset link=addlink(argumentCollection=linkArgs)>
		</cfsilent>
		<cfif not started>
			<cfset started=true>
			<ul<cfif arguments.currDepth eq 1 and len(arguments.class)> class="#arguments.class#"<cfelse><cfif len(arguments.ulNestedClass)> class="#arguments.ulNestedClass#"</cfif><cfif len(arguments.ulNestedAttributes)> #arguments.ulNestedAttributes#</cfif></cfif>>
		</cfif>
		<li<cfif len(itemClass)> class="#itemClass#"</cfif><cfif len(arguments.liCurrentAttributes)> #arguments.liCurrentAttributes#</cfif>>#link#<cfif subnav>#nest#</cfif></li><cfelse><cfset adjust=adjust-1></cfif></cfloop>
		<cfif started></ul></cfif></cfoutput>
		</cfsavecontent>
	</cfif>
	<cfreturn theNav />
</cffunction>

<!--- For backward compatibility --->
<cffunction name="dspPortalNav" output="false">
	<cfreturn dspFolderNav(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspFolderNav" output="false">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsAttributes" required="true" default="#this.liHasKidsAttributes#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentAttributes" required="true" default="#this.liCurrentAttributes#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">
	<cfargument name="ulNestedClass" required="true" default="#this.ulNestedClass#">
	<cfargument name="ulNestedAttributes" required="true" default="#this.ulNestedAttributes#">

	<cfset var thenav="" />
	<cfset var menutype="" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspFolderNav")>

	<!--- Supporting Old Arguments--->
	<cfif structKeyExists(arguments,'liHasKidsCustomString')>
		<cfset arguments.liHasKidsAttributes=arguments.liHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aHasKidsCustomString')>
		<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aCurrentCustomString')>
		<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'ulNestedCustomString')>
		<cfset arguments.ulNestedAttributes=arguments.ulNestedCustomString>
	</cfif>
	<!--- --->

	<cfset nestedArgs.openCurrentOnly=true>

	<cfif variables.event.getValue('contentBean').getType() eq 'Folder' or variables.event.getValue('contentBean').getType() eq 'Gallery'>
		<cfif arraylen(this.crumbdata) gt (this.navParentIdx+this.navOffSet)>
			<cfif arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and (this.crumbdata[this.navGrandParentIdx].type neq 'Folder' or this.crumbdata[this.navGrandParentIdx].type neq 'Gallery') and not variables.contentGateway.getCount(variables.event.getValue('siteID'),this.crumbdata[this.navSelfIdx].contentID)>
				<cfset nestedArgs.contentID=this.crumbdata[this.navGrandParentIdx].contentid>
				<cfset nestedArgs.viewDepth=2>
				<cfset nestedArgs.currDepth=1>
				<cfset nestedArgs.sortBy=this.crumbdata[this.navGrandParentIdx].sortBy>
				<cfset nestedArgs.sortDirection=this.crumbdata[this.navGrandParentIdx].sortDirection>
				<cfset nestedArgs.categoryID=variables.event.getValue('categoryID')>
				<cfset structAppend(nestedArgs,arguments,false)>
				<cfset theNav = this.dspNestedNav(argumentCollection=nestedArgs) />
			<cfelse>
				<cfset thenav=this.dspPeerNav(argumentCollection=arguments) />
			</cfif>
		</cfif>
	<cfelseif arrayLen(this.crumbdata) gt (this.navSelfIdx+this.navOffSet) and this.crumbdata[this.navParentIdx].type eq 'Folder' or (arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and this.crumbdata[this.navGrandParentIdx].type eq 'Folder')>
		<cfif arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and this.crumbdata[this.navGrandParentIdx].type neq 'Folder' and not variables.contentGateway.getCount(variables.event.getValue('siteID'),this.crumbdata[this.navSelfIdx].contentID)>
			<cfset nestedArgs.contentID=this.crumbdata[this.navGrandParentIdx].contentid>
			<cfset nestedArgs.viewDepth=1>
			<cfset nestedArgs.currDepth=1>
			<cfset nestedArgs.sortBy=this.crumbdata[this.navGrandParentIdx].sortBy>
			<cfset nestedArgs.sortDirection=this.crumbdata[this.navGrandParentIdx].sortDirection>
			<cfset nestedArgs.categoryID=variables.event.getValue('categoryID')>
			<cfset structAppend(nestedArgs,arguments,false)>

			<cfset theNav = this.dspNestedNav(argumentCollection=nestedArgs) />
		<cfelse>
			<cfset thenav=this.dspSubNav(argumentCollection=nestedArgs) />
		</cfif>
	<cfelse>
		<cfset thenav=this.dspStandardNav(argumentCollection=nestedArgs) />
	</cfif>
	<cfset commitTracePoint(tracePoint)>

	<cfreturn thenav />
</cffunction>

<cffunction name="dspStandardNav" output="false">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsAttributes" required="true" default="#this.liHasKidsAttributes#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentAttributes" required="true" default="#this.liCurrentAttributes#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">
	<cfargument name="ulNestedClass" required="true" default="#this.ulNestedClass#">
	<cfargument name="ulNestedAttributes" required="true" default="#this.ulNestedAttributes#">
	<cfset var thenav="" />
	<cfset var menutype="" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspStandardNav")>

	<!--- Supporting Old Arguments--->
	<cfif structKeyExists(arguments,'liHasKidsCustomString')>
		<cfset arguments.liHasKidsAttributes=arguments.liHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aHasKidsCustomString')>
		<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aCurrentCustomString')>
		<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'ulNestedCustomString')>
		<cfset arguments.ulNestedAttributes=arguments.ulNestedCustomString>
	</cfif>
	<!--- --->

	<cfset nestedArgs.openCurrentOnly=true>

	<cfif not listFindNoCase('Gallery,Folder',variables.event.getValue('contentBean').getType())>
			<cfif arraylen(this.crumbdata) gt (this.navParentIdx+this.navOffSet)>
				<cfif this.crumbdata[this.navParentIdx].type eq 'calendar'>
					<cfset menutype='fixed'>
				<cfelse>
					<cfset menutype='default'>
				</cfif>
				<cfif arraylen(this.crumbdata) gt (this.navGrandParentIdx+this.navOffSet) and not variables.contentGateway.getCount(variables.event.getValue('siteID'),this.crumbdata[this.navSelfIdx].contentID)>
					<cfset nestedArgs.contentID=this.crumbdata[this.navGrandParentIdx].contentid>
					<cfset nestedArgs.viewDepth=2>
					<cfset nestedArgs.currDepth=1>
					<cfset nestedArgs.type=menutype>
					<cfset nestedArgs.sortBy=this.crumbdata[this.navGrandParentIdx].sortBy>
					<cfset nestedArgs.sortDirection=this.crumbdata[this.navGrandParentIdx].sortDirection>
					<cfset structAppend(nestedArgs,arguments,false)>
					<cfset theNav = this.dspNestedNav(argumentCollection=nestedArgs) />
				<cfelse>
					<cfset nestedArgs.contentID=this.crumbdata[this.navParentIdx].contentid>
					<cfset nestedArgs.viewDepth=2>
					<cfset nestedArgs.currDepth=1>
					<cfset nestedArgs.type=menutype>
					<cfset nestedArgs.sortBy=this.crumbdata[this.navParentIdx].sortBy>
					<cfset nestedArgs.sortDirection=this.crumbdata[this.navParentIdx].sortDirection>
					<cfset structAppend(nestedArgs,arguments,false)>
					<cfset theNav = this.dspNestedNav(argumentCollection=nestedArgs) />
				</cfif>
			<cfelse>
				<cfset theNav=this.dspSubNav(argumentCollection=arguments) />
			</cfif>
	<cfelse>
			<cfset thenav=this.dspFolderNav(argumentCollection=arguments) />
	</cfif>

	<cfset commitTracePoint(tracePoint)>

	<cfreturn thenav>
</cffunction>

<cffunction name="dspSubNav" output="false">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsAttributes" required="true" default="#this.liHasKidsAttributes#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentAttributes" required="true" default="#this.liCurrentAttributes#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">

	<cfset var thenav="" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspSubNav")>

	<!--- Supporting Old Arguments--->
	<cfif structKeyExists(arguments,'liHasKidsCustomString')>
		<cfset arguments.liHasKidsAttributes=arguments.liHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aHasKidsCustomString')>
		<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aCurrentCustomString')>
		<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'ulNestedCustomString')>
		<cfset arguments.ulNestedAttributes=arguments.ulNestedCustomString>
	</cfif>
	<!--- --->

	<cfset nestedArgs.openCurrentOnly=true>

	<cfif arraylen(this.crumbdata) gt (this.navSelfIdx+this.navOffSet)>
		<cfset nestedArgs.contentID=this.crumbdata[this.navSelfIdx].contentID>
		<cfset nestedArgs.viewDepth=1>
		<cfset nestedArgs.currDepth=1>
		<cfif this.crumbdata[this.navSelfIdx].type eq 'Calendar'>
			<cfset nestedArgs.type='fixed'>
		<cfelse>
			<cfset nestedArgs.type='default'>
		</cfif>
		<cfset nestedArgs.sortBy=this.crumbdata[this.navSelfIdx].sortBy>
		<cfset nestedArgs.sortDirection=this.crumbdata[this.navSelfIdx].sortDirection>
		<cfset structAppend(nestedArgs,arguments,false)>
		<cfset theNav = this.dspNestedNav(argumentCollection=nestedArgs) />
	</cfif>

	<cfset commitTracePoint(tracePoint)>

	<cfreturn thenav />
</cffunction>

<cffunction name="dspPeerNav" output="false">
	<cfargument name="class" default="#this.ulTopClass#" required="true">
	<cfargument name="liHasKidsClass" required="true" default="#this.liHasKidsClass#">
	<cfargument name="liHasKidsAttributes" required="true" default="#this.liHasKidsAttributes#">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentAttributes" required="true" default="#this.liCurrentAttributes#">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">

	<cfset var thenav="" />
	<cfset var menutype = "" />
	<cfset var nestedArgs=structNew()>
	<cfset var tracepoint=initTracepoint("contentRenderer.dspPeerNav")>

	<!--- Supporting Old Arguments--->
	<cfif structKeyExists(arguments,'liHasKidsCustomString')>
		<cfset arguments.liHasKidsAttributes=arguments.liHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aHasKidsCustomString')>
		<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aCurrentCustomString')>
		<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'ulNestedCustomString')>
		<cfset arguments.ulNestedAttributes=arguments.ulNestedCustomString>
	</cfif>
	<!--- --->

	<cfset nestedArgs.openCurrentOnly=true>

	<cfif variables.event.getContentBean().getContentID() neq '00000000000000000000000000000000001'
		 and arraylen(this.crumbdata) gt (this.navParentIdx+this.navOffSet)>
		<cfset nestedArgs.contentID=this.crumbdata[this.navParentIdx].contentID>
		<cfset nestedArgs.viewDepth=1>
		<cfset nestedArgs.currDepth=1>
		<cfif this.crumbdata[this.navParentIdx].type eq 'calendar'>
			<cfset nestedArgs.type='fixed'>
		<cfelse>
			<cfset nestedArgs.type='default'>
		</cfif>
		<cfset nestedArgs.sortBy=this.crumbdata[this.navParentIdx].sortBy>
		<cfset nestedArgs.sortDirection=this.crumbdata[this.navParentIdx].sortDirection>
		<cfset structAppend(nestedArgs,arguments,false)>
		<cfset theNav = this.dspNestedNav(argumentCollection=nestedArgs) />
	</cfif>

	<cfset commitTracePoint(tracePoint)>

	<cfreturn theNav />
</cffunction>

<cffunction name="dspSequentialNav" output="false">
		<cfset var rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000','#variables.event.getValue('siteID')#','#variables.event.getValue('contentBean').getparentid()#','default',now(),0,'',0,'#this.crumbdata[2].sortBy#','#this.crumbdata[2].sortDirection#')>
		<cfset var link=''>
		<cfset var class=''>
		<cfset var itemClass=''>
		<cfset var theNav="">
		<cfset var current=1>
		<cfset var next=1>
		<cfset var prev=1>
		<cfset var tracepoint=initTracepoint("contentRenderer.dspSequentialNav")>

		<cfif rsSection.recordcount and ((variables.event.getValue('r').restrict and variables.event.getValue('r').allow) or (not variables.event.getValue('r').restrict))>
			<cfloop query="rsSection">
			<cfif rssection.filename eq variables.event.getValue('contentBean').getfilename()>
				<cfset prev=iif((rsSection.currentrow - 1) lt 1,de(rsSection.recordcount),de(rsSection.currentrow-1)) />
				<cfset current=rsSection.currentrow />
				<cfset next=iif((rsSection.currentrow + 1) gt rsSection.recordcount,de(1),de(rsSection.currentrow + 1)) />
			</cfif>
			</cfloop>

			<cfsavecontent variable="theNav">
			<cfoutput>
			<ul class="#this.ulPaginationClass#">
			<cfif rsSection.contentID[1] neq variables.event.getValue('contentBean').getContentID()>
			<li ><a href="./index.cfm?linkServID=#rsSection.contentID[prev]#">&laquo; #getSite().getRBFactory().getKey("sitemanager.prev")#</a></li>
			</cfif>
			<cfloop query="rsSection">
			<cfsilent>
				<cfset itemClass=iif(variables.event.getValue('contentBean').getfilename() eq rsSection.filename,de('#this.liCurrentClass#'),de('')) />
				<cfset link=addlink(rsSection.type,rsSection.filename,rssection.currentrow,'','',rsSection.contentid,variables.event.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile(),showItemMeta(rsSection.fileExt))>
			</cfsilent>
			<li<cfif len(itemClass)> class="#itemClass#"</cfif>>#link#</li>
			</cfloop>
			<cfif rsSection.contentID[rsSection.recordcount] neq variables.event.getValue('contentBean').getContentID()>
			<li><a href="./index.cfm?linkServID=#rsSection.contentID[next]#">#getSite().getRBFactory().getKey("sitemanager.next")# &raquo;</a></li>
			</cfif>
			</ul></cfoutput>
			</cfsavecontent>
		</cfif>

		<cfset commitTracePoint(tracePoint)>

		<cfreturn trim(theNav) />
</cffunction>

<cffunction name="dspGalleryNav" output="false">
		<cfset var rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000',variables.event.getValue('siteID'),variables.event.getValue('contentBean').getcontentID(),'default',now(),0,'',0,variables.event.getValue('contentBean').getsortBy(),variables.event.getValue('contentBean').getsortDirection(),variables.event.getValue('categoryID'),variables.event.getValue('relatedID'))>
		<cfset var link=''>
		<cfset var class=''>
		<cfset var itemClass=''>
		<cfset var theNav="">
		<cfset var current=1>
		<cfset var next=1>
		<cfset var prev=1>
		<cfset var tracepoint=initTracepoint("contentRenderer.dspGalleryNav")>

		<cfif rsSection.recordcount and ((variables.event.getValue('r').restrict and variables.event.getValue('r').allow) or (not variables.event.getValue('r').restrict))>

			<cfloop query="rsSection">
			<cfif rssection.contentID eq variables.event.getValue('galleryItemID')>
				<cfset prev=iif((rsSection.currentrow - 1) lt 1,de(rsSection.recordcount),de(rsSection.currentrow-1)) />
				<cfset current=rsSection.currentrow />
				<cfset next=iif((rsSection.currentrow + 1) gt rsSection.recordcount,de(1),de(rsSection.currentrow + 1)) />
			</cfif>
			</cfloop>

			<cfsavecontent variable="theNav">
			<cfoutput>
			<ul class="#this.navSequentialULClass#">
			<li class="first">
			 <a href="#application.configBean.getIndexFile()#?startrow=#variables.event.getValue('startRow')#&galleryItemID=#rsSection.contentid[prev]#&categoryID=#variables.event.getValue('categoryID')#&relatedID=#variables.event.getValue('relatedID')#">&laquo; Prev</a>
			</li>
			<cfloop query="rsSection">
			<cfsilent>
				<cfset itemClass=iif(variables.event.getValue('galleryItemID') eq rsSection.contentID,de('current'),de('')) />
				<cfset link='<a href="#application.configBean.getIndexFile()#?startrow=#variables.event.getValue('startRow')#&galleryItemID=#rsSection.contentID#&categoryID=#variables.event.getValue('categoryID')#">#rsSection.currentRow#</a>'>
			</cfsilent>
			<li class="#itemClass#">#link#</li>
			</cfloop>
			<li class="last"> <a href="#application.configBean.getIndexFile()#?startrow=#variables.event.getValue('startRow')#&galleryItemID=#rsSection.contentid[next]#&categoryID=#variables.event.getValue('categoryID')#">Next &raquo;</a></li>
			</ul></cfoutput>
			</cfsavecontent>
		</cfif>

		<cfset commitTracePoint(tracePoint)>

		<cfreturn trim(theNav) />
</cffunction>

<cffunction name="dspSessionNav" output="false">
	<cfargument name="id" type="string" default="">
	<cfset var returnUrl = "" />
	<cfset var thenav = "" />
	<cfset var sessionData=getSession()>

	<cfif variables.event.getValue('returnURL') neq "">
		<cfset returnUrl = variables.event.getValue('returnURL')>
	<cfelse>
		<cfset returnURL = URLEncodedFormat(getCurrentURL())>
	</cfif>

	<cfsavecontent variable="theNav">
		<cfif getSite().getExtranet() eq 1 and sessionData.mura.isLoggedIn>
			<cfoutput><ul id="#arguments.id#"><li><a href="#application.configBean.getIndexFile()#?doaction=logout&nocache=1">Log Out #HTMLEditFormat("#sessionData.mura.fname# #sessionData.mura.lname#")#</a></li><li><a href="#application.settingsManager.getSite(variables.event.getValue('siteID')).getEditProfileURL()#&returnURL=#returnURL#&nocache=1">Edit Profile</a></li></ul></cfoutput>
		</cfif>
	</cfsavecontent>

	<cfreturn trim(thenav) />
</cffunction>

<cffunction name="dspTagCloud" output="false">
<cfargument name="parentID" type="any"  required="true" default="" />
<cfargument name="categoryID"  type="any" required="true" default="" />
<cfargument name="rsContent"  type="any"  required="true"  default="" />
<cfargument name="taggroup"  type="any"  required="true"  default="" />
	<cfset var theIncludePath = variables.event.getSite().getIncludePath() />
	<cfset var theExandedIncludePath = expandPath(variables.event.getSite().getIncludePath()) />
	<cfset var fileDelim = "/" />
	<cfset var filePath = theIncludePath  & fileDelim & "includes" & fileDelim />
	<cfset var theContent = "" />
	<cfset var theme =variables.$.siteConfig("theme")>
	<cfset var expandedPath=expandPath(filePath)>
	<cfset var str="">
	<cfset var tracePoint=0>

	<cfsavecontent variable="str">
	<cfif fileExists(expandedPath & "themes/"  & theme & "/modules/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#filePath#themes/#theme#/modules/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#themes/#theme#/display_objects/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandedPath & "themes/"  & theme & "/display_objects/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#filePath#themes/#theme#/display_objects/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#themes/#theme#/display_objects/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandedPath & "modules/custom/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#filePath#display_objects/custom/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#modules/custom/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandedPath & "display_objects/custom/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#filePath#display_objects/custom/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#display_objects/custom/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(theExandedIncludePath & "/modules/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#theExandedIncludePath#/modules/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#theIncludePath#/modules/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(theExandedIncludePath & "/display_objects/nav/dsp_tag_cloud.cfm")>
		<cfset tracePoint=initTracePoint("#theExandedIncludePath#/display_objects/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#theIncludePath#/display_objects/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandPath("#filePath#modules/nav/dsp_tag_cloud.cfm"))>
		<cfset tracePoint=initTracePoint("#filePath#modules/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#display_objects/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandPath("#filePath#display_objects/nav/dsp_tag_cloud.cfm"))>
		<cfset tracePoint=initTracePoint("#filePath#display_objects/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="#filePath#display_objects/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandPath("/muraWRM/modules/nav/dsp_tag_cloud.cfm"))>
		<cfset tracePoint=initTracePoint("/muraWRM/modules/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="/muraWRM/modules/nav/dsp_tag_cloud.cfm" />
	<cfelseif fileExists(expandPath("/muraWRM/display_objects/nav/dsp_tag_cloud.cfm"))>
		<cfset tracePoint=initTracePoint("/modules/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="/muraWRM/display_objects/nav/dsp_tag_cloud.cfm" />
	<cfelse>
		<cfset tracePoint=initTracePoint("/core/modules/v1/nav/dsp_tag_cloud.cfm")>
		<cfinclude template="/muraWRM/core/modules/v1/nav/dsp_tag_cloud.cfm" />
	</cfif>
	</cfsavecontent>

	<cfset commitTracePoint(tracePoint)>

<cfreturn str />
</cffunction>

<cffunction name="dspObject_Render" output="false">
	<cfargument name="siteid" type="string" />
	<cfargument name="object" type="string" />
	<cfargument name="objectid" type="string" default=""/>
	<cfargument name="fileName" type="string" default=""/>
	<cfargument name="cacheKey" type="string" required="false"  />
	<cfargument name="hasSummary" type="boolean" required="false" default="true" />
	<cfargument name="useRss" type="boolean" required="false" default="false" />
	<cfargument name="params" required="false" default="" />
	<cfargument name="assignmentID" type="string" required="true" default="">
	<cfargument name="regionID" required="true" default="0">
	<cfargument name="orderno" required="true" default="0">
	<cfargument name="showEditable" required="true" default="false">
	<cfargument name="isConfigurator" required="true" default="false">
	<cfargument name="objectname" required="true" default="">
	<cfargument name="bodyRender" required="true" default="false">
	<cfargument name="returnformat" required="true" default="html">
	<cfargument name="include" required="true" default="false">
	<cfargument name="RenderingAsRegion" required="true" default="false">

	<cfset var theContent=""/>
	<cfset var objectPerm="none">
	<cfset var result="">

	<cfif StructKeyExists(arguments,"cacheKey") and not arguments.showEditable and not arguments.include and arguments.object neq 'plugin'>
		<cfsavecontent variable="theContent">
		<cf_CacheOMatic key="#arguments.cacheKey##request.muraFrontEndRequest#" nocache="#variables.event.getValue('nocache')#">
			<cfset result=dspObject_Include(arguments.siteid,arguments.object,arguments.objectid,arguments.fileName,arguments.hasSummary,arguments.useRss,"none",arguments.params,arguments.assignmentID,arguments.regionID,arguments.orderno,'',true,arguments.showEditable,arguments.isConfigurator,arguments.objectname,arguments.bodyRender,arguments.returnformat,arguments.include,arguments.RenderingAsRegion)>
			<cfif isSimpleValue(result)>
				<cfoutput>#result#</cfoutput>
			<cfelse>
				<cfset request.cacheItem=false>
			</cfif>
		</cf_cacheomatic>
		</cfsavecontent>

		<cfif isSimpleValue(result)>
			<cfreturn trim(theContent)>
		<cfelse>
			<cfreturn result>
		</cfif>
	<cfelse>
		<cfset result = dspObject_Include(arguments.siteid,arguments.object,arguments.objectid,arguments.fileName,arguments.hasSummary,arguments.useRss,objectPerm,arguments.params,arguments.assignmentID,arguments.regionID,arguments.orderno,'',true,arguments.showEditable,arguments.isConfigurator,arguments.objectname,arguments.bodyRender,arguments.returnformat,arguments.include,arguments.RenderingAsRegion) />

		<cfif isSimpleValue(result)>
			<cfreturn trim(result)>
		<cfelse>
			<cfreturn result>
		</cfif>
	</cfif>


</cffunction>

<cffunction name="dspObject_Include" output="false">
	<cfargument name="siteid" type="string" default="#variables.$.event('siteid')#"/>
	<cfargument name="object" type="string" default="" />
	<cfargument name="objectid" type="string" default=""/>
	<cfargument name="theFile" type="string" />
	<cfargument name="hasSummary" type="boolean" required="true" default="false"/>
	<cfargument name="RSS" type="boolean" required="true" default="false" />
	<cfargument name="objectPerm" type="string" required="true" default="none" />
	<cfargument name="params" required="true" default="" />
	<cfargument name="assignmentID" type="string" required="true" default="">
	<cfargument name="regionID" required="true" default="0">
	<cfargument name="orderno" required="true" default="0">
	<cfargument name="contentHistID" required="true" default="">
	<cfargument name="throwError" default="true">
	<cfargument name="showEditable" required="true" default="false">
	<cfargument name="isConfigurator" required="true" default="false">
	<cfargument name="objectname" required="true" default="">
	<cfargument name="bodyRender" required="true" default="false">
	<cfargument name="returnFormat" required="true" default="html">
	<cfargument name="include" required="true" default="false">
	<cfargument name="RenderingAsRegion" required="true" default="false">

	<cfparam name="request.muraDisplayObjectNestLevel" default="0">

	<cfset var fileDelim = "/" />
	<cfset var displayObjectPath = variables.$.siteConfig('IncludePath') & fileDelim & "includes"  & fileDelim & "display_objects"/>
	<cfset var themeObjectPath = variables.$.siteConfig('ThemeIncludePath') & fileDelim & "display_objects"/>
	<cfset var themePath = variables.$.siteConfig('themeAssetPath') />
	<cfset var useRss = arguments.RSS />
	<cfset var bean = "" />
	<cfset var theContent = "" />
	<cfset var editableControl = structNew()>
	<cfset var expandedDisplayObjectPath=expandPath(displayObjectPath)>
	<cfset var expandedThemeObjectPath=expandPath(themeObjectPath)>
	<cfset var tracePoint=0>
	<cfset var result=''>

	<cfset request.muraDisplayObjectNestLevel=request.muraDisplayObjectNestLevel+1>

	<cfif not isDefined('arguments.objectparams')>
		<cfif isJSON(arguments.params)>
			<cfset var objectParams=deserializeJSON(arguments.params)>
		<cfelseif isStruct(arguments.params)>
			<cfset var objectParams=arguments.params>
		<cfelse>
			<cfset var objectParams=structNew()>
		</cfif>
	</cfif>

	<cfset objectParams.async=false>
	<cfset objectParams.render='server'>
	<cfset objectparams.object=arguments.object>
	<cfset objectparams.objectname=arguments.objectname>
	<cfset objectparams.objectid=arguments.objectid>

	<cfparam name="objectparams.instanceid" default="#createUUID()#">

	<cfif arguments.object eq 'plugin'>
		<cfset result=application.pluginManager.displayObject(regionid=arguments.regionid,object=arguments.objectid,event=variables.$.event(),params=objectParams,isConfigurator=arguments.isConfigurator,objectname=arguments.objectname)>
		<cfif isSimpleValue(result)>
			<cfset theContent=result>
		</cfif>
	<cfelse>
		<!--- For backward compatability with old dsp_feed.cfm files --->
		<cfif arguments.thefile eq "dsp_feed.cfm">
			<cfparam name="objectParams.displaySummaries" default="#arguments.hasSummary#">
		</cfif>

		<cfset var filePath=variables.$.siteConfig().lookupDisplayObjectFilePath(arguments.theFile)>

		<cfsavecontent variable="theContent">
			<cfif len(filepath)>
			<cfset tracePoint=initTracePoint("#filepath#")>
			<cfinclude template="#filepath#" />
			<cfset commitTracePoint(tracePoint)>
			<cfelse>
			<cfset tracePoint=initTracePoint("The requested file '#arguments.theFile#' could not be found.")>
			<cfoutput><cfif arguments.throwError><!-- The requested file '#arguments.theFile#' could not be found.--></cfif></cfoutput>
			<cfset commitTracePoint(tracePoint)>
			</cfif>
		</cfsavecontent>
	</cfif>

	<cfset request.muraDisplayObjectNestLevel=request.muraDisplayObjectNestLevel-1>

	<cfset var doLayoutManagerWrapper=not arguments.include and (request.muraFrontEndRequest or request.muraDisplayObjectNestLevel) and (this.layoutmanager or objectparams.render eq 'client') and len(arguments.object)>

	<cfif doLayoutManagerWrapper &&  (request.muraDisplayObjectNestLevel or (arguments.returnFormat eq 'struct' or not (objectParams.async and objectParams.render eq 'client' and request.returnFormat eq 'json')))>
		<cfset var managerResponse=''>
		<cfset theContent=trim(theContent)>

		<cfif objectParams.render eq 'client'>

			<cfset managerResponse=variables.contentRendererUtility.renderObjectInManager(object=arguments.object,
				objectid=arguments.objectid,
				content='',
				objectParams=objectParams,
				showEditable=arguments.showEditable,
				isConfigurator=arguments.isConfigurator,
				objectname=arguments.objectname,
				renderer=this,
				bodyRender=arguments.bodyRender,
				returnformat=arguments.returnFormat) />
		<cfelse>
			<cfset managerResponse=variables.contentRendererUtility.renderObjectInManager(object=arguments.object,
				objectid=arguments.objectid,
				content=theContent,
				objectParams=objectParams,
				showEditable=arguments.showEditable,
				isConfigurator=arguments.isConfigurator,
				objectname=arguments.objectname,
				renderer=this,
				bodyRender=arguments.bodyRender,
				returnformat=arguments.returnFormat) />
		</cfif>

		<cfif arguments.returnFormat eq 'struct'>
			<cfset objectparams.header=managerResponse.header>
			<cfset objectparams.footer=managerResponse.footer>

			<cfif objectParams.render neq 'client'>
				<cfset objectparams.html=thecontent>
			<cfelse>
				<cfset objectparams.html=''>
			</cfif>

			<cfreturn objectparams>
		<cfelse>
			<cfreturn managerResponse>
		</cfif>
	<cfelseif isDefined('objectParams.render') and objectParams.render eq 'client'>
		<cfreturn objectParams>
	<cfelseif arguments.returnFormat eq 'struct'>
		<cfset objectparams.html=trim(theContent)>
		<cfreturn objectparams>
	<cfelse>
		<cfreturn trim(theContent) />
	</cfif>
</cffunction>

<cffunction name="getBodyDisplayStatus" output="false">
	<cfif $.event('display') eq 'search'>
		<cfreturn "search">
	<cfelseif $.event('display') eq 'editprofile'>
		<cfreturn "editprofile">
	<cfelseif $.event('display') eq 'login'>
		<cfreturn "login">
	<cfelseif $.event('isOnDisplay') and $.event('r').restrict and $.event('r').loggedIn and not $.event('r').allow >
		<cfreturn "deny">
	<cfelseif $.event('isOnDisplay') and $.event('r').restrict and not $.event('r').loggedIn>
		<cfreturn "login">
	<cfelseif not $.event('isOnDisplay')>
		<cfreturn "offline">
	<cfelse>
		<cfreturn 'default'>
	</cfif>
</cffunction>

<cffunction name="dspBody"  output="false">
	<cfargument name="body" type="string" default="#$.content('body')#">
	<cfargument name="pagetitle" type="string" default="">
	<cfargument name="crumblist" type="boolean" default="1">
	<cfargument name="crumbseparator" type="string" default="&raquo;&nbsp;">
	<cfargument name="showMetaImage" type="boolean" default="1">
	<cfargument name="includeMetaHREF" type="boolean" default="true" />
	<cfargument name="bodyAttribute">
	<cfargument name="titleAttribute">
	<cfargument name="metaImageSizeArgs" default="#this.bodyMetaImageSizeArgs#">
	<cfargument name="metaImageClass" default="#this.bodymetaImageClass#">
	<cfargument name="renderKids" default="true">
	<cfargument name="displayIntervalDesc" type="string" default="">
	<cfargument name="displayIntervalClass" type="string" default="">

	<cfset var theIncludePath = variables.event.getSite().getIncludePath() />
	<cfset var themeIncludePath = variables.event.getSite().getThemeIncludePath() />
	<cfset var str = "" />
	<cfset var fileDelim="/" />
	<cfset var eventOutput="" />
	<cfset var rsPages="">
	<cfset var cacheStub="#variables.event.getValue('contentBean').getcontentID()##variables.event.getValue('pageNum')##variables.event.getValue('startrow')##variables.event.getValue('year')##variables.event.getValue('month')##variables.event.getValue('day')##variables.event.getValue('filterby')##variables.event.getValue('categoryID')##variables.event.getValue('relatedID')#">
	<cfset var sessionData=getSession()>

	<cfset variables.event.setValue("BodyRenderArgs",arguments)>
	<cfset var doLayoutManagerWrapper=false>
	<cfsavecontent variable="str">
		<cfset eventOutput=application.pluginManager.renderEvent("onDisplayRender",variables.event)>
		<!---
			Test for custom onDisplayRender output
		--->
		<cfif len(eventOutput)>
			<cfset variables.$.noIndex()>
			<cfset variables.event.setValue('noCache',1)>
			<cfoutput>#eventOutput#</cfoutput>
		<!---
			If not check if the content is on display, but there's standard display override happening
		--->
		<cfelseif (variables.event.getValue('isOnDisplay') and (not variables.event.getValue('r').restrict or (variables.event.getValue('r').restrict and variables.event.getValue('r').allow)))
			or (getSite().getextranetpublicreg() and variables.event.getValue('display') eq 'editprofile' and not sessionData.mura.isLoggedIn)
			or (variables.event.getValue('display') eq 'editprofile' and sessionData.mura.isLoggedIn)>
			<cfif listFindNoCase('search,editprofile,login',variables.event.getValue('display'))>
				<cfswitch expression="#variables.event.getValue('display')#">
					<cfcase value="editprofile">
						<cfset variables.$.noIndex()>
						<cfset variables.event.setValue('noCache',1)>
						<cfset variables.event.setValue('forceSSL',getSite().getExtranetSSL())/>
						<cfset eventOutput=application.pluginManager.renderEvent("onSiteEditProfileRender",variables.event)>
						<cfif len(eventOutput)>
						<cfoutput>#eventOutput#</cfoutput>
						<cfelseif $.siteConfig().hasDisplayObject('editprofile')>
						<cfoutput>#variables.$.dspObject('editprofile')#</cfoutput>
						<cfelse>
						<cfoutput>#variables.$.dspObject_include(thefile='dsp_edit_profile.cfm')#</cfoutput>
						</cfif>
					</cfcase>
					<cfcase value="search">
						<cfset variables.$.noIndex()>
						<cfset variables.event.setValue('noCache',1)>
						<cfset eventOutput=application.pluginManager.renderEvent("onSiteSearchRender",variables.event)>
						<cfif len(eventOutput)>
						<cfoutput>#eventOutput#</cfoutput>
						<cfelseif $.siteConfig().hasDisplayObject('search')>
						<cfoutput>#variables.$.dspObject('search')#</cfoutput>
						<cfelse>
						<cfoutput>#variables.$.dspObject_include(thefile='dsp_search_results.cfm')#</cfoutput>
						</cfif>
					</cfcase>
					<cfcase value="login">
						<cfset variables.$.noIndex()>
						<cfset variables.event.setValue('noCache',1)>
						<cfset eventOutput=application.pluginManager.renderEvent("onSiteLoginPromptRender",variables.event)>
						<cfif len(eventOutput)>
						<cfoutput>#eventOutput#</cfoutput>
						<cfelseif $.siteConfig().hasDisplayObject('login')>
						<cfoutput>#variables.$.dspObject('login')#</cfoutput>
						<cfelse>
						<cfoutput>#variables.$.dspObject_include(thefile='dsp_login.cfm')#</cfoutput>
						</cfif>
					</cfcase>
				</cfswitch>
			<cfelse>
				<!---
					Render crumblist and title if required which is beind phazed out
					infavor of handling that within a content_type include
				--->
				 <cfoutput>
				 	<cfif structKeyExists(arguments,'titleAttribute')>
				 		<#getHeaderTag('headline')# class="pageTitle">#renderEditableAttribute(attribute=arguments.titleAttribute,required=true)#</#getHeaderTag('headline')#>
					<cfelseif arguments.pageTitle neq ''>
						<#getHeaderTag('headline')# class="pageTitle"><cfif arguments.pageTitle eq $.content('title')>#renderEditableAttribute(attribute='title',required=true)#<cfelse>#arguments.pageTitle#</cfif></#getHeaderTag('headline')#>
					</cfif>
					<cfif arguments.crumblist>
						#dspCrumbListLinks("crumblist",arguments.crumbseparator)#
					</cfif>
					<cfif $.hasParent() and $.getParent().getType() eq 'Calendar' and len(arguments.displayIntervalDesc)>
						<p<cfif len(arguments.displayIntervalClass)> class="#arguments.displayIntervalClass#"</cfif>>#arguments.displayIntervalDesc#</p>
					</cfif>
				</cfoutput>

				<!---
					Look for custom overrides via events or content types includes.  Preferred for future development
				--->
				<cfset var bodyLookup=variables.contentRendererUtility.lookupCustomContentTypeBody(variables.$)>

				<cfif isDefined('bodyLookup.eventOutput')>
					<cfoutput>#bodyLookup.eventOutput#</cfoutput>
				<cfelseif isDefined('bodyLookup.filepath')>
					<cfset var objectParams=$.content().getObjectParams()>
					<cfset objectParams.isBodyObject=true>
					<cfinclude template="#bodyLookup.filepath#">

				<!---
					Otherwise start default body rendering, Mura will eventually ship
					wth content_type includes for all base content types. So this will eventually be phased out
				 --->
				<cfelse>
					<cfswitch expression="#$.content('type')#">
					<cfcase value="File">
						<cfif variables.event.getValue('contentBean').getContentType() eq "Image"
							and listFind("jpg,jpeg,gif,png",lcase(variables.event.getValue('contentBean').getFileExt()))>
								<cfset loadShadowBoxJS() />
								<cfoutput>
								<div id="svAssetDetail" class="mura-asset-detail image">
								<a href="#variables.$.content().getImageURL(size='large')#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" #this.shadowboxattribute#="shadowbox[body]" id="svAsset" class="mura-asset"><img src="#variables.$.content().getImageURL(argumentCollection=arguments.metaImageSizeArgs)#" class="imgMed #arguments.metaImageClass#" alt="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" /></a>
								#renderEditableAttribute(attribute="summary",type="htmlEditor")#
								</div>
								</cfoutput>
						<cfelse>
								<cfoutput>
								<div id="svAssetDetail" class="mura-asset-detail file">
								#renderEditableAttribute(attribute="summary",type="htmlEditor")#
								<a href="#$.content().getURL('showMeta=2&ext=.#$.content().getFileExt()#')#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" id="svAsset" class="mura-asset #lcase(variables.event.getValue('contentBean').getFileExt())#">Download File</a>
								</div>
								</cfoutput>
						</cfif>
					</cfcase>
					<cfcase value="Link">
						<cfoutput>
						<div id="svAssetDetail" class="mura-asset-detail link">
							#renderEditableAttribute(attribute="summary",type="htmlEditor")#
							<a href="#$.content().getURL('showMeta=2&ext=.#$.content().getFileExt()#')#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" id="svAsset" class="mura-asset url">View Link</a>
						</div>
						</cfoutput>
					</cfcase>
					<cfdefaultcase>
						<cfif arguments.showMetaImage
							and len(variables.event.getValue('contentBean').getFileID())
							and variables.event.getValue('contentBean').getContentType() eq "Image"
							and listFind("jpg,jpeg,gif,png",lcase(variables.event.getValue('contentBean').getFileExt()))>
								<cfif useLayoutManager()>
									<cfoutput>
										<cfif arguments.includeMetaHREF><cfset loadShadowBoxJS() /></cfif>
										<div class="mura-asset">
											<cfif arguments.includeMetaHREF><a href="#variables.$.content().getImageURL(size='large')#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" #this.shadowboxattribute#="shadowbox[body]"></cfif><img src="#variables.$.content().getImageURL(argumentCollection=arguments.metaImageSizeArgs)#" class="imgMed #arguments.metaImageClass#" alt="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" /><cfif arguments.includeMetaHREF></a></cfif>
										</div>
									</cfoutput>
								<cfelse>
									<cfoutput>
									<cfif arguments.includeMetaHREF>
										<cfset loadShadowBoxJS() />
										<a href="#variables.$.content().getImageURL(size='large')#" title="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" #this.shadowboxattribute#="shadowbox[body]" id="svAsset" class="mura-asset"><img src="#variables.$.content().getImageURL(argumentCollection=arguments.metaImageSizeArgs)#" class="imgMed #arguments.metaImageClass#" alt="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" /></a>
									<cfelse>
										<div id="svAsset" class="mura-asset">
										<img src="#variables.$.content().getImageURL(argumentCollection=arguments.metaImageSizeArgs)#" class="imgMed #arguments.metaImageClass#" alt="#HTMLEditFormat(variables.event.getValue('contentBean').getMenuTitle())#" />
										</div>
									</cfif>
									</cfoutput>
								</cfif>
						</cfif>
						<cfoutput>
							<cfif structKeyExists(arguments,'bodyAttribute')>
								#renderEditableAttribute(attribute=arguments.bodyAttribute,type="htmlEditor")#
							<cfelseif $.content('body') eq arguments.body>
								#renderEditableAttribute(attribute="body",type="htmlEditor")#
							<cfelse>
								#setDynamicContent(arguments.body)#
							</cfif>
						</cfoutput>
					</cfdefaultcase>
					</cfswitch>
					<cfoutput>#$.dspContentTypeBody(params=$.content().getObjectParams(),renderKids=arguments.renderKids)#</cfoutput>
				</cfif>
			</cfif>
		<cfelse>
			<!---
				The content is not on display or offline or the current viewer is not allowed to see it.
			--->
			<cfoutput>#$.dspContentTypeBody(params=$.content().getObjectParams())#</cfoutput>
		</cfif>
	</cfsavecontent>

	<cfreturn str />
</cffunction>

<cffunction name="dspContentTypeBody" output="false">
	<cfargument name="params" default="#structNew()#">
	<cfargument name="renderKids" default="true">
	<cfset var status=getBodyDisplayStatus()>
	<cfsavecontent variable="eventOutput">
	<cfoutput>
	<cfif status eq 'deny' >
		<cfset $.noIndex()>
		<cfset eventOutput=application.pluginManager.renderEvent("onContentDenialRender",$)>
		<cfif len(eventOutput)>
		<cfoutput>#eventOutput#</cfoutput>
		<cfelse>
			<cfoutput>#$.dspObject('deny')#</cfoutput>
		</cfif>
	<cfelseif status eq 'login'>
		<cfset $.noIndex()>
		<cfset $.event('noCache',1)>
		<cfset eventOutput=application.pluginManager.renderEvent("onSiteLoginPromptRender",$)>
		<cfif len(eventOutput)>
		<cfoutput>#eventOutput#</cfoutput>
		<cfelse>
		<cfoutput>#$.dspObject('login')#</cfoutput>
		</cfif>
	<cfelseif status eq 'offline'>
		<cfset $.noIndex()>
		<cfset eventOutput=application.pluginManager.renderEvent("onContentOfflineRender",$)>
		<cfif $.globalConfig().getValue(property="offline404", defaultValue="true")>
			<cfheader statuscode="404" statustext="Content Not Found" />
		</cfif>
		<cfif len(eventOutput)>
		<cfoutput>#eventOutput#</cfoutput>
		<cfelse>
		<cfoutput>#$.dspObject('offline')#</cfoutput>
		</cfif>
	<cfelse>
		<cfset var bodyLookup=variables.contentRendererUtility.lookupCustomContentTypeBody($=variables.$)>
		<cfset var eventOutput="">
		<cfif isDefined('bodyLookup.eventOutput')>
			#bodyLookup.eventOutput#
		<cfelseif isDefined('bodyLookup.filepath')>
			<cfset var objectParams=arguments.params>
			<cfset objectParams.isBodyObject=true>
			<cfinclude template="#bodyLookup.filepath#">
		<cfelse>
			<cfif arguments.renderKids>
				<cfif $.siteConfig().hasDisplayObject($.content('type'))>
					<cfoutput>#dspObject(objectid=$.content('contentid'),object=$.content('type'),params=arguments.params,bodyRender=true)#</cfoutput>
				<cfelse>
					<cfif $.content('type') eq 'folder'>
						<cf_CacheOMatic key="folderBody#$.content('contentid')##hash(cgi.query_string)#" nocache="#$.event('r').restrict#">
						 <cfset var filePath=$.siteConfig().lookupDisplayObjectFilePath('dsp_portal.cfm')>
						 <cfif len(filePath)>
						 	<cfoutput>#$.dspObject_Include(thefile='dsp_portal.cfm',params=arguments.params)#</cfoutput>
						 <cfelse>
						 	 <cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('dsp_folder.cfm')>
						 	 <cfif len(filePath)>
							 	<cfoutput>#$.dspObject_Include(thefile='dsp_folder.cfm',params=arguments.params)#</cfoutput>
							 <cfelse>
							 	<cfoutput>#$.dspObject_Include(thefile='folder/index.cfm',params=arguments.params)#</cfoutput>
							 </cfif>
						</cfif>
						</cf_CacheOMatic>
					<cfelseif $.content('type') eq 'calendar'>
						<cf_CacheOMatic key="calendarBody#$.content('contentid')##hash(cgi.query_string)#" nocache="#$.event('r').restrict#">
						 	 <cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('calendar/index.cfm')>
						 	 <cfif len(filePath)>
							 	<cfoutput>#$.dspObject_Include(thefile='calendar/index.cfm',params=arguments.params)#</cfoutput>
							 </cfif>
						</cf_CacheOMatic>
					<cfelseif variables.$.content('type') eq 'gallery'>
						<cf_CacheOMatic key="galleryBody#$.content('contentid')##hash(cgi.query_string)#" nocache="#$.event('r').restrict#">
						 	 <cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('gallery/index.cfm')>
						 	 <cfif len(filePath)>
							 	<cfoutput>#$.dspObject_Include(thefile='gallery/index.cfm',params=arguments.params)#</cfoutput>
							 </cfif>
						</cf_CacheOMatic>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	</cfoutput>
	</cfsavecontent>
	<cfreturn eventOutput>
</cffunction>

<cffunction name="dspPrimaryNavKids" output="false">
	<cfargument name="contentid" type="string">
	<cfargument name="viewDepth" type="numeric" required="true" default="1">
	<cfargument name="currDepth" type="numeric"  required="true"  default="1">
	<cfargument name="type" type="string"  default="default">
	<cfargument name="today" type="date"  default="#now()#">
	<cfargument name="id" type="string" default="">
	<cfargument name="querystring" type="string" default="">
	<cfargument name="sortBy" type="string" default="orderno">
	<cfargument name="sortDirection" type="string" default="asc">
	<cfargument name="context" type="string" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" default="#application.configBean.getStub()#">
	<cfargument name="displayHome" type="string" default="conditional">
	<cfargument name="closeFolders" type="string" default="">
	<cfargument name="openFolders" type="string" default="">
	<cfargument name="menuClass" type="string" default="">
	<cfargument name="showCurrentChildrenOnly" type="boolean" default="false">
	<cfargument name="liHasKidsClass" required="true" default="">
	<cfargument name="liHasKidsAttributes" required="true" default="">
	<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
	<cfargument name="liCurrentAttributes" required="true" default="">
	<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
	<cfargument name="aHasKidsClass" required="true" default="">
	<cfargument name="aHasKidsAttributes" required="true" default="">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="">
	<cfargument name="ulNestedClass" required="true" default="">
	<cfargument name="ulNestedAttributes" required="true" default="">
	<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">
	<cfargument name="siteid" default="#variables.event.getValue('siteID')#">
	<cfargument name="liClass" type="string" default="">
	<cfargument name="setLiIds" type="boolean" default="false">
	<cfreturn dspNestedNavPrimary(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspNestedNavPrimary" output="false">
		<cfargument name="contentid" type="string">
		<cfargument name="viewDepth" type="numeric" required="true" default="1">
		<cfargument name="currDepth" type="numeric"  required="true"  default="1">
		<cfargument name="type" type="string"  default="default">
		<cfargument name="today" type="date"  default="#now()#">
		<cfargument name="id" type="string" default="">
		<cfargument name="querystring" type="string" default="">
		<cfargument name="sortBy" type="string" default="orderno">
		<cfargument name="sortDirection" type="string" default="asc">
		<cfargument name="context" type="string" default="#application.configBean.getContext()#">
		<cfargument name="stub" type="string" default="#application.configBean.getStub()#">
		<cfargument name="displayHome" type="string" default="conditional">
		<cfargument name="closeFolders" type="string" default="">
		<cfargument name="openFolders" type="string" default="">
		<cfargument name="menuClass" type="string" default="">
		<cfargument name="showCurrentChildrenOnly" type="boolean" default="false">
		<cfargument name="liHasKidsClass" required="true" default="">
		<cfargument name="liHasKidsAttributes" required="true" default="">
		<cfargument name="liCurrentClass" required="true" default="#this.liCurrentClass#">
		<cfargument name="liCurrentAttributes" required="true" default="">
		<cfargument name="liHasKidsNestedClass" required="true" default="#this.liHasKidsNestedClass#">
		<cfargument name="aHasKidsClass" required="true" default="">
		<cfargument name="aHasKidsAttributes" required="true" default="">
		<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
		<cfargument name="aCurrentAttributes" required="true" default="">
		<cfargument name="ulNestedClass" required="true" default="">
		<cfargument name="ulNestedAttributes" required="true" default="">
		<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">
		<cfargument name="siteid" default="#variables.event.getValue('siteID')#">
		<cfargument name="liClass" type="string" default="">
		<cfargument name="setLiIds" type="boolean" default="false">

		<cfset var rsSection=variables.contentGateway.getKids('00000000000000000000000000000000000',arguments.siteid,arguments.contentid,arguments.type,arguments.today,0,'',0,arguments.sortBy,arguments.sortDirection,'','','',0)>
		<cfset var adjust=0>
		<cfset var current=0>
		<cfset var link=''>
		<cfset var itemClass=''>
		<cfset var itemId=''>
		<cfset var nest=''>
		<cfset var subnav=false>
		<cfset var theNav="">
		<cfset var topIndex= arrayLen(this.crumbdata)-this.navOffSet />
		<cfset var rsHome=0>
		<cfset var homeLink = "" />
		<cfset var isLimitingOn = false>
		<cfset var isNotLimited = false>
		<cfset var limitingBy = "">
		<cfset var isNavSecondary=arguments.showCurrentChildrenOnly or (arguments.id eq 'navSecondary' or arguments.menuClass eq 'navSecondary')>
		<cfset var homeDisplayed = false>
		<cfset var nestedArgs=structNew()>
		<cfset var linkArgs=structNew()>
		<cfset var started=false>
		<cfset var sessionData=getSession()>

		<cfif isDefined("arguments.closePortals")>
			<cfset arguments.closeFolders=arguments.closePortals>
		</cfif>

		<cfif isDefined("arguments.openPortals")>
			<cfset arguments.openFolders=arguments.openPortals>
		</cfif>

		<cfif isDefined("arguments.ulTopClass")>
			<cfset arguments.menuclass=arguments.ulTopClass>
		</cfif>

		<cfif len(arguments.closeFolders)>
			<cfset limitingBy="closed">
			<cfif isBoolean(arguments.closeFolders)>
				<cfset isLimitingOn=arguments.closeFolders />
			</cfif>
		</cfif>

		<cfif len(arguments.openFolders)>
			<cfset limitingBy="open">
			<cfif isBoolean(arguments.openFolders)>
				<cfif arguments.openFolders>
					<cfset isLimitingOn=false />
				<cfelse>
					<cfset isLimitingOn=true />
				</cfif>
			</cfif>
		</cfif>

		<cfif structKeyExists(arguments,'aHasKidsCustomString') and len(arguments.aHasKidsCustomString) and not (arguments.aHasKidsAttributes contains arguments.aHasKidsCustomString)>
			<cfset arguments.aHasKidsAttributes = arguments.aHasKidsAttributes & ' ' & arguments.aHasKidsCustomString>
		</cfif>

		<cfif rsSection.recordcount>
			<cfset adjust=rsSection.recordcount>
			<cfsavecontent variable="theNav"><cfoutput>

			<cfif not homeDisplayed and arguments.currDepth eq 1 and (arguments.displayHome eq "Always" or (arguments.displayHome eq "Conditional" and variables.event.getValue('contentBean').getcontentid() neq "00000000000000000000000000000000001"))>
				<cfsilent>
					<cfquery name="rsHome" datasource="#application.configBean.getReadOnlyDatasource()#" username="#application.configBean.getReadOnlyDbUsername()#" password="#application.configBean.getReadOnlyDbPassword()#">
					select menutitle,filename from tcontent where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"> and active=1
					</cfquery>
					<cfset homeLink="#application.configBean.getContext()##getURLStem(arguments.siteid,rsHome.filename)#">
					<cfset homeDisplayed = true>
				</cfsilent>

				<cfset started=true>
				<ul<cfif arguments.currDepth eq 1>#iif(arguments.id neq '',de(' id="#arguments.id#"'),de(''))##iif(arguments.menuClass neq '',de(' class="#arguments.menuClass#"'),de(''))#<cfelse><cfif len(arguments.ulNestedClass)> class="#arguments.ulNestedClass#"</cfif><cfif len(arguments.ulNestedAttributes)> #arguments.ulNestedAttributes#</cfif></cfif>>
				<li class="first<cfif variables.event.getValue('contentBean').getcontentid() eq arguments.contentid> #arguments.liCurrentClass#</cfif><cfif len(arguments.liClass)> #arguments.liClass#</cfif>"<cfif arguments.setLIIds> id="navHome"</cfif><cfif len(arguments.liCurrentAttributes)> #arguments.liCurrentAttributes#</cfif>><a href="#homeLink#"<cfif len(arguments.aCurrentClass) and $.content('contentID') eq '00000000000000000000000000000000001'> class="#arguments.aCurrentClass#"<cfelseif len(arguments.aNotCurrentClass)> class="#arguments.aNotCurrentClass#"</cfif><cfif len(arguments.aCurrentAttributes)> #arguments.aCurrentAttributes#</cfif>>#HTMLEditFormat(rsHome.menuTitle)#</a></li>
			</cfif>

			<cfloop query="rsSection">
			<cfif allowLink(rssection.restricted,rssection.restrictgroups,variables.event.getValue('r').loggedIn)>
			<cfsilent>

			<cfset current=current+1>
			<cfset nest=''>

			<cfset isNotLimited= rsSection.type eq "Page" or
			not (
				rsSection.type eq "Folder" and
					(isLimitingOn or (
										(limitingBy eq "closed" and listFind(arguments.closeFolders,rsSection.contentid))
									or
										(limitingBy eq "open" and not listFind(arguments.openFolders,rsSection.contentid))
									)

					)
					or listFindNoCase("Calendar,Gallery,Link,File",rsSection.type)
				)
			/>

			<cfset subnav= arguments.currDepth lt arguments.viewDepth
			and (
					(
					isNotLimited and isNavSecondary and (
														listFind(variables.event.getValue('contentBean').getPath(),"#rsSection.contentID#")
														and
														listLen(rsSection.path) lte listLen(variables.event.getValue('contentBean').getPath())
														)
					)
				or (
					isNotLimited and not isNavSecondary
					)
				)
				and not (rsSection.restricted and not sessionData.mura.isLoggedIn)
			/>

			<cfif subnav>
				<cfset nestedArgs.contentID=rssection.contentid>
				<cfset nestedArgs.currDepth=arguments.currDepth+1>
				<cfset nestedArgs.type=iif(rssection.type eq 'calendar',de('fixed'),de('default'))>
				<cfset nestedArgs.sortBy=rssection.sortBy>
				<cfset nestedArgs.sortDirection=rssection.sortDirection>
				<cfset nestedArgs.menuClass="">
				<cfset nestedArgs.ulTopClass="">
				<cfset structAppend(nestedArgs,arguments,false)>
				<cfset nest=this.dspPrimaryNavKids(argumentCollection=nestedArgs) />
				<cfset subnav=subnav and (find("<li",nest) or find("<div",nest))>
			</cfif>

			<cfset itemClass=''>

			<cfif subnav and arguments.currDepth gt 1 and len(arguments.liHasKidsNestedClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liHasKidsNestedClass,' ')>
			</cfif>

			<cfif current eq adjust>
				<cfset itemClass=listAppend(itemClass, "last"," ")>
			</cfif>

			<cfif len(arguments.liClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liClass,' ')>
			</cfif>

			<cfif listFind(variables.event.getValue('contentBean').getPath(),"#rsSection.contentid#") and len(arguments.liCurrentClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liCurrentClass," ")/>
			</cfif>

			<cfif subnav and len(arguments.liHasKidsClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liHasKidsClass," ")/>
			</cfif>

			<cfif arguments.setLIIds>
				<cfset itemId="nav" & setCamelback(rsSection.menutitle)>
			</cfif>

			<cfset linkArgs=structNew()>
			<cfset linkArgs.aHasKidsClass=arguments.aHasKidsClass>
			<cfset linkArgs.aHasKidsAttributes=arguments.aHasKidsAttributes>
			<cfset linkArgs.aNotCurrentClass=arguments.aNotCurrentClass>
			<cfset linkArgs.aCurrentClass=arguments.aCurrentClass>
			<cfset linkArgs.aCurrentAttributes=arguments.aCurrentAttributes>
			<cfset linkArgs.type=rsSection.type>
			<cfset linkArgs.filename=rsSection.filename>
			<cfset linkArgs.title=rsSection.menutitle>
			<cfset linkArgs.contentid=rsSection.contentid>
			<cfset linkArgs.target=rsSection.target>
			<cfset linkArgs.targetParams=rsSection.targetParams>
			<cfset linkArgs.siteID=arguments.siteid>
			<cfset linkArgs.querystring=arguments.querystring>
			<cfset linkArgs.isParent=subnav>
			<cfset linkArgs.liClass=arguments.liClass>
			<cfset link=addlink(argumentCollection=linkArgs)>

			</cfsilent>

			<cfif not started>
				<cfset started=true>
				<cfset itemClass=listAppend(itemClass, "first",' ')>
				<ul<cfif arguments.currDepth eq 1>#iif(arguments.id neq '',de(' id="#arguments.id#"'),de(''))##iif(arguments.menuClass neq '',de(' class="#arguments.menuClass#"'),de(''))#<cfelse><cfif len(arguments.ulNestedClass)> class="#arguments.ulNestedClass#"</cfif><cfif len(arguments.ulNestedAttributes)> #arguments.ulNestedAttributes#</cfif></cfif>>
			</cfif>
			<li<cfif len(itemClass)> class="#itemClass#"</cfif><cfif len(itemid)> id="#itemId#"</cfif><cfif len(arguments.liCurrentAttributes)> #arguments.liCurrentAttributes#</cfif>>#link#<cfif subnav>#nest#</cfif></li>
			<cfelse><cfset adjust=adjust-1></cfif></cfloop>
			<cfif started></ul></cfif>
			</cfoutput></cfsavecontent>
		</cfif>
		<cfreturn theNav />
</cffunction>

<cffunction name="dspPrimaryNav">
	<cfargument name="viewDepth" type="numeric" default="1" required="true">
	<cfargument name="id" type="string" required="true" default="navPrimary">
	<cfargument name="displayHome" type="string" required="true" default="conditional">
	<cfargument name="closeFolders" type="string" default="">
	<cfargument name="openFolders" type="string" default="">
	<cfargument name="class" type="string" default="">
	<cfargument name="aHasKidsClass" type="string" default="">
	<cfargument name="aHasKidsAttributes" type="string" default="">
	<cfargument name="siteid" default="#$.event('siteid')#">
	<cfargument name="complete" type="boolean" default="false">
	<cfargument name="setLiIds" type="boolean" default="false">

	<cfset var thenav="" />
	<cfset var topIndex= arrayLen(this.crumbdata)-this.navOffSet />
	<cfset var tracePoint=0>

	<!--- Supporting Old Arguments--->
	<cfif structKeyExists(arguments,'liHasKidsCustomString')>
		<cfset arguments.liHasKidsAttributes=arguments.liHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aHasKidsCustomString')>
		<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aCurrentCustomString')>
		<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'ulNestedCustomString')>
		<cfset arguments.ulNestedAttributes=arguments.ulNestedCustomString>
	</cfif>
	<!--- --->

	<!--- hack or issue with bootstrap that breaks link with kids --->
	<cfif arguments.aHasKidsClass eq 'dropdown-toggle' and arguments.aHasKidsAttributes eq 'role="button" data-toggle="dropdown" data-target="##"'>
		<cfset arguments.aHasKidsAttributes=''>
	</cfif>

	<cfif isDefined("arguments.closePortals")>
		<cfset arguments.closeFolders=arguments.closePortals>
	</cfif>

	<cfif isDefined("arguments.openPortals")>
		<cfset arguments.openFolders=arguments.openPortals>
	</cfif>

	<cfset arguments.contentid=this.crumbdata[topIndex].contentID>
	<cfset arguments.viewDepth=arguments.viewDepth+1>
	<cfset arguments.currDepth=1>
	<cfset arguments.sortBy="orderno">
	<cfset arguments.sortDirection="asc">
	<cfset arguments.menuClass=arguments.class>
	<cfset tracepoint=initTracepoint("contentRenderer.dspPrimaryNav")>
	<cfset theNav = this.dspNestedNavPrimary(argumentCollection=arguments) />
	<cfset commitTracePoint(tracePoint)>
	<cfreturn thenav />
</cffunction>

<cffunction name="loadShadowboxJS" output="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.loadShadowboxJS(argumentCollection=arguments)>
</cffunction>

<cffunction name="allowLink" output="false" returntype="boolean">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.allowLink(argumentCollection=arguments)>
</cffunction>

<cffunction name="getTopId" output="false">
	<cfargument name="useNavOffset" required="true" default="false"/>
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getTopId(argumentCollection=arguments)>
</cffunction>

<cffunction name="getTopVar" output="false">
	<cfargument name="topVar" required="true" default="" type="String">
	<cfargument name="useNavOffset" required="true" type="boolean" default="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getTopVar(argumentCollection=arguments)>
</cffunction>

<cffunction name="getCrumbVarByLevel" output="false">
	<cfargument name="theVar" required="true" default="" type="String">
	<cfargument name="level" required="true" type="numeric" default="1">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getCrumbVarByLevel(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspZoomText" output="false">
	<cfargument name="crumbdata" required="yes" type="array">
	<cfargument name="separator" required="yes" default=">">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.dspZoomText(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspZoom" output="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.dspZoom(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspZoomNoLinks" output="false">
	<cfargument name="crumbdata" required="yes" type="array">
	<cfargument name="fileExt" type="string" default="" hint="deprecated, this is now in the crumbData">
	<cfargument name="class" type="string" default="navZoom">
	<cfargument name="charLimit" type="numeric" default="0">
	<cfargument name="minLevels" type="numeric" default="0">
	<cfargument name="maxLevels" type="numeric" default="0">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.dspZoomNoLinks(argumentCollection=arguments) />
</cffunction>

<cffunction name="dspObject" output="false">
	<cfargument name="object" type="string">
	<cfargument name="objectid" type="string" required="true" default="">
	<cfargument name="siteid" type="string" required="true" default="#variables.event.getValue('siteID')#">
	<cfargument name="params" required="true" default="">
	<cfargument name="assignmentID" type="string" required="true" default="">
	<cfargument name="regionID" required="true" default="0">
	<cfargument name="orderno" required="true" default="0">
	<cfargument name="hasConfigurator" required="true" default="false">
	<cfargument name="assignmentPerm" required="true" default="none">
	<cfargument name="allowEditable" type="boolean" default="#this.showEditableObjects#">
	<cfargument name="cacheKey" type="string" required="false" default="">
	<cfargument name="objectname" default="">
	<cfargument name="returnFormat" required="true" default="html">
	<cfset arguments.renderer=this>
	<cfset arguments.showEditableObjects=this.showEditableObjects>
	<cfset arguments.layoutmanager=this.layoutmanager>

	<cfif isDefined('arguments.objectParams')>
		<cfset arguments.params=arguments.objectParams>
	</cfif>

	<cfreturn variables.contentRendererUtility.dspObject(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspRegion" output="false">
	<cfargument name="region" default="">
	<cfargument name="label" default="">
	<cfargument name="ContentHistID" default="#variables.event.getValue('contentBean').getcontenthistid()#">
	<cfargument name="returnFormat" default="string">
	<cfargument name="columnID" default="1">
	<cfif len(arguments.region)>
		<cfset arguments.columnid=listFindNoCase( variables.$.siteConfig('columnNames'), arguments.region, '^')>
	</cfif>
	<cfset arguments.renderer=this>
	<cfset arguments.layoutmanager=this.layoutmanager>
	<cfreturn variables.contentRendererUtility.dspObjects(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspObjects" output="false">
	<cfargument name="columnID" default="1">
	<cfargument name="ContentHistID" default="#variables.event.getValue('contentBean').getcontenthistid()#">
	<cfargument name="returnFormat" default="string">
	<cfargument name="label" default="">
	<cfif not isNumeric(arguments.columnID)>
		<cfset arguments.columnid=listFindNoCase( variables.$.siteConfig('columnNames'), arguments.columnID, '^')>
	</cfif>
	<cfset arguments.renderer=this>
	<cfset arguments.layoutmanager=this.layoutmanager>
	<cfreturn variables.contentRendererUtility.dspObjects(argumentCollection=arguments)>
</cffunction>

<cffunction name="getPersonalizationID" output="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getPersonalizationID(argumentCollection=arguments)>
</cffunction>

<cffunction name="getContentListProperty" output="false">
	<cfargument name="property" default="">
	<cfargument name="contentListPropertyMap" default="#this.contentListPropertyMap#">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getContentListProperty(argumentCollection=arguments)>
</cffunction>

<cffunction name="getContentListPropertyValue" output="false">
	<cfargument name="property" default="">
	<cfargument name="value" default="">
	<cfargument name="contentListPropertyMap" default="#this.contentListPropertyMap#">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getContentListPropertyValue(argumentCollection=arguments)>
</cffunction>

<cffunction name="getContentListLabel" output="false">
	<cfargument name="property" default="">
	<cfargument name="contentListPropertyMap" default="#this.contentListPropertyMap#">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getContentListLabel(argumentCollection=arguments)>
</cffunction>

<cffunction name="getContentListAttributes" output="false">
	<cfargument name="property" default="">
	<cfargument name="class" default="">
	<cfargument name="contentListPropertyMap" default="#this.contentListPropertyMap#">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getContentListAttributes(argumentCollection=arguments)>
</cffunction>

<cffunction name="getListFormat" output="false">
	<cfset arguments.renderer=this>
	<cfset arguments.contentListPropertyMap=this.contentListPropertyMap>
	<cfreturn variables.contentRendererUtility.getListFormat(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspCrumblistLinks"  output="false">
	<cfargument name="id" type="string" default="crumblist">
	<cfargument name="separator" type="string" default="">
	<cfargument name="class" type="string" default="#this.navBreadcrumbULClass#">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.dspCrumblistLinks(argumentCollection=arguments)>
</cffunction>

<cffunction name="renderIcon" output="false">
	<cfargument name="data">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.renderIcon(argumentCollection=arguments)>
</cffunction>

<cffunction name="getURLStem" output="false">
	<cfargument name="siteID">
	<cfargument name="filename">
	<cfargument name="siteidinurls" default="#this.siteIDInURLS#">
	<cfargument name="indexfileinurls" default="#this.indexFileInURLS#">
	<cfargument name="hashURLS" default="#this.hashURLS#">
	<cfreturn application.contentServer.getURLStem(argumentCollection=arguments)>
</cffunction>

<cffunction name="createHREF" output="false">
	<cfargument name="type" required="true" default="Page">
	<cfargument name="filename" required="true">
	<cfargument name="siteid" required="true" default="">
	<cfargument name="contentid" required="true" default="">
	<cfargument name="target" required="true" default="">
	<cfargument name="targetParams" required="true" default="" hint="deprecated, does not do anything.  May come be re-introduced for modal params">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#" hint="deprecated">
	<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#" hint="deprecated">
	<cfargument name="indexFile" type="string" required="true" default="" hint="deprecated">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfargument name="bean" hint="The contentBean that link is being generated for">
	<cfargument name="secure" default="false">
	<cfset arguments.renderer=this>
	<cfset arguments.hashUrls=this.hashUrls>
	<cfreturn variables.contentRendererUtility.createHREF(argumentCollection=arguments)>
</cffunction>

<cffunction name="createHREFforRSS" output="false">
	<cfargument name="type" required="true" default="Page">
	<cfargument name="filename" required="true">
	<cfargument name="siteid" required="true">
	<cfargument name="contentid" required="true" default="">
	<cfargument name="target" required="true" default="">
	<cfargument name="targetParams" required="true" default="" hint="deprecated">
	<cfargument name="context" type="string" default="#application.configBean.getContext()#" hint="deprecated">
	<cfargument name="stub" type="string" default="#application.configBean.getStub()#" hint="deprecated">
	<cfargument name="indexFile" type="string" default="">
	<cfargument name="showMeta" type="string" default="0">
	<cfargument name="fileExt" type="string" default="" required="true">
	<cfargument name="secure" default="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.createHREFforRSS(argumentCollection=arguments)>
</cffunction>

<cffunction name="createHREFForImage" output="false">
	<cfargument name="siteID" default="">
	<cfargument name="fileID">
	<cfargument name="fileExt">
	<cfargument name="size" required="true" default="undefined">
	<cfargument name="direct" required="true" default="#this.directImages#">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="height" default=""/>
	<cfargument name="width" default=""/>
	<cfargument name="secure" default="false">
	<cfif not len(arguments.siteid) and isDefined('variables.$') and len(variables.$.event('siteid'))>
		<cfset arguments.siteid=variables.$.event('siteid')>
	</cfif>
	<cfset arguments.direct=this.directImages>
	<cfreturn getBean("fileManager").createHREFForImage(argumentCollection=arguments)>
</cffunction>

<cffunction name="addlink" output="false">
	<cfargument name="type" required="true">
	<cfargument name="filename" required="true">
	<cfargument name="title" required="true">
	<cfargument name="target" type="string"  default="">
	<cfargument name="targetParams" type="string"  default="">
	<cfargument name="contentid" required="true">
	<cfargument name="siteid" required="true">
	<cfargument name="querystring" type="string" required="true" default="">
	<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#">
	<cfargument name="indexFile" type="string" required="true" default="">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfargument name="showCurrent" type="string" required="true" default="1">
	<cfargument name="class" type="string" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="id" type="string" required="true" default="">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">
	<cfargument name="isParent" required="true" default="false">
	<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">
	<cfargument name="secure" default="false">
	<cfargument name="isBreadCrumb" default="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.addlink(argumentCollection=arguments)>
</cffunction>

<cffunction name="queryPermFilter" output="false">
	<cfargument name="rawQuery" type="query">
	<cfreturn application.permUtility.queryPermFilter(arguments.rawQuery,'',variables.event.getValue('siteID'),variables.event.getValue('r').hasModuleAccess)/>
</cffunction>

<cffunction name="newResultQuery" output="false">
	<cfreturn application.permUtility.newResultQuery() />
</cffunction>

<cffunction name="setParagraphs" output="false">
	<cfargument name="theString" type="string">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.setParagraphs(argumentCollection=arguments)>
</cffunction>

<cffunction name="createCSSID"  output="false">
	<cfargument name="title" type="string" required="true" default="">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.createCSSID(argumentCollection=arguments)>
</cffunction>

<cffunction name="createCSSHook"  output="false">
	<cfargument name="text" type="string" required="true">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.createCSSHook(argumentCollection=arguments)>
</cffunction>

<cffunction name="getTemplate"  output="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getTemplate(argumentCollection=arguments)>
</cffunction>

<cffunction name="getMetaDesc"  output="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getMetaDesc(argumentCollection=arguments)>
</cffunction>

<cffunction name="getMetaKeywords"  output="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getMetaKeyWords(argumentCollection=arguments)>
</cffunction>

<cffunction name="stripHTML" output="false">
	<cfargument name="str" type="string">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.stripHTML(argumentCollection=arguments)>
</cffunction>

<cffunction name="addCompletePath" output="false">
	<cfargument name="str" type="string">
	<cfargument name="siteID" type="string">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.addCompletePath(argumentCollection=arguments)>
</cffunction>

<cffunction name="getSite" output="false">
	<cfreturn application.settingsManager.getSite(variables.event.getValue('siteID')) />
</cffunction>

<cffunction name="getCurrentURLArray" output="false">
	<cfreturn variables.contentRendererUtility.getCurrentURLArray(renderer=this)>
</cffunction>

<cffunction name="renderFile" output="true">
	<cfargument name="fileID" type="string">
	<cfargument name="method" type="string" required="true" default="inline">
	<cfargument name="size" type="string" required="true" default="">
	<cfset getBean('fileManager').renderFile(arguments.fileid,arguments.method,arguments.size) />
</cffunction>

<cffunction name="renderSmall" output="true">
	<cfargument name="fileID" type="string">
	<cfset getBean('fileManager').renderSmall(arguments.fileid) />
</cffunction>

<cffunction name="renderMedium" output="true">
	<cfargument name="fileID" type="string">
	<cfset getBean('fileManager').renderMedium(arguments.fileid) />
</cffunction>

<cffunction name="jsonencode" output="false">
	<cfargument name="arg" default="" required="yes" type="any"/>
	<cfreturn createObject("component","mura.json").init().jsonencode(arguments.arg)>
</cffunction>

<cffunction name="getCurrentURL" output="false">
	<cfargument name="complete" required="true" type="boolean" default="true" />
	<cfargument name="injectVars" required="true" type="string" default="" />
	<cfargument name="filterVars" required="true" type="boolean" default="true" />
	<cfargument name="domain" default="#listFirst(cgi.http_host,":")#">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.getCurrentURL(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspUserTools" output="false" hint="deprecated">
	<cfset var theObject = "" />
	<cfset var theIncludePath = variables.event.getSite().getIncludePath() />

	<cfsavecontent variable="theObject">
		<cfinclude template="#theIncludePath#/includes/display_objects/dsp_user_tools.cfm">
	</cfsavecontent>

	<cfreturn theObject />

</cffunction>

<cffunction name="dspSection" output="false">
	<cfargument name="level" default="1" required="true">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.dspSection(argumentCollection=arguments)>
</cffunction>

<cffunction name="setDynamicContent" output="false">
	<cfargument name="str">

	<cfset var body=arguments.str>
	<cfset var errorStr="">
	<cfset var regex1="(\[sava\]|\[mura\]|\[m\]).+?(\[/sava\]|\[/mura\]|\[/m\])">
	<cfset var regex2="">
	<cfset var finder=reFindNoCase(regex1,body,1,"true")>
	<cfset var tempValue="">

	<cfparam name="this.enableMuraTag" default="true" />
	<cfparam name="this.enableDynamicContent" default="true" />

	<!--- It the Dyanmic content is not enabled just return the submitted string --->
	<cfif isBoolean(this.enableDynamicContent) and not this.enableDynamicContent>
		<cfset str=application.scriptProtectionFilter.filterWords(str,"script,object,applet,embed,layer,ilayer,frameset,param,meta,base,xss,marquee")>
		<cfset str=application.scriptProtectionFilter.filterTags(str)>
		<cfreturn str />
	</cfif>

	<!--- It the Mura tag is not enabled just return the submitted string --->
	<cfif isBoolean(this.enableMuraTag) and not this.enableMuraTag>
		<cfreturn str />
	</cfif>

	<!---  still looks for the Sava tag for backward compatibility --->
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset tempValue=mid(body, finder.pos[1], finder.len[1])>

			<cfif left(tempValue,3) eq "[m]">
				<cfset tempValue=evaluate("##" & mid(tempValue, 4, len(tempValue)-7) & "##")>
			<cfelse>
				<cfset tempValue=evaluate("##" & mid(tempValue, 7, len(tempValue)-13) & "##")>
			</cfif>

			<cfif not isDefined("tempValue") or not isSimpleValue(tempValue)>
				<cfset tempValue="">
			</cfif>

			<cfset body=replaceNoCase(body,mid(body, finder.pos[1], finder.len[1]),'#trim(tempValue)#')>
			<cfcatch>
				<cfif application.configBean.getDebuggingEnabled()>
					<cfset request.muraDynamicContentError=true>
					<cfset errorStr=getBean('utility').formatError(cfcatch)>
					<cfset body=replaceNoCase(body,mid(body, finder.pos[1], finder.len[1]),errorStr)>
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>
		<cfset finder=reFindNoCase(regex1,body,1,"true")>
		<cfset request.cacheItem=false>
	</cfloop>

	<cfreturn body />
</cffunction>

<cffunction name="dspCaptcha" output="false" hint="deprecated">
	<cfset var theObject = "" />
	<cfset var theIncludePath = variables.event.getSite().getDSPIncludePath() />

	<cfsavecontent variable="theObject">
		<cfinclude template="#theIncludePath#/display_objects/dsp_captcha.cfm">
	</cfsavecontent>

	<cfreturn trim(theObject)>
</cffunction>

<cffunction name="dspInclude" output="false">
	<cfargument name="template" default="" required="true">

	<cfset var baseDir=variables.event.getSite().getDSPIncludePath()>
	<cfset var str='' />
	<cfset var tracePoint1=0>
	<cfset var tracePoint2=0>
	<cfif arguments.template neq '' and listFindNoCase('cfm,html,htm,txt',listLast(template,'.'))>
		<cfset tracePoint1=initTracePoint("#baseDir#/#arguments.template#")>
		<cfif getBean('utility').isPathLegal("#baseDir#/#arguments.template#")>
			<cfsavecontent variable="str">
				<cfinclude template="#baseDir#/#arguments.template#">
			</cfsavecontent>
		<cfelse>
			<cfset tracePoint2=initTracePoint("Path excluded for being outside Mura root")>
			<cfset commitTracePoint(tracePoint2)>
		</cfif>
		<cfset commitTracePoint(tracePoint1)>
	</cfif>

	<cfreturn trim(str) />
</cffunction>

<cffunction name="dspThemeInclude" output="false">
	<cfargument name="template" default="" required="true">
	<cfset var str='' />
	<cfset var tracePoint1=0>
	<cfset var tracePoint2=0>
	<cfif arguments.template neq '' and listFindNoCase('cfm,html,htm,txt',listLast(template,'.'))>
		<cfset tracePoint1=initTracePoint("#variables.$.siteConfig('themeIncludePath')#/#arguments.template#")>
		<cfif getBean('utility').isPathLegal("#variables.$.siteConfig('themeIncludePath')#/#arguments.template#")>
			<cfsavecontent variable="str">
				<cfinclude template="#variables.$.siteConfig('themeIncludePath')#/#arguments.template#">
			</cfsavecontent>
		<cfelse>
			<cfset tracePoint2=initTracePoint("Path excluded for being outside Mura root")>
			<cfset commitTracePoint(tracePoint2)>
		</cfif>
		<cfset commitTracePoint(tracePoint1)>
	</cfif>

	<cfreturn trim(str) />
</cffunction>

<!--- DEPRECATED --->
<cffunction name="sendToFriendLink" output="false" hint="deprecated">
<cfreturn "javascript:sendtofriend=window.open('#variables.event.getSite().getAssetPath()#/utilities/sendtofriend.cfm?link=#urlEncodedFormat(getCurrentURL())#&siteID=#variables.event.getValue('siteID')#', 'sendtofriend', 'scrollbars=yes,resizable=yes,screenX=0,screenY=0,width=570,height=390');sendtofriend.focus();void(0);"/>
</cffunction>

<cffunction name="addToHTMLHeadQueue" output="false">
	<cfargument name="text">
	<cfargument name="action" default="append">
	<cfset arguments.renderer=this>
	<cfset variables.contentRendererUtility.addToHTMLHeadQueue(argumentCollection=arguments)>
</cffunction>

<cffunction name="addToHTMLFootQueue" output="false">
	<cfargument name="text">
	<cfargument name="action" default="append">
	<cfset arguments.renderer=this>
	<cfset variables.contentRendererUtility.addToHTMLFootQueue(argumentCollection=arguments)>
</cffunction>

<cffunction name="getShowModal" output="false">
<cfreturn getShowToolbar() or (this.showEditableObjects and this.hasEditableObjects and not request.muraExportHTML and this.enableFrontEndTools) />
</cffunction>

<cffunction name="getShowToolbar" output="false">
	<cfif not request.muraSessionManagement>
		<cfreturn false>
	<cfelse>
		<cfset var sessionData=getSession()>
		<cfreturn this.enableFrontEndTools
			and (
				request.muraChangesetPreviewToolbar
				and (
					this.showMemberToolBar or this.showAdminToolBar
				) or (
					(
					 	StructKeyExists(sessionData, 'mura')
					 	and (
							(listFind(sessionData.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite(variables.event.getValue('siteID')).getPrivateUserPoolID()#') and getBean('permUtility').getModulePerm("00000000000000000000000000000000000",variables.event.getValue('siteID')))
							or listFind(sessionData.mura.memberships,'S2')
						)
					) or (
						listFindNoCase("editor,author",variables.event.getValue('r').perm)
						and this.showMemberToolBar
					)
				) and getShowAdminToolBar()
			) and not request.muraExportHTML />
		</cfif>
</cffunction>

<cffunction name="hasFETools" output="false">
<cfreturn getShowToolbar() and (not isDefined('cookie.fetdisplay') or cookie.fetdisplay eq '' or cookie.fetdisplay eq 'block')/>
</cffunction>

<cffunction name="getShowInlineEditor" output="false">
<cfreturn  getShowToolbar() and this.showInlineEditor/>
</cffunction>

<cffunction name="renderHTMLQueue" output="false">
	<cfargument name="queueType">
	<cfset var headerStr="" />
	<cfset var itemStr="" />
	<cfset var HTMLQueue="" />
	<cfset var i = "" />
	<cfset var iLen = 0 />
	<cfset var headerFound=false />
	<cfset var pluginBasePath="" />
	<cfset var pluginPath="" />
	<cfset var pluginID=0 />
	<cfset var pluginConfig="" />
	<cfset var displayPoolID=application.settingsManager.getSite(variables.event.getValue('siteID')).getDisplayPoolID()>
	<cfset var theme=(len(request.altTheme) ? request.altTheme : application.settingsManager.getSite(variables.event.getValue('siteID')).getTheme())>
	<cfset var tracePoint=0>
	<cfset var item = "" />
	<cfset var lookupData = {} />

	<cfif getRenderHTMLQueues()>

		<cfif arguments.queueType eq "HEAD" and variables.$.content('type') neq 'Variation'>

			<!--- Add global.js --->
			<cfset addToHTMLHEADQueue('global.cfm',"prepend")>

			<!--- ensure that the js lb is always there --->
			<cfif not this.jsLibLoaded>
				<cfset addToHTMLHeadQueue("jquery.cfm","prepend")>
			</cfif>

		<cfelseif arguments.queueType eq "FOOT">
			<cfif (getShowModal() or variables.event.getValue("muraChangesetPreviewToolbar")) and not request.muraExportHTML>
				<cfif getShowModal()>
					<cfset tracePoint=initTracePoint("/#application.configBean.getWebRootMap()##application.configBean.getAdminDir()#/core/utilities/modal/toolbar.cfm")>
					<cfsavecontent variable="headerStr"><cfinclude template="/#application.configBean.getWebRootMap()##application.configBean.getAdminDir()#/core/utilities/modal/toolbar.cfm"></cfsavecontent>
					<cfset commitTracePoint(tracePoint)>
				</cfif>
			</cfif>
		</cfif>
		<!--- Loop through the HTML Head Que--->
		<cfset HTMLQueue=variables.event.getValue(property='HTML#arguments.queueType#Queue',defaultValue=[]) />

		<cfif arrayLen(HTMLQueue)>
			<cfloop from="1" to="#arrayLen(HTMLQueue)#" index="item">
				<cfset headerFound=false/>
				<cfset i=HTMLQueue[item]>

				<cfif refind('[<>]',i)>
					<!--- If we got just an in-line block of HTML markup and not a "real" file, render accordingly --->
						<cfset itemStr=i>
				<cfelse>
					<cfset itemStr=""/>
					<!--- look in default htmlHead directory --->
					<cfset lookupData=$.siteConfig().lookupHTMLHeadQueueFilePath(i)>
					<cfif not structIsEmpty(lookupData)>
						<cfset pluginPath=lookupData.pluginPath >
						<cfset tracePoint=initTracePoint(lookupData.filePath)>
						<cfif structKeyExists(lookupData,'pluginID')>
							<cfset variables.event.setValue('pluginConfig',application.pluginManager.getConfig(lookupData.pluginID))>
							<cfset pluginConfig=variables.event.getValue('pluginConfig')>
							<cfset pluginPath=application.configBean.getContext() & "/plugins/" & pluginConfig.getDirectory() & "/">
						</cfif>
						<cfsavecontent variable="itemStr"><cfinclude template="#lookupData.filePath#"></cfsavecontent>
						<cfif structKeyExists(lookupData,'pluginID')>
							<cfset variables.event.removeValue("pluginPath")>
							<cfset variables.event.removeValue("pluginConfig")>
						</cfif>
						<cfset commitTracePoint(tracePoint)>
						<cfset headerFound=true>
					</cfif>
					<cfif not headerFound>
						<cfoutput><!-- missing header include- #i# --></cfoutput>
					</cfif>
				</cfif>
				<cfset headerStr=headerStr & chr(13) & chr(10) & trim(itemStr)>
			</cfloop>
		</cfif>
	</cfif>
	<cfreturn headerStr>
</cffunction>

<cffunction name="renderHTMLHeadQueue" output="false" hint="deprecated">
	<cfreturn renderHTMLQueue("Head")>
</cffunction>

<cffunction name="redirect" output="false">
	<cfargument name="location">
	<cfargument name="addToken" required="true" default="false">
	<cfargument name="statusCode" required="true" default="301">
	<cfif request.muraApiRequest>
		<cfset request.muraJSONRedirectURL=arguments.location>
	<cfelse>
		<cflocation url="#arguments.location#" addtoken="#arguments.addToken#" statusCode="#arguments.statusCode#">
	</cfif>
</cffunction>

<cffunction name="getPagesQuery" output="false">
	<cfargument name="str">
	<cfreturn variables.contentRendererUtility.getPagesQuery(argumentCollection=arguments)>
</cffunction>

<cffunction name="dspMultiPageContent" output="false">
	<cfargument name="body">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.dspMultiPageContent(argumentCollection=arguments)>
</cffunction>

<cffunction name="generateEditableHook" output="false">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.generateEditableHook(argumentCollection=arguments)>
</cffunction>

<cffunction name="generateEditableObjectControl" output="no">
	<cfargument name="editLink" required="yes" default="">
	<cfargument name="isConfigurator" default="false">
	<cfset arguments.renderer=this>
	<cfset arguments.showEditableObjects=this.showEditableObjects>
	<cfset arguments.enableFrontEndTools=this.enableFrontEndTools>
	<cfreturn variables.contentRendererUtility.generateEditableObjectControl(argumentCollection=arguments)>
</cffunction>

<cffunction name="renderEditableObjectHeader" output="no">
	<cfargument name="class" required="yes" default="">
	<cfargument name="customWrapperString" required="yes" default="">
	<cfset arguments.renderer=this>
		<cfset arguments.showEditableObjects=this.showEditableObjects>
	<cfset arguments.enableFrontEndTools=this.enableFrontEndTools>
	<cfreturn variables.contentRendererUtility.renderEditableObjectHeader(argumentCollection=arguments)>
</cffunction>

<cffunction name="renderEditableObjectfooter" output="no">
	<cfargument name="control" required="yes" default="">
	<cfset arguments.renderer=this>
	<cfset arguments.showEditableObjects=this.showEditableObjects>
	<cfset arguments.enableFrontEndTools=this.enableFrontEndTools>
	<cfreturn variables.contentRendererUtility.renderEditableObjectfooter(argumentCollection=arguments)>
</cffunction>

<cffunction name="generateListImageSyles" output="false" hint="for backward compatibility">
	<cfreturn generateListImageStyles(argumentCollection=arguments)>
</cffunction>

<cffunction name="generateListImageStyles" output="false">
	<cfargument name="size" default="small">
	<cfargument name="height" default="auto">
	<cfargument name="width" default="auto">
	<cfargument name="padding" default="#this.contentListImagePadding#">
	<cfargument name="setHeight" default="true">
	<cfargument name="setWidth" default="true">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.generateListImageStyles(argumentCollection=arguments)>
</cffunction>

<cffunction name="getURLForFile" output="false">
	<cfargument name="fileid" required="false" default="" />
	<cfargument name="method" required="false" default="inline" />
	<cfscript>
		var rsFileData = getBean('fileManager').read(arguments.fileid);
		if ( not rsFileData.recordcount ) {
			return '';
		} else {
			return '#application.configBean.getContext()#/index.cfm/_api/render/file/?method=#arguments.method#&amp;fileID=#arguments.fileid#';
		}
	</cfscript>
</cffunction>

<cffunction name="getURLForImage" output="false">
	<cfargument name="fileid" required="false" default="" />
	<cfargument name="size" required="false" default="large" />
	<cfargument name="direct" required="false" default="#this.directImages#" />
	<cfargument name="complete" type="boolean" required="false" default="false" />
	<cfargument name="height" required="false" default="AUTO" />
	<cfargument name="width" required="false" default="AUTO" />
	<cfargument name="siteID" required="false" default="#variables.$.event('siteID')#" />
	<cfargument name="secure" default="false">
	<cfargument name="useProtocol" default="true">
	<cfscript>
		if(not len(arguments.siteid) and isDefined('variables.$') and len(variables.$.event('siteid'))){
			arguments.siteid=variables.$.event('siteid');
		}
		var imageURL = getBean('fileManager').createHREFForImage(argumentCollection=arguments);
		if ( IsSimpleValue(imageURL) ) {
			return imageURL;
		} else {
			return '';
		};
	</cfscript>
</cffunction>

<cffunction name="iconClassByContentType" output="false">
	<cfargument name="type">
	<cfargument name="subtype" default="Default">
	<cfargument name="siteid" default="">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.iconClassByContentType(argumentCollection=arguments)>
</cffunction>

<cffunction name="renderEditableAttribute" output="false">
	<cfargument name="attribute">
	<cfargument name="type" default="text">
	<cfargument name="required" default="false">
	<cfargument name="validation" default="">
	<cfargument name="message" default="">
	<cfargument name="label">
	<cfargument name="value">
	<cfargument name="enableMuraTag" default="true">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.renderEditableAttribute(argumentCollection=arguments)>
</cffunction>

<cffunction name="renderClassOption" output="false">
	<cfargument name="object">
	<cfargument name="objectid" default="">
	<cfargument name="objectname" default="">
	<cfargument name="objectlabel">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.renderObjectClassOption(argumentCollection=arguments)>
</cffunction>

<cffunction name="renderIntervalDesc" output="false">
	<cfargument name="content">
	<cfargument name="showTitle" default="true">
	<cfset arguments.renderer=this>
	<cfreturn variables.contentRendererUtility.renderIntervalDesc(argumentCollection=arguments)>
</cffunction>

<cfscript>
	public any function dspComponent(string componentid, boolean allowEditable=this.showEditableObjects) {
		return variables.$.dspObject(object='component',objectid=arguments.componentid,allowEditable=arguments.allowEditable);
	}

	public any function dspForm(string formid, boolean allowEditable=this.showEditableObjects) {
		return variables.$.dspObject(object='form',objectid=arguments.formid,allowEditable=arguments.allowEditable);
	}

	public any function dspFeed(string feedid,params={}, boolean allowEditable=this.showEditableObjects) {
		return variables.$.dspObject(object='feed',objectid=arguments.feedid,params=arguments.params,allowEditable=arguments.allowEditable);
	}

	public any function getCalendarUtility() {
		return variables.$.getBean('contentCalendarUtilityBean').setMuraScope(variables.$);
	}

	public any function noIndex(){
		addToHTMLHeadQueue('<meta name="robots" content="noindex, follow" />');
	}

	public string function dspReCAPTCHAContainer(string reCAPTCHATheme='light', string reCAPTCHAType='image',string reCAPTCHAClass='g-recaptcha-container') {
		return dspReCAPTCHA(argumentCollection=arguments);
	}

	public string function dspReCAPTCHA(string reCAPTCHATheme='light', string reCAPTCHAType='image',reCAPTCHAClass='g-recaptcha') {
		var str = '';

		if ( Len($.siteConfig('reCAPTCHASiteKey')) && Len($.siteConfig('reCAPTCHASecret')) ) {

			// scrub args
			arguments.reCAPTCHATheme = ListFindNoCase('light,dark', arguments.reCAPTCHATheme)
				? LCase(arguments.reCAPTCHATheme)
				: 'light';

			arguments.reCAPTCHAType = ListFindNoCase('audio,image', arguments.reCAPTCHAType)
				? LCase(arguments.reCAPTCHAType)
				: 'image';

			savecontent variable='str' {
				WriteOutput('<div id="m#createUUID()#" class="#arguments.reCAPTCHAClass#" data-sitekey="#$.siteConfig('reCAPTCHASiteKey')#" data-theme="#arguments.reCAPTCHATheme#" data-type="#arguments.reCAPTCHAType#"></div><noscript><div class="alert alert-info"><p>#$.rbKey('recaptcha.noscript')#</p><style>button[type="submit"],input[type="submit"]{display:none !important;}</style></noscript>');
			};

			// load Google ReCAPTCHA script
			//addToHTMLHeadQueue('<script type="text/javascript" src="https://www.google.com/recaptcha/api.js?hl=#$.siteConfig('reCAPTCHALanguage')#"></script>');
		} else {
			str = '<div class="alert alert-warning"><h4><i class="fa fa-warning"></i> #$.rbKey('recaptcha.warning')#</h4><p>#$.rbKey('recaptcha.nokeys')#</p></div>';
		}

		return str;
	}

	public string function setCamelback(required string theString) {
		return variables.$.getBean('utility').setCamelback(arguments.theString);
	}

	public string function setProperCase(required string theString) {
		return variables.$.getBean('utility').setProperCase(arguments.theString);
	}

	public string function renderFilesize(size) {
		return variables.$.getBean('utility').renderFilesize(arguments.size);
	}

 	public function getEvent(){
 		return variables.event;
 	}

 	public function getMuraScope(){
 		return variables.$;
 	}

 	public function hasEvent(){
 		return isDefined('variables.event');
 	}

 	public function hasMuraScope(){
 		return isDefined('variables.$');
 	}

 	public function useLayoutManager(){
 		return this.layoutmanager;
 	}

 	public function registerDisplayObject(
 			object,name='',
 			displaymethod='',
 			displayobjectFile='',
 			configuratorJS='',
 			configuratorInit='',
 			siteid='#variables.$.event('siteid')#'){
 		getBean('settingsManager').getSite(arguments.siteid).registerDisplayObject(argumentCollection=arguments);
 		return this;
	}

	public function hasDisplayObject(object,siteid='#variables.$.event('siteid')#'){
		return getBean('settingsManager').getSite(arguments.siteid).hasDisplayObject(argumentCollection=arguments);
	}

	public function getDisplayObject(object,siteid='#variables.$.event('siteid')#'){
		return getBean('settingsManager').getSite(arguments.siteid).getDisplayObject(argumentCollection=arguments);
	}

	public function get(){
		if(isDefined('this.#arguments.property#')){
			return this[arguments.property];
		} else if (isDefined('variables.#argumentsproperty#')){
			return this[arguments.property];
		}

		return '';
	}

	public function outputMuraCSS(includeskin=true, version='7.2', complete=false, useProtocol=true) {
		if ( !fileExists(expandPath('/muraWRM/core/modules/v1/core_assets/css/mura.' & arguments.version & '.min.css')) ) {
			arguments.version = '7.0';
		}
		var corePath=variables.$.siteConfig().getCorePath(complete=arguments.complete, useProtocol=arguments.useProtocol);
		var str = '<link rel="stylesheet" href="#corePath#/modules/v1/core_assets/css/mura.#arguments.version#.min.css?v=#variables.$.globalConfig("version")#">';

		if ( arguments.includeskin ) {
			str &= '<link rel="stylesheet" href="#corePath#/modules/v1/core_assets/css/mura.#arguments.version#.skin.css?v=#variables.$.globalConfig("version")#">';
		}

		return str;
	}

	public function getMuraJSDeferredString(){
		if(isBoolean(this.deferMuraJS) && this.deferMuraJS){
			return 'defer="defer"';
		} else {
			return '';
		}
	}

	public function renderCssStyles(styles) {
		var returnString="";


		if(isJSON(arguments.styles)){
			arguments.styles=deserializeJSON(arguments.styles);
		}

		if(isStruct(arguments.styles)){
			for(var s in arguments.styles){
				if(structKeyExists(this.styleLookup,'#s#')){
					returnString=returnString & ' ' & this.styleLookup['#s#'] & ':' & arguments.styles[s] & ';';
				} else {
					returnString=returnString & ' ' & s & ':' & arguments.styles[s] & ';';
				}
			}
		}

		return returnString;
	}
</cfscript>


</cfcomponent>
