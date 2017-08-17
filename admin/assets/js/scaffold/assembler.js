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
				var blah = Mura
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
							if(data.properties[i].list) {
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
									if(data.properties[i].list) {
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

				if(item['default'] == 'null')
					item['default'] = "";

				if(!item.orderno)
					item.orderno = orderpx++;



				if(item.optionlist)
					item.optionlist = item.optionlist.split('^');

				if(item.optionvaluelist)
					item.optionvaluelist = item.optionvaluelist.split('^');

				if(!item.rendertype || item.rendertype == "")
					item.rendertype = self.getRenderType( item );

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
			}
		}
	});
	Vue.component('assembler-related-form-template', {
		template: '#assembler-related-form-template',
		props: ['data','datatypes','relatedprops'],
		mounted: function() {

			if(!this.data.cfc)
				this.data.cfc = this.data.relatesto;

			if(!this.data.relatesto)
				this.data.relatesto = this.data.cfc;

			if(this.data.cfc.length) {
				MuraAssembler.getPropertiesAsJSON( this.onLoadComplete,this.data.cfc );
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
			currentView: '',
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
				properties: [],
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
				list: false,
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
				{name:'int',label: 'Boolean'},
				{name:'datetime',label: 'DateTime'},
				{name:'any',label: 'Any'}
			];

			this.fieldtypes = [
				{name:'',label: ''},
				{name:'index',label: 'Index'}
			];

			$( "#assembler-properties" ).sortable (
				{
					axis: 'y'
				}
			);

			var urlparams=Mura.getQueryStringParams(location.search);

			if(urlparams.entityname){
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

					var sortorder = $( "#assembler-properties" ).sortable('toArray',{attribute: "data-index"});

					Mura("#load-spin").show();

					// sort properties based on drag/drop list
					for(var i = 0;i < sortorder.length;i++) {

						var prop = this.model.properties[sortorder[i]];

						prop.pos = prop.orderno = i+1;
						newprops.push(prop);
						console.log(JSON.parse(JSON.stringify(prop)));
					}

					this.model.properties = JSON.parse(JSON.stringify(newprops));
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

					Mura
						.declareEntity(savemodel)
						.then( function(response) {
							Mura("#load-spin").hide();
							alert("Saved!");
							console.log("big load");
							MuraAssembler.all( self.setDynamicObjects );
							Assembler.loadEntity(savemodel.entityname);
						});


			},
			clickDelete: function( entityname ) {
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
				this.currentView="";
			},
			clickDeleteProperty: function() {
				var data = JSON.parse(JSON.stringify(this.data));
				var conf = confirm( "Are you sure you want to delete this property?");

				if (conf) {
					this.model.properties.splice(data.pos, 1);
					this.data = {};
					this.currentView = "";
				}
			},
			clickUpdateRelated: function() {
				if(!this.data.cfc)
					this.data.cfc = this.data.relatesto;
				if(!this.data.relatesto)
					this.data.relatesto = this.data.cfc;

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
				this.currentView="";
			},
			clickDeleteRelated: function() {
				var data = JSON.parse(JSON.stringify(this.data));
				var conf = confirm( "Are you sure you want to delete this relationship?");

				if (conf) {
					this.model.properties.splice(data.pos, 1);
					this.data = {};
					this.currentView = "";
				}
			},
			clickCancel: function() {
				this.data = {};
				this.currentView = "";
			},
			clickClear: function() {
				var conf = confirm( "Are you sure you want to delete *all* of your hard work?");

				if(conf) {
					this.data = {};
					this.model = JSON.parse(JSON.stringify(this.staticmodel));

					this.currentView = "";

					$( "#assembler-properties" ).sortable (
						{
							axis: 'y'
						}
					);

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

				if(!this.data.cfc)
					this.data.cfc = this.data.relatesto;
				if(!this.data.relatesto)
					this.data.relatesto = this.data.cfc;


				this.currentView = "assembler-related-form-template";
			},
			clickLoadEntity: function() {

				Mura("#load-spin").show();

				this.data = {};
				this.currentView = "";

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

				if(!json.dynamic || json.dynamic != true) {
					this.checkIDProp();
					alert("Sorry, you can only edit dynamic Mura ORM objects.");
					return;
				}


				this.model = json;

				console.log(this.model);


				$( "#assembler-properties" ).sortable(
					{
						axis: 'y'
					}
				);
			},
			setDynamicObjects( data ) {
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

			  for(var i = 0;i < self.model.properties.length;i++) {
			    var prop = self.model.properties[i];
			    if(prop.fieldtype &&  prop.fieldtype == "id") {
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
				this.currentView = "";
				this.checkIDProp();
				this.isvisible = true;

				$( "#assembler-properties" ).sortable(
						{
							axis: 'y'
						}
					);

			},
			hide: function() {
				this.isvisible = false;
			}
		}
	});

});
