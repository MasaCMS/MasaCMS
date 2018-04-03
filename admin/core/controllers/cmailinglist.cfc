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

	public function setMailingListManager(mailingListManager) output=false {
		variables.mailingListManager=arguments.mailingListManager;
	}

	public function before(rc) output=false {
		if ( (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') && !listFind(session.mura.memberships,'S2')) && !( variables.permUtility.getModulePerm('00000000000000000000000000000000009','#rc.siteid#') && variables.permUtility.getModulePerm('00000000000000000000000000000000000','#rc.siteid#')) ) {
			secure(arguments.rc);
		}
		param default=1 name="arguments.rc.startrow";
	}

	public function list(rc) output=false {
		arguments.rc.rslist=variables.mailinglistManager.getList(arguments.rc.siteid);
	}

	public function edit(rc) output=false {
		arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid);
	}

	public function listmembers(rc) output=false {
		arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid);
		arguments.rc.rslist=variables.mailinglistManager.getListMembers(arguments.rc.mlid,arguments.rc.siteid);
		arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rslist,30,arguments.rc.startrow);
	}

	public function update(rc) output=false {
		if ( arguments.rc.action == 'add' ) {
			arguments.rc.listBean=variables.mailinglistManager.create(arguments.rc);
			arguments.rc.mlid= rc.listBean.getMLID();
		}
		if ( arguments.rc.action == 'update' ) {
			variables.mailinglistManager.update(arguments.rc);
		}
		if ( arguments.rc.action == 'delete' ) {
			variables.mailinglistManager.delete(arguments.rc.mlid,arguments.rc.siteid);
		}
		if ( arguments.rc.action == 'delete' ) {
			variables.fw.redirect(action="cMailingList.list",append="siteid",path="./");
		} else {
			variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid",path="./");
		}
	}

	public function updatemember(rc) output=false {
		if ( arguments.rc.action == 'add' ) {
			variables.mailinglistManager.createMember(arguments.rc);
		}
		if ( arguments.rc.action == 'delete' ) {
			variables.mailinglistManager.deleteMember(arguments.rc);
		}
		variables.fw.redirect(action="cMailingList.listmembers",append="siteid,mlid",path="./");
	}

	public function download(rc) output=false {
		arguments.rc.listBean=variables.mailinglistManager.read(arguments.rc.mlid,arguments.rc.siteid);
		arguments.rc.rslist=variables.mailinglistManager.getListMembers(arguments.rc.mlid,arguments.rc.siteid);
	}

}
