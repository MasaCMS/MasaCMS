<!---
	This code is a modified version of the javaRB.cfc by Paul Hastings.
	You can find the original code + examples here: 
	
	http://www.sustainablegis.com/unicode/resourceBundle/rb.cfm
	
	My modifications were to simply add a few var statements to rbLocale and
	to add a few more methods, as well as adding persistance to the CFC.
--->

<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.resourceBundle=structNew() />
<cfset variables.locale="en_US" />
<cfset variables.resourceDirectory=getDirectoryFromPath(getCurrentTemplatePath()) & "/resources/"  />
<cfset variables.isLoaded=false/>
<cfset variables.rsFile=""/>
<cfset variables.msgFormat=createObject("java", "java.text.MessageFormat") />	
<cfset variables.javaLocale=createObject("java","java.util.Locale") />
<cfset variables.utils=createObject("component","utils") />

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="locale"  type="string" required="true">
<cfargument name="resourceDirectory"  type="string" default="" required="true">
	
<cfset var lang= ""/>
<cfset var country= ""/>
<cfset var variant= ""/>
	
	<cfset variables.locale=arguments.locale />
	<cfset variables.utils.init(variables.locale) />
	
	<cfif len(arguments.resourceDirectory)>
		<cfset variables.resourceDirectory=arguments.resourceDirectory />
	</cfif>

	<cfset variables.rbFile = variables.resourceDirectory & variables.locale &".properties" />
	<cfset lang=listFirst(variables.Locale,"_")>

	<cfif listLen(arguments.locale,"_") GT 1>
		<cfset country=listGetAt(variables.Locale,2,"_")>
		<cfset variant=listLast(variables.Locale,"_")>
	</cfif>

	<cfset variables.javaLocale.init(lang,country,variant)>
	<cfset loadResourceBundle() />
	
	<cfreturn this />
</cffunction>


<cffunction name="getUtils" returntype="any" output="false">
	<cfreturn variables.utils />
</cffunction>

<cffunction name="convertToUTF" returntype="any" hint="reads and parses java resource bundle per locale">
	<cfargument name="rbfile">
	<cfscript>
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
	</cfscript>
</cffunction>

<cffunction name="LoadResourceBundleLegacy" returntype="any" hint="reads and parses java resource bundle per locale">
	<cfargument name="rbFile">

	<cfscript>
		var thisKEY="";
		var thisMSG="";
		var fis=createObject("java", "java.io.FileInputStream").init(arguments.rbFile);
		var rB=createObject("java", "java.util.PropertyResourceBundle").init(fis);
		var keys=variables.rB.getKeys();

		while (keys.hasMoreElements()) {
			thisKEY=keys.nextElement();
			thisMSG=rB.handleGetObject(thisKey);
			variables.resourceBundle["#thisKEY#"]=thisMSG;
			}
		fis.close();
	</cfscript>
	
	<cfset variables.isloaded=true />
	<cfreturn variables.resourceBundle>

</cffunction> 

<cffunction name="LoadResourceBundle" returntype="any" hint="reads and parses java resource bundle per locale">
	<cfscript>
		var isOk=false; // success flag
		var keys=""; // var to hold rb keys
		var thisKey="";
		var thisMSG="";
		var thisLang=listFirst(variables.Locale,"_");
		var thisDir=GetDirectoryFromPath(variables.rbFile);
		var thisFile=getFileFromPath(variables.rbFile);
		var thisRBfile=thisDir & listFirst(thisFile,".") & "_"& variables.Locale & "." & listLast(thisFile,".");
		var local=structNew();
		var linecheck=false;
		
		if (NOT fileExists(thisRBfile))// still nothing? strip thisRBfile back to base rb
			thisRBfile=thisDir & thisLang & "." & listLast(thisFile,".");
		
		if (NOT fileExists(thisRBfile)) //try just the language
			thisRBfile=thisDir & listFirst(thisFile,".") & "_"& thisLang & "." & listLast(thisFile,".");
		
		if (NOT fileExists(thisRBfile))// still nothing? strip thisRBfile back to base rb
			thisRBFile=variables.rbFile;
		
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
				     	variables.resourceBundle["#reReplaceNoCase(listFirst(local.line,'='), '[^-a-zA-Z0-9.]', '', 'all')#"]=listRest(local.line,'=');
				     	}
				   }
				} while(lineCheck);
			
			br.close();
		}
	</cfscript>
	
	<cfset variables.isloaded=true />
	<cfreturn variables.resourceBundle>

</cffunction> 

<cffunction name="getResourceBundle" returntype="any" access="public" output="false">
	<cfif not variables.isLoaded>	
		<cfset variables.resourceBundle=loadResourceBundle() />			
	</cfif>	

	<cfreturn variables.resourceBundle />	
</cffunction>

<cffunction name="messageFormat" access="public" output="no" returnType="string" hint="performs messageFormat on compound rb string">
	<cfargument name="thisPattern" required="yes" type="string" hint="pattern to use in formatting">
	<cfargument name="args" required="yes" hint="substitution values"> <!--- array or single value to format --->

		<cfset var pattern=createObject("java","java.util.regex.Pattern")>
		<cfset var regexStr="(\{[0-9]{1,},number.*?\})">
		<cfset var p="">
		<cfset var m="">
		<cfset var i=0>
		<cfset var thisFormat="">
		<cfset var inputArgs=arguments.args>
		
		<cftry>
			<cfif NOT isArray(inputArgs)>
				<cfset inputArgs=listToArray(inputArgs)>
			</cfif>	
			<cfset thisFormat=variables.msgFormat.init(replace(arguments.thisPattern,"'","''","all"),variables.javaLocale)>
			<!--- let's make sure any cf numerics are cast to java datatypes --->
			<cfset p=pattern.compile(regexStr,pattern.CASE_INSENSITIVE)>
			<cfset m=p.matcher(arguments.thisPattern)>
			<cfloop condition="#m.find()#">
				<cfset i=listFirst(replace(m.group(),"{",""))>
				<cfset inputArgs[i]=javacast("float",inputArgs[i])>
			</cfloop>
			<cfset arrayPrepend(inputArgs,"")> <!--- dummy element to fool java --->
			<!--- coerece to a java array of objects  --->
			<cfreturn thisFormat.format(inputArgs.toArray())>
			<cfcatch type="Any">
				<cfthrow message="#cfcatch.message#" type="any" detail="#cfcatch.detail#">
			</cfcatch>
		</cftry>
</cffunction>

<cffunction name="verifyPattern" access="public" output="no" returnType="boolean" hint="performs verification on MessageFormat pattern">
	<cfargument name="pattern" required="yes" type="string" hint="format pattern to test">
	<cfscript>
		var test="";
		var isOK=true;
		try {
			test=msgFormat.init(arguments.pattern);			
		}
		catch (Any e) {
			isOK=false;
		}
		return isOk;
	</cfscript>		
</cffunction>

<cffunction name="getKeyValue" returnType="String">
	<cfargument name="key">
	<cfargument name="useMuraDefault" required="true" type="boolean" default="false">
	
	<cfif structKeyExists(variables.resourceBundle,arguments.key)>

		<cfreturn replace(variables.resourceBundle[arguments.key],"''","'","ALL") />

	<cfelseif arguments.useMuraDefault>
		<cfreturn "muraKeyEmpty">

	<cfelse>
		<cfreturn ""/>

	</cfif>

</cffunction>

</cfcomponent>
