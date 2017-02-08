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
	;(function (root, factory) {
	    if (typeof define === 'function' && define.amd) {
	        // AMD. Register as an anonymous module.
	        define(['Mura'], factory);
	    } else if (typeof module === 'object' && module.exports) {
	        // Node. Does not work with strict CommonJS, but
	        // only CommonJS-like environments that support module.exports,
	        // like Node.
	        factory(require('Mura'));
	    } else {
	        // Browser globals (root is window)
	        factory(root.Mura);
	    }
	}(this, function (Mura) {
		Mura.DisplayObject.Form=Mura.UI.extend({
			context:{},
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
			inlineerrors: true,
			properties: {},
			rendered: {},
			renderqueue: 0,
			//templateList: ['file','error','textblock','checkbox','checkbox_static','dropdown','dropdown_static','radio','radio_static','nested','textarea','textfield','form','paging','list','table','view','hidden','section'],
			formInit: false,
			responsemessage: "",
			rb: {
				btnsubmitclass:"form-submit",
				btnsubmitlabel:"Submit",
				btnnextlabel:"Next",
				btnbacklabel:"Back",
				btncancellabel:"Cancel"
			},
			render:function(){

				if(this.context.mode == undefined){
					this.context.mode = 'form';
				}

				var ident = "mura-form-" + this.context.objectid;

				this.context.formEl = "#" + ident;

				this.context.html = "<div id='"+ident+"'></div>";

				mura(this.context.targetEl).html( this.context.html );

				if (this.context.view == 'form') {
					this.getForm();
				}
				else {
					this.getList();
				}
				return this;
			},

			getTemplates:function() {

				var self = this;

				if (self.context.view == 'form') {
					self.loadForm();
				} else {
					self.loadList();
				}

				/*
				if(Mura.templatesLoaded.length){
					var temp = Mura.templateList.pop();

					Mura.ajax(
						{
							url:Mura.assetpath + '/includes/display_objects/form/templates/' + temp + '.hb',
							type:'get',
							xhrFields:{ withCredentials: false },
							success:function(data) {
								Mura.templates[temp] = Mura.Handlebars.compile(data);
								if(!Mura.templateList.length) {
									if (self.context.view == 'form') {
										self.loadForm();
									} else {
										self.loadList();
									}
								} else {
									self.getTemplates();
								}
							}
						}
					);

				}
				*/
			},

			getPageFieldList:function(){
					var page=this.currentpage;
					var fields = self.formJSON.form.pages[page];
					var result=[];

					for(var f=0;f < fields.length;f++){
						//console.log("add: " + self.formJSON.form.fields[fields[f]].name);
						result.push(self.formJSON.form.fields[fields[f]].name);
					}

					//console.log(result);

					return result.join(',');
			},

			renderField:function(fieldtype,field) {
				var self = this;
				var templates = Mura.templates;
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

					var nestedForm = new Mura.FormUI( context );
					var holder = mura('<div id="nested-'+field.formid+'"></div>');

					mura(".field-container-" + self.context.objectid,self.context.formEl).append(holder);

					context.formEl = holder;
					nestedForm.getForm();

					var html = Mura.templates[template](field);
					mura(".field-container-" + self.context.objectid,self.context.formEl).append(html);
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

					var html = Mura.templates[template](field);

					mura(".field-container-" + self.context.objectid,self.context.formEl).append(html);
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

						for(var i=0;i<ds.datarecords.length;i++) {
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

						for(var i=0;i<ds.datarecords.length;i++) {
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
					if (self.renderqueue == 0) {
						self.renderForm();
					}
					return;
				}

				var dataset = self.formJSON.datasets[self.datasets.pop()];

				if(dataset.sourcetype && dataset.sourcetype != 'muraorm'){
					self.renderData();
					return;
				}

				if(dataset.sourcetype=='muraorm'){
					dataset.options = [];
					self.renderqueue++;

					Mura.getFeed( dataset.source )
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

				//console.log("render form: " + self.currentpage);

				mura(".field-container-" + self.context.objectid,self.context.formEl).empty();

				if(!self.formInit) {
					self.initForm();
				}

				var fields = self.formJSON.form.pages[self.currentpage];

				for(var i = 0;i < fields.length;i++) {
					var field =  self.formJSON.form.fields[fields[i]];
					try {
						if( field.fieldtype.fieldtype != undefined && field.fieldtype.fieldtype != "") {
							self.renderField(field.fieldtype.fieldtype,field);
						}
					} catch(e){
						console.log('Error rendering form field:');
						console.log(field);
					}
				}

				if(self.ishuman && self.currentpage==(self.formJSON.form.pages.length-1)){
					mura(".field-container-" + self.context.objectid,self.context.formEl).append(self.ishuman);
				}

				if (self.context.mode == 'form') {
					self.renderPaging();
				}

				Mura.processMarkup(".field-container-" + self.context.objectid,self.context.formEl);

				self.trigger('afterRender');

			},

			renderPaging:function() {
				var self = this;
				var submitlabel=(typeof self.formJSON.form.formattributes != 'undefined' && typeof self.formJSON.form.formattributes.submitlabel != 'undefined' && self.formJSON.form.formattributes.submitlabel) ? self.formJSON.form.formattributes.submitlabel : self.rb.btnsubmitlabel;

				mura(".error-container-" + self.context.objectid,self.context.formEl).empty();

				mura(".paging-container-" + self.context.objectid,self.context.formEl).empty();

				if(self.formJSON.form.pages.length == 1) {
					mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:submitlabel,"class":self.rb.btnsubmitclass}));
				}
				else {
					if(self.currentpage == 0) {
						mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:1,label:self.rb.btnnextlabel,"class":"form-nav"}));
					} else {
						mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage-1,label:self.rb.btnbacklabel,"class":'form-nav'}));

						if(self.currentpage+1 < self.formJSON.form.pages.length) {
							mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:self.rb.btnnextlabel,"class":'form-nav'}));
						}
						else {
							mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:submitlabel,"class":'form-submit  btn-primary'}));
						}
					}

					if(self.backlink != undefined && self.backlink.length)
						mura(".paging-container-" + self.context.objectid,self.context.formEl).append(Mura.templates['paging']({page:self.currentpage+1,label:self.rb.btncancellabel,"class":'form-cancel btn-primary pull-right'}));
				}

				mura(".form-submit",self.context.formEl).click( function() {
					self.submitForm();
				});
				mura(".form-cancel",self.context.formEl).click( function() {
					self.getTableData( self.backlink );
				});


				var formNavHandler=function() {
					self.setDataValues();

					var keepGoing=self.onPageSubmit.call(self.context.targetEl);
					if(typeof keepGoing != 'undefined' && !keepGoing){
						return;
					}

					var button = this;

					if(self.ormform) {
						Mura.getEntity(self.entity)
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
						var data=Mura.deepExtend({}, self.data, self.context);
		                data.validateform=true;
						data.formid=data.objectid;
						data.siteid=data.siteid || Mura.siteid;
						data.fields=self.getPageFieldList();

		                Mura.post(
	                        Mura.apiEndpoint + '?method=processAsyncObject',
	                        data)
	                        .then(function(resp){
	                            if(typeof resp.data.errors == 'object' && !Mura.isEmptyObject(resp.data.errors)){
									self.showErrors( resp.data.errors );
	                            } else if(typeof resp.data.redirect != 'undefined') {
									if(resp.data.redirect && resp.data.redirect != location.href){
										location.href=resp.data.redirect;
									} else {
										location.reload(true);
									}
								} else {
									self.currentpage = mura(button).data('page');
	                                self.renderForm();
	                            }
	                        }
							);
					}

					/*
					}
					else {
						console.log('oops!');
					}
					*/
				};

				mura(".form-nav",self.context.formEl).off('click',formNavHandler).on('click',formNavHandler);
			},

			setDataValues: function() {
				var self = this;
				var multi = {};
				var item = {};
				var valid = [];
				var currentPage = {};

				mura(".field-container-" + self.context.objectid + " input, .field-container-" + self.context.objectid + " select, .field-container-" + self.context.objectid + " textarea").each( function() {

					currentPage[mura(this).attr('name')]=true;

					if( mura(this).is('[type="checkbox"]')) {
						if ( multi[mura(this).attr('name')] == undefined )
							multi[mura(this).attr('name')] = [];

						if( this.checked ) {
							if (self.ormform) {
								item = {};
								item['id'] = Mura.createUUID();
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

				if(typeof FormData != 'undefined'){
					var frm=document.getElementById('frm' + self.context.objectid);
					for(var p in currentPage){
						if(currentPage.hasOwnProperty(p) && typeof self.data[p] != 'undefined'){
							if(p.indexOf("_attachment") > -1 && typeof frm[p] != 'undefined'){
								self.attachments[p]=frm[p].files[0];
							}
						}
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

				if(entityid != undefined){
					self.entityid = entityid;
				} else {
					delete self.entityid;
				}

				if(backlink != undefined){
					self.backlink = backlink;
				} else {
					delete self.backlink;
				}

				/*
				if(Mura.templateList.length) {
					self.getTemplates( entityid );
				}
				else {
				*/
					self.loadForm();
				//}
			},

			loadForm: function( data ) {
				var self = this;

				//console.log('a');
				//console.log(self.formJSOrenderN);

				formJSON = JSON.parse(self.context.def);

				// old forms
				if(!formJSON.form.pages) {
					formJSON.form.pages = [];
					formJSON.form.pages[0] = formJSON.form.fieldorder;
					formJSON.form.fieldorder = [];
				}


				if(typeof formJSON.datasets != 'undefined'){
					for(var d in formJSON.datasets){
						if(typeof formJSON.datasets[d].DATARECORDS != 'undefined'){
							formJSON.datasets[d].datarecords=formJSON.datasets[d].DATARECORDS;
							delete formJSON.datasets[d].DATARECORDS;
						}
						if(typeof formJSON.datasets[d].DATARECORDORDER != 'undefined'){
							formJSON.datasets[d].datarecordorder=formJSON.datasets[d].DATARECORDORDER;
							delete formJSON.datasets[d].DATARECORDORDER;
						}
					}
				}

				entityName = self.context.filename.replace(/\W+/g, "");
				self.entity = entityName;
				self.formJSON = formJSON;
				self.fields = formJSON.form.fields;
				self.responsemessage = self.context.responsemessage;
				self.ishuman=self.context.ishuman;

				if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
					self.ormform = true;
				}

				for(var i=0;i < self.formJSON.datasets;i++){
					self.datasets.push(i);
				}

				if(self.ormform) {
					self.entity = entityName;

					if(self.entityid == undefined) {
						Mura.get(
							Mura.apiEndpoint +'/'+ entityName + '/new?expand=all&ishuman=true'
						).then(function(resp) {
							self.data = resp.data;
							self.renderData();
						});
					}
					else {
						Mura.get(
							Mura.apiEndpoint  + '/'+ entityName + '/' + self.entityid + '?expand=all&ishuman=true'
						).then(function(resp) {
							self.data = resp.data;
							self.renderData();
						});
					}
				}
				else {
					self.renderData();
				}
				/*
				Mura.get(
						Mura.apiEndpoint + '/content/' + self.context.objectid
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

							if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
								self.ormform = true;
							}

							for(var i=0;i < self.formJSON.datasets;i++){
								self.datasets.push(i);
							}

							if(self.ormform) {
							 	self.entity = entityName;

							 	if(self.entityid == undefined) {
									Mura.get(
										Mura.apiEndpoint +'/'+ entityName + '/new?expand=all&ishuman=true'
									).then(function(resp) {
										self.data = resp.data;
										self.renderData();
									});
							 	}
							 	else {
									Mura.get(
										Mura.apiEndpoint  + '/'+ entityName + '/' + self.entityid + '?expand=all&ishuman=true'
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

				*/
			},

			initForm: function() {
				var self = this;
				mura(self.context.formEl).empty();

				if(self.context.mode != undefined && self.context.mode == 'nested') {
					var html = Mura.templates['nested'](self.context);
				}
				else {
					var html = Mura.templates['form'](self.context);
				}

				mura(self.context.formEl).append(html);

				self.currentpage = 0;
				self.attachments={};
				self.formInit=true;
			},

			onSubmit: function(){
				return true;
			},

			onPageSubmit: function(){
				return true;
			},

			submitForm: function() {

				var self = this;
				var valid = self.setDataValues();
				mura(".error-container-" + self.context.objectid,self.context.formEl).empty();

				var keepGoing=this.onSubmit.call(this.context.targetEl);
				if(typeof keepGoing != 'undefined' && !keepGoing){
					return;
				}

				delete self.data.isNew;

				mura(self.context.formEl)
					.find('form')
					.trigger('formSubmit');

				if(self.ormform) {
					//console.log('a!');
					Mura.getEntity(self.entity)
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

							if(typeof resp.data.redirect != 'undefined'){
								if(resp.data.redirect && resp.data.redirect != location.href){
									location.href=resp.data.redirect;
								} else {
									location.reload(true);
								}
							} else {
								mura(self.context.formEl).html( Mura.templates['success'](data) );
							}
						},
						function( entity ) {
							self.showErrors( entity.properties.errors );
						}
					);
				}
				else {
					//console.log('b!');

					if(typeof FormData == 'undefined'){
						var data=Mura.deepExtend({},self.context,self.data);
						data.saveform=true;
						data.formid=data.objectid;
						data.siteid=data.siteid || Mura.siteid;
						data.contentid=Mura.contentid || '';
						data.contenthistid=Mura.contenthistid || '';
						delete data.filename;

					} else {
						var rawdata=Mura.deepExtend({},self.context,self.data);
						rawdata.saveform=true;
						rawdata.formid=rawdata.objectid;
						rawdata.siteid=rawdata.siteid || Mura.siteid;
						rawdata.contentid=Mura.contentid || '';
						rawdata.contenthistid=Mura.contenthistid || '';
						delete rawdata.filename;

						var data=new FormData();

						for(var p in rawdata){
							if(rawdata.hasOwnProperty(p)){
								if(typeof self.attachments[p] != 'undefined'){
									data.append(p,self.attachments[p]);
								} else {
									data.append(p,rawdata[p]);
								}
							}
						}
					}

	                Mura.post(
	                        Mura.apiEndpoint + '?method=processAsyncObject',
	                        data)
	                        .then(function(resp){
	                            if(typeof resp.data.errors == 'object' && !Mura.isEmptyObject(resp.data.errors )){
									self.showErrors( resp.data.errors );
								} else if(typeof resp.data.redirect != 'undefined'){
									if(resp.data.redirect && resp.data.redirect != location.href){
										location.href=resp.data.redirect;
									} else {
										location.reload(true);
									}
	                            } else {
									mura(self.context.formEl).html( Mura.templates['success'](resp.data) );
								}
	                        });

				}

			},

			showErrors: function( errors ) {
				var self = this;
				var frm=mura(this.context.formEl);
				var frmErrors=frm.find(".error-container-" + self.context.objectid);

				frm.find('.mura-response-error').remove();

				console.log(errors);

				//var errorData = {};

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
						//errorData[e] = error;
					} else {
						var error = {};
						error.message = errors[e];
						error.field = '';
						error.label = '';
						//errorData[e] = error;
					}

					if(this.inlineerrors){
						var label=mura(this.context.formEl).find('label[for="' + e + '"]');

						if(label.length){
							label.node.insertAdjacentHTML('afterend',Mura.templates['error'](error));
						} else {
							frmErrors.append(Mura.templates['error'](error));
						}
					} else {
						frmErrors.append(Mura.templates['error'](error));
					}
				}

				//var html = Mura.templates['error'](errorData);
				//console.log(errorData);

				mura(self.context.formEl).find('.g-recaptcha-container').each(function(el){
					grecaptcha.reset(el.getAttribute('data-widgetid'));
				});

				//mura(".error-container-" + self.context.objectid,self.context.formEl).html(html);
			},


	// lists
			getList: function() {
				var self = this;

				var entityName = '';

				/*
				if(Mura.templateList.length) {
					self.getTemplates();
				}
				else {
				*/
					self.loadList();
				//}
			},

			filterResults: function() {
				var self = this;
				var before = "";
				var after = "";

				self.filters.filterby = mura("#results-filterby",self.context.formEl).val();
				self.filters.filterkey = mura("#results-keywords",self.context.formEl).val();

				if( mura("#date1",self.context.formEl).length ) {
					if(mura("#date1",self.context.formEl).val().length) {
						self.filters.from = mura("#date1",self.context.formEl).val() + " " + mura("#hour1",self.context.formEl).val() + ":00:00";
						self.filters.fromhour = mura("#hour1",self.context.formEl).val();
						self.filters.fromdate = mura("#date1",self.context.formEl).val();
					}
					else {
						self.filters.from = "";
						self.filters.fromhour = 0;
						self.filters.fromdate = "";
					}

					if(mura("#date2",self.context.formEl).val().length) {
						self.filters.to = mura("#date2",self.context.formEl).val() + " " + mura("#hour2",self.context.formEl).val() + ":00:00";
						self.filters.tohour = mura("#hour2",self.context.formEl).val();
						self.filters.todate = mura("#date2",self.context.formEl).val();
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

				formJSON = self.context.formdata;
				entityName = dself.context.filename.replace(/\W+/g, "");
				self.entity = entityName;
				self.formJSON = formJSON;

				if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
					self.ormform = true;
				}
				else {
					mura(self.context.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
					return;
				}

				self.getTableData();

				/*
				Mura.get(
					Mura.apiEndpoint + 'content/' + self.context.objectid
					 + '?fields=body,title,filename,responsemessage'
					).then(function(data) {
					 	formJSON = JSON.parse( data.data.body );
						entityName = data.data.filename.replace(/\W+/g, "");
						self.entity = entityName;
					 	self.formJSON = formJSON;

						if (formJSON.form.formattributes && formJSON.form.formattributes.Muraormentities == 1) {
							self.ormform = true;
						}
						else {
							mura(self.context.formEl).append("Unsupported for pre-Mura 7.0 MuraORM Forms.");
							return;
						}

						self.getTableData();
				});
				*/
			},

			getTableData: function( navlink ) {
				var self = this;

				Mura.get(
					Mura.apiEndpoint  + self.entity + '/listviewdescriptor'
				).then(function(resp) {
						self.columns = resp.data;
					Mura.get(
						Mura.apiEndpoint + self.entity + '/propertydescriptor/'
					).then(function(resp) {
						self.properties = self.cleanProps(resp.data);
						if( navlink == undefined) {
							navlink = Mura.apiEndpoint + self.entity + '?sort=' + self.sortdir + self.sortfield;
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

						Mura.get(
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

				var html = Mura.templates['table'](tableData);
				mura(self.context.formEl).html( html );

				if (self.context.view == 'list') {
					mura("#date-filters",self.context.formEl).empty();
					mura("#btn-results-download",self.context.formEl).remove();
				}
				else {
					if (self.context.render == undefined) {
						mura(".datepicker", self.context.formEl).datepicker();
					}

					mura("#btn-results-download",self.context.formEl).click( function() {
						self.downloadResults();
					});
				}

				mura("#btn-results-search",self.context.formEl).click( function() {
					self.filterResults();
				});


				mura(".data-edit",self.context.formEl).click( function() {
					self.renderCRUD( mura(this).attr('data-value'),mura(this).attr('data-pos'));
				});
				mura(".data-view",self.context.formEl).click( function() {
					self.loadOverview(mura(this).attr('data-value'),mura(this).attr('data-pos'));
				});
				mura(".data-nav",self.context.formEl).click( function() {
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

				Mura.get(
					Mura.apiEndpoint + entityName + '/' + itemid + '?expand=all'
					).then(function(resp) {
						self.item = resp.data;

						self.renderOverview();
				});
			},

			renderOverview: function() {
				var self = this;

				//console.log('ia');
				//console.log(self.item);

				mura(self.context.formEl).empty();

				var html = Mura.templates['view'](self.item);
				mura(self.context.formEl).append(html);

				mura(".nav-back",self.context.formEl).click( function() {
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

				delete props.isnew;
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

				Mura.Handlebars.registerHelper('eachColRow',function(row, columns, options) {
					var ret = "";
					for(var i = 0;i < columns.length;i++) {
						ret = ret + options.fn(row[columns[i].column]);
					}
					return ret;
				});

				Mura.Handlebars.registerHelper('eachProp',function(data, options) {
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

				Mura.Handlebars.registerHelper('eachKey',function(properties, by, options) {
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

				Mura.Handlebars.registerHelper('eachHour',function(hour, options) {
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

				Mura.Handlebars.registerHelper('eachColButton',function(row, options) {
					var ret = "";

					row.label='View';
					row.type='data-view';

					// only do view if there are more properties than columns
					if( Object.keys(self.properties).length > self.columns.length) {
						ret = ret + options.fn(row);
					}

					if( self.context.view == 'edit') {
						row.label='Edit';
						row.type='data-edit';

						ret = ret + options.fn(row);
					}

					return ret;
				});

				Mura.Handlebars.registerHelper('eachCheck',function(checks, selected, options) {
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

				Mura.Handlebars.registerHelper('eachStatic',function(dataset, options) {
					var ret = "";

					for(var i = 0;i < dataset.datarecordorder.length;i++) {
						ret = ret + options.fn(dataset.datarecords[dataset.datarecordorder[i]]);
					}
					return ret;
				});

				Mura.Handlebars.registerHelper('inputWrapperClass',function() {
					var escapeExpression=Mura.Handlebars.escapeExpression;
					var returnString='mura-control-group';

					if(this.wrappercssclass){
						returnString += ' ' + escapeExpression(this.wrappercssclass);
					}

					if(this.isrequired){
						returnString += ' req';
					}

					return returnString;
				});

				Mura.Handlebars.registerHelper('formClass',function() {
					var escapeExpression=Mura.Handlebars.escapeExpression;
					var returnString='mura-form';

					if(this['class']){
						returnString += ' ' + escapeExpression(this['class']);
					}

					return returnString;
				});

				Mura.Handlebars.registerHelper('commonInputAttributes',function() {
					//id, class, title, size
					var escapeExpression=Mura.Handlebars.escapeExpression;
					
					if(typeof this.fieldtype != 'undefined' && this.fieldtype.fieldtype=='file'){
						var returnString='name="' + escapeExpression(this.name) + '_attachment"';
					} else {
						var returnString='name="' + escapeExpression(this.name) + '"';
					}

					if(this.cssid){
						returnString += ' id="' + escapeExpression(this.cssid) + '"';
					} else {
						returnString += ' id="field-' + escapeExpression(this.name) + '"';
					}

					if(this.cssclass){
						returnString += ' class="' + escapeExpression(this.cssclass) + '"';
					}

					if(this.tooltip){
						returnString += ' title="' + escapeExpression(this.tooltip) + '"';
					}

					if(this.size){
						returnString += ' size="' + escapeExpression(this.size) + '"';
					}

					return returnString;
				});

			}

		});

		//Legacy for early adopter backwords support
		Mura.DisplayObject.form=Mura.DisplayObject.Form;

	}));
