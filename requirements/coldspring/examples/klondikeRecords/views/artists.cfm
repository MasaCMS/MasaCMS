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

  $Id: artists.cfm,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: artists.cfm,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


--->

<cfsilent>
	<cfset artists = event.getArg('artists') />
	<cfset rowcolors = structNew() />
	<cfset rowcolors[0] = "even" />
	<cfset rowcolors[1] = "odd" />
</cfsilent>

<!-- genre data -->
<table class="stripes" cellspacing="0">
	<tr>
		<td><span class="header">Artists</span></td>
	</tr>
</table>

<div class="scrollBox">
<table class="stripes2" cellspacing="0">
<cfoutput>

	<cfloop from="1" to="#ArrayLen(artists.order)#" index="ix">
	<tr class="#rowcolors[(ix mod 2)]#">
		<td><a href="index.cfm?event=showRecords&arID=#artists.order[ix]#">#artists.data[artists.order[ix]]#</a></td>
	</tr>
	</cfloop>

</cfoutput>	
</table>
</div>
<!-- end main data -->

<p class="add">
	<a href="index.cfm?event=addRecord">Add Record</a>
</p>