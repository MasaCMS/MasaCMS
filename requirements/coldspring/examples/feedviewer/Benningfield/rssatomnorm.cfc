<cfcomponent displayname="RSS/Atom Normalization 1.0" hint="Converts Atom and RSS 0.x/1.0/2.x feeds into a common structure." extends="coldspring.examples.feedviewer.model.normalization.normalizationService">

	<!--- 
		NORMALIZE function 1.01
		AUTHOR: Roger Benningfield
		WORK: http://journurl.com/
		BLOG: http://admin.support.journurl.com/
		COPYRIGHT: (c)2004 Agincourt Media
		LICENSE: Don't claim you wrote it, give credit where due,
		and don't delete this comment block. Outside of that, use it freely.
		NOTES:
		  2004-12-22
		    * Added code to handle where RSS2 items contain a guid but not
		  a link.
			2004-12-16
				* This is the first release of the CFC, but the code itself
			has been running for over a year as part of JournURL's internal
			aggregator. Experience shows that it works well with the 95% of
			the feeds you'll encounter in production.
				* The code checks for many edge-cases, but it is far from
			perfect. 
				* It will fail immediately if you give it ill-formed XML.
				* It will try to deal gracefully with invalid RSS/Atom, but
			the definition of "graceful" is flexible. It won't catch fire,
			but results may vary.
				* Don't try to give the component an experimental Atom 1.0draft 		
			feed. As of this writing, 1.0 is still far from release, and no 
			attempt has been made to handle pre-release feeds.
				* Yeah, there's some ugly stuff in there. Some of it is in there 		
			to work around the limits of CF's XML functions. Some of it is in
			there to work around publishers who don't stick to the specs. And
			some of it is in there because I'm an idiot.
	--->
	
	
	
	<cffunction name="normalize" output="no" returntype="array" hint="Returns a struct containing author, content, date, id, link, and title members. Also returns an isHtml member that is set to 'true' when the content element contains HTML.">
		<cfargument name="rss" required="no" default="" type="string" hint="An unparsed XML string." />
		<cfset var dummy = 0 />
		<cfset var dummy2 = "" />
		<cfset var i = 0 />
		<cfset var myNormFeed = StructNew() />
		<cfset var myNormItems = ArrayNew(1) />
		<cfset var myXmlContent = "" />
		<cfset var myXmlFeed = "" />
		<cfset var myXmlItems = "" />
		
		<cfset myXmlContent = XmlParse(arguments.rss) />
		
		<!--- LOOK FOR RSS 1.0 or 2.0--->
		<cfset myXmlFeed = XmlSearch(myXmlContent, "//*[name()='channel']")>
		<cfset myXmlItems = XmlSearch(myXmlContent, "//*[name()='item']")>
		<!--- LOOK FOR ATOM 0.3 --->
		<cfif NOT ArrayLen(myXmlFeed)>
			<cfset myXmlFeed = XmlSearch(myXmlContent, "//*[name()='feed']")>
			<cfset myXmlItems = XmlSearch(myXmlContent, "//*[name()='entry']")>
		</cfif>

		<!--- TITLE --->
		<cfif StructKeyExists(myXmlFeed[1], "title")>
			<cfset myNormFeed.title = myXmlFeed[1].title.xmlText />
		<cfelse>
			<cfset myNormFeed.title = "" />
		</cfif>
		<cfset myNormFeed.title = Trim(myNormFeed.title) />
		<!--- DESCRIPTION --->
		<cfif StructKeyExists(myXmlFeed[1], "description")>
			<cfset myNormFeed.description = myXmlFeed[1].description.xmlText />
		<cfelseif StructKeyExists(myXmlFeed[1], "tagline")>
			<cfset myNormFeed.description = myXmlFeed[1].tagline.xmlText />
		<cfelse>
			<cfset myNormFeed.description = "" />
		</cfif>
		<cfset myNormFeed.description = Trim(myNormFeed.description) />
		<!--- LINK --->
		<cfif StructKeyExists(myXmlFeed[1], "link")>
			<cfset myNormFeed.link = myXmlFeed[1].link.xmlText />
			<!--- CHECK FOR MULTIPLE LINKS --->
			<cfset dummy = XmlNodeCount(myXmlFeed[1], "link") />
			<cfif dummy GT 1>
				<cfloop index="i" from="1" to="#dummy#">
					<cfset dummy = myXmlFeed[1].xmlChildren[XmlChildPos(myXmlFeed[1], "link", i)].xmlAttributes.rel />
					<cfif dummy IS "alternate">
						<cfset myNormFeed.link = myXmlFeed[1].xmlChildren[XmlChildPos(myXmlFeed[1], "link", i)].xmlAttributes.href />
					</cfif>
				</cfloop>
			</cfif>
		<cfelse>
			<cfset myNormFeed.link = "" />
		</cfif>
		<cfset myNormFeed.link = Trim(myNormFeed.link) />
		
		<!--- NORMALIZE ITEMS --->
		<cfloop index="i" from="1" to="#ArrayLen(myXmlItems)#">
			<cfset myNormItems[i] = StructNew() />
			
			<!--- CONTENT --->
			<cfset dummy = false />
			<cfif StructKeyExists(myXmlItems[i], "description")>
				<cfset myNormItems[i].content = myXmlItems[i].description.xmlText />
				<cfif LCase(myNormItems[i].content) CONTAINS "<p" OR LCase(myNormItems[i].content) CONTAINS "<br">
					<cfset myNormItems[i].content = "<div>" & myNormItems[i].content & "</div>" />
					<cfset dummy = true />
				</cfif>
			<cfelseif StructKeyExists(myXmlItems[i], "content")>
				<!--- CHECK FOR MISSING MODE --->
				<cfif NOT StructKeyExists(myXmlItems[i].content.xmlAttributes, "mode")>
					<cfset myXmlItems[i].content.xmlAttributes.mode = "xml" />
				</cfif>
				<cfif StructKeyExists(myXmlItems[i].content.xmlAttributes, "type") AND (myXmlItems[i].content.xmlAttributes.type IS "text/html" OR myXmlItems[i].content.xmlAttributes.type IS "application/xhtml+xml")>
					<cfif myXmlItems[i].content.xmlAttributes.mode IS "xml">
						<!--- CHECK FOR MARKUP MIXED WITH TEXT --->
						<cfif Len(Trim(myXmlItems[i].content.xmlText))>
							<cfset myNormItems[i].content = ToString(myXmlItems[i].content) />
							<cfset dummy2 = "content" />
							<!--- CHECK FOR NAMESPACE --->
							<cfif Len(myXmlItems[i].content.XmlNsPrefix)>
								<cfset dummy2 = myXmlItems[i].content.XmlNsPrefix & ":" & dummy2 />
							</cfif>
							<cfset myNormItems[i].content = REReplaceNoCase(myNormItems[i].content,"<#dummy2#[^>]*>","","ONE") />
							<cfset myNormItems[i].content = Replace(myNormItems[i].content, "</#dummy2#>", "", "ONE") />
						<cfelse>
							<cfset myNormItems[i].content = "" />
							<cfloop index="ichildren" from="1" to="#ArrayLen(myXmlItems[i].content.xmlChildren)#">
								<cfset myNormItems[i].content = myNormItems[i].content & ToString(myXmlItems[i].content.xmlChildren[ichildren]) />
							</cfloop>
						</cfif>
						<cfset myNormItems[i].content = Trim(Replace(myNormItems[i].content, "<?xml version=""1.0"" encoding=""UTF-8""?>", "", "ALL")) />
						<cfset dummy = true />
					<cfelse>
						<cfset myNormItems[i].content = "<div>" & myXmlItems[i].content.xmlText & "</div>" />
						<cfset dummy = true />
					</cfif>
				<cfelse>
					<cfset myNormItems[i].content = myXmlItems[i].content.xmlText />
				</cfif>
			<cfelseif StructKeyExists(myXmlItems[i], "summary")>
				<!--- CHECK FOR MISSING MODE --->
				<cfif NOT StructKeyExists(myXmlItems[i].summary.xmlAttributes, "mode")>
					<cfset myXmlItems[i].summary.xmlAttributes.mode = "xml" />
				</cfif>
				<cfif StructKeyExists(myXmlItems[i].summary.xmlAttributes, "type") AND (myXmlItems[i].summary.xmlAttributes.type IS "text/html" OR myXmlItems[i].summary.xmlAttributes.type IS "application/xhtml+xml")>
					<cfif myXmlItems[i].summary.xmlAttributes.mode IS "xml">
						<!--- CHECK FOR MARKUP MIXED WITH TEXT --->
						<cfif Len(Trim(myXmlItems[i].summary.xmlText))>
							<cfset myNormItems[i].content = ToString(myXmlItems[i].summary) />
							<cfset dummy2 = "summary" />
							<!--- CHECK FOR NAMESPACE --->
							<cfif Len(myXmlItems[i].summary.XmlNsPrefix)>
								<cfset dummy2 = myXmlItems[i].summary.XmlNsPrefix & ":" & dummy2 />
							</cfif>
							<cfset myNormItems[i].content = REReplaceNoCase(myNormItems[i].content,"<#dummy2#[^>]*>","","ONE") />
							<cfset myNormItems[i].content = Replace(myNormItems[i].content, "</#dummy2#>", "", "ONE") />
						<cfelse>
							<cfset myNormItems[i].content = "" />
							<cfloop index="ichildren" from="1" to="#ArrayLen(myXmlItems[i].summary.xmlChildren)#">
								<cfset myNormItems[i].content = myNormItems[i].content & ToString(myXmlItems[i].summary.xmlChildren[ichildren]) />
							</cfloop>
						</cfif>
						<cfset myNormItems[i].content = Trim(Replace(myNormItems[i].content, "<?xml version=""1.0"" encoding=""UTF-8""?>", "<div>SUMMARY:</div>", "ONE")) />
						<cfset myNormItems[i].content = Trim(Replace(myNormItems[i].content, "<?xml version=""1.0"" encoding=""UTF-8""?>", "", "ALL")) />
						<cfset dummy = true />
					<cfelse>
						<cfset myNormItems[i].content = "<div>SUMMARY: " & myXmlItems[i].summary.xmlText & "</div>" />
						<cfset dummy = true />
					</cfif>
				<cfelse>
					<cfset myNormItems[i].content = "SUMMARY: " & myXmlItems[i].summary.xmlText />
				</cfif>
			<cfelse>
				<cfset myNormItems[i].content = "" />
			</cfif>
			<!--- IF CONTENT IS HTML --->
			<cfset myNormItems[i].isHtml = false />
			<cfif dummy>
				<cfset myNormItems[i].isHtml = true />
			</cfif>
			<cfset myNormItems[i].content = Trim(myNormItems[i].content) />
			
			<!--- TITLES --->
			<cfif StructKeyExists(myXmlItems[i], "title")>
				<cfset myNormItems[i].title = myXmlItems[i].title.xmlText />
			<cfelse>
				<cfset myNormItems[i].title = "" />
			</cfif>
			<cfset myNormItems[i].title = Trim(myNormItems[i].title) />
			
			<!--- AUTHORS --->
			<cfif StructKeyExists(myXmlItems[i], "dc:creator")>
				<cfset myNormItems[i].author = myXmlItems[i]["dc:creator"].xmlText />
			<cfelseif StructKeyExists(myXmlItems[i], "author")>
				<cfset myNormItems[i].author = myXmlItems[i].author.xmlText />
				<cfif StructKeyExists(myXmlItems[i].author, "name")>
					<cfset myNormItems[i].author = myXmlItems[i].author.name.xmlText />
				</cfif>
			<cfelse>
				<cfset myNormItems[i].author = "" />
			</cfif>
			<cfset myNormItems[i].author = Trim(myNormItems[i].author) />
			
			<!--- DATES --->
			<cfif StructKeyExists(myXmlItems[i], "pubDate")>
				<cfset myNormItems[i].date = myXmlItems[i]["pubDate"].xmlText />
			<cfelseif StructKeyExists(myXmlItems[i], "dc:date")>
				<cfset myNormItems[i].date = myXmlItems[i]["dc:date"].xmlText />
			<cfelseif StructKeyExists(myXmlItems[i], "issued")>
				<cfset myNormItems[i].date = myXmlItems[i]["issued"].xmlText />
			<cfelseif StructKeyExists(myXmlItems[i], "modified")>
				<cfset myNormItems[i].date = myXmlItems[i]["modified"].xmlText />
			<cfelseif StructKeyExists(myXmlItems[i], "created")>
				<cfset myNormItems[i].date = myXmlItems[i]["created"].xmlText />
			<cfelse>
				<cfset myNormItems[i].date = "" />
			</cfif>
			<!--- FIX CF-INCOMPATIBLE DATES --->
			<cfset dummy = REFind("[[:digit:]]T[[:digit:]]", myNormItems[i].date)>
			<cfif dummy>
				<cfset myNormItems[i].date = Replace(myNormItems[i].date, "Z", "+00:00", "ONE")>
				<cfset dummy = "<wddxPacket version='1.0'><header/><data><dateTime>#myNormItems[i].date#</dateTime></data></wddxPacket>">
				<cfwddx action="wddx2cfml" input="#dummy#" output="dummy">
				<cfset myNormItems[i].date = dummy />
			</cfif>
			
			<!--- LINKS --->
			<cfif StructKeyExists(myXmlItems[i], "link")>
				<cfset myNormItems[i].link = myXmlItems[i].link.xmlText />
				<cfif StructKeyExists(myXmlItems[i], "guid")>
					<cfif NOT StructKeyExists(myxmlItems[i].guid.xmlAttributes, "isPermaLink") OR (StructKeyExists(myxmlItems[i].guid.xmlAttributes, "isPermaLink") AND myXmlItems[i].guid.xmlAttributes.isPermaLink IS "true")>
						<cfset myNormItems[i].link = myXmlItems[i].guid.xmlText />
					</cfif>
				</cfif>
				<cfif StructKeyExists(myXmlItems[i].link.xmlAttributes, "href")>
					<cfset myNormItems[i].link = myXmlItems[i].link.xmlAttributes.href />
				</cfif>
				<!--- CHECK FOR MULTIPLE LINKS --->
				<cfset dummy = XmlNodeCount(myXmlItems[i], "link") />
				<cfif dummy GT 1>
					<cfloop index="i2" from="1" to="#dummy#">
						<cfset dummy = myXmlItems[i].xmlChildren[XmlChildPos(myXmlItems[i], "link", i2)].xmlAttributes.rel />
						<cfif dummy IS "alternate">
							<cfset myNormItems[i].link = myXmlItems[i].xmlChildren[XmlChildPos(myXmlItems[i], "link", i2)].xmlAttributes.href />
						</cfif>
					</cfloop>
				</cfif>
			<cfelse>
				<cfset myNormItems[i].link = "" />
			</cfif>
			<cfset myNormItems[i].link = Trim(myNormItems[i].link) />
			
			<!--- IDS --->
			<cfif StructKeyExists(myXmlItems[i], "guid")>
				<cfset myNormItems[i].id = myXmlItems[i].guid.xmlText />
				<cfset dummy = myNormItems[i].id />
				<cfif StructKeyExists(myXmlItems[i].guid.xmlattributes, "ispermalink")
					  AND LCase(myXmlItems[i].guid.xmlattributes.ispermalink) IS "false">
					<cfset dummy = myNormItems[i].link />
				</cfif>
				<cfset myNormItems[i].link = dummy />
			<cfelseif StructKeyExists(myXmlItems[i], "id")>
				<cfset myNormItems[i].id = myXmlItems[i].id.xmlText />
			<cfelseif StructKeyExists(myXmlItems[i].xmlAttributes, "rdf:about")>
				<cfset myNormItems[i].id = myXmlItems[i].xmlAttributes["rdf:about"] />
			<cfelse>
				<cfset myNormItems[i].id = "" />
			</cfif>
			<cfset myNormItems[i].id = Trim(myNormItems[i].id) />
		</cfloop>
		
		<cfreturn myNormItems />
	</cffunction>
	
	<cffunction name="xmlNodeCount" output="no" returntype="numeric">
		<cfargument name="xmlElement" required="yes" type="any" hint="An XML node." />
		<cfargument name="nodeName" required="yes" type="string" hint="The name of a child node." />
		<cfset var nodesFound = 0 />
		<cfset var i = 0 />
		<!--- CODE COURTESY OF MACROMEDIA'S CF DOCS --->
		<cfscript>
		   for ( i = 1; i LTE ArrayLen(arguments.xmlElement.XmlChildren); i = i+1)
		   {
		      if (arguments.xmlElement.XmlChildren[i].XmlName IS arguments.nodeName)
		         nodesFound = nodesFound + 1;
		   }
		</cfscript>
		<cfreturn nodesFound />
	</cffunction>

</cfcomponent>