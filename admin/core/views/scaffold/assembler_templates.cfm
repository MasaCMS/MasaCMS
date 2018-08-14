<cfoutput>

<template id="assembler-template">
	<div>
		<div class="half">
			<div class="formtemplate" id="attributes-form-template">

					<div class="mura-control-group">
						<label>Entity Name</label>
						<input type="text" v-model="model.entityname"
							name="entityname" @change="checkIDProp();model.table='dyn_' + model.entityname" :disabled="this.$parent.entityissaved">
					</div>

					<div class="mura-control-group">
						<label>Display Name</label>
						<input type="text" v-model="model.displayname"
							name="displayname" @change="model.displayname=removeInvalidText(model.displayname)">
					</div>

					<div class="mura-control-group">
						<label>Table Name</label>
						<input type="text" v-model="model.table"
							name="table" @change="model.table=model.table.replace(/[^0-9a-z]/gi, '');"
							:disabled="this.$parent.entityissaved">
					</div>

					<div class="mura-control-group">
						<label>Order By (optional)</label>
						<input type="text" v-model="model.orderby"
							name="orderby">
					</div>

					<div class="mura-control-group">
						<label class="checkbox">
							<input type="checkbox" v-model="model.scaffold"
								name="scaffold"
								v-bind:true-value="true"
			   		 		v-bind:false-value="false"
				 				name="scaffold" :checked="model.scaffold == true || model.scaffold == 1 || model.scaffold == 'true' ? 'checked' : null">
				 				Scaffold
				 		</label>
						<label class="checkbox">
						<input type="checkbox" v-model="model.bundleable"
							name="bundleable"
							v-bind:true-value="true"
				   		 v-bind:false-value="false"
			 				name="bundleable" :checked="model.bundleable == true || model.bundleable == 1 || model.bundleable == 'true' ? 'checked' : null">
							Bundleable</label>
						<label class="checkbox">
						<input type="checkbox" v-model="model.public"
							name="public"
							v-bind:true-value="true"
			   		 		v-bind:false-value="false"
			 				name="public" :checked="model.public == true || model.public == 1 || model.public == 'true' ? 'checked' : null">
							Publicly Accessible</label>
					</div>

			</div> <!-- /.formtemplate -->
		</div>
		<!--- property/relationship form --->
		<div class="half">
			<h3>Entity Properties</h3>
			<div class="btn-group">
				<button class="btn" @click='clickAddProperty'><i class="mi-plus-circle"></i> Add Property</button>
				<button class="btn" @click='clickAddRelated'><i class="mi-plus-circle"></i> Add Relationship</button>
			</div>
			<assembler-property-template :model="model"></assembler-property-template>
		</div>
	</div>
</template>

<template id="assembler-property-template">
	<div id="property-template">
		<div class="mura-control justify">
			<draggable :model="model" :list="model.properties" id="assembler-properties">
				<div v-for="(item,index) in model.properties" v-bind:id="'assembler-property-index-' + index" :data-index="index" :data-name="item.name" :key="item.pos">
					<span class="assembler-item-box">
						<span v-if="item.relatesto || item.relatesto" class="assembler-prop">
							<button @click="clickEditRelated(index)"><i class="mi-cogs"></i></button>
						</span>
						<span v-else-if="item.fieldtype == 'id'" class="assembler-prop">
							<button @click="clickEditProperty(index)"><i class="mi-cog"></i></button>
						</span>
						<span v-else class="assembler-prop">
							<button @click="clickEditProperty(index)"><i class="mi-edit"></i></button>
						</span>
						<span v-if="item.displayname && item.displayname.length">{{item.displayname}}</span><span v-else class="assembler-no-displayname">{{item.name}}</span>
						<span v-if="item.relatesto || item.relatesto"> ({{item.fieldtype}} {{item.relatesto}})</span>
						<span v-if="item.rendertype == 'hidden'"> (Hidden)</span>
						<span v-if="item.rendertype == 'null'"> (Does Not Render)</span>
					</span>
				</div>
			</draggable>
		</div>
	</div>
</template> <!--- / assembler-property-template --->

<template id="assembler-property-form-template">
	<div class="formtemplate" id="related-form-template-property">
		<h3>Property Details</h3>
		<div class="mura-control-group">
			<label>Property Name</label>
			<input type="text" v-model="data.name"
				name="name" @change="data.name=data.name.replace(/[^0-9a-z]/gi, '');"
				:disabled="data.fieldtype==='id' && this.$parent.entityissaved===false">
		</div>

		<div class="mura-control-group" v-if="data.fieldtype != 'id'">
			<label>Display Name</label>
			<input type="text" v-model="data.displayname"
				name="displayname" @change="data.displayname=removeInvalidText(data.displayname)">
		</div>

		<div class="mura-control-group" v-if="data.fieldtype != 'id'">
			<label>Data Type</label>
			<select
				v-model="data.datatype"
				name="datatype"
				>
				<option v-for="(option,index) in datatypes" :value="option.name" :selected="option.name == data.datatype ? 'selected' : 'null'">{{datatypes[index].label}}</option>
			</select>
		</div>

		<div class="mura-control-group" v-if="data.fieldtype != 'id'">
			<label>Field Type</label>
			<select
				v-model="data.fieldtype"
				name="fieldtype"
				>
				<option v-for="(option,index) in fieldtypes" :value="option.name" :selected="option.name == data.fieldtype ? 'selected' : 'null'">{{fieldtypes[index].label}}</option>
			</select>
		</div>

		<div class="mura-control-group" v-if="data.fieldtype != 'id'">
			<label>Default</label>
			<input type="text" v-model="data.default"
				name="default">
		</div>

		<div class="mura-control-group" v-if="data.fieldtype != 'id'">
			<label>Form Field</label>
			<select
				v-model="data.rendertype"
				name="rendertype"
				>
				<option v-for="(option,index) in rendertypes" :value="option.name" :selected="option.name == data.rendertype ? 'selected' : 'null'">{{rendertypes[index].label}}</option>
			</select>
		</div>

		<div class="mura-control-group" v-if="data.fieldtype != 'id'">
			<label>Length</label>
			<input type="text" v-model="data.length"
				name="length">
		</div>

		<div class="mura-control-group">
			<span v-if="data.fieldtype != 'id'">
				<label class="checkbox">
				<input type="checkbox" v-model="data.required"
					v-bind:true-value="true"
	   		 	v-bind:false-value="false"
	 				name="required" :checked="data.required == true || data.required == 1 || data.required == 'true' ? 'checked' : null">
					Required</label>
			</span>

			<span v-if="data.fieldtype != 'id'">
				<label class="checkbox">
				<input type="checkbox" v-model="data.listview"
					v-bind:true-value="true"
	   			v-bind:false-value="false"
	 				name="listview" :checked="data.listview == true || data.listview == 1 || data.listview == 'true' ? 'checked' : null">
				List</label>
			</span>

			<span v-if="data.fieldtype != 'id'">
				<label class="checkbox">
					<input type="checkbox" v-model="data.filter"
					v-bind:true-value="true"
	   		 	v-bind:false-value="false"
 					name="filter" :checked="data.filter == true || data.filter == 1 || data.filter == 'true' ? 'checked' : null">
				Filter</label>
			</span>

			<span v-if="data.fieldtype != 'id'">
				<label class="checkbox">
				<input type="checkbox" v-model="data.nullable"
				v-bind:true-value="true"
	   		v-bind:false-value="false"
 				name="nullable" :checked="data.nullable == true || data.nullable == 1 || data.nullable == 'true' ? 'checked' : null">
				Nullable</label>
		</span>
	</div>

		<div class="mura-control-group" v-if="(data.rendertype == 'radio' || data.rendertype == 'dropdown') && data.fieldtype != 'id'">
			<label>Option List</label>
				<div class="help-block-inline">
					"^" Delimiter, e.g. One^Two^Three
				</div>
			<input type="text" v-model="data.optionlist"
				name="optionlist">
		</div>

		<div class="mura-control-group" v-if="(data.rendertype == 'radio' || data.rendertype == 'dropdown') && data.fieldtype != 'id'">
			<label>Option Value List</label>
				<div class="help-block-inline">
					"^" Delimiter, e.g. 1^2^3
				</div>
			<input type="text" v-model="data.optionvaluelist"
				name="optionvaluelist">
		</div>

		<div>
			<div class="btn-group">
				<!---
				<button class="btn" @click="clickUpdateProperty"><i class="mi-save"></i> <span v-if="this.$parent.isupdate">Update Property</span><span v-else>Add Property</span></button>
				<button class="btn" v-if="this.$parent.isupdate && data.fieldtype != 'id'" @click="clickDeleteProperty"><i class="mi-trash"></i> Delete</button>
				<button class="btn" @click='clickCancel'><i class="mi-times-circle"></i> Cancel</button>
				--->
			</div>
		</div>
	</div>
</template> <!--- / assembler-property-form-template --->


<template id="assembler-related-form-template">
	<div class="formtemplate" id="related-form-template">

		<h3>Relationship Details</h3>
		<div class="mura-control-group">
			<label>Property Name</label>
			<input type="text" v-model="data.name"
				name="name" @change="data.name=data.name.replace(/[^0-9a-z]/gi, '');">
		</div>

		<div class="mura-control-group">
			<label>Display Name</label>
			<input type="text" v-model="data.displayname"
				name="displayname">
		</div>

		<div class="mura-control-group">
			<label>Relationship Type</label>
			<select
				v-model="data.fieldtype"
				name="fieldtype"
				>
				<option v-for="(option,index) in ['one-to-many','one-to-one','many-to-one']" :value="option" :selected="option == data.fieldtype ? 'selected' : 'null'">{{option}}</option>
			</select>
		</div>

		<div class="mura-control-group">
			<label>Relates To</label>

			<select
				v-model="data.relatesto"
				name="relatesto"
				@change="getRelatesToFields"
				>
				<option v-for="(option,index) in this.$parent.alldynamicobjects" :value="option.entityname" :selected="option.entityname == data.relatesto ? 'selected' : 'null'">{{option.displayname}}</option>
			</select>
		</div>

		<div class="mura-control-group">
				<label>Foreign Key Column</label>
				<select
					v-model="data.fkcolumn"
					name="fkcolumn"
					>
					<option value="" :selected="!data.fkcolumn || data.fkcolumn == ''">Primary Key</option>
					<option v-for="(option,index) in this.relatedprops" v-if="option.fieldtype='id' || option.fieldtype=='index'" :value="option.name" :selected="option.fkcolumn == option.name ? 'selected' : 'null'">{{option.name}}</option>
				</select>
			</div>

		<div class="mura-control-group">
			<label>Render Field</label>
			<select
				v-model="data.renderfield"
				name="renderfield"
				>
				<option v-for="(option,index) in this.relatedprops" v-if="option.displayname && option.displayname.length > 0" :value="option.name" :selected="((!data.renderfield || data.renderfield.length==0) && option.name=='name') ? 'selected' : 'null'">{{option.displayname}}</option>
			</select>
		</div>

		<div class="mura-control-group">
			<label>Load Key</label>
			<input type="text" v-model="data.loadkey"
				name="loadkey">
		</div>

		<div class="mura-control-group">
			<label>Cascade Delete?</label>
			<select
				v-model="data.cascade"
				name="cascade"
				>
				<option v-for="(option,index) in ['none','delete']" :value="option" :selected="option == data.cascade ? 'selected' : 'null'">{{option}}</option>
			</select>
		</div>

		<div class="mura-control-group" v-if="data.fieldtype == 'many-to-one' || data.fieldtype == '0me-to-one'">
			<label class="checkbox">
			<input type="checkbox" v-model="data.listview"
				v-bind:true-value="true"
				v-bind:false-value="false"
				name="listview" :checked="data.listview == true || data.listview == 1 || data.listview == 'true' ? 'checked' : null">
			List</label>
		</div>

		<div>
			<div class="btn-group">
				<!---
				<button class="btn" @click="clickUpdateRelated"><i class="mi-save"></i> <span v-if="this.$parent.isupdate">Update Relationship</span><span v-else>Add Relationship</span></button>
				<button class="btn" v-if="this.$parent.isupdate" @click="clickDeleteRelated"><i class="mi-trash"></i> Delete</button>
				<button class="btn" @click='clickCancel'><i class="mi-times-circle"></i> Cancel</button>
				--->
			</div>
		</div>
	</div>
</template> <!--- / assembler-related-form-template --->

</cfoutput>
