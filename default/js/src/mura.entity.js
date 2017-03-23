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
     * Creates a new Mura.Entity
     * @class {class} Mura.Entity
     */
    Mura.Entity = Mura.Core.extend(
        /** @lends Mura.Entity.prototype */
        {

            /**
             * init - initiliazes instance
             *
             * @param  {object} properties Object containing values to set into object
             * @return {void}
             */
            init: function(properties) {
                properties = properties || {};
                properties.entityname = properties.entityname ||
                    'content';
                properties.siteid = properties.siteid || Mura.siteid;
                this.set(properties);

                if (typeof this.properties.isnew == 'undefined') {
                    this.properties.isnew = 1;
                }

                if (this.properties.isnew) {
                    this.set('isdirty', true);
                } else {
                    this.set('isdirty', false);
                }

                if (typeof this.properties.isdeleted ==
                    'undefined') {
                    this.properties.isdeleted = false;
                }

                this.cachePut();
            },


            /**
             * exists - Returns if the entity was previously saved
             *
             * @return {boolean}
             */
            exists: function() {
                return this.has('isnew') && !this.get('isnew');
            },



            /**
             * get - Retrieves property value from entity
             *
             * @param  {string} propertyName Property Name
             * @param  {*} defaultValue Default Value
             * @return {*}              Property Value
             */
            get: function(propertyName, defaultValue) {
                if (typeof this.properties.links != 'undefined' &&
                    typeof this.properties.links[propertyName] !=
                    'undefined') {
                    var self = this;

                    if (typeof this.properties[propertyName] !=
                        'undefined') {

                        return new Promise(function(resolve,
                            reject) {
                            if ('items' in self.properties[
                                    propertyName]) {
                                var returnObj = new Mura
                                    .EntityCollection(
                                        self.properties[
                                            propertyName
                                        ]);
                            } else {
                                if (Mura.entities[self.properties[
                                        propertyName
                                    ].entityname]) {
                                    var returnObj = new Mura
                                        .entities[self.properties[
                                            propertyName
                                        ].entityname](
                                            obj.properties[
                                                propertyName
                                            ]);
                                } else {
                                    var returnObj = new Mura
                                        .Entity(self.properties[
                                            propertyName
                                        ]);
                                }
                            }

                            if (typeof resolve ==
                                'function') {
                                resolve(returnObj);
                            }
                        });

                    } else {
                        if (typeof defaultValue == 'object') {
                            var params = defaultValue;
                        } else {
                            var params = {};
                        }
                        return new Promise(function(resolve,
                            reject) {

                            Mura.ajax({
                                type: 'get',
                                url: self.properties
                                    .links[
                                        propertyName
                                    ],
                                params: params,
                                success: function(
                                    resp) {

                                    if (
                                        'items' in
                                        resp
                                        .data
                                    ) {
                                        var
                                            returnObj =
                                            new Mura
                                            .EntityCollection(
                                                resp
                                                .data
                                            );
                                    } else {
                                        if (
                                            Mura
                                            .entities[
                                                obj
                                                .entityname
                                            ]
                                        ) {
                                            var
                                                returnObj =
                                                new Mura
                                                .entities[
                                                    obj
                                                    .entityname
                                                ]
                                                (
                                                    obj
                                                );
                                        } else {
                                            var
                                                returnObj =
                                                new Mura
                                                .Entity(
                                                    resp
                                                    .data
                                                );
                                        }
                                    }

                                    //Dont cache it there are custom params
                                    if (
                                        Mura
                                        .isEmptyObject(
                                            params
                                        )) {
                                        self
                                            .set(
                                                propertyName,
                                                resp
                                                .data
                                            );
                                    }

                                    if (
                                        typeof resolve ==
                                        'function'
                                    ) {
                                        resolve
                                            (
                                                returnObj
                                            );
                                    }
                                },
                                error: reject
                            });
                        });
                    }

                } else if (typeof this.properties[propertyName] !=
                    'undefined') {
                    return this.properties[propertyName];
                } else if (typeof defaultValue != 'undefined') {
                    this.properties[propertyName] =
                        defaultValue;
                    return this.properties[propertyName];

                } else {
                    return '';
                }
            },


            /**
             * set - Sets property value
             *
             * @param  {string} propertyName  Property Name
             * @param  {*} propertyValue Property Value
             * @return {Mura.Entity} Self
             */
            set: function(propertyName, propertyValue) {

                if (typeof propertyName == 'object') {
                    this.properties = Mura.deepExtend(this.properties,
                        propertyName);
                    this.set('isdirty', true);
                } else if (typeof this.properties[propertyName] ==
                    'undefined' || this.properties[propertyName] !=
                    propertyValue) {
                    this.properties[propertyName] =
                        propertyValue;
                    this.set('isdirty', true);
                }

                return this;

            },


            /**
             * has - Returns is the entity has a certain property within it
             *
             * @param  {string} propertyName Property Name
             * @return {type}
             */
            has: function(propertyName) {
                return typeof this.properties[propertyName] !=
                    'undefined' || (typeof this.properties.links !=
                        'undefined' && typeof this.properties.links[
                            propertyName] != 'undefined');
            },


            /**
             * getAll - Returns all of the entities properties
             *
             * @return {object}
             */
            getAll: function() {
                return this.properties;
            },


            /**
             * load - Loads entity from JSON API
             *
             * @return {Promise}
             */
            load: function() {
                return this.loadBy('id', this.get('id'));
            },


            /**
             * new - Loads properties of a new instance from JSON API
             *
             * @param  {type} params Property values that you would like your new entity to have
             * @return {Promise}
             */
            'new': function(params) {
                var self = this;

                return new Promise(function(resolve, reject) {
                    params = Mura.extend({
                            entityname: self.get(
                                'entityname'),
                            method: 'findNew',
                            siteid: self.get(
                                'siteid'),
                            '_cacheid': Math.random()
                        },
                        params
                    );

                    Mura.get(Mura.apiEndpoint, params).then(
                        function(resp) {
                            self.set(resp.data);
                            if (typeof resolve ==
                                'function') {
                                resolve(self);
                            }
                        });
                });
            },


            /**
             * loadBy - Loads entity by property and value
             *
             * @param  {string} propertyName  The primary load property to filter against
             * @param  {string|number} propertyValue The value to match the propert against
             * @param  {object} params        Addition parameters
             * @return {Promise}
             */
            loadBy: function(propertyName, propertyValue, params) {

                propertyName = propertyName || 'id';
                propertyValue = propertyValue || this.get(
                    propertyName) || 'null';

                var self = this;

                if (propertyName == 'id') {
                    var cachedValue = Mura.datacache.get(
                        propertyValue);

                    if (cachedValue) {
                        this.set(cachedValue);
                        return new Promise(function(resolve,
                            reject) {
                            resolve(self);
                        });
                    }
                }

                return new Promise(function(resolve, reject) {
                    params = Mura.extend({
                            entityname: self.get(
                                'entityname').toLowerCase(),
                            method: 'findQuery',
                            siteid: self.get(
                                'siteid'),
                            '_cacheid': Math.random(),
                        },
                        params
                    );

                    if (params.entityname == 'content' ||
                        params.entityname ==
                        'contentnav') {
                        params.includeHomePage = 1;
                        params.showNavOnly = 0;
                        params.showExcludeSearch = 1;
                    }

                    params[propertyName] =
                        propertyValue;


                    Mura.findQuery(params).then(
                        function(collection) {

                            if (collection.get(
                                    'items').length) {
                                self.set(collection
                                    .get(
                                        'items'
                                    )[0].getAll()
                                );
                            }
                            if (typeof resolve ==
                                'function') {
                                resolve(self);
                            }
                        });
                });
            },


            /**
             * validate - Validates instance
             *
             * @param  {string} fields List of properties to validate, defaults to all
             * @return {Promise}
             */
            validate: function(fields) {
                fields = fields || '';

                var self = this;
                var data = Mura.deepExtend({}, self.getAll());

                data.fields = fields;

                return new Promise(function(resolve, reject) {

                    Mura.ajax({
                        type: 'post',
                        url: Mura.apiEndpoint +
                            '?method=validate',
                        data: {
                            data: Mura.escape(
                                data),
                            validations: '{}',
                            version: 4
                        },
                        success: function(resp) {
                            if (resp.data !=
                                'undefined'
                            ) {
                                self.set(
                                    'errors',
                                    resp
                                    .data
                                )
                            } else {
                                self.set(
                                    'errors',
                                    resp
                                    .error
                                );
                            }

                            if (typeof resolve ==
                                'function') {
                                resolve(
                                    self
                                );
                            }
                        }
                    });
                });

            },


            /**
             * hasErrors - Returns if the entity has any errors
             *
             * @return {boolean}
             */
            hasErrors: function() {
                var errors = this.get('errors', {});
                return (typeof errors == 'string' && errors !=
                    '') || (typeof errors == 'object' && !
                    Mura.isEmptyObject(errors));
            },


            /**
             * getErrors - Returns entites errors property
             *
             * @return {object}
             */
            getErrors: function() {
                return this.get('errors', {});
            },


            /**
             * save - Saves entity to JSON API
             *
             * @return {Promise}
             */
            save: function() {
                var self = this;

                if (!this.get('isdirty')) {
                    return new Promise(function(resolve, reject) {
                        if (typeof resolve ==
                            'function') {
                            resolve(self);
                        }
                    });
                }

                if (!this.get('id')) {
                    return new Promise(function(resolve, reject) {
                        var temp = Mura.deepExtend({},
                            self.getAll());

                        Mura.ajax({
                            type: 'get',
                            url: Mura.apiEndpoint +
                                self.get(
                                    'entityname'
                                ) + '/new',
                            success: function(
                                resp) {
                                self.set(
                                    resp
                                    .data
                                );
                                self.set(
                                    temp
                                );
                                self.set(
                                    'id',
                                    resp
                                    .data
                                    .id
                                );
                                self.set(
                                    'isdirty',
                                    true
                                );
                                self.cachePut();
                                self.save()
                                    .then(
                                        resolve,
                                        reject
                                    );
                            }
                        });
                    });

                } else {
                    return new Promise(function(resolve, reject) {

                        var context = self.get('id');

                        Mura.ajax({
                            type: 'post',
                            url: Mura.apiEndpoint +
                                '?method=generateCSRFTokens',
                            data: {
                                siteid: self.get(
                                    'siteid'
                                ),
                                context: context
                            },
                            success: function(
                                resp) {
                                Mura.ajax({
                                    type: 'post',
                                    url: Mura
                                        .apiEndpoint +
                                        '?method=save',
                                    data: Mura
                                        .extend(
                                            self
                                            .getAll(), {
                                                'csrf_token': resp
                                                    .data
                                                    .csrf_token,
                                                'csrf_token_expires': resp
                                                    .data
                                                    .csrf_token_expires
                                            }
                                        ),
                                    success: function(
                                        resp
                                    ) {
                                        if (
                                            resp
                                            .data !=
                                            'undefined'
                                        ) {
                                            self
                                                .set(
                                                    resp
                                                    .data
                                                )
                                            self
                                                .set(
                                                    'isdirty',
                                                    false
                                                );
                                            if (
                                                self
                                                .get(
                                                    'saveerrors'
                                                ) ||
                                                Mura
                                                .isEmptyObject(
                                                    self
                                                    .getErrors()
                                                )
                                            ) {
                                                if (
                                                    typeof resolve ==
                                                    'function'
                                                ) {
                                                    resolve
                                                        (
                                                            self
                                                        );
                                                }
                                            } else {
                                                if (
                                                    typeof reject ==
                                                    'function'
                                                ) {
                                                    reject
                                                        (
                                                            self
                                                        );
                                                }
                                            }

                                        } else {
                                            self
                                                .set(
                                                    'errors',
                                                    resp
                                                    .error
                                                );
                                            if (
                                                typeof reject ==
                                                'function'
                                            ) {
                                                reject
                                                    (
                                                        self
                                                    );
                                            }
                                        }
                                    }
                                });
                            },
                            error: function(
                                resp) {
                                this.success(
                                    resp
                                );
                            }
                        });

                    });

                }

            },


            /**
             * delete - Deletes entity
             *
             * @return {Promise}
             */
            'delete': function() {

                var self = this;

                return new Promise(function(resolve, reject) {
                    Mura.ajax({
                        type: 'post',
                        url: Mura.apiEndpoint +
                            '?method=generateCSRFTokens',
                        data: {
                            siteid: self.get(
                                'siteid'),
                            context: self.get(
                                'id')
                        },
                        success: function(resp) {
                            Mura.ajax({
                                type: 'post',
                                url: Mura
                                    .apiEndpoint +
                                    '?method=delete',
                                data: {
                                    siteid: self
                                        .get(
                                            'siteid'
                                        ),
                                    id: self
                                        .get(
                                            'id'
                                        ),
                                    entityname: self
                                        .get(
                                            'entityname'
                                        ),
                                    'csrf_token': resp
                                        .data
                                        .csrf_token,
                                    'csrf_token_expires': resp
                                        .data
                                        .csrf_token_expires
                                },
                                success: function() {
                                    self
                                        .set(
                                            'isdeleted',
                                            true
                                        );
                                    self
                                        .cachePurge();
                                    if (
                                        typeof resolve ==
                                        'function'
                                    ) {
                                        resolve
                                            (
                                                self
                                            );
                                    }
                                }
                            });
                        }
                    });
                });

            },


            /**
             * getFeed - Returns a Mura.Feed instance of this current entitie's type and siteid
             *
             * @return {object}
             */
            getFeed: function() {
                var siteid = get('siteid') || Mura.siteid;
                return new Mura.Feed(this.get('entityName'));
            },


            /**
             * cachePurge - Purges this entity from client cache
             *
             * @return {object}  Self
             */
            cachePurge: function() {
                Mura.datacache.purge(this.get('id'));
                return this;
            },


            /**
             * cachePut - Places this entity into client cache
             *
             * @return {object}  Self
             */
            cachePut: function() {
                if (!this.get('isnew')) {
                    Mura.datacache.set(this.get('id'), this);
                }
                return this;
            }

        });
}));
