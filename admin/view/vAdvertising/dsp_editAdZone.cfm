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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.editadzone')#</h2>
#application.utility.displayErrors(request.adZoneBean.getErrors())#

<form name="form1" method="post" action="index.cfm?fuseaction=cAdvertising.updateAdZone&siteid=#attributes.siteid#" onsubmit="return false;">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</dt>
<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.namerequired')#" value="#HTMLEditFormat(request.adZoneBean.getName())#" maxlength="50"><dd>
<cfif attributes.adZoneID neq ''>
</dl>
<div id="page_tabView">
<div class="page_aTab">
<dl class="oneColumn">
<dt class="first">
<cfelse>
<dt>
</cfif>
#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#</dt>
<dd><select name="creativeType">
<cfloop list="#application.advertiserManager.getCreativeTypes()#" index="ct">
<option value="#ct#" <cfif request.adZoneBean.getCreativeType() eq ct>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#ct#')#</option>
</cfloop>
</select></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</dt>
<dd><input name="height" validate="integer" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.heightvalidate')#" value="#request.adZoneBean.getHeight()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</dt>
<dd><input name="width" validate="integer" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.widthvalidate')#" value="#request.adZoneBean.getWidth()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</dt>
<dd>
<input name="isActive" id="isActiveYes" type="radio" value="1" <cfif request.adZoneBean.getIsActive()>checked</cfif>> <label for="isActiveYes">#application.rbFactory.getKeyValue(session.rb,'advertising.yes')#</label> 
<input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not request.adZoneBean.getIsActive()>checked</cfif>> <label for="isActiveNo">#application.rbFactory.getKeyValue(session.rb,'advertising.no')#</label>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#</dt>
<dd><textarea name="notes" class="textArea">#HTMLEditFormat(request.adZoneBean.getNotes())#</textarea></dd>
</dl>
<cfif attributes.adZoneid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.add')#</span></a><input type=hidden name="adZoneID" value="">
<cfelse><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringformat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteadzoneconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#</span></a>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.update')#</span></a>
<input type=hidden name="adZoneID" value="#request.adZoneBean.getAdZoneID()#"></cfif><input type="hidden" name="action" value="add"></form>
</p></cfoutput>
<cfif attributes.adZoneID neq ''>
</div>
<cfinclude template="dsp_tab_usage.cfm">
</div>
</cfif>
<cfif attributes.adZoneID neq ''>
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.usagereport'))#"),0,0,0);
</script></cfoutput>
</cfif>