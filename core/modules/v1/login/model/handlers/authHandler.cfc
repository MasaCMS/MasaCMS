component extends="mura.cfobject" {

  public boolean function onSessionStart() {
  	session.loggedin = false;

  	return true;
  }

  public function onGlobalRequestStart($) {
    if($.event().valueExists('facebook') && hasCallbackValues()) {
      url.facebook = '1';
  		handleCallback();
  	}

    if($.event().valueExists('github') && hasCallbackValues()) {
      url.github = '1';
  		handleCallback();
  	}

    if($.event().valueExists('google') && hasCallbackValues()) {
      url.google = '1';
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
    param name="url.state" default="";
    param name="url.error" default="";
    return (len(url.code) || len(url.error) || len(url.state));
  }

  function handleCallback(){
    //Attempt authentication

    if( structKeyExists(url, 'facebook') ){
      var result = getBean('facebookLoginUtility').validateResult(url.code, url.error, url.state, session.urltoken);
    } else if( structKeyExists(url, 'github') ){
      var result = getBean('githubLoginUtility').validateResult(url.code, url.error, url.state, session.urltoken);
    } else {
      var result = getBean('googleLoginUtility').validateResult(url.code, url.error, url.state, session.urltoken);
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
