/**
 * This provides access to the current user's session
 */
component extends="mura.cfobject" output="false" hint="This provides access to the current user's session" {
	variables.userBean="";

	/**
	 * Handles missing method exceptions.
	 */
	public function OnMissingMethod(required string MissingMethodName, required struct MissingMethodArguments) output=false {
		var prop="";
		var prefix=left(arguments.MissingMethodName,3);
		var theValue="";
		var bean="";
		if ( len(arguments.MissingMethodName) ) {
			//  forward normal getters to the default getValue method
			if ( listFindNoCase("set,get",prefix) && len(arguments.MissingMethodName) > 3 ) {
				prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3);
				if ( prefix == "get" ) {
					return getValue(prop);
				} else if ( prefix == "set" && !structIsEmpty(MissingMethodArguments) ) {
					setValue(prop,MissingMethodArguments[1]);
					return this;
				}
			}
			//  otherwise get the bean and if the method exsists forward request
			bean=getUserBean();
			if ( !structIsEmpty(MissingMethodArguments) ) {
				theValue=bean.invokeMethod(methodName=MissingMethodName,methodArguments=MissingMethodArguments);
			} else {
				theValue=bean.invokeMethod(methodName=MissingMethodName);
			}
			if ( isDefined("theValue") ) {
				return theValue;
			} else {
				return "";
			}
		} else {
				return "";
		}
	}

		public function init() output=false {
			variables.sessionData=getSession();
			return this;
		}

		public function getValue(property) output=false {
			var theValue="";
			if ( isDefined('get#arguments.property#') ) {
				var tempFunc=this["get#arguments.property#"];
				return tempFunc();
			} else if ( !structKeyExists(variables.sessionData.mura,arguments.property) ) {
				theValue=getUserBean().getValue(arguments.property);
				if ( isSimpleValue(theValue) ) {
					variables.sessionData.mura[arguments.property]=theValue;
				}
				return theValue;
			} else {
				return variables.sessionData.mura[arguments.property];
			}
		}

		public function setValue(property, propertyValue) output=false {
			if ( !hasSession() ) {
				variables.sessionData=getSession();
			}
			variables.sessionData.mura[arguments.property]=arguments.propertyValue;
			getUserBean().setValue(arguments.property, arguments.propertyValue);
			return this;
		}

		public function set(property, propertyValue) output=false {
			setValue(argumentCollection=arguments);
			return this;
		}

		public function get(property) output=false {
			return getValue(argumentCollection=arguments);
		}

		public function getAll() output=false {
			return getAllValues();
		}

		public function getUserBean() output=false {
			if ( isObject(variables.userBean) ) {
				return variables.userBean;
			} else {
				if ( !hasSession() ) {
					variables.sessionData=getSession();
				}
				variables.userBean=application.userManager.read(variables.sessionData.mura.userID);
				if ( variables.userBean.getIsNew() ) {
					variables.userBean.setSiteID(getValue('siteID'));
				}
			}
			return variables.userBean;
		}

		public function getFullName() output=false {
			if ( hasSession() ) {
				return trim("#variables.sessionData.mura.fname# #variables.sessionData.mura.lname#");
			} else {
				return "";
			}
		}

		public boolean function isInGroup(group, isPublic) output=false {
			var siteid="";
			var publicPool="";
			var privatePool="";
			if ( hasSession() ) {
				siteid=variables.sessionData.mura.siteID;
				if ( structKeyExists(request,"siteid") ) {
					siteID=request.siteID;
				}
				publicPool=application.settingsManager.getSite(siteid).getPublicUserPoolID();
				privatePool=application.settingsManager.getSite(siteid).getPrivateUserPoolID();
				if ( variables.sessionData.mura.isLoggedIn && len(siteID) ) {
					if ( structKeyExists(arguments,"isPublic") ) {
						if ( arguments.isPublic ) {
							return application.permUtility.isUserInGroup(arguments.group,publicPool,1);
						} else {
							return application.permUtility.isUserInGroup(arguments.group,privatePool,0);
						}
					} else {
						return application.permUtility.isUserInGroup(arguments.group,publicPool,1) || application.permUtility.isUserInGroup(arguments.group,privatePool,0);
					}
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

		public boolean function isPrivateUser() output=false {
			if ( hasSession() ) {
				var siteid=variables.sessionData.mura.siteID;
				if ( structKeyExists(request,"siteid") ) {
					siteID=request.siteID;
				}
				return application.permUtility.isS2() || application.permUtility.isPrivateUser(siteid);
			} else {
				return false;
			}
		}

		public boolean function isSystemUser() output=false {
			return isPrivateUser();
		}

		public boolean function isSuperUser() output=false {
			if ( hasSession() ) {
				return application.permUtility.isS2();
			} else {
				return false;
			}
		}

		public boolean function isAdminUser() output=false {
			if ( hasSession() ) {
				return isInGroup('Admin',0);
			} else {
				return false;
			}
		}

		public boolean function isLoggedIn() output=false {
			if ( hasSession() ) {
				return variables.sessionData.mura.isLoggedIn;
			} else {
				return false;
			}
		}

		public boolean function isPassedLockdown() output=false {
			if(getBean('configBean').getValue(property="sessionBasedLockdown",defaultValue=false)){
				var sessionData=getSession();
				if ( !structKeyExists(sessionData, "passedLockdown") ) {
					sessionData.passedLockdown=false;
				}
				return sessionData.passedLockdown;
			} else {
				if ( !structKeyExists(cookie, "passedLockdown") ) {
					application.utility.setCookie(name="passedLockdown", value="false");
				}
				return cookie.passedLockdown;
			}
		}

		public boolean function hasSession() output=false {
			return isDefined("variables.sessionData.mura");
		}

		public function logout() output=false {
			getBean('loginManager').logout();
			return this;
		}

		public function getAllValues() output=false {
			return getUserBean().getAllValues();
		}

		public function validateCSRFTokens($="", context="") output=false {
			if ( !hasSession() ) {
				variables.sessionData=getSession();
			}
			// CLEAR OLD TOKENS
			for ( local.key in variables.sessionData.mura.csrfusedtokens ) {
				if ( variables.sessionData.mura.csrfusedtokens['#local.key#'] < dateAdd('h',-3,now()) ) {
					structDelete(variables.sessionData.mura.csrfusedtokens,'#local.key#');
				}
			}
			//  CAN ONLY USE TOKEN ONCE
			if ( !len(arguments.$.event('csrf_token')) || structKeyExists(variables.sessionData.mura.csrfusedtokens, "#arguments.$.event('csrf_token')#") ) {
				return false;
			}
			if ( application.cfversion < 10 ) {
				if ( arguments.$.event('csrf_token_expires') > (now() + 0) && arguments.$.event('csrf_token') == hash(arguments.context & variables.sessionData.mura.csrfsecretkey & arguments.$.event('csrf_token_expires')) ) {
					variables.sessionData.mura.csrfusedtokens["#arguments.$.event('csrf_token')#"]=now();
					return true;
				} else {
					return false;
				}
			} else {
				if ( arguments.$.event('csrf_token_expires') > datetimeformat(now(),'yyMMddHHnnsslll') && arguments.$.event('csrf_token') == hash(arguments.context & variables.sessionData.mura.csrfsecretkey & arguments.$.event('csrf_token_expires')) ) {
					variables.sessionData.mura.csrfusedtokens["#arguments.$.event('csrf_token')#"]=now();
					return true;
				} else {
					return false;
				}
			}
		}

		public function generateCSRFTokens(timespan="#createTimeSpan(0,3,0,0)#", context="") output=false {
			if ( !hasSession() ) {
				variables.sessionData=getSession();
			}
			if ( application.cfversion < 10 ) {
				var expires="#numberFormat((now() + arguments.timespan),'99999.9999999')#";
			} else {
				var currentDateTime = now();
				var milliseconds = datetimeFormat(currentDateTime,'lll');
				var expires=dateTimeFormat(dateAdd('l',milliseconds,(currentDateTime + arguments.timespan)),'yyMMddHHnnsslll');
			}
			return {
				expires=expires,
				token=hash(arguments.context & variables.sessionData.mura.csrfsecretkey & expires)
			};
		}

		public function renderCSRFTokens(timespan="#createTimeSpan(0,3,0,0)#", context="", format="form") output=false {
			var csrf=generateCSRFTokens(argumentCollection=arguments);
			switch ( arguments.format ) {
				case  "url":
					return "&csrf_token=#csrf.token#&csrf_token_expires=#csrf.expires#";
					break;
				case  "json":
					return "{csrf_token:'#csrf.token#',csrf_token_expires:'#csrf.expires#'}";
					break;
				default:
					savecontent variable="local.str" {
							writeOutput('<input type="hidden" name="csrf_token" value="#csrf.token#" /><input type="hidden" name="csrf_token_expires" value="#csrf.expires#" />');
					}
					return local.str;
					break;
			}
		}

	}
