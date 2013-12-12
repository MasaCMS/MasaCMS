<cfscript>
request.layout=false;
bean1=$.getBean('content').loadBy(contenthistid=rc.contenthistid1);
bean2=$.getBean('content').loadBy(contenthistid=rc.contenthistid2);

//Make sure to always compare the older to newer
if(bean1.getLastUpdate() < bean2.getLastUpdate()){
	diff=bean1.compare(bean2);
} else{
	diff=bean2.compare(bean1);
}	

if(!structIsEmpty(diff)){
	for(i in diff){
		writeOutput("<h3>#ucase(i)#</h3>");
		writeOutput(diff[i].html);
		
		/*
		for(d in diff[i].diff){
			if(d.operation.toString() == 'EQUAL'){
				writeOutput(d.text);
			} else if(d.operation.toString() == 'INSERT'){
				writeOutput('<ins>' & d.text & '</ins>');
			} else if(d.operation.toString() == 'DELETE'){
				writeOutput('<del>' & d.text & '</del>');
			}
		}
		*/
	}
} else { 
	writeOutput(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.codediffnodifference'));
}
</cfscript>