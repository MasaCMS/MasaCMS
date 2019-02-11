Mura.DisplayObject.Cta = Mura.UI.extend({
    displayed: false,
    delaymet: true,
    stats: {
        visits: 0,
        displays: 0,
				dismissed: 0
    },
    preview: false,
    render: function() {

        //this.context.delay=5;
        //this.context.scroll=.5;
        //this.context.visits=3;
        //this.context.displays=3;

        this.context.scroll = parseInt(this.context.scroll) || 0;
        this.context.delay = parseInt(this.context.delay) || 0;
        this.context.displays = parseInt(this.context.displays) || 0;
        this.context.visits = parseInt(this.context.visits) || 0;
        this.context.resetinterval = this.context.resetinterval || 'session';
        this.context.resetqty = parseInt(this.context.resetqty) ||  1;

        this.context.type = this.context.type || 'modal';
        this.context.animatespeed = this.context.animatespeed ||  'fast';
        this.context.anchorx = this.context.anchorx || 'center';
        this.context.anchory = this.context.anchory || 'center';
        this.context.animate = this.context.animate || '';
        this.context.animatespeed = this.context.animatespeed ||  'fast';

        this.context.width = this.context.width || 'md';
        this.context.instanceclass = this.context.instanceclass || '';
        this.context.eventLabel=this.context.type
				this.context.statsid=this.context.statsid || this.context.instanceid || Mura.createUUID();

        if (this.context.type == 'modal') {
            this.context.anchorx = 'center';
            this.context.anchory = 'center';

            if (!this.context.animate) {
                this.context.animate = 'ttb';
            }

        } else if (this.context.type == 'bar') {
            this.context.anchorx = 'center';
            this.context.anchory = 'bottom';
            this.context.animate = 'btt';

        } else if (this.context.type == 'drawer') {
            if (this.context.anchorx == 'center') {
              this.context.anchorx = 'right';
            }

            if (this.context.anchorx == 'right') {
              this.context.animate = 'rtl';
            } else {
              this.context.anchorx = 'left';
              this.context.animate = 'ltr';
            }

            this.context.eventLabel=this.context.eventLabel + ' (' + this.context.anchorx + ')';
        } else if (this.context.type == 'inline') {
            this.context.width = 'full';
            this.context.animate = '';
            this.context.animatespeed = '';
        }

        if (!Mura.isNumeric(this.context.scroll)) {
            this.context.scroll = 0;
        }

        if (!Mura.isNumeric(this.context.delay)) {
            this.context.delay = 0;
        }

        if (!Mura.isNumeric(this.context.displays)) {
            this.context.displays = 0;
        }

        if (!Mura.isNumeric(this.context.visits)) {
            this.context.visits = 0;
        }

        if (!Mura.isNumeric(this.context.resetqty)) {
            this.context.resetqty = 1;
        }

				if (typeof this.context.dismissible == 'undefined') {
						this.context.dismissible = 0;
				}

        this.context.eventLabel=this.context.type;

        var region = Mura(this.context.targetEl).closest('.mura-region-local');

        if (region.length && region.data('perm')) {
            Mura(this.context.targetEl).html(
                '<div class="mura-cta-empty" data-mura-cta-type-label="' +
                Mura.escape(this.context.type) + '"></div>');
            this.mode = 'editable';
        }

        if (this.context.preview) {
            this.preview = true;
            Mura(this.context.targetEl).closest('.mura-object').data(
                'preview', '');
        }

        this.initStats();
        this.recordVisit();

        if (this.context.type != 'inline' && !Mura('.mura-cta').length) {
            Mura('body').append(Mura.templates['cta']());
        }



        var cta = Mura('#mura-cta-' + this.context.instanceid);

        if (cta.length) {
            cta.find('.mura-cta__item__dismiss').trigger('click');
        }

        var self = this;

        Mura.loader().load(Mura.corepath +
            '/modules/v1/cta/css/mura-cta-config.css',
            function() {
                if (self.context.delay) {
                    self.delaymet = false;

                    setTimeout(function() {
                            self.delaymet = true;
                            self.checkRequirements();
                        },
                        self.context.delay * 1000
                    );
                }

                Mura(window).on('scroll', function() {
                    self.checkRequirements();
                });

                self.checkRequirements();
            }
        );
    },
    addTime: function(date, interval, qty) {

        if (!interval || interval == 'session') {
            interval = 'day';
        }

        qty = qty || 1;

        if (interval == 'minute') {
            return new Date(date.getTime() + (qty * 60000));
        } else if (interval == 'hour') {
            return new Date(date.getTime() + (qty * 60 * 60000));
        } else if (interval == 'day') {
            return new Date(date.getTime() + (qty * 24 * 60 * 60000));
        } else if (interval == 'week') {
            return new Date(date.getTime() + (qty * 7 * 24 * 60 *
                60000));
        } else if (interval == 'month') {
            return new Date(date.getTime() + (qty * 30 * 24 * 60 *
                60000));
        }
    },
    getStorage: function() {
      function isLocalStorageNameSupported() {
          var testKey = 'test', storage = window.sessionStorage;
          try {
              storage.setItem(testKey, '1');
              storage.removeItem(testKey);
              return true;
          } catch (error) {
              return false;
          }
      }

      if(isLocalStorageNameSupported()){
        if (this.context.resetinterval == 'session') {
            return window.sessionStorage;
        } else {
            return window.localStorage;
        }
      } else {
        console.log('Your web browser does not support storing settings locally. In Safari, the most common cause of this is using "Private Browsing Mode". Some settings may not save or some features may not work properly for you.');
        return {};
      }
    },
    initStats: function() {
        var storage = this.getStorage();

        if (storage[this.context.statsid]) {
            this.stats = JSON.parse(storage[this.context.statsid]);
        }

				if(!Mura.isNumeric(this.stats.dismissed)){
					this.stats.dismissed=0;
				}

				if(!Mura.isNumeric(this.stats.visits)){
					this.stats.visits=0;
				}

				if(!Mura.isNumeric(this.stats.displays)){
					this.stats.displays=0;
				}

        if (typeof this.stats.expires == 'string') {
            this.stats.expires = new Date(this.stats.expires);

            if (this.stats.expires.getTime() < new Date().getTime()) {
                this.stats = {
                    visits: 0,
                    displays: 0,
										dismissed: 0,
                    expires: this.addTime(new Date(), this.context
                        .resetinterval, this.context.resetqty
                    )
                };
                this.saveStats();
            }

        } else {
            this.stats.expires = this.addTime(new Date(), this.context
                .resetinterval, this.context.resetqty);
            this.saveStats();
        }
    },
    saveStats: function() {
      var storage = this.getStorage();
      storage[this.context.statsid] = JSON.stringify(this.stats);
    },
    clearStats: function() {
        this.stats = {
            visits: 0,
            displays: 0,
						dismissed: 0
        }
        this.saveStats();
    },
    recordVisit: function() {
        this.stats.visits++;
        this.saveStats();
    },
    recordDisplay: function() {
        this.stats.displays++;
        this.saveStats();
    },
    display: function() {
        if (!this.displayed) {
            this.displayed = true;

						var cta = Mura('#mura-cta-' + this.context.instanceid);

		        if (cta.length) {
		            cta.find('.mura-cta__item__dismiss').trigger('click');
		        }

            this.recordDisplay();

            if (this.context.type === 'inline') {
                Mura(this.context.targetEl).html(Mura.templates['cta-instance'](this.context));
            } else {
                var region = Mura('.mura-cta__container[data-mura-cta-anchorx="' + this.context.anchorx +'"][data-mura-cta-anchory="' + this.context.anchory + '"]');

                if (!region.length) {
                    Mura('.mura-cta').append(Mura.templates['cta-container'](this.context));
                    region = Mura('.mura-cta__container[data-mura-cta-anchorx="' + this.context.anchorx + '"][data-mura-cta-anchory="' + this.context.anchory + '"]');
                }

                region.addClass('mura-cta__container--' + this.context.type);

                region.append(Mura.trim(Mura.templates['cta-instance'](this.context)));
            }
            var cta = Mura('#mura-cta-' + this.context.instanceid);

						if(this.context.instanceclass){
							var classes=this.context.instanceclass.split(' ');
							for(var c=0;c<classes.length;c++){
								cta.addClass(classes[c]);
							}
						}

            var self = this;

            var region = Mura(self.context.targetEl).closest('.mura-region-local');

            cta.find('.mura-cta__item__dismiss').on('click',
                function() {
                    var item = Mura(this).closest('.mura-cta__item');
                    var container = item.closest('.mura-cta__container');

                    item.remove();
								
										if(self.context.dismissible){
											self.stats.dismissed=1;
											self.saveStats();
										}

                    if (container.length && !container.find('.mura-cta__item').length) {
                        container.html('').hide();

                        setTimeout(function() {
                                container.show();
                            },
                            20
                        );
                    }

                    if (self.context.type == 'inline') {
                        if (region.length && region.data('perm')) {
                            Mura(self.context.targetEl).html('<div class="mura-cta-empty" data-mura-cta-type-label="' + '"></div>');
                        } else {
                            Mura(self.context.targetEl).html('');
                        }
                    }

                    var obj = Mura(self.context.targetEl).closest('.mura-object');

                    obj.hide();

                    setTimeout(function() {
                            obj.show();
                        },
                        20
                    );

                }
            );

            var isEmpty = true;

            if (this.context.nestedobject && this.context.nestedobject != 'notconfigured') {
							if(!cta.find('[data-ctaid="' + this.context.instanceid + '"][data-object="' + this.context.nestedobject + '"]').length){
                cta.find('.mura-cta__item__content').appendDisplayObject({
                    object: this.context.nestedobject,
										ctaid: this.context.instanceid,
                    queue: false
                });
							}
							isEmpty = false;
            }
            if (this.context.componentid && this.context.componentid != 'notconfigured') {
								if(!cta.find('[data-ctaid="' + this.context.instanceid + '"][data-object="component"]').length){
									cta.find('.mura-cta__item__content').appendDisplayObject({
											object: 'component',
											objectid: this.context.componentid,
											ctaid: this.context.instanceid,
											queue: false
									});
								}
								isEmpty = false;
            }
            if (this.context.formid && this.context.formid != 'notconfigured') {
							if(!cta.find('[data-ctaid="' + this.context.instanceid + '"][data-object="form"]').length){
                cta.find('.mura-cta__item__content').appendDisplayObject({
                    object: 'form',
                    objectid: this.context.formid,
										ctaid: this.context.instanceid,
                    queue: false
                });
							}
							isEmpty = false;
            }

            if (isEmpty) {
                cta.find('.mura-cta__item__content').html(
                    '<p>No content has been assigned.</p>');
            }

            setTimeout(function() {
                    console.log('Mura:Render CTA')
                    cta.addClass('mura-cta__item--active');
                },
                50
            );

            //if (!(region.length && region.data('perm'))) {

            if (this.context.nestedobject && this.context.nestedobject !=
                'notconfigured') {

                Mura.trackEvent({
                    category: 'Call to Action',
                    action: 'Impression',
                    label:this.context.eventLabel,
                    objectid: this.context.nestedobject,
                    nonInteraction: true,
                    value: this.stats.displays
                });

                cta.on('click', 'a', function(e) {

									if(self.context.dismissible){
										self.stats.dismissed=1;
										self.saveStats();
									}

                  if(!Mura(this).hasClass('mura-donottrack')){
                    var a = Mura(e.target || e.srcElement);

                    if (!a.attr('target') || a.attr('target') ==  '_self') {
                        e.preventDefault();
                    }

                    Mura.trackEvent({
                        category: 'Call to Action',
                        action: 'Conversion',
                        label: self.context.eventLabel,
                        objectid: self.context.nestedobject,
                        value: self.stats.displays
                    }).then(
                        function() {
                            if (!a.attr('target') || a.attr('target') == '_self') {
                                window.location = a.attr('href');
                            }
                        });
                  }
                });

                cta.on('submit', 'form', function(e) {

									if(self.context.dismissible){
										self.stats.dismissed=1;
										self.saveStats();
									}

                  if(!Mura(this).hasClass('mura-donottrack')){
                    Mura.trackEvent({
                        category: 'Call to Action',
                        action: 'Conversion',
                        label: self.context.eventLabel,
                        objectid: self.context.nestedobject,
                        value: self.stats.displays
                    });
                  }
                });

                cta.on('formSubmit', function(e) {

									if(self.context.dismissible){
										self.stats.dismissed=1;
										self.saveStats();
									}

                  if(!Mura(this).hasClass('mura-donottrack')){
                    Mura.trackEvent({
                        category: 'Call to Action',
                        action: 'Conversion',
                        label: self.context.eventLabel,
                        objectid: self.context.nestedobject,
                        value: self.stats.displays
                    });
                  }
                });
            }

            if (this.context.componentid && this.context.componentid !=
                'notconfigured') {

                Mura.trackEvent({
                    category: 'Call to Action',
                    action: 'Impression',
                    objectid: this.context.componentid,
                    label: this.context.eventLabel,
                    nonInteraction: true,
                    value: this.stats.displays
                });

                cta.on('click', 'a', function(e) {

									if(self.context.dismissible){
										self.stats.dismissed=1;
										self.saveStats();
									}

                  if(!Mura(this).hasClass('mura-donottrack')){
                    var a = Mura(e.target || e.srcElement);

                    if (!a.attr('target') || a.attr('target') == '_self') {
                        e.preventDefault();
                    }

                    Mura.trackEvent({
                        category: 'Call to Action',
                        action: 'Conversion',
                        label: self.context.eventLabel,
                        objectid: self.context.componentid,
                        value: self.stats.displays
                    }).then(
                        function() {
                            if (!a.attr('target') || a.attr('target') == '_self') {
                                window.location = a.attr('href');
                            }
                        });
                  }
                });
            }

            if (this.context.formid && this.context.formid !=
                'notconfigured') {

                Mura.trackEvent({
                    category: 'Call to Action',
                    action: 'Impression',
                    label: self.context.eventLabel,
                    objectid: self.context.formid,
                    nonInteraction: true,
                    value: self.stats.displays
                });

                cta.on('submit', 'form', function(e) {

									if(self.context.dismissible){
										self.stats.dismissed=1;
										self.saveStats();
									}

                  if(!Mura(this).hasClass('mura-donottrack')){
                    Mura.trackEvent({
                        category: 'Call to Action',
                        action: 'Conversion',
                        label: self.context.eventLabel,
                        objectid: self.context.formid,
                        value: self.stats.displays
                    });

                    if (self.context.componentid && self.context
                        .componentid !=
                        'notconfigured') {

                        Mura.trackEvent({
                            category: 'Call to Action',
                            action: 'Conversion',
                            label: self.context.eventLabel,
                            objectid: self.context
                                .componentid,
                            value: self.stats.displays
                        });
                    }
                  }
                });

                cta.on('formSubmit', function(e) {

									if(self.context.dismissible){
										self.stats.dismissed=1;
										self.saveStats();
									}

                  if(!Mura(this).hasClass('mura-donottrack')){
                    Mura.trackEvent({
                        category: 'Call to Action',
                        action: 'Conversion',
                        label: self.context.eventLabel,
                        objectid: self.context.formid,
                        value: self.stats.displays
                    });

                    if (self.context.componentid && self.context
                        .componentid !=
                        'notconfigured') {

                        Mura.trackEvent({
                            category: 'Call to Action',
                            action: 'Conversion',
                            label: self.context.eventLabel,
                            objectid: self.context
                                .componentid,
                            value: self.stats.displays
                        });
                    }
                  }
                });
            }
            //}

        }
    },
    checkRequirements: function() {
        /*
        console.log('delay: ' + this.metDelayRequirement())
        console.log('scroll: ' + this.metScrollRequirement())
        console.log('visits: ' + this.metVisitsRequirement())
        console.log('displays: ' + this.metDisplaysRequirement())
        */

        if (this.preview || (this.metDelayRequirement() &&
                this.metScrollRequirement() &&
                this.metVisitsRequirement() && this.metDisplaysRequirement()
            && !(this.context.dismissible && this.stats.dismissed)
					)) {
            this.display();
        }
    },
    metVisitsRequirement: function() {
        return (!this.context.visits || (this.stats.visits >=
            this.context
            .visits));
    },
    metDisplaysRequirement: function() {
        return (!this.context.displays || (this.context.displays >
            this.stats.displays));
    },
    metDelayRequirement: function() {
        return this.delaymet;
    },
    metScrollRequirement: function() {
        if (this.context.scroll) {

            var percent = ((document.documentElement.scrollTop +
                document.body.scrollTop) / (
                document.documentElement
                .scrollHeight - document.documentElement
                .clientHeight
            ) * 100);

            //console.log(percent);

            if (percent >= this.context.scroll) {
                return true;
            } else {
                return false;
            }

        } else {
            return true;
        }
    }
});
