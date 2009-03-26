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

  $Id: genres.cfm,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: genres.cfm,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


--->

<cfsilent>
	<cfset genres = event.getArg('genres') />
	<cfset rowcolors = structNew() />
	<cfset rowcolors[0] = "even" />
	<cfset rowcolors[1] = "odd" />
</cfsilent>

<!-- genre data -->
<table class="stripes" cellspacing="0">
	<tr>
		<td><span class="header">Genres</span></td>
	</tr>
</table>

<table class="stripes" cellspacing="0">
<cfoutput>

	<cfloop from="1" to="#ArrayLen(genres.order)#" index="ix">
	<tr class="#rowcolors[(ix mod 2)]#">
		<td><a href="index.cfm?event=showRecords&gnID=#genres.order[ix]#">#genres.data[genres.order[ix]]#</a></td>
	</tr>
	</cfloop>

</cfoutput>	
</table>
<!-- end main data -->

<br />