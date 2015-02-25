<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfif request.muraFrontEndRequest and this.asyncObjects>
	<cfoutput>
		<div class="mura-async-object" 
			data-object="editprofile" 
			data-returnurl="#esapiEncode('html_attr',$.event('returnurl'))#">
		</div>
	</cfoutput>
<cfelse>
	<cfsilent>
		<cfif not isdefined('request.userBean')>
			<cfset request.userBean=application.userManager.read(session.mura.userID) />
		</cfif>

		<cfparam name="msg" default="#variables.$.rbKey('user.message')#">
	</cfsilent>
	<cfoutput>
		<#variables.$.getHeaderTag('headline')#><cfif not session.mura.isLoggedIn>#variables.$.rbKey('user.createprofile')#<cfelse>#variables.$.rbKey('user.editprofile')#</cfif></#variables.$.getHeaderTag('headline')#>

		<cfif not(structIsEmpty(request.userBean.getErrors()) and request.doaction eq 'createprofile')>
			<div id="svEditProfile" class="mura-edit-profile #this.editProfileWrapperClass#">

				<cfif not structIsEmpty(request.userBean.getErrors()) >
					<div class="#this.alertDangerClass#">#variables.$.getBean('utility').displayErrors(request.userBean.getErrors())#</div>
				<cfelse>
					<div class="#this.alertDangerClass#">#msg#</div>
				</cfif>

				<!--- EDIT PROFILE FORM --->
				<!--- <a id="editSubscriptions" href="##">Edit Email Subscriptions</a> --->
				<form role="form" name="profile" id="profile" action="?nocache=1" class="#this.editProfileFormClass# <cfif this.generalWrapperClass neq "">#this.formWrapperClass#</cfif>" method="post" onsubmit="return mura.validateForm(this);"  enctype="multipart/form-data" novalidate="novalidate">
					<fieldset>
						<legend>#variables.$.rbKey('user.contactinformation')#</legend>

						<!--- First Name --->
						<div class="req #this.editProfileFormGroupWrapperClass#">
							<label class="#this.editProfileFieldLabelClass#" for="firstName">
								#variables.$.rbKey('user.fname')#
								<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
							</label>
							<div class="#this.editProfileFormFieldsWrapperClass#">
								<input class="#this.editProfileFormFieldsClass#" type="text" id="firstName" name="fname" value="#HTMLEditFormat(request.userBean.getfname())#" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('user.fnamerequired'))#" maxlength="50" placeholder="#variables.$.rbKey('user.fname')#">
							</div>
						</div>

						<!--- Last Name --->
						<div class="req #this.editProfileFormGroupWrapperClass#">
							<label class="#this.editProfileFieldLabelClass#" for="lastName">
								#variables.$.rbKey('user.lname')#
								<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
							</label>
							<div class="#this.editProfileFormFieldsWrapperClass#">
								<input class="#this.editProfileFormFieldsClass#" type="text" id="lastName" name="lname" value="#HTMLEditFormat(request.userBean.getlname())#" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('user.lnamerequired'))#" maxlength="50" placeholder="#variables.$.rbKey('user.lname')#">
							</div>
						</div>

						<!--- Username --->
						<div class="req #this.editProfileFormGroupWrapperClass#">
							<label class="#this.editProfileFieldLabelClass#" for="usernametxt">
								#variables.$.rbKey('user.username')#
								<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
							</label>
							<div class="#this.editProfileFormFieldsWrapperClass#">
								<input class="#this.editProfileFormFieldsClass#" type="text" id="usernametxt" name="username" value="#HTMLEditFormat(request.userBean.getUserName())#" data-required="true" data-message="#htmlEditFormat(variables.$.rbKey('user.usernamerequired'))#" maxlength="50" placeholder="#variables.$.rbKey('user.username')#">
							</div>
						</div>

						<!--- Company / Organization --->
						<div class="#this.editProfileFormGroupWrapperClass#">
							<label class="#this.editProfileFieldLabelClass#" for="companytxt">#variables.$.rbKey('user.organization')#</label>
							<div class="#this.editProfileFormFieldsWrapperClass#">
								<input class="#this.editProfileFormFieldsClass#" type="text" id="companytxt" name="company" value="#HTMLEditFormat(request.userBean.getCompany())#" maxlength="50" placeholder="#variables.$.rbKey('user.organization')#">
							</div>
						</div>

						<!--- Email --->
						<div class="req #this.editProfileFormGroupWrapperClass#">
							<label class="#this.editProfileFieldLabelClass#" for="emailtxt">
								#variables.$.rbKey('user.email')#
								<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
							</label>
							<div class="#this.editProfileFormFieldsWrapperClass#">
								<input class="#this.editProfileFormFieldsClass#" type="text" id="emailtxt" name="email" value="#HTMLEditFormat(request.userBean.getEmail())#" maxlength="50" data-required="true" placeholder="#variables.$.rbKey('user.email')#" data-message="#HTMLEditFormat(variables.$.rbKey('user.emailvalidate'))#">
							</div>
						</div>

						<cfif not session.mura.isloggedin>
							<!--- Email2 (for NEW USER) --->
							<div class="req #this.editProfileFormGroupWrapperClass#">
								<label class="#this.editProfileFieldLabelClass#" for="email2xt">
									#variables.$.rbKey('user.emailconfirm')#
									<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
								</label>
								<div class="#this.editProfileFormFieldsWrapperClass#">
									<input class="#this.editProfileFormFieldsClass#" type="text" id="email2xt" name="email2" value="" maxlength="50" data-required="true" data-validate="match" matchfield="email" placeholder="#variables.$.rbKey('user.emailconfirm')#" data-message="#HTMLEditFormat(variables.$.rbKey('user.emailconfirmvalidate'))#" />
								</div>
							</div>
						</cfif>

						<!--- 
							Comment out the following two password fields to automatically create a random password 
							for the user instead of letting them pick one themselves 
						--->
						<!--- Password --->
						<div class="req #this.editProfileFormGroupWrapperClass#">
							<label class="#this.editProfileFieldLabelClass#" for="passwordtxt">
								#variables.$.rbKey('user.password')#
								<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
							</label>
							<div class="#this.editProfileFormFieldsWrapperClass#">
								<input class="#this.editProfileFormFieldsClass#" type="password" name="passwordNoCache" id="passwordtxt" data-validate="match" matchfield="password2" value=""  maxlength="50" data-required="true" placeholder="#variables.$.rbKey('user.password')#" data-message="#HTMLEditFormat(variables.$.rbKey('user.passwordvalidate'))#" />
							</div>
						</div>

						<!--- Password2 --->
						<div class="req #this.editProfileFormGroupWrapperClass#">
							<label class="#this.editProfileFieldLabelClass#" for="password2txt">
								#variables.$.rbKey('user.passwordconfirm')#
								<ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins>
							</label>
							<div class="#this.editProfileFormFieldsWrapperClass#">
								<input class="#this.editProfileFormFieldsClass#" type="password" name="password2" id="password2txt" value=""  maxlength="50" data-required="true" placeholder="#variables.$.rbKey('user.passwordconfirm')#" data-message="#HTMLEditFormat(variables.$.rbKey('user.passwordconfirmrequired'))#" />
							</div>
						</div>

					</fieldset>

					<!--- INTEREST GROUPS --->
					<!--- <cfif application.categoryManager.getInterestGroupCount($.event('siteID'), TRUE)>
						<fieldset>
							<legend>#variables.$.rbKey('user.interests')#:</legend>
							<cf_dsp_categories_nest siteid="#variables.$.event('siteID')#">
						</fieldset>
					</cfif> --->

					<!--- This *should* work if you want to allow an avatar, but it hasn't been fully tested. If you need help with it, hit us up in the Mura forum.
					<fieldset>
						<legend>Upload Your Photo</legend>

							<ul class="columns2">
								<li class="col">
									<p class="inputNote">Photo must be JPG format optimized for up to 150 pixels wide.</p>
										<input type="file" name="newFile" data-validate="regex" regex="(.+)(\.)(jpg|JPG)" data-message="Your logo must be a .JPG" value=""/>
								</li>
								<li class="col">
									<cfif len(request.userBean.getPhotoFileID())>
										<img src="#variables.$.globalConfig('context')#/index.cfm/_api/render/small/?fileid=#request.userBean.getPhotoFileID()#" alt="your photo" />
										<input type="checkbox" name="removePhotoFile" value="true"> Remove current logo
								</cfif>
								</li>
							</ul>
					</fieldset>
					--->

					<!--- EXTENDED ATTRIBUTES (as defined in the class extension manager) --->
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

					<!--- Extended Attributes --->
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
										<legend>#extendSetBean.getName()#</legend>
										<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#">
										<cfset started=true>
									</cfif>

									<div class="<cfif attributeBean.getRequired()>req</cfif> #this.editProfileFormGroupWrapperClass#">
										<cfif not listFind("TextArea,MultiSelectBox",attributeBean.getType())>
											<label class="#this.editProfileFieldLabelClass#" for="ext#attributeBean.getAttributeID()#">
												#attributeBean.getLabel()#
												<cfif attributeBean.getRequired()><ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins></cfif>
												<!--- <cfif len(attributeBean.gethint())><br />#attributeBean.gethint()#</cfif> --->
											</label>
										<cfelse>
											<label class="#this.editProfileFieldLabelClass#" for="ext#attributeBean.getAttributeID()#">
												#attributeBean.getLabel()#
												<cfif attributeBean.getRequired()><ins>(#HTMLEditFormat(variables.$.rbKey('user.required'))#)</ins></cfif>
												<cfif len(attributeBean.gethint())><span class="#this.editProfileHelpBlockClass#">#attributeBean.gethint()#</span></cfif>
											</label>
										</cfif>

										<div class="#this.editProfileFormFieldsWrapperClass#">
											<cfif attributeBean.getType() neq 'TextArea'>
												#attributeBean.renderAttribute(attributeValue,true)#

												<cfif attributeBean.getType() neq "MultiSelectBox" and len(attributeBean.gethint())>
													<span class="#this.editProfileHelpBlockClass#">#attributeBean.gethint()#</span>
												</cfif>
												<!--- If it's a file --->
												<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'>
													<div class="#this.editProfileFormGroupWrapperClass#">
														<div class="#this.editProfileExtAttributeFileWrapperClass#">
															<div class="#this.editProfileExtAttributeFileCheckboxClass#">
																<label>
																	<input type="checkbox" name="extDelete#attributeBean.getAttributeID()#" value="true"/> Delete
																</label>
															</div>
														</div>
														<div class="#this.editProfileExtAttributeDownloadClass#">
															<span class="#this.editProfileHelpBlockClass#"><a class="#this.editProfileExtAttributeDownloadButtonClass#" href="#variables.$.globalConfig('context')#/tasks/render/file/index.cfm?fileID=#attributeValue#" target="_blank">Download</a></span>
														</div>
													</div>
												</cfif>
											<cfelse>
												#attributeBean.renderAttribute(attributeValue)#
											</cfif>
										</div>
									</div>
								</cfif>
							</cfloop>
						</cfloop>
					</cfif>
					<!--- @END Extended Attributes --->

					<!--- form protection --->
					<div class="#this.editProfileFormGroupWrapperClass#">
						<div class="#this.editProfileSubmitButtonWrapperClass#">
							<cfinclude template="dsp_form_protect.cfm"/>
						</div>
					</div>

					<!--- EDIT PROFILE BUTTON --->
					<div class="#this.editProfileFormGroupWrapperClass#">
						<div class="#this.editProfileSubmitButtonWrapperClass#">
							<cfif session.mura.isLoggedIn>
								<button type="submit" class="#this.editProfileSubmitButtonClass#">#htmlEditFormat(variables.$.rbKey('user.updateprofile'))#</button>
								<input type="hidden" name="userid" value="#session.mura.userID#">
								<input type="hidden" name="doaction" value="updateprofile">
							<cfelse>
								<input type="hidden" name="userid" value="">
								<input type="hidden" name="isPublic" value="1">
								<input type="hidden" name="inactive" value="0"> <!--- Set the value to "1" to require admin approval of new accounts --->
								<button type="submit" class="#this.editProfileSubmitButtonClass#">#htmlEditFormat(variables.$.rbKey('user.createprofile'))#</button>
								<input type="hidden" name="doaction" value="createprofile">
								<!--- <input type="hidden" name="groupID" value="[userid from Group Detail page url]"> Add users to a specific group --->
							</cfif>

							<input type="hidden" name="siteid" value="#HTMLEditFormat(variables.$.event('siteID'))#">
							<input type="hidden" name="returnURL" value="#HTMLEditFormat(request.returnURL)#">
							<input type="hidden" name="display" value="editprofile">
							<!--- <cfinclude template="dsp_form_protect.cfm"/> --->
						</div>
					</div>
				</form>
			</div>

			<script type="text/javascript">
				document.getElementById("profile").elements[0].focus();
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
				<div class="#this.alertDangerClass#">
					<p class="#this.editProfileSuccessMessageClass#">#variables.$.rbKey('user.thankyouinactive')#</p>
				</div>
			<cfelse>
				<div class="#this.alertDangerClass#"><p class="#this.editProfileSuccessMessageClass#">#variables.$.rbKey('user.thankyouactive')#</p></div>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
