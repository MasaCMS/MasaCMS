/* This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

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
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */

;(function(window){

	window.mura.UI=window.mura.Core.extend({

		settings:{},
		ormform: false,
		formJSON:{},
		data:{},
		columns:[],
		currentpage: 0,
		entity: {},
		fields:{},
		filters: {},
		datasets: [],
		sortfield: '',
		sortdir: '',
		properties: {},
		rendered: {},
		renderqueue: 0,
		//templateList: ['file','error','textblock','checkbox','checkbox_static','dropdown','dropdown_static','radio','radio_static','nested','textarea','textfield','form','paging','list','table','view','hidden','section'],
		formInit: false,
		responsemessage: "",

		init:function(properties){

			properties || {};

			this.settings = properties;

			if(this.settings.mode == undefined)
				this.settings.mode = 'form';

			this.registerHelpers();
		},

		getTemplates:function() {

			var self = this;

			if(window.mura.templateList.length){
				var temp = window.mura.templateList.pop();

				window.mura.get(
						window.mura.assetpath + '/includes/display_objects/form/templates/' + temp + '.hb'
					).then(function(data) {
					window.mura.templates[temp] = window.mura.Handlebars.compile(data);
					if(!window.mura.templateList.length) {
						if (self.settings.view == 'form') {
							self.loadForm();
						}
						else {
							self.loadList();
						}
					}
					else
						self.getTemplates();
				});
			}
		},

		getPageFieldList:function(){
				var page=this.currentpage;
				var fields = self.formJSON.form.pages[page];
				var result=[];

				for(var f in fields){
					console.log("add: " + self.formJSON.form.fields[fields[f]].name);
					result.push(self.formJSON.form.fields[fields[f]].name);
				}

				console.log(result);

				return result.join(',');
		},

		renderField:function(fieldtype,field) {
			var self = this;
			var templates = window.mura.templates;
			var template = fieldtype;

			if( field.datasetid != "" && self.isormform)
				field.options = self.formJSON.datasets[field.datasetid].options;
			else if(field.datasetid != "") {
				field.dataset = self.formJSON.datasets[field.datasetid];
			}

			self.setDefault( fieldtype,field );

			if (fieldtype == "nested") {
				var context = {};
				context.objectid = field.formid;
				context.paging = 'single';
				context.mode = 'nested';
				context.master = this;

				var nestedForm = new mura.UI( context );
				var holder = mura('<div id="nested-'+field.formid+'"></div>');

				mura(".field-container-" + self.settings.objectid,self.settings.formEl).append(holder);

				context.formEl = holder;
				nestedForm.getForm();

				var html = window.mura.templates[template](field);
				mura(".field-container-" + self.settings.objectid,self.settings.formEl).append(html);
			}
			else {
				if(fieldtype == "checkbox") {
					if(self.ormform) {
						field.selected = [];

						var ds = self.formJSON.datasets[field.datasetid];

						for (var i in ds.datarecords) {
							if(ds.datarecords[i].selected && ds.datarecords[i].selected == 1)
								field.selected.push(i);
						}

						field.selected = field.selected.join(",");
					}
					else {
						template = template + "_static";
					}
				}
				else if(fieldtype == "dropdown") {
					if(!self.ormform) {
						template = template + "_static";
					}
				}
				else if(fieldtype == "radio") {
					if(!self.ormform) {
						template = template + "_static";
					}
				}

				var html = window.mura.templates[template](field);

				mura(".field-container-" + self.settings.objectid,self.settings.formEl).append(html);
			}

		},

		setDefault:function(fieldtype,field) {
			var self = this;

			switch( fieldtype ) {
				case "textfield":
				case "textarea":
					field.value = self.data[field.name];
				 break;
				case "checkbox":

					var ds = self.formJSON.datasets[field.datasetid];

					for(var i in ds.datarecords) {
						if (self.ormform) {
							var sourceid = ds.source + "id";

							ds.datarecords[i].selected = 0;
							ds.datarecords[i].isselected = 0;

							if(self.data[field.name].items && self.data[field.name].items.length) {
								for(var x = 0;x < self.data[field.name].items.length;x++) {
									if (ds.datarecords[i].id == self.data[field.name].items[x][sourceid]) {
										ds.datarecords[i].isselected = 1;
										ds.datarecords[i].selected = 1;
									}
								}
							}
						}
						else {
							if (self.data[field.name] && ds.datarecords[i].value && self.data[field.name].indexOf(ds.datarecords[i].value) > -1) {
								ds.datarecords[i].isselected = 1;
								ds.datarecords[i].selected = 1;
							}
							else {
								ds.datarecords[i].selected = 0;
								ds.datarecords[i].isselected = 0;
							}
						}
					}

				break;
				case "radio":
				case "dropdown":
					var ds = self.formJSON.datasets[field.datasetid];
					for(var i in ds.datarecords) {
						if(self.ormform) {
							if(ds.datarecords[i].id == self.data[field.name+'id']) {
								ds.datarecords[i].isselected = 1;
								field.selected = self.data[field.name+'id'];
							}
							else {
								ds.datarecords[i].selected = 0;
								ds.datarecords[i].isselected = 0;
							}
						}
						else {
							 if(ds.datarecords[i].value == self.data[field.name]) {
								ds.datarecords[i].isselected = 1;
								field.selected = self.data[field.name];
							}
							else {
								ds.datarecords[i].isselected = 0;
							}
						}
					}
				 break;
			}
		},

		renderData:function() {
			var self = this;

			if(self.datasets.length == 0){
				return;
			}

			var dataset = self.formJSON.datasets[self.datasets.pop()];

			if(dataset.sourcetype && dataset.sourcetype != 'muraorm'){
				self.renderData();
			}

			if(dataset.sourcetype=='muraorm'){
				dataset.options = [];
				self.renderqueue++;

				window.mura.getFeed( dataset.source )
					.getQuery()
					.then( function(collection) {
						collection.each(function(item) {
							var itemid = item.get('id');
							dataset.datarecordorder.push( itemid );
							dataset.datarecords[itemid] = item.getAll();
							dataset.datarecords[itemid]['value'] = itemid;
							dataset.datarecords[itemid]['datarecordid'] = itemid;
							dataset.datarecords[itemid]['datasetid'] = dataset.datasetid;
							dataset.datarecords[itemid]['isselected'] = 0;
							dataset.options.push( dataset.datarecords[itemid] );
						});

					})
					.then(function() {
						self.renderqueue--;
						self.renderData();
						if (self.renderqueue == 0) {
							self.renderForm();
						}
					});
			} else {
				if (self.renderqueue == 0) {
					self.renderForm();
				}
			}
		},

		renderForm: function( ) {
			var self = this;

			console.log("render form: " + self.currentpage);

			mura(".field-container-" + self.settings.objectid,self.settings.formEl).empty();

			if(!self.formInit) {
				self.initForm();
			}

			var fields = self.formJSON.form.pages[self.currentpage];

			for(var i = 0;i < fields.length;i++) {
				var field =  self.formJSON.form.fields[fields[i]];
				if( field.fieldtype.fieldtype != undefined && field.fieldtype.fieldtype != "") {
					self.renderField(field.fieldtype.fieldtype,field);
				}
			}

			if(self.ishuman && self.currentpage==(self.formJSON.form.pages.length-1)){
				mura(".field-container-" + self.settings.objectid,self.settings.formEl).append(self.ishuman);
			}

			if (self.settings.mode == 'form') {
				self.renderPaging();
			}

			mura.processMarkup(".field-container-" + self.settings.objectid,self.settings.formEl);

		},

		renderPaging:function() {
			var self = this;
			mura(".error-container-" + self.settings.objectid,self.settings.formEl).empty();

			mura(".paging-container-" + self.settings.objectid,self.settings.formEl).empty();

			if(self.formJSON.form.pages.length == 1) {
				mura(".paging-container-" + self.settings.objectid,self.settings.formEl).append(window.mura.templates['paging']({page:self.currentpage+1,label:"Submit",class:"form-submit"}));
			}
			else {
				if(self.currentpage == 0) {
					mura(".paging-container-" + self.settings.objectid,self.settings.formEl).append(window.mura.templates['paging']({page:1,label:"Next",class:"form-nav"}));
				} else {
					mura(".paging-container-" + self.settings.objectid,self.settings.formEl).append(window.mura.templates['paging']({page:self.currentpage-1,label:"Back",class:'form-nav'}));

					if(self.currentpage+1 < self.formJSON.form.pages.length) {
						mura(".paging-container-" + self.settings.objectid,self.settings.formEl).append(window.mura.templates['paging']({page:self.currentpage+1,label:"Next",class:'form-nav'}));
					}
					else {
						mura(".paging-container-" + self.settings.objectid,self.settings.formEl).append(window.mura.templates['paging']({page:self.currentpage+1,label:"Submit",class:'form-submit  btn-primary'}));
					}
				}

				if(self.backlink != undefined && self.backlink.length)
					mura(".paging-container-" + self.settings.objectid,self.settings.formEl).append(window.mura.templates['paging']({page:self.currentpage+1,label:"Cancel",class:'form-cancel btn-primary pull-right'}));
			}

			mura(".form-submit",self.settings.formEl).click( function() {
				self.submitForm();
			});
			mura(".form-cancel",self.settings.formEl).click( function() {
				self.getTableData( self.backlink );
			});


			var formNavHandler=function() {
				self.setDataValues();

				var button = this;

				if(self.ormform) {
					window.mura.getEntity(self.entity)
					.set(
						self.data
					)
					.validate(self.getPageFieldList())
					.then(
						function( entity ) {
							if(entity.hasErrors()){
								self.showErrors( entity.properties.errors );
							} else {
								self.currentpage = mura(button).data('page');
								self.renderForm();
							}
						}
					);
				} else {
					var data=mura.deepExtend({}, self.data, self.settings);
	                data.validateform=true;
					data.formid=data.objectid;
					data.siteid=data.siteid || mura.siteid;
					data.fields=self.getPageFieldList();

	                window.mura.post(
                        window.mura.apiEndpoint + '?method=processAsyncObject',
                        data)
                        .then(function(resp){
                            if(typeof resp.data.errors == 'object' && !mura.isEmptyObject(resp.data.errors)){
                                self.showErrors( resp.data.errors );
                            } else {
								self.currentpage = mura(button).data('page');
                                self.renderForm();
                            }
                        });
				}

				/*
				}
				else {
					console.log('oops!');
				}
				*/
			};

			mura(".form-nav",self.settings.formEl).off('click',formNavHandler).on('click',formNavHandler);
		},

		setDataValues: function() {
			var self = this;
			var multi = {};
			var item = {};
			var valid = [];

			mura(".field-container-" + self.settings.objectid + " input, .field-container-" + self.settings.objectid + " select, .field-container-" + self.settings.objectid + " textarea").each( function() {

				if( mura(this).is('[type="checkbox"]')) {
					if ( multi[mura(this).attr('name')] == undefined )
						multi[mura(this).attr('name')] = [];

					if( this.checked ) {
						if (self.ormform) {
							item = {};
							item['id'] = window.mura.createUUID();
							item[self.entity + 'id'] = self.data.id;
							item[mura(this).attr('source') + 'id'] = mura(this).val();
							item['key'] = mura(this).val();

							multi[mura(this).attr('name')].push(item);
						}
						else {
							multi[mura(this).attr('name')].push(mura(this).val());
						}
					}
				}
				else if( mura(this).is('[type="radio"]')) {
					if( this.checked ) {
						self.data[ mura(this).attr('name') ] = mura(this).val();
						valid[ mura(this).attr('name') ] = self.data[name];
					}
				}
				else {
					self.data[ mura(this).attr('name') ] = mura(this).val();
					valid[ mura(this).attr('name') ] = self.data[mura(this).attr('name')];
				}
			});

			for(var i in multi) {
				if(self.ormform) {
					self.data[ i ].cascade = "replace";
					self.data[ i ].items = multi[ i ];
					valid[ i ] = self.data[i];
				}
				else {
					self.data[ i ] = multi[i].join(",");
					valid[ i ] = multi[i].join(",");
				}
			}

			return valid;

		},

		validate: function( entity,fields ) {
			return true;
		},

		getForm: function( entityid,backlink ) {
			var self = this;
			var formJSON = {};
			var entityName = '';

			if(entityid != undefined)
				self.entityid = entityid;
			else
				delete self.entityid;

			if(backlink != undefined)
				self.backlink = backlink;
			else
				delete self.backlink;

			if(window.mura.templateList.length) {
				self.getTemplates( entityid );
			}
			else {
				self.loadForm();
			}
		},

		loadForm: function( data ) {
			var self = this;

						console.log('a');
						console.log(self.formJSON);


			window.mura.get(
					window.mura.apiEndpoint + '/content/' + self.settings.objectid
					 + '?fields=body,title,filename,responsemessage&ishuman=true'
					).then(function(data) {
					 	formJSON = JSON.parse( data.data.body );

						// old forms
						if(!formJSON.form.pages) {
							formJSON.form.pages = [];
							formJSON.form.pages[0] = formJSON.form.fieldorder;
							formJSON.form.fieldorder = [];
						}

						entityName = data.data.filename.replace(/\W+/g, "");
						self.entity = entityName;
					 	self.formJSON = formJSON;
					 	self.fields = formJSON.form.fields;
					 	self.responsemessage = data.data.responsemessage;
						self.ishuman=data.data.ishuman;

						if (formJSON.form.formattributes && formJSON.form.formattributes.muraormentities == 1) {
							self.ormform = true;
						}

						for(var i in self.formJSON.datasets){
							self.datasets.push(i);
						}

						if(self.ormform) {
						 	self.entity = entityName;

						 	if(self.entityid == undefined) {
								window.mura.get(
									window.mura.apiEndpoint +'/'+ entityName + '/new?expand=all&ishuman=true'
								).then(function(resp) {
									self.data = resp.data;
									self.renderData();
								});
						 	}
						 	else {
								window.mura.get(
									window.mura.apiEndpoint  + '/'+ entityName + '/' + self.entityid + '?expand=all&ishuman=true'
								).then(function(resp) {
									self.data = resp.data;
									self.renderData();
								});
							}
						}
						else {
							self.renderData();
						}
					 }
				);
		},

		initForm: function() {
			var self = this;
			mura(self.settings.formEl).empty();

			if(self.settings.mode != undefined && self.settings.mode == 'nested') {
				var html = window.mura.templates['nested'](self.settings);
			}
			else {
				var html = window.mura.templates['form'](self.settings);
			}

			mura(self.settings.formEl).append(html);

			self.currentpage = 0;
			self.formInit=true;
		},

		submitForm: function() {

			var self = this;
			var valid = self.setDataValues();
			mura(".error-container-" + self.settings.objectid,self.settings.formEl).empty();

			delete self.data.isNew;

			if(self.ormform) {
				console.log('a!');
				window.mura.getEntity(self.entity)
				.set(
					self.data
				)
				.save()
				.then(
					function( entity ) {
						if(self.backlink != undefined) {
							self.getTableData( self.location );
							return;
						}
						mura(self.settings.formEl).html( self.responsemessage );
					},
					function( entity ) {
						self.showErrors( entity.properties.errors );
					}
				);
			}
			else {
				console.log('b!');
				var data=mura.deepExtend({},self.settings,self.data);
				data.saveform=true;
				data.formid=data.objectid;
				data.siteid=data.siteid || mura.siteid;

                window.mura.post(
                        window.mura.apiEndpoint + '?method=processAsyncObject',
                        data)
                        .then(function(resp){
                            if(typeof resp.data.errors == 'object' && !mura.isEmptyObject(resp.data.errors )){
								self.showErrors( resp.data.errors );
                            } else {
                                mura(self.settings.formEl).html( resp.data.responsemessage );
                            }
                        });

			}

		},

		showErrors: function( errors ) {
			var self = this;

			console.log(errors);

			var errorData = {};

			/*
			for(var i in self.fields) {
				var field = self.fields[i];

				if( errors[ field.name ] ) {
					var error = {};
					error.message = field.validatemessage && field.validatemessage.length ? field.validatemessage : errors[field.name];
					error.field = field.name;
					error.label = field.label;
					errorData[field.name] = error;
				}

			}
			*/

			for(var e in errors) {
				if( typeof self.fields[e] != 'undefined' ) {
					var field = self.fields[e]
					var error = {};
					error.message = field.validatemessage && field.validatemessage.length ? field.validatemessage : errors[field.name];
					error.field = field.name;
					error.label = field.label;
					errorData[e] = error;
				} else {
					var error = {};
					error.message = errors[e];
					error.field = '';
					error.label = '';
					errorData[e] = error;
				}
			}

			var html = window.mura.templates['error'](errorData);
			console.log(errorData);

			mura(".error-container-" + self.settings.objectid,self.settings.formEl).html(html);
		},


// lists
		getList: function() {
			var self = this;

			var entityName = '';

			if(window.mura.templateList.length) {
				self.getTemplates();
			}
			else {
				self.loadList();
			}
		},

		filterResults: function() {
			var self = this;
			var before = "";
			var after = "";

			self.filters.filterby = mura("#results-filterby",self.settings.formEl).val();
			self.filters.filterkey = mura("#results-keywords",self.settings.formEl).val();

			if( mura("#date1",self.settings.formEl).length ) {
				if(mura("#date1",self.settings.formEl).val().length) {
					self.filters.from = mura("#date1",self.settings.formEl).val() + " " + mura("#hour1",self.settings.formEl).val() + ":00:00";
					self.filters.fromhour = mura("#hour1",self.settings.formEl).val();
					self.filters.fromdate = mura("#date1",self.settings.formEl).val();
				}
				else {
					self.filters.from = "";
					self.filters.fromhour = 0;
					self.filters.fromdate = "";
				}

				if(mura("#date2",self.settings.formEl).val().length) {
					self.filters.to = mura("#date2",self.settings.formEl).val() + " " + mura("#hour2",self.settings.formEl).val() + ":00:00";
					self.filters.tohour = mura("#hour2",self.settings.formEl).val();
					self.filters.todate = mura("#date2",self.settings.formEl).val();
				}
				else {
					self.filters.to = "";
					self.filters.tohour = 0;
					self.filters.todate = "";
				}
			}

			self.getTableData();
		},

		downloadResults: function() {
			var self = this;

			self.filterResults();

		},


		loadList: function() {
			var self = this;

			window.mura.get(
				window.mura.apiEndpoint + '/content/' + self.settings.objectid
				 + '?fields=body,title,filename,responsemessage'
				).then(function(data) {
				 	formJSON = JSON.parse( data.data.body );
					entityName = data.data.filename.replace(/\W+/g, "");
					self.entity = entityName;
				 	self.formJSON = formJSON;

					if (formJSON.form.formattributes && formJSON.form.formattributes.muraormentities == 1) {
						self.ormform = true;
					}
					else {
						mura(self.settings.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
						return;
					}

					self.getTableData();
			});
		},

		getTableData: function( navlink ) {
			var self = this;

			window.mura.get(
				window.mura.apiEndpoint  + self.entity + '/listviewdescriptor'
			).then(function(resp) {
					self.columns = resp.data;
				window.mura.get(
					window.mura.apiEndpoint + self.entity + '/propertydescriptor/'
				).then(function(resp) {
					self.properties = self.cleanProps(resp.data);
					if( navlink == undefined) {
						navlink = window.mura.apiEndpoint + self.entity + '?sort=' + self.sortdir + self.sortfield;
						var fields = [];
						for(var i = 0;i < self.columns.length;i++) {
							fields.push(self.columns[i].column);
						}
						navlink = navlink + "&fields=" + fields.join(",");

						if (self.filters.filterkey && self.filters.filterkey != '') {
							navlink = navlink + "&" + self.filters.filterby + "=contains^" + self.filters.filterkey;
						}

						if (self.filters.from && self.filters.from != '') {
							navlink = navlink + "&created[1]=gte^" + self.filters.from;
						}
						if (self.filters.to && self.filters.to != '') {
							navlink = navlink + "&created[2]=lte^" + self.filters.to;
						}
					}

					window.mura.get(
						navlink
					).then(function(resp) {
						self.data = resp.data;
						self.location = self.data.links.self;

						var tableData = {rows:self.data,columns:self.columns,properties:self.properties,filters:self.filters};
						self.renderTable( tableData );
					});

				});
			});

		},

		renderTable: function( tableData ) {
			var self = this;

			var html = window.mura.templates['table'](tableData);
			mura(self.settings.formEl).html( html );

			if (self.settings.view == 'list') {
				mura("#date-filters",self.settings.formEl).empty();
				mura("#btn-results-download",self.settings.formEl).remove();
			}
			else {
				if (self.settings.render == undefined) {
					mura(".datepicker", self.settings.formEl).datepicker();
				}

				mura("#btn-results-download",self.settings.formEl).click( function() {
					self.downloadResults();
				});
			}

			mura("#btn-results-search",self.settings.formEl).click( function() {
				self.filterResults();
			});


			mura(".data-edit",self.settings.formEl).click( function() {
				self.renderCRUD( mura(this).attr('data-value'),mura(this).attr('data-pos'));
			});
			mura(".data-view",self.settings.formEl).click( function() {
				self.loadOverview(mura(this).attr('data-value'),mura(this).attr('data-pos'));
			});
			mura(".data-nav",self.settings.formEl).click( function() {
				self.getTableData( mura(this).attr('data-value') );
			});

			mura(".data-sort").click( function() {

				var sortfield = mura(this).attr('data-value');

				if(sortfield == self.sortfield && self.sortdir == '')
					self.sortdir = '-';
				else
					self.sortdir = '';

				self.sortfield = mura(this).attr('data-value');
				self.getTableData();

			});
		},


		loadOverview: function(itemid,pos) {
			var self = this;

			window.mura.get(
				window.mura.apiEndpoint + entityName + '/' + itemid + '?expand=all'
				).then(function(resp) {
					self.item = resp.data;

					self.renderOverview();
			});
		},

		renderOverview: function() {
			var self = this;

			console.log('ia');
			console.log(self.item);

			mura(self.settings.formEl).empty();

			var html = window.mura.templates['view'](self.item);
			mura(self.settings.formEl).append(html);

			mura(".nav-back",self.settings.formEl).click( function() {
				self.getTableData( self.location );
			});
		},

		renderCRUD: function( itemid,pos ) {
			var self = this;

			self.formInit = 0;
			self.initForm();

			self.getForm(itemid,self.data.links.self);
		},

		cleanProps: function( props ) {
			var propsOrdered = {};
			var propsRet = {};
			var ct = 100000;

			delete props.isNew;
			delete props.created;
			delete props.lastUpdate;
			delete props.errors;
			delete props.saveErrors;
			delete props.instance;
			delete props.instanceid;
			delete props.frommuracache;
			delete props[self.entity + "id"];

			for(var i in props) {
				if( props[i].orderno != undefined) {
					propsOrdered[props[i].orderno] = props[i];
				}
				else {
					propsOrdered[ct++] = props[i];
				}
			}

			Object.keys(propsOrdered)
				.sort()
					.forEach(function(v, i) {
					propsRet[v] = propsOrdered[v];
			});

			return propsRet;
		},

		registerHelpers: function() {
			var self = this;

			window.mura.Handlebars.registerHelper('eachColRow',function(row, columns, options) {
				var ret = "";
				for(var i = 0;i < columns.length;i++) {
					ret = ret + options.fn(row[columns[i].column]);
				}
				return ret;
			});

			window.mura.Handlebars.registerHelper('eachProp',function(data, options) {
				var ret = "";
				var obj = {};

				for(var i in self.properties) {
					obj.displayName = self.properties[i].displayName;
					if( self.properties[i].fieldtype == "one-to-one" ) {
						obj.displayValue = data[ self.properties[i].cfc ].val;
					}
					else
						obj.displayValue = data[ self.properties[i].column ];

					ret = ret + options.fn(obj);
				}
				return ret;
			});

			window.mura.Handlebars.registerHelper('eachKey',function(properties, by, options) {
				var ret = "";
				var item = "";
				for(var i in properties) {
					item = properties[i];

					if(item.column == by)
						item.selected = "Selected";

					if(item.rendertype == 'textfield')
						ret = ret + options.fn(item);
				}

				return ret;
			});

			window.mura.Handlebars.registerHelper('eachHour',function(hour, options) {
				var ret = "";
				var h = 0;
				var val = "";

				for(var i = 0;i < 24;i++) {

					if(i == 0 ) {
						val = {label:"12 AM",num:i};
					}
					else if(i <12 ) {
						h = i;
						val = {label:h + " AM",num:i};
					}
					else if(i == 12 ) {
						h = i;
						val = {label:h + " PM",num:i};
					}
					else {
						h = i-12;
						val = {label:h + " PM",num:i};
					}

					if(hour == i)
						val.selected = "selected";

					ret = ret + options.fn(val);
				}
				return ret;
			});

			window.mura.Handlebars.registerHelper('eachColButton',function(row, options) {
				var ret = "";

				row.label='View';
				row.type='data-view';

				// only do view if there are more properties than columns
				if( Object.keys(self.properties).length > self.columns.length) {
					ret = ret + options.fn(row);
				}

				if( self.settings.view == 'edit') {
					row.label='Edit';
					row.type='data-edit';

					ret = ret + options.fn(row);
				}

				return ret;
			});

			window.mura.Handlebars.registerHelper('eachCheck',function(checks, selected, options) {
				var ret = "";

				for(var i = 0;i < checks.length;i++) {
					if( selected.indexOf( checks[i].id ) > -1 )
						checks[i].isselected = 1;
					else
					 	checks[i].isselected = 0;

					ret = ret + options.fn(checks[i]);
				}
				return ret;
			});
			window.mura.Handlebars.registerHelper('eachStatic',function(dataset, options) {
				var ret = "";

				for(var i = 0;i < dataset.datarecordorder.length;i++) {
					ret = ret + options.fn(dataset.datarecords[dataset.datarecordorder[i]]);
				}
				return ret;
			});
		}





	});

})(window);
