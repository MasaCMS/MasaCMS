<cfparam name="path" default="" />

<cfscript>
request.backported=true;

try{
	esapiencode('html', 'test');
} catch (any e){
	include path & '#backportdir#esapiencode.cfm';
}

if(structKeyExists(server, 'boxlang')){
	include path & '#backportdir#boxlang.cfm';
} else if(structKeyExists(server, 'lucee')){
	include path & '#backportdir#lucee.cfm';
} else {
	include path & '#backportdir#acf.cfm';
}
</cfscript>
