$( document ).ready(function() {

	// structDelete(application.objectMappings,entity.entityName);

	var MuraORMAssenbler = {
		siteID: '',
		endpoint: '',

		init: function(siteID){

			MuraORMAssenbler.siteID = siteID;
			MuraORMAssenbler.endpoint = '/index.cfm/_api/json/v1/' + MuraORMAssenbler.siteID + '/';

			return MuraORMAssenbler;
		},

		getEndpoint: function() {
			return MuraORMAssenbler.endpoint;
		},

		all: function( listener ) {
			var self = this;
			var data = {};

			Mura
				.get(self.getEndpoint())
				.then(function(data) {

					data.items = data.data.items;
					listener(data);
				});
		},

		getPropertiesAsJSON: function( listener,entityname ) {
			var self = this;
			var data = {};

			console.log(arguments);

			Mura
			.get(self.getEndpoint() + entityname + "/" + "properties")
			.then(function(entity) {

				console.log("GET PROP");
				console.log(entity);

				if(entity.error){
					data={};

				} else {
					data = entity.data;

					if(data.links){
						delete data.links;
					}

					self.processProperties(data);
				}

				listener( data );
			});
		},

		get: function( listener,entityname,id,properties,params ) {
			var self = this;
			var entity = {};
			var data = {};
			var ident = id ? id : 'new';

			if(ident == 'new') {
				var newEntity = Mura
				.getEntity(entityname)
				.new()
				.then(function(entity) {
					//Read properties for UI.

					data.model = entity.getAll();
					data.model._displaylist = [];
					data.entity = entity;

					entity.get('properties').then(function(properties){
						data.properties = properties.getAll().items;

//						self.processProperties(data);

						for(var i = 0;i < data.properties.length;i++) {
							if(data.properties[i].listview) {
								data.model._displaylist.push(data.properties[i]);
							}
						}

						listener(data);

					});
				});

			}
			else {
				Mura
				.getEntity(entityname)
				.loadBy('id',ident) // 3rd argument = params
				.then(function(entity) {
					//Read properties for UI.

					data.model = entity.getAll();
					data.model._displaylist = [];
					data.entity = entity;

					entity.get('properties')
						.then(
							function(properties) {
								data.properties = properties.getAll().items;

								self.processProperties(data);

								for(var i = 0;i < data.properties.length;i++) {
									if(data.properties[i].listview) {
										data.model._displaylist.push(data.properties[i]);
									}
									else if(data.properties[i].fieldtype) {

									}
								}
							listener(data);
						},
						function(error) {
							console.log('error');
							console.log(error);
						}
					);
				});
			}
		},

		processProperties: function( data ) {

			var self = this;
			var orderpx = -10000;

			data.properties.sort(self.propertySort);

			for(var x = 0;x < data.properties.length;x++) {

				var item = JSON.parse(JSON.stringify(data.properties[x]));

				item.pos = x;

				if(item['default'] == 'null'){
					item['default'] = "";
				}

				if(!item.orderno){
					item.orderno = orderpx++;
				}

				if(item.optionlist && item.optionlist.length && Array.isArray(item.optionlist)) {
					item.optionlist = prop.optionlist.join("^");
				}
				if(item.optionvaluelist && item.optionvaluelist.length && Array.isArray(item.optionvaluelist)) {
					item.optionvaluelist = item.optionvaluelist.join("^");
				}

				if(!item.rendertype || item.rendertype == ""){
					item.rendertype = self.getRenderType( item );
				}

				if(!item.displayname || item.displayname == ""){
					item.displayname = item.name;
				}

				if(!item.name || item.name == ""){
					item.name = item.displayname;
				}

				data.properties[x] = item;

			}

			return data;

		},

		propertySort: function(a,b) {

			if(!a.orderno)
				a.orderno = 0;
			if(!b.orderno)
				b.orderno = 0;

			return parseInt(a.orderno) - parseInt(b.orderno);
		},

		getRenderType: function( properties ) {
			if(properties.datatype == 'text')
				return "textarea";
			else if(properties.datatype == 'int' && properties['default'] <= 1)
				return "checkbox";
			else
				return "textfield";

		},
		removeInvalidText:function(text){
			return text.replace(/"/g,'\'');
		}

}

	var MuraAssembler = new MuraORMAssenbler.init( Mura.siteid );

/*
	Vue.component('assembler-error-template', {
		template: '#Assembler-error-template',
		props: ['errordata'],
		methods: {
		}
	});
*/

	Vue.component('assembler-attributes-form-template', {
		template: '#assembler-attributes-form-template',
		props: ['model'],
		mounted: function() {
		},
		methods: {
			removeInvalidText:function(text){
				return MuraAssembler.removeInvalidText(text);
			},
			checkIDProp:function(){
				console.log(this);
				console.log(this.$parent);
				this.$parent.checkIDProp();
			}
		}
	});

	Vue.component('assembler-related-form-template', {
		template: '#assembler-related-form-template',
		props: ['data','datatypes','relatedprops'],
		mounted: function() {
			/*
			if(!this.data.cfc)
				this.data.cfc = this.data.relatesto;

			if(!this.data.relatesto)
				this.data.relatesto = this.data.cfc;

			*/

			if(this.data.relatesto.length) {
				MuraAssembler.getPropertiesAsJSON( this.onLoadComplete,this.data.relatesto );
			}
		},
		methods: {
			clickUpdateRelated: function() {
				this.$forceUpdate();
				this.$parent.clickUpdateRelated();
			},
			clickDeleteRelated: function() {
				this.$forceUpdate();
				this.$parent.clickDeleteRelated();
			},
			clickCancel: function() {
				this.$parent.clickCancel();
			},
			getRelatesToFields: function( event ) {
				MuraAssembler.getPropertiesAsJSON( this.onLoadComplete,event.target.value );
			},
			onLoadComplete: function( data ) {
				var related = [];

				for(var i in data.properties) {
					if(!data.properties[i].cfc && !data.properties[i].relatesto) {
						console.log(data.properties[i]);
						related.push(data.properties[i]);
					}
				}

				this.relatedprops = related;
			}
		}
	});

	Vue.component('assembler-template', {
		template: '#assembler-template',
		props: ['data','rendertypes','datatypes','fieldtypes','model','isupdate'],
		created: function () {
		},
		destroyed: function () {
		},
		updated: function () {
		},
		methods: {
			checkIDProp:function(){
				console.log(this);
				console.log(this.$parent);
				this.$parent.checkIDProp();
			},
			clickEditProperty: function( pos ) {
				this.$parent.clickEditProperty(pos);
			},
			clickEditRelated: function( pos ) {
				this.$parent.clickEditRelated(pos);
			},
			clickAddRelated: function() {
					this.$parent.clickAddRelated();
			},
			clickAddProperty: function() {
				this.$parent.clickAddProperty();
			},
			clickCancel: function() {
				this.$parent.clickCancel();
			},
			clickUpdateProperty: function() {
				this.$forceUpdate();

				this.$parent.clickUpdateProperty();
			},
			clickDeleteProperty: function() {
				this.$forceUpdate();

				this.$parent.clickDeleteProperty();
			},
			removeInvalidText:function(text){
				return MuraAssembler.removeInvalidText(text);
			},
			removeInvalidText:function(text){
				return MuraAssembler.removeInvalidText(text);
			}
		}
	});

	Vue.component('assembler-property-form-template', {
		template: '#assembler-property-form-template',
		props: ['data','rendertypes','datatypes','fieldtypes'],
		methods: {
			clickCancel: function() {
				this.$parent.clickCancel();
			},
			clickUpdateProperty: function() {
				this.$forceUpdate();

				this.$parent.clickUpdateProperty();
			},
			clickDeleteProperty: function() {
				this.$forceUpdate();

				this.$parent.clickDeleteProperty();
			},
			removeInvalidText:function(text){
				return MuraAssembler.removeInvalidText(text);
			},
			removeInvalidText:function(text){
				return MuraAssembler.removeInvalidText(text);
			}
		}
	});

	Vue.component('assembler-related-template', {
		template: '#assembler-related-template',
		props: ['model'],
		methods: {
		}
	});

	Vue.component('assembler-property-template', {
		template: '#assembler-property-template',
		props: ['model'],
		methods: {
			clickEditProperty: function( pos ) {
				this.$parent.clickEditProperty(pos);
			},
			clickEditRelated: function( pos ) {
				this.$parent.clickEditRelated(pos);
			}
		}
	});

	Assembler = new Vue({
		el: '#container-assembler',
		data: {
			alldynamicobjects: [],
			staticmodel: {},
			isupdate: false,
			isvisible: false,
			model: {
				entityname:"",
				displayname:"",
				table : "",
				historical: false,
				orderby: '',
				bundleable: false,
				scaffold: true,
				dynamic: true,
				public: false,
				properties: []
			},
			data: {},
			propertymodel: {},
			relatedmodel: {},
			entityissaved:false,
			currentView: 'assembler-template',
			rendertypes: [],
			datatypes: [],
			fieldtypes: [],
		},
		mounted: function() {

			MuraAssembler.all( this.setDynamicObjects );

			var self = this;

			// available for complete reset
			this.staticmodel = {
				entityname:"",
				displayname:"",
				table:"",
				historical: false,
				orderby: '',
				bundleable: false,
				scaffold: true,
				dynamic: true,
				public: false,
				properties: [
					{
						"default": "default",
						required: true,
						rendertype: "hidden",
						filter: false,
						fieldtype: '',
						dynamic: true,
						"orderno": 2,
						listview: false,
						displayname: "siteid",
						html: "",
						datatype: "varchar",
						length: "25",
						name: "siteid",
						nullable: false
					}
				],
			};

			this.model = JSON.parse(JSON.stringify(this.staticmodel));
			this.checkIDProp();

			this.propertymodel = {
				"default": "",
				required: false,
				rendertype: "textfield",
				filter: false,
				fieldtype: '',
				dynamic: true,
				"orderno": 1,
				listview: false,
				displayname: "",
				html: "",
				datatype: "varchar",
				length: "",
				name: "",
				nullable: true
			};

			this.relatedmodel = {
				"default": "",
				fieldtype: "one-to-many",
				renderfield: '',
				fkcolumn: '',
				cascade: 'none',
				loadkey: '',
				name: "",
				displayname: "",
				relatesto: "",
				datatype: "char",
				length: "35",
				nullable: true
			};

			this.rendertypes = [
				{name:'textfield',label: 'Text Field'},
				{name:'textarea',label: 'Text Area'},
				{name:'htmleditor',label: 'HTML Editor'},
				{name:'dropdown',label: 'Dropdown'},
				{name:'checkbox',label: 'Checkbox'},
				{name:'radio',label: 'Radio'},
				{name:'hidden',label: 'Hidden'},
				{name:'null',label: 'Do not render'}
			];

			this.datatypes = [
				{name:'varchar',label: 'VarChar'},
				{name:'text',label: 'Text'},
				{name:'int',label: 'Int'},
				{name:'float',label: 'Float'},
				{name:'double',label: 'Double'},
				{name:'int',label: 'Boolean'},
				{name:'datetime',label: 'DateTime'},
				{name:'any',label: 'Any'}
			];

			this.fieldtypes = [
				{name:'',label: ''},
				{name:'index',label: 'Index'}
			];

			var urlparams=Mura.getQueryStringParams(location.search);

			this.entityissaved=false;

			if(urlparams.entityname){
				this.entityissaved=true;
				this.loadEntity( urlparams.entityname );
			}

		},
		destroyed: function() {
		},
		watch: {
			handler: function() {
			}
		},
		methods: {
			clickSave: function( entityname ) {
					var self = this;

					var newprops = [];
					var ind = 1;

					Mura("#load-spin").show();

					for(var i = 1;i < this.model.properties.length;i++) {
							this.model.properties[i].orderno = i;
					}

					// make sure there is an "id" field
					var savemodel = JSON.parse(JSON.stringify(this.model));

					for(var i = 0;i < savemodel.properties.length;i++) {
						var prop = savemodel.properties[i];

						// delete internal position marker
						delete prop.pos;

						// collapse option arrays
						if(prop.optionlist && prop.optionlist.length && Array.isArray(prop.optionlist)) {
							prop.optionlist = prop.optionlist.join("^");
						}
						if(prop.optionvaluelist && prop.optionvaluelist.length && Array.isArray(prop.optionvaluelist)) {
							prop.optionvaluelist = prop.optionvaluelist.join("^");
						}

						// for mysql, defaults not allowed for text, blob, comment
						if(prop.datatype == 'text')
							delete prop.default;

						// remove empty attributes
						for(var x in prop) {
							if(prop[x] == "") {
								delete prop[x];
							}
						}

					}

					$('body').append('<div id="action-modal" class="modal-backdrop fade in"></div>');
					$('#action-modal').spin(spinnerArgs);

					Mura
						.declareEntity(savemodel)
						.then( function(response) {
							Mura.getEntity(savemodel.entityname)
							.checkSchema()
							.then(function(){
								self.entityissaved=true;
								$('#action-modal').stop().remove();
								Mura("#alert-assembler-saved").html('<div class="alert alert-success"><span>Entity definition saved</span><button type="button" class="close" data-dismiss="alert"><i class="mi-close"></i></button></div>');
								// console.log("Saved!");
								// console.log("big load");
								MuraAssembler.all( self.setDynamicObjects );
								Assembler.loadEntity(savemodel.entityname);
							})
						});

			},
			clickDelete: function( ) {
				var self=this;
				confirmDialog(
					"Delete dynamic entity?",
					function(){
						confirmDialog(
							"Delete entity schema from database?",
							function(){
								$('body').append('<div id="action-modal" class="modal-backdrop fade in"></div>');
								$('#action-modal').spin(spinnerArgs);
								Mura.
									getEntity(self.model.entityname)
									.undeclareEntity(true)
									.then(function(){
										location.href="./?muraAction=cArch.list&activeTab=2&" + Mura.siteid;
									});
							},
							function(){
								$('body').append('<div id="action-modal" class="modal-backdrop fade in"></div>');
								$('#action-modal').spin(spinnerArgs);
								Mura.
									getEntity(self.model.entityname)
									.undeclareEntity(false)
									.then(function(){
										location.href="./?muraAction=cArch.list&activeTab=2&" + Mura.siteid;
									});
							}
						);
					}
				);
			},
			clickAddRelated: function() {

				this.isupdate = false;
				this.data = JSON.parse(JSON.stringify(this.relatedmodel));

				if(this.data.fkcolumn && this.data.fkcolumn == 'primaryKey') {
					this.data.fkcolumn = '';
				}

				if(this.data.loadkey && this.data.loadkey == 'primaryKey') {
					this.data.loadkey = '';
				}

				this.currentView = "assembler-related-form-template";
			},
			clickAddProperty: function() {
				this.isupdate = false;
				this.data = JSON.parse(JSON.stringify(this.propertymodel));

				this.currentView = "assembler-property-form-template";
			},
			clickUpdateProperty: function() {
				var data = JSON.parse(JSON.stringify(this.data));

				if(data.pos == undefined) {
					data.pos = this.model.properties.length;
					data.orderno =data.pos+1;
					this.model.properties.push(data);
				}
				else {
					this.model.properties.splice(data.pos,1,data);
//					this.model.properties[data.pos] = data;
				}

				this.data = {};
				this.currentView="assembler-template";
			},
			clickDeleteProperty: function() {
				var data = JSON.parse(JSON.stringify(this.data));
				var conf = confirm( "Are you sure you want to delete this property?");

				if (conf) {
					this.model.properties.splice(data.pos, 1);
					this.data = {};
					this.currentView = "assembler-template";
				}
			},
			clickUpdateRelated: function() {
				/*
				if(!this.data.cfc)
					this.data.cfc = this.data.relatesto;
				if(!this.data.relatesto)
					this.data.relatesto = this.data.cfc;
				*/
				var data = JSON.parse(JSON.stringify(this.data));

				if(data.loadkey && data.loadkey == 'primaryKey') {
					data.loadkey = '';
				}

				if(data.fkcolumn && data.fkcolumn == 'primaryKey') {
					data.fkcolumn = '';
				}

				if(data.pos == undefined) {
					data.pos = this.model.properties.length;
					data.orderno =data.pos+1;
					this.model.properties.push(data);
				}
				else {
					this.model.properties.splice(data.pos,1,data);
//					this.model.properties[data.pos] = data;
				}

				this.data = {};
				this.currentView="assembler-template";
			},
			clickDeleteRelated: function() {
				var data = JSON.parse(JSON.stringify(this.data));
				var conf = confirm( "Are you sure you want to delete this relationship?");

				if (conf) {
					this.model.properties.splice(data.pos, 1);
					this.data = {};
					this.currentView = "assembler-template";
				}
			},
			clickCancel: function() {
				this.data = {};
				this.currentView = "assembler-template";
			},
			clickClear: function() {
				var conf = confirm( "Clear the form? Unsaved changes will be lost.");

				if(conf) {
					this.data = {};
					this.model = JSON.parse(JSON.stringify(this.staticmodel));

					this.currentView = "assembler-template";

					this.checkIDProp();
				}
			},
			clickEditProperty: function(pos) {
				this.isupdate = true;
				this.data = JSON.parse(JSON.stringify(this.model.properties[pos]));
				this.currentView = "assembler-property-form-template";
			},
			clickEditRelated: function(pos) {
				this.isupdate = true;
				this.data = JSON.parse(JSON.stringify(this.model.properties[pos]));

				console.log(this.data);

				if(this.data.loadkey && this.data.loadkey == 'primaryKey') {
					this.data.loadkey = '';
				}

				if(this.data.fkcolumn && this.data.fkcolumn == 'primaryKey') {
					this.data.fkcolumn = '';
				}

				/*
				if(!this.data.cfc)
					this.data.cfc = this.data.relatesto;
				if(!this.data.relatesto)
					this.data.relatesto = this.data.cfc;
				*/

				this.currentView = "assembler-related-form-template";
			},
			clickLoadEntity: function() {

				Mura("#load-spin").show();

				this.data = {};
				this.currentView = "assembler-template";

				this.model = JSON.parse(JSON.stringify(this.staticmodel));

				var entityname = $("#loadentity").val();

				if(!entityname.length){
					Mura("#load-spin").hide();
					this.checkIDProp();
					return;
				}

				this.loadEntity( entityname );

			},
			loadEntity: function( entityname ) {
				console.log("LOADING");
				MuraAssembler.getPropertiesAsJSON( this.onLoadComplete,entityname );
			},
			onLoadComplete: function(json) {

				Mura("#load-spin").hide();


				if(!json.dynamic || (json.dynamic != true && json.dynamic != "true")) {
					this.checkIDProp();
					alert("Sorry, you can only edit dynamic Mura ORM objects.");
					return;
				}

				this.model = json;
				this.checkIDProp();
			},
			setDynamicObjects:function( data ) {
/*
				var items = data.items;
				var itemlist = [];

				for(var i in items) {
					if(items[i].dynamic && items[i].dynamic == true) {
						itemlist.push(items[i]);
					}
				}
*/
				this.alldynamicobjects = data.items;
			},
			checkIDProp: function() {
			  var idprop = {};
			  var self = this;
			  var hasid = false;
				var newprops = [];

				this.model.entityname=this.model.entityname.replace(/[^0-9a-z]/gi, '');

			  for(var i = 0;i < self.model.properties.length;i++) {
			    var prop = self.model.properties[i];
			    if(prop.fieldtype &&  prop.fieldtype == "id") {
						if(!this.entityissaved){
							prop.name = this.model.entityname.toLowerCase() + "id";
							prop.displayname = prop.name;
						}
			      return;
			      break;
			    }
			  }

			  idprop.fieldtype = "id";
			  idprop.orderno = -100000;
			  idprop.pos = -100000;
			  idprop.name = this.model.entityname + "id";
			  self.model.properties.unshift(idprop);

			},
			show: function() {
				this.data = {};
				this.model = JSON.parse(JSON.stringify(this.staticmodel));
				this.currentView = "assembler-template";
				this.checkIDProp();
				this.isvisible = true;
			},
			hide: function() {
				this.isvisible = false;
			}
		}
	});

});
