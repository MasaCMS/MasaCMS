<cfscript>
request.backported=true;

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
	try {
		include '#backportdir#esapiencode.cfm';
	} catch (any e) {
		include 'esapiencode.cfm';
	}
}

if(isDefined('server.lucee')){
	include '#backportdir#lucee.cfm';
} else {
	include '#backportdir#acf.cfm';
}
</cfscript>
