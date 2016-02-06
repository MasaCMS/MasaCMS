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
	window.mura.Feed=window.mura.Core.extend({
		init:function(siteid,entityname){
            this.queryString=siteid + '/' + entityname + '/?';
			this.propIndex=0;
			this.entityname=entityname;
            return this;
		},
        where:function(property){
            if(property){
                return this.andProp(property);
            }
            return this;
        },
        prop:function(property){
            return this.andProp(property);
        },
        andProp:function(property){
            this.queryString+='&' + property + '[' + this.propIndex + ']=';
			this.propIndex++;
            return this;
        },
        orProp:function(property){
            this.queryString+='&or[' + this.propIndex + ']&';
			this.propIndex++;
			this.queryString+= property + '[' + this.propIndex + ']=';
			this.propIndex++;
			return this;
        },
        isEQ:function(criteria){
            this.queryString+=criteria;
			return this;
        },
        isNEQ:function(criteria){
            this.queryString+='neq:' & criteria;
			return this;
        },
        isLT:function(criteria){
            this.queryString+='lt:' & criteria;
			return this;
        },
        isLTE:function(criteria){
            this.queryString+='lte:' & criteria;
			return this;
        },
        isGT:function(criteria){
            this.queryString+='gt:' & criteria;
			return this;
        },
        isGTE:function(criteria){
            this.queryString+='gte:' & criteria;
			return this;
        },
        isIn:function(criteria){
            this.queryString+='in:' & criteria;
			return this;
        },
        isNotIn:function(criteria){
            this.queryString+='notin:' & criteria;
			return this;
        },
        contains:function(criteria){
            this.queryString+='contains:' & criteria;
			return this;
        },
        doesNotContain:function(criteria){
            this.queryString+='doesnotcontain:' & criteria;
			return this;
        },
        openGrouping:function(criteria){
            this.queryString+='&openGrouping';
			return this;
        },
        andOpenGrouping:function(criteria){
            this.queryString+='&andOpenGrouping';
			return this;
        },
        closeGrouping:function(criteria){
            this.queryString+='&closeGrouping:';
			return this;
        },
		sort:function(property,direction){
			direction=direction || 'asc';
			if(direction == 'desc'){
				this.queryString+='&sort[' + this.propIndex + ']=-' + property;
			} else {
				this.queryString+='&sort[' + this.propIndex + ']=+' + property;
			}
			this.propIndex++;
            return this;
        },
		itemsPerPage:function(itemsPerPage){
            this.queryString+='&itemsPerPage=' + itemsPerPage;
        },
		maxItems:function(maxItems){
            this.queryString+='&maxItems=' + maxItems;
        },
        getQuery:function(){
            var self=this;
            return new Promise(function(resolve,reject) {
				window.mura.ajax({
					type:'get',
					url:window.mura.apiEndpoint + self.queryString,
					success:function(resp){

						if('items' in resp.data){
							var returnObj = new window.mura.EntityCollection(resp.data);
						} else {
							if(window.mura.entities[self.entityname]){
								var returnObj = new window.mura.entities[self.entityname](obj);
							} else {
								var returnObj = new window.mura.Entity(resp.data);
							}
						}

						if(typeof resolve == 'function'){
							resolve(returnObj);
						}
					},
					error:reject
				});
			});
        }
    });

})(window);
