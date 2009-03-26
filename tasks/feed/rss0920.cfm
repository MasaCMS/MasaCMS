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
<cfset tz=GetTimeZoneInfo()>
<cfif not find("-", tz.utcHourOffset)>
	<cfset utc = " -" & numberFormat(tz.utcHourOffset,"00") & "00">
<cfelse>
	<cfset tz.utcHourOffset = right(tz.utcHourOffset, len(tz.utcHourOffset) -1 )>
	<cfset utc = " +" & numberFormat(tz.utcHourOffset,"00") & "00">
</cfif>
<cfheader name="content-type" value="text/xml"><cfcontent reset="yes"><cfoutput><?xml version="1.0" ?>
<rss version="0.92"
	xmlns:dc="http://purl.org/dc/elements/1.1/">
	<channel>
		<title>#XMLFormat(feedBean.getName())#</title> 
		<link>http://#CGI.SERVER_NAME#</link> 
		<description>#XMLFormat(feedBean.getDescription())#</description> 
		<webMaster>#application.settingsManager.getSite(feedBean.getSiteID()).getContact()#</webMaster> 
		<language>#feedBean.getLang()#</language>
<cfloop query="rs"><cfsilent>
<cfif feedBean.getallowhtml() eq 0>
	<cfset itemdescription = renderer.stripHTML(rs.summary)>
<cfelse>
	<cfset itemdescription = renderer.addCompletePath(rs.summary,feedBean.getSiteID())>
</cfif>
<cfif isDate(rs.releaseDate)>
	<cfset thePubDate=dateFormat(rs.releaseDate,"yyyy-mm-dd") & "T" & timeFormat(rs.releaseDate,"HH:mm:ss") & utc>
<cfelse>
	<cfset thePubDate=dateFormat(rs.lastUpdate,"yyyy-mm-dd") & "T" & timeFormat(rs.lastUpdate,"HH:mm:ss") & utc>
</cfif>

<cfset rsCats=application.contentManager.getCategoriesByHistID(rs.contentHistID)>

<cfset theLink=xmlFormat(renderer.createHREFforRss(rs.type,rs.filename,rs.siteid,rs.contentid,rs.target,rs.targetparams,application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())) />
</cfsilent>
		<item>
			<title>#XMLFormat(rs.menutitle)#</title>
			<description><![CDATA[#itemdescription# ]]></description> 
			<link>#theLink#</link>
			<guid isPermaLink="true">#theLink#</guid>
			<dc:date>#thePubDate#</dc:date>
			<cfif rs.type eq "File"><cfset fileMeta=application.serviceFactory.getBean("fileManager").readMeta(rs.fileID)><enclosure url="#XMLFormat('http://#application.settingsManager.getSite(rs.siteID).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#rs.fileID#')#" length="#fileMeta.filesize#" type="#fileMeta.ContentType#/#fileMeta.ContentSubType#" /></cfif>
		</item></cfloop>
	</channel>
</rss></cfoutput>
