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

	public function setEmailManager(emailManager) output=false {
		variables.emailManager=arguments.emailManager;
	}

	public function before(rc) output=false {
		if ( (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') && !listFind(session.mura.memberships,'S2')) && !( variables.permUtility.getModulePerm('00000000000000000000000000000000005',arguments.rc.siteid) && variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid)) ) {
			secure(arguments.rc);
		}
		session.moduleID="00000000000000000000000000000000005";
		param default="list" name="arguments.rc.muraAction";
		param default="" name="arguments.rc.subject";
		param default="" name="arguments.rc.bodytext";
		param default="" name="arguments.rc.bodyhtml";
		param default="" name="arguments.rc.createddate";
		param default="" name="arguments.rc.deliverydate";
		param default="" name="arguments.rc.grouplist";
		param default="" name="arguments.rc.groupid";
		param default="" name="arguments.rc.emailid";
		param default=2 name="arguments.rc.status";
		param default="" name="arguments.rc.lastupdatebyid";
		param default="" name="arguments.rc.lastupdateby";
		param default=2 name="session.emaillist.status";
		param default="" name="session.emaillist.groupid";
		param default="" name="session.emaillist.subject";
		param default=1 name="session.emaillist.dontshow";
	}

	public function list(rc) output=false {
		arguments.rc.rsList=variables.emailManager.getList(arguments.rc);
		arguments.rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(arguments.rc.siteid);
		arguments.rc.rsPublicGroups=variables.emailManager.getPublicGroups(arguments.rc.siteid);
		arguments.rc.rsMailingLists=variables.emailManager.getMailingLists(arguments.rc.siteid);
	}

	public function edit(rc) output=false {
		arguments.rc.emailBean=variables.emailManager.read(arguments.rc.emailid);
		arguments.rc.rsPrivateGroups=variables.emailManager.getPrivateGroups(arguments.rc.siteid);
		arguments.rc.rsPublicGroups=variables.emailManager.getPublicGroups(arguments.rc.siteid);
		arguments.rc.rsMailingLists=variables.emailManager.getMailingLists(arguments.rc.siteid);
		arguments.rc.rsTemplates=variables.emailManager.getTemplates(arguments.rc.siteid);
	}

	public function update(rc) output=false {
		variables.emailManager.update(arguments.rc);
		variables.fw.redirect(action="cEmail.list",append="siteid",path="./");
	}

	public function showAllBounces(rc) output=false {
		arguments.rc.rsBounces=variables.emailManager.getAllBounces(arguments.rc);
	}

	public function showBounces(rc) output=false {
		arguments.rc.rsBounces=variables.emailManager.getBounces(arguments.rc.emailid);
	}

	public function showReturns(rc) output=false {
		arguments.rc.rsReturns=variables.emailManager.getReturns(arguments.rc.emailid);
		arguments.rc.rsReturnsByUser=variables.emailManager.getReturnsByUser(arguments.rc.emailid);
	}

	public function deleteBounces(rc) output=false {
		variables.emailManager.deleteBounces(arguments.rc);
		location(url="./?muraAction=cEmail.showAllBounces&siteid=#arguments.rc.siteid#",addToken=false );
	}

}
