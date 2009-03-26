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
<cfset rbFactory=getSite().getRBFactory() />
<cfparam name="request.emailid" default=""/>
<cfoutput>
<div id="svForwardEmail">
	<cfif request.emailid eq ''>
	<em>#rbFactory.getKey('email.emailiderror')#</em>
	<cfelse>
	<h3>#application.emailManager.read(request.emailid).getSubject()#</h3>
	<cfif listfind(request.doaction,"forwardEmail")>
	<p>#rbFactory.getKey('email.fowarded')#</p>
	</cfif>
	<form name="forwardFrm" action="?nocache=1" method="post" format="html" onsubmit="return validate(this);">
	<fieldset>
	<legend>#rbFactory.getKey('email.uptofive')#<legend>
	<ul>
	<li><input name="to1" message="#htmlEditFormat(rbFactory.getKey('email.emailrequired'))#" validate="email" required="true"></li>
	<li><input name="to2" message="#htmlEditFormat(rbFactory.getKey('email.emailvalidate'))#" validate="email" required="no"></li>
	<li><input name="to3" message="#htmlEditFormat(rbFactory.getKey('email.emailvalidate'))#" validate="email" required="no"></li>
	<li><input name="to4" message="#htmlEditFormat(rbFactory.getKey('email.emailvalidate'))#" validate="email" required="no"></li>
	<li><input name="to5" message="#htmlEditFormat(rbFactory.getKey('email.emailvalidate'))#" validate="email" required="no"></li>
	</ul>
	<input name="doaction" value="forwardEmail" type="hidden"/>
	<input name="emailid" value="#request.emailid#" type="hidden"/>
	<input name="from" value="#request.from#" type="hidden"/>
	<input name="origin" value="#request.origin#" type="hidden"/>
	<fieldset>
	<input class="submit" type="submit" value="#htmlEditFormat(rbFactory.getKey('email.submit'))#"/>
	</form>
	</cfif>
</div>
</cfoutput>