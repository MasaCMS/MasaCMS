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

<div class="page_aTab">
<dl class="oneColumn"><cfoutput>
<cfif attributes.type eq 'Page' or attributes.type eq 'Portal' or attributes.type eq 'Calendar'  or attributes.type eq 'Gallery'>
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.metainformation')#</dt>
<dd id="editMeta">
	<dl>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.description')#</dt>
	<dd><textarea name="metadesc" rows="8" id="metadesc">#HTMLEditFormat(request.contentBean.getMETADesc())#</textarea></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywords')#</dt>
	<dd><textarea name="metakeywords" rows="8" id="metakeywords">#HTMLEditFormat(request.contentBean.getMETAKEYWORDS())#</textarea></dd>
	</dl>
</dd>
<dt>
<cfelse>
<dt class="first">
</cfif>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tags')#</dt>
<dd><input type="text" id="credits" name="tags" value="#HTMLEditFormat(request.contentBean.getTags())#"  maxlength="255" class="textLong"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.credits')#</dt>
<dd><input type="text" id="credits" name="credits" value="#HTMLEditFormat(request.contentBean.getCredits())#"  maxlength="255" class="textLong"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.audience')#</dt>
<dd><input type="text" id="audience" name="audience" value="#HTMLEditFormat(request.contentBean.getAudience())#"  maxlength="255" class="textLong"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keypoints')#</dt>
<dd><textarea name="keyPoints" rows="8" id="keyPoints">#HTMLEditFormat(request.contentBean.getKeyPoints())#</textarea></dd>
</cfoutput></dl>
</div>