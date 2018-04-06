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
 * This provides the ability to manage plugin specific application level variables
 */
component extends="mura.cfobject" output="false" hint="This provides the ability to manage plugin specific application level variables" {
	variables.properties=structNew();
	variables.wired=structNew();
	variables.pluginConfig="";

	public function init(any data="#structNew()#") output=false {
		variables.properties=arguments.data;
		variables.utility=getBean('utility');
		return this;
	}

	public function setPluginConfig(pluginConfig) output=false {
		variables.pluginConfig=arguments.pluginConfig;
	}

	public function setValue(required string property, required propertyValue="", required autowire="false") output=false {
		variables.properties[arguments.property]=arguments.propertyValue;
		structDelete(variables.wired,arguments.property);
		if ( arguments.autowire && isObject(arguments.propertyValue) ) {
			doAutowire(variables.properties[arguments.property]);
			variables.wired[arguments.property]=true;
		}
	}

	public function doAutowire(cfc) output=false {
		var i="";
		var property="";
		var setters="";
		if ( application.cfversion > 8 ) {
			setters=findImplicitAndExplicitSetters(arguments.cfc);
			for ( i in setters ) {
				wireProperty(arguments.cfc,i);
			}
		} else {
			for ( i in arguments.cfc ) {
				if ( len(i) > 3 && left(i,3) == "set" ) {
					property=right(i,len(i)-3);
					wireProperty(arguments.cfc,property);
				}
			}
		}
		return arguments.cfc;
	}

	private function wireProperty(object, property) output=false {
		var args=structNew();
		if ( arguments.property != "value" ) {
			if ( arguments.property == "pluginConfig" ) {
				args[arguments.property] = variables.pluginConfig;
				variables.utility.invokeMethod(component=arguments.object,methodName="set#arguments.property#",args=args);
			} else if ( structKeyExists(variables.properties,arguments.property) ) {
				args[arguments.property] = variables.properties[arguments.property];
				variables.utility.invokeMethod(component=arguments.object,methodName="set#arguments.property#",args=args);
			} else if ( getServiceFactory().containsBean(arguments.property) ) {
				args[arguments.property] = getBean(arguments.property);
				variables.utility.invokeMethod(component=arguments.object,methodName="set#arguments.property#",args=args);
			}
		}
	}
	//  Ported from FW1

	private function findImplicitAndExplicitSetters(cfc) output=false {

		//Moved all the varing to top of method for CF8 compilation.
		var baseMetadata = getMetadata( arguments.cfc );
		var setters = { };
		var md = "";
		var n = "";
		var property = "";
		var i = "";
		var implicitSetters = "";
		var member = "";
		var method = "";

		// is it already attached to the CFC metadata?
		if ( structKeyExists( baseMetadata, '__fw1_setters' ) )  {
			setters = baseMetadata.__fw1_setters;
		} else {
			md = { extends = baseMetadata };
			do {
				md = md.extends;
				implicitSetters = false;
				// we have implicit setters if: accessors="true" or persistent="true"
				if ( structKeyExists( md, 'persistent' ) and isBoolean( md.persistent ) ) {
					implicitSetters = md.persistent;
				}
				if ( structKeyExists( md, 'accessors' ) and isBoolean( md.accessors ) ) {
					implicitSetters = implicitSetters or md.accessors;
				}
				if ( structKeyExists( md, 'properties' ) ) {
					// due to a bug in ACF9.0.1, we cannot use var property in md.properties,
					// instead we must use an explicit loop index... ugh!
					n = arrayLen( md.properties );
					for ( i = 1; i lte n; i=i+1 ) {
						property = md.properties[ i ];
						if ( implicitSetters ||
								structKeyExists( property, 'setter' ) and isBoolean( property.setter ) and property.setter ) {
							setters[ property.name ] = 'implicit';
						}
					}
				}
			} while ( structKeyExists( md, 'extends' ) );
			// cache it in the metadata (note: in Railo 3.2 metadata cannot be modified
			// which is why we return the local setters structure - it has to be built
			// on every controller call; fixed in Railo 3.3)
			baseMetadata.__fw1_setters = setters;
		}
		// gather up explicit setters as well
		for ( member in arguments.cfc ) {
			method = arguments.cfc[ member ];
			n = len( member );
			if ( isCustomFunction( method ) and left( member, 3 ) eq 'set' and n gt 3 ) {
				 property = right( member, n - 3 );
				setters[ property ] = 'explicit';
			}
		}
		return setters;
	}

	public function getValue(required string property, required defaultValue="", required autowire="true") output=false {
		var returnValue="";
		if ( structKeyExists(variables.properties,arguments.property) ) {
			returnValue=variables.properties[arguments.property];
		} else {
			variables.properties[arguments.property]=arguments.defaultValue;
			returnValue=variables.properties[arguments.property];
		}
		if ( arguments.autowire && isObject(returnValue) && !structKeyExists(variables.wired,arguments.property) ) {
			doAutowire(returnValue);
			variables.wired[arguments.property]=true;
		}
		return returnValue;
	}

	public function getAllValues() output=false {
		return variables.properties;
	}

	public function valueExists(required string property) output=false {
		return structKeyExists(variables.properties,arguments.property);
	}

	public function removeValue(required string property) output=false {
		structDelete(variables.properties,arguments.property);
		structDelete(variables.wired,arguments.property);
	}

	/**
	 * This is for fw1 autowiring
	 */
	public function containsBean(required string property) output=false {
					return (structKeyExists(variables.properties,arguments.property) && isObject(variables.properties[arguments.property]))
	 				|| getServiceFactory().containsBean(arguments.property) || arguments.property == "pluginConfig";
	}

				/**
	 * This is for fw1 autowiring
	 */
	public function getBean(required string property) output=false {
			if ( arguments.property == "pluginConfig" ) {
				return variables.pluginConfig;
			} else if ( getServiceFactory().containsBean(arguments.property) ) {
				return getServiceFactory().getBean(arguments.property);
			} else {
				return getValue(arguments.property);
			}
		}

	}
