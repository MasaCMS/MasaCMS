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
	include '#backportdir#esapiencode.cfm';
}
</cfscript>