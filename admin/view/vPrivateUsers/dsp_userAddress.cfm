<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfset rsAddress=request.userBean.getAddressById(attributes.addressID)>
<cfoutput><form action="index.cfm?fuseaction=cPrivateUsers.updateAddress&userid=#attributes.userid#&routeid=#attributes.routeid#&siteid=#attributes.siteid#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off" >
	<h2>#application.rbFactory.getKeyValue(session.rb,'user.adminuseraddressform')#</h2>
	
	<!--- #application.utility.displayErrors(request.addressBean.getErrors())# --->
	
	<h3>#Request.userBean.getFname()# #Request.userBean.getlname()# <cfif find("activeTab",attributes.returnURL)><a href="index.cfm?#attributes.returnURL#"><cfelse><a href="index.cfm?#attributes.returnURL#&activeTab=1"></cfif>[#application.rbFactory.getKeyValue(session.rb,'user.back')#]</a></h3>
	
		<dl class="oneColumn">
		<dt class="first"></dt>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.addressname')#</dt>
		<dd><input id="addressName" name="addressName" type="text" value="#HTMLEditFormat(rsAddress.addressName)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address1')#</dt>
		<dd><input id="address1" name="address1" type="text" value="#HTMLEditFormat(rsAddress.address1)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address2')#</dt>
		<dd><input id="address2" name="address2" type="text" value="#HTMLEditFormat(rsAddress.address2)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.city')#</dt>
		<dd><input id="city" name="city" type="text" value="#HTMLEditFormat(rsAddress.city)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.state')#</dt>
		<dd><input id="state" name="state" type="text" value="#HTMLEditFormat(rsAddress.state)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.zip')#</dt>
		<dd><input id="zip" name="zip" type="text" value="#HTMLEditFormat(rsAddress.zip)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.country')#</dt>
		<dd><input id="country" name="country" type="text" value="#HTMLEditFormat(rsAddress.country)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.phone')#</dt>
		<dd><input id="phone" name="phone" type="text" value="#HTMLEditFormat(rsAddress.phone)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.fax')#</dt>
		<dd><input id="fax" name="fax" type="text" value="#HTMLEditFormat(rsAddress.fax)#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.website')# (#application.rbFactory.getKeyValue(session.rb,'user.includehttp')#)</dt>
		<dd><input id="addressURL" name="addressURL" type="text" value="#HTMLEditFormat(rsAddress.addressURL)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#</dt>
		<dd><input id="addressEmail" name="addressEmail" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#" type="text" value="#HTMLEditFormat(rsAddress.addressEmail)#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.hours')#</dt>
		<dd><textarea id="hours" name="hours" >#HTMLEditFormat(rsAddress.hours)#</textarea></dd>   
</dl>

	
		<cfif attributes.addressid eq ''>
        
				<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'user.add')#</span></a>
           <cfelse>
            	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'user.update')#</span></a>
				<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm')#</span></a>
           </cfif>


		<input type="hidden" name="action" value="">
		<input type="hidden" name="addressID" value="#attributes.addressID#">
		<input type="hidden" name="isPublic" value="#request.userBean.getIsPublic()#">
		<cfif find("activeTab",attributes.returnURL)>
		<input type="hidden" name="returnURL" value="#attributes.returnURL#" />
		<cfelse>
		<input type="hidden" name="returnURL" value="#attributes.returnURL#&activeTab=1" />
		</cfif>
		<cfif not request.userBean.getAddresses().recordcount><input type="hidden" name="isPrimary" value="1"></cfif>

	</cfoutput>

</form>