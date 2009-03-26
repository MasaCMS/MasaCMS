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
		
			
 $Id: dspCategory.cfm,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->


<cfset Category = event.getArg('category')/>
<cfoutput>
<form action="index.cfm?event=c.SaveCategory" method="post">
<table id="catSingleTable" cellpadding="3" cellspacing="0" align="center">
<cfif Category.hasId()>
	<input type="hidden" name="id" value="#Category.getId()#"/>
</cfif>

<tr><td class="catTitle">Category:</td><td colspan="2">&nbsp;</td></tr>
<tr><td>Name:</td><td><input type="text" name="name" value="#Category.getName()#" size="55"/></td>

<td width="200" rowspan="3" class="CategoryChannelHeader">	
<cfif event.isArgDefined('categorychannels')>
	<cfset CategoryChannels = event.getArg('categorychannels')/>
	Channels:<br />
	<ul>
		<cfloop query="CategoryChannels">
			<li <cfif currentrow mod 2>class="hl"</cfif>><a href="index.cfm?event=c.showChannel&amp;channelID=#id#">#title#</a></li>
		</cfloop>
	</ul> 
</cfif>
</td>
</tr>
<tr><td>Description:</td><td><input type="text" name="description" value="#Category.getDescription()#" size="55"/></td></tr>
<tr><td colspan="2" align="center" valign="top">
	<input type="submit" value="<cfif Category.hasId()>save<cfelse>create</cfif>" class="subbtn"/>&nbsp;&nbsp;
	<input type="button" onclick="javascript: self.location.href='index.cfm'" value="cancel" class="subbtn"/>&nbsp;&nbsp;  
	<cfif Category.hasId()><input type="button" onclick="javascript: if(confirm('Click OK if you are sure you want to remove this category'))self.location.href='index.cfm?event=c.removeCategory&amp;categoryID=#category.getId()#'" value="remove" class="rembtn"/></cfif></td></tr>
</table>
</form>
</cfoutput>