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
component extends="controller" output="false" {

	public function before(rc) output=false {
		if ( !(
				listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0')
				or listFind(session.mura.memberships,'S2')
				) ) {
			secure(arguments.rc);
		}
		application.classExtensionManager=variables.configBean.getClassExtensionManager();
		param default="" name="arguments.rc.subTypeID";
		param default="" name="arguments.rc.extendSetID";
		param default="" name="arguments.rc.attibuteID";
		param default="" name="arguments.rc.siteID";
		param default=0 name="arguments.rc.hasAvailableSubTypes";
	}

	public function exportsubtype(rc) output=false {
		param default="list" name="arguments.rc.action";
		if ( arguments.rc.action == 'export' ) {
			variables.fw.redirect(action="cExtend.export",append="siteid",path="./");
		}
		arguments.rc.subtypes = application.classExtensionManager.getSubTypes(arguments.rc.siteID,false);
	}

	public function importsubtypes(rc) output=false {
		var file = "";
		var fileContent = "";
		var fileManager=getBean("fileManager");
		param default="" name="arguments.rc.action";
		if ( arguments.rc.action == 'import' && arguments.rc.$.validateCSRFTokens(context='import') ) {
			if ( structKeyExists(arguments.rc,"newfile") && len(arguments.rc.newfile) ) {
				file = fileManager.upload( "newFile" );
				fileContent=fileRead("#file.serverdirectory#/#file.serverfile#");
				application.classExtensionManager.loadConfigXML( xmlParse(filecontent) ,arguments.rc.siteid);
				variables.fw.redirect(action="cExtend.listSubTypes",append="siteid",path="./");
			}
		}
	}

	public function export(rc) output=false {
		param default="" name="arguments.rc.exportClassExtensionID";
		extendArray = [];
		arguments.rc.exportXML = "";
		if ( Len(arguments.rc.exportClassExtensionID) ) {
			extendArray = ListToArray( arguments.rc.exportClassExtensionID );
			arguments.rc.exportXML = application.classExtensionManager.getSubTypesAsXML(extendArray, false);
		}
	}

	public function download(rc) output=false {
		param default="" name="arguments.rc.exportClassExtensionID";
		extendArray = [];
		arguments.rc.exportXML = "";
		if ( Len(arguments.rc.exportClassExtensionID) ) {
			extendArray = ListToArray( arguments.rc.exportClassExtensionID );
			arguments.rc.exportXML = application.classExtensionManager.getSubTypesAsXML(extendArray, false);
		}
	}

	public function updateSubType(rc) output=false {
		if ( !arguments.rc.hasAvailableSubTypes ) {
			arguments.rc.availableSubTypes="";
		}
		arguments.rc.subtypeBean=application.classExtensionManager.getSubTypeByID(arguments.rc.subTypeID);
		arguments.rc.subtypeBean.set(arguments.rc);
		if ( arguments.rc.$.validateCSRFTokens(context=arguments.rc.subtypeid) ) {
			if ( arguments.rc.action == 'Update' ) {
				arguments.rc.subtypeBean.save();
			}
			if ( arguments.rc.action == 'Delete' ) {
				arguments.rc.subtypeBean.delete();
			}
			if ( arguments.rc.action == 'Add' ) {
				arguments.rc.subtypeBean.save();
			}
		}
		if ( arguments.rc.action != 'delete' ) {
			arguments.rc.subTypeID=rc.subtypeBean.getSubTypeID();
			variables.fw.redirect(action="cExtend.listSets",append="subTypeID,siteid",path="./");
		} else {
			variables.fw.redirect(action="cExtend.listSubTypes",append="siteid",path="./");
		}
	}

	public function updateSet(rc) output=false {
		arguments.rc.extendSetBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean();
		arguments.rc.extendSetBean.set(arguments.rc);
		if ( arguments.rc.$.validateCSRFTokens(context=arguments.rc.extendsetid) ) {
			if ( arguments.rc.action == 'Update' ) {
				arguments.rc.extendSetBean.save();
			}
			if ( arguments.rc.action == 'Delete' ) {
				arguments.rc.extendSetBean.delete();
			}
			if ( arguments.rc.action == 'Add' ) {
				arguments.rc.extendSetBean.save();
			}
		}
		if ( arguments.rc.action != 'delete' ) {
			variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="./");
		} else {
			variables.fw.redirect(action="cExtend.listSets",append="subTypeId,siteid",path="./");
		}
	}

	public function updateRelatedContentSet(rc) output=false {
		arguments.rc.rcsBean = getBean('relatedContentSet').loadBy(relatedContentSetID=arguments.rc.relatedContentSetID);
		if ( !arguments.rc.hasAvailableSubTypes ) {
			arguments.rc.availableSubTypes="";
		}
		arguments.rc.rcsBean.set(arguments.rc);
		if ( arguments.rc.$.validateCSRFTokens(context=arguments.rc.relatedContentSetID) ) {
			if ( listFindNoCase("Update,Add", arguments.rc.action) ) {
				arguments.rc.rcsBean.save();
			}
			if ( arguments.rc.action == 'Delete' ) {
				arguments.rc.rcsBean.delete();
			}
		}
		variables.fw.redirect(action="cExtend.listSets",append="subTypeId,siteid",path="./");
	}

	public function updateAttribute(rc) output=false {
		arguments.rc.attributeBean=application.classExtensionManager.getSubTypeBean().getExtendSetBean().getattributeBean();
		arguments.rc.attributeBean.set(arguments.rc);
		if ( arguments.rc.$.validateCSRFTokens(context=arguments.rc.attributeid) ) {
			if ( arguments.rc.action == 'Update' ) {
				arguments.rc.attributeBean.save();
			}
			if ( arguments.rc.action == 'Delete' ) {
				arguments.rc.attributeBean.delete();
			}
			if ( arguments.rc.action == 'Add' ) {
				arguments.rc.attributeBean.save();
			}
		}
		variables.fw.redirect(action="cExtend.editAttributes",append="subTypeId,extendSetID,siteid",path="./");
	}

	public function saveAttributeSort(rc) output=false {
		application.classExtensionManager.saveAttributeSort(arguments.rc.attributeID);
		abort;
	}

	public function saveExtendSetSort(rc) output=false {
		application.classExtensionManager.saveExtendSetSort(arguments.rc.extendSetID);
		abort;
	}

	public function saveRelatedSetSort(rc) output=false {
		application.classExtensionManager.saveRelatedSetSort(arguments.rc.relatedContentSetID);
		abort;
	}

}
