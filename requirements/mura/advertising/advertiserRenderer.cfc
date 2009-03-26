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

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.bucket=listLast(variables.instance.configBean.getFileStoreAccessInfo(),"^") />
	<cfreturn this />
</cffunction>

<cffunction name="renderCreative" access="public" output="false" returntype="String">
<cfargument name="creativeBean" type="any" default="">
<cfargument name="placementID" required="true" type="string">
<cfargument name="siteid" required="true" type="string">
<cfargument name="track" required="true" type="numeric" default="1">

<cfset var ad= ""/>
<cfset var link= ""/>
<cfset var version= ""/>

<cfif arguments.siteid neq ''>
	<cfset link="#application.configBean.getContext()#/tasks/ads/track.cfm?adUrl=#urlEncodedFormat(arguments.creativeBean.getRedirectURL())#&placementid=#arguments.placementID#&track=#arguments.track#&siteID=#arguments.siteid#" />
<cfelse>
	<cfset link=arguments.creativeBean.getRedirectURL() />
</cfif>


<cfswitch expression="#arguments.creativeBean.getMediaType()#">
<cfcase value="image">
<cfsavecontent variable="ad"><cfoutput>
<a href="#link#" title="#arguments.creativeBean.getAltText()#" target="#arguments.creativeBean.getTarget()#"><img alt="#arguments.creativeBean.getAltText()#" src="#getMediaURL(arguments.creativeBean)#" <cfif arguments.creativeBean.getHeight()>height="#arguments.creativeBean.getHeight()#"</cfif> <cfif arguments.creativeBean.getWidth()>width="#arguments.creativeBean.getWidth()#"</cfif> border="0"></a>
</cfoutput></cfsavecontent>
</cfcase>
<cfcase value="Text">
<cfset ad=arguments.creativeBean.getTextBody()>
</cfcase>
<cfdefaultcase>
<cfset version=mid(arguments.creativeBean.getMediaType(),6,1) />
<cfsavecontent variable="ad">
<script language="javascript" type="text/javascript">
		// Flash Version Detector  v1.2.1
// documentation: http://www.dithered.com/javascript/flash_detect/index.html
// license: http://creativecommons.org/licenses/by/1.0/
// code by Chris Nott (chris[at]dithered[dot]com)
// with VBScript code from Alastair Hamilton (now somewhat modified)


	function isDefined(property) {
	  return (typeof property != 'undefined');
	}
	
	var flashVersion = 0;
	function getFlashVersion() {
	   var latestFlashVersion = 12;
	   var agent = navigator.userAgent.toLowerCase(); 
		
	   // NS3 needs flashVersion to be a local variable
	   if (agent.indexOf("mozilla/3") != -1 && agent.indexOf("msie") == -1) {
	      flashVersion = 0;
	   }
	   
		// NS3+, Opera3+, IE5+ Mac (support plugin array):  check for Flash plugin in plugin array
		if (navigator.plugins != null && navigator.plugins.length > 0) {
			var flashPlugin = navigator.plugins['Shockwave Flash'];
			if (typeof flashPlugin == 'object') { 
				for (var i = latestFlashVersion; i >= 3; i--) {
	            if (flashPlugin.description.indexOf(i + '.') != -1) {
	               flashVersion = i;
	               break;
	            }
	         }
			}
		}
	
		// IE4+ Win32:  attempt to create an ActiveX object using VBScript
		else if (agent.indexOf("msie") != -1 && parseInt(navigator.appVersion) >= 4 && agent.indexOf("win")!=-1 && agent.indexOf("16bit")==-1) {
		   var doc = '<scr' + 'ipt language="VBScript"\> \n';
	      doc += 'On Error Resume Next \n';
	      doc += 'Dim obFlash \n';
	      doc += 'For i = ' + latestFlashVersion + ' To 3 Step -1 \n';
	      doc += '   Set obFlash = CreateObject("ShockwaveFlash.ShockwaveFlash." & i) \n';
	      doc += '   If IsObject(obFlash) Then \n';
	      doc += '      flashVersion = i \n';
	      doc += '      Exit For \n';
	      doc += '   End If \n';
	      doc += 'Next \n';
	      doc += '</scr' + 'ipt\> \n';
	      document.write(doc);
	   }
			
		// WebTV 2.5 supports flash 3
		else if (agent.indexOf("webtv/2.5") != -1) flashVersion = 3;
	
		// older WebTV supports flash 2
		else if (agent.indexOf("webtv") != -1) flashVersion = 2;
	
		// Can't detect in all other cases
		else {
			flashVersion = flashVersion_DONTKNOW;
		}
	
		return flashVersion;
	}
	
	flashVersion_DONTKNOW = -1;
<cfoutput>
		var requiredVersion = #version#;
		var flashVersion = getFlashVersion();

		if (flashVersion >= requiredVersion) {
			
			str="";
			str= str + '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=#version#,0,0,0" width="#arguments.creativeBean.getWidth()#" height="#arguments.creativeBean.getHeight()#">\n';
			str=str+'<param name="movie" value="#variables.instance.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#arguments.creativeBean.getFileID()#&adUrl=#urlEncodedFormat(link)#">\n';
			str=str+'<param name="quality" value="high">\n';
			str=str+'<param name="adUrl" value="#urlEncodedFormat(link)#">\n';
			str=str+'<embed src="#variables.instance.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#arguments.creativeBean.getFileID()#&adUrl=#urlEncodedFormat(link)#" quality="high" width="#arguments.creativeBean.getWidth()#" height="#arguments.creativeBean.getHeight()#" name="nav" align="" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"><'+'/embed>\n';
			str=str+'<'+'/object>';
			document.write(str);
		
		 }
		else {
			document.write('<a href="#link#" title="#arguments.creativeBean.getAltText()#" target="_blank">#arguments.creativeBean.getAltText()#<'+'/a>\n');
		} 
		
		</script>
<!--- 		<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=#version#,0,0,0" width="#arguments.creativeBean.getWidth()#" height="#arguments.creativeBean.getHeight()#">
		<param name="movie" value="/tasks/ads/creatives/#arguments.creativeBean.getMedia()#?adUrl=#urlEncodedFormat(link)#">
		<param name="quality" value="high">
		<param name="adUrl" value="#urlEncodedFormat(link)#">
		<embed src="/tasks/ads/creatives/#arguments.creativeBean.getMedia()#?adUrl=#urlEncodedFormat(link)#" quality="high" width="#arguments.creativeBean.getWidth()#" height="#arguments.creativeBean.getHeight()#" name="nav" align="" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>
		</object> --->
</cfoutput></cfsavecontent>
</cfdefaultcase>
</cfswitch>

<cfreturn trim(ad)/>
</cffunction>

<cffunction name="getMediaURL" output="false" returntype="string">
<cfargument name="creativeBean" required="true" type="any" >

<cfswitch expression="#variables.instance.configBean.getFileStore()#">
	<cfcase value="S3">
		<cfreturn "http://s3.amazonaws.com/#variables.instance.bucket#/#arguments.creativeBean.getSiteID()#/#arguments.creativeBean.getFileID()#.#arguments.creativeBean.getFileExt()#">
	</cfcase>
	<cfcase value="database">
		<cfreturn "#variables.instance.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#arguments.creativeBean.getFileID()#" />
	</cfcase>
	<cfcase value="fileDir">
		<cfreturn "#variables.instance.configBean.getAssetPath()#/#arguments.creativeBean.getSiteID()#/cache/file/#arguments.creativeBean.getFileID()#.#arguments.creativeBean.getFileExt()#" />
	</cfcase>
</cfswitch>
</cffunction>


</cfcomponent>