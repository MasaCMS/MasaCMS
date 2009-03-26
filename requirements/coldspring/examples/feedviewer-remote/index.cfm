<!---
	$Id: index.cfm,v 1.3 2005/11/17 19:28:29 rossd Exp $
	$Source: D:/CVSREPO/coldspring/coldspring/examples/feedviewer-remote/index.cfm,v $
	$State: Exp $
	$Log: index.cfm,v $
	Revision 1.3  2005/11/17 19:28:29  rossd
	fixes to the flash utils... in the future we need to supply the method to call (or inspect the bean manually), rather than relying on getTO()
	
	Revision 1.2  2005/09/26 02:01:04  rossd
	updated license section
	
	Revision 1.1  2005/09/24 22:12:44  rossd
	first commit of sample app and m2 plugin
	
	Revision 1.1  2005/02/13 17:48:04  rossd
	first check in of feedviewer - remote
	
	
    Copyright (c) 2005 David Ross
--->

<cfoutput>
<html>
<head>
	<title>CFML stupid feedviewer, v#getProperty('applicationVersion')#</title>
	<link rel="stylesheet" type="text/css" href="#getProperty('styleSheetPath')#" />

</head>

<body>
<table id="mainTable" width="100%">
<tr><td>
<cfset facadeUrl = "http" />
<cfif cgi.SERVER_PORT_SECURE>
	<cfset facadeUrl = facadeUrl & "s" />
</cfif>
<cfset facadeUrl = facadeUrl & "://" & cgi.SERVER_NAME />
<cfif not listFind("443,80",cgi.SERVER_PORT)>
	<cfset facadeUrl = facadeUrl & ":" & cgi.SERVER_PORT />
</cfif>
<cfset facadeUrl = facadeUrl & GetPathFromURL(cgi.SCRIPT_NAME) & "remoteFacade.cfc?wsdl" />

<cfset remoteFacade = createObject("webservice",facadeUrl)/>

<h3>View the remoteFacade (<a href="#facadeUrl#">wsdl</a>)&nbsp;(<a href="remoteFacade.cfc">cfc</a>)</h3>

<h3>The calls below were made remotely:</h3>

<br /><br />  
<cfset allCats = remoteFacade.getAllCategories()/>
<cfdump var="#allCats#" label="All Categories"/>
<br />
</cfoutput>

<cfoutput query="allCats" maxrows="1">
	<cfdump var="#remoteFacade.getCategory(allCats.ID)#" label="A single category"/>
</cfoutput>
<cfoutput>

<br />  
<cfdump var="#remoteFacade.getAllChannels()#" label="All Channels"/>
<br /><br />  
<cfdump var="#remoteFacade.getRecentEntries(3)#" label="3 most recent entries"/>
<br /><br />
</td></tr>
</body>
</html>
</cfoutput>

<cfscript>
/**
 * Returns the path from a specified URL.
 * 
 * @param this_url 	 URL to parse. 
 * @return Returns a string. 
 * @author Shawn Seley (shawnse@aol.com) 
 * @version 1, February 21, 2002 
 */
function GetPathFromURL(this_url) {
	var first_char        = "";
	var re_found_struct   = "";
	var path              = "";
	var i                 = 0;
	var cnt               = 0;
	
	this_url = trim(this_url);
	
	first_char = Left(this_url, 1);
	if (Find(first_char, "./")) {
		// relative URL (ex: "../dir1/filename.html" or "/dir1/filename.html")
		re_found_struct = REFind("[^##\?]+", this_url, 1, "True");
	} else if(Find("://", this_url)){
		// absolute URL    (ex: "pass@ftp.host.com">ftp://user:pass@ftp.host.com")
		re_found_struct = REFind("/[^##\?]*", this_url, Find("://", this_url)+3, "True");
	} else {
		// abbreviated URL (ex: "user:pass@ftp.host.com")
		re_found_struct = REFind("/[^##\?]*", this_url, 1, "True");
	}
	
	if (re_found_struct.pos[1] GT 0)  {
		// get path with filename (if exists)
		path = Mid(this_url, re_found_struct.pos[1], re_found_struct.len[1]);
		
		// chop off the filename
 		if(find("/", path)) {
			i = len(path) - find("/" ,reverse(path)) +1;
			cnt = len(path) -i;
			if (cnt LT 1) cnt =1;
			if (REFind("[^##\?]+\.[^##\?]+", Right(path, cnt))){
				// if the part after the last slash is a file name then chop it off
				path = Left(path, i);
			}
		}
		return path;
	} else {
		return "";
	}
}
</cfscript>
