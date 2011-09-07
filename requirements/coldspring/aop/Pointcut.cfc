<!---
	  
  Copyright (c) 2005, Chris Scott, David Ross, Kurt Wiersma, Sean Corfield
  All rights reserved.
	
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  $Id: Pointcut.cfc,v 1.6 2005/11/16 16:16:10 rossd Exp $
  $Log: Pointcut.cfc,v $
  Revision 1.6  2005/11/16 16:16:10  rossd
  updates to license in all framework code

  Revision 1.5  2005/10/09 22:45:24  scottc
  Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="Pointcut" 
			displayname="Pointcut" 
			hint="Interface (Abstract Class) for all Pointcut implimentations" 
			output="false">
			
	<cffunction name="init" access="private" returntype="void" output="false">
		<cfthrow message="Abstract CFC. Cannot be initialized" />
	</cffunction>
	
</cfcomponent>