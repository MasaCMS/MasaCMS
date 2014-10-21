<cfcomponent output="false" displayname="CKFinder" hint="Create an instance of the CKFinder.">
<!---
 * CKFinder
 * ========
 * http://cksource.com/ckfinder
 * Copyright (C) 2007-2014, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfset this.defaultPath = "/ckfinder/">
<cfset Init()>

<cffunction
	name="Init"
>
	<cfparam name="this.basePath" type="string" default="#this.defaultPath#"/>
	<cfparam name="this.width" type="string" default="100%" />
	<cfparam name="this.height" type="string" default="400" />
	<cfparam name="this.selectFunction" type="string" default="" />
	<cfparam name="this.selectFunctionData" type="string" default="" />
	<cfparam name="this.selectThumbnailFunction" type="string" default="" />
	<cfparam name="this.selectThumbnailFunctionData" type="string" default="" />
	<cfparam name="this.disableThumbnailSelection" type="boolean" default="false">
	<cfparam name="this.id" type="string" default="" />
	<cfparam name="this.resourceType" type="string" default="" />
	<cfparam name="this.startupPath" type="string" default="" />
	<cfparam name="this.startupFolderExpanded" type="boolean" default="false" />
	<cfparam name="this.rememberLastFolder" type="boolean" default="true" />
	<cfparam name="this.className" type="string" default="" />
</cffunction>

<cffunction
	name="Create"
	access="public"
	output="true"
	returntype="void"
	hint="Renders CKFinder in the current page"
>
	<cfoutput>#CreateHtml()#</cfoutput>
</cffunction>

<cffunction
	name="CreateHtml"
	access="public"
	output="false"
	returntype="string"
	hint="Gets the HTML needed to create a CKFinder instance"
>
	<cfset var id = "" >
	<cfset var class= "" >

	<cfif len( this.className ) gt 0>
		<cfset class = " class=""" & this.className & """">
	</cfif>
	<cfif len( this.id ) gt 0>
		<cfset id = " id=""" & this.id & """">
	</cfif>

	<cfreturn "<iframe src=""" & _BuildUrl() & """ width=""" & this.width & """ " & "height="""
		& this.height & """" & class & id & """ frameborder=""0"" scrolling=""no""></iframe>">

</cffunction>

<cffunction
	name="_BuildUrl"
	access="private"
	output="false"
	returnType="string"
	hint="Build URL to CKFinder"
>
	<cfset var qs = "">
	<cfset var url = this.basePath>

	<cfparam name="_url" type="string" default="" />

	<cfif Len(_url)>
		<cfset url = _url >
	<cfelseif not Len(url)>
		<cfset url = this.defaultPath >
	</cfif>

	<cfif Right(url, 1) neq "/">
		<cfset url = url & "/" >
	</cfif>
	<cfset url = url & "ckfinder.html">
	<cfif Len(this.selectFunction)>
		<cfset qs = qs & '?action=js&amp;func=' & this.selectFunction>
	</cfif>

	<cfif Len(this.selectFunctionData)>
		<cfset qs = qs & iif(Len(qs), De("&amp;"), De("?"))>
		<cfset qs = qs & 'data=' & urlencodedformat(this.selectFunctionData)>
	</cfif>

	<cfif not this.disableThumbnailSelection>
		<cfif Len(this.selectThumbnailFunction) or Len(this.selectFunction)>
			<cfset qs = qs & iif(Len(qs), De("&amp;"), De("?"))>
			<cfset qs = qs & 'thumbFunc=' & IIF(Len(this.selectThumbnailFunction), De(this.selectThumbnailFunction), De(this.selectFunction))>
			<cfif Len(this.selectThumbnailFunctionData)>
				<cfset qs = qs & '&amp;tdata=' & urlencodedformat(this.selectThumbnailFunctionData)>
			<cfelseif not Len(this.selectThumbnailFunction) and Len(this.selectFunctionData)>
				<cfset qs = qs & '&amp;tdata=' & urlencodedformat(this.selectFunctionData)>
			</cfif>
		</cfif>
	<cfelse>
		<cfset qs = qs & iif(Len(qs), De("&amp;"), De("?"))>
		<cfset qs = qs & 'dts=0'>
	</cfif>
	<cfif Len(this.startupPath)>
		<cfset qs = qs & iif(Len(qs), De("&amp;"), De("?"))>
		<cfset qs = qs & 'start=' & urlencodedformat(this.startupPath) & iif(this.startupFolderExpanded, De(":1"), De(":0"))>
	</cfif>
	<cfif Len(this.resourceType)>
		<cfset qs = qs & iif(Len(qs), De("&amp;"), De("?"))>
		<cfset qs = qs & 'type=' & urlencodedformat(this.resourceType)>
	</cfif>
	<cfif not this.rememberLastFolder>
		<cfset qs = qs & iif(Len(qs), De("&amp;"), De("?"))>
		<cfset qs = qs & 'rlf=0'>
	</cfif>
	<cfif Len(this.id)>
		<cfset qs = qs & iif(Len(qs), De("&amp;"), De("?"))>
		<cfset qs = qs & 'id=' & urlencodedformat(this.id)>
	</cfif>
	<cfreturn url & qs>
</cffunction>

<cffunction
	name="SetupFCKeditor"
	access="public"
	output="false"
	returnType="void"
	hint="Setup FCKeditor"
>
	<cfset var url = "" >
	<cfset var dir = "" >
	<cfset var qs = "" >
	<cfset var _width = 0 >
	<cfset var _height = 0 >

	<cfparam name="this.editorObj" />
	<cfparam name="this.imageType" type="string" default="" />
	<cfparam name="this.flashType" type="string" default="" />

	<cfif not Len(this.basePath)>
		<cfset this.basePath = this.defaultPath>
	</cfif>
	<cfif Left(this.basePath, 1) neq "/" and not find("://", this.basePath)>
		<cfset this.basePath = mid(CGI.SCRIPT_NAME, 1, Len(CGI.SCRIPT_NAME) - Find("/", Reverse(CGI.SCRIPT_NAME))) & this.basePath>
	</cfif>

	<cfset url = _BuildUrl(this.basePath)>
	<cfset qs = iif(find("?", url), De("&"), De("?"))>
	<cfset url = replace(url, "&", "%26", "all")>
	<cfset url = replace(url, "=", "%3D", "all")>
	<cfset url = replace(url, """", "%22", "all")>
	<cfset _width = replacenocase(this.width, "px", "", "all")>
	<cfif _width neq "100%" and lsisnumeric(_width)>
		<cfset _width = lsparsenumber(_width)>
		<cfif _width gt 0>
			<!--- we have to set width and height with "px" at the end, otherwise it will be converted to boolean --->
			<cfset this.editorObj.config['LinkBrowserWindowWidth'] = tostring(_width & "px")>
			<cfset this.editorObj.config['ImageBrowserWindowWidth'] = tostring(_width & "px")>
			<cfset this.editorObj.config['FlashBrowserWindowWidth'] = tostring(_width & "px")>
		</cfif>
	</cfif>
	<cfset _height = replacenocase(this.height, "px", "", "all")>
	<cfif _height neq "400" and lsisnumeric(_height)>
		<cfset _height = lsparsenumber(_height)>
		<cfif _height gt 0>
			<cfset this.editorObj.config['LinkBrowserWindowHeight'] = tostring(_height & "px")>
			<cfset this.editorObj.config['ImageBrowserWindowHeight'] = tostring(_height & "px")>
			<cfset this.editorObj.config['FlashBrowserWindowHeight'] = tostring(_height & "px")>
		</cfif>
	</cfif>
	<cfset this.editorObj.config['LinkBrowserURL'] = url>
	<cfset this.editorObj.config['ImageBrowserURL'] = url & urlencodedformat(qs & 'type=' & iif( Len( this.imageType ), this.imageType, De('Images')))>
	<cfset this.editorObj.config['FlashBrowserURL'] = url & urlencodedformat(qs & 'type=' & iif( Len( this.flashType ), this.flashType, De('Flash')))>
	<cfset dir = GetDirectoryFromPath(url) >
	<cfset this.editorObj.config['LinkUploadURL'] = urlencodedformat(dir & 'core/connector/cfm/connector.cfm?command=QuickUpload&type=Files')>
	<cfset this.editorObj.config['ImageUploadURL'] = urlencodedformat(dir & 'core/connector/cfm/connector.cfm?command=QuickUpload&type=' & iif( Len( this.imageType ), this.imageType, De('Images')))>
	<cfset this.editorObj.config['FlashUploadURL'] = urlencodedformat(dir & 'core/connector/cfm/connector.cfm?command=QuickUpload&type=' & iif( Len( this.flashType ), this.flashType, De('Flash')))>
</cffunction>

</cfcomponent>
