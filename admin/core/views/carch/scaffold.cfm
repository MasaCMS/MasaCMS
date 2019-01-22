<cfoutput>

<script>
	var Assembler = "";
	var Scaffolder = "";
	var Master = "";
  var IsSuperUser = #rc.$.currentUser().isSuperUser()#;
</script>

<script src="#$.globalConfig('rootPath')#/core/vendor/vue/vue.js"></script>
<script src="#$.globalConfig('rootPath')#/admin/assets/js/scaffold/scaffolder.js"></script>

<div class="block-content">

	<div id="container-scaffold">
		<scaffold-crumb-template :data="data" :state="state"></scaffold-crumb-template>
		<scaffold-error-template :errordata="errordata"></scaffold-error-template>
		<div>
			<component :is="currentView" :currentparent="currentparent" :entityname="entityname" :data="data" transition="fade" transition-mode="out-in"></component>
		</div>
	</div> <!-- /container-scaffold -->
</div> <!-- /.block-content -->

	<template id="scaffold-crumb-template">
			<div v-if="state" id="scaffold-crumb-display">
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
	</template>

	<template id="scaffold-error-template">
		<div v-if="errordata.length">
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
			<h2>Available Entities:</h2>
			<div v-if="data.items">
				<ul v-for="att in data.items">
					<li @click="showList(att.entityname)">
						{{att.displayname ? att.displayname : att.entityname}}
					</li>
				</ul>
			</div>

			<p v-if="!data.items.length" class="alert alert-info">No items available.</p>

		</div>
	</template>

	<template id="scaffold-list-template">

		<div>
			<div class="btn-group pull-right">
				<a v-if="currentparent && currentparent.properties" @click="showForm(currentparent.properties.entityname,currentparent.properties.id)" class="btn"><i class="mi-arrow-circle-left"></i> Back</a>
				<a v-if="entityname != 'entity' && data.issuperuser && data && data.parentproperties && data.parentproperties.dynamic" class="btn" @click="goToAssembler(entityname)"><i class="mi-edit"></i> Edit</a>
				<a class="btn" @click="openEndpoint()"><i class="mi-globe"> API Endpoint</i></a>
				<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
					<span v-if="entityname == 'entity'">
						<a class="btn" href="./?muraAction=cPerm.module&contentid=00000000000000000000000000000000016&siteid=#esapiEncode('url',rc.siteid)#&moduleid=00000000000000000000000000000000016"><i class="mi-group"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions')#</a>
					</span>
				</cfif>
			</div> <!-- /.btn-group -->



			<span v-if="entityname">
				<ul class="breadcrumb" v-if="entityname=='entity'">
						<li><strong><a @click="showAll" onclick="return false;" href="##"><i class="mi-cubes"></i>Custom Entities</a></strong></li>
				</ul>
				<ul class="breadcrumb" v-if="entityname!='entity'">
						<li><a @click="showAll" onclick="return false;" href="##"><i class="mi-cubes"></i>Custom Entities</a></li>
						<li>
							<strong><a href="##" onclick="return false;"><i class="mi-cube"></i>{{entityname}}
								<span v-if="currentparent && currentparent.properties">(for {{currentparent.properties.entityname}}: <span v-for="item in currentparent.properties._displaylist">{{currentparent.properties[item.name]}}) </span>
						</span>
						</a></strong>
						</li>
				</ul>
			</span>
			<div  v-if="!data.list" class="scaffolder-list-entity-loader"><div class="load-inline"></div></div>
			<div v-if="data.list">
				<table width="100%" class="table table-striped table-condensed table-bordered mura-table-grid" id="scaffold-table">
					<thead>
						<tr id="scaffold-filterby">
							<th class="actions"></th>
							<th class="var-width" v-for="item in data.listview">
								<input v-if="!item.relatesto && currentparent && currentparent.properties" type="HIDDEN" class="filter" :name="'filter-' + currentparent.properties.properties.primarykey" :value="currentparent.properties.id">
								<input v-if="!item.relatesto && (item.filter==true || item.filter == 'true')" class="filter" :name="'filter-' + item.name" @keyup="applyKeyFilter">
							</th>
							<th>
								<div class="btn-group pull-right">
									<span v-if="!data.hasFilterApplied"><a class="btn btn-sm btn-default" @click='applyFilter'>Apply Filter</a></span>
									<span v-if="data.hasFilterApplied"><a class="btn btn-sm btn-default" @click='removeFilter'>Remove Filter</a><span>
								</div>
							</th>
						</tr>

						<tr id="scaffold-sortby">
							<th class="actions"></th>
							<th class="var-width" v-for="(item, key, index) in data.listview" :id="'sortby-' + item.name">
								<span v-if="item.relatesto">{{item.displayname}}</span>
								<span v-else @click="applySortBy(item.name)">{{item.displayname}}</span>
							</th>
							<th v-if="entityname == 'entity'">Dynamic</th>
							<th v-else></th>
						</tr>
					</thead>
					<tbody>
						<tr v-if="data.list.length && !listtransition" v-for="(object,index) in data.list">
								<td class="actions">
								<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
								<div class="actions-menu hide">
									<ul class="actions-list">
										<li v-if="entityname != 'entity'">
											<a href="##" onclick="return false;" @click="showForm(object.entityname,object.id)"><i class="mi-edit"></i> Edit</a>
										</li>
										<li v-if="entityname == 'entity'">
											<a href="##" onclick="return false;" @click="showList(object.entityname)"><i class="mi-list"></i> List</a>
										</li>
										<li v-if="entityname == 'entity' && data.issuperuser && object.dynamic">
											<a href="##" onclick="return false;" @click="goToAssembler(object.entityname)"><i class="mi-edit"></i> Edit</a>
										</li>
									</ul>
								</div>
								</td>
								<td class="var-width" v-for="item in data.listview" @click="(entityname == 'entity') ? showList(object.entityname) : ( (item.fieldtype == 'many-to-one' || item.fieldtype == 'one-to-one' ) ? showForm(object[item.name].entityname,object[item.name].id)  : showForm(object.entityname,object.id) )">
										<span v-if="item.fieldtype == 'many-to-one' || item.fieldtype == 'one-to-one'" v-html="object[item.name][item.renderfield]"></span>
										<span v-else-if="item.rendertype == 'htmleditor'" v-html="object[item.name]"></span>
										<span v-else-if="item.datatype=='datetime' || item.datetime=='date'" v-text="formatDate(object[item.name])"></span>
										<span v-else v-text="object[item.name]"></span>
								</td>
								<td v-if="entityname == 'entity' && object.dynamic"><i class="mi-check"></i></td>
								<td v-else><i class="mi-minus"></i></td>
						</tr>
					</tbody>
				</table>

				<div v-if="listtransition" class="scaffolder-list-transition-loader"><div class="load-inline"></div></div>

				<div v-if="!data.list.length && !listtransition" class="help-block-empty">No items available.</div>

				<span v-if="entityname != 'entity'">
					<span v-if="currentparent && currentparent.properties">
						<div class="btn-group">
							<a class="btn" href="##" onclick="return false;" @click="showForm(entityname)"><i class="mi-plus-circle"></i> Add</a>
						</div>
					</span>
					<span v-else>
						<div class="btn-group">
							<a class="btn" href="##" onclick="return false;" @click="showForm(entityname)"><i class="mi-plus-circle"></i> Add</a>
						</div>
					</span>
				</span>
				<span v-if="entityname == 'entity' && data.issuperuser">
					<div class="btn-group">
						<a href="./?muraAction=scaffold.assembler" class="btn"><i class="mi-plus-circle"></i> Add</a>
					</div>
				</span>

				<ul v-if="data.list.length" class="pagination">
					<li><strong>{{data.collection.get('startindex')}}</strong> to <strong>{{data.collection.get('endindex')}}</strong> of <strong>{{data.collection.get('totalitems')}}</strong></li>
					<li><a v-if="data.links.first" @click="applyPage('first')">
						<i class="mi-angle-double-left"></i>
					</a></li>
					<li><a v-if="data.links.previous" @click="applyPage('previous')">
						<i class="mi-angle-left"></i>
					</a></li>
					<li><a v-if="data.links.next" @click="applyPage('next')">
						<i class="mi-angle-right"></i>
					</a></li>
					<li><a v-if="data.links.last" @click="applyPage('last')">
						<i class="mi-angle-double-right"></i>
					</a></li>

					<li class="pull-right">
						<select name="itemsper" class="itemsper" @change="applyItemsPer">
							<option value='10' :selected="this.$parent.itemsper == 10 ? 'selected' : null">10</option>
							<option value='20' :selected="this.$parent.itemsper == 20 ? 'selected' : null">20</option>
							<option value='50' :selected="this.$parent.itemsper == 50 ? 'selected' : null">50</option>
						</select>
					</li>

				</ul>

			</div>
		</div>
	</template>

	<template id="scaffold-form-template">
		<div>

		<div class="btn-group pull-right">
			<button class="btn" @click="clickBack" type="submit" class="btn"><i class="mi-arrow-circle-left"></i> Back</button>
			<button  class="btn" @click="openEndpoint()"><i class="mi-globe"> API Endpoint</i></button>
			<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
				<span v-if="entityname == 'entity'">
					<a class="btn" href="./?muraAction=cPerm.module&contentid=00000000000000000000000000000000016&siteid=#esapiEncode('url',rc.siteid)#&moduleid=00000000000000000000000000000000016"><i class="mi-group"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions')#</a>
				</span>
			</cfif>
		</div>	<!-- /.btn-group -->

		<ul class="breadcrumb">
			<li><a @click="showAll" href="##" onclick="return false;"><i class="mi-cubes"></i>Custom Entities</a></li>
			<li><a @click="clickBack" href="##" onclick="return false;"><i class="mi-cube"></i>{{entityname}}</a></li>
			<li><strong><a href="##" onclick="return false;"><i class="mi-edit"></i>Edit</a></strong></li>
		</ul>
			<div class="help-block-inline">*Required</div>

			<template v-for="property in data.properties">
				<span v-if="property.fieldtype == 'id'">
						<scaffold-field-text-readonly :property=property :model=data.model :entity=data.entity>~</scaffold-field-text-readonly>
				</span>
				<span v-else-if="property.name == 'siteid' || property.relatesto == 'site'">
				</span>
				<span v-else-if="property.fieldtype == 'one-to-one'">
					<scaffold-related-one :property=property :model=data.model :entity=data.entity :data=data :entityid="entityid"></scaffold-related-one>
				</span>
				<span v-else-if="property.fieldtype == 'many-to-one'">
					<scaffold-related-many-one :property=property :model=data.model :entity=data.entity :data=data :entityid="entityid"></scaffold-related-many-one>
				</span>
				<span v-else-if="property.fieldtype == 'one-to-many'">
					<scaffold-related-many v-if="Math.random()" :property=property :model=data.model :entity=data.entity :data=data :entity="data.entity"></scaffold-related-many>
				</span>
				<span v-else-if="property.name.slice(-2).toLowerCase()=='id'">
				</span>
				<div v-else>
					<scaffold-field-textarea v-if="property.rendertype == 'textarea'" :property=property :model=data.model :entity=data.entity></scaffold-field-textarea>
					<scaffold-field-htmleditor v-else-if="property.rendertype === 'htmleditor'" :property=property :model=data.model :entity=data.entity></scaffold-field-htmleditor>
					<scaffold-field-checkbox v-else-if="property.rendertype === 'checkbox'" :property=property :model=data.model :entity=data.entity></scaffold-field-checkbox>
					<scaffold-field-dropdown v-else-if="property.rendertype === 'dropdown'" :property=property :model=data.model :entity=data.entity></scaffold-field-dropdown>
					<scaffold-field-radio v-else-if="property.rendertype === 'radio'" :property=property :model=data.model :entity=data.entity></scaffold-field-radio>
					<scaffold-field-text v-else="property.rendertype == 'textbox'" :property=property :model=data.model :entity=data.entity>~</scaffold-field-text>
				</div>
			</template>

			<div class="btn-group">
				<a href="##" onclick="return false;" @click="clickSave" class="btn"><i class="mi-check-circle"></i> Save</a>
				<a href="##" onclick="return false;" v-if="data.model && !data.model.isnew" @click="clickDelete" class="btn"><i class="mi-trash"></i> Delete</a>
			</div>

		</div>
	</template>

	<template id="scaffold-related-one">
		<div v-if="property.fieldtype && this.$parent.data.parent">
			<input type="hidden" :name="property.fkcolumn" v-model="model[property.fkcolumn]" id="primary-id"
				:data-default="doDefault(this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null,property.fkcolumn ? property.fkcolumn : null,model)"
				:value="this.$parent.data.parent[property.fkcolumn] ? this.$parent.data.parent[property.fkcolumn] : null" :length="property.length">
		</div>
	</template>

	<template id="scaffold-related-many-one">
		<div v-if="loaded || mparent && mparent.properties &&  mparent.list">
			<div v-if="property.relatesto">
				<div class="mura-control-group">
					<label>
						{{property.displayname ? property.displayname : property.label ? property.label : mparent.properties.name}}
					</label>
					<select
					v-model="property.fkcolumn=='primaryKey' ? model[mparent.properties.primarykey] : model[property.fkcolumn]"
					:name="property.fkcolumn">
						<option value="">-- none --</option>
						<option v-for="(option,index) in this.mparent.list" :value="option.id"
							 :selected="option[property.loadkey] == model[property.fkcolumn] ? 'selected' : null">
							{{option[property.renderfield]}}
						</option>
					</select>
					<button class="btn btn-default" v-if="property.fkcolumn" @click="showForm(property.relatesto,model[property.fkcolumn])"><i class="mi-edit"></i> Edit</button>
				</div>
			</div>
		</div>
	</template>

	<template id="scaffold-related-many">
		<div v-if="this.entity.properties.isnew == 0" class="mura-control-group">
			<label>Relationships</label>
		  <div class="mura-control-inline">
				<label><i class="mi-cube"></i> {{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
				<button class="btn btn-sm btn-default" @click="showRelatedList(property.relatesto,entity)">Manage</button>
		  </div>
		</div>
	</template>

	<template id="scaffold-field-text-readonly">
		<div>
			<div v-if="model.errors && model.errors[property.name]" class="help-block-inline">
				{{model.errors[property.name]}}
			</div>
			<div class="mura-control-group">
				<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}</label>
				<input
				  disabled="disabled"
					type="text"
					v-model="model[property.name]"
					:name="property.name"
					:id="property.name"
					:value="model[property.name] ? model[property.name] : property.default"
					:length="property.length"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					>
			</div>
		</div>
	</template>

	<template id="scaffold-field-text">
		<div>
			<div v-if="model.errors && model.errors[property.name]" class="help-block-inline">
				{{model.errors[property.name]}}
			</div>
			<div class="mura-control-group">
				<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}<span v-if="property.required">*</span></label>
				<input
					type="text"
					v-model="model[property.name]"
					:name="property.name"
					:id="property.name"
					:value="model[property.name] ? model[property.name] : property.default"
					:length="property.length"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					>
			</div>
		</div>
	</template>

	<template id="scaffold-field-htmleditor">
		<div>
			<div v-if="model.errors && model.errors[property.name]" class="help-block-inline">
				{{model.errors[property.name]}}
			</div>
			<div class="mura-control-group">
				<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}<span v-if="property.required">*</span></label>
				<textarea
					v-model="model[property.name]"
					class="htmlEditor"
					:id="property.name"
					:name="property.name"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					rows="10"
					>{{model[property.name] ? model[property.name] : property.default}}</textarea>
			</div>
		</div>
	</template>

	<template id="scaffold-field-textarea">
		<div>
			<div v-if="model.errors && model.errors[property.name]" class="help-block-inline">
				{{model.errors[property.name]}}
			</div>
			<div class="mura-control-group">
				<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}<span v-if="property.required">*</span></label>
				<textarea
					v-model="model[property.name]"
					:name="property.name"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					rows="10">{{model[property.name] ? model[property.name] : property.default}}</textarea>
			</div>
		</div>
	</template>

	<template id="scaffold-field-checkbox">
		<div>
			<div v-if="model.errors && model.errors[property.name]" class="help-block-inline">
				{{model.errors[property.name]}}
			</div>
			<div class="mura-control-group">
				<div class="checkbox-group-inline">
					<label :for="property.name" class="checkbox">
						<input type="checkbox" v-model="model[property.name]"
						 v-bind:true-value="1"
			  		 v-bind:false-value="0"
						:name="property.name" :value="1" :checked="typeof model[property.name] != 'undefined'  ? model[property.name] == 1 ? 1 : 0 : property.default"
						:data-validate="property.validate ? property.validate : null"
						:data-validate-message="property.validatemessage ? property.validatemessage : null"
						>
						{{property.displayname ? property.displayname : property.label ? property.label : property.name}}<span v-if="property.required">*</span>
					</label>
				</div>
			</div>
		</div>
	</template>

	<template id="scaffold-field-dropdown">
		<div>
			<div v-if="model.errors && model.errors[property.name]" class="help-block-inline">
				{{model.errors[property.name]}}
			</div>
			<div class="mura-control-group">
				<label :for="property.name">{{property.displayname ? property.displayname : property.label ? property.label : property.name}}<span v-if="property.required">*</span></label>
				<select
					v-model="model[property.name]"
					:name="property.name"
					:data-validate="property.validate ? property.validate : null"
					:data-validate-message="property.validatemessage ? property.validatemessage : null"
					>
					<option v-for="(option,index) in property.optionlist" :value="option" :selected="option == property.default ? 'selected' : null">{{property.optionvaluelist[index]}}</option>
				</select>
			</div>
		</div>
	</template>

	<template id="scaffold-field-radio">
		<div>
			<div v-if="model.errors && model.errors[property.name]" class="help-block-inline">
				{{model.errors[property.name]}}
			</div>
			<div class="mura-control-group">
				<label :for="property.name">
					{{property.displayname ? property.displayname : property.label ? property.label : property.name}}<span v-if="property.required">*</span>
				</label>
				<div class="radio-group">
					<label class="radio" v-for="(option,index) in property.optionlist" :value="option">
						<input
							type="radio"
							v-model="model[property.name]"
							:name="property.name"
							:value="property.optionvaluelist[index]"
							:checked="option == property.default ? 'checked' : null"
							>
							{{option}}
					</label>
				</div>
			</div>
		</div>
	</template>

</cfoutput>
