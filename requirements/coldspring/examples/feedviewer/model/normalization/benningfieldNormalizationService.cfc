<!---
 
  Copyright (c) 2002-2005	David Ross,	Chris Scott
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: benningfieldNormalizationService.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="Normalization Service" hint="Uses Roger Benningfield's rssatomnormcfc"  extends="coldspring.examples.feedviewer.model.normalization.normalizationService" output="false">
	
	<cffunction name="init" returntype="coldspring.examples.feedviewer.model.normalization.benningfieldNormalizationService" access="public">
		<cfargument name="rssatomnormalizer" type="coldspring.examples.feedviewer.Benningfield.rssatomnorm" required="true"/>
		<cfset variables.m_normalizer = arguments.rssatomnormalizer>
		<cfreturn this/>
	</cffunction>

	<cffunction name="setRetrievalService" returntype="void" access="public" output="false" hint="dependency: retrievalService">
		<cfargument name="retrievalService" type="coldspring.examples.feedviewer.model.retrieval.retrievalService" required="true"/>
		<cfset variables.m_retrievalService = arguments.retrievalService/>
	</cffunction>	
		
	<cffunction name="normalize" returntype="array" output="false" hint="Returns an array of structs containing author, content, date, id, link, and title members. Also returns an isHtml member that is set to 'true' when the content element contains HTML." access="public">
		<cfargument name="url" type="string" required="true"/>
		<cfset var xmlContent = variables.m_retrievalService.retrieve(arguments.url)/>
		<cfreturn variables.m_normalizer.normalize(xmlContent)>
	</cffunction>
	
</cfcomponent>