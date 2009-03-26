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
<cfif arrayLen(request.crumbdata) gt 1 and request.crumbdata[2].type eq 'Calendar' and request.contentBean.getdisplay() eq 2 and request.contentBean.getdisplaystart() gt now()>
<cfoutput>
<div id="svEventReminder">
	<h3>#rbFactory.getKey('event.setreminder')#</h3>
	<cfif listfind(request.doaction,"setReminder")>
	<em>#rbFactory.getKey('event.setreminder')#</em><br/><br/>
	</cfif>
	<form name="reminderFrm" action="#application.configBean.getIndexFile()#?nocache=1" method="post" onsubmit="return validate(this);">
	<label for="email">#rbFactory.getKey('event.email')#*</label><br/>
	<input id="email" name="email" required="true" validate="email" message="#htmlEditFormat(rbFactory.getKey('event.emailvalidate'))#">
	<br/>
	<label for="interval">#rbFactory.getKey('event.sendmeareminder')#</label>
	<select id="interval" name="interval">
	<option value="0">0 #rbFactory.getKey('event.minutes')#</option>
	<option value="5">5 #rbFactory.getKey('event.minutes')#</option>
	<option value="15">15 #rbFactory.getKey('event.minutes')#</option>
	<option value="30">30 #rbFactory.getKey('event.minutes')#</option>
	<option value="60">1 #rbFactory.getKey('event.hour')#</option>
	<option value="120">2 #rbFactory.getKey('event.hours')#</option>
	<option value="240">3 #rbFactory.getKey('event.hours')#</option>
	<option value="300">4 #rbFactory.getKey('event.hours')#</option>
	<option value="360">5 #rbFactory.getKey('event.hours')#</option>
	<option value="420">6 #rbFactory.getKey('event.hours')#</option>
	<option value="480">7 #rbFactory.getKey('event.hours')#</option>
	<option value="540">8 #rbFactory.getKey('event.hours')#</option>
	<option value="1440">1 #rbFactory.getKey('event.day')#</option>
	<option value="2880">2 #rbFactory.getKey('event.days')#</option>
	<option value="3320">3 #rbFactory.getKey('event.days')#</option>
	<option value="10040">1 #rbFactory.getKey('event.week')#</option>
	</select> 
	#rbFactory.getKey('event.beforethisevent')# </label> <br/>
	<input name="doaction" value="setReminder" type="hidden"/>
	<input type="submit" value="#htmlEditFormat(rbFactory.getKey('event.submit'))#"/>
	</form>
</div>
</cfoutput>
</cfif>
