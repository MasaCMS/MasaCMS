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

<cfsilent>
<cfif not isdefined("session.cart")>
<cfset session.cart=createObject("component","cart")> 
</cfif>

<cfparam name="request.item_number" default="" >
<cfparam name="request.item_name" default="" >
<cfparam name="request.amount" default="0" >
<cfparam name="request.quantity" default="0" >
<cfparam name="request.shipping" default="0" >
<cfparam name="request.shipping2" default="0" >
<cfparam name="request.handling" default="0" >
<cfparam name="request.on0" default="" >
<cfparam name="request.os0" default="" >
<cfparam name="request.on1" default="" >
<cfparam name="request.os1" default="" >

<cfif not isNumeric(request.quantity)>
	<cfset request.quantity=1>
</cfif>

<cfif request.doaction eq 'addToCart'>
 <cfset session.cart.add(
	request.item_number,
	request.item_name,
	request.amount,
	request.quantity,
	request.shipping,
	request.shipping2,
	request.handling,
	request.on0,
	request.os0,
	request.on1,
	request.os1) >
</cfif>

<cfif request.doaction eq 'updateCart'>
  <cfloop list="#request.item_number#" index="thisItem">
  	<cfif not isNumeric(request['quant_#thisItem#'])>
		<cfset request['quant_#thisItem#']=1>
	</cfif>
    <cfset session.cart.update(thisItem,request['quant_#thisItem#']) >
  </cfloop>
</cfif>
</cfsilent>
<cfswitch expression="#request.doaction#">
<cfcase value="completeCart">
<cfset session.cart.empty()>
<cfinclude template="dsp_complete.cfm">
</cfcase>
<cfcase value="cancelCart">
<!---<cfset session.cart.empty()>--->
<cfinclude template="dsp_cancel.cfm">
</cfcase>
<cfdefaultcase>
<cfset getCart = session.cart.List()>
<cfinclude template="dsp_basket.cfm">
</cfdefaultcase>
</cfswitch>