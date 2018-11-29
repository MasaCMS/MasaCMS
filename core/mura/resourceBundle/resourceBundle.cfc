/*
	This code is a modified version of the javaRB.cfc by Paul Hastings.
	You can find the original code + examples here:

	http://www.sustainablegis.com/unicode/resourceBundle/rb.cfm

	My modifications were to simply add a few var statements to rbLocale and
	to add a few more methods, as well as adding persistance to the CFC.
*/
/**
 * This provides access to locale resource bundle keys
 */
component extends="mura.cfobject" output="false" hint="This provides access to locale resource bundle keys" {
	variables.resourceBundle=structNew();
	variables.resourceBundleStruct=structNew();
	variables.locale="en_US";
	variables.resourceDirectory=getDirectoryFromPath(getCurrentTemplatePath()) & "/resources/";
	variables.isLoaded=false;
	variables.rsFile="";
	variables.msgFormat=createObject("java", "java.text.MessageFormat");
	variables.javaLocale=createObject("java","java.util.Locale");
	variables.utils=createObject("component","utils");

	public function init(required string locale, required string resourceDirectory="") output=false {
		var lang= "";
		var country= "";
		var variant= "";
		variables.locale=arguments.locale;
		variables.utils.init(variables.locale);
		if ( len(arguments.resourceDirectory) ) {
			variables.resourceDirectory=arguments.resourceDirectory;
		}
		variables.rbFile = variables.resourceDirectory & variables.locale &".properties";
		lang=listFirst(variables.Locale,"_");
		if ( listLen(arguments.locale,"_") > 1 ) {
			country=listGetAt(variables.Locale,2,"_");
			variant=listLast(variables.Locale,"_");
		}
		variables.javaLocale.init(lang,country,variant);
		loadResourceBundle();
		return this;
	}

	public function getUtils() output=false {
		return variables.utils;
	}

	/**
	 * reads and parses java resource bundle per locale
	 */
	public function convertToUTF(rbfile) {

		var keys=""; // var to hold rb keys
		var thisKEY="";
		var thisMSG="";
		var bundle={};
		var fis=createObject("java", "java.io.FileInputStream").init(arguments.rbfile);
		var rB=createObject("java", "java.util.PropertyResourceBundle").init(fis);
		var keys= rB.getKeys();
		var keySorter=[];
		var rbString='';

		while (keys.hasMoreElements()) {
			thisKEY=keys.nextElement();
			thisMSG=rB.handleGetObject(thisKey);
			bundle["#thisKEY#"]=thisMSG;
			arrayAppend(keySorter,thisKEY);
			}
			fis.close();

		arraySort(keySorter,'text','asc');

		for(var r in keySorter){
			rbString=rbString & "#r#=#bundle['#r#']#" &  Chr(13) & Chr(10);
		}

		fileWrite(arguments.rbfile,rbString,'UTF-8');
	}

	/**
	 * reads and parses java resource bundle per locale
	 */
	public function LoadResourceBundleLegacy(rbFile) {

		var thisKEY="";
		var thisMSG="";
		var fis=createObject("java", "java.io.FileInputStream").init(arguments.rbFile);
		var rB=createObject("java", "java.util.PropertyResourceBundle").init(fis);
		var keys=rB.getKeys();

		while (keys.hasMoreElements()) {
			thisKEY=keys.nextElement();
			thisMSG=rB.handleGetObject(thisKey);
			variables.resourceBundle["#thisKEY#"]=thisMSG;
			}
		fis.close();
		variables.isloaded=true;
		return variables.resourceBundle;
	}

	/**
	 * reads and parses java resource bundle per locale
	 */
	public function LoadResourceBundle() {

		var isOk=false; // success flag
		var keys=""; // var to hold rb keys
		var thisKey="";
		var thisMSG="";
		var thisLang=listFirst(variables.Locale,"_");
		var thisDir=GetDirectoryFromPath(variables.rbFile);
		var thisFile=getFileFromPath(variables.rbFile);
		var thisRBfile=thisDir & variables.Locale & ".properties";
		var local=structNew();
		var linecheck=false;

		if (NOT fileExists(thisRBfile))// still nothing? strip thisRBfile back to base rb
			thisRBfile=thisDir & thisLang & ".properties";

		if (fileExists(thisRBFile)) { // final check, if this fails the file is not where it should be
			isOK=true;
			//writeDump(var=thisRBFile,abort=1);
			if(find("\u00",fileRead(thisRBFile))){
				try{
					convertToUTF(thisRBFile);
				} catch(Any e){
					LoadResourceBundleLegacy(thisRBFile);
					return;
				}
			}

			var fis=createObject("java", "java.io.FileInputStream").init(thisRBFile);
			var fisr=createObject("java", "java.io.InputStreamReader").init(fis,"UTF-8");
			var br=createObject("java", "java.io.BufferedReader").init(fisr);

			do
				{
				   local.line = br.readLine();
				   linecheck = isDefined("local.line");
				   if(lineCheck)
				   {
				     if(left(local.line,1) neq "##" and listLen(local.line,"=") gt 1){
				     	variables.resourceBundle["#reReplaceNoCase(listFirst(local.line,'='), '[^a-zA-Z0-9_\-\.]', '', 'all')#"]=listRest(local.line,'=');
				     	}
				   }
				} while(lineCheck);

			br.close();
		}
		variables.isloaded=true;
		return variables.resourceBundle;
	}

	public function getResourceBundle() output=false {
		if ( !variables.isLoaded ) {
			variables.resourceBundle=loadResourceBundle();
		}
		return variables.resourceBundle;
	}

	/**
	 * performs messageFormat on compound rb string
	 */
	public function messageFormat(required string thisPattern, required args) output=false {
		//  array or single value to format
		var pattern=createObject("java","java.util.regex.Pattern");
		var regexStr="(\{[0-9]{1,},number.*?\})";
		var p="";
		var m="";
		var i=0;
		var thisFormat="";
		var inputArgs=arguments.args;
		try {
			if ( !isArray(inputArgs) ) {
				inputArgs=listToArray(inputArgs);
			}
			thisFormat=variables.msgFormat.init(replace(arguments.thisPattern,"'","''","all"),variables.javaLocale);
			//  let's make sure any cf numerics are cast to java datatypes
			p=pattern.compile(regexStr,pattern.CASE_INSENSITIVE);
			m=p.matcher(arguments.thisPattern);
			while ( m.find() ) {
				i=listFirst(replace(m.group(),"{",""));
				inputArgs[i]=javacast("float",inputArgs[i]);
			}
			arrayPrepend(inputArgs,"");
			//  dummy element to fool java
			//  coerece to a java array of objects
			return thisFormat.format(inputArgs.toArray());
		} catch (Any cfcatch) {
			throw( message=cfcatch.message, detail=cfcatch.detail, type="any" );
		}
	}

	/**
	 * performs verification on MessageFormat pattern
	 */
	public boolean function verifyPattern(required string pattern) output=false {

		var test="";
		var isOK=true;
		try {
			test=msgFormat.init(arguments.pattern);
		}
		catch (Any e) {
			isOK=false;
		}
		return isOk;
	}

	public function getKeyValue(key, required boolean useMuraDefault="false") {
		if ( structKeyExists(variables.resourceBundle,arguments.key) ) {
			return replace(variables.resourceBundle[arguments.key],"''","'","ALL");
		} else if ( arguments.useMuraDefault ) {
			return "muraKeyEmpty";
		} else {
			return "";
		}
	}

	function getKeyStructure( key ) {
		if( StructKeyExists(variables.resourceBundleStruct,"key") ) {
			return variables.resourceBundleStruct[key];
		}

		var keyStruct = {};

		for(var i in variables.resourceBundle) {
			if( left( i,len(arguments.key) ) eq key ) {
				variables.resourceBundleStruct[key][replace(i,".","-","all")] = variables.resourceBundle[i];
			}
		}

		return variables.resourceBundleStruct[key];

	}

}
