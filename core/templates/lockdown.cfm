<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<cfoutput>
<title>#REReplace(application.settingsManager.getSite(request.siteID).getEnableLockdown(), "([a-z]{1})", "\U\1", "ONE" )# Mode</title>
<link rel="stylesheet" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/fonts/font-awesome/css/font-awesome.css">
</cfoutput>

<style type="text/css">

body {
	background: #f1f1f1;
	font-family: "Helvetica", "Arial", sans-serif;
	color: #343434;
	margin: 0; padding: 0;
}

#wrapper {
	width: 300px;
	margin: 100px auto;
	background: #FCFCFC;
	padding: 25px;
	border: 1px solid #ccc;
	-moz-border-radius: 5px; -webkit-border-radius: 5px; border-radius: 5px;
}

.alert {
	font-weight: bold;
    text-align: center;
}

form label {
	display: block;
	width: 100%;
	font-size: 14px;
}

form input.text {
	font-size: 12px;
	width: 288px;
	margin: 5px 0 25px;
	padding: 6px;
	border: 1px solid #ccc;
	-moz-border-radius: 3px; -webkit-border-radius: 3px; border-radius: 3px;
	transition: border 100ms linear;
	-moz-transition: border 100ms linear; /* Firefox 4 */
	-webkit-transition: border 100ms linear; /* Safari and Chrome */
	-o-transition: border 100ms linear; /* Opera */

}

form input.text:focus {
	outline: 0;
	border: 1px solid #959595;
}

form select {
	font-size: 12px;
	margin: 5px 0 25px;
	padding: 6px;
	border: 1px solid #ccc;
	-moz-border-radius: 3px; -webkit-border-radius: 3px; border-radius: 3px;
	transition: border 100ms linear;
	-moz-transition: border 100ms linear; /* Firefox 4 */
	-webkit-transition: border 100ms linear; /* Safari and Chrome */
	-o-transition: border 100ms linear; /* Opera */

}

form select {
	outline: 0;
	border: 1px solid #959595;
}

form input.submit {
		cursor: pointer;
		padding: 2px 12px;
    font-weight: 400;
    font-size: 13px;
    display: block;
    width: 100%;
    border: none;
    background-color: #ff3405;
    color: #fff!important;
    height: 35px;
    margin-left: 0;
    margin-right: 0;
}

form p#submitWrap {
	text-align: center;
	margin: 0; padding: 0;
}

form p#error {
	color: #A70001;
	padding: 5px 10px;
	font-size: 12px;
	margin: 0;
	float: left;
}

.text-divider {
    display: flex;
    justify-content:center;
    align-items: center;
    margin-top: 20px;
    position: relative;
    text-align: center;
}

.text-divider::before,
.text-divider::after {
    content: '';
    background: #ccc;
    height: 1px;
    display: block;
    width: 100%;
}

.text-divider span {
		color: #646464;
    font-size: 16px;
    font-weight: bold;
    padding: 10px 20px;
    text-align: center;
}

.center{
	text-align: center;
}
/* login and setup */
.mura-login-auth-btn{
  display: inline-block;
  margin: 0 0 6px;
  height: 40px;
  text-align: left;
 	text-decoration: none;
  width: 100%;
}

.mura-login-auth-btn.ggl{
  background-color: #dc4e41;
}

.mura-login-auth-btn.fb{
  background-color: #4267b2;
}

.mura-login-auth-btn span{
  color: #fff;
  font-size: 16px;
  text-align: left;
  padding: 11px 0 0 12px;
  display: inline-block;
}
.mura-login-auth-btn i{
  border-right: 1px solid #fff;
  color: #fff;
  height: 40px;
  font-size: 28px;
  float: left;
  padding: 6px;
  text-align: center;
  width: 40px;
 	font-family: 'FontAwesome';
}

h3.mura-login-auth-heading{
  margin: 22px;
}

</style>

</head>
<cfoutput>
<body>
	<div id="wrapper">
		<cfif application.settingsManager.getSite(request.siteID).getEnableLockdown() eq "maintenance">
			<div class="alert">#application.settingsManager.getSite(request.siteID).getSite()# is currently undergoing maintenance.</div>

		<cfelseif application.settingsManager.getSite(request.siteID).getEnableLockdown() eq "development">
			<form method="post" action="<cfif application.configBean.getLockdownHTTPS() eq true>#replacenocase(arguments.$.getContentRenderer().createHREF(siteid = request.siteid, filename = arguments.event.getScope().currentfilename, complete = true), "http:", "https:")#</cfif>">

					<cfif listFindNoCase($.globalConfig().getEnableOauth(), 'google') or listFindNoCase($.globalConfig().getEnableOauth(), 'facebook') >

						<!--- Use Google oAuth Button --->
						<cfif listFindNoCase($.globalConfig().getEnableOauth(), 'google')>
							<div style="padding-bottom: 5px" class="center">
								<a href="#$.getBean('googleLoginProvider').generateAuthUrl(session.urltoken)#" title="#$.rbKey('login.loginwithgoogle')#" class="mura-login-auth-btn ggl">
				        	<i class="icon icon-lg icon-google-plus mi-google"></i>
				        	<span>#$.rbKey('login.loginwithgoogle')#</span>
								</a>
							</div>
						</cfif>
						<!--- Use Facebook oAuth Button --->
						<cfif listFindNoCase($.globalConfig().getEnableOauth(), 'facebook')>
							<div style="padding-bottom: 5px" class="center">
								<a href="#$.getBean('facebookLoginProvider').generateAuthUrl(session.urltoken)#" title="#$.rbKey('login.loginwithfacebook')#" class="mura-login-auth-btn fb">
					      	<i class="icon icon-lg icon-facebook mi-facebook"></i>
					      	<span>#$.rbKey('login.loginwithfacebook')#</span>
								</a>
							</div>
						</cfif>

	          <div class="text-divider"><span>#$.rbKey('login.or')#</span></div>
						<h3 class="center mura-login-auth-heading">#$.rbKey('login.loginwithcredentials')#</h3>

					</cfif>

				<label for="locku">Username</label>
				<input type="text" name="locku" id="locku" class="text" />

				<label for="lockp">Password</label>
				<input type="password" name="lockp" id="lockp" class="text" />
				<cfif not $.globalConfig().getValue(property="sessionBasedLockdown",defaultValue=false)>
				<label for="expires">Log me in for:</label>
					<select name="expires">
						<option value="session">Session</option>
						<option value="1">One Day</option>
						<option value="7">One Week</option>
						<option value="30">One Month</option>
						<option value="10950">Forever</option>
					</select>
				</cfif>

				<input type="hidden" name="locks" value="true" />
				<cfif len(event.getValue('locks'))>
					<p id="error">Login failed!</p>
				</cfif>
				<p id="submitWrap"><input type="submit" name="submit" value="#$.rbKey('login.login')#" class="submit" /></p>
			</form>
		</cfif>
	</div>
</body>
</cfoutput>
</html>
<cfabort>
