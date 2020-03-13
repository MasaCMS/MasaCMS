/*  This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
/**
 * This provides base functionality to all Mura core objects
 */
component output="false" hint="This provides base functionality to all Mura core objects" {

	if(server.ColdFusion.ProductName != 'Coldfusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}

	public function init() output=false {
		return this;
	}

	public function setValue(required string property, propertyValue="") output=false {
		variables["#arguments.property#"]=arguments.propertyValue;
		return this;
	}

	public function set(required string property, propertyValue="") output=false {
		return setValue(argumentCollection=arguments);
	}

	public function getValue(required string property, defaultValue) output=false {
		if ( structKeyExists(variables,"#arguments.property#") ) {
			return variables["#arguments.property#"];
		} else if ( structKeyExists(arguments,"defaultValue") ) {
			variables["#arguments.property#"]=arguments.defaultValue;
			return variables["#arguments.property#"];
		} else {
			return "";
		}
	}

	public function get(required string property, defaultValue) output=false {
		return getValue(argumentCollection=arguments);
	}

	public function valueExists(required string property) output=false {
		return structKeyExists(variables,arguments.property);
	}

	public function removeValue(required string property) output=false {
		structDelete(variables,arguments.property);
		return this;
	}

	public function isORM(){
		return false;
	}

	public function getConfigBean() output=false {
		return application.configBean;
	}

	public function getServiceFactory() output=false {
		return application.serviceFactory;
	}

	public function getBean(beanName, siteID="") output=false {
		var bean="";
		bean=getServiceFactory().getBean(arguments.beanName);
		if ( structKeyExists(bean,'valueExists') && bean.valueExists('siteid') ) {
			if ( len(arguments.siteID) ) {
				bean.setValue('siteid',arguments.siteID);
			} else if ( len(getValue("siteID")) ) {
				bean.setValue('siteid',getValue("siteID"));
			}
		}
		return bean;
	}

	public function getEntity(entityName, siteID="") output=false {
		return getBean(arguments.entityName,arguments.siteid);
	}

	public function getPluginManager() output=false {
		return application.pluginManager;
	}

	/**
	 * The eventManager is the same as the pluginManager.
	 */
	public function getEventManager() output=false {
		return application.eventManager;
	}

	public function getCurrentUser() output=false {
		if ( !structKeyExists(request,"currentUser") ) {
			request.currentUser=createObject("component","mura.user.sessionUserFacade").init();
		}
		return request.currentUser;
	}

	public function getPlugin(ID, required siteID="", required cache="true") output=false {
		return application.pluginManager.getConfig(arguments.ID, arguments.siteID, arguments.cache);
	}

	/**
	 * @deprecated Use inject method
	 */
	public function injectMethod(required string toObjectMethod, required any fromObjectMethod) output=false {
		this[ arguments.toObjectMethod ] =  arguments.fromObjectMethod;
		variables[ arguments.toObjectMethod ] =  arguments.fromObjectMethod;
		return this;
	}

	public function inject(required string property, required any propertValue) output=false {
		this[ arguments.property ] =  arguments.propertValue;
		variables[ arguments.property ] =  arguments.propertValue;
		return this;
	}

	public function deleteMethod(required any methodName) output=false {
		StructDelete(this,arguments.methodName);
		StructDelete(variables,arguments.methodName);
	}

	public function getAsJSON() output=false {
		var data = getAsStruct();
		return serializeJSON( data );
	}

	public struct function getAsStruct() output=false {
		var data			= "";
		var iiX			= "";
		var subBeans		= StructNew();
		var subData		= StructNew();
		var subItem		= "";
		var iiY			= "";
		if ( !StructKeyExists(this,"getAllValues") ) {
			return "";
		}
		data = getAllValues();
		for ( iiX in data ) {
			if ( isInstanceOf(data[iiX],"cfobject") ) {
				data[iiX] = data[iiX].getAsStruct();
			} else if ( isStruct( data[iiX] ) && StructCount( data[iiX] ) ) {
				subBeans = data[iiX];
				subData	= StructNew();
				for ( iiY in subBeans ) {
					subItem = subBeans[iiY];
					if ( isInstanceOf(subItem,"cfobject") ) {
						subData[iiY] = subItem.getAsStruct();
					} else if ( isStruct(subItem) ) {
						subData[iiY] = subItem;
					}
				}
				if ( structCount( subData ) ) {
					data[iiX] = subData;
				}
			} else if ( isJSON(data[iiX]) ) {
				data[iiX] = deserializeJSON( data[iiX] );
			}
		}
		return data;
	}

	public function initTracePoint(detail) output=false {
		var tracePoint=structNew();
		if ( !request.muraShowTrace ) {
			return 0;
		}
		tracePoint.detail=arguments.detail;
		tracePoint.start=getTickCount();
		arrayAppend(request.muraTraceRoute,tracePoint);
		return arrayLen(request.muraTraceRoute);
	}

	public function commitTracePoint(tracePointID) output=false {
		var tracePoint="";
		if ( arguments.tracePointID ) {
			tracePoint=request.muraTraceRoute[arguments.tracePointID];
			tracePoint.stop=getTickCount();
			tracePoint.duration=tracePoint.stop-tracePoint.start;
			tracePoint.total=tracePoint.stop-request.muraRequestStart;
		}
	}

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
				if(!isDefined('arguments.password') || !len(arguments.password)){
					structDelete(arguments,'username');
					structDelete(arguments,'password');
				}
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
			//Trick to allow statelesss interaction outside of rest api
			try{
				structKeyExists(session,'mura');
			} catch(any e){
				param name="request.muraSessionPlaceholder" default={};
				var sessionData=request.muraSessionPlaceholder;
			}
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
			sessionData.mura.csrfsecretkey=createUUID();
			sessionData.mura.csrfusedtokens={};
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

}
