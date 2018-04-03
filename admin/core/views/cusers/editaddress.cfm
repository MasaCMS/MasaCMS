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
	/core/
	/Application.cfc
	/index.cfm

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
	requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfset rsAddress=rc.userBean.getAddressById(rc.addressID)>
<cfset addressBean=rc.userBean.getAddressBeanById(rc.addressID)>
<cfset extendSets=application.classExtensionManager.getSubTypeByName("Address",rc.userBean.getsubtype(),rc.userBean.getSiteID()).getExtendSets(inherit=true,activeOnly=true) />
<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>

<cfoutput>
<form novalidate="novalidate" action="./?muraAction=cUsers.updateAddress&amp;userid=#esapiEncode('url',rc.userid)#&amp;routeid=#rc.routeid#&amp;siteid=#esapiEncode('url',rc.siteid)#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return userManager.submitForm(this);"  autocomplete="off" >

<div class="mura-header">
	<h1>#rbKey('user.memberaddressform')#</h1>
	<div class="nav-module-specific btn-group">
	<a class="btn" href="##" title="#esapiEncode('html',rbKey('sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="mi-arrow-circle-left"></i> #esapiEncode('html',rbKey('sitemanager.back'))#</a>
	</div>
</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
	  <div class="block-content">
				
				<h2>#esapiEncode('html',rc.userBean.getFname())# #esapiEncode('html',rc.userBean.getlname())#</h2>
					<div class="mura-control-group">
			      <label>#rbKey('user.addressname')#</label>
		      	<input id="addressName" name="addressName" type="text" value="#esapiEncode('html',rsAddress.addressName)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.address1')#</label>
		      	<input id="address1" name="address1" type="text" value="#esapiEncode('html',rsAddress.address1)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.address2')#</label>
		      	<input id="address2" name="address2" type="text" value="#esapiEncode('html',rsAddress.address2)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.city')#</label>
		      	<input id="city" name="city" type="text" value="#esapiEncode('html',rsAddress.city)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.state')#</label>
		      	<input id="state" name="state" type="text" value="#esapiEncode('html',rsAddress.state)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.zip')#</label>
		      	<input id="zip" name="zip" type="text" value="#esapiEncode('html',rsAddress.zip)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.country')#</label>
		      	<input id="country" name="country" type="text" value="#esapiEncode('html',rsAddress.country)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.phone')#</label>
		      	<input id="phone" name="phone" type="text" value="#esapiEncode('html',rsAddress.phone)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.fax')#</label>
		      	<input id="fax" name="fax" type="text" value="#esapiEncode('html',rsAddress.fax)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.website')# (#rbKey('user.includehttp')#)</label>
		      	<input id="addressURL" name="addressURL" type="text" value="#esapiEncode('html',rsAddress.addressURL)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.email')#</label>
		      	<input id="addressEmail" name="addressEmail" validate="email" message="#rbKey('user.emailvalidate')#" type="text" value="#esapiEncode('html',rsAddress.addressEmail)#">
			    </div>
					
					<div class="mura-control-group">
			      <label>#rbKey('user.hours')#</label>
		      	<textarea id="hours" rows="6" name="hours" >#esapiEncode('html',rsAddress.hours)#</textarea>
			    </div>

			<!--- extended attributes as defined in the class extension manager --->
			<cfif arrayLen(extendSets)>

			<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
			<cfset extendSetBean=extendSets[s]/>
			<cfoutput><cfset style=extendSetBean.getStyle()/><cfif not len(style)><cfset started=true/></cfif>
				<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
				<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
					<h2>#extendSetBean.getName()#</h2>
				<cfsilent>
				<cfset attributesArray=extendSetBean.getAttributes() />
				</cfsilent>
				<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
					<cfset attributeBean=attributesArray[a]/>
					<cfset attributeValue=addressBean.getExtendedAttribute(attributeBean.getAttributeID(),true) />
					<div class="mura-control-group">
			      <label>
					<cfif len(attributeBean.getHint())>
					<span data-toggle="popover" title="" data-placement="right" data-content="#esapiEncode('html',attributeBean.gethint())#" data-original-title="#attributeBean.getLabel()# <cfif attributeBean.getType() IS "Hidden"><strong>[Hidden]</strong></cfif>">#attributeBean.getLabel()# <cfif attributeBean.getType() IS "Hidden"><strong>[Hidden]</strong></cfif> <i class="mi-question-circle"></i></span>
					<cfelse>
					#attributeBean.getLabel()# <cfif attributeBean.getType() IS "Hidden"><strong>[Hidden]</strong></cfif>
					</cfif>
					<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'> <a href="#application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#attributeValue#" target="_blank">[Download]</a> <input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/> Delete</cfif>
					</label>
					<!--- if it's an hidden type attribute then flip it to be a textbox so it can be editable through the admin --->
					<cfif attributeBean.getType() IS "Hidden">
						<cfset attributeBean.setType( "TextBox" ) />
					</cfif>	
						#attributeBean.renderAttribute(attributeValue)#
					</div>
				</cfloop>
			</cfoutput>
			</cfloop>

			<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
			<cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
			<script type="text/javascript">
			initTabs(Array("#jsStringFormat(rbKey('user.basic'))#","#jsStringFormat(rbKey('user.extendedattributes'))#"),0,0,0);
			</script>	
			</cfif>

				<div class="mura-actions">
					<div class="form-actions">
						<cfif rc.addressid eq ''>
							<button class="btn mura-primary" onclick="userManager.submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i>#rbKey('user.add')#</button>
				        <cfelse>
				            <button class="btn mura-primary" onclick="userManager.submitForm(document.forms.form1,'update');"><i class="mi-check-circle"></i>#rbKey('user.update')#</button>
							<button class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(rbKey('user.deleteaddressconfirm'))#');"><i class="mi-trash"></i>#rbKey('user.delete')#</button>
				           </cfif>
			    	</div>
		    	</div>

					<input type="hidden" name="action" value="">
					<input type="hidden" name="addressID" value="#esapiEncode('html_attr',rc.addressID)#">
					<input type="hidden" name="isPublic" value="#rc.userBean.getIsPublic()#">
					<cfif not rc.userBean.getAddresses().recordcount><input type="hidden" name="isPrimary" value="1"></cfif>
				
				</cfoutput>


			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
	</div> <!-- /.block-constrain -->
</form>
