<!---
	This file is part of Mura CMS.

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

<cfoutput>

<script src="#$.globalConfig('rootPath')#/core/vendor/vue/vue.js"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold/assembler.js"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold/Sortable.min.js"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold/vuedraggable.min.js"></script>

<script>
	var Assembler = "";
	var Scaffolder = "";
	var Master = "";
</script>

<style>
.mura ##container-assembler ##assembler-properties .sortable-ghost {
	background-color: ##eee;
	border-color: ##eee;
}
.mura ##container-assembler ##assembler-properties sortable-list div {
  list-style: none;
  margin: 0;
  padding: 0;
}
</style>

<div id="alert-assembler-saved"></div>

<div class="mura-header">
  <h1>Custom Mura ORM Entity</h1>

	<div class="nav-module-specific btn-group">
		<!---<a class="btn" href="./?muraAction=scaffold.assembler"><i class="mi-plus-circle"></i> New Entity</a>--->
    <a class="btn" href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&activeTab=2"><i class="mi-arrow-circle-left"></i> Back</a>
  </div>

</div> <!-- /.mura-header -->

<div class="block block-constrain" id="container">

	<!--- Tab navigation --->
  <ul class="mura-tabs nav-tabs" data-toggle="tabs">
    <li class="active"><a href="##tabDef" onclick="return false;"><span>Definition</span></a></li>
    <li class=""><a href="##tabJson" onclick="return false;"><span>JSON</span></a></li>
  </ul>	<!--- /Tab Nav --->

	<!--- assembler --->
	<div id="container-assembler">

	  <!--- start tab content --->
		<div class="block-content tab-content">
			<!-- definitions-->
			<div class="tab-pane active" id="tabDef">
				<div class="block block-bordered">

					<div class="block-content">
						<div class="alert alert-warning">
						   IMPORTANT: After updating dynamically created entities, a reload of the Mura application may be required.
						</div>
							<component :is="currentView" :data="data" :isupdate="isupdate" :rendertypes="rendertypes" :fieldtypes="fieldtypes" :datatypes="datatypes" :model="model" transition="fade" transition-mode="out-in"></component>
					</div>
				</div> <!-- /.block-bordered -->
			</div> <!-- /tabDef -->

			<!-- json -->
			<div class="tab-pane" id="tabJson">
				<div class="block block-bordered">
					<div class="block-content">
						<h3>JSON Preview</h3>
						<pre id="assembler-preview">{{JSON.stringify(model,null,2)}}</pre>
					</div>
				</div> <!-- /.block-bordered -->
			</div> <!-- /tabJson -->

		</div> <!-- /.block-content.tab-content -->

		<div class="mura-actions" style="display:none">
			<div class="form-actions" v-if="currentView==='assembler-template'">
				<button v-if="this.entityissaved" @click='clickDelete' class="btn"><i class="mi-trash"></i> Delete</button>
				<button v-if="model.entityname != '' && model.table != ''" @click='clickSave' class="btn mura-primary"><i class="mi-check-circle"></i> Save</button>
				<button v-else class="btn" disabled><i class="mi-ban"></i> Save</button>
			</div>
			<div class="form-actions" v-else-if="currentView==='assembler-property-form-template'">
				<button  class="btn mura-primary" @click="clickUpdateProperty"><i class="mi-check-circle"></i> <span v-if="isupdate">Update</span><span v-else>Add</span> Property</button>
				<button class="btn" v-if="isupdate && data.fieldtype != 'id'" @click="clickDeleteProperty"><i class="mi-trash"></i> Delete</button>
				<button  class="btn" @click='clickCancel'><i class="mi-arrow-circle-left"></i> Cancel</button>
			</div>
			<div class="form-actions" v-else-if="currentView==='assembler-related-form-template'">
				<button  class="btn mura-primary" @click="clickUpdateRelated"><i class="mi-check-circle"></i> <span v-if="isupdate">Update</span><span v-else>Add</span> Relationship</button>
				<button class="btn" v-if="isupdate" @click="clickDeleteRelated"><i class="mi-trash"></i> Delete</button>
				<button  class="btn" @click='clickCancel'><i class="mi-arrow-circle-left"></i> Cancel</button>
			</div>
		</div>

	</div> <!--- /container-assembler --->

</div> <!-- /.block-constrain -->

</cfoutput>

<!--- vue templates --->
<cfinclude template="assembler_templates.cfm">
