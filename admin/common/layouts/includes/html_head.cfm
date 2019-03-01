<cfoutput>

	<!-- Spinner JS -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/spin.min.js" type="text/javascript"></script>

	<!-- jQuery -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- OneUI Core JS: Bootstrap, slimScroll, scrollLock, Appear, CountTo, Placeholder, Cookie and App.js -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/oneui.min.js"></script>

	<!-- jQuery UI components -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-ui.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/jquery/jquery.spin.js" type="text/javascript"></script>

	<!-- Mura js -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/mura.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- Mura Admin JS -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/admin.js?coreversion=#application.coreversion#" type="text/javascript"></script>

	<!-- CK Editor -->
	<script type="text/javascript" src="#application.configBean.getContext()#/core/vendor/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/core/vendor/ckeditor/adapters/jquery.js"></script>

	<!-- JSON -->
	<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/json2.js" type="text/javascript"></script>

	<!-- Color Picker -->
	<script type="text/javascript" src="#application.configBean.getContext()#/core/vendor/colorpicker/js/bootstrap-colorpicker.js?coreversion=#application.coreversion#"></script>
	<link href="#application.configBean.getContext()#/core/vendor/colorpicker/css/colorpicker.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />

	<script type="text/javascript">
	var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
	var context='#application.configBean.getContext()#';
	var themepath='#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#';
	var rb='#lcase(esapiEncode('javascript',session.rb))#';
	var siteid='#esapiEncode('javascript',session.siteid)#';
	var sessionTimeout=#evaluate("application.configBean.getValue('sessionTimeout') * 60")#;
	var activepanel=#esapiEncode('javascript',rc.activepanel)#;
	var activetab=#esapiEncode('javascript',rc.activetab)#;
	<cfif $.currentUser().isLoggedIn()>var webroot='#esapiEncode('javascript',left($.globalConfig("webroot"),len($.globalConfig("webroot"))-len($.globalConfig("context"))))#';</cfif>
	var fileDelim='#esapiEncode('javascript',$.globalConfig("fileDelim"))#';
	</script>	

</cfoutput>
