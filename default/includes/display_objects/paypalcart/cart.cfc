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


<cfcomponent output="false">
  <cfset VARIABLES.cart = structNew()>

  <cffunction name="Add" access="public" returnType="void" output="false" >
	<cfargument name="item_number" type="string" required="Yes">
	<cfargument name="item_name" type="string" required="Yes">
	<cfargument name="amount" type="numeric" required="Yes"  default="0">
	<cfargument name="quantity" type="numeric" required="no" default="1">
	<cfargument name="shipping" type="numeric" required="Yes" default="0">
	<cfargument name="shipping2" type="numeric" required="Yes"  default="0">
	<cfargument name="handling" type="numeric" required="Yes"  default="0">
	<cfargument name="on0" type="string" required="Yes"  default="">
	<cfargument name="os0" type="string" required="Yes"  default="">
	<cfargument name="on1" type="string" required="Yes"  default="">
	<cfargument name="os1" type="string" required="Yes"  default="">
 
	
    <cfif structKeyExists(VARIABLES.cart, arguments.item_number)>
      	<cfset VARIABLES.cart[arguments.item_number].quantity = 
             VARIABLES.cart[arguments.item_number].quantity + arguments.quantity>
    <cfelse>
			<cfset VARIABLES.cart[arguments.item_number] = structNew()>
      	<cfset VARIABLES.cart[arguments.item_number].quantity = arguments.quantity>
    </cfif>

	<cfset  VARIABLES.cart[arguments.item_number].amount = arguments.amount >
	<cfset  VARIABLES.cart[arguments.item_number].shipping = arguments.shipping >
	<cfset  VARIABLES.cart[arguments.item_number].shipping2 = arguments.shipping2 >
	<cfset  VARIABLES.cart[arguments.item_number].handling = arguments.handling >
	<cfset  VARIABLES.cart[arguments.item_number].on0 = arguments.on0 >
	<cfset  VARIABLES.cart[arguments.item_number].os0 = arguments.os0 >
	<cfset  VARIABLES.cart[arguments.item_number].on1 = arguments.on1 >
	<cfset  VARIABLES.cart[arguments.item_number].os1 = arguments.os1 >
	<cfset  VARIABLES.cart[arguments.item_number].item_name = arguments.item_name >

  </cffunction> 
 
  <cffunction name="Update" access="public" returnType="void" output="false"
              hint="Updates an items quantity in the shopping cart">
    <cfargument name="item_number" type="string" required="Yes">
    <cfargument name="quantity" type="numeric" required="Yes">

    <cfif arguments.quantity gt 0>
      <cfset VARIABLES.cart[arguments.item_number].quantity = arguments.quantity>    
    <cfelse>
      <cfset remove(arguments.item_number)>
    </cfif>
  </cffunction> 


  <cffunction name="Remove" access="public" returnType="void" output="false"
              hint="Removes an item from the shopping cart">
    <cfargument name="item_number" type="string" required="Yes">

    <cfset structDelete(VARIABLES.cart, arguments.item_number)>
  </cffunction> 
 
  <cffunction name="Empty" access="public" returnType="void" output="false"
              hint="Removes all items from the shopping cart">
    <cfset structClear(VARIABLES.cart)>
  </cffunction>
 
  <cffunction name="List" access="public" returnType="query" output="false"
              hint="Returns a query object containing all items in shopping 
              cart. The query object has two columns: MerchID and Quantity.">

    <cfset var q = queryNew("item_number,item_name,amount,quantity,shipping,shipping2,handling,on0,os0,on1,os1")>
    <cfset var key = "">
   

    <cfloop collection="#VARIABLES.cart#" item="key">
    <cfset queryAddRow(q)>
    <cfset querySetCell(q, "item_number", key)>
    <cfset querySetCell(q, "item_name", VARIABLES.cart[key].item_name)>
	<cfset querySetCell(q, "quantity", VARIABLES.cart[key].quantity)>
	<cfset querySetCell(q, "amount", VARIABLES.cart[key].amount)>
	<cfset querySetCell(q, "shipping", VARIABLES.cart[key].shipping)>
	<cfset querySetCell(q, "shipping2", VARIABLES.cart[key].shipping2)>
	<cfset querySetCell(q, "handling", VARIABLES.cart[key].handling)>
	<cfset querySetCell(q, "on0", VARIABLES.cart[key].on0)>
	<cfset querySetCell(q, "os0", VARIABLES.cart[key].os0)>
	<cfset querySetCell(q, "on1", VARIABLES.cart[key].on1)>
	<cfset querySetCell(q, "os1", VARIABLES.cart[key].os1)>
    </cfloop>

    <cfreturn q> 
  </cffunction> 

</cfcomponent>
