component extends="mura.cfobject" {

  public boolean function onSessionStart() {
  	session.loggedin = false;

  	return true;
  }

  public function onGlobalRequestStart($) {
    if(hasCallbackValues()) {
  		handleCallback();
  	}

    if (structKeyExists($.event().getAllValues(), 'showuser')) {
      writeDump($.getBean('event').getCurrentUser().getAllValues());abort;
    }

    if (structKeyExists($.event().getAllValues(), 'logout')) {
      var loginManager = $.getBean('loginManager');
      loginManager.logout();
    }

  }

  function hasCallbackValues(){
    param name="url.code" default="";
    param name="url.loginProvider" default="";
    param name="url.state" default="";
    param name="url.error" default="";
    return len(url.loginProvider) && (len(url.code) || len(url.error) || len(url.state));
  }

  function handleCallback(){
    //Attempt authentication

    if(getServiceFactory().containsBean(url.loginProvider & 'loginProvider')){
      var result = getBean(url.loginProvider & 'loginProvider').validateResult(url.code, url.error, url.state, session.urltoken);
    }

    //If authentication successful, redirect user to intended target, or home if no target exists

    if( result.status ){
      if(isDefined('session.mura.returnURL') && len(session.mura.returnURL)){
        location(url="#session.mura.returnURL#", addToken="no");
        } else {
        location(url=getBean('configBean').getContext(), addToken="no");
      }
    }


  }

  // onLoginPromptRender

  // onSiteRequestStart
}
