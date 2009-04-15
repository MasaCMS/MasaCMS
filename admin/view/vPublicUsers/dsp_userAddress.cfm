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

<cfset rsAddress=request.userBean.getAddressById(attributes.addressID)>
<cfoutput><form action="index.cfm?fuseaction=cPublicUsers.updateAddress&userid=#attributes.userid#&routeid=#attributes.routeid#&siteid=#attributes.siteid#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off" >
	<h2>#application.rbFactory.getKeyValue(session.rb,'user.memberaddressform')#</h2>
	
	<!--- #application.utility.displayErrors(request.addressBean.getErrors())# --->
	
	<h3>#Request.userBean.getFname()# #Request.userBean.getlname()# <a href="index.cfm?fuseaction=cPublicUsers.editUser&userid=#attributes.userid#&siteid=#attributes.siteid#&routeid=#attributes.routeid#">[#application.rbFactory.getKeyValue(session.rb,'user.back')#]</a></h3>
	
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
				<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'user.delete')#</span></a>
           </cfif>


		<input type="hidden" name="action" value="">
		<input type="hidden" name="addressID" value="#attributes.addressID#">
		<input type="hidden" name="isPublic" value="#request.userBean.getIsPublic()#">
		<cfif not request.userBean.getAddresses().recordcount><input type="hidden" name="isPrimary" value="1"></cfif>
	
	</cfoutput>

</form>