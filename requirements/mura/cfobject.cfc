<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent output="false" hint="This provides base functionality to all Mura core objects">

<cfscript>
	if(server.ColdFusion.ProductName != 'Coldfusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="setValue" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	<cfset variables["#arguments.property#"]=arguments.propertyValue />
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	<cfreturn setValue(argumentCollection=arguments)>
</cffunction>

<cffunction name="getValue" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">

	<cfif structKeyExists(variables,"#arguments.property#")>
		<cfreturn variables["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="get" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	<cfreturn getValue(argumentCollection=arguments)>
</cffunction>

<cffunction name="valueExists" output="false">
	<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables,arguments.property) />
</cffunction>

<cffunction name="removeValue" output="false">
	<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables,arguments.property) />
		<cfreturn this>
</cffunction>

<cffunction name="getConfigBean" output="false">
	<cfreturn application.configBean />
</cffunction>

<cffunction name="getServiceFactory" output="false">
	<cfreturn application.serviceFactory />
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="beanName">
	<cfargument name="siteID" default="">
	<cfset var bean="">

	<cfset bean=getServiceFactory().getBean(arguments.beanName) />

	<cfif structKeyExists(bean,'valueExists') and bean.valueExists('siteid')>
		<cfif len(arguments.siteID)>
			<cfset bean.setValue('siteid',arguments.siteID)>
		<cfelseif len(getValue("siteID"))>
			<cfset bean.setValue('siteid',getValue("siteID"))>
		</cfif>
	</cfif>

	<cfreturn bean>
</cffunction>

<cffunction name="getEntity" output="false">
	<cfargument name="entityName">
	<cfargument name="siteID" default="">
	<cfreturn getBean(arguments.entityName,arguments.siteid)>
</cffunction>

<cffunction name="getPluginManager" output="false">
	<cfreturn application.pluginManager />
</cffunction>

<cffunction name="getEventManager" output="false" hint="The eventManager is the same as the pluginManager.">
	<cfreturn application.eventManager />
</cffunction>

<cffunction name="getCurrentUser" output="false">
	<cfif not structKeyExists(request,"currentUser")>
		<cfset request.currentUser=createObject("component","mura.user.sessionUserFacade").init() />
	</cfif>
	<cfreturn request.currentUser>
</cffunction>

<cffunction name="getPlugin" output="false">
	<cfargument name="ID">
	<cfargument name="siteID" required="true" default="">
	<cfargument name="cache" required="true" default="true">

	<cfreturn application.pluginManager.getConfig(arguments.ID, arguments.siteID, arguments.cache) />
</cffunction>

<cffunction name="injectMethod" output="false" deprecated="Use inject method">
	<cfargument name="toObjectMethod" type="string" required="true" />
	<cfargument name="fromObjectMethod" type="any" required="true" />
	<cfset this[ arguments.toObjectMethod ] =  arguments.fromObjectMethod  />
	<cfset variables[ arguments.toObjectMethod ] =  arguments.fromObjectMethod />
	<cfreturn this>
</cffunction>

<cffunction name="inject" output="false">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="propertValue" type="any" required="true" />
	<cfset this[ arguments.property ] =  arguments.propertValue  />
	<cfset variables[ arguments.property ] =  arguments.propertValue />
	<cfreturn this>
</cffunction>

<cffunction name="deleteMethod" output="false">
	<cfargument name="methodName" type="any" required="true" />
	<cfset StructDelete(this,arguments.methodName)>
	<cfset StructDelete(variables,arguments.methodName)>
</cffunction>

<cffunction name="getAsJSON" output="false" >
	<cfset var data = getAsStruct() />
	<cfreturn serializeJSON( data ) />
</cffunction>

<cffunction name="getAsStruct" output="false" returntype="struct">
	<cfset var data			= "">
	<cfset var iiX			= "">
	<cfset var subBeans		= StructNew()>
	<cfset var subData		= StructNew()>
	<cfset var subItem		= "">
	<cfset var iiY			= "">

	<cfif not StructKeyExists(this,"getAllValues")>
		<cfreturn "" />
	</cfif>

	<cfset data = getAllValues() />

	<cfloop collection="#data#" item="iiX">
		<cfif isInstanceOf(data[iiX],"cfobject")>
			<cfset data[iiX] = data[iiX].getAsStruct() />
		<cfelseif isStruct( data[iiX] ) and StructCount( data[iiX] )>
			<cfset subBeans = data[iiX] />
			<cfset subData	= StructNew()>
			<cfloop collection="#subBeans#" item="iiY">
				<cfset subItem = subBeans[iiY] />
				<cfif isInstanceOf(subItem,"cfobject")>
					<cfset subData[iiY] = subItem.getAsStruct() />
				<cfelseif isStruct(subItem)>
					<cfset subData[iiY] = subItem />
				</cfif>
 			</cfloop>
			<cfif structCount( subData )>
				<cfset data[iiX] = subData />
			</cfif>
		<cfelseif isJSON(data[iiX])>
			<cfset data[iiX] = deserializeJSON( data[iiX] ) />
		</cfif>
	</cfloop>

	<cfreturn data />
</cffunction>

<cffunction name="initTracePoint" output="false">
	<cfargument name="detail">
	<cfset var tracePoint=structNew()>
	<cfif not request.muraShowTrace>
		<cfreturn 0>
	</cfif>
	<cfset tracePoint.detail=arguments.detail>
	<cfset tracePoint.start=getTickCount()>
	<cfset arrayAppend(request.muraTraceRoute,tracePoint)>
	<cfreturn arrayLen(request.muraTraceRoute)>
</cffunction>

<cffunction name="commitTracePoint" output="false">
	<cfargument name="tracePointID">
	<cfset var tracePoint="">
	<cfif arguments.tracePointID>
		<cfset tracePoint=request.muraTraceRoute[arguments.tracePointID]>
		<cfset tracePoint.stop=getTickCount()>
		<cfset tracePoint.duration=tracePoint.stop-tracePoint.start>
		<cfset tracePoint.total=tracePoint.stop-request.muraRequestStart>
	</cfif>
</cffunction>

<cfscript>
	public any function invokeMethod(required string methodName, struct methodArguments={}) {
		if(structKeyExists(this, arguments.methodName)) {
			var theMethod = this[ arguments.methodName ];
			return theMethod(argumentCollection = methodArguments);
		}
		if(structKeyExists(this, "onMissingMethod")) {
			return this.onMissingMethod(missingMethodName=arguments.methodName, missingMethodArguments=arguments.methodArguments);
		}
		throw("You have attempted to call the method #arguments.methodName# which does not exist in #getClassFullName()#");
	}

	function hasCustomDatasource(){
		return len(getValue('customDatasource'));
	}

	function getQueryAttrs(readOnly=false){
		if( hasCustomDatasource() ){
			arguments.datasource=getValue('customDatasource');
			structDelete(arguments,'username');
			structDelete(arguments,'password');

			if(!getBean('configBean').getValue(property='allowQueryCaching',defaultValue=true)){
				structDelete(arguments,'cachedWithin');
			}

			structDelete(arguments,'readOnly');

			return arguments;
		} else if (isDefined('arguments.readOnly')) {
			if(arguments.readOnly){
				return getBean('configBean').getReadOnlyQRYAttrs(argumentCollection=arguments);
			} else {
				structDelete(arguments,'readOnly');
				return arguments;
			}
		} else {
			return structNew();
		}
	}

	function getQueryService(readOnly=false){
		return new Query(argumentCollection=getQueryAttrs(argumentCollection=arguments));
	}

	function getHTTPService(){
		var configBean=getBean('configBean');
		var hs=new http();
		if(len(configBean.getProxyServer())){
			hs.setProxyServer(configBean.getProxyServer());
			hs.setProxyPort(configBean.getProxyPort());

			hs.setProxyUser(configBean.getProxyUser());
			hs.setProxyPassword(configBean.getProxyPassword());

			if(configBean.getProxyAuthType() == 'NTLM'){
				hs.setAuthType('NTLM');
			}
		}

		return hs;
	}

	function getHTTPAttrs(authtype=''){
        var configBean=getBean('configBean');
        var connectionType = "BASIC";

        if(listFindNoCase('PROXY,NTLM,BASIC',arguments.authtype)){
            connectionType = arguments.authtype;
        } else if(len(configBean.getProxyServer())){
            connectionType = 'PROXY';
        }

        structDelete(arguments,"authtype");

        if(connectionType == "NTLM") {

            if(find('\',configBean.getProxyUser())){
                structAppend(arguments,{
                    domain=listFirst(configBean.getProxyUser(),'\'),
                    username=listLast(configBean.getProxyUser(),'\')
                });
            } else {
                arguments.username=configBean.getProxyUser();
            }

            structAppend(arguments,{
                password=configBean.getProxyPassword(),
                authtype="NTLM"
            });

        } else if(connectionType == 'PROXY'){

            structAppend(arguments,{
                proxyserver=configBean.getProxyServer(),
                proxyport=configBean.getProxyPort(),
                proxyuser=configBean.getProxyUser(),
                proxypassword=configBean.getProxyPassword()
            });

        }

        return arguments;
   }


    function convertTimezone(datetime,from,to){
		var tz=getJavaTimezone();

		if(!isDefined('arguments.from')){
			arguments.from=tz.getDefault().getID();
		}

		if(!isDefined('arguments.to')){
			arguments.to=tz.getDefault().getID();
		}

		if (arguments.from == arguments.to){
			return arguments.datetime;
		} else {


			var currentdate=createObject('java','java.lang.System').currentTimeMillis();
			var offset=(tz.getTimezone(arguments.from).getOffSet(javaCast('long',currentdate)) / 1000);

			if(offset > 0){
				offset = 0 - abs(offset);
			} else {
				offset = 0 + abs(offset);
			}

			arguments.datetime= dateAdd(
				"s",
	   			offset,
	   			arguments.datetime
	   		);

	   		arguments.datetime= dateAdd(
				"s",
	   			(tz.getTimezone(arguments.to).getOffSet(javaCast('long',currentdate)) / 1000),
	   			arguments.datetime
	   		);

			return arguments.datetime;
		}
	}

	function getJavaTimezone(timezone){
		var tz=createObject( "java", "java.util.TimeZone" );

		if(isDefined('arguments.timezone')){
			return tz.getTimezone(arguments.timezone);
		} else {
			return tz;
		}
	}

	function getSession(){
		if(request.muraSessionManagement && isdefined('session')){
			var sessionData=session;
		} else {
			param name="request.muraSessionPlaceholder" default={};
			var sessionData=request.muraSessionPlaceholder;
		}

		if(!structKeyExists(sessionData,'mura')){
			sessionData.mura={};
			sessionData.mura.isLoggedIn=false;
			sessionData.mura.userID="";
			sessionData.mura.siteID="";
			sessionData.mura.subtype="Default";
			sessionData.mura.username="";
			sessionData.mura.password="";
			sessionData.mura.fname="";
			sessionData.mura.lname="";
			sessionData.mura.company="";
			sessionData.mura.lastlogin="";
			sessionData.mura.passwordCreated="";
			sessionData.mura.email="";
			sessionData.mura.remoteID="";
			sessionData.mura.memberships="";
			sessionData.mura.membershipids="";
			sessionData.mura.showTrace=false;
		}

		param name="sessionData.siteid" default="default";

		return sessionData;

	}

	function mixin(obj){
		for(var key in obj){
			this.inject('#key#',arguments.obj[key]);
		}

		return this;
	}

	function getFeed(beanName,siteid=""){
		return getBean(argumentCollection=arguments).getFeed();
	}

	function parseDateArg(String arg){

 		//fix so that date's like 2015-06-23T14:22:35 can be parsed
 		if(refind('(\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d)',arguments.arg)){
 			arguments.arg=replace(arguments.arg,'T',' ');
 		}

		if(lsisDate(arguments.arg)){
			try{
				return lsparseDateTime(arguments.arg);
			} catch(any e){
				return arguments.arg;
			}

		} else if(isDate(arguments.arg)){
			try{
				return parseDateTime(arguments.arg);
			} catch(any e){
				return arguments.arg;
			}
		} else {
			return "";
		}
	}
</cfscript>

</cfcomponent>
