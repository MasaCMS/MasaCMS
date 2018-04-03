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

	public function setUserManager(userManager) output=false {
		variables.userManager=arguments.userManager;
	}

	public function before(rc) output=false {
		param default=0 name="arguments.rc.Type";
		param default=0 name="arguments.rc.ContactForm";
		param default=0 name="arguments.rc.isPublic";
		param default="" name="arguments.rc.email";
		param default="" name="arguments.rc.jobtitle";
		param default="" name="arguments.rc.lastupdate";
		param default="" name="arguments.rc.lastupdateby";
		param default=0 name="arguments.rc.lastupdatebyid";
		param default=0 name="arguments.rc.rsGrouplist.recordcount";
		param default="" name="arguments.rc.groupname";
		param default="" name="arguments.rc.fname";
		param default="" name="arguments.rc.lname";
		param default="" name="arguments.rc.address";
		param default="" name="arguments.rc.city";
		param default="" name="arguments.rc.state";
		param default="" name="arguments.rc.zip";
		param default="" name="arguments.rc.phone1";
		param default="" name="arguments.rc.phone2";
		param default="" name="arguments.rc.fax";
		param default=0 name="arguments.rc.perm";
		param default="" name="arguments.rc.groupid";
		param default="" name="arguments.rc.routeid";
		param default=0 name="arguments.rc.InActive";
		param default=1 name="arguments.rc.startrow";
		param default="" name="arguments.rc.categoryID";
		param default="" name="arguments.rc.routeID";
		param default=structnew() name="arguments.rc.error";
		param default="" name="arguments.rc.returnurl";
		if ( !session.mura.isLoggedIn ) {
			secure(arguments.rc);
		}
	}

	public function edit(rc) output=false {
		if ( !isdefined('arguments.rc.userBean') ) {
			arguments.rc.userBean=variables.userManager.read(session.mura.userID);
		}
		//  This is here for backward plugin compatibility
		appendRequestScope(arguments.rc);
	}

	public function update(rc) output=false {
		if ( rc.$.validateCSRFTokens() ) {
			request.newImageIDList="";
			arguments.rc.userBean=variables.userManager.update(arguments.rc,false);
			if ( structIsEmpty(arguments.rc.userBean.getErrors()) ) {
				structDelete(session.mura,"editBean");
			
				variables.fw.redirect(action="home.redirect",path="./");
			}
		}
	}

}
