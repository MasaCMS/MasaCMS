component extends="mura.cfobject"{
	
	remote function getCSRFTokens() returnFormat="json" {	

		var pc = getpagecontext().getresponse();
  		pc.getresponse().setcontenttype('application/json');

		return getBean('$').generateCSRFTokens(context='');
	}

}