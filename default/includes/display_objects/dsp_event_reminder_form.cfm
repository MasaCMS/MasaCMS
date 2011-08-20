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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfset rbFactory=getSite().getRBFactory() />
<cfif arrayLen(request.crumbdata) gt 1 and request.crumbdata[2].type eq 'Calendar' and $.content('display') eq 2 and $.content('displayStart') gt now()>
<cfoutput>
<div id="svEventReminder">
	<#getHeaderTag('subHead1')#>#$.rbKey('event.setreminder')#</#getHeaderTag('subHead1')#>
	<cfif listfind(request.doaction,"setReminder")>
	<em>#$.rbKey('event.setreminder')#</em><br/><br/>
	</cfif>
	<form name="reminderFrm" action="?nocache=1" method="post" onsubmit="return validate(this);" novalidate="novalidate" data-role="fieldcontain">
	<fieldset>
	<ol>
	<li><label for="email">#$.rbKey('event.email')#*</label>
	<input id="email" name="email" required="true" validate="email" message="#htmlEditFormat($.rbKey('event.emailvalidate'))#"></li>
	<li><label for="interval">#$.rbKey('event.sendmeareminder')#</label>
	<select id="interval" name="interval">
	<option value="0">0 #$.rbKey('event.minutes')#</option>
	<option value="5">5 #$.rbKey('event.minutes')#</option>
	<option value="15">15 #$.rbKey('event.minutes')#</option>
	<option value="30">30 #$.rbKey('event.minutes')#</option>
	<option value="60">1 #$.rbKey('event.hour')#</option>
	<option value="120">2 #$.rbKey('event.hours')#</option>
	<option value="240">3 #$.rbKey('event.hours')#</option>
	<option value="300">4 #$.rbKey('event.hours')#</option>
	<option value="360">5 #$.rbKey('event.hours')#</option>
	<option value="420">6 #$.rbKey('event.hours')#</option>
	<option value="480">7 #$.rbKey('event.hours')#</option>
	<option value="540">8 #$.rbKey('event.hours')#</option>
	<option value="1440">1 #$.rbKey('event.day')#</option>
	<option value="2880">2 #$.rbKey('event.days')#</option>
	<option value="3320">3 #$.rbKey('event.days')#</option>
	<option value="10040">1 #$.rbKey('event.week')#</option>
	</select> 
	#$.rbKey('event.beforethisevent')#</li>
	</ol>
	</fieldset>
	<input name="doaction" value="setReminder" type="hidden"/>
	<input type="submit" value="#htmlEditFormat($.rbKey('event.submit'))#"/>
	</form>
</div>
</cfoutput>
</cfif>
