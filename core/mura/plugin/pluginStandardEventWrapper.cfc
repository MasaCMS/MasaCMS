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
 * This provides functionality to parse runtime context and provide it to the executing event handler method
 */
component extends="mura.cfobject" output="false" hint="This provides functionality to parse runtime context and provide it to the executing event handler method" {
	variables.eventHandler="";
	variables.eventName="";
	variables.objectName="";

	public function init(eventHandler, eventName) output=false {
		variables.eventHandler=arguments.eventHandler;
		variables.eventName=arguments.eventName;
		variables.objectName=getMetaData(variables.eventHandler).name;
		variables.utility=getBean('utility');
		return this;
	}

	public function splitContexts(context) output=false {
		var contexts=structNew();
		if ( listLast(getMetaData(arguments.context).name, '.') == "MuraScope" ) {
			contexts.muraScope=arguments.context;
			contexts.event=arguments.context.event();
		} else {
			contexts.muraScope=arguments.context.getValue("muraScope");
			contexts.event=arguments.context;
		}
		return contexts;
	}

	public function handle(context) output=false {
		var contexts=splitContexts(arguments.context);
		var tracePoint=0;
		var handler="";

		if ( structKeyExists(variables.eventHandler,variables.eventName) ) {
			tracePoint=initTracePoint("#variables.objectName#.#variables.eventName#");

			var args={
					event=contexts.event,
					mura=contexts.muraScope,
					m=contexts.muraScope,
					$=contexts.muraScope
				};

			variables.utility.invokeMethod(component=variables.eventHandler,methodName=variables.eventName,args=args);
		} else {
			tracePoint=initTracePoint("#variables.objectName#.handle");
			variables.eventHandler.handle(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope);
		}
		commitTracePoint(tracePoint);
		request.muraHandledEvents["#variables.eventName#"]=true;
	}

	public function validate(context) output=false {
		var contexts=splitContexts(arguments.context);
		var verdict="";
		var tracePoint=0;
		if ( structKeyExists(variables.eventHandler,variables.eventName) ) {
			var args={
					event=contexts.event,
					mura=contexts.muraScope,
					m=contexts.muraScope,
					$=contexts.muraScope
				};

			verdict=variables.utility.invokeMethod(component=variables.eventHandler,methodName=variables.eventName,args=args);

		} else {
			tracePoint=initTracePoint("#variables.objectName#.validate");
			verdict=variables.eventHandler.validate(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope);
		}
		commitTracePoint(tracePoint);
		request.muraHandledEvents["#variables.eventName#"]=true;
		if ( isdefined("verdict") ) {
			return verdict;
		}
	}

	public function translate(context) output=false {
		var contexts=splitContexts(arguments.context);
		var tracePoint=0;
		if ( structKeyExists(variables.eventHandler,variables.eventName) ) {
			tracePoint=initTracePoint("#variables.objectName#.#variables.eventName#");

			var args={
					event=contexts.event,
					mura=contexts.muraScope,
					m=contexts.muraScope,
					$=contexts.muraScope
				};

			variables.utility.invokeMethod(component=variables.eventHandler,methodName=variables.eventName,args=args);
		} else {
			tracePoint=initTracePoint("#variables.objectName#.translate");
			variables.eventHandler.translate(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope, m=contexts.muraScope);
		}
		commitTracePoint(tracePoint);
		request.muraHandledEvents["#variables.eventName#"]=true;
	}

}
