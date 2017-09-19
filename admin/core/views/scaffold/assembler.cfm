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
<!---<script src="#$.globalConfig('rootPath')#/admin/assets/js/vue.min.js"></script>--->

<script src="#$.globalConfig('rootPath')#/admin/assets/js/jquery/jquery-ui.min.js"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold/assembler.js"></script>


		<style>
			##scaffold-sortby th i {
				padding: 1px 0px 0px 5px;
				color: ##333333;
				font-size: 1.1em;
			}
			##scaffold-sortby th {
			}

			##scaffold-table tr.alt td {
				background-color: ##eee;
			}


			.formtemplate {
				margin: 20px 0;
			}
			.formtemplate div {
				margin: 10px;
				padding: 10px 0;
				border-top: 1px solid ##ccc;
			}
			##property-template {
				margin: 10px 0;
			}
			##assembler-properties li {
				list-style: none;
				margin: 0;
				padding: 0;
			}
			##assembler-properties .assembler-item-box {
				width: 100%;
				display: block;
				margin: 1px 0;
				padding: 5px 5px 5px 10px;
			}

			##assembler-properties .assembler-item-box .assembler-prop {
				padding: 4px 5px 5px 10px;
				border-left: 5px solid ##eee;
			}

			.assembler-no-displayname {
				color: ##880000;
			}

			.small {
				font-size: 0.7em;
			}

			.breadcrumb {
				list-style: none;
				overflow: hidden;
				height: 25px;
			}
			.crumbly li {
				display: inline-block;
				float: left;
			}

			##scaffold-table {

			}

			##scaffold-table td {
				padding-bottom: 5px;
			}

			##assembler-preview,.assembler-preview {
				float: left;
				border: 2px solid ##333;
				width: 490px;
				height: 600px;
				overflow: scroll;

			}

			##load-spin ##spinner {
			  position: absolute;
			  left: 50%;
			  top: 50%;
			  z-index: 10000;
			  width: 150px;
			  height: 150px;
			  margin: -75px 0 0 -75px;
			  border: 16px solid ##f3f3f3;
			  border-radius: 50%;
			  border-top: 16px solid ##3498db;
			  width: 120px;
			  height: 120px;
			  -webkit-animation: spin 2s linear infinite;
			  animation: spin 2s linear infinite;
			}

			##load-spin {
				position: fixed;
				width: 100%;
				height: 100%;
				left: 0;
				top: 0;
				background-color: ##fff;
				z-index: 10000;
				border: 16px solid ##f3f3f3;
				opacity: .8;
			}
		</style>

		<script>
			var Assembler = "";
			var Scaffolder = "";
			var Master = "";
		</script>

<div class="mura-header">
  <h1>Dynamic Custom Entity</h1>

	<div class="nav-module-specific btn-group">
    <a class="btn" href="./?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteid)#&activeTab=2" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#"><i class="mi-arrow-circle-left"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
  </div>

</div> <!-- /.mura-header -->

<div class="block block-constrain" id="container">

	<!--- /Tab Nav --->

	<div class="block-content tab-content">

		<!-- start tab -->
		<div class="tab-pane active">

			<div class="block block-bordered">
				<div id="load-spin" style="display: none;"><div id="load-spin-spinner"></div></div>
				<!-- block header -->
				<div class="block-header">
					<h3 class="block-title">
						Scaffolding
					</h3>
				</div> <!-- /.block header -->
				<div class="block-content">
					<div>
						<div>
							<div id="container-assembler">
								<div style="float: left;width: 49%;">
									<!---
									<button @click='clickLoadEntity'>Load</button>
									<input type="text" id='loadentity' name="loadentity" value="">
									--->
									<assembler-attributes-form-template :model="model"></assembler-attributes-form-template>
									<div>
										<button @click='clickAddProperty'>New Property</button>
										<button @click='clickAddRelated'>New Relationship</button>
										<button class="btn btn-info" @click='clickSave' v-if="model.entityname != '' && model.table != ''">Save</button>
										<button class="btn btn-danger pull-right" @click='clickClear'>New</button>
									</div>
									<assembler-property-template :model="model"	></assembler-property-template>
									<div>
										<component :is="currentView" :data="data" :rendertypes="rendertypes" :fieldtypes="fieldtypes" :datatypes="datatypes" :model="model" transition="fade" transition-mode="out-in"></component>
									</div>
								</div>
								<div style="float: right;width: 49%;">
									<pre id="assembler-preview">{{JSON.stringify(model,null,2)}}
									</pre>
								</div>
							</div>
						</div>
					</div>
			</div> <!-- /.block-content -->
			</div> <!-- /.block-bordered -->
		</div> <!-- /.tab-pane -->

	</div> <!-- /.block-content.tab-content -->
</div> <!-- /.block-constrain -->


	<template id="assembler-property-template">
		<div id="property-template">
			<h3>Properties</h3>
			<ul id="assembler-properties">
				<li v-for="(item,index) in model.properties" v-bind:id="'assembler-property-index-' + index" :data-index="index" :data-name="item.name" :key="item.pos">
					<span class="assembler-item-box">
						<span v-if="item.relatesto || item.cfc" class="assembler-prop">
							<button @click="clickEditRelated(index)"><i class="mi-cogs"></i></button>
						</span>
						<span v-else-if="item.fieldtype == 'id'" class="assembler-prop">
							<button @click="clickEditProperty(index)"><i class="mi-cog"></i></button>
						</span>
						<span v-else class="assembler-prop">
							<button @click="clickEditProperty(index)"><i class="mi-edit"></i></button>
						</span>
						<span v-if="item.displayname && item.displayname.length">{{item.displayname}}</span><span v-else class="assembler-no-displayname">{{item.name}}</span>
						<span v-if="item.relatesto || item.cfc"> ({{item.fieldtype}} {{item.cfc}})</span>
						<span v-if="item.rendertype == 'hidden'"> (Hidden)</span>
						<span v-if="item.rendertype == 'null'"> (Does Not Render)</span>
					</span>
				</li>
			</ul>
		</div>
	</template>

	<template id="assembler-attributes-form-template">
		<div class="formtemplate" id="attributes-form-template">

	<div class="help-block">
	   IMPORTANT: In many instances you will need to reload Mura after updating dynamically created entities.
	</div>

			<div>
				<label>Entity Name</label>
				<input type="text" v-model="model.entityname"
					name="entityname" @change="model.entityname=model.entityname.replace(/[^0-9a-z]/gi, '');"
				>
			</div>

			<div>
				<label>Display Name</label>
				<input type="text" v-model="model.displayname"
					name="displayname" @change="model.displayname=removeInvalidText(model.displayname)"
				>
			</div>

			<div>
				<label>Order By</label>
				<input type="text" v-model="model.orderby"
					name="orderby"
				>
			</div>

			<div>
				<label>Table Name</label>
				<input type="text" v-model="model.table"
					name="table" @change="model.table=model.table.replace(/[^0-9a-z]/gi, '');"
				>
			</div>

			<div>
				<label>Scaffold</label>
				<input type="checkbox" v-model="model.scaffold"
					name="scaffold"
					v-bind:true-value="true"
	   		 		v-bind:false-value="false"
	 				name="scaffold" :checked="model.scaffold == true || model.scaffold == 1 || model.scaffold == 'true' ? 'checked' : null"
				>
			</div>

			<div>
				<label>Bundleable</label>
				<input type="checkbox" v-model="model.bundleable"
					name="bundleable"
					v-bind:true-value="true"
		   		 	v-bind:false-value="false"
	 				name="bundleable" :checked="model.bundleable == true || model.bundleable == 1 || model.bundleable == 'true' ? 'checked' : null"
				>
			</div>

			<div>
				<label>Publicly Accessible</label>
				<input type="checkbox" v-model="model.public"
					name="public"
					v-bind:true-value="true"
	   		 		v-bind:false-value="false"
	 				name="public" :checked="model.public == true || model.public == 1 || model.public == 'true' ? 'checked' : null"
				>
			</div>
		</div>
	</template>


	<template id="assembler-related-form-template">
		<div class="formtemplate" id="related-form-template">
			<div>
				<label>Property Name</label>
				<input type="text" v-model="data.name"
					name="name" @change="data.name=data.name.replace(/[^0-9a-z]/gi, '');"
				>
			</div>

			<div>
				<label>Display Name</label>
				<input type="text" v-model="data.displayname"
					name="displayname"
				>
			</div>

			<div>
				<label>Relationship Type</label>
				<select
					v-model="data.fieldtype"
					name="fieldtype"
					>
					<option v-for="(option,index) in ['one-to-many','one-to-one','many-to-one']" :value="option" :selected="option == data.fieldtype ? 'selected' : 'null'">{{option}}</option>
				</select>
			</div>

			<div>
				<label>Relates To</label>

				<select
					v-model="data.relatesto"
					name="relatesto"
					@change="getRelatesToFields"
					>
					<option v-for="(option,index) in this.$parent.alldynamicobjects" :value="option.entityname" :selected="option.entityname == data.cfc ? 'selected' : 'null'">{{option.displayname}}</option>
				</select>
			</div>


				<div>
					<label>Foriegn Key Column</label>
					<select
						v-model="data.fkcolumn"
						name="fkcolumn"
						>
						<option value="" :selected="!data.fkcolumn || data.fkcolumn == ''">Primary Key</option>
						<option v-for="(option,index) in this.relatedprops" v-if="option.fieldtype='id' || option.fieldtype=='index'" :value="option.name" :selected="option.fkcolumn == option.name ? 'selected' : 'null'">{{option.name}}</option>
					</select>
				</div>

			<div>
				<label>Render Field</label>
				<select
					v-model="data.renderfield"
					name="renderfield"
					>
					<option v-for="(option,index) in this.relatedprops" v-if="option.displayname && option.displayname.length > 0" :value="option.name" :selected="((!data.renderfield || data.renderfield.length==0) && option.name=='name') ? 'selected' : 'null'">{{option.displayname}}</option>
				</select>
			</div>

			<div>
				<label>Load Key</label>
				<input type="text" v-model="data.loadkey"
					name="loadkey"
				>
			</div>

			<div>
				<label>Cascade Delete?</label>
				<select
					v-model="data.cascade"
					name="cascade"
					>
					<option v-for="(option,index) in ['none','delete']" :value="option" :selected="option == data.cascade ? 'selected' : 'null'">{{option}}</option>
				</select>
			</div>



			<div>
				<button @click="clickUpdateRelated"><span v-if="this.$parent.isupdate">Update</span><span v-else>Add</span></button>
				<button v-if="this.$parent.isupdate" @click="clickDeleteRelated">Delete</button>
				<button @click='clickCancel'>Cancel</button>
			</div>
		</div>
	</template>

	<template id="assembler-property-form-template">
		<div class="formtemplate">
			<div>
				<label>Property Name</label>
				<input type="text" v-model="data.name"
					name="name" @change="data.name=data.name.replace(/[^0-9a-z]/gi, '');"
				>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Display Name</label>
				<input type="text" v-model="data.displayname"
					name="displayname" @change="data.displayname=removeInvalidText(data.displayname)"
				>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Data Type</label>
				<select
					v-model="data.datatype"
					name="datatype"
					>
					<option v-for="(option,index) in datatypes" :value="option.name" :selected="option.name == data.datatype ? 'selected' : 'null'">{{datatypes[index].label}}</option>
				</select>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Field Type</label>
				<select
					v-model="data.fieldtype"
					name="fieldtype"
					>
					<option v-for="(option,index) in fieldtypes" :value="option.name" :selected="option.name == data.fieldtype ? 'selected' : 'null'">{{fieldtypes[index].label}}</option>
				</select>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Default</label>
				<input type="text" v-model="data.default"
					name="default"
				>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Form Field</label>
				<select
					v-model="data.rendertype"
					name="rendertype"
					>
					<option v-for="(option,index) in rendertypes" :value="option.name" :selected="option.name == data.rendertype ? 'selected' : 'null'">{{rendertypes[index].label}}</option>
				</select>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Length</label>
				<input type="text" v-model="data.length"
					name="length"
				>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Required</label>
				<input type="checkbox" v-model="data.required"
					v-bind:true-value="true"
		   		 	v-bind:false-value="false"
	 				name="required" :checked="data.required == true || data.required == 1 || data.required == 'true' ? 'checked' : null"
				>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>List</label>
				<input type="checkbox" v-model="data.listview"
					v-bind:true-value="true"
	   			 	v-bind:false-value="false"
	 				name="listview" :checked="data.listview == true || data.listview == 1 || data.listview == 'true' ? 'checked' : null"
				>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Filter</label>
				<input type="checkbox" v-model="data.filter"
					v-bind:true-value="true"
		   		 	v-bind:false-value="false"
	 				name="filter" :checked="data.filter == true || data.filter == 1 || data.filter == 'true' ? 'checked' : null"
				>
			</div>

			<div v-if="data.fieldtype != 'id'">
				<label>Nullable</label>
				<input type="checkbox" v-model="data.nullable"
					v-bind:true-value="true"
		   		 	v-bind:false-value="false"
	 				name="nullable" :checked="data.nullable == true || data.nullable == 1 || data.nullable == 'true' ? 'checked' : null"
				>
			</div>


			<div v-if="(data.rendertype == 'radio' || data.rendertype == 'dropdown') && data.fieldtype != 'id'">
				<label>Option List</label>
				<input type="text" v-model="data.optionlist"
					name="optionlist">*</br>
					<span class="small">*separate by ^, i.e. One^Two^Three</span>
			</div>


			<div v-if="(data.rendertype == 'radio' || data.rendertype == 'dropdown') && data.fieldtype != 'id'">
				<label>Option Value List</label>
				<input type="text" v-model="data.optionvaluelist"
					name="optionvaluelist">*</br>

					<span class="small">*separate by ^, i.e. 1^2^3</span>
			</div>


			<div>
				<button @click="clickUpdateProperty"><span v-if="this.$parent.isupdate">Update</span><span v-else>Add</span></button>
				<button v-if="this.$parent.isupdate && data.fieldtype != 'id'" @click="clickDeleteProperty">Delete</button>
				<button @click='clickCancel'>Cancel</button>
			</div>
		</div>
	</template>

</cfoutput>
