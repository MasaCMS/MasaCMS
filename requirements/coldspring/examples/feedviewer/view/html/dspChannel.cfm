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
		
			
 $Id: dspChannel.cfm,v 1.4 2007/06/18 12:01:26 rossd Exp $

--->


<cfset channel = event.getArg('channel')/>
<cfset categories = event.getArg('categories')/>

<cfoutput>
<form action="index.cfm?event=c.saveChannel" method="post">
<table id="catSingleTable" cellpadding="3" cellspacing="0" align="center">
<cfif channel.hasId()>
	<input type="hidden" name="id" value="#channel.getId()#"/>
</cfif>
<tr><td valign="top">
<table>


<tr><td class="catTitle">Channel:</td><td colspan="2">&nbsp;</td></tr>
<tr><td>Title:</td><td><input type="text" name="title" value="#channel.getTitle()#" size="60"/></td>
<tr><td>RSS/Atom Url:</td><td><input type="text" name="url" value="#channel.getUrl()#" size="60"/></td>
<tr><td>Description:</td><td><input type="text" name="description" value="#channel.getDescription()#" size="60"/></td></tr>
<tr><td>Category(s):</td><td><select name="categoryIDs" multiple size="4">
								<cfloop query="categories">
								<option value="#id#" <cfif listFind(channel.getCategoryIds(),id)>selected</cfif>>#name#</option>
								</cfloop>
							</select></td></tr>
<tr>
	<td colspan="2" align="center" valign="top" nowrap>
		<input type="submit" value="<cfif channel.hasId()>save<cfelse>create</cfif>" class="subbtn"/>&nbsp;&nbsp;
		<input type="button" onclick="javascript: self.location.href='index.cfm'" value="cancel" class="subbtn"/>&nbsp;&nbsp;  
		<cfif channel.hasId()>
			<input type="button" onclick="javascript: self.location.href='index.cfm?event=c.refreshChannelEntries&amp;channelID=#channel.getId()#'" value="refresh entries" class="subbtn"/>
			&nbsp;&nbsp;<input type="button" onclick="javascript: if(confirm('Click OK if you are sure you want to remove this channel'))self.location.href='index.cfm?event=c.removechannel&amp;channelID=#channel.getId()#'" value="remove" class="rembtn"/>
		</cfif>
	</td>
</tr>

</table>
</td>
<td valign="top" class="CategoryChannelHeader">	
<cfif event.isArgDefined('channelentries')>
	<cfset channelEntries = event.getArg('channelentries')/>
	Recent Entries:<br />
	<ul>
		<cfloop query="channelEntries">
			<li <cfif currentrow mod 2>class="hl"</cfif>><a href="#channelEntries.url#" target="_blank">#channelEntries.title#</a></li>
		</cfloop>
	</ul> 
</cfif>
</td>
</tr>
</table>
</form>
</cfoutput>