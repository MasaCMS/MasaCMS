<cfset $.getContentRenderer().setRenderHTMLHead(false)/>
<!--- <cfheader name="Expires" value="#GetHttpTimeString(Now'))#">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate"> --->
<!--- This file is an example of alternate outputs --->
<cfcontent reset="true" type="text/xml; charset=UTF-8">
<cfset r=$.event('r')>
<cfif $.event('isOnDisplay') and ((not r.restrict) or (r.restrict and r.allow))><cfoutput><?xml version="1.0" ?>
<content>
<title>#xmlFormat($.content('Title'))#</title>
<menutitle>#xmlFormat($.content('MenuTitle'))#</menutitle>
<type>#xmlFormat($.content('Type'))#</type>
<subtype>#xmlFormat($.content('SubType'))#</subtype>
<display>#xmlFormat($.content('Display'))#</display>
<displaystart>#xmlFormat($.content('DisplayStart'))#</displaystart>
<displaystop>#xmlFormat($.content('DisplayStop'))#</displaystop>
<filename>#xmlFormat($.content('Filename'))#</filename>
<credits>#xmlFormat($.content('Credits'))#</credits>
<siteid>#xmlFormat($.content('SiteID'))#</siteid>
<contentid>#xmlFormat($.content('ContentId'))#</contentid>
<contenthistid>#xmlFormat($.content('ContentHistId'))#</contenthistid>
<parentid>#xmlFormat($.content('ParentId'))#</parentid>
<lastupdate>#xmlFormat($.content('LastUpdate'))#</lastupdate>
<lastupdateby>#xmlFormat($.content('LastUpdateBy'))#</lastupdateby>
<lastupdatebyid>#xmlFormat($.content('LastUpdateById'))#</lastupdatebyid>
<tags>#xmlFormat($.content('Tags'))#</tags>
<releasedate>#xmlFormat($.content('ReleaseDate'))#</releasedate>
<fileid>#xmlFormat($.content('FileId'))#</fileid>
<fileext>#xmlFormat($.content('FileExt'))#</fileext>
<contenttype>#xmlFormat($.content('ContentType'))#</contenttype>
<contentsubtype>#xmlFormat($.content('contentsubtype'))#</contentsubtype>
<filesize>#xmlFormat($.content('FileSize'))#</filesize>
<metadesc><![CDATA[#$.content('MetaDesc')#]]></metadesc>
<metakeywords><![CDATA[#$.content('MetaKeyWords')#]]></metakeywords>
<summary><![CDATA[#$.content('Summary')#]]></summary>
<body><![CDATA[#$.dspBody($.content('Body'),'',0,'',0)#]]></body>
</content></cfoutput>
<cfelse><cfoutput><?xml version="1.0" ?>
<content>
<title>Restricted Content</title>
<menutitle>Restricted Content</menutitle>
<type>#xmlFormat($.content('Type'))#</type>
<subtype>#xmlFormat($.content('SubType'))#</subtype>
<display>#xmlFormat($.content('Display'))#</display>
<displaystart>#xmlFormat($.content('DisplayStart'))#</displaystart>
<displaystop>#xmlFormat($.content('DisplayStop'))#</displaystop>
<filename>#xmlFormat($.content('Filename'))#</filename>
<credits></credits>
<siteid>#xmlFormat($.content('SiteID'))#</siteid>
<contentid>#xmlFormat($.content('ContentId'))#</contentid>
<contenthistid>#xmlFormat($.content('ContentHistId'))#</contenthistid>
<parentid>#xmlFormat($.content('ParentId'))#</parentid>
<lastupdate>#xmlFormat($.content('LastUpdate'))#</lastupdate>
<lastupdateby>#xmlFormat($.content('LastUpdateBy'))#</lastupdateby>
<lastupdatebyid>#xmlFormat($.content('LastUpdateById'))#</lastupdatebyid>
<tags></tags>
<releasedate>#xmlFormat($.content('ReleaseDate'))#</releasedate>
<fileid></fileid>
<fileext></fileext>
<contenttype>#xmlFormat($.content('ContentType'))#</contenttype>
<contentsubtype>#xmlFormat($.content('contentsubtype'))#</contentsubtype>
<filesize></filesize>
<metadesc></metadesc>
<metakeywords></metakeywords>
<summary>Restricted Content</summary>
<body>Restricted Content</body>
</content></cfoutput>
</cfif>
