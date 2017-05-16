<cfscript>
//  Preventing XSS attacks

if ( structKeyExists(application,"scriptProtectionFilter") && application.configBean.getScriptProtect() ) {
	if ( isDefined("url") ) {
		application.scriptProtectionFilter.scan(
									object=url,
									objectname="url",
									ipAddress=request.remoteAddr,
									useTagFilter=true,
									useWordFilter=true);
	}
	if ( isDefined("form") ) {
		application.scriptProtectionFilter.scan(
									object=form,
									objectname="form",
									ipAddress=request.remoteAddr,
									useTagFilter=true,
									useWordFilter=true);
	}
	try {
		if ( isDefined("cgi") ) {
			application.scriptProtectionFilter.scan(
										object=cgi,
										objectname="cgi",
										ipAddress=request.remoteAddr,
										useTagFilter=true,
										useWordFilter=true,
										fixValues=false);
		}
		if ( isDefined("cookie") ) {
			application.scriptProtectionFilter.scan(
										object=cookie,
										objectname="cookie",
										ipAddress=request.remoteAddr,
										useTagFilter=true,
										useWordFilter=true,
										fixValues=false);
		}
	} catch (any cfcatch) {
	}
	if ( application.scriptProtectionFilter.isBlocked(request.remoteAddr) == true ) {
		application.eventManager.announceEvent("onGlobalThreatDetect",createObject("component","mura.event").init());
	}
}
</cfscript>
