<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfset rbFactory=application.settingsManager.getSite(request.siteid).getRBFactory()/>
<cfparam name="attributes.tags" default="">
<cfset tagLen=listLen(attributes.tags) />
<cfif len(tagLen)><cfoutput>#rbFactory.getKey('tagcloud.tags')#: <cfloop from="1" to="#tagLen#" index="t"><cfset tag=#trim(listgetAt(attributes.tags,t))#><a href="?tag=#urlEncodedFormat(tag)#&newSearch=1&display=search">#tag#</a><cfif tagLen gt t>, </cfif></cfloop></cfoutput></cfif>