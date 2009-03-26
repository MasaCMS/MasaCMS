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

