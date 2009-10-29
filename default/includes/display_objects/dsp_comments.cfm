<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfif not listFind("Portal,Gallery",request.contentBean.getType())>

<cfsilent>
	<cfparam name="request.subscribe" default="0">
	<cfparam name="request.remember" default="0">
	<cfparam name="cookie.name" default="">
	<cfparam name="cookie.email" default="">
	<cfparam name="cookie.url" default="">
	<cfparam name="cookie.remember" default="0">
	<cfparam name="cookie.subscribe" default="0">
	
	<cfset errorJSTxt = "">
	
	<cfif not structKeyExists(request,"name")>
		<cfset request.name=cookie.name>
	</cfif>
	
	<cfif not structKeyExists(request,"url")>
		<cfset request.url=cookie.url>
	</cfif>
	
	<cfif not structKeyExists(request,"email")>
		<cfset request.email=cookie.email>
	</cfif>
	
	<cfif not structKeyExists(request,"subscribe")>
		<cfset request.subscribe=cookie.subscribe>
	</cfif>
	
	<cfif not structKeyExists(request,"remember")>
		<cfset request.remember=cookie.remember>
	</cfif>
	
	<cfset rbFactory=getSite().getRBFactory() />
	<cfset theContentID=request.contentBean.getcontentID()>
	<cfset request.isEditor=(isUserInRole('S2IsPrivate;#application.settingsManager.getSite(request.siteid).getPrivateUserPoolID()#') 
			and application.permUtility.getnodePerm(request.crumbdata) neq 'none') 
			or isUserInRole("S2")>
	<cfparam name="request.commentid" default="">
	<cfparam name="request.comments" default="">
	<cfparam name="request.securityCode" default="">
	<cfparam name="session.securityCode" default="">
	<cfparam name="request.deletecommentid" default="">
	<cfparam name="request.approvedcommentid" default="">
	<cfparam name="request.isApproved" default="1">
	<cfparam name="request.hkey" default="">
	<cfparam name="request.ukey" default="">
	
	<cfset errors=structNew()/>
	
	<cfif structKeyExists(request,"commentUnsubscribe")>
		<cfset application.contentManager.commentUnsubscribe(request.contentBean.getContentID(),request.commentUnsubscribe,request.siteID)>
		<cfset errors["unsubscribe"]=rbFactory.getKey('comments.youhaveunsubscribed')>
	</cfif>

	<cfif request.commentid neq '' and request.comments neq '' and request.name neq ''>
	
		<cfset passedProtect = true>
		<cfscript>
			myRequest = structNew();
			StructAppend(myRequest, url, "no");
			StructAppend(myRequest, form, "no");
		</cfscript>
		
		<cfif structKeyExists(myRequest, "useProtect")>
			<cfset cffp = CreateObject("component","cfformprotect.cffpVerify").init() />
			
			<cfif application.settingsManager.getSite(request.siteID).getContactEmail() neq "">
				<cfset cffp.updateConfig('emailServer', application.settingsManager.getSite(request.siteID).getMailServerIP())>
				<cfset cffp.updateConfig('emailUserName', application.settingsManager.getSite(request.siteID).getMailserverUsername(true))>
				<cfset cffp.updateConfig('emailPassword', application.settingsManager.getSite(request.siteID).getMailserverPassword())>
				<cfset cffp.updateConfig('emailFromAddress', application.settingsManager.getSite(request.siteID).getMailserverUsernameEmail())>
				<cfset cffp.updateConfig('emailToAddress', application.settingsManager.getSite(request.siteID).getContactEmail())>
				<cfset cffp.updateConfig('emailSubject', 'Spam form submission')>
			</cfif>
			
			<cfset passedProtect = cffp.testSubmission(myRequest)>
		</cfif>
		
		<cfif (request.hkey eq '' or request.hKey eq hash(lcase(request.ukey))) and passedProtect>
	
			<cfset submittedData=application.utility.filterArgs(request,application.badwords)/>
			<cfset submittedData.contentID=theContentID />
			<cfset submittedData.isApproved=application.settingsManager.getSite(request.siteid).getCommentApprovalDefault() />
			<cfset commentBean=application.contentManager.saveComment(submittedData,event.getContentRenderer()) />			
			<cfset request.comments=""/>
			<cfif not (request.remember)>	
				<cfset request.name=""/>
				<cfset request.email=""/>
				<cfset request.url=""/>
				<cfset request.subscribe=0/>
				<cfset request.remember=0/>
			</cfif>		
			<cfif not application.settingsManager.getSite(request.siteid).getCommentApprovalDefault() eq 1>
				<cfset commentBean.sendNotification() />
			</cfif>
			<cfif isBoolean(request.remember) and request.remember>
				<cfcookie name="remember" value="1">
				<cfcookie name="subscribe" value="#request.subscribe#">
				<cfcookie name="name" value="#request.name#">
				<cfcookie name="url" value="#request.url#">
				<cfcookie name="email" value="#request.email#">
			<cfelse>
				<cfcookie name="remember" value="0">
				<cfcookie name="subscribe" value="0">
				<cfcookie name="name" value="">
				<cfcookie name="url" value="">
				<cfcookie name="email" value="">
			</cfif>
		<cfelse>
			<cfsavecontent variable="errorJSTxt">	
				<script type="text/javascript" language="javascript">
					addLoadEvent(function(){
						window.location.hash="errors";
					});
				</script>
			</cfsavecontent>
			
			<cfif passedProtect>
				<cfset errors["SecurityCode"]=rbFactory.getKey('captcha.error')>
			<cfelse>
				<cfset errors["Spam"] = rbFactory.getKey("captcha.spam")>
			</cfif>
			
		</cfif>
	</cfif>

	<cfif request.isEditor and request.deletecommentid neq "" >
		<cfset application.contentManager.deleteComment(request.deletecommentid) />
	</cfif>

	<cfif request.isEditor and request.approvedcommentid neq "" >
		<cfset application.contentManager.approveComment(request.approvedcommentid,event.getContentRenderer()) />
	</cfif>

	<cfset rsComments=application.contentManager.readComments(thecontentID,request.siteid,request.isEditor) />

	</cfsilent>
	<!--- <cfset TotalRecords=rsComments.RecordCount>
	<cfset RecordsPerPage=10> 
	<cfset NumberOfPages=Ceiling(TotalRecords/RecordsPerPage)>
	<cfset CurrentPageNumber=Ceiling(request.StartRow/RecordsPerPage)> --->	
	<a name="comments"></a>
	<div id="svComments">
	<cfif rsComments.recordcount>
		<cfoutput><#getHeaderTag('subHead1')#>#rbFactory.getKey('comments.comments')#</#getHeaderTag('subHead1')#></cfoutput>
			<!--- This was for the "Guestbook" style comments with pagination 
			<cfif numberofpages gt 1><p class="moreResults"><#getHeaderTag('subHead2')#>More Results:</#getHeaderTag('subHead2')#> 
				<cfloop from="1"  to="#numberofpages#" index="i">
				<cfoutput><ul>
				<cfif currentpagenumber eq i><li class="current">#i#</li><cfelse><li><a href="index.cfm?startrow=#evaluate('(#i#*#recordsperpage#)-#recordsperpage#+1')#">#i#</a></li></cfif>
				<cfif currentpagenumber lt numberofpages and not i mod 15></cfif></ul></cfoutput></cfloop></p>
			</cfif> --->	
		<cfoutput query="rsComments"  startrow="#request.startrow#">
		<cfset class=iif(rsComments.currentrow eq 1,de('first'),de(iif(rsComments.currentrow eq rsComments.recordcount,de('last'),de(''))))>
		<dl class="#class#">
			<dt><cfif rsComments.url neq ''><a href="#rsComments.url#" target="_blank">#htmleditformat(rsComments.name)#</a><cfelse>#htmleditformat(rsComments.name)# </cfif> <cfif request.isEditor and rsComments.email neq ''><a href="javascript:noSpam('#listFirst(htmlEditFormat(rsComments.email),'@')#','#listlast(HTMLEditFormat(rsComments.email),'@')#')" onfocus="this.blur();">#rbFactory.getKey('comments.email')#</a></cfif></dt>
			<dd class="comment">#setParagraphs(htmleditformat(rsComments.comments))#</dd>
			<dd class="dateTime">#LSDateFormat(rsComments.entered,"long")#, #LSTimeFormat(rsComments.entered,"short")# <cfif request.isEditor> | <a href="index.cfm?deletecommentid=#rscomments.commentid#&nocache=1" onClick="return confirm('Delete Comment?');">#rbFactory.getKey('comments.delete')#</a> <cfif rsComments.isApproved neq 1> | <a href="index.cfm?approvedcommentid=#rscomments.commentid#&nocache=1" onClick="return confirm('Approve Comment?');">#rbFactory.getKey('comments.approve')#</a></cfif></cfif></dd>
		</dl>
		</cfoutput>
		<!--- This was for the "Guestbook" style comments with pagination
		<cfif numberofpages gt 1><div class="moreResults"><#getHeaderTag('subHead2')#>More Results:</#getHeaderTag('subHead2')#> 
			<cfloop from="1"  to="#numberofpages#" index="i">
			<cfoutput><ul>
			<cfif currentpagenumber eq i><li class="current">#i#</li><cfelse><li><a href="index.cfm?startrow=#evaluate('(#i#*#recordsperpage#)-#recordsperpage#+1')#">#i#</a></li></cfif>
			<cfif currentpagenumber lt numberofpages and not i mod 15></cfif></ul></cfoutput></cfloop></div>
		</cfif>	--->
	</cfif>

<cfif not structIsEmpty(errors) >
	<cfoutput>
	#errorJSTxt#
	<a name="errors"></a>
	<div id="editProfileMsg" class="required">
		#application.utility.displayErrors(errors)#
	</div>
</cfoutput>
<cfelseif request.commentid neq '' and application.settingsManager.getSite(request.siteid).getCommentApprovalDefault() neq 1>
	<div id="editProfileMsg" class="required"><cfoutput>#rbFactory.getKey('comments.postedsoon')#</cfoutput></div>
</cfif>

	<form method="post" name="addComment" action="?nocache=1" onsubmit="return validate(this);" >
		<fieldset>
			<cfoutput><legend>#rbFactory.getKey('comments.postacomment')#</legend>
			<ol>
				<li class="req">
					<label for="txtName">#rbFactory.getKey('comments.name')#<ins> (#rbFactory.getKey('comments.required')#)</ins></label>
					<input id="txtName" name="name" type="text" size="38" class="text" maxlength="50" required="true" message="#htmlEditFormat(rbFactory.getKey('comments.namerequired'))#" value="#HTMLEditFormat(request.name)#"/>
				</li>
				<li class="req">
					<label for="txtEmail">#rbFactory.getKey('comments.email')#</label>
					<input id="txtEmail" name="email" type="text" size="38" class="text" maxlength="50" required="true" message="#htmlEditFormat(rbFactory.getKey('comments.emailvalidate'))#"value="#HTMLEditFormat(request.email)#"/>
				</li>
				<li>
					<label for="txtUrl">#rbFactory.getKey('comments.url')#</label>
					<input id="txtUrl" name="url" type="text" size="38" class="text" maxlength="50" value="#HTMLEditFormat(request.url)#"/>
				</li>
				<li class="req">
					<label for="txtComment">#rbFactory.getKey('comments.comment')#<ins> (#rbFactory.getKey('comments.required')#)</ins></label>
					<textarea id="txtComment" name="comments" message="#htmlEditFormat(rbFactory.getKey('comments.commentrequired'))#" cols="30" rows="20" required="true">#HTMLEditFormat(request.comments)#</textarea>
				</li>
				<li>
					<label for="txtRemember">#rbFactory.getKey('comments.rememberinfo')#</label>
					<input type="checkbox" id="txtRemember" name="remember" value="1"<cfif isBoolean(request.remember) and request.remember> checked="checked"</cfif> />
				</li>
				<li>
					<label for="txtSubscribe">#rbFactory.getKey('comments.subscribe')#</label>
					<input type="checkbox" id="txtSubscribe" name="subscribe" value="1"<cfif isBoolean(request.subscribe) and request.subscribe> checked="checked"</cfif> />
				</li></cfoutput>
				<cfinclude template="dsp_form_protect.cfm" >
			</ol>
		</fieldset>
		<div class="buttons">
			<cfoutput><p class="required">#rbFactory.getKey('comments.requiredfield')#</p>
			<input type="hidden" name="returnURL" value="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.contentRenderer.getCurrentURL()#" />
			<input type="hidden" name="commentid" value="#createuuid()#" />
			<input type="submit" class="submit" name="submit" value="#htmlEditFormat(rbFactory.getKey('comments.submit'))#" /></cfoutput>
		</div>
	</form>
</div>
</cfif>