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
<dl class="oneColumn">
<cfoutput>
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#: <span id="selectRelatedContent"> <a href="javascript:;" onclick="javascript: loadRelatedContent('#attributes.siteid#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addrelatedcontent')#]</a></span></dt>
<table id="relatedContent" class="stripe"> 
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contenttitle')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type')#</th>
<th class="administration">&nbsp;</th>
</tr>
<tbody id="RelatedContent">
<cfif request.rsRelatedContent.recordCount>
<cfloop query="request.rsRelatedContent">
<tr id="c#request.rsRelatedContent.contentID#">
<td class="varWidth">#request.rsRelatedContent.menuTitle#</td>
<td>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#request.rsRelatedContent.type#')#</td>
<td class="administration"><input type="hidden" name="relatedcontentid" value="#request.rsRelatedContent.contentid#" /><ul class="clearfix"><li class="delete"><a title="Delete" href="##" onclick="return removeRelatedContent('c#request.rsRelatedContent.contentid#','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removerelatedcontent'))#');">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li></ul></td>
</tr></cfloop>
<cfelse>
<tr>
<td id="noFilters" colspan="4" class="noResults">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.norelatedcontent')#</td>
</tr>
</cfif></tbody>
</table>
</cfoutput>
</dl></div>