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

<div id="svPayPalCart">
<cfif getCart.recordcount> 
<cfoutput>
<form action="" onSubmit="return validate(this)" method="post">
<table>
<tr>
  <th colspan="2">Your Shopping Cart</th>
</tr>
<cfloop query="getCart">
  <tr>
    <td>
   	#getCart.item_name#
    </td> 
    <td>
   
    Quantity: 
    <input type="hidden" name="item_number" value="#getCart.item_number#">
    <input type="text" size="3" name="quant_#getCart.item_number#" 
           value="#getCart.Quantity#">
   
    </td>
  </tr>
</cfloop>
</table>
<input type="hidden" name="doaction" value="updateCart" />
<input type="submit" name="submit" value="Update Quantities">
</form>



<form target="paypal" action="https://www.paypal.com/cgi-bin/webscr" method="post">
<input type="submit" name="submit" value="Check Out">
<input type="hidden" name="upload" value="1">
<input type="hidden" name="cmd" value="_cart">
<input type="hidden" name="business" value="[EMAIL ADDRESS]">
<cfloop query="getCart">
<input type="hidden" name="item_name_#getCart.currentrow#" value="#getCart.item_name#">
<input type="hidden" name="item_number_#getCart.currentrow#" value="#getCart.item_number#">
<input type="hidden" name="quantity_#getCart.currentrow#" value="#getCart.quantity#">
<input type="hidden" name="amount_#getCart.currentrow#" value="#getCart.amount#">
<input type="hidden" name="handling_#getCart.currentrow#" value="#getCart.handling#">
<input type="hidden" name="shipping_#getCart.currentrow#" value="#getCart.shipping#">
<input type="hidden" name="shipping2_#getCart.currentrow#" value="#getCart.shipping2#">
<input type="hidden" name="on0_#getCart.currentrow#" value="#getCart.on0#">
<input type="hidden" name="os0_#getCart.currentrow#" value="#getCart.os0#">
<input type="hidden" name="on1_#getCart.currentrow#" value="#getCart.on1#">
<input type="hidden" name="os1_#getCart.currentrow#" value="#getCart.os1#">
</cfloop>
<input type="hidden" name="page_style" value="PayPal">
<input type="hidden" name="return" value="http://#listFirst(cgi.http_host,":")##request.path#?doaction=completeCart">
<input type="hidden" name="cancel_return" value="http://#listFirst(cgi.http_host,":")##request.path#?doaction=cancelCart">
<input type="hidden" name="cn" value="Comments">
<input type="hidden" name="currency_code" value="USD">
</form>
</cfoutput>
<cfelse>
Your shopping cart is currently empty.
</cfif>
</div>