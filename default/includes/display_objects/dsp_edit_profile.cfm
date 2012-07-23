<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfsilent>
<cfif not isdefined('request.userBean')>
<cfset request.userBean=application.userManager.read(session.mura.userID) />
</cfif>

<cfparam name="msg" default="#variables.$.rbKey('user.message')#">
<cfset variables.$.loadJSLib()>
<cfset variables.$.addToHTMLHeadQueue("htmlEditor.cfm")>
</cfsilent>
<cfoutput>

<#variables.$.getHeaderTag('headline')#><cfif not session.mura.isLoggedIn>#variables.$.rbKey('user.createprofile')#<cfelse>
#variables.$.rbKey('user.editprofile')#</cfif></#variables.$.getHeaderTag('headline')#>
<div id="svEditProfile">
<cfif not(structIsEmpty(request.userBean.getErrors()) and request.doaction eq 'createprofile')>

<cfif not structIsEmpty(request.userBean.getErrors()) >
 <div id="editProfileMsg" class="required">#variables.$.getBean('utility').displayErrors(request.userBean.getErrors())#</div>
<cfelse>
  <div id="editProfileMsg" class="required">#msg#</div>
</cfif>
	<!--- <a id="editSubscriptions" href="##">Edit Email Subscriptions</a> --->
	<form name="profile" id="profile" action="?nocache=1" method="post" onsubmit="return validate(this);"  enctype="multipart/form-data" novalidate="novalidate">
	<fieldset>
	<legend>#variables.$.rbKey('user.contactinformation')#</legend>
	<ul>
	<li>
	<label for="firstName">#variables.$.rbKey('user.fname')#<span class="required">*</span></label>
	<input type="text" id="firstName" class="text" name="fname" value="#HTMLEditFormat(request.userBean.getfname())#" required="true" message="#htmlEditFormat(variables.$.rbKey('user.fnamerequired'))#" maxlength="50"/>
	</li>
	<li>
	<label for="lastName">#variables.$.rbKey('user.lname')#<span class="required">*</span></label>
	<input type="text" id="lastName" class="text" name="lname" value="#HTMLEditFormat(request.userBean.getlname())#" required="true" message="#htmlEditFormat(variables.$.rbKey('user.lnamerequired'))#" maxlength="50"/>
	</li>
	<li>
	<label for="usernametxt">#variables.$.rbKey('user.username')#<span class="required">*</span></label>
	<input name="username" id="usernametxt" type="text" value="#HTMLEditFormat(request.userBean.getusername())#" class="text"  required="yes" message="#htmlEditFormat(variables.$.rbKey('user.usernamerequired'))#" maxlength="50">
	</li>	
	
	<li>
	<label for="companytxt">#variables.$.rbKey('user.organization')#</label>
	<input name="company" id="companytxt" type="text" value="#htmlEditFormat(request.userBean.getCompany())#" class="text" maxlength="50"/>
	</li>

       
<cfif not session.mura.isloggedin>
	<li>
	<label for="emailtxt">#variables.$.rbKey('user.email')#<span class="required">*</span></label>
	<input name="email" id="emailtxt" validate="email" type="text" value="#request.userBean.getEmail()#" class="text"  required="true" message="#HTMLEditFormat(variables.$.rbKey('user.emailvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="email2xt">#variables.$.rbKey('user.emailconfirm')#<span class="required">*</span></label>
	<input name="email2" id="email2txt" type="text" value="" class="text" validate="match" matchfield="email" required="true" message="#HTMLEditFormat(variables.$.rbKey('user.emailconfirmvalidate'))#" maxlength="50">
	
	<!--- Comment out the following two password fields to automatically create a random password for the user instead of letting them pick one themselves --->
	<li>
	<label for="passwordtxt">#variables.$.rbKey('user.password')#<span class="required">*</span></label>
	<input name="passwordNoCache" validate="match" matchfield="password2" type="password" value="" class="text"  message="#HTMLEditFormat(variables.$.rbKey('user.passwordvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="password2txt">#variables.$.rbKey('user.passwordconfirm')#<span class="required">*</span></label>
	<input  name="password2" id="password2txt" type="password" value="" required="true" class="text"  message="#HTMLEditFormat(variables.$.rbKey('user.passwordconfirmrequired'))#" maxlength="50">
	</li>
	<!--- <cfinclude template="dsp_captcha.cfm" > --->
	<cfinclude template="dsp_form_protect.cfm" >
<cfelse>
 	 <li>
	<label for="emailtxt">#variables.$.rbKey('user.email')#<span class="required">*</span></label>
	<input name="email" id="emailtxt" validate="email" type="text" value="#htmlEditFormat(request.userBean.getEmail())#" class="text"  required="true" message="#HTMLEditFormat(variables.$.rbKey('user.emailvalidate'))#" maxlength="50">
	</li>

	<li>
	<label for="passwordtxt">#variables.$.rbKey('user.password')#</label>
	<input name="passwordNoCache" validate="match" matchfield="password2" type="password" value="" class="text"  message="#HTMLEditFormat(variables.$.rbKey('user.passwordvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="password2txt">#variables.$.rbKey('user.passwordconfirm')#</label>
	<input  name="password2" id="password2txt" type="password" value="" required="false" class="text"  message="#HTMLEditFormat(variables.$.rbKey('user.passwordconfirmrequired'))#" maxlength="50">
	</li>

</cfif>

</ul>
</fieldset>

<cfif application.categoryManager.getInterestGroupCount($.event('siteID'), TRUE) >
<fieldset>
	<legend>#variables.$.rbKey('user.interests')#:</legend>		
			<cf_dsp_categories_nest siteid="#variables.$.event('siteID')#">
</fieldset>
</cfif>
<!--- This *should* work if you want to allow an avatar, but it hasn't been fully tested. If you need help with it, hit us up in the Mura forum.
<fieldset>
	<legend>Upload Your Photo</legend>
		<ul class="columns2">
			<li class="col">
				<p class="inputNote">Photo must be JPG format optimized for up to 150 pixels wide.</p>
					<input type="file" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG)" message="Your logo must be a .JPG" value=""/>
			</li>
			<li class="col">
				<cfif len(request.userBean.getPhotoFileID())>
							<img src="#variables.$.globalConfig('context')#/tasks/render/small/?fileid=#request.userBean.getPhotoFileID()#" alt="your photo" />
			<input type="checkbox" name="removePhotoFile" value="true"> Remove current logo 
			</cfif>
			</li>
		</ul>
</fieldset>
--->

<!--- extended attributes as defined in the class extension manager --->
<cfsilent>
<cfif request.userBean.getIsNew()>
	<cfset request.userBean.setSiteID(variables.$.event("siteid"))>
</cfif>
<cfif request.userBean.getIsPublic()>
<cfset userPoolID=application.settingsManager.getSite(request.userBean.getSiteID()).getPublicUserPoolID()>
<cfelse>
<cfset userPoolID=application.settingsManager.getSite(request.userBean.getSiteID()).getPrivateUserPoolID()>
</cfif>
<cfset extendSets=application.classExtensionManager.getSubTypeByName(request.userBean.gettype(),request.userBean.getsubtype(),userPoolID).getExtendSets(inherit=true,activeOnly=true) />
</cfsilent>
<cfif arrayLen(extendSets)>
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
	<cfset extendSetBean=extendSets[s]/>
		<cfsilent>
		<cfset started=false />
		<cfset attributesArray=extendSetBean.getAttributes() />
		</cfsilent>
		
		<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
		<cfset attributeBean=attributesArray[a]/>
		<cfset attributeValue=request.userBean.getExtendedAttribute(attributeBean.getAttributeID(),true)/>
			<cfif attributeBean.getType() neq "hidden">
				<cfif not started>
				<fieldset>
				<legend>#extendSetBean.getName()#</legend>
					<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
					<ul>
					<cfset started=true>
				</cfif>
				<li>
				<cfif not listFind("TextArea,MultiSelectBox",attributeBean.getType())>
					<label for="ext#attributeBean.getAttributeID()#"><cfif attributeBean.getRequired()><b>*</b></cfif>#attributeBean.getLabel()#<!--- <cfif len(attributeBean.gethint())><br />#attributeBean.gethint()#</cfif> ---></label>
				<cfelse>
					<label for="ext#attributeBean.getAttributeID()#"><cfif attributeBean.getRequired()><b>*</b></cfif>#attributeBean.getLabel()#<cfif len(attributeBean.gethint())><br/>#attributeBean.gethint()#</cfif></label>
				</cfif>
			
				<cfif attributeBean.getType() neq 'TextArea'>		
					#attributeBean.renderAttribute(attributeValue,true)#
					<cfif attributeBean.getType() neq "MultiSelectBox" and len(attributeBean.gethint())>
						<div class="inputBox rightCol" >
							<p class="fieldDescription">#attributeBean.gethint()#</p>
						</div>	
					</cfif>
					<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'>
						<div class="inputBox rightCol">
							<a href="#variables.$.globalConfig('context')#/tasks/render/file/?fileID=#attributeValue#" target="_blank">[Download]</a> 
							<br/><input type="checkbox" name="extDelete#attributeBean.getAttributeID()#" value="true"/> 
							Delete
						</div>
					</cfif>
				<cfelse>
				#attributeBean.renderAttribute(attributeValue)#
				</cfif>	
				</li>
			</cfif>	
		</cfloop>
		<cfif started>
			</ul>
			</fieldset>	
		</cfif>
		
</cfloop>
</cfif>

<div class="buttons form-actions">
	<cfif session.mura.isLoggedIn>
		<input name="submit" type="submit" class="btn" value="#HTMLEditFormat(variables.$.rbKey('user.updateprofile'))#" />
		<input type="hidden" name="userid" value="#session.mura.userID#"/>
		<input type="hidden" name="doaction" value="updateprofile">
	<cfelse>
		<input type="hidden" name="userid" value=""/>
		<input type="hidden" name="isPublic" value="1"/>
		<input type="hidden" name="inactive" value="0"/> <!--- Set the value to "1" to require admin approval of new accounts --->
		<input name="submit" type="submit"  value="#HTMLEditFormat(variables.$.rbKey('user.createprofile'))#"/>
		<input type="hidden" name="doaction" value="createprofile">
		<!--- <input type="hidden" name="groupID" value="[userid from Group Detail page url]"> Add users to a specific group --->
	</cfif> 

	<input type="hidden" name="siteid" value="#HTMLEditFormat(variables.$.event('siteID'))#" />
	<input type="hidden" name="returnURL" value="#HTMLEditFormat(request.returnURL)#" />
	<input type="hidden" name="display" value="editprofile" />
</div>
</form>
</div>
<script type="text/javascript"> 
document.getElementById("profile").elements[0].focus();
setHTMLEditors(200,"70%");
</script>
<cfelse>
<!--- This is where the script for a newly created account does if inactive is default to 1 for new accounts--->
<cfsilent>
<cfif request.userBean.getInActive() and len(getSite().getExtranetPublicRegNotify())>
<cfsavecontent variable="notifyText"><cfoutput>
A new registration has been submitted to #getSite().getSite()#

Date/Time: #now()#
#variables.$.rbKey('user.email')#: #request.userBean.getEmail()#
#variables.$.rbKey('user.username')#: #request.userBean.getUserName()#
#variables.$.rbKey('user.fname')#: #request.userBean.getFname()#
#variables.$.rbKey('user.lname')#: #request.userBean.getLname()#
</cfoutput></cfsavecontent>
<cfset email=variables.$.getBean('mailer') />
<cfset email.sendText(notifyText,
				getSite().getExtranetPublicRegNotify(),
				getSite().getSite(),
				'#getSite().getSite()# Public Registration',
				variables.$.event('siteID')) />

</cfif>
</cfsilent>

<cfif request.userBean.getInActive()>
<div id="editProfileMsg" class="required">
<p class="success">#variables.$.rbKey('user.thankyouinactive')#</p>
</div>
<cfelse>
<div id="editProfileMsg" class="required"><p class="notice">#variables.$.rbKey('user.thankyouactive')#</p></div>
</cfif>
</cfif>
</cfoutput>
