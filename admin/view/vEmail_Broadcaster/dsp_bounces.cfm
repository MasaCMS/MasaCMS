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
<h2>#application.rbFactory.getKeyValue(session.rb,"email.bouncedemailaddresses")#</h2>
<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"email.filterbynumberofbounces")#:</h3>
<div id="advancedSearch" class="clearfix bounces">
<form action="index.cfm?fuseaction=cEmail.showAllBounces&siteid=<cfoutput>#attributes.siteid#</cfoutput>" method="post" name="form1" id="filterBounces">
<dl>
<dt>
	  <select name="bounceFilter">
	  	<option value="">#application.rbFactory.getKeyValue(session.rb,"email.all")#</option>
			<cfloop from="1" to="5" index="i">
			  <option value="#i#"<cfif isDefined('attributes.bounceFilter') and attributes.bounceFilter eq i> selected</cfif>>#i#</option>
			</cfloop>
	  </select>
</dt>
<dd><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span>#application.rbFactory.getKeyValue(session.rb,"email.filter")#</span></a></dd>
</dl>			  

</form>
</div>

<h3>#application.rbFactory.getKeyValue(session.rb,"email.emailaddressbounces")#</h3></cfoutput>
<cfif request.rsBounces.recordcount>
	<cfset bouncedEmailList = "">

	<form action="index.cfm?fuseaction=cEmail.deleteBounces&siteid=<cfoutput>#attributes.siteid#</cfoutput>" method="post" name="form2" id="bounces">
	
		<ul class="metadata">
			<cfoutput query="request.rsBounces">
				<li>#email# - #bounceCount#</li>
				<cfset bouncedEmailList = listAppend(bouncedEmailList,email)>
			</cfoutput>
		</ul>
		<cfoutput>
		<input type="hidden" value="#bouncedEmailList#" name="bouncedEmail" />
		<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','This');"><span>#application.rbFactory.getKeyValue(session.rb,"email.delete")#</span></a>
	</form></cfoutput>
</cfif>

	







