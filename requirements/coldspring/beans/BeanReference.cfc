<!---
 
  Copyright (c) 2005, David Ross, Chris Scott, Kurt Wiersma, Sean Corfield
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: BeanReference.cfc,v 1.4 2005/11/16 16:16:11 rossd Exp $

--->

<cfcomponent>

	<cffunction name="init" returntype="coldspring.beans.BeanReference" access="public" output="false"
				hint="I am used within complex Bean Properties as a placeholder for a bean">
		<cfargument name="beanID" type="string" required="true" />
		<cfset this.beanID = arguments.beanID/>		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBeanID" returntype="string" access="public" output="false">
		<cfreturn this.beanID />		
	</cffunction>
</cfcomponent>

