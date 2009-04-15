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


<!--- CFWebstore®, version 6.10 --->

<!--- CFWebstore® is ©Copyright 1998-2007 by Dogpatch Software, All Rights Reserved. This code may not be copied or sold without permission of the original author. Dogpatch Software may be contacted at info@cfwebstore.com --->

<!--- This is the shopping.giftregistry circuit. It allows customers to create, manage and purchase items from a gift registry. --->
	
<cfset Webpage_title = "Gift Registry">
	
<cfif isdefined("attributes.manage")>

	<!---- check that a user is logged in 
	dsp_login_Required="dsp_please_login_wishlist.cfm" 
	--->
	<cfmodule template="../../access/secure.cfm"
		keyname="login"
		requiredPermission="0"
		>	
				
	<!--- Make sure user has access to this registry --->
	<cfif IsDefined("attributes.GiftRegistry_ID") AND attributes.GiftRegistry_ID IS NOT 0>
		<cfmodule template="../../access/useraccess.cfm" type="registry" ID="#attributes.GiftRegistry_ID#">
	<cfelse>
		<cfset useraccess = "Yes">
	</cfif>
	
	
	<cfif ispermitted AND useraccess>
		
		<cfset variables.UID = Session.User_ID>
		
		<!--- Run the various gift registry management functions --->
		
		<!--- User's Registry List --->
		<cfif CompareNoCase(attributes.manage, "list") IS 0>			
			<cfinclude template="qry_get_giftregistries.cfm">
			
			<cfif NOT qry_get_registries.recordcount>
				<cflocation url="#request.self#?fuseaction=shopping.giftregistry&manage=add#request.token2#" addtoken="No">
			<cfelse>
				<cfinclude template="manager/dsp_giftregistries.cfm">
			</cfif>		
			
		<!--- Add New Registry --->
		<cfelseif CompareNoCase(attributes.manage, "add") IS 0>
			<cfinclude template="manager/dsp_giftregistry_form.cfm">
		
		<cfelseif CompareNoCase(attributes.manage, "edit") IS 0>
			<cfinclude template="manager/dsp_giftregistry_form.cfm">
			
		<cfelseif CompareNoCase(attributes.manage, "act") IS 0>
			<cfinclude template="manager/act_giftregistry.cfm">			
			<cfset attributes.XFA_success="fuseaction=shopping.giftregistry&manage=list">
			<cfset attributes.box_title="Gift Registry">
			<cfinclude template="../../includes/form_confirmation.cfm">		
		
		<cfelseif CompareNoCase(attributes.manage, "additem") IS 0>
			<!--- Add selected product to registry --->
			<cfinclude template="manager/act_add_item.cfm">		
			
		<cfelseif CompareNoCase(attributes.manage, "additems") IS 0>	
			<!--- Add items from shopping cart to registry --->
			<cfinclude template="manager/act_add_items.cfm">	
		
		<cfelseif CompareNoCase(attributes.manage, "print") IS 0>
			<cfinclude template="qry_get_giftregistry.cfm">
			<cfif qry_get_giftregistry.recordcount>
				<cfinclude template="qry_get_items.cfm">
				<cfinclude template="manager/dsp_print_registry.cfm">
			<cfelse>
				<cfset attributes.XFA_success="fuseaction=shopping.giftregistry&manage=list">
				<cfset attributes.box_title="Gift Registry">
				<cfset attributes.error_message="Sorry, Registry Not Found.">
				<cfinclude template="../../includes/form_confirmation.cfm">			
			</cfif>	
			
		<!--- View Registry & add Items --->
		<cfelseif CompareNoCase(attributes.manage, "items") IS 0>
			<cfinclude template="qry_get_giftregistry.cfm">
			<cfif qry_get_giftregistry.recordcount>
				<cfinclude template="qry_get_items.cfm">
				<cfinclude template="manager/dsp_items_form.cfm">
			<cfelse>
				<cfset attributes.XFA_success="fuseaction=shopping.giftregistry&manage=list">
				<cfset attributes.box_title="Gift Registry">
				<cfset attributes.error_message="Sorry, Registry Not Found.">
				<cfinclude template="../../includes/form_confirmation.cfm">			
			</cfif>
		
		
		<cfelseif CompareNoCase(attributes.manage, "actitems") IS 0>
			<cfif isdefined("attributes.KeepShopping") OR isdefined("attributes.KeepShopping.x")>
				<cflocation url="#session.page#" addtoken="no">
			<cfelse>
				<cfinclude template="manager/act_items_form.cfm">			
				<cfset attributes.XFA_success="fuseaction=shopping.giftregistry&manage=items&giftregistry_ID=#attributes.giftregistry_ID#">
			
				<cfset attributes.box_title="Gift Registry">
				<cfinclude template="../../includes/form_confirmation.cfm">
			</cfif>		
		
		<!--- Email Friends --->
		<cfelseif CompareNoCase(attributes.manage, "notify") IS 0>
			<cfinclude template="manager/dsp_notify.cfm">	
			
		</cfif>
		
	<cfelseif NOT useraccess>
		<cfset attributes.message = "You do not have permissions to access this gift registry.">
		<cfparam name="attributes.XFA_success" default="fuseaction=shopping.giftregistry">
		<cfinclude template="../../includes/form_confirmation.cfm">
		
	</cfif><!--- Login and Access Check --->
	
<!--- ===== PUBLIC ACTIONS === --->
<cfelseif isdefined("attributes.do")>
	
	<cfset variables.UID = "">
	
	<!--- View Search Results --->
	<cfif CompareNoCase(attributes.do, "results") IS 0>
			<cfinclude template="qry_get_giftregistries.cfm">		

			<cfif qry_Get_registries.recordcount is 1>
				<cflocation url="#request.self#?fuseaction=shopping.giftregistry&do=display&giftregistry_ID=#qry_Get_registries.GiftRegistry_ID##request.token2#" addtoken="No">
			<cfelse>
				<cfinclude template="dsp_results.cfm">		
			</cfif>
				
		
		<cfelseif CompareNoCase(attributes.do, "display") IS 0>				
		<!--- View Registry Items --->
			<cfinclude template="qry_get_giftregistry.cfm">	
			<cfinclude template="qry_get_items.cfm">		
			<cfinclude template="dsp_giftregistry.cfm">			
		
		<cfelseif CompareNoCase(attributes.do, "cart") IS 0>
		<!--- Add Registry Items to shopping cart --->
			<cfinclude template="act_giftregistry_cart.cfm">
			<cfinclude template="../basket/act_recalc.cfm">
			<cfinclude template="../basket/do_basket.cfm">
				
	</cfif>

<cfelse><!--- MENU --->	

	<!--- if shortcut link is used (index.cfm?fuseaction=shopping.giftregistry&ID=3), forward. --->
	<cfif isdefined("attributes.ID")>

		<cflocation url="#request.self#?fuseaction=shopping.giftregistry&do=display&giftregistry_ID=#attributes.ID##request.Token2#" addtoken="No">
	
	</cfif>

	<cfinclude template="dsp_home.cfm">
	
</cfif>

