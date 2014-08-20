<cfscript>
request.backported=true;

if(!structKeyExists(request,'backports')){
	request.backports={openjava=true};
	try{
		CreateObject("java", "org.owasp.esapi.ESAPI");
	} catch(Any e){
		request.backports.openjava=false;
	}
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