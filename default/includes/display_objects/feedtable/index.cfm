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
<cfset rbFactory=getSite().getRBFactory() />
<cfset rs=application.feedManager.getFeeds(request.siteID,'Local',true,true)/>
<cfset port=application.configBean.getServerPort() />
<table name="svRssFeedsList" id="svRssFeedsList">
	<thead>
		<tr>
			<cfoutput><th colspan="5">#rbFactory.getKey('feedtable.rssfeeds')#</th></cfoutput>
		</tr>
	</thead>
	<tbody>
		<cfif rs.recordcount>
		<cfoutput query="rs">
		<tr>
			<td>#rs.name#</td>
			<td><a href="http://#cgi.server_name##port#/tasks/feed/?feedID=#rs.feedID#"><img alt="" src="#application.configBean.getContext()#/#request.siteid#/includes/display_objects/feedtable/images/feed-icon-12x12.gif" /></a></td>
			<td><a href="http://add.my.yahoo.com/rss?url=#URLEncodedFormat('http://#cgi.server_name##port##application.configBean.getContext()#/tasks/feed/?feedID=#rs.feedID#')#"><img alt="" src="#application.configBean.getContext()#/#request.siteid#/includes/display_objects/feedtable/images/add_myyahoo.gif" /></a></td>
			<td><a href="http://fusion.google.com/add?feedurl=#URLEncodedFormat('http://#cgi.server_name##port##application.configBean.getContext()#/tasks/feed/?feedID=#rs.feedID#')#"><img alt="" src="#application.configBean.getContext()#/#request.siteid#/includes/display_objects/feedtable/images/add_google.gif" /></a></td>
			<td><a href="http://feeds.my.aol.com/add.jsp?url=#URLEncodedFormat('http://#cgi.server_name##port##application.configBean.getContext()#/tasks/feed/?feedID=#rs.feedID#')#"><img alt="" src="#application.configBean.getContext()#/#request.siteid#/includes/display_objects/feedtable/images/add_myaol.gif" /></a></td>
		</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<cfoutput><td colspan="4">#rbFactory.getKey('feedtable.nofeeds')#</td></cfoutput>
		</tr>
		</cfif>
	</tbody>
</table>