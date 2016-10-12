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
    /**
     * Creates a new Mura.Entity
     * @class {class} Mura.UI
     */
	Mura.UI=Mura.Core.extend(
    /** @lends Mura.Feed.prototype */
    {
		rb:{},
		context:{},
		onAfterRender:function(){},
		onBeforeRender:function(){},
		trigger:function(eventName){
			$eventName=eventName.toLowerCase();
			if(typeof this.context.targetEl != 'undefined'){
				var obj=mura(this.context.targetEl).closest('.mura-object');
				if(obj.length && typeof obj.node != 'undefined'){
					if(typeof this.handlers[$eventName] != 'undefined'){
						var $handlers=this.handlers[$eventName];
						for(var i=0;i < $handlers.length;i++){
							$handlers[i].call(obj.node);
						}
					}

					if(typeof this[eventName] == 'function'){
						this[eventName].call(obj.node);
					}
					var fnName='on' + eventName.substring(0,1).toUpperCase() + eventName.substring(1,eventName.length);

					if(typeof this[fnName] == 'function'){
						this[fnName].call(obj.node);
					}
				}
			}

			return this;
		},

		render:function(){
			mura(this.context.targetEl).html(Mura.templates[context.object](this.context));
			this.trigger('afterRender');
			return this;
		},

		init:function(args){
			this.context=args;
			this.registerHelpers();
			this.trigger('beforeRender');
			this.render();
			return this;
		},

		registerHelpers:function(){

		}
	});

}));
