<cfcomponent name="s3" displayname="Amazon S3 REST Wrapper v1.4">

<!---
Amazon S3 REST Wrapper

Written by Joe Danziger (joe@ajaxcf.com) with much help from
dorioo on the Amazon S3 Forums.  See the readme for more
details on usage and methods.
Thanks to Steve Hicks for the bucket ACL updates.
Thanks to Carlos Gallupa for the EU storage location updates.

Version 1.4 - Released: February 12, 2008

text/html; charset=UTF-8
--->

	<cfset variables.accessKeyId = "">
	<cfset variables.secretAccessKey = "">

	<cffunction name="init" access="public" returnType="s3" output="false"
				hint="Returns an instance of the CFC initialized.">
		<cfargument name="accessKeyId" type="string" required="true" hint="Amazon S3 Access Key ID.">
		<cfargument name="secretAccessKey" type="string" required="true" hint="Amazon S3 Secret Access Key.">
		
		<cfset variables.accessKeyId = arguments.accessKeyId>
		<cfset variables.secretAccessKey = arguments.secretAccessKey>
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="HMAC_SHA1" returntype="binary" access="private" output="false" hint="NSA SHA-1 Algorithm">
	   <cfargument name="signKey" type="string" required="true" />
	   <cfargument name="signMessage" type="string" required="true" />
	
	   <cfset var jMsg = JavaCast("string",arguments.signMessage).getBytes("iso-8859-1") />
	   <cfset var jKey = JavaCast("string",arguments.signKey).getBytes("iso-8859-1") />
	   <cfset var key = createObject("java","javax.crypto.spec.SecretKeySpec") />
	   <cfset var mac = createObject("java","javax.crypto.Mac") />
	
	   <cfset key = key.init(jKey,"HmacSHA1") />
	   <cfset mac = mac.getInstance(key.getAlgorithm()) />
	   <cfset mac.init(key) />
	   <cfset mac.update(jMsg) />
	
	   <cfreturn mac.doFinal() />
	</cffunction>

	<cffunction name="createSignature" returntype="string" access="public" output="false">
	   <cfargument name="stringIn" type="string" required="true" />
		
		<!--- Replace "\n" with "chr(10) to get a correct digest --->
		<cfset var fixedData = replace(arguments.stringIn,"\n","#chr(10)#","all")>
		<!--- Calculate the hash of the information --->
		<cfset var digest = HMAC_SHA1(variables.secretAccessKey,fixedData)>
		<!--- fix the returned data to be a proper signature --->
		<cfset var signature = ToBase64("#digest#")>
		
		<cfreturn signature>
	</cffunction>

	<cffunction name="getBuckets" access="public" output="false" returntype="array" 
				description="List all available buckets.">
		
		<cfset var data = "">
		<cfset var bucket = "">
		<cfset var buckets = "">
		<cfset var thisBucket = "">
		<cfset var allBuckets = "">
		<cfset var dateTimeString = GetHTTPTimeString(Now())>
		<cfset var cs = "">
		<cfset var signature = "">
		<cfset var x = 0 />
		
		<!--- Create a canonical string to send --->
		<cfset cs = "GET\n\n\n#dateTimeString#\n/">
	
		
		<!--- Create a proper signature --->
		<cfset signature = createSignature(cs)>
		
		<!--- get all buckets via REST --->
		<cfhttp method="GET" url="http://s3.amazonaws.com">
			<cfhttpparam type="header" name="Date" value="#dateTimeString#">
			<cfhttpparam type="header" name="Authorization" value="AWS #variables.accessKeyId#:#signature#">
		</cfhttp>
		
		<cfset data = xmlParse(cfhttp.FileContent)>
		<cfset buckets = xmlSearch(data, "//:Bucket")>

		<!--- create array and insert values from XML --->
		<cfset allBuckets = arrayNew(1)>
		<cfloop index="x" from="1" to="#arrayLen(buckets)#">
		   <cfset bucket = buckets[x]>
		   <cfset thisBucket = structNew()>
		   <cfset thisBucket.Name = bucket.Name.xmlText>
		   <cfset thisBucket.CreationDate = bucket.CreationDate.xmlText>
		   <cfset arrayAppend(allBuckets, thisBucket)>   
		</cfloop>
		
		<cfreturn allBuckets>		
	</cffunction>
	
	<cffunction name="putBucket" access="public" output="false" returntype="boolean" 
				description="Creates a bucket.">
		<cfargument name="bucketName" type="string" required="true">
		<cfargument name="acl" type="string" required="false" default="public-read">
		<cfargument name="storageLocation" type="string" required="false" default="">
		<cfset var dateTimeString = "">
		<cfset var cs = "">
		<cfset var signature =""/>
		<cfset var strXML =""/>
		
		<cfset dateTimeString = GetHTTPTimeString(Now())>

		<!--- Create a canonical string to send based on operation requested ---> 
		<cfset cs = "PUT\n\ntext/html\n#dateTimeString#\nx-amz-acl:#arguments.acl#\n/#arguments.bucketName#">
		
		<!--- Create a proper signature --->
		<cfset signature = createSignature(cs)>

		<cfif arguments.storageLocation eq "EU">
			<cfsavecontent variable="strXML">
				<CreateBucketConfiguration><LocationConstraint>EU</LocationConstraint></CreateBucketConfiguration>
			</cfsavecontent>
		<cfelse>
			<cfset strXML = "">
		</cfif>

		<!--- put the bucket via REST --->
		<cfhttp method="PUT" url="http://s3.amazonaws.com/#arguments.bucketName#" charset="utf-8">
			<cfhttpparam type="header" name="Content-Type" value="text/html">
			<cfhttpparam type="header" name="Date" value="#dateTimeString#">
			<cfhttpparam type="header" name="x-amz-acl" value="#arguments.acl#">
			<cfhttpparam type="header" name="Authorization" value="AWS #variables.accessKeyId#:#signature#">
			<cfhttpparam type="body" value="#trim(variables.strXML)#">
		</cfhttp>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getBucket" access="public" output="false" returntype="array" 
				description="Creates a bucket.">
		<cfargument name="bucketName" type="string" required="yes">
		<cfargument name="prefix" type="string" required="false" default="">
		<cfargument name="marker" type="string" required="false" default="">
		<cfargument name="maxKeys" type="string" required="false" default="">
		
		<cfset var data = "">
		<cfset var content = "">
		<cfset var contents = "">
		<cfset var thisContent = "">
		<cfset var allContents = "">
		<cfset var dateTimeString = GetHTTPTimeString(Now())>
		<cfset var cs = "">
		<cfset var signature =""/>
		<cfset var x = 0 />
		
		<!--- Create a canonical string to send --->
			<cfset cs = "GET\n\n\n#dateTimeString#\n/#arguments.bucketName#">	
		
		<!--- Create a proper signature --->
		<cfset signature = createSignature(cs)>

		<!--- get the bucket via REST --->
		<cfhttp method="GET" url="http://s3.amazonaws.com/#arguments.bucketName#">
			<cfhttpparam type="header" name="Date" value="#dateTimeString#">
			<cfhttpparam type="header" name="Authorization" value="AWS #variables.accessKeyId#:#signature#">
			<cfif compare(arguments.prefix,'')>
				<cfhttpparam type="URL" name="prefix" value="#arguments.prefix#"> 
			</cfif>
			<cfif compare(arguments.marker,'')>
				<cfhttpparam type="URL" name="marker" value="#arguments.marker#"> 
			</cfif>
			<cfif isNumeric(arguments.maxKeys)>
				<cfhttpparam type="URL" name="max-keys" value="#arguments.maxKeys#"> 
			</cfif>
		</cfhttp>
		
		<cfset data = xmlParse(cfhttp.FileContent)>
		<cfset contents = xmlSearch(data, "//:Contents")>

		<!--- create array and insert values from XML --->
		<cfset allContents = arrayNew(1)>
		<cfloop index="x" from="1" to="#arrayLen(contents)#">
			<cfset content = contents[x]>
			<cfset thisContent = structNew()>
			<cfset thisContent.Key = content.Key.xmlText>
			<cfset thisContent.LastModified = content.LastModified.xmlText>
			<cfset thisContent.Size = content.Size.xmlText>
			<cfset arrayAppend(allContents, thisContent)>   
		</cfloop>

		<cfreturn allContents>
	</cffunction>
	
	<cffunction name="deleteBucket" access="public" output="false" returntype="boolean" 
				description="Deletes a bucket.">
		<cfargument name="bucketName" type="string" required="yes">	
		
		<cfset var dateTimeString = GetHTTPTimeString(Now())>
		<cfset var cs = "">
		<cfset var signature =""/>
		
		<!--- Create a canonical string to send based on operation requested ---> 
		<cfset cs = "DELETE\n\n\n#dateTimeString#\n/#arguments.bucketName#"> 
		
		<!--- Create a proper signature --->
		<cfset signature = createSignature(cs)>
		
		<!--- delete the bucket via REST --->
		<cfhttp method="DELETE" url="http://s3.amazonaws.com/#arguments.bucketName#" charset="utf-8">
			<cfhttpparam type="header" name="Date" value="#dateTimeString#">
			<cfhttpparam type="header" name="Authorization" value="AWS #variables.accessKeyId#:#signature#">
		</cfhttp>

		<cfreturn true>
	</cffunction>
	
	<cffunction name="putObject" access="public" output="false" returntype="boolean" 
				description="Puts an object into a bucket.">
		<cfargument name="bucketName" type="string" required="yes">
		<cfargument name="fileKey" type="string" required="yes">
		<cfargument name="binaryFileData" type="any" required="yes">
		<cfargument name="contentType" type="string" required="yes">
		<cfargument name="HTTPtimeout" type="numeric" required="no" default="300">
	
		<cfset var dateTimeString = GetHTTPTimeString(Now())>
		<cfset var cs = "">
		<cfset var signature =""/>
		
		<!--- Create a canonical string to send --->
		<cfset cs = "PUT\n\n#arguments.contentType#\n#dateTimeString#\nx-amz-acl:public-read\n/#arguments.bucketName#/#arguments.fileKey#">
		
		<!--- Create a proper signature --->
		<cfset signature = createSignature(cs)>
		
		<!--- Read the image data into a variable --->
		<!---<cffile action="readBinary" file="#ExpandPath("./#arguments.fileKey#")#" variable="binaryFileData">--->
		
		<!--- Send the file to amazon. The "X-amz-acl" controls the access properties of the file --->
		<cfhttp method="PUT" url="http://s3.amazonaws.com/#arguments.bucketName#/#arguments.fileKey#" timeout="#arguments.HTTPtimeout#">
			  <cfhttpparam type="header" name="Authorization" value="AWS #variables.accessKeyId#:#signature#">
			  <cfhttpparam type="header" name="Content-Type" value="#arguments.contentType#">
			  <cfhttpparam type="header" name="Date" value="#dateTimeString#">
			  <cfhttpparam type="header" name="x-amz-acl" value="public-read">
			   <cfhttpparam type="body" value="#arguments.binaryFileData#">
		</cfhttp> 		
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getObject" access="public" output="false" returntype="string" 
				description="Returns a link to an object.">
		<cfargument name="bucketName" type="string" required="yes">
		<cfargument name="fileKey" type="string" required="yes">
		<cfargument name="minutesValid" type="string" required="false" default="60">
		
		<cfset var timedAmazonLink = "">
		<cfset var epochTime = DateDiff("s", DateConvert("utc2Local", "January 1 1970 00:00"), now()) + (arguments.minutesValid * 60)>
		<cfset var cs = "">
		<cfset var signature =""/>
		
		<!--- Create a canonical string to send --->
		<cfset cs = "GET\n\n\n#epochTime#\n/#arguments.bucketName#/#arguments.fileKey#">

		<!--- Create a proper signature --->
		<cfset signature = createSignature(cs)>

		<!--- Create the timed link for the image --->
		<cfset timedAmazonLink = "http://s3.amazonaws.com/#arguments.bucketName#/#arguments.fileKey#?AWSAccessKeyId=#urlEncodedFormat(variables.accessKeyId)#&Expires=#urlEncodedFormat(epochTime)#&Signature=#urlEncodedFormat(signature)#">

		<cfreturn timedAmazonLink>
	</cffunction>

	<cffunction name="deleteObject" access="public" output="false" returntype="boolean" 
				description="Deletes an object.">
		<cfargument name="bucketName" type="string" required="yes">
		<cfargument name="fileKey" type="string" required="yes">
		
		<cfset var dateTimeString = GetHTTPTimeString(Now())>
		<cfset var cs = "">
		<cfset var signature =""/>
		
		<!--- Create a canonical string to send based on operation requested ---> 
		<cfset cs = "DELETE\n\n\n#dateTimeString#\n/#arguments.bucketName#/#arguments.fileKey#">

		<!--- Create a proper signature --->
		<cfset signature = createSignature(cs)>

		<!--- delete the object via REST --->
		<cfhttp method="DELETE" url="http://s3.amazonaws.com/#arguments.bucketName#/#arguments.fileKey#">
			<cfhttpparam type="header" name="Date" value="#dateTimeString#">
			<cfhttpparam type="header" name="Authorization" value="AWS #variables.accessKeyId#:#signature#">
		</cfhttp>

		<cfreturn true>
	</cffunction>
	
</cfcomponent>