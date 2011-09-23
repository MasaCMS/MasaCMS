<cfset renderer.setRenderHTMLHead(false)/>
<!--- <cfheader name="Expires" value="#GetHttpTimeString(Now())#">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate"> --->
<!--- This file is an example of alternate outputs --->
<cfcontent reset="true" type="text/xml; charset=UTF-8">
<cfif request.isOnDisplay and ((not request.r.restrict) or (request.r.restrict and request.r.allow))><cfoutput><?xml version="1.0" ?>
<content>
<title>#xmlFormat(request.contentBean.getTitle())#</title>
<menutitle>#xmlFormat(request.contentBean.getMenuTitle())#</menutitle>
<type>#xmlFormat(request.contentBean.getType())#</type>
<subtype>#xmlFormat(request.contentBean.getSubType())#</subtype>
<display>#xmlFormat(request.contentBean.getDisplay())#</display>
<displaystart>#xmlFormat(request.contentBean.getDisplayStart())#</displaystart>
<displaystop>#xmlFormat(request.contentBean.getDisplayStop())#</displaystop>
<filename>#xmlFormat(request.contentBean.getFilename())#</filename>
<credits>#xmlFormat(request.contentBean.getCredits())#</credits>
<siteid>#xmlFormat(request.contentBean.getSiteID())#</siteid>
<contentid>#xmlFormat(request.contentBean.getContentId())#</contentid>
<contenthistid>#xmlFormat(request.contentBean.getContentHistId())#</contenthistid>
<parentid>#xmlFormat(request.contentBean.getParentId())#</parentid>
<lastupdate>#xmlFormat(request.contentBean.getLastUpdate())#</lastupdate>
<lastupdateby>#xmlFormat(request.contentBean.getLastUpdateBy())#</lastupdateby>
<lastupdatebyid>#xmlFormat(request.contentBean.getLastUpdateById())#</lastupdatebyid>
<tags>#xmlFormat(request.contentBean.getTags())#</tags>
<releasedate>#xmlFormat(request.contentBean.getReleaseDate())#</releasedate>
<fileid>#xmlFormat(request.contentBean.getFileId())#</fileid>
<fileext>#xmlFormat(request.contentBean.getFileExt())#</fileext>
<contenttype>#xmlFormat(request.contentBean.getContentType())#</contenttype>
<contentsubtype>#xmlFormat(request.contentBean.getcontentsubtype())#</contentsubtype>
<filesize>#xmlFormat(request.contentBean.getFileSize())#</filesize>
<metadesc><![CDATA[#request.contentBean.getMetaDesc()#]]></metadesc>
<metakeywords><![CDATA[#request.contentBean.getMetaKeyWords()#]]></metakeywords>
<summary><![CDATA[#request.contentBean.getSummary()#]]></summary>
<body><![CDATA[#renderer.dspBody(request.contentBean.getBody(),'',0,'',0)#]]></body>
</content></cfoutput>
<cfelse><cfoutput><?xml version="1.0" ?>
<content>
<title>Restricted Content</title>
<menutitle>Restricted Content</menutitle>
<type>#xmlFormat(request.contentBean.getType())#</type>
<subtype>#xmlFormat(request.contentBean.getSubType())#</subtype>
<display>#xmlFormat(request.contentBean.getDisplay())#</display>
<displaystart>#xmlFormat(request.contentBean.getDisplayStart())#</displaystart>
<displaystop>#xmlFormat(request.contentBean.getDisplayStop())#</displaystop>
<filename>#xmlFormat(request.contentBean.getFilename())#</filename>
<credits></credits>
<siteid>#xmlFormat(request.contentBean.getSiteID())#</siteid>
<contentid>#xmlFormat(request.contentBean.getContentId())#</contentid>
<contenthistid>#xmlFormat(request.contentBean.getContentHistId())#</contenthistid>
<parentid>#xmlFormat(request.contentBean.getParentId())#</parentid>
<lastupdate>#xmlFormat(request.contentBean.getLastUpdate())#</lastupdate>
<lastupdateby>#xmlFormat(request.contentBean.getLastUpdateBy())#</lastupdateby>
<lastupdatebyid>#xmlFormat(request.contentBean.getLastUpdateById())#</lastupdatebyid>
<tags></tags>
<releasedate>#xmlFormat(request.contentBean.getReleaseDate())#</releasedate>
<fileid></fileid>
<fileext></fileext>
<contenttype>#xmlFormat(request.contentBean.getContentType())#</contenttype>
<contentsubtype>#xmlFormat(request.contentBean.getcontentsubtype())#</contentsubtype>
<filesize></filesize>
<metadesc></metadesc>
<metakeywords></metakeywords>
<summary>Restricted Content</summary>
<body>Restricted Content</body>
</content></cfoutput>
</cfif>
