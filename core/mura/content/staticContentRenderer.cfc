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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
/**
 * This provides static content rendering functionality
 */
component extends="contentRenderer" output="false" hint="This provides static content rendering functionality" {

	public function createHREF(required type, required filename, required siteid, required contentid, required target="", required targetParams="", required querystring="", string context="", string stub="", string indexFile="index.htm", boolean complete="false") output=false {
		var href="";
		var tp="";
		var begin=iif(arguments.complete,de('#application.settingsManager.getSite(arguments.siteID).getScheme()#://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#'),de(''));
		var staticIndexFile = "index.htm";
		var contentBean = "";
		var rsFile = "";
		switch ( arguments.type ) {
			case  "Link":
			case  "File":
				contentBean=getBean('contentManager').getActiveContent(arguments.contentID,arguments.siteid);
				rsFile=getBean('fileManager').read(contentBean.getfileid());
				href="/#application.settingsManager.getSite(arguments.siteid).getExportLocation()#/#replace(arguments.contentid, '-', '', 'ALL')#.#rsfile.fileExt#";
				break;
			default:
				href="/#application.settingsManager.getSite(arguments.siteid).getExportLocation()#/#arguments.filename##iif(not len(arguments.filename),de('/'),de(''))##staticIndexFile#";
				break;
		}
		if ( arguments.target == "_blank" ) {
			tp=iif(arguments.targetParams != "",de(",'#arguments.targetParams#'"),de(""));
			href="javascript:newWin=window.open('#href#','NewWin#replace('#rand()#','.','')#'#tp#);newWin.focus();void(0);";
		}
		return href;
	}

	public function addlink(required type, required filename, required title, string target="", string targetParams="", required contentid, required siteid, string querystring="", string context="", string stub="", string indexFile="index.cfm") output=false {
		var link ="";
		var href ="";
		var staticIndexFile = "index.htm";
		if ( request.contentBean.getcontentid() == arguments.contentid ) {
			link='<a href="#staticIndexFile#" class="current">#arguments.title#</a>';
		} else {
			href=createHREF(arguments.type,arguments.filename,arguments.siteid,arguments.contentid,arguments.target,iif(arguments.filename eq request.contentBean.getfilename(),de(''),de(arguments.targetParams)),arguments.queryString,arguments.context,arguments.stub,arguments.indexFile);
			link='<a href="#href#" #iif(request.contentBean.getparentid() eq arguments.contentid,de("class=current"),de(""))#>#arguments.title#</a>';
		}
		return link;
	}

}
