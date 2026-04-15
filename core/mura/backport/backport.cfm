<!---
BACKPORT COMPATIBILITY LAYER

Goal: Provides backward compatibility functions and engine-specific polyfills for Masa CMS
across multiple CFML engines (Adobe ColdFusion, Lucee, BoxLang).

Usage Example:
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}

Note: Various attempts have been made to refactor this into a single-line include, but this
isn't possible due to:
- Support required for multiple CFML engines (ACF, Lucee, BoxLang)
- Variable Masa CMS installation paths across different environments
- Different relative paths of files that include this backport file
--->
<cfscript>
request.backported=true;

try{
	esapiencode('html', 'test');
} catch (any e){
	include '#backportdir#esapiencode.cfm';
}

if(structKeyExists(server, 'boxlang')){
	include '#backportdir#boxlang.cfm';
} else if(structKeyExists(server, 'lucee')){
	include '#backportdir#lucee.cfm';
} else {
	include '#backportdir#acf.cfm';
}
</cfscript>
