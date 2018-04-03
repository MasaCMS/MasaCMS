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

	public function setLoginManager(loginManager) output=false {
		variables.loginManager=arguments.loginManager;
	}

	public function before(rc) output=false {
		param default="" name="arguments.rc.returnurl";
		param default="" name="arguments.rc.status";
		param default="" name="arguments.rc.contentid";
		param default="" name="arguments.rc.contenthistid";
		param default="" name="arguments.rc.topid";
		param default="" name="arguments.rc.type";
		param default="" name="arguments.rc.moduleid";
		param default="" name="arguments.rc.redirect";
		param default="" name="arguments.rc.parentid";
		param default="" name="arguments.rc.siteid";
	}

	public function main(rc) output=false {
		if ( listFind(session.mura.memberships,'S2IsPrivate') ) {
			variables.fw.redirect(action="home.redirect",path="./");
		}
	}

	public function login(rc) output=false {
		if ( rc.$.validateCSRFTokens(context='login') ) {
			var loginManager=rc.$.getBean('loginManager');
			if ( isBoolean(rc.$.event('attemptChallenge')) && rc.$.event('attemptChallenge') ) {
				rc.$.event('failedchallenge', !loginManager.handleChallengeAttempt(rc.$));
				loginManager.completedChallenge(rc.$);
			} else if ( isDefined('form.username') && isDefined('form.password') ) {
				loginManager.login(arguments.rc);
			}
		} else {
			variables.fw.redirect(action="clogin.main",path="./");
		}
	}

	public function logout(rc) output=false {
		variables.loginManager.logout();
		variables.fw.redirect(action="home.redirect",path="./");
	}

}
