component extends="mura.cfobject"{
	
	remote function getCSRFTokens() returnFormat="json" {	

		try{
  			getpagecontext().getresponse().setcontenttype('application/json; charset=utf-8');
  		} catch(any e){}

		return getBean('$').generateCSRFTokens(context='');
	}

}