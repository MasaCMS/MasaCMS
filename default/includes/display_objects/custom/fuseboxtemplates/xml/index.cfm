<!---
	sample index.cfm if you use Application.cfm
	this should be empty if you use Application.cfc
--->

<!--- set application name based on the directory path 
<cfapplication name="#right(REReplace(expandPath('.'),'[^A-Za-z]','','all'),64)#" />
--->


<!--- enable debugging --->
<cfset FUSEBOX_PARAMETERS.debug = true />
<cfset FUSEBOX_CALLER_PATH = getDirectoryFromPath(getCurrentTemplatePath()) />
<cfset FUSEBOX_APPLICATION_KEY	 ="FBwithXML" />

<!--- include the core file runtime --->
<cfinclude template="/fusebox5/fusebox5.cfm" />
