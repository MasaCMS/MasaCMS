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

<cfsilent>
<cfif not isdefined('request.userBean')>
<cfset request.userBean=application.userManager.read(listFirst(getAuthUser(),"^")) />
</cfif>
<cfset rbFactory=getSite().getRBFactory() />
<cfparam name="msg" default="#rbFactory.getKey('user.message')#">
<cfparam name="request.categoryID" default="">
<cfset addToHTMLHeadQueue("fckeditor.cfm")>
</cfsilent>
<cfoutput>

<h2><cfif getAuthUser() eq ''>#rbFactory.getKey('user.createprofile')#<cfelse>
#rbFactory.getKey('user.editprofile')#</cfif></h2>
<div id="svEditProfile">
<cfif not(structIsEmpty(request.userBean.getErrors()) and request.doaction eq 'createprofile')>

<cfif not structIsEmpty(request.userBean.getErrors()) >
 <div id="editProfileMsg" class="required">#application.utility.displayErrors(request.userBean.getErrors())#</div>
<cfelse>
  <div id="editProfileMsg" class="required">#msg#</div>
</cfif>
	<!--- <a id="editSubscriptions" href="##">Edit Email Subscriptions</a> --->
	<form name="profile" id="profile" action="#application.configBean.getIndexFile()#?nocache=1" method="post" onsubmit="return validate(this);"  enctype="multipart/form-data">
	<fieldset>
	<legend>#rbFactory.getKey('user.contactinformation')#</legend>
	<ul>
	<li>
	<label for="firstName">#rbFactory.getKey('user.fname')#<span class="required">*</span></label>
	<input type="text" id="firstName" class="text" name="fname" value="#HTMLEditFormat(request.userBean.getfname())#" required="true" message="#htmlEditFormat(rbFactory.getKey('user.fnamerequired'))#" maxlength="50"/>
	</li>
	<li>
	<label for="lastName">#rbFactory.getKey('user.lname')#<span class="required">*</span></label>
	<input type="text" id="lastName" class="text" name="lname" value="#HTMLEditFormat(request.userBean.getlname())#" required="true" message="#htmlEditFormat(rbFactory.getKey('user.lnamerequired'))#" maxlength="50"/>
	</li>
	<li>
	<label for="usernametxt">#rbFactory.getKey('user.username')#<span class="required">*</span></label>
	<input name="username" id="usernametxt" type="text" value="#HTMLEditFormat(request.userBean.getusername())#" class="text"  required="yes" message="#htmlEditFormat(rbFactory.getKey('user.usernamerequired'))#" maxlength="50">
	</li>	
	
	<li>
	<label for="companytxt">#rbFactory.getKey('user.organization')#</label>
	<input name="company" id="companytxt" type="text" value="#htmlEditFormat(request.userBean.getCompany())#" class="text" maxlength="50"/>
	</li>

       
<cfif getAuthUser() eq ''>
	<li>
	<label for="emailtxt">#rbFactory.getKey('user.email')#<span class="required">*</span></label>
	<input name="email" id="emailtxt" validate="email" type="text" value="#request.userBean.getEmail()#" class="text"  required="true" message="#HTMLEditFormat(rbFactory.getKey('user.emailvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="email2xt">#rbFactory.getKey('user.emailconfirm')#<span class="required">*</span></label>
	<input name="email2" id="email2txt" type="text" value="" class="text" validate="match" matchfield="email" required="true" message="T#HTMLEditFormat(rbFactory.getKey('user.emailconfirmvalidate'))#" maxlength="50">
	
	<!--- Comment out the following two password fields to automatically create a random password for the user instead of letting them pick one themselves --->
	<li>
	<label for="passwordtxt">#rbFactory.getKey('user.password')#<span class="required">*</span></label>
	<input name="passwordNoCache" validate="match" matchfield="password2" type="password" value="" class="text"  message="#HTMLEditFormat(rbFactory.getKey('user.passwordvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="password2txt">#rbFactory.getKey('user.passwordconfirm')#<span class="required">*</span></label>
	<input  name="password2" id="password2txt" type="password" value="" required="true" class="text"  message="#HTMLEditFormat(rbFactory.getKey('user.passwordconfirmrequired'))#" maxlength="50">
	</li>
	<!--- <cfinclude template="dsp_captcha.cfm" > --->
	<cfinclude template="dsp_form_protect.cfm" >
<cfelse>
 	 <li>
	<label for="emailtxt">#rbFactory.getKey('user.email')#<span class="required">*</span></label>
	<input name="email" id="emailtxt" validate="email" type="text" value="#htmlEditFormat(request.userBean.getEmail())#" class="text"  required="true" message="#HTMLEditFormat(rbFactory.getKey('user.emailvalidate'))#" maxlength="50">
	</li>

	<li>
	<label for="passwordtxt">#rbFactory.getKey('user.password')#</label>
	<input name="passwordNoCache" validate="match" matchfield="password2" type="password" value="" class="text"  message="#HTMLEditFormat(rbFactory.getKey('user.passwordvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="password2txt">#rbFactory.getKey('user.passwordconfirm')#</label>
	<input  name="password2" id="password2txt" type="password" value="" required="false" class="text"  message="#HTMLEditFormat(rbFactory.getKey('user.passwordconfirmrequired'))#" maxlength="50">
	</li>

</cfif>

</ul>
</fieldset>

<cfif application.categoryManager.getCategoryCount(request.siteid)>
<fieldset>
	<legend>#rbFactory.getKey('user.interests')#:</legend>		
			<cf_dsp_categories_nest siteid="#request.siteid#">
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
							<img src="#application.configBean.getContext()#/tasks/render/small/?fileid=#request.userBean.getPhotoFileID()#" alt="your photo" />
			<input type="checkbox" name="removePhotoFile" value="true"> Remove current logo 
			</cfif>
			</li>
		</ul>
</fieldset>
--->

<!--- extended attributes as defined in the class extension manager --->
<cfsilent>
<cfset extendSets=application.classExtensionManager.getSubTypeByName(request.userBean.gettype(),request.userBean.getsubtype(),request.siteid).getExtendSets(true) />
</cfsilent>
<cfif arrayLen(extendSets)>
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
	<cfset extendSetBean=extendSets[s]/>
	<fieldset>
	<legend>#extendSetBean.getName()#</legend>
		<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
		<cfsilent>
		<cfset attributesArray=extendSetBean.getAttributes() />
		</cfsilent>
		<ul>
		<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
		<cfset attributeBean=attributesArray[a]/>
		<cfset attributeValue=request.userBean.getExtendedAttribute(attributeBean.getAttributeID(),true)/>
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
						<a href="#application.configBean.getContext()#/tasks/render/file/?fileID=#attributeValue#" target="_blank">[Download]</a> 
						<br/><input type="checkbox" name="extDelete#attributeBean.getAttributeID()#" value="true"/> 
						Delete
					</div>
				</cfif>
			<cfelse>
			#attributeBean.renderAttribute(attributeValue)#
			</cfif>	
			</li>
		</cfloop>
		</ul>
	</fieldset>
</cfloop>
</cfif>

<cfif getAuthUser() neq ''>
	<input name="submit" type="submit"  value="#HTMLEditFormat(rbFactory.getKey('user.updateprofile'))#" />
	<input type="hidden" name="userid" value="#listgetat(getAuthUser(),1,'^')#"/>
	<input type="hidden" name="doaction" value="updateprofile">
<cfelse>
	<input type="hidden" name="userid" value=""/>
	<input type="hidden" name="isPublic" value="1"/>
	<input type="hidden" name="inactive" value="0"/> <!--- Set the value to "1" to require admin approval of new accounts --->
	<input name="submit" type="submit"  value="#HTMLEditFormat(rbFactory.getKey('user.createprofile'))#"/>
	<input type="hidden" name="doaction" value="createprofile">
	<!--- <input type="hidden" name="groupID" value="[userid from Group Detail page url]"> Add users to a specific group --->
</cfif> 

<input type="hidden" name="siteid" value="#request.siteid#" />
<input type="hidden" name="returnURL" value="#request.returnURL#" />
<input type="hidden" name="display" value="editprofile" />
</form>
</div>
<script type="text/javascript"> 
document.getElementById("profile").elements[0].focus();
setHTMLEditors(200,500);
</script>
<cfelse>
<!--- This is where the script for a newly created account does if inactive is default to 1 for new accounts--->
<cfsilent>
<cfif request.userBean.getInActive() and len(getSite().getExtranetPublicRegNotify())>
<cfsavecontent variable="notifyText"><cfoutput>
A new registration has been submitted to #getSite().getSite()#

Date/Time: #now()#
#rbFactory.getKey('user.email')#: #request.userBean.getEmail()#
#rbFactory.getKey('user.username')#: #request.userBean.getUserName()#
#rbFactory.getKey('user.fname')#: #request.userBean.getFname()#
#rbFactory.getKey('user.lname')#: #request.userBean.getLname()#
</cfoutput></cfsavecontent>
<cfset email=application.serviceFactory.getBean('mailer') />
<cfset email.sendText(notifyText,
				getSite().getExtranetPublicRegNotify(),
				getSite().getSite(),
				'#getSite().getSite()# Public Registration',
				request.siteid) />

</cfif>
</cfsilent>

<cfif request.userBean.getInActive()>
<div id="editProfileMsg" class="required">
<p class="success">#rbFactory.getKey('user.thankyouinactive')#</p>
</div>
<cfelse>
<div id="editProfileMsg" class="required"><p class="notice">#rbFactory.getKey('user.thankyouactive')#</p></div>
</cfif>
</cfif>
</cfoutput>
