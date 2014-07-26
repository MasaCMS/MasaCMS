component extends="mura.cfobject"{
	
	remote function getCSRFTokens() returnFormat="json" {	
		return getBean('$').generateCSRFTokens(context='');
	}

}