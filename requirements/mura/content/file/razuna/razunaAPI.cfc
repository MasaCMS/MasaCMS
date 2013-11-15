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
<cfcomponent extends="mura.cfobject">
	<cfscript>
		function set(required string hostName,required string APIKey, required numeric hostID){
			
			this.config_host 		= arguments.hostName;
			this.config_APIKey 		= arguments.APIKey;
			this.config_hostid 		= arguments.hostID;
			
			this.config_host_type 	= "";
			
			this.auth_uri			= this.config_host & '/global/api2/authentication.cfc?';
			this.folder_uri			= this.config_host & '/global/api2/folder.cfc?';
			this.collection_uri		= this.config_host & '/global/api2/collection.cfc?';
			this.hosts_uri			= this.config_host & '/global/api2/hosts.cfc?';
			this.search_uri			= this.config_host & '/global/api2/search.cfc?';
			this.user_uri			= this.config_host & '/global/api2/user.cfc?';
			this.asset_uri			= this.config_host & '/global/api2/asset.cfc?';
			
			this.host_type_id		= 1;
			this.host_type_name		= 2;
			
			this.asset_type_all		= 'all';
			this.asset_type_image	= 'img';
			this.asset_type_video	= 'vid';
			this.asset_type_document= 'doc';
			this.asset_type_audio	= 'aud';
			
			this.doc_type_empty		= 'empty';
			this.doc_type_pdf		= 'pdf';
			this.doc_type_excel		= 'xls';
			this.doc_type_word		= 'doc';
			this.doc_type_other		= 'other';
						
			return this;
		}
		
		function checkAPIKey(){
			// checkdb method is not having remote access. Need to discuss about this with Nitai
			var apiURL = this.auth_uri & "method=checkdb&api_key=" & this.config_APIKey ;
			var result = doHttp(apiURL);
			return  result;
		}
		
		query function getFolders( string folderid = "0" ){
		
			var apiURL = this.folder_uri & "method=getfolders&api_key=" & this.config_hostid&'-'&this.config_APIKey & "&folderid=" & arguments.folderid;
			var result = doHttp(apiURL);
		
			if(arraylen(result.columns) LTE 3 )
				var qry = querynew ("CALLEDWITH, CLOUD_URL, CLOUD_URL_ORG, DATEADD, DATECHANGE, DESCRIPTION, EXTENSION, EXTENSION_THUMB, FILENAME, FILENAME_ORG, FOLDER_ID, HEIGHT, ID, KEYWORDS, KIND, LOCAL_URL_ORG, LOCAL_URL_THUMB, PATH_TO_ASSET, RESPONSECODE, SIZE, SUBASSETS, TOTALASSETSCOUNT, VIDEO_IMAGE, WIDTH");
			else{
				var q = querynew (arrayToList(result.columns)); //we can pass result.data as third argument in CF 10 
				for (i=1;i LTE ArrayLen(result.data);i=i+1) {
					queryAddRow(q);
					for (j=1;j LTE ArrayLen(result.columns);j=j+1) {	
						if(arrayIsDefined(result.data[i],j)){
							QuerySetCell( q, result.columns[j], result.data[i][j], i );
						}
					}
				}
				var qry = removeCurrentFolder (q, arguments.folderid);
			}	
			return qry;
		}
		
		//Get the renditions details for the existing assets. 
		 query function getrenditions( required string assetid, required string assettype){
			var apiURL = this.asset_uri & "method=getrenditions&api_key=" & this.config_hostid&'-'&this.config_APIKey & "&assetid=" & arguments.assetid& "&assettype=" & arguments.assettype;
			var result = doHttp(apiURL);

			if(arraylen(result.columns) LTE 3 )
				var q = querynew ("CALLEDWITH, CLOUD_URL, CLOUD_URL_ORG, DATEADD, DATECHANGE, DESCRIPTION, EXTENSION, EXTENSION_THUMB, FILENAME, FILENAME_ORG, FOLDER_ID, HEIGHT, ID, KEYWORDS, KIND, LOCAL_URL_ORG, LOCAL_URL_THUMB, PATH_TO_ASSET, RESPONSECODE, SIZE, SUBASSETS, TOTALASSETSCOUNT, VIDEO_IMAGE, WIDTH");
			else{
				var q = querynew (arrayToList(result.columns));//we can pass result.data as third argument in CF 10 
				for (var i=1;i LTE ArrayLen(result.data);i=i+1) {
					queryAddRow(q);
					for (var j=1;j LTE ArrayLen(result.columns);j=j+1) {        
							if(arrayIsDefined(result.data[i],j)){
								QuerySetCell( q, result.columns[j], result.data[i][j], i );
							}
						}
					}
				}
				return  q;
			}
		
		//Get the all assets details using API. 
		query function getassets( required string folderID ){
			var apiURL = this.folder_uri & "method=getassets&api_key=" & this.config_hostid&'-'&this.config_APIKey & "&folderid=" & arguments.folderID;
			var result = doHttp(apiURL);

			if(arraylen(result.columns) LTE 3 )
				var q = querynew ("CALLEDWITH, CLOUD_URL, CLOUD_URL_ORG, DATEADD, DATECHANGE, DESCRIPTION, EXTENSION, EXTENSION_THUMB, FILENAME, FILENAME_ORG, FOLDER_ID, HEIGHT, ID, KEYWORDS, KIND, LOCAL_URL_ORG, LOCAL_URL_THUMB, PATH_TO_ASSET, RESPONSECODE, SIZE, SUBASSETS, TOTALASSETSCOUNT, VIDEO_IMAGE, WIDTH");
			else{
				var q = querynew (arrayToList(result.columns));//we can pass result.data as third argument in CF 10 
				for (var i=1;i LTE ArrayLen(result.data);i=i+1) {
					queryAddRow(q);
					for (var j=1;j LTE ArrayLen(result.columns);j=j+1) {	
						if(arrayIsDefined(result.data[i],j)){
							QuerySetCell( q, result.columns[j], result.data[i][j], i );
						}
					}
				}
			}
			return  q;
		}
		
		//Get the folder details. 
		query function getfolder( required string folderID ){
			var apiURL = this.folder_uri & "method=getfolder&api_key=" & this.config_hostid&'-'&this.config_APIKey & "&folderid=" & arguments.folderID;
			var result = doHttp(apiURL);

			if(arraylen(result.columns) LTE 3 )
				var q = querynew ("CALLEDWITH, CLOUD_URL, CLOUD_URL_ORG, DATEADD, DATECHANGE, DESCRIPTION, EXTENSION, EXTENSION_THUMB, FILENAME, FILENAME_ORG, FOLDER_ID, HEIGHT, ID, KEYWORDS, KIND, LOCAL_URL_ORG, LOCAL_URL_THUMB, PATH_TO_ASSET, RESPONSECODE, SIZE, SUBASSETS, TOTALASSETSCOUNT, VIDEO_IMAGE, WIDTH");
			else{
				var q = querynew (arrayToList(result.columns));//we can pass result.data as third argument in CF 10 
				for (var i=1;i LTE ArrayLen(result.data);i=i+1) {
					queryAddRow(q);
					for (var j=1;j LTE ArrayLen(result.columns);j=j+1) {	
						if(arrayIsDefined(result.data[i],j)){
							QuerySetCell( q, result.columns[j], result.data[i][j], i );
						}
					}
				}
			}
			return  q;
		}
		
		struct function removefolder( required string folderID ){
			var apiURL = this.folder_uri & "method=removefolder&api_key=" & this.config_hostid&'-'&this.config_APIKey & "&folder_id=" & arguments.folderID;
			var result = doHttp(apiURL);
			return result;
		}
		
		struct function createfolder( required string folder_name, string folder_owner ="", string folder_related ="", string folder_collection ="", string folder_description = "" ){
			var apiURL = this.folder_uri & "method=setfolder&api_key=" & this.config_hostid&'-'&this.config_APIKey & "&folder_name=" & arguments.folder_name;
			var result = doHttp(apiURL);
			return result;
		}
	</cfscript>
	
	<cffunction name="removeCurrentFolder" access="private" >
		<cfargument name="q" required="true" type="query" >
		<cfargument name="folderid" required="true" type="string" >
		
		<cfset var res = {}>
		<cfquery dbtype="query" name="res">
			select * from arguments.q where folder_id != '#arguments.folderid#'
		</cfquery>
		
		<cfreturn res>
	</cffunction>
		
	<cffunction name="doHttp" access="private" >
		<cfargument name="apiURL" required="true" type="string" >
		<cfset var res = {}>
		<cfhttp url="#arguments.apiURL#" method="get" result="res">
		<cftry>
		<cfreturn deserializeJSON(res.Filecontent)>
		<cfcatch>
			<cfheader statuscode="400" statustext="400 Bad Request
" />
			<cfdump var="#res#" abort="true"></cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>