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

  $Id: recordForm.cfm,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: recordForm.cfm,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


--->

<cfsilent>
	<cfset submitEvent = event.getArg('submitEvent','') />
	<cfset cancelEvent = event.getArg('cancelEvent','') />
	<cfset label = event.getArg('submitLabel','') />
	
	<cfset record = event.getArg('record') />
	<cfset artists = event.getArg('artists') />
	<cfset genres = event.getArg('genres') />
	
	<cfset message = event.getArg('message','') />
	<cfset missingFields = event.getArg('missingFields','') />
	
	<!--- debuggin
	<cfset sf = getProperty( 'serviceFactory' ) />
	<cfset cachingService = sf.getBean('cachingService') /> --->
</cfsilent>

<cfoutput>
	<h1><span class="head">Klondike Records</span><br />
	#label# Record</h1>
	
	<cfif len(message)>
	<p class="alert">Please provide all required information.</p>
	</cfif>
	
	<form action="index.cfm?event=#submitEvent#" method="post">
	<input type="hidden" name="RecordID" value="#record.getRecordID()#" />
	<table class="stripes" cellspacing="0">
	
		<tr>
			<td colspan="2">
			<span class="header">#label# Record</span>
			</td>
		</tr>
		
		<tr class="odd">
			<td class="label-l">
			<cfif ListFindNoCase(missingFields, 'Title')>
				<span class="alert">*Title:</span>
			<cfelse>
				*Title:
			</cfif>
			</td>
			<td class="input-r">
			<input type="text" name="Title" size="45" maxlength="255" value="#record.getTitle()#" />
			</td>
		</tr>
		
		<tr class="odd">
			<td class="label-l">
			<cfif ListFindNoCase(missingFields, 'ArtistID')>
				<span class="alert">*Artist:</span>
			<cfelse>
				*Artist:
			</cfif>
			</td>
			<cfset currArtistID = record.getArtistID() />
			<td class="input-r">
				<select size="1" name="ArtistID">
					<option value="0" selected>- Select -</option>
					<cfloop from="1" to="#ArrayLen(artists.order)#" index="ix">
						<option value="#artists.order[ix]#" <cfif currArtistID EQ artists.order[ix]>selected</cfif>>#artists.data[artists.order[ix]]#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		
		<tr class="odd">
			<td class="label-l">
			<cfif ListFindNoCase(missingFields, 'GenreID')>
				<span class="alert">*GenreID:</span>
			<cfelse>
				*GenreID:
			</cfif>
			</td>
			<cfset currGenreID = record.getGenreID() />
			<td class="input-r">
				<select size="1" name="GenreID">
					<option value="0" selected>- Select -</option>
					<cfloop from="1" to="#ArrayLen(genres.order)#" index="ix">
						<option value="#genres.order[ix]#" <cfif currGenreID EQ genres.order[ix]>selected</cfif>>#genres.data[genres.order[ix]]#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		
		<tr class="odd">
			<td class="label-l">
			<cfif ListFindNoCase(missingFields, 'Image')>
				<span class="alert">*Image Name:</span>
			<cfelse>
				*Image Name:
			</cfif>
			</td>
			<td class="input-r">
			<input type="text" name="Image" size="18" maxlength="35" value="#record.getImage()#" />
			</td>
		</tr>
		
		<tr class="odd">
			<td class="label-l">
			<cfif ListFindNoCase(missingFields, 'ReleaseDate')>
				<span class="alert">*Release Date:</span>
			<cfelse>
				*Release Date:
			</cfif>
			</td>
			<td class="input-r">
			<input type="text" name="ReleaseDate" size="8" maxlength="4" value="#record.getReleaseDate()#" />
			</td>
		</tr>
		
		<tr class="odd">
			<td class="label-l">
			<cfif ListFindNoCase(missingFields, 'Price')>
				<span class="alert">*Price:</span>
			<cfelse>
				*Price:
			</cfif>
			</td>
			<td class="input-r">
			<input type="text" name="Price" size="8" maxlength="5" value="#record.getPrice()#" />
			</td>
		</tr>
		
		<tr class="odd">
			<td class="label-l">
			Featured
			</td>
			<td class="input-r">
			<input type="checkbox" name="Featured" value="1" <cfif record.isFeatured()>checked="true"</cfif> />
			</td>
		</tr>
		
		<tr>
			<td class="label-l">
			<input type="button" value="Cancel"  onclick="javascript:document.location.href='index.cfm?event=#cancelEvent#'" />
			</td>
			<td class="input-r">
			<input type="submit" value="#label# Record" />
			</td>
		</tr>
		
	</table>
	
</cfoutput>

<!--- <cfdump var="#cachingService.getCache()#" /> --->