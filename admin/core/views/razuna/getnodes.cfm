<cfsilent>
<!---
 *
 * Copyright (C) 2005-2008 Razuna Ltd.
 *
 * This file is part of Razuna - Enterprise Digital Asset Management.
 *
 * Razuna is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Razuna is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero Public License for more details.
 *
 * You should have received a copy of the GNU Affero Public License
 * along with Razuna. If not, see <http://www.gnu.org/licenses/>.
 *
 * You may restribute this Program with a special exception to the terms
 * and conditions of version 3.0 of the AGPL as described in Razuna's
 * FLOSS exception. You should have received a copy of the FLOSS exception
 * along with Razuna. If not, see <http://www.razuna.com/licenses/>.
 *
 *
 * HISTORY:
 * Date US Format		User					Note
 * 2013/04/10			CF Mitrah		 	Initial version
 
--->
<cfscript>
	request.layout=false;
	arr = arrayNew(1);
	
	for (x = 1; x <= rc.qFolders.RecordCount; x=x+1) { 
		arr[x] = structNew();
		arr[x]["data"] = "#rc.qFolders.FOLDER_NAME[x]#";
		arr[x]["attr"] = structNew();
		arr[x]["attr"]["id"] = "#rc.qFolders.FOLDER_ID[x]#";
		
		arr[x]["attr"]["rel"] = "folder";
		arr[x]["state"] = "closed";
	}
	
	for (y = 1; y <= rc.qAssets.RecordCount; y=y+1) { 
		tot=0;
		arr[x] = structNew();
		arr[x]["attr"] = structnew();
		if(rc.qAssets.id[x]!=''){
			qRenditions = rc.razunaAPI.getrenditions(assetid='#rc.qAssets.id[x]#',assettype='#rc.qAssets.KIND[x]#');//To get the rendition details
			for(r=1; r<=qRenditions.RecordCount; r=r+1){
				if(qRenditions.type[r] == 'rendition'){
					tot=tot+1;
					arr[x]["attr"]["rend_extension"&tot] = "#qRenditions.EXTENSION[r]#";
					arr[x]["attr"]["rend_local_url_org"&tot] = "#qRenditions.LOCAL_URL_ORG[r]#";
					arr[x]["attr"]["rend_cloud_url_org"&tot] = "#qRenditions.LOCAL_URL_ORG[r]#";
					arr[x]["attr"]["rend_height"&tot] = "#qRenditions.HEIGHT[r]#";
					arr[x]["attr"]["rend_width"&tot] = "#qRenditions.WIDTH[r]#";
				}
			}
			arr[x]["attr"]["rend_total"] = tot;//Total number of renditions
		}
		arr[x]["data"] = "#rc.qAssets.filename[x]#";
		arr[x]["attr"]["id"] = "#rc.qAssets.id[x]#";
		
		arr[x]["attr"]["rel"] = "#rc.qAssets.KIND[x]#";
		arr[x]["state"] = "";
		arr[x]["attr"]["data-filename"] = "#rc.qAssets.filename[x]#";
        arr[x]["attr"]["data-folder_id"] = "#rc.qAssets.folder_id[x]#";
        arr[x]["attr"]["data-extension"] = "#rc.qAssets.extension[x]#";
        arr[x]["attr"]["data-video_image"] = "#rc.qAssets.video_image[x]#";
        arr[x]["attr"]["data-filename_org"] = "#rc.qAssets.filename_org[x]#";
        arr[x]["attr"]["data-kind"] = "#rc.qAssets.kind[x]#";
        arr[x]["attr"]["data-extension_thumb"] = "#rc.qAssets.extension_thumb[x]#";
        arr[x]["attr"]["data-description"] = "#rc.qAssets.description[x]#";
        arr[x]["attr"]["data-path_to_asset"] = "#rc.qAssets.path_to_asset[x]#";
        arr[x]["attr"]["data-cloud_url"] = "#rc.qAssets.cloud_url[x]#";
        arr[x]["attr"]["data-cloud_url_org"] = "#rc.qAssets.cloud_url_org[x]#";
        arr[x]["attr"]["data-local_url_org"] = "#rc.qAssets.local_url_org[x]#";
        arr[x]["attr"]["data-local_url_thumb"] = "#rc.qAssets.local_url_thumb[x]#";
        arr[x]["attr"]["data-width"] = "#rc.qAssets.width[x]#";
        arr[x]["attr"]["data-height"] = "#rc.qAssets.height[x]#";
		x=x+1;	
	}
</cfscript>
	
</cfsilent>
<cfsetting enablecfoutputonly="true">
<cfoutput>#serializeJSON(arr)#</cfoutput>

