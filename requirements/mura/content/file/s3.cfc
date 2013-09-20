<!---
Copyright 2008 Barney Boisvert (bboisvert@gmail.com).

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->
<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="awsKey" type="string" required="true" />
		<cfargument name="awsSecret" type="string" required="true" />
		<cfargument name="localCacheDir" type="string" required="false"
			hint="If omitted, no local caching is done.  If provided, this directory is used for local caching of S3 assets.  Note that if local caching is enabled, this CFC assumes it is the only entity managing the S3 storage and therefore that S3 never needs to be checked for updates (other than those made though this CFC).  If you update S3 via other means, you cannot safely use the local cache." />
		<cfargument name="awsEndpoint" type="string" required="false" default="s3.amazonaws.com" />
		<cfset variables.awsEndpoint = awsEndpoint>
		<cfset variables.awsKey = awsKey />
		<cfset variables.awsSecret = awsSecret />
		<cfset variables.useLocalCache = structKeyExists(arguments, "localCacheDir") />
		<cfif useLocalCache>
			<cfset variables.localCacheDir = localCacheDir />
			<cfif NOT directoryExists(localCacheDir)>
				<cfdirectory action="create"
					directory="#localCacheDir#" />
			</cfif>
		</cfif>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="s3Url" access="public" output="false" returntype="string">
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfargument name="requestType" type="string" default="vhost"
			hint="Must be one of 'regular', 'ssl', 'vhost', or 'cname'.  'Vhost' and 'cname' are only valid if your bucket name conforms to the S3 virtual host conventions, and cname requires a CNAME record configured in your DNS." />
		<cfargument name="timeout" type="numeric" default="900"
			hint="The number of seconds the URL is good for.  Defaults to 900 (15 minutes)." />
		<cfargument name="verb" type="string" default="GET"
			hint="The HTTP verb to use.  Only GET (the default) and HEAD make sense." />
		<cfscript>
			var expires = int(getTickCount() / 1000) + timeout;
			var signature = "";
			var destUrl = "";

			signature = getRequestSignature(
				uCase(verb),
				bucket,
				objectKey,
				expires
			);
			if (requestType EQ "ssl" OR requestType EQ "regular") {
				destUrl = "http" & iif(requestType EQ "ssl", de("s"), de("")) & "://#variables.awsEndpoint#/#bucket#/#objectKey#?AWSAccessKeyId=#variables.awsKey#&Signature=#urlEncodedFormat(signature)#&Expires=#expires#";
			} else if (requestType EQ "cname") {
				destUrl = "http://#bucket#/#objectKey#?AWSAccessKeyId=#variables.awsKey#&Signature=#urlEncodedFormat(signature)#&Expires=#expires#";
			} else { // vhost
				destUrl = "http://#bucket#.#variables.awsEndpoint#/#objectKey#?AWSAccessKeyId=#variables.awsKey#&Signature=#urlEncodedFormat(signature)#&Expires=#expires#";
			}

			return destUrl;
		</cfscript>
	</cffunction>



	<cffunction name="putFileOnS3" access="public" output="false" returntype="struct"
			hint="I put a file on S3, and return the HTTP response from the PUT">
		<!---<cfargument name="localFilePath" type="string" required="true" />--->
		<cfargument name="binaryFileData" type="any" required="true" />
		<cfargument name="contentType" type="string" required="true"  />
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfargument name="isPublic" type="boolean" default="true" />
		<cfset var gmtNow = dateAdd("s", getTimeZoneInfo().utcTotalOffset, now()) />
		<cfset var dateValue = dateFormat(gmtNow, "ddd, dd mmm yyyy") & " " & timeFormat(gmtNow, "HH:mm:ss") & " GMT" />
		<cfset var signature = getRequestSignature(
			"PUT",
			bucket,
			objectKey,
			dateValue,
			contentType,
			'',
			iif(isPublic, de('x-amz-acl:public-read'), '')
		) />
		<!---<cfset var content = "" />--->
		<cfset var result = "" />
		<!---
		<cffile action="readbinary"
			file="#localFilePath#"
			variable="content" />
		--->
		<cfif len(application.configBean.getProxyServer())>
		<cfhttp url="http://#variables.awsEndpoint#/#bucket#/#objectKey#"
			method="PUT"
			result="result"
			proxyUser="#application.configBean.getProxyUser()#"
			proxyPassword="#application.configBean.getProxyPassword()#"
			proxyServer="#application.configBean.getProxyServer()#"
			proxyPort="#application.configBean.getProxyPort()#">
			<cfhttpparam type="header" name="Date" value="#dateValue#" />
			<cfhttpparam type="header" name="Authorization" value="AWS #variables.awsKey#:#signature#" />
			<cfhttpparam type="header" name="Content-Type" value="#contentType#" />
			<cfif isPublic>
				<cfhttpparam type="header" name="x-amz-acl" value="public-read" />
			</cfif>
			<cfhttpparam type="body" value="#binaryFileData#" />
		</cfhttp>
		<cfelse>
		<cfhttp url="http://#variables.awsEndpoint#/#bucket#/#objectKey#"
			method="PUT"
			result="result">
			<cfhttpparam type="header" name="Date" value="#dateValue#" />
			<cfhttpparam type="header" name="Authorization" value="AWS #variables.awsKey#:#signature#" />
			<cfhttpparam type="header" name="Content-Type" value="#contentType#" />
			<cfif isPublic>
				<cfhttpparam type="header" name="x-amz-acl" value="public-read" />
			</cfif>
			<cfhttpparam type="body" value="#binaryFileData#" />
		</cfhttp>
		</cfif>
		<cfset deleteCacheFor(bucket, objectKey) />
		<cfreturn result />
	</cffunction>



	<cffunction name="s3FileExists" access="public" output="false" returntype="boolean">
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfset var result = "" />
		<cfif useLocalCache>
			<cfif fileExists(cacheFilenameFromBucketAndKey(bucket, objectKey))>
				<cfreturn true />
			</cfif>
		</cfif>
		<cfif len(application.configBean.getProxyServer())>
		<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30, 'HEAD')#"
			method="HEAD"
			timeout="30"
			throwonerror="false"
			result="result"
			proxyUser="#application.configBean.getProxyUser()#"
			proxyPassword="#application.configBean.getProxyPassword()#"
			proxyServer="#application.configBean.getProxyServer()#"
			proxyPort="#application.configBean.getProxyPort()#"/>
		<cfelse>
		<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30, 'HEAD')#"
			method="HEAD"
			timeout="30"
			throwonerror="false"
			result="result"/>
		</cfif>
		<cfreturn val(trim(result.statusCode)) EQ 200 />
	</cffunction>



	<cffunction name="deleteS3File" access="public" output="false" returntype="void">
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfset deleteS3FileInternal(bucket, objectKey, 0) />
	</cffunction>



	<cffunction name="deleteS3FileInternal" access="private" output="false" returntype="void">
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfargument name="attemptCount" type="numeric" required="true" />
		<cfset var result = "" />
		<cfset var retry = false />
		<cfif len(application.configBean.getProxyServer())>
		<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30, 'DELETE')#"
			method="DELETE"
			timeout="15"
			throwonerror="false"
			result="result"
			proxyUser="#application.configBean.getProxyUser()#"
			proxyPassword="#application.configBean.getProxyPassword()#"
			proxyServer="#application.configBean.getProxyServer()#"
			proxyPort="#application.configBean.getProxyPort()#"/>
		<cfelse>
		<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30, 'DELETE')#"
			method="DELETE"
			timeout="15"
			throwonerror="false"
			result="result"/>
		</cfif>
		<cfif result.statusCode LT 200 OR result.statusCode GTE 300>
			<cfset retry = attemptCount LT 3 AND (
				(isXml(result.fileContent)
					AND result.fileContent CONTAINS "<Code>InternalError</Code>"
				)
				OR (result.fileContent EQ "Connection Timeout"
				)
			)>
			<cfif retry>
				<cfset deleteS3FileInternal(bucket, objectKey, attemptCount + 1) />
			<cfelse>
				<cfdump var="#arguments#" />
				<cfdump var="#result#" />
				<cfabort showerror="error deleting file from S3" />
			</cfif>
		</cfif>
		<cfset deleteCacheFor(bucket, objectKey) />
	</cffunction>



	<cffunction name="getFileFromS3" access="public" output="false" returntype="string"
			hint="Brings a file from S3 down local, and returns the fully qualified local path">
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfargument name="localFilePath" type="string" required="false"
			hint="If omitted a temp file will be created" />
		<cfset var filepath = "" />
		<cfset var cachePath = "" />
		<cfif structKeyExists(arguments, "localFilePath")>
			<cfset filepath = localFilePath />
		<cfelse>
			<cfset filepath = getTempFile(application.configBean.getTempDir(), "s3") />
		</cfif>
		<cfif useLocalCache>
			<cfset cachePath = cacheFilenameFromBucketAndKey(bucket, objectKey) />
			<cfif fileExists(cachePath)>
				<cfset fileCopy(cachePath, filepath) />
				<cfreturn filepath />
			</cfif>
		</cfif>
		<cftry>
			<cfif len(application.configBean.getProxyServer())>
			<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30)#"
				timeout="30"
				throwonerror="true"
				getasbinary="yes"
				file="#getFileFromPath(filepath)#"
				path="#getDirectoryFromPath(filepath)#"
				proxyUser="#application.configBean.getProxyUser()#"
				proxyPassword="#application.configBean.getProxyPassword()#"
				proxyServer="#application.configBean.getProxyServer()#"
				proxyPort="#application.configBean.getProxyPort()#" />
			<cfelse>
			<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30)#"
				timeout="30"
				throwonerror="true"
				getasbinary="yes"
				file="#getFileFromPath(filepath)#"
				path="#getDirectoryFromPath(filepath)#"/>
			</cfif>
			<cfcatch type="any">
				<!--- try again, exactly the same --->
				<cfif len(application.configBean.getProxyServer())>
				<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30)#"
					timeout="30"
					throwonerror="true"
					getasbinary="yes"
					file="#getFileFromPath(filepath)#"
					path="#getDirectoryFromPath(filepath)#"
					proxyUser="#application.configBean.getProxyUser()#"
					proxyPassword="#application.configBean.getProxyPassword()#"
					proxyServer="#application.configBean.getProxyServer()#"
					proxyPort="#application.configBean.getProxyPort()#" />
				<cfelse>
				<cfhttp url="#s3Url(bucket, objectKey, 'regular', 30)#"
					timeout="30"
					throwonerror="true"
					getasbinary="yes"
					file="#getFileFromPath(filepath)#"
					path="#getDirectoryFromPath(filepath)#"/>
				</cfif>
			</cfcatch>
		</cftry>
		<cfif useLocalCache>
			<cfset fileCopy(filepath, cachePath) />
		</cfif>
		<cfreturn filepath />
	</cffunction>



	<cffunction name="deleteCacheFor" access="public" output="false" returntype="void">
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfset var cachePath = "" />
		<cfif useLocalCache>
			<cfset cachePath = cacheFilenameFromBucketAndKey(bucket, objectKey) />
			<cfif fileExists(cachePath)>
				<cfset fileDelete(cachePath) />
			</cfif>
		</cfif>
	</cffunction>



	<cffunction name="getRequestSignature" access="private" output="false" returntype="string">
		<cfargument name="verb" type="string" required="true" />
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfargument name="dateOrExpiration" type="string" required="true" />
		<cfargument name="contentType" type="string" default="" />
		<cfargument name="contentMd5" type="string" default="" />
		<cfargument name="canonicalizedAmzHeaders" type="string" default=""
			hint="A newline-delimited list of headers, in lexographical order, duplicates collapsed, and no extraneous whitespace.  See Amazon's description of 'CanonicalizedAmzHeaders' for specifics." />
		<cfscript>
			var stringToSign = "";
			var algo = "HmacSHA1";
			var signingKey = "";
			var mac = "";
			var signature = "";

			stringToSign = uCase(verb) & chr(10)
				& contentMd5 & chr(10)
				& contentType & chr(10)
				& dateOrExpiration & chr(10)
				& iif(len(canonicalizedAmzHeaders) GT 0, de(canonicalizedAmzHeaders & chr(10)), de(''))
				& "/#bucket#/#objectKey#";
			signingKey = createObject("java", "javax.crypto.spec.SecretKeySpec").init(variables.awsSecret.getBytes(), algo);
			mac = createObject("java", "javax.crypto.Mac").getInstance(algo);
			mac.init(signingKey);
			signature = toBase64(mac.doFinal(stringToSign.getBytes()));

			return signature;
		</cfscript>
	</cffunction>



	<cffunction name="cacheFilenameFromBucketAndKey" access="private" output="false" returntype="string">
		<cfargument name="bucket" type="string" required="true" />
		<cfargument name="objectKey" type="string" required="true" />
		<cfreturn localCacheDir & "/" & REReplace(bucket & "/" & objectKey, "[^a-zA-Z0-9.-]+", "_", "all") />
	</cffunction>

<cfoutput></cfoutput>
</cfcomponent>