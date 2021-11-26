component extends="mura.cfobject" {

	// Event handler that intercepts deprecations warnings
	// It runs in the global context, so covers ALL Mura sites that are running
	
	public void function onLogDeprecation() {

		log file="myAppLog" text="In de handler onLogDeprecation in de Core" type="information";
		logAction('logDeprecation', arguments.event);

	}	

	private void function logAction(required string type, required struct event) {
		local.m = arguments.event.getMuraScope(); //HMMM interesting..... 
		local.loginType = arguments.event.getValue('isAdminLogin') eq 'true' ? 'admin' : 'site';
		local.username = local.m.getCurrentUser().getUsername();
		local.logType = 'information';
		local.extraMessage = '';

		switch( arguments.type ) {
			case 'loginSuccess': case 'loginFailure': 
				local.logType = arguments.type eq 'loginSuccess' ? 'information' : 'warning';
				local.logMessageType = arguments.type eq 'loginSuccess' ? 'Login' : 'LOGIN FAILURE';
				local.username = arguments.event.getValue('username');
			break;		

			case 'impersonateUser':
				local.logMessageType = 'Impersonate User';
				local.extraMessage = arguments.event.getValue('context').becomeUser.getUsername();
			break;

			case 'logDeprecation':
				local.logMessageType = 'Deprecation Warning';
				//local.extraMessage = arguments.event.getValue('context').downloadDocumentFilePath;
			break;
		}

		local.message = '#local.logMessageType#|#local.username#';

		if( len(local.extraMessage) ) {
			local.message = listAppend(local.message, local.extraMessage, '|');
		}      

		writeLog(type=local.logType, file='mura-deprecations', text=local.message, application="no");

	}

}