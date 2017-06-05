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
<script src="https://unpkg.com/vue@2.3.3"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold.js"></script>
<style>
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
		border: 1px solid ##eee;
	}

	##scaffold-table td,##scaffold-table th {
		padding: 5px;
		border-left: 1px solid ##eee;
	}

	.alt {
		background-color: ##eee;
	}

</style>


		<template id="scaffold-crumb-template">
			<div style="height: 30px">
				<div v-if="state">
					<ul v-for="(att,index) in state" class="crumbly">
						<li v-if="att.parent" @click="clickCrumb(index)">
							<i class="mi-file">...</i>
							{{att.parent.entityname}}
						</li>
						<li v-else @click="clickCrumb(0)">
							<strong>{{state[0].name}}</strong> List
						</li>
					</ul>
				</div>
			</div>
		</template>

		<template id="scaffold-error-template">
			<div>
				<div>
					<div>Errors</div>
					<ul v-for="att in errordata">
						<li>
							{{att}}
							<i class="mi-error"></i>
							{{att.name}}
						</li>
					</ul>
				</div>
			</div>
		</template>

		<template id="scaffold-all-template">
			<div>
				<h2>All Objects:</h2>
				<div v-if="data.items">
					<ul v-for="att in data.items">
						<li @click="showList(att.entityname)">
							{{att.entityname}}
						</li>
					</ul>
				</div>
			</div>
		</template>

		<template id="scaffold-list-template">
			<div>
				<h2>List of entities:</h2>
				<div v-if="data.list">
					<table width="100%" id="scaffold-table">
						<thead>
							<tr>
								<th v-for="item in data.listview">
									<div v-if="item.filter==true || item.filter == 'true'">
									<input class="filter" :name="'filter-' + item.name" @keyup="applyKeyFilter">
									</div>
								</th>
								<th><button @click='applyFilter'>Filter</button></th>
							</tr>
						</thead>
						<thead>
							<tr>
								<th v-for="item in data.listview">
									<span @click="applySortBy(item.name)">{{item.displayname}}</span>
								</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="(object,index) in data.list" :class="index % 2 != 0 ?  'alt' : null">
									<td v-for="item in data.listview">
										{{object[item.name]}}
									</td>
									<td>
										<button @click="showForm(object.entityname,object.id)">edit</button>
									</td>
								</li>
							</tr>

						</tbody>
						<tfoot>
							<tr id="scaffold-nav">
								<th :colspan="data.listview.length+1" style="text-align: right">
									<button v-if="data.links.first" @click="applyPage('first')">
										|<
									</button>
									<button v-if="data.links.previous" @click="applyPage('previous')">
										<
									</button>
									<button v-if="data.links.next" @click="applyPage('next')">
										>
									</button>
									<button v-if="data.links.last" @click="applyPage('last')">
										>|
									</button>
									<span>
										<select name="data.itemsper" @change="applyItemsPer">
											<option value='5' :selected="this.$parent.itemsper == 5 ? 'selected' : null">5</option>
											<option value='10' :selected="this.$parent.itemsper == 10 ? 'selected' : null">10</option>
											<option value='20' :selected="this.$parent.itemsper == 20 ? 'selected' : null">20</option>
										</select>
									</span>
								</th>
							</tr>
						</tfoot>
					</table>
					<ul>
						<li @click="showForm(entityname)">
							NEW ({{this.entityname}})
						</li>
					</ul>
				</div>
			</div>
		</template>

		<template id="scaffold-form-template">
			<ul>
				<template v-for="property in data.properties">
					<span v-if="property.fieldtype == 'id'">
					</span>
					<span v-else-if="property.fieldtype == 'one-to-one'">
						<related-one :property=property :model=data.model :entity=data.entity :data=data :entityid="entityid"></related-one>
					</span>
					<span v-else-if="property.fieldtype == 'many-to-one'">
						<related-many-one :property=property :model=data.model :entity=data.entity :data=data :entityid="entityid"></related-many-one>
					</span>
					<span v-else-if="property.fieldtype == 'one-to-many'">
						<related-many v-if="Math.random()" :property=property :model=data.model :entity=data.entity :data=data :entityid="$parent.entityid"></related-many>
					</span>
					<li v-else>
					<field-textarea v-if="property.rendertype == 'textarea'" :property=property :model=data.model :entity=data.entity></field-textarea>
					<field-checkbox v-else-if="property.rendertype === 'checkbox'" :property=property :model=data.model :entity=data.entity></field-checkbox>
					<field-dropdown v-else-if="property.rendertype === 'dropdown'" :property=property :model=data.model :entity=data.entity></field-dropdown>
					<field-radio v-else-if="property.rendertype === 'radio'" :property=property :model=data.model :entity=data.entity></field-radio>
					<field-text v-else="property.rendertype == 'textbox'" :property=property :model=data.model :entity=data.entity>~</field-text>
					</li>
				</template>


				<li>
					<button @click="clickSave" type="submit" class="btn">Save</button>
					<button @click="clickBack" type="submit" class="btn">Back</button>
					<button @click="clickDelete" type="submit" class="btn btn-warning">Delete</button>
				</li>
			</ul>
			</form>
			</div>
		</template>

		<template id="related-one">
			<div>
				<ul v-if="property.fkcolumn && this.$parent.data.parent">
					<input type="hidden" :name="property.fkcolumn" v-model="model[property.fkcolumn]" id="primary-id"
					:data-default="doDefault(this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null,property.fkcolumn ? property.fkcolumn : null,model)"
					:value="this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null" :length="property.length">
				</ul>
			</div>
		</template>

		<template id="related-many-one">
			<div>
				<ul v-if="property.fkcolumn && this.$parent.data.parent">
					<input type="hidden" :name="property.fkcolumn" v-model="model[property.fkcolumn]" id="primary-id"
					:data-default="doDefault(this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null,property.fkcolumn ? property.fkcolumn : null,model)"
					:value="this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null" :length="property.length">
				</ul>
			</div>
		</template>

		<template id="related-many">
			<div v-if="this.entity.properties.isnew == 0">
				<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
				<ul v-if="mrelated && mrelated.collection">
					<li v-for="object in mrelated.collection.items">
						<span v-if="property.renderfield">{{object.properties[property.renderfield]}}</span><span v-else>{{object.properties.id}}</span>
						<button @click="showForm(object.properties.entityname,object.properties.id,entity.properties.id)">EDIT: {{object.properties[property.renderfield] ? object.properties[property.renderfield] : object.properties.entityname}}</button>
					</li>
				</ul>
				<button class='btn' @click="showForm(property.relatesto,'new',entity.properties.id)">ADD NEW {{property.displayname ? property.displayname : property.name.toUpperCase()}}</button>
			</div>
		</template>

		<template id="field-text">
			<div>
				<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
				<input
					type="text"
					v-model="model[property.name]"
					:name="property.name"
					:value="model[property.name] ? model[property.name] : property.default"
					:length="property.length"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					>

			</div>
		</template>

		<template id="field-textarea">
			<div>
				<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
				<textarea
					v-model="model[property.name]"
					:name="property.name"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					>{{model[property.name] ? model[property.name] : property.default}}</textarea>

			</div>
		</template>

		<template id="field-checkbox">
			<div>
				<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
				<input type="checkbox" v-model="model[property.name]"
				 v-bind:true-value="1"
	  		 v-bind:false-value="0"
				:name="property.name" :value="1" :checked="typeof model[property.name] != 'undefined'  ? model[property.name] == 1 ? 1 : 0 : property.default"
				:data-validate="property.validate ? property.validate : null"
				:data-validate-message="property.validatemessage ? property.validatemessage : null"
				>

			</div>
		</template>


		<template id="field-dropdown">
			<div>
				<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
				<select
					v-model="model[property.name]"
					:name="property.name"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					>
					<option v-for="(option,index) in property.optionlist" :value="option" :selected="option == property.default ? 'selected' : null">{{property.optionvaluelist[index]}}</option>
				</select>

			</div>
		</template>


		<template id="field-radio">
			<div>
				<label>{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>

				<div v-for="(option,index) in property.optionlist" :value="option">
					{{property.optionvaluelist[index]}}
					<input
						type="radio"
						v-model="model[property.name]"
						:name="property.name"
						:value="option"
						:checked="option == property.default ? 'checked' : null"
						>
				</div>

			</div>
		</template>



<div class="block block-constrain" id="container">

	<!--- Tab Nav (only tabbed for Admin + Super Users) --->

	<ul id="viewTabs" class="mura-tab-links nav-tabs">
			<li>
				<a href="##" @click="showAll">All</a>
			</li>
	</ul>

	<!--- /Tab Nav --->

	<div class="block-content tab-content">

		<!-- start tab -->
		<div class="tab-pane active">

			<div class="block block-bordered">
				<!-- block header -->
				<div class="block-header">
					<h3 class="block-title">
						Scaffolding
					</h3>
				</div> <!-- /.block header -->
				<div class="block-content">
					<div>
						<div>
							<component :is="currentView" :entityname="entityname" :data="data" transition="fade" transition-mode="out-in"></component>
						</div>
					</div>




				</div> <!-- /.block-content -->
			</div> <!-- /.block-bordered -->
		</div> <!-- /.tab-pane -->

	</div> <!-- /.block-content.tab-content -->
</div> <!-- /.block-constrain -->


</cfoutput>
