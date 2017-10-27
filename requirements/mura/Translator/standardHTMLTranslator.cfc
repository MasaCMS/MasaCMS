/*  This file is part of Mura CMS.

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
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
/**
 * This handles translating a frontend request to html
 */
component extends="mura.cfobject" output="false" hint="This handles translating a frontend request to html" {

	public function translate(required event) output=false {
		var page = "";
		var themePath=arguments.event.getSite().getThemeAssetPath();
		var $=arguments.event.getValue("MuraScope");
		var m=$;
		var mura=arguments.event.getValue("MuraScope");
		var renderer="";
		var siteRenderer=arguments.event.getContentRenderer();
		var themeRenderer=arguments.event.getThemeRenderer();
		var modal="";
		var tracePoint=0;
		var inheritedObjectsPerm="";
		var inheritedObjectsContentID="";
		var defaultTemplatePath = arguments.event.getSite().getTemplateIncludePath() & '/default.cfm';
		var sessionData=getSession();
		request.muraActiveRegions="";
		variables.$=$;
		variables.m=$;
		if ( !isNumeric(arguments.event.getValue('startRow')) ) {
			arguments.event.setValue('startRow',1);
		}
		if ( !isNumeric(arguments.event.getValue('pageNum')) ) {
			arguments.event.setValue('pageNum',1);
		}
		if ( sessionData.mura.isLoggedIn && siteRenderer.getShowEditableObjects() ) {
			inheritedObjectsContentID=$.getBean("contentGateway").getContentIDFromContentHistID(contentHistID=$.event('inheritedObjects') );
			if ( len(inheritedObjectsContentID) ) {
				inheritedObjectsPerm=$.getBean('permUtility').getNodePerm($.getBean('contentGateway').getCrumblist(inheritedObjectsContentID,$.event('siteID')));
			} else {
				inheritedObjectsPerm="none";
			}
			$.event("inheritedObjectsPerm",inheritedObjectsPerm);
		}
		if ( isObject(themeRenderer) && structKeyExists(themeRenderer,"renderHTMLHeadQueue") ) {
			renderer=themeRenderer;
		} else {
			renderer=siteRenderer;
		}
		arguments.event.setValue('themePath',themePath);
		savecontent variable="page" {
			if ( fileExists(expandPath("#$.siteConfig('templateIncludePath')#/#renderer.getTemplate()#") ) ) {
				tracePoint=initTracePoint("#arguments.event.getSite().getTemplateIncludePath()#/#renderer.getTemplate()#");
				include "#arguments.event.getSite().getTemplateIncludePath()#/#renderer.getTemplate()#";
				commitTracePoint(tracePoint);
			} else {
				tracePoint=initTracePoint("#defaultTemplatePath#");
				try {
					include defaultTemplatePath;
				} catch (any cfcatch) {
						writeOutput("#$.getBean('resourceBundle').messageFormat($.rbKey('sitemanager.missingDefaultTemplate'), ['<strong>/#ListRest(defaultTemplatePath, '/')#</strong>'])#");
				}
				commitTracePoint(tracePoint);
			}
		}
		
		page=replaceNoCase(page,"</head>", renderer.renderHTMLQueue("Head") & "</head>");
		//  This is to prevent a lower level CF replaceNoCase issue from throwing an error with some utf chars
		var renderedFootQueue=renderer.renderHTMLQueue("Foot");
		try {
			page=replaceNoCase(page,"</body>", renderedFootQueue & "</body>");
		} catch (any cfcatch) {
			page=replace(page,"</body>", renderedFootQueue & "</body>");
		}
		//  Cleaning up old paths
		try {
			page=replaceNoCase(page,"/tasks/widgets/","/requirements/");
		} catch (any cfcatch) {
			page=replace(page,"/tasks/widgets/","/requirements/");
		}
		try {
			page=replaceNoCase(page,"/tasks/","/index.cfm/tasks/");
		} catch (any cfcatch) {
			page=replace(page,"/tasks/","/index.cfm/tasks/");
		}
		arguments.event.setValue('__MuraResponse__',trim(page));
	}

}
