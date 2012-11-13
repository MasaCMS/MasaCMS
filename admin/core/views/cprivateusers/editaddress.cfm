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

<cfset rsAddress=rc.userBean.getAddressById(rc.addressID)>
<cfset addressBean=rc.userBean.getAddressBeanById(rc.addressID)>
<cfset extendSets=application.classExtensionManager.getSubTypeByName("Address",rc.userBean.getsubtype(),rc.userBean.getSiteID()).getExtendSets(inherit=true,activeOnly=true) />
<cfoutput>
<form novalidate="novalidate" action="index.cfm?muraAction=cPrivateUsers.updateAddress&userid=#URLEncodedFormat(rc.userid)#&routeid=#rc.routeid#&siteid=#URLEncodedFormat(rc.siteid)#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off">
	<h1>#application.rbFactory.getKeyValue(session.rb,'user.adminuseraddressform')#</h1>
	
	<div id="nav-module-specific" class="btn-group">
	<a class="btn" href="##" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="icon-circle-arrow-left"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
	</div>
	
	<h2>#HTMLEditFormat(rc.userBean.getFname())# #HTMLEditFormat(rc.userBean.getlname())#</h2>
	
<div class="fieldset-wrap">
	<div class="fieldset">
		<div class="control-group">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.addressname')#</label>
      <div class="controls"><input id="addressName" name="addressName" type="text" value="#HTMLEditFormat(rsAddress.addressName)#"  class="span6"></div>
    </div>
		
		<div class="control-group">
		<div class="span6">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.address1')#</label>
      <div class="controls"><input id="address1" name="address1" type="text" value="#HTMLEditFormat(rsAddress.address1)#"  class="span12"></div>
      </div>
		
		<div class="span6">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.address2')#</label>
      <div class="controls"><input id="address2" name="address2" type="text" value="#HTMLEditFormat(rsAddress.address2)#"  class="span12"></div>
    </div>
</div>
		
		<div class="control-group">
		<div class="span5">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.city')#</label>
      <div class="controls"><input id="city" name="city" type="text" value="#HTMLEditFormat(rsAddress.city)#" class="span12"></div>
    </div>
		
		<div class="span1">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.state')#</label>
      <div class="controls"><input id="state" name="state" type="text" value="#HTMLEditFormat(rsAddress.state)#" class="span12"></div>
    </div>
		
		<div class="span2">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.zip')#</label>
      <div class="controls"><input id="zip" name="zip" type="text" value="#HTMLEditFormat(rsAddress.zip)#" class="span12"></div>
    </div>
		
		<div class="span4">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.country')#</label>
      <div class="controls"><input id="country" name="country" type="text" value="#HTMLEditFormat(rsAddress.country)#" class="span12"></div>
    </div>
    </div>
		
		<div class="control-group">
		<div class="span6">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.phone')#</label>
      <div class="controls"><input id="phone" name="phone" type="text" value="#HTMLEditFormat(rsAddress.phone)#" class="span12"></div>
    </div>
		
		<div class="span6">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.fax')#</label>
      <div class="controls"><input id="fax" name="fax" type="text" value="#HTMLEditFormat(rsAddress.fax)#" class="span12"></div>
    </div>
    </div>
		
		<div class="control-group">
		<div class="span6">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.website')# (#application.rbFactory.getKeyValue(session.rb,'user.includehttp')#)</label>
      <div class="controls"><input id="addressURL" name="addressURL" type="text" value="#HTMLEditFormat(rsAddress.addressURL)#" class="span12"></div>
    </div>
		
		<div class="span6">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.email')#</label>
      <div class="controls"><input id="addressEmail" name="addressEmail" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#" type="text" value="#HTMLEditFormat(rsAddress.addressEmail)#" class="span12"></div>
    </div>
    </div>
		
		<div class="control-group">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.hours')#</label>
      <div class="controls"><textarea rows="6" class="span6" id="hours" name="hours" >#HTMLEditFormat(rsAddress.hours)#</textarea>
      </div>
    </div>


<!--- extended attributes as defined in the class extension manager --->
<cfif arrayLen(extendSets)>

<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
<cfset extendSetBean=extendSets[s]/>
<cfoutput><cfset style=extendSetBean.getStyle()/><cfif not len(style)><cfset started=true/></cfif>
	<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
	<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
	<div class="fieldset">
		<h2>#extendSetBean.getName()#</h2>
	<cfsilent>
	<cfset attributesArray=extendSetBean.getAttributes() />
	</cfsilent>
	<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
		<cfset attributeBean=attributesArray[a]/>
		<cfset attributeValue=addressBean.getExtendedAttribute(attributeBean.getAttributeID(),true) />
		<div class="control-group">
      <label class="control-label">
		<cfif len(attributeBean.getHint())>
		<a href="##" rel="tooltip" title="#HTMLEditFormat(attributeBean.gethint())#">#attributeBean.getLabel()# <cfif attributeBean.getType() IS "Hidden"><strong>[Hidden]</strong></cfif> <i class="icon-question-sign"></i></a>
		<cfelse>
		#attributeBean.getLabel()# <cfif attributeBean.getType() IS "Hidden"><strong>[Hidden]</strong></cfif>
		</cfif>
		<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'> <a href="#application.configBean.getContext()#/tasks/render/file/?fileID=#attributeValue#" target="_blank">[Download]</a> <input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/> Delete</cfif>
		</label>
     
		
		<!--- if it's an hidden type attribute then flip it to be a textbox so it can be editable through the admin --->
		<cfif attributeBean.getType() IS "Hidden">
			<cfset attributeBean.setType( "TextBox" ) />
		</cfif>	
		
		 <div class="controls">#attributeBean.renderAttribute(attributeValue)#</div></div>
	</cfloop>
	</div>
</cfoutput>
</cfloop>

</cfif>
</div>
	<div class="form-actions">
		<cfif rc.addressid eq ''>
        
				<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'user.add')#" />
           <cfelse>
            	<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
				<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" />
           </cfif>
    </div>
		<input type="hidden" name="action" value="">
		<input type="hidden" name="addressID" value="#rc.addressID#">
		<input type="hidden" name="isPublic" value="#rc.userBean.getIsPublic()#">
		<cfif find("activeTab",rc.returnURL)>
		<input type="hidden" name="returnURL" value="#rc.returnURL#" />
		<cfelse>
		<input type="hidden" name="returnURL" value="#rc.returnURL#&activeTab=1" />
		</cfif>
		<cfif not rc.userBean.getAddresses().recordcount><input type="hidden" name="isPrimary" value="1"></cfif>

	</cfoutput>

</div>
</form>