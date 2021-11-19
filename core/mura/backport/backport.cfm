<cfscript>
request.backported=true;

if(!isdefined('backportdir')){
	if(server.coldfusion.productname != 'Coldfusion Server'){
		backportdir='';
	} else {
		backportdir='/mura/backport/';
	}
}

if(!structKeyExists(request,'backports')){
	request.backports={};
}

if(!structKeyExists(request.backports,'esapiencode')){
	request.backports.esapiencode=false;
	try{
		esapiencode('html','test');
	} catch (Any e){
		request.backports.esapiencode=true;
	}
}

if(request.backports.esapiencode){
	include '#backportdir#esapiencode.cfm';
}

if(isDefined('server.lucee')){
	include '#backportdir#logerror_lucee.cfm';
} else {
	include '#backportdir#logerror_acf.cfm';
}
</cfscript>
