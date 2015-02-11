<cffunction name="esapiEncode" output="false" returntype="string">
	<cfargument name="encodeFor" type="string" default="html" hint="encode for what, valid values are: - css: for output inside Cascading Style Sheets (CSS) - dn: for output in LDAP Distinguished Names - html: for output inside HTML - html_attr: for output inside HTML Attributes - javascript: for output inside Javascript - ldap: for output in LDAP queries - url: for output in URL - vbscript: for output inside vbscript - xml: for output inside XML - xml_attr: for output inside XML Attributes - xpath: for output in XPath">
	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode">
	<cfscript>

			if(!isDefined('request.esapiencoder')){
				if(application.configBean.getJavaEnabled()){
					try{
						request.esapiencoder=CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
					} catch (any e){
						request.esapiencoder='';
					}
				} else {
					request.esapiencoder='';
				}
			}

			if(isObject(request.esapiencoder)){
				var encoder = '';
				var encodedString = '';

				encoder = request.esapiencoder;


				switch(arguments.encodeFor) {
					case 'css' :
						encodedString = encoder.encodeForCSS(JavaCast("string", arguments.inputString));
						break;
					case 'dn' :
						encodedString = encoder.encodeForDN(JavaCast("string", arguments.inputString));
						break;
					case 'html' :
						encodedString = encoder.encodeForHTML(JavaCast("string", arguments.inputString));
						break;
					case 'html_attr' :
						encodedString = encoder.encodeForHTMLAttribute(JavaCast("string", arguments.inputString));
						break;
					case 'javascript' :
						encodedString = encoder.encodeForJavascript(JavaCast("string", arguments.inputString));
						break;
					case 'ldap' : 
						encodedString = encoder.encodeForLDAP(JavaCast("string", arguments.inputString));
						break;
					case 'url' :
						encodedString = encoder.encodeForURL(JavaCast("string", arguments.inputString));
						break;
					case 'vbscript' :
						encodedString = encoder.encodeForVBScript(JavaCast("string", arguments.inputString));
						break;
					case 'xml' :
						encodedString = encoder.encodeForXML(JavaCast("string", arguments.inputString));
						break;
					case 'xml_attr' :
						encodedString = encoder.encodeForXMLAttribute(JavaCast("string", arguments.inputString));
						break;
					case 'xpath' :
						encodedString = encoder.encodeForXPath(JavaCast("string", arguments.inputString));
						break;
					default :
						throw(
							type = 'Invalid data'
							, message = "The encodeFor value ["& arguments.encodeFor & "] is invalid, valid values are [css,dn,html,html_attr,javascript,ldap,vbscript,xml,xml_attr,xpath]"
						 );
				}
			} else {
				switch(arguments.encodeFor) {
					case 'css' :
						encodedString = arguments.inputString;
						break;
					case 'dn' :
						encodedString = arguments.inputString;
						break;
					case 'html' :
						encodedString = htmlEditFormat(arguments.inputString);
						break;
					case 'html_attr' :
						encodedString = htmlEditFormat(arguments.inputString);
						break;
					case 'javascript' :
						encodedString = JSStringFormat(arguments.inputString);
						break;
					case 'ldap' : 
						encodedString = arguments.inputString;
						break;
					case 'url' :
						encodedString = urlEncodedFormat(arguments.inputString);
						break;
					case 'vbscript' :
						encodedString = arguments.inputString;
						break;
					case 'xml' :
						encodedString = xmlFormat(arguments.inputString);
						break;
					case 'xml_attr' :
						encodedString = xmlFormat(arguments.inputString);
						break;
					case 'xpath' :
						encodedString = arguments.inputString;
						break;
					default :
						throw(
							type = 'Invalid data'
							, message = "The encodeFor value ["& arguments.encodeFor & "] is invalid, valid values are [css,dn,html,html_attr,javascript,ldap,vbscript,xml,xml_attr,xpath]"
						 );
				}
			}
			
			return encodedString;
	</cfscript>
</cffunction>

