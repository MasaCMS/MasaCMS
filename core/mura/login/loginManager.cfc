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
 * This provides primary login service functionality
 */
component extends="mura.cfobject" output="false" hint="This provides primary login service functionality" {

	public function init(required any userUtility, required any userDAO, required any utility, required any permUtility, required any settingsManager) output=false {
		variables.userUtility=arguments.userUtility;
		variables.userDAO=arguments.userDAO;
		variables.globalUtility=arguments.utility;
		variables.permUtility=arguments.permUtility;
		variables.settingsManager=arguments.settingsManager;
		return this;
	}

	public boolean function rememberMe(required string userid="", required string userHash="") output=false {
		var rsUser=variables.userDAO.readUserHash(arguments.userid);
		var isLoggedin=0;
		var sessionData=getSession();
		if ( !len(arguments.userHash) || arguments.userHash == rsUser.userHash ) {
			isloggedin=variables.userUtility.loginByUserID(rsUser.userID,rsUser.siteID);
		}
		if ( isloggedin ) {
			sessionData.rememberMe=1;
			return true;
		} else {
			variables.globalUtility.deleteCookie(name="userHash");
			variables.globalUtility.deleteCookie(name="userid");
			sessionData.rememberMe=0;
			return false;
		}
	}

	public function handleSuccess(returnUrl="", rememberMe="0", contentid="", linkServID="", isAdminLogin="false", compactDisplay="false", deviceid="", publicDevice="false") output=false {
		var isloggedin =false;
		var site="";
		var returnDomain="";
		var returnProtocol="";
		var indexFile="./";
		var loginURL="";
		var sessionData=getSession();
		if ( isDefined('sessionData.mfa') ) {
			structDelete(sessionData,'mfa');
		}
		if ( arguments.isAdminLogin ) {
			indexFile="./";
		}
		sessionData.rememberMe=arguments.rememberMe;
		if ( listFind(sessionData.mura.memberships,'S2IsPrivate') ) {
			sessionData.siteArray=arrayNew(1);
			for ( site in variables.settingsManager.getSites() ) {
				if ( variables.permUtility.getModulePerm("00000000000000000000000000000000000","#site#") ) {
					arrayAppend(sessionData.siteArray,site);
				}
			}
			if ( arguments.returnUrl == '' ) {
				if ( len(arguments.linkServID) ) {
					arguments.returnURL="#indexFile#?LinkServID=#arguments.linkServID#";
				} else {
					arguments.returnURL="#indexFile#";
				}
			} else {
				arguments.returnURL = getBean('utility').sanitizeHREF(replace(arguments.returnUrl, 'doaction=logout', '', 'ALL'));
			}
		} else if ( arguments.returnUrl != '' ) {
			arguments.returnURL = getBean('utility').sanitizeHREF(replace(arguments.returnUrl, 'doaction=logout', '', 'ALL'));
		} else {
			if ( len(arguments.linkServID) ) {
				arguments.returnURL="#indexFile#?LinkServID=#arguments.linkServID#";
			} else {
				arguments.returnURL="#indexFile#";
			}
		}
		structDelete(sessionData,'mfa');
		if ( request.muraAPIRequest ) {
			request.muraJSONRedirectURL=arguments.returnURL;
		} else {
			location( arguments.returnURL, false );
		}
	}

	public function sendAuthCode() output=false {
		sendAuthCodeByEmail();
	}

	public function sendAuthCodeByEmail() output=false {
		var sessionData=getSession();
		var site=getBean('settingsManager').getSite(sessionData.mfa.siteid);
		var contactEmail=site.getContact();
		var contactName=site.getSite();
		var mailText=site.getSendAuthCodeScript();
		var user=getBean('user').loadBy(userid=sessionData.mfa.userid,siteid=sessionData.mfa.siteid);
		var firstName=user.getFname();
		var lastName=user.getLname();
		var email=user.getEmail();
		var username=user.getUsername();
		var authcode=sessionData.mfa.authcode;
		var mailer=getBean('mailer');
		if ( getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false) ) {
			var emailtitle=application.rbFactory.getKeyValue(sessionData.rb,'login.deviceauthorizationcode');
		} else {
			var emailtitle=application.rbFactory.getKeyValue(sessionData.rb,'login.authorizationcode');
		}
		if ( !len(mailText) ) {
			savecontent variable="mailText" {

					writeOutput("#firstName#,

Here is the authorization code you requested for username: #username#. It expires in the next 3 hours.

Authorization Code: #authcode#

If you did not request a new authorization, contact #contactEmail#.");

			}
		} else {
			var finder=refind('##.+?##',mailText,1,"true");
			while ( finder.len[1] ) {
				try {
					mailText=replace(mailText,mid(mailText, finder.pos[1], finder.len[1]),'#trim(evaluate(mid(mailText, finder.pos[1], finder.len[1])))#');
				} catch (any cfcatch) {
					mailText=replace(mailText,mid(mailText, finder.pos[1], finder.len[1]),'');
				}
				finder=refind('##.+?##',mailText,1,"true");
			}
		}
		mailer.sendText(trim(mailText),
	email,
	contactName,
	emailtitle,
	user.getSiteID()
	);
	}

	public function handleChallenge(rememberMe="0", contentid="", linkServID="", isAdminLogin="false", compactDisplay="false", deviceid="", publicDevice="false", failedchallenge="false") output=false {
		var sessionData=getSession();

		sessionData.mfa.authcode=variables.userUtility.getRandomPassword();
		if ( !arguments.failedchallenge && getBean('configBean').getValue(property='MFASendAuthCode',defaultValue=true) ) {
			sendAuthCode();
		}
		if ( arguments.isAdminLogin ) {
			location( "./?muraAction=cLogin.main&display=login&status=challenge&failedchallenge=#arguments.failedchallenge#&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#&compactDisplay=#urlEncodedFormat(arguments.compactDisplay)#", false);
		} else {
			var loginURL = application.settingsManager.getSite(request.siteid).getLoginURL();
			if ( find('?', loginURL) ) {
				loginURL &= "&status=challenge&failedchallenge=#arguments.failedchallenge#&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#";
			} else {
				loginURL &= "?status=challenge&failedchallenge=#arguments.failedchallenge#&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#";
			}

			if ( request.muraAPIRequest ) {
				request.muraJSONRedirectURL=loginURL;
			} else {
				location( loginURL, false );
			}
		}
	}

	public function handleFailure(rememberMe="0", contentid="", linkServID="", isAdminLogin="false", compactDisplay="false", deviceid="", publicDevice="false") output=false {
		var sessionData=getSession();
		structDelete(sessionData,'mfa');
		if ( arguments.isAdminLogin ) {
			location( "./?muraAction=cLogin.main&display=login&status=failed&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#&compactDisplay=#urlEncodedFormat(arguments.compactDisplay)#", false );
		} else {
			var loginURL = application.settingsManager.getSite(request.siteid).getLoginURL();
			if ( find('?', loginURL) ) {
				loginURL &= "&status=failed&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#";
			} else {
				loginURL &= "?status=failed&rememberMe=#arguments.rememberMe#&contentid=#arguments.contentid#&LinkServID=#arguments.linkServID#&returnURL=#urlEncodedFormat(arguments.returnUrl)#";
			}
			if ( request.muraAPIRequest ) {
				request.muraJSONRedirectURL=loginURL;
			} else {
				location( loginURL, false );
			}
		}
	}

	public function attemptChallenge($) output=false {
		var sessionData=getSession();
		var eventResponse = arguments.$.renderEvent('onMFAAttemptChallenge');
		var isCodeValid = IsBoolean(eventResponse)
						? eventResponse
						: Len(arguments.$.event('authcode')) && IsDefined('sessionData.mfa.authcode') && arguments.$.event('authcode') == sessionData.mfa.authcode;
		return isCodeValid;
	}

	public function handleChallengeAttempt($) output=false {
		if ( isBoolean(arguments.$.event('attemptChallenge')) && arguments.$.event('attemptChallenge') ) {
			var sessionData=getSession();
			var strikes = createObject("component","mura.user.userstrikes").init(sessionData.mfa.username,getBean('configBean'));
			param name="sessionData.blockLoginUntil" default=strikes.blockedUntil();
			if ( attemptChallenge($=arguments.$) ) {
				strikes.clear();
				return true;
			} else {
				strikes.addStrike();
			}
		}
		return false;
	}

	public function completedChallenge($) output=false {
		var sessionData=getSession();
		var failedchallenge = IsBoolean(arguments.$.event('failedchallenge')) ? arguments.$.event('failedchallenge') : false;

		if ( !IsBoolean(arguments.$.event('isadminlogin')) ) {
			arguments.$.event('isadminlogin', false);
		}

		if ( isDefined('sessionData.mfa') ) {

			if ( failedchallenge ) {
				var data = {
					failedchallenge = true
					, returnurl = arguments.$.event('returnurl')
					, rememberme = arguments.$.event('rememberme')
					, contentid = arguments.$.event('contentid')
					, linkservid = arguments.$.event('linkservid')
					, isadminlogin = arguments.$.event('isadminlogin')
					, compactdisplay = arguments.$.event('compactdisplay')
					, deviceid = arguments.$.event('deviceid')
					, publicdevice = arguments.$.event('publicdevice')
					, m = arguments.$
					, $ = arguments.$
				};

				handleChallenge(argumentCollection=data);
			} else {
				if ( getBean('configBean').getValue(property='MFA',defaultValue=false) && isBoolean(arguments.$.event('rememberdevice')) && arguments.$.event('rememberdevice') ) {
					var userDevice=getBean('userDevice')
							.loadBy(
								userid=sessionData.mfa.userid,
								deviceid=sessionData.mfa.deviceid,
								siteid=sessionData.mfa.siteid
							)
							.setLastLogin(now())
							.save();
				}
				variables.userUtility.loginByUserID(argumentCollection=sessionData.mfa);
				handleSuccess(argumentCollection=sessionData.mfa);
			}
		}

	}

	public function login(struct data, required any loginObject="") output=false {
		var isloggedin =false;
		var returnUrl ="";
		var site="";
		var returnDomain="";
		var returnProtocol="";
		var indexFile="./";
		var loginURL="";
		structDelete(session,'mfa');
		param name="arguments.data.returnUrl" default="";
		param name="arguments.data.rememberMe" default=0;
		param name="arguments.data.contentid" default="";
		param name="arguments.data.linkServID" default="";
		param name="arguments.data.isAdminLogin" default=false;
		param name="arguments.data.compactDisplay" default=false;
		param name="arguments.data.failedchallenge" default=false;
		var sessionData=getSession();
		if ( !isdefined('arguments.data.username') ) {
			if ( request.muraAPIRequest ) {
				request.muraJSONRedirectURL="#indexFile#?muraAction=clogin.main&linkServID=#arguments.data.linkServID#";
				return false;
			} else {
				location( "#indexFile#?muraAction=clogin.main&linkServID=#arguments.data.linkServID#", false );
			}
		} else {
			if ( getBean('configBean').getValue(property='MFA',defaultValue=false) ) {
				var rsUser=variables.userUtility.lookupByCredentials(arguments.data.username,arguments.data.password,arguments.data.siteid);
				if ( rsUser.recordcount ) {
					var $=getBean('$').init(arguments.data.siteid);
					sessionData.mfa={
						userid=rsuser.userid,
						siteid=rsuser.siteid,
						username=rsuser.username,
						returnUrl=arguments.data.returnURL,
						rememberMe=arguments.data.rememberMe,
						contentid=arguments.data.contentid,
						linkServID=arguments.data.linkServID,
						isAdminLogin=arguments.data.isAdminLogin,
						compactDisplay=arguments.data.compactDisplay,
						deviceid=cookie.mxp_trackingid,
						failedchallenge=arguments.data.failedchallenge
					};
					//  if the deviceid is supplied then check to see if the user has validated the device
					if ( getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false) ) {
						var userDevice=$.getBean('userDevice').loadBy(userid=sessionData.mfa.userid,deviceid=sessionData.mfa.deviceid,siteid=sessionData.mfa.siteid);
						if ( userDevice.exists() ) {
							userDevice.setLastLogin(now()).save();
							variables.userUtility.loginByUserId(siteid=rsuser.siteid,userid=rsuser.userid);
							handleSuccess(argumentCollection=sessionData.mfa);
							return true;
						}
					}
					handleChallenge(argumentCollection=arguments.data);
					return false;
				} else {
					handleFailure(argumentCollection=arguments.data);
					return false;
				}
			} else {
				if ( !isObject(arguments.loginObject) ) {
					isloggedin=variables.userUtility.login(arguments.data.username,arguments.data.password,arguments.data.siteid);
				} else {
					isloggedin=arguments.loginObject.login(arguments.data.username,arguments.data.password,arguments.data.siteid);
				}
				if ( isloggedin ) {
					handleSuccess(argumentCollection=arguments.data);
					return true;
				} else {
					handleFailure(argumentCollection=arguments.data);
					return false;
				}
			}
		}
	}

	public function remoteLogin(struct data, required any loginObject="") output=false {
		var isloggedin =false;
		var returnUrl ="";
		var site="";
		if ( !isdefined('arguments.data.username')
		or !isdefined('arguments.data.password')
		or !isdefined('arguments.data.siteid')
		or !(isDefined('form.username') && isDefined('form.password')) ) {
			return false;
		} else {
			return login(data=arguments.data);
		}
	}

	public function loginByUserID(struct data) output=true {
		var isloggedin =false;
		var returnURL="";
		var site="";
		var returnDomain="";
		var sessionData=getSession();
		param name="arguments.data.redirect" default="";
		param name="arguments.data.returnUrl" default="";
		param name="arguments.data.rememberMe" default=0;
		param name="arguments.data.contentid"default="";
		param name="arguments.data.linkServID" default="";
		param name="arguments.data.contentid" default="";
		param name="arguments.data.compactDisplay" default=false;
		param name="arguments.data.isAdminLogin" default=false;
		sessionData.rememberMe=arguments.data.rememberMe;
		if ( !isdefined('arguments.data.userid') ) {
			location( "./?muraAction=clogin.main&linkServID=#arguments.data.linkServID#", false );
		} else {
			if ( getBean('configBean').getValue(property='MFA',defaultValue=false) ) {
				var $=getBean('$').init(arguments.data.siteid);
				var user=$.getBean('user').loadBy(userid=arguments.data.userid,siteid=arguments.data.siteid);
				if ( user.exists() ) {
					sessionData.mfa={
					userid=user.getUserID(),
					siteid=user.getSiteID(),
					username=user.getUsername(),
					returnUrl=arguments.data.returnURL,
					redirect=arguments.data.redirect,
					rememberMe=arguments.data.rememberMe,
					contentid=arguments.data.contentid,
					linkServID=arguments.data.linkServID,
					isAdminLogin=arguments.data.isAdminLogin,
					compactDisplay=arguments.data.compactDisplay,
					deviceid=sessionData.trackingID};
					//  if the deviceid is supplied then check to see if the user has validated the device
					if ( getBean('configBean').getValue(property='MFAPerDevice',defaultValue=false) ) {
						var userDevice=$.getBean('userDevice').loadBy(userid=arguments.data.userid,deviceid=sessionData.mfa.deviceid);
						if ( userDevice.exists() ) {
							userDevice.setLastLogin(now()).save();
							variables.userUtility.loginByUserId(siteid=rsuser.siteid,userid=rsuser.userid);
							handleSuccess(argumentCollection=sessionData.mfa);
							return true;
						}
					}
					handleChallenge(argumentCollection=arguments.data);
					return false;
				} else {
					handleFailure(argumentCollection=arguments.data);
					return false;
				}
			} else {
				isloggedin=variables.userUtility.loginByUserID(arguments.data.userID,arguments.data.siteid);
				if ( isloggedin ) {
					handleSuccess(argumentCollection=arguments.data);
					return true;
				} else {
					handleFailure(argumentCollection=arguments.data);
					return false;
				}
			}
		}
	}

	public function logout() output=false {
		var pluginEvent="";
		if ( structKeyExists(request,"servletEvent") ) {
			pluginEvent=request.servletEvent;
		} else if ( structKeyExists(request,"event") ) {
			pluginEvent=request.event;
		} else {
			pluginEvent = new mura.event();
		}
		if ( len(pluginEvent.getValue("siteID")) ) {
			getPluginManager().announceEvent('onSiteLogout',pluginEvent);
			getPluginManager().announceEvent('onBeforeSiteLogout',pluginEvent);
		} else {
			getPluginManager().announceEvent('onGlobalLogout',pluginEvent);
			getPluginManager().announceEvent('onBeforeGlobalLogout',pluginEvent);
		}
		if ( yesNoFormat(getBean('configBean').getValue("useLegacySessions")) ) {

			getBean('utility').legacyLogout();

		}
		for ( local.i in session ) {
			if ( !listFindNoCase('cfid,cftoken,sessionid,urltoken,jsessionid',local.i) ) {
				structDelete(session,local.i);
			}
		}
		if ( getBean('configBean').getValue(property='rotateSessions',defaultValue='false') ) {
			sessionInvalidate();
		}
		variables.globalUtility.deleteCookie(name="userHash");
		variables.globalUtility.deleteCookie(name="userid");
		getSession();
		getBean('changesetManager').removeSessionPreviewData();
		if ( len(pluginEvent.getValue("siteID")) ) {
			getPluginManager().announceEvent('onAfterSiteLogout',pluginEvent);
		} else {
			getPluginManager().announceEvent('onAfterGlobalLogout',pluginEvent);
		}
	}

}
