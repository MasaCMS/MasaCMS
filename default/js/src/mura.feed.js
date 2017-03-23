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
;
(function(root, factory) {
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
}(this, function(Mura) {
	/**
	 * Creates a new Mura.Feed
	 * @class {class} Mura.Feed
	 */
	Mura.Feed = Mura.Core.extend(
		/** @lends Mura.Feed.prototype */
		{

			/**
			 * init - Initialiazes feed
			 *
			 * @param  {string} siteid     Siteid
			 * @param  {string} entityname Entity name
			 * @return {Mura.Feed}            Self
			 */
			init: function(siteid, entityname) {
				this.queryString = entityname + '/?_cacheid=' + Math.random();
				this.propIndex = 0;
				return this;
			},

			/**
			 * fields - List fields to retrieve from API
			 *
			 * @param  {string} fields List of fields
			 * @return {Mura.Feed}        Self
			 */
			fields: function(fields) {
				this.queryString += '&fields=' + encodeURIComponent(fields);
				return this;
			},

			/**
			 * contentPoolID - Sets items per page
			 *
			 * @param  {number} contentPoolID Items per page
			 * @return {Mura.Feed}              Self
			 */
			contentPoolID: function(contentPoolID) {
				this.queryString += '&contentpoolid=' + encodeURIComponent(
					contentPoolID);
				return this;
			},

			/**
			 * where - Optional method for starting query chain
			 *
			 * @param  {string} property Property name
			 * @return {Mura.Feed}          Self
			 */
			where: function(property) {
				if (property) {
					return this.andProp(property);
				}
				return this;
			},

			/**
			 * prop - Add new property value
			 *
			 * @param  {string} property Property name
			 * @return {Mura.Feed}          Self
			 */
			prop: function(property) {
				return this.andProp(property);
			},

			/**
			 * andProp - Add new AND property value
			 *
			 * @param  {string} property Property name
			 * @return {Mura.Feed}          Self
			 */
			andProp: function(property) {
				this.queryString += '&' + encodeURIComponent(property + '[' + this.propIndex + ']') +
					'=';
				this.propIndex++;
				return this;
			},

			/**
			 * orProp - Add new OR property value
			 *
			 * @param  {string} property Property name
			 * @return {Mura.Feed}          Self
			 */
			orProp: function(property) {
				this.queryString += '&or$' + this.propIndex + '&';
				this.propIndex++;
				this.queryString += encodeURIComponent(property +'[' + this.propIndex + ']') +
					'=';
				this.propIndex++;
				return this;
			},

			/**
			 * isEQ - Checks if preceding property value is EQ to criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			isEQ: function(criteria) {
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
					criteria = 'null';
				}
				this.queryString += encodeURIComponent(criteria);
				return this;
			},

			/**
			 * isNEQ - Checks if preceding property value is NEQ to criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			isNEQ: function(criteria) {
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
					criteria = 'null';
				}
				this.queryString += encodeURIComponent('neq^' + criteria);
				return this;
			},

			/**
			 * isLT - Checks if preceding property value is LT to criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			isLT: function(criteria) {
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
					criteria = 'null';
				}
				this.queryString += encodeURIComponent('lt^' + criteria);
				return this;
			},

			/**
			 * isLTE - Checks if preceding property value is LTE to criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			isLTE: function(criteria) {
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
					criteria = 'null';
				}
				this.queryString += encodeURIComponent('lte^' + criteria);
				return this;
			},

			/**
			 * isGT - Checks if preceding property value is GT to criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			isGT: function(criteria) {
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
					criteria = 'null';
				}
				this.queryString += encodeURIComponent('gt^' + criteria);
				return this;
			},

			/**
			 * isGTE - Checks if preceding property value is GTE to criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			isGTE: function(criteria) {
				if (typeof criteria == 'undefined' || criteria == '' || criteria ==
					null) {
					criteria = 'null';
				}
				this.queryString += encodeURIComponent('gte^' + criteria);
				return this;
			},

			/**
			 * isIn - Checks if preceding property value is IN to list of criterias
			 *
			 * @param  {*} criteria Criteria List
			 * @return {Mura.Feed}          Self
			 */
			isIn: function(criteria) {
				this.queryString += encodeURIComponent('in^' + criteria);
				return this;
			},

			/**
			 * isNotIn - Checks if preceding property value is NOT IN to list of criterias
			 *
			 * @param  {*} criteria Criteria List
			 * @return {Mura.Feed}          Self
			 */
			isNotIn: function(criteria) {
				this.queryString += encodeURIComponent('notin^' + criteria);
				return this;
			},

			/**
			 * containsValue - Checks if preceding property value is CONTAINS the value of criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			containsValue: function(criteria) {
				this.queryString += encodeURIComponent('containsValue^' + criteria);
				return this;
			},
			contains: function(criteria) {
				this.queryString += encodeURIComponent('containsValue^' + criteria);
				return this;
			},

			/**
			 * beginsWith - Checks if preceding property value BEGINS WITH criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			beginsWith: function(criteria) {
				this.queryString += encodeURIComponent('begins^' + criteria);
				return this;
			},

			/**
			 * endsWith - Checks if preceding property value ENDS WITH criteria
			 *
			 * @param  {*} criteria Criteria
			 * @return {Mura.Feed}          Self
			 */
			endsWith: function(criteria) {
				this.queryString += encodeURIComponent('ends^' + criteria);
				return this;
			},


			/**
			 * openGrouping - Start new logical condition grouping
			 *
			 * @return {Mura.Feed}          Self
			 */
			openGrouping: function() {
				this.queryString += '&openGrouping';
				return this;
			},

			/**
			 * openGrouping - Starts new logical condition grouping
			 *
			 * @return {Mura.Feed}          Self
			 */
			andOpenGrouping: function(criteria) {
				this.queryString += '&andOpenGrouping';
				return this;
			},

			/**
			 * openGrouping - Closes logical condition grouping
			 *
			 * @return {Mura.Feed}          Self
			 */
			closeGrouping: function(criteria) {
				this.queryString += '&closeGrouping:';
				return this;
			},

			/**
			 * sort - Set desired sort or return collection
			 *
			 * @param  {string} property  Property
			 * @param  {string} direction Sort direction
			 * @return {Mura.Feed}           Self
			 */
			sort: function(property, direction) {
				direction = direction || 'asc';
				if (direction == 'desc') {
					this.queryString += '&sort' + encodeURIComponent('[' + this.propIndex + ']') + '=' +
						encodeURIComponent('-' + property);
				} else {
					this.queryString += '&sort' +encodeURIComponent('[' + this.propIndex + ']') + '=' +
						encodeURIComponent(property);
				}
				this.propIndex++;
				return this;
			},

			/**
			 * itemsPerPage - Sets items per page
			 *
			 * @param  {number} itemsPerPage Items per page
			 * @return {Mura.Feed}              Self
			 */
			itemsPerPage: function(itemsPerPage) {
				this.queryString += '&itemsPerPage=' + encodeURIComponent(itemsPerPage);
				return this;
			},

			/**
			 * pageIndex - Sets items per page
			 *
			 * @param  {number} pageIndex page to start at
			 */
			pageIndex: function(pageIndex) {
				this.queryString += '&pageIndex=' + encodeURIComponent(pageIndex);
				return this;
			},

			/**
			 * maxItems - Sets max items to return
			 *
			 * @param  {number} maxItems Items to return
			 * @return {Mura.Feed}              Self
			 */
			maxItems: function(maxItems) {
				this.queryString += '&maxItems=' + encodeURIComponent(maxItems);
				return this;
			},

			/**
			 * showNavOnly - Sets to only return content set to be in nav
			 *
			 * @param  {boolean} showNavOnly Whether to return items that have been excluded from nav
			 * @return {Mura.Feed}              Self
			 */
			showNavOnly: function(showNavOnly) {
				this.queryString += '&showNavOnly=' + encodeURIComponent(showNavOnly);
				return this;
			},

			/**
			 * showExcludeSearch - Sets to include the homepage
			 *
			 * @param  {boolean} showExcludeSearch Whether to return items that have been excluded from search
			 * @return {Mura.Feed}              Self
			 */
			showExcludeSearch: function(showExcludeSearch) {
				this.queryString += '&showExcludeSearch=' + encodeURIComponent(
					showExcludeSearch);
				return this;
			},

			/**
			 * includeHomepage - Sets to include the home page
			 *
			 * @param  {boolean} showExcludeSearch Whether to return the homepage
			 * @return {Mura.Feed}              Self
			 */
			includeHomepage: function(includeHomepage) {
				this.queryString += '&includehomepage=' + encodeURIComponent(
					includeHomepage);
				return this;
			},

			/**
			 * innerJoin - Sets entity to INNER JOIN
			 *
			 * @param  {string} relatedEntity Related entity
			 * @return {Mura.Feed}              Self
			 */
			innerJoin: function(relatedEntity) {
				this.queryString += '&innerJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' +
					encodeURIComponent(relatedEntity);
				this.propIndex++;
				return this;
			},

			/**
			 * leftJoin - Sets entity to LEFT JOIN
			 *
			 * @param  {string} relatedEntity Related entity
			 * @return {Mura.Feed}              Self
			 */
			leftJoin: function(relatedEntity) {
				this.queryString += '&leftJoin' + encodeURIComponent('[' + this.propIndex + ']') + '=' +
					encodeURIComponent(relatedEntity);
				this.propIndex++;
				return this;
			},

			/**
			 * Query - Return Mura.EntityCollection fetched from JSON API
			 * @return {Promise}
			 */
			getQuery: function() {
				var self = this;

				return new Promise(function(resolve, reject) {
					if (Mura.apiEndpoint.charAt(Mura.apiEndpoint.length - 1) == "/") {
						var apiEndpoint = Mura.apiEndpoint;
					} else {
						var apiEndpoint = Mura.apiEndpoint + '/';
					}
					Mura.ajax({
						type: 'get',
						url: apiEndpoint + self.queryString,
						success: function(resp) {

							var returnObj = new Mura.EntityCollection(resp.data);

							if (typeof resolve == 'function') {
								resolve(returnObj);
							}
						},
						error: reject
					});
				});
			}
		});

}));
