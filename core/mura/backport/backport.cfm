<cfscript>
request.backported=true;

try{
	esapiencode('html', 'test');
} catch (any e){
	include './esapiencode.cfm';
}

if(structKeyExists(server, 'boxlang')){
	include './boxlang.cfm';
} else if(structKeyExists(server, 'lucee')){
	include './lucee.cfm';
} else {
	include './acf.cfm';
}
</cfscript>
