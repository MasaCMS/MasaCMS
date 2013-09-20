<!--- load the file that grabs all values from the ini file --->
<cfinclude template="cffpConfig.cfm">

<cfset akismetHTTPRequest = 1>

<cfif structKeyExists(url,"type")>
	<cftry>
		<!--- send form contents to Akismet API --->
		<cfhttp url="http://#cffpConfig.akismetAPIKey#.rest.akismet.com/1.1/submit-#url.type#" timeout="10" method="post">
			<cfhttpparam name="key" type="formfield" value="#cffpConfig.akismetAPIKey#">
			<cfhttpparam name="blog" type="formfield" value="#cffpConfig.akismetBlogURL#">
			<cfhttpparam name="user_ip" type="formfield" value="#urlDecode(url.user_ip,'utf-8')#">
			<cfhttpparam name="user_agent" type="formfield" value="CFFormProtect/1.0 | Akismet/1.11">
			<cfhttpparam name="referrer" type="formfield" value="#urlDecode(url.referrer,'utf-8')#">
			<cfhttpparam name="comment_author" type="formfield" value="#urlDecode(url.comment_author,'utf-8')#">
			<cfif cffpConfig.akismetFormEmailField neq "">
			<cfhttpparam name="comment_author_email" type="formfield" value="#urlDecode(url.comment_author_email,'utf-8')#">
			</cfif>
			<cfif cffpConfig.akismetFormURLField neq "">
			<cfhttpparam name="comment_author_url" type="formfield" value="#urlDecode(url.comment_author_url,'utf-8')#">
			</cfif>
			<cfhttpparam name="comment_content" type="formfield" value="#urlDecode(url.comment_content,'utf-8')#">
		</cfhttp>
		<cfcatch type="any">
			<cfset akismetHTTPRequest = 0>
		</cfcatch>
	</cftry>
	
	<cfif akismetHTTPRequest>
		Thank you for submitting this data to Akismet
	<cfelse>
		Could not contact Akistmet server.
	</cfif>
<cfelse>
	Invalid URL.
</cfif>