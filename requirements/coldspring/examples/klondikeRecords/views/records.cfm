<!--- 
	  
  Copyright (c) 2005, Chris Scott, David Ross
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

  $Id: records.cfm,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: records.cfm,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


--->

<cfsilent>
	<cfset genres = event.getArg('genres') />
	<cfset artists = event.getArg('artists') />
	<cfset records = event.getArg('records') />
</cfsilent>

	<h1>Welcome to Klondike Records!!</h1>
	<p>
	Here's today's top records!
	</p>
	
	<!-- main data -->
	<table cellspacing="12">
	<cfoutput>
	
	<cfset numRecords = ArrayLen(records)>
	<cfif numRecords>
	
		<tr>
		
		<cfset rowOpen = true />
		<cfloop from="1" to="#numRecords#" index="ix">
			<cfset record = records[ix] />
			
			<td valign="top"><img src="views/img/covers/#record.getImage()#"></td>
			<td valign="top">
			<strong>#record.getTitle()#<a href="index.cfm?event=showDetail&rdID=#record.getRecordID()#"></a></strong><br>
			<a href="index.cfm?event=showRecords&arID=#record.getArtistID()#">#artists.data[record.getArtistID()]#</a><br>
			<a href="index.cfm?event=showRecords&gnID=#record.getGenreID()#">#genres.data[record.getGenreID()]#</a><br>
			Released #record.getReleaseDate()#<br>
			#DollarFormat(record.getPrice())#<br>
			<span class="links">
			details<a href="index.cfm?event=showDetail&rdID=#record.getRecordID()#"></a> | 
			<a href="index.cfm?event=editRecord&rdID=#record.getRecordID()#">edit</a>
			</span>
			</td>
		
		<cfif not(ix mod 2)>
			</tr>
			<cfset rowOpen = false />
			
			<cfif ix LT numRecords>
			<tr>
			<cfset rowOpen = true />
			</cfif>
		</cfif>

		</cfloop>
		
		<cfif rowOpen>
		</tr>
		</cfif>
		
	<cfelse>
	
		<tr>
			<td>There are no Records to tell you about!.</td>
		</tr>
		
	</cfif>
	
	</cfoutput>	
	</table>
	<!-- end main data -->
