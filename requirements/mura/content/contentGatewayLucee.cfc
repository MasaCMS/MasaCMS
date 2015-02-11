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
<cfcomponent extends="contentGatewayAdobe" output="false">

<cffunction name="renderMenuTypeClause" output="true">
<cfargument name="menuType">
<cfargument name="menuDateTime">
<cfoutput>
			<cfswitch expression="#arguments.menuType#">
					<cfcase value="Calendar,CalendarDate">
						tcontent.Display = 2 	 
					 	AND 
						  (
						  	tcontent.DisplayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,arguments.menuDateTime)#">
						  	AND 
						  		(
						  			tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#"> or tcontent.DisplayStop is null
						  		)
						  	)  
					</cfcase>
					<cfcase value="calendar_features">
					  	tcontent.Display = 2 	 
					 	AND
					  		(
					  			tcontent.DisplayStart >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#"> 
					  			OR (tcontent.DisplayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#"> AND tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#">)
					  		)
					 </cfcase>
					 <cfcase value="ReleaseDate">
					 	(
						 	tcontent.Display = 1 
						 	
						 OR
						 	( 
						   	tcontent.Display = 2 	 
						 	 	AND 
						 	 	(
						 	 		tcontent.DisplayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,arguments.menuDateTime)#">
							  		AND (
							  				tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#"> or tcontent.DisplayStop is null
							  			)  
								)
							)
						)
						  
						AND
						
						(
						  	(
						  		tcontent.releaseDate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,arguments.menuDateTime)#">
						  		AND tcontent.releaseDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#">) 
						  		
						  	OR 
						  	 (
						  	 	tcontent.releaseDate is Null
						  		AND tcontent.lastUpdate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,arguments.menuDateTime)#">
						  		AND tcontent.lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#">
						  	)
					  	)	
					  	
					  </cfcase>
					  <cfcase value="ReleaseMonth">
					   (
						 	tcontent.Display = 1 
						 	
						 OR
						 	( 
						   	tcontent.Display = 2 	 
						 	 	AND 
								(
									tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
									AND tcontent.DisplayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("M",1,arguments.menuDateTime)#">
									AND (
										tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
										or tcontent.DisplayStop is null
									)

								)
							)
						)
						  
						AND
						(
						  	(
						  		tcontent.releaseDate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime)))#">
						  		AND  tcontent.releaseDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1)#">) 
						  		
						  	OR 
					  		(
					  			tcontent.releaseDate is Null
					  			AND tcontent.lastUpdate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime)))#">
					  			AND tcontent.lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1)#">
					  		)  
					  	)
					   </cfcase>
					  <cfcase value="CalendarMonth">
						tcontent.display=2
						
						AND
						(
						  	(
						  		tcontent.displayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime)))#">
						  		AND  tcontent.displayStart >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1)#"> 
						  	)
						  	
						  	or 
						  	
						  	(
						  		tcontent.displayStop < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime)))#">
						  		AND  
						  			(
						  				tcontent.displayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1)#"> 
						  				or tcontent.displayStop is null
						  			)
						  	)
						  	
						  	or 
						  	
						  	(
						  		tcontent.displayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1)#">
						  		and 
						  			(
						  				tcontent.displayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime)))#">
						  				or tcontent.displayStop is null
						  			) 
						  	)
						 )
					  </cfcase>
					  <cfcase value="ReleaseYear"> 
						  (
							
							    tcontent.Display = 1
							
							    OR
							        (
							            tcontent.Display = 2	
							                AND (
							                    tcontent.DisplayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,arguments.menuDateTime)#"> AND (
							                        tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#"> or tcontent.DisplayStop is null
							                    )
							            )
							    )
							
							) AND (
							
							    (
							        tcontent.releaseDate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),12,31))#"> AND tcontent.releaseDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),1,1)#">)
							    OR
							        (
							            tcontent.releaseDate is Null AND tcontent.lastUpdate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),12,31))#"> AND tcontent.lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),1,1)#">			
							        )
							    )
					  </cfcase> 
					  <cfcase value="fixed">
					  	
					  	tcontent.Display = 1 
					  	
					   </cfcase>
					  <cfdefaultcase>
					  
					 	tcontent.Display = 1 
					  	OR
					  	(
					  		tcontent.Display = 2 	 
					 		AND 
					 	 		(
					 	 			tcontent.DisplayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#">
						  			AND 
						  				(
						  					tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.menuDateTime#"> or tcontent.DisplayStop is null
						  				)  
						  		)
						)
					  
					  </cfdefaultcase>
			</cfswitch>
</cfoutput>
</cffunction>

</cfcomponent>