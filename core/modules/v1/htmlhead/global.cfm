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
<cfif request.returnformat neq 'amp' and not $.siteConfig('isRemote')>
<cfif this.deferMuraJS>
<cfoutput>
<script type="text/javascript" src="#$.globalConfig('context')#/core/modules/v1/core_assets/js/mura.min.js?v=#$.globalConfig('version')#" defer="defer"></script>
<script>
(function(root,config){root.queuedMuraCmds=[],root.queuedMuraPreInitCmds=[],root.deferMuraInit=function(){void 0!==root.Mura&&"function"==typeof root.Mura.init?root.Mura.init(config):("function"!=typeof root.Mura&&(root.mura=root.m=root.Mura=function(o){root.queuedMuraCmds.push(o)},root.Mura.preInit=function(o){root.queuedMuraPreInitCmds.push(o)}),setTimeout(root.deferMuraInit))},root.deferMuraInit();}
)(this,{
loginURL:"#variables.$.siteConfig('LoginURL')#",
siteid:"#variables.$.event('siteID')#",
contentid:"#variables.$.content('contentid')#",
contenthistid:"#variables.$.content('contenthistid')#",
parentid:"#variables.$.content('parentid')#",
changesetid:"#variables.$.content('changesetid')#",
context:"#variables.$.globalConfig('context')#",
nocache:#val($.event('nocache'))#,
assetpath:"#variables.$.siteConfig('assetPath')#",
corepath:"#variables.$.globalConfig('corepath')#",
fileassetpath:"#variables.$.siteConfig('fileAssetPath')#",
themepath:"#variables.$.siteConfig('themeAssetPath')#",
reCAPTCHALanguage:"#$.siteConfig('reCAPTCHALanguage')#",
preloaderMarkup: "#esapiEncode('javascript',this.preloaderMarkup)#",
mobileformat: #esapiEncode('javascript',$.event('muraMobileRequest'))#,
windowdocumentdomain: "#application.configBean.getWindowDocumentDomain()#",
layoutmanager:#variables.$.getContentRenderer().useLayoutManager()#,
type:"#esapiEncode('javascript',variables.$.content('type'))#",
subtype:"#esapiEncode('javascript',variables.$.content('subtype'))#",
queueObjects: #esapiEncode('javascript',this.queueObjects)#,
rb:#variables.$.siteConfig().getAPI('json','v1').getSerializer().serialize(variables.$.getClientRenderVariables())#,
#trim(variables.$.siteConfig('JSDateKeyObjInc'))#
});
</script>
</cfoutput>
<cfelse>
<cfoutput>
<script type="text/javascript" src="#$.globalConfig('context')#/core/modules/v1/core_assets/js/mura.min.js?v=#$.globalConfig('version')#"></script>
<script>
Mura.init({
loginURL:"#variables.$.siteConfig('LoginURL')#",
siteid:"#variables.$.event('siteID')#",
contentid:"#variables.$.content('contentid')#",
contenthistid:"#variables.$.content('contenthistid')#",
changesetid:"#variables.$.content('changesetid')#",
parentid:"#variables.$.content('parentid')#",
context:"#variables.$.globalConfig('context')#",
nocache:#val($.event('nocache'))#,
assetpath:"#variables.$.siteConfig('assetPath')#",
corepath:"#variables.$.globalConfig('corepath')#",
fileassetpath:"#variables.$.siteConfig('fileAssetPath')#",
themepath:"#variables.$.siteConfig('themeAssetPath')#",
reCAPTCHALanguage:"#$.siteConfig('reCAPTCHALanguage')#",
preloaderMarkup: "#esapiEncode('javascript',this.preloaderMarkup)#",
mobileformat: #esapiEncode('javascript',$.event('muraMobileRequest'))#,
windowdocumentdomain: "#application.configBean.getWindowDocumentDomain()#",
layoutmanager:#variables.$.getContentRenderer().useLayoutManager()#,
type:"#esapiEncode('javascript',variables.$.content('type'))#",
subtype:"#esapiEncode('javascript',variables.$.content('subtype'))#",
queueObjects: #esapiEncode('javascript',this.queueObjects)#,
rb:#variables.$.siteConfig().getAPI('json','v1').getSerializer().serialize(variables.$.getClientRenderVariables())#,
#trim(variables.$.siteConfig('JSDateKeyObjInc'))#
});
</script>
</cfoutput>
</cfif>
<cfif this.cookieConsentEnabled>
<cfoutput>#$.dspObject_Include(thefile='cookie_consent/index.cfm')#</cfoutput>
</cfif>
</cfif>
