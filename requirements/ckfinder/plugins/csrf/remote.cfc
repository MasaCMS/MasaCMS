component extends="mura.cfobject"{
	
	remote function getCSRFTokens() returnFormat="json" {	

		try{
			var pc = getpagecontext().getresponse();
  			pc.getresponse().setcontenttype('application/json');
  		} catch(any e){}

		return getBean('$').generateCSRFTokens(context='');
	}

}