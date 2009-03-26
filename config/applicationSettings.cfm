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

	<!--- Application name, should be unique --->
	<cfset this.name = right(REReplace(getDirectoryFromPath(getCurrentTemplatePath()),'[^A-Za-z0-9]','','all'),64) />
	<!--- How long application vars persist --->
	<cfset this.applicationTimeout = createTimeSpan(3,0,0,0)>
	<!--- Where should cflogin stuff persist --->
	<cfset this.loginStorage = "cookie">
	
	
	<cfset request.userAgent = LCase( CGI.http_user_agent ) />
	<!--- Should we even use sessions? --->
	<cfset request.trackSession = not (NOT Len( request.userAgent ) OR
	 REFind( "bot\b", request.userAgent ) OR
	 Find( "crawl", request.userAgent ) OR
	 REFind( "\brss", request.userAgent ) OR
	 Find( "feed", request.userAgent ) OR
	 Find( "news", request.userAgent ) OR
	 Find( "blog", request.userAgent ) OR
	 Find( "reader", request.userAgent ) OR
	 Find( "syndication", request.userAgent ) OR
	 Find( "coldfusion", request.userAgent ) OR
	 Find( "slurp", request.userAgent ) OR
	 Find( "google", request.userAgent ) OR
	 Find( "zyborg", request.userAgent ) OR
	 Find( "emonitor", request.userAgent ) OR
	 Find( "jeeves", request.userAgent )
	 OR Find( "spider", request.userAgent ))>
	
	<cfset this.sessionManagement = true>
	<!--- How long do session vars persist? --->
	<cfif request.trackSession>
		<cfset this.sessionTimeout = createTimeSpan(0,3,0,0)>
	<cfelse>
		<cfset this.sessionTimeout = createTimeSpan(0,0,5,0)>
	</cfif>
	
	<!--- Should we set cookies on the browser? --->
	<cfset this.setClientCookies = true>
	<!--- should cookies be domain specific, ie, *.foo.com or www.foo.com --->
	<cfset this.setDomainCookies = false>
	<!--- should we try to block 'bad' input from users --->
	<cfset this.scriptProtect = false>
	<!--- should we secure our JSON calls? --->
	<cfset this.secureJSON = false>
	<!--- Should we use a prefix in front of JSON strings? --->
	<cfset this.secureJSONPrefix = "">
	<!--- Used to help CF work with missing files and dir indexes --->
	<cfset this.welcomeFileList = "">
	
	<!--- Preferred method for ColdFusion 8, allows you to skip administering these settings in the CF admin	
	1. Place Mura requirements directory in your webroot
	2. Place Mura Custom Tags directory into "requirements/custom_tags/"
	2. Change basedir to point to your webroot
	3. Uncomment the code below
	--->
	
	
	<!--- Define the location of your frameworks 
		The default here is dynamically pointing at the webroot
	--->
	<cfset baseDir= left(getDirectoryFromPath(getCurrentTemplatePath()),len(getDirectoryFromPath(getCurrentTemplatePath()))-8) />

	<!--- define a list of custom tag paths. --->
	<cfset this.customtagpaths = baseDir  &  "/requirements/custom_tags/">
	
	<!--- define custom coldfusion mappings. Keys are mapping names, values are full paths  --->
	<cfset this.mappings = structNew()>
	<cfdirectory action="list" directory="#baseDir#/requirements/" name="rsRequirements">
	<cfloop query="rsRequirements">
		<cfif rsRequirements.type eq "dir">
			<cfset this.mappings["/#rsRequirements.name#"] = rsRequirements.directory & "/" & rsRequirements.name>
		</cfif>
	</cfloop>
	<cfset this.mappings["/plugins"] = baseDir & "/plugins">
	<cfset this.mappings["/muraWRM"] = baseDir>
	<cfset this.mappings["/savaWRM"] = baseDir>
	