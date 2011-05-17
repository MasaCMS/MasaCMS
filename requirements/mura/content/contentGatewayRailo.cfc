<cfcomponent extends="contentGateway" output="false">

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
						  		AND  tcontent.displayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1)#"> 
						  	)
						  	
						  	or 
						  	
						  	(
						  		tcontent.displayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1)#">
						  		and tcontent.displayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime)))#"> 
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