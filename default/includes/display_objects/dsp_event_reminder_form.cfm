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
<cfset crumbs=variables.$.event('crumbData')>
<cfif arrayLen(crumbs) gt 1 and crumbs[2].type eq 'Calendar' and variables.$.content('display') eq 2 and variables.$.content('displayStart') gt now()>
<cfoutput>
<div id="svEventReminder" class="mura-event-reminder">
	<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('event.setreminder')#</#variables.$.getHeaderTag('subHead1')#>
	<cfif listfind(variables.$.event('doaction'),"setReminder")>
	<em>#variables.$.rbKey('event.setreminder')#</em><br/><br/>
	</cfif>
	<form class="well" name="reminderFrm" action="?nocache=1" method="post" onsubmit="return mura.validateForm(this);" novalidate="novalidate" >
	<fieldset>
	<ol>
	<li class="req control-group"><label class="control-label" for="email">#variables.$.rbKey('event.email')#*</label>
	<input id="email" name="email" data-required="true" data-validate="email" data-message="#htmlEditFormat(variables.$.rbKey('event.emailvalidate'))#"></li>
	<li class="req control-group"><label class="control-label" for="interval">#variables.$.rbKey('event.sendmeareminder')#</label>
	<select id="interval" name="interval">
	<option value="0">0 #variables.$.rbKey('event.minutes')#</option>
	<option value="5">5 #variables.$.rbKey('event.minutes')#</option>
	<option value="15">15 #variables.$.rbKey('event.minutes')#</option>
	<option value="30">30 #variables.$.rbKey('event.minutes')#</option>
	<option value="60">1 #variables.$.rbKey('event.hour')#</option>
	<option value="120">2 #variables.$.rbKey('event.hours')#</option>
	<option value="240">3 #variables.$.rbKey('event.hours')#</option>
	<option value="300">4 #variables.$.rbKey('event.hours')#</option>
	<option value="360">5 #variables.$.rbKey('event.hours')#</option>
	<option value="420">6 #variables.$.rbKey('event.hours')#</option>
	<option value="480">7 #variables.$.rbKey('event.hours')#</option>
	<option value="540">8 #variables.$.rbKey('event.hours')#</option>
	<option value="1440">1 #variables.$.rbKey('event.day')#</option>
	<option value="2880">2 #variables.$.rbKey('event.days')#</option>
	<option value="3320">3 #variables.$.rbKey('event.days')#</option>
	<option value="10040">1 #variables.$.rbKey('event.week')#</option>
	</select> 
	#variables.$.rbKey('event.beforethisevent')#</li>
	</ol>
	</fieldset>
	<input name="doaction" value="setReminder" type="hidden"/>
	<input class="btn" type="submit" value="#htmlEditFormat(variables.$.rbKey('event.submit'))#"/>
	</form>
</div>
</cfoutput>
</cfif>
