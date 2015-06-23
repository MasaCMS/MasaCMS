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
	function MuraEntity(properties){
		this.init.apply(this,arguments)

		return this;
	}

	MuraEntity.prototype={
		init:function(properties){
			properties || {};
			properties.entityname = properties.entityname || 'content';
			properties.siteid = properties.siteid || window.mura.siteid;
			this.set(properties);
		},

		get:function(propertyName,defaultValue){

			if(typeof this.properties[propertyName] != 'undefined'){
				return this.properties[propertyName];
			} else if (typeof defaultValue != 'undefined') {
				this.properties[propertyName]=defaultValue;
				return this.properties[propertyName];
			} else if(typeof this.properties.links != 'undefined'
				&& typeof this.properties.links[propertyName] != 'undefined'){

				self=this;

				return new Promise(function(resolve,reject) {
					window.mura.ajax({
						type:'get',
						url:this.properties.links[propertyName],
						success:function(resp){
							
							if('items' in resp.data){
								var returnObj = new window.mura.MuraEntityCollection(resp.data);

								returnObj.set('items',returnObj.get('items').map(function(obj){
									return new window.mura.MuraEntity(obj);
								}));
							} else {
								var returnObj = new window.mura.MuraEntity(resp.data);
							}
							
							self.set(propertyName,returnObj);

							if(typeof resolve == 'function'){
								resolve(returnObj);
							}
						}
					});
				});
			
			} else {
				return '';
			}
		},

		set:function(propertyName,propertyValue){

			if(typeof propertyName == 'object'){
				this.properties=window.mura.deepExtend(this.properties,propertyName);
			} else {
				this.properties[propertyName]=propertyValue;
			}
			
			return this;
			
		},

		has:function(propertyName){
			return typeof this.properties[propertyName] != 'undefined' || (typeof this.properties.links != 'undefined' && typeof this.properties.links[propertyName] != 'undefined');
		},

		getAll:function(){
			return this.properties;
		},

		load:function(){
			return this.loadBy('id',this.get('id'));
		},

		loadBy:function(propertyName,propertyValue){

			propertyName=propertyName || 'id';
			propertyValue=propertyValue || this.get(propertyName);
			
			var self=this;

			return new Promise(function(resolve,reject){
				var params={
					entityname:self.get('entityname'),
					method:'findQuery',
					siteid:self.get('siteid')};

					params[propertyName]=propertyValue;

					window.mura.findQuery(params).then(function(collection){
					
					if(collection.get('items').length){
						self.set(collection.get('items')[0].getAll());
					}
					if(typeof resolve == 'function'){
						resolve(self);
					}
				});	
			});
		},

		validate:function(){
			
			var self=this;

			return new Promise(function(resolve,reject) {
				window.mura.ajax({
					type: 'post',
					url: window.mura.apiEndpoint + '?method=validate',
					data: {
							data: window.mura.escape(JSON.stringify(self.getAll())),
							validations: '{}',
							version: 4
						},
					success:function(resp){
						if(resp.data != 'undefined'){
								self.set(resp.data)
						} else {
							self.set('errors',resp.error);
						}
						if(typeof resolve == 'function'){
							resolve(self);
						}
					}
				});
			});		

		},

		save:function(){
			var self=this;

			return new Promise(function(resolve,reject) {
				self.validate(function(){
					if(window.mura.isEmptyObject(self.get('errors'))){
						window.mura.ajax({
							type:'get',
							url:window.mura.apiEndpoint + '?method=generateCSRFTokens',
							data:{
								siteid:self.get('siteid'),
								context:self.get('id')
							},
							success:function(resp){
								window.mura.ajax({
										type:'post',
										url:window.mura.apiEndpoint + '?method=save',
										data:window.mura.extend(self.getAll(),{'csrf_token':resp.data.csrf_token,'csrf_token_expires':resp.data.csrf_token_expires}),
										success:function(resp){
											if(resp.data != 'undefined'){
												self.set(resp.data)
												if(typeof resolve == 'function'){
													resolve(self);
												}
											} else {
												self.set('errors',resp.error);
												if(typeof reject == 'function'){
													reject(self);
												}	
											}
										}
								});
							}
						});
					}
				});
			});

		},

		delete:function(){
			
			var self=this;

			return new Promise(function(resolve,reject) {
				window.mura.ajax({
					type:'get',
					url:window.mura.apiEndpoint + '?method=generateCSRFTokens',
					data:{
						siteid:self.get('siteid'),
						context:self.get('id')
					},
					success:function(resp){
						window.mura.ajax({
							type:'get',
							url:window.mura.apiEndpoint + '?method=delete',
							data:{
								siteid:self.get('siteid'),
								id:self.get('id'),
								entityname:self.get('entityname'),
								'csrf_token':resp.data.csrf_token,
								'csrf_token_expires':resp.data.csrf_token_expires
							},
							success:function(){
								if(typeof resolve == 'function'){
									resolve(self);
								}
							}
						});
					}
				});
			});
		
		}

	}

	window.mura.MuraEntity=MuraEntity;
})(window);
