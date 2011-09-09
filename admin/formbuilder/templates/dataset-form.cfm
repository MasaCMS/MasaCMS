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
<cfoutput>
	<div class="ui-tabs">
		<ul class="ui-tabs-nav">
			<li title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.edit')#" class="ui-state-active ui-corner-top ui-tabs-selected"><a href="javascript:void(null);"><span>Source</span></a></li>
			<li id="button-grid-grid" class="ui-state-default ui-corner-top"><a href="javascript:void(null);"><span>List</span></a></li>
		</ul>
			<div class="ui-tabs-panel" id="meld-tb-form-tab-source">
			<div id="meld-tb-dataset" class="meld-tb-form">
			
					<ul class="template-form">
						<li>
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype')#</label>
							<select class="select" name="sourcetype" id="meld-tb-dataset-sourcetype">
								<option value="entered">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.entered')#</option>
								<option value="dsp">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.dsp')#</option>
								<option value="object">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.object')#</option>
								<option value="remote">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.remote')#</option>
							</select>
						</li>
					
						<li class="meld-tb-dsi meld-tb-grp-entered" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.issorted')#</label>
							<select class="select" name="issorted" id="meld-tb-dataset-issorted">
								<option value="0">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.issorted.manual')#</option>
								<option value="1">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.issorted.sorted')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype')#</label>
							<select class="select" name="sorttype" id="meld-tb-dataset-sorttype">
								<option value="string">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype.string')#</option>
								<option value="numeric">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype.numeric')#</option>
								<option value="date">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype.date')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortcolumn')#</label>
							<select class="select" name="sortcolumn" id="meld-tb-dataset-sortcolumn">
								<option value="label">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortcolumn.label')#</option>
								<option value="value">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortcolumn.value')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortdirection')#</label>
							<select class="select" name="sortdirection" id="meld-tb-dataset-sortdirection">
								<option value="asc">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortdirection.asc')#</option>
								<option value="desc">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortdirection.desc')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-source" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.source')#</label>
							<input class="text tb-source" id="meld-tb-dataset-source" type="text" name="source" value="" maxlength="250" />
						</li>
					</ul>
					<div class="btn-wrap">
								<input type="button" class="button" name="save-dataset" id="meld-tb-save-dataset" value="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.update')#" />
							</div>
				</div>
				</div>
							
		</div>
</cfoutput>
