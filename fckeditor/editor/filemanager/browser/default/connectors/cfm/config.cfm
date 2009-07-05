<cfsetting enablecfoutputonly="Yes">

<cfscript>
	config = structNew();

	// SECURITY: You must explicitly enable this "connector". (Set enabled to "true")
	config.enabled = application.permUtility.getModulePerm("00000000000000000000000000000000000",session.siteid);

	config.userFilesPath = "/UserFiles/";

	config.serverPath = "#application.configBean.getFileDir()##application.configBean.getFileDelim()##session.siteid##application.configBean.getFileDelim()#assets"; // use this to force the server path if FCKeditor is not running directly off the root of the application or the FCKeditor directory in the URL is a virtual directory or a symbolic link / junction

	config.allowedExtensions = structNew();
	config.deniedExtensions = structNew();

	// config.allowedExtensions["File"] = "doc,rtf,pdf,ppt,pps,xls,csv,vnd,zip";
	config.allowedExtensions["File"] = "";
	config.deniedExtensions["File"] = "php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,js,reg,cgi";

	config.allowedExtensions["Image"] = "png,gif,jpg,jpeg,bmp";
	config.deniedExtensions["Image"] = "";

	config.allowedExtensions["Flash"] = "swf,fla";
	config.deniedExtensions["Flash"] = "";

	config.allowedExtensions["Media"] = "swf,fla,jpg,gif,jpeg,png,avi,mpg,mpeg,mp3,mp4,m4a,wma,wmv,wav,mid,midi,rmi,rm,ram,rmvb,mov,qt";
	config.deniedExtensions["Media"] = "";
</cfscript>

<!--- code to maintain backwards compatibility with previous version of cfm connector --->
<cfif isDefined("application.userFilesPath")>

	<cflock scope="application" type="readonly" timeout="5">
	<cfset config.userFilesPath = application.userFilesPath>
	</cflock>

<cfelseif isDefined("server.userFilesPath")>
	
	<cflock scope="server" type="readonly" timeout="5">
	<cfset config.userFilesPath = server.userFilesPath>
	</cflock>
	
<cfelseif isDefined("session.userFilesPath")>
	
	<cflock scope="session" type="readonly" timeout="5">
	<cfset config.userFilesPath = session.userFilesPath>
	</cflock>
	
</cfif>

<!--- look for config struct in request, application and server scopes --->
<cfif isDefined("request.FCKeditor") and isStruct(request.FCKeditor)>

	<cfset variables.FCKeditor = request.FCKeditor>

<cfelseif isDefined("application.FCKeditor") and isStruct(application.FCKeditor)>

	<cflock scope="application" type="readonly" timeout="5">
	<cfset variables.FCKeditor = duplicate(application.FCKeditor)>
	</cflock>

<cfelseif isDefined("server.FCKeditor") and isStruct(server.FCKeditor)>

	<cflock scope="server" type="readonly" timeout="5">
	<cfset variables.FCKeditor = duplicate(server.FCKeditor)>
	</cflock>

</cfif>

<cfif isDefined("FCKeditor")>

	<!--- copy key values from external to local config (i.e. override default config as required) --->
	<cfscript>
		function structCopyKeys(stFrom, stTo) {
			for ( key in stFrom ) {
				if ( isStruct(stFrom[key]) ) {
					structCopyKeys(stFrom[key],stTo[key]);
				} else {
					stTo[key] = stFrom[key];
				}
			}
		}
		structCopyKeys(FCKeditor, config);
	</cfscript>

</cfif>
