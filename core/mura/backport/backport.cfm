<cfscript>
request.backported=true;

try{
	esapiencode('html', 'test');
} catch (any e){
	include '/core/mura/backport/esapiencode.cfm';
}

if(structKeyExists(server, 'boxlang')){
	include '/core/mura/backport/boxlang.cfm';
} else if(structKeyExists(server, 'lucee')){
	include '/core/mura/backport/lucee.cfm';
} else {
	include '/core/mura/backport/acf.cfm';
}
</cfscript>
