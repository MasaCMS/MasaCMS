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
<cfset addToHTMLHeadQueue("swfobject.cfm") />
<cfset r="#replace('#rand()#','.','')#"/>
<cfswitch expression="#getJSLib()#">
<cfcase value="jquery">
<cfset addToHTMLHeadQueue("jquery.cfm") />
<cfoutput>
<div id="svAd#r#" class="svAd"></div>
<script type="text/javascript">
function renderAdZone#r#(){			
$.getJSON("#application.configBean.getContext()#/tasks/ads/renderAdZone.cfm", 
		{AdZoneID: "#arguments.objectid#", siteID: "#request.siteid#",track:"#request.track#",cacheid:Math.random()},
		function(r){
		if(r.mediatype.indexOf('lash') > -1){
				var so = new SWFObject(r.mediaurl, "svAd#r#swf", r.width, r.height, r.version);
			    so.addVariable("adUrl", "#application.configBean.getContext()#/tasks/ads/track.cfm?adUrl=" + escape(r.redirecturl) + "&placementid=" + r.placementid + "track=#request.track#&siteID=#request.siteid#");
			    so.addParam("wmode", "transparent");
			    so.write("svAd#r#");
			} else {
				$("##svAd#r#").html(r.creative);
			}
		}			
	);
}
new renderAdZone#r#();
</script>
</cfoutput>
</cfcase>
<cfdefaultcase>
<cfset addToHTMLHeadQueue("prototype.cfm") />
<cfoutput>
<div id="svAd#r#" class="svAd"></div>
<script type="text/javascript">
function renderAdZone#r#(){
new Ajax.Request( '#application.configBean.getContext()#/tasks/ads/renderAdZone.cfm',
	{method: 'get',
	parameters: 'AdZoneID=#arguments.objectid#&siteid=#request.siteid#&track=#request.track#&cacheid=' + Math.random(),
	onSuccess: function(transport){
			var r=eval("(" + transport.responseText + ")");
			if(r.mediatype.indexOf('lash') > -1){
				var so = new SWFObject(r.mediaurl, "svAd#r#swf", r.width, r.height, r.version);
			    so.addVariable("adUrl", "#application.configBean.getContext()#/tasks/ads/track.cfm?adUrl=" + escape(r.redirecturl) + "&placementid=" + r.placementid + "track=#request.track#&siteID=#request.siteid#");
			    so.addParam("wmode", "transparent");
			    so.write("svAd#r#");
			} else {
				$("svAd#r#").innerHTML=r.creative;
			}
		}
	}); 
}
new renderAdZone#r#();
</script>
</cfoutput>
</cfdefaultcase>
</cfswitch>