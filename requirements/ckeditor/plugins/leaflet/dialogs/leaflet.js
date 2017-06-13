CKEDITOR.dialog.add('leaflet', function(editor) {
  var mapContainer = '';

  // Access the current translation file.
  var pluginTranslation = editor.lang.leaflet;

  // Use the core translation file. Used mainly for the `Alignment` values.
  var commonTranslation = editor.lang.common;

  // Dialog's function callback for the Leaflet Map Widget.
  return {
    title: pluginTranslation.dialogTitle,
    minWidth: 320,
    minHeight: 125,

    contents: [{
      // Create a Location tab.
      id: 'location_tab',
      label: pluginTranslation.locationTabLabel,
      elements: [
        {
          id: 'map_geocode',
          className: 'geocode',
          type: 'text',
          label: pluginTranslation.googleSearchFieldLabel,
          style: 'margin-top: -7px;',

          setup: function(widget) {
            this.setValue('');
          },

          onShow: function (widget) {
            // Get the DOM reference for the Search field.
            var input = jQuery('.geocode input')[0];

            // Set a diffused/default text for better user experience.
            // This will override the Google's default placeholder text:
            // 'Enter a location'.
            jQuery('.geocode input').attr('placeholder', pluginTranslation.googleSearchFieldHint);

            var config = editor.config;

            // Default value, but eventually will reach its quota if many users
            // will just utilize this key instead of creating their own.
            var googleApiKey = 'AIzaSyA9ySM6msnGm0qQB1L1cLTMBdKEUKPySmQ';

            if (typeof config.leaflet_maps_google_api_key != 'undefined' && config.leaflet_maps_google_api_key != '') {
              googleApiKey = config.leaflet_maps_google_api_key;
            }

            // Execute only once, and not every dialog pop-up.
            if (typeof google == 'undefined') {
              // Load other needed external library.
              // Wait for the script to finish loading before binding
              // the autocomplete mechanism to prevent rendering issue.
              CKEDITOR.scriptLoader.load('//maps.googleapis.com/maps/api/js?libraries=places&callback=dummy&key=' + googleApiKey, function() {
                // Bind the Search field to the Autocomplete widget.
                var autocomplete = new google.maps.places.Autocomplete(input);
              });
            }

            // Fix for the Google's type-ahead search displaying behind
            // the widgets dialog window.
            // Basically, we want to override the z-index of the
            // Seach Autocomplete list, in which the styling is being set
            // in real-time by Google.
            // Make a new DOM element.
            var stylesheet = jQuery('<style type="text/css" />');

            // Set the inner HTML. Include also the vertical alignment
            // adjustment for the MiniMap checkbox.
            stylesheet.html('.pac-container { z-index: 100000 !important;} input.minimap { margin-top: 18px !important; }');

            // Append to the main document's Head section.
            jQuery('head').append(stylesheet);
          },
        },

        { // Dummy element serving as label/text container only.
          type: 'html',
          id: 'map_label',
          className: 'label',
          style: 'margin-bottom: -10px;',
          html: '<p>' + pluginTranslation.manualCoordinatesFieldLabel + '</p>'
        },

        {
          // Create a new horizontal group.
          type: 'hbox',
          // Set the relative widths of Latitude, Longitude and Zoom fields.
          widths: [ '50%', '50%' ],
          children: [
            {
              id: 'map_latitude',
              className: 'latitude',
              type: 'text',
              label: pluginTranslation.manualLatitudeFieldLabel,

              setup: function(widget) {
                // Set the Lat values if widget has previous value.
                if (widget.element.data('lat') !== '') {
                  // Update the data-lat based on the map lat in iframe.
                  // Make sure that mapContainer is set.
                  // Also avoids setting it again since zoom/longitude
                  // might already computed/set this object.
                  if (mapContainer === '') {
                    mapContainer = widget.element.getChild(0).$.contentDocument.getElementById('map_container');
                  }

                  var currentLat = mapContainer.getAttribute('data-lat');

                  this.setValue(currentLat);
                }
              },
            },

            {
              id: 'map_longitude',
              className: 'longitude',
              type: 'text',
              label: pluginTranslation.manualLongitudeFieldLabel,

              setup: function(widget) {
                // Set the Lon values if widget has previous value.
                if (widget.element.data('lat') !== '') {
                  // Update the data-lon based on the map lon in iframe.
                  // Make sure that mapContainer is set.
                  // Also avoids setting it again since zoom/latitude
                  // might already computed/set this object.
                  if (mapContainer === '') {
                    mapContainer = widget.element.getChild(0).$.contentDocument.getElementById('map_container');
                  }

                  var currentLon = mapContainer.getAttribute('data-lon');

                  this.setValue(currentLon);
                }
              },
            },
          ]
        },

        {
          id: 'popup_text',
          className: 'popup-text',
          type: 'text',
          label: pluginTranslation.popupTextFieldLabel,
          style: 'margin-bottom: 8px;',

          setup: function(widget) {
            // Set the Lat values if widget has previous value.
            if (widget.element.data('popup-text') != '') {
              this.setValue(widget.element.data('popup-text'));
            }

            else {
              // Set a diffused/default text for better user experience.
              jQuery('.popup-text input').attr('placeholder', pluginTranslation.popupTextFieldHint)
            }
          },
        },
      ]
      },

      {
      // Create an Options tab.
      id: 'options_tab',
      label: pluginTranslation.optionsTabLabel,
      elements: [
        {
          // Create a new horizontal group.
          type: 'hbox',
          style: 'margin-top: -7px;',
          // Set the relative widths of Latitude, Longitude and Zoom fields.
          widths: [ '38%', '38%', '24%' ],
          children: [
            {
              id: 'width',
              className: 'map_width',
              type: 'text',
              label: pluginTranslation.mapWidthFieldLabel,

              setup: function(widget) {
                // Set a diffused/default text for better user experience.
                jQuery('.map_width input').attr('placeholder', '400')

                // Set the map width value if widget has a previous value.
                if (widget.element.data('width') != '') {
                  this.setValue(widget.element.data('width'));
                }
              },
            },

            {
              id: 'height',
              className: 'map_height',
              type: 'text',
              label: pluginTranslation.mapHeightFieldLabel,

              setup: function(widget) {
                // Set a diffused/default text for better user experience.
                jQuery('.map_height input').attr('placeholder', '400');

                // Set the map height value if widget has a previous value.
                if (widget.element.data('height') != '') {
                  this.setValue(widget.element.data('height'));
                }
              },
            },

            {
              // Create a select list for Zoom Levels.
              // 'className' attribute is used for targeting this element in jQuery.
              id: 'map_zoom',
              className: 'zoom',
              type: 'select',
              label: pluginTranslation.mapZoomLevelFieldLabel,
              width: '70px',
              items: [['1'], ['2'], ['3'], ['4'],['5'], ['6'], ['7'], ['8'], ['9'], ['10'], ['11'], ['12'], ['13'], ['14'], ['15'], ['16'], ['17'], ['18'], ['19'], ['20']],

              // This will execute also every time you edit/double-click the widget.
              setup: function(widget) {
                // Set this Zoom Level's select list when
                // the current location has been initialized and set previously.
                if (widget.element.data('zoom') != '') {
                  // Update the data-zoom based on the map zoom level in iframe.
                  // Make sure that mapContainer is set.
                  // Also avoids setting it again since latitude/longitude
                  // might already computed/set this object.
                  if (mapContainer === '') {
                    mapContainer = widget.element.getChild(0).$.contentDocument.getElementById('map_container');
                  }

                  var currentZoom = mapContainer.getAttribute('data-zoom');

                  this.setValue(currentZoom);
                }

                // Set the Default Zoom Level value.
                else {
                  this.setValue('10');
                }
              },
            }
          ]
        },

        {
          // Create a new horizontal group.
          type: 'hbox',
          // Set the relative widths for the tile and overview map fields.
          widths: [ '50%', '50%' ],
          children: [
            {
              // Create a select list for map tiles.
              // 'className' attribute is used for targeting this element in jQuery.
              type: 'select',
              id: 'map_tile',
              className: 'tile',
              label: pluginTranslation.baseMapTileLabel,
              items: [['OpenStreetMap.Mapnik'], ['OpenStreetMap.DE'], ['OpenStreetMap.HOT'], ['Esri.DeLorme'], ['Esri.NatGeoWorldMap'], ['Esri.WorldPhysical'], ['Esri.WorldTopoMap'], ['Thunderforest.OpenCycleMap'], ['Thunderforest.Landscape'], ['Stamen.Watercolor']],

              // This will execute also every time you edit/double-click the widget.
              setup: function(widget) {
                var restrictedTiles = ['MapQuestOpen.Aerial', 'MapQuestOpen.OSM'];

                var tile = widget.element.data('tile');

                // Set the Tile data attribute.
                // Must not be the restricted, MapQuest tiles.
                if ( tile != '' && restrictedTiles.indexOf(tile) == -1 ) {
                  this.setValue(tile);
                }

                else {
                  // Set the default value.
                  // Includes the case for existing MapQuest tiles.
                  this.setValue('OpenStreetMap.Mapnik');
                }
              },

              // This will execute every time you click the Dialog's OK button.
              // It will inject a map iframe in the CKEditor page.
              commit: function(widget) {
                // Remove the iframe if it has one.
                widget.element.setHtml('');

                // Retrieve the value in the Search field.
                var geocode = jQuery('.geocode input').val();
                var latitude, longitude;

                if (geocode != '') {
                  // No need to call the encodeURIComponent().
                  var geocodingRequest = '//maps.googleapis.com/maps/api/geocode/json?address=' + geocode + '&sensor=false';

                  // Disable the asynchoronous behavior temporarily so that
                  // waiting for results will happen before proceeding
                  // to the next statements.
                  jQuery.ajaxSetup({
                    async: false
                  });

                  // Geocode the retrieved place name.
                  jQuery.getJSON(geocodingRequest, function(data) {
                    if (data['status'] != 'ZERO_RESULTS') {
                      // Get the Latitude and Longitude object in the
                      // returned JSON object.
                      latitude = data.results[0].geometry.location.lat;
                      longitude = data.results[0].geometry.location.lng;
                    }

                    // Handle queries with no results or have some
                    // malformed parameters.
                    else {
                      alert('The Place could not be Geocoded properly. Kindly choose another one.')
                    }
                  });
                }

                // Get the Lat/Lon values from the corresponding fields.
                var latInput = jQuery('.latitude input').val();
                var lonInput = jQuery('.longitude input').val();

                // Get the data-lat and data-lon values.
                // It is empty for yet to be created widgets.
                var latSaved = widget.element.data('lat');
                var lonSaved = widget.element.data('lon');

                // Used the inputted values if it's not empty or
                // not equal to the previously saved values.
                // latSaved and lonSaved are initially empty also
                // for widgets that are yet to be created.
                // Or if the user edited an existing map, and did not edit
                // the lat/lon fields, and the Search field is empty.
                if ((latInput != '' && lonInput != '') && ((latInput != latSaved && lonInput != lonSaved) || geocode == '')) {
                  latitude = latInput;
                  longitude = lonInput;
                }

                var width = jQuery('.map_width input').val() || '400';
                var height = jQuery('.map_height input').val() || '400';
                var zoom = jQuery('select.zoom').val();
                var popUpText = jQuery('.popup-text input').val();
                var tile = jQuery('select.tile').val();
                var alignment = jQuery('select.alignment').val();

                // Returns 'on' or 'undefined'.
                var minimap = jQuery('.minimap input:checked').val();

                // Use 'off' if the MiniMap checkbox is unchecked.
                if (minimap == undefined) {
                  minimap = 'off';
                }

                // Get a unique timestamp:
                var milliseconds = new Date().getTime();

                // Set/Update the widget's data attributes.
                widget.element.setAttribute('id', 'leaflet_div-' + milliseconds);

                widget.element.data('lat', latitude);
                widget.element.data('lon', longitude);
                widget.element.data('width', width);
                widget.element.data('height', height);
                widget.element.data('zoom', zoom);
                widget.element.data('popup-text', popUpText);
                widget.element.data('tile', tile);
                widget.element.data('minimap', minimap);
                widget.element.data('alignment', alignment);

                // Remove the previously set alignment class.
                // Only one alignment class is set per map.
                widget.element.removeClass('align-left');
                widget.element.removeClass('align-right');
                widget.element.removeClass('align-center');

                // Set the alignment for this map.
                widget.element.addClass('align-' + alignment);

                // Returns 'on' or 'undefined'.
                var responsive = jQuery('.responsive input:checked').val();

                // Use 'off' if the Responsive checkbox is unchecked.
                if (responsive == undefined) {
                  responsive = 'off';

                  // Remove the previously set responsive map class,
                  // if there's any.
                  widget.element.removeClass('responsive-map');
                }

                else {
                  // Add a class for styling.
                  widget.element.addClass('responsive-map');
                }

                // Set the 'responsive' data attribute.
                widget.element.data('responsive', responsive);

                // Build the full path to the map renderer.
                mapParserPathFull = mapParserPath + '?lat=' + latitude + '&lon=' + longitude + '&width=' + width + '&height=' + height + '&zoom=' + zoom + '&text=' + popUpText + '&tile=' + tile + '&minimap=' + minimap + '&responsive=' + responsive;

                // Create a new CKEditor DOM's iFrame.
                var iframe = new CKEDITOR.dom.element('iframe');

                // Setup the iframe characteristics.
                iframe.setAttributes({
                  'scrolling': 'no',
                  'id': 'leaflet_iframe-' + milliseconds,
                  'class': 'leaflet_iframe',
                  'width': width + 'px',
                  'height': height + 'px',
                  'frameborder': 0,
                  'allowTransparency': true,
                  'src': mapParserPathFull,
                  'data-cke-saved-src': mapParserPathFull
                });

                // If map is responsive.
                if (responsive == 'on') {
                  // Add a class for styling.
                  iframe.setAttribute('class', 'leaflet_iframe responsive-map-iframe');
                }

                // Insert the iframe to the widget's DIV element.
                widget.element.append(iframe);

                // Reset/clear the map iframe/DOM object reference.
                mapContainer = '';
              },
            },

            {
              type: 'checkbox',
              id: 'map_mini',
              className: 'minimap',
              label: pluginTranslation.minimapCheckboxLabel,

              // This will execute also every time you edit/double-click the widget.
              setup: function(widget) {
                // Set the MiniMap check button.
                if (widget.element.data('minimap') != '' && widget.element.data('minimap') != 'on') {
                  this.setValue('');
                }

                else {
                  // Set the default value.
                  this.setValue('true');
                }
              },
            }
          ]
        },

        {
          // Create a new horizontal group.
          type: 'hbox',
          // Set the relative widths for alignment and responsive options.
          widths: [ '20%', '80%' ],
          children: [
            {
              // Create a select list for Map Alignment.
              // 'className' attribute is used for targeting this element in jQuery.
              id: 'map_alignment',
              className: 'alignment',
              type: 'select',
              label: commonTranslation.align,
              items: [[commonTranslation.alignLeft, 'left'], [commonTranslation.alignRight, 'right'], [commonTranslation.alignCenter, 'center']],
              style: 'margin-bottom: 4px;',

              // This will execute also every time you edit/double-click the widget.
              setup: function(widget) {
                // Set this map alignment's select list when
                // the current map has been initialized and set previously.
                if (widget.element.data('alignment') != '') {
                  // Set the alignment.
                  this.setValue(widget.element.data('alignment'));
                }

                // Set the Default alignment value.
                else {
                  this.setValue('left');
                }
              },
            },

            {
              type: 'checkbox',
              id: 'map_responsive',
              className: 'responsive',
              label: pluginTranslation.responsiveMapCheckboxLabel,
              style: 'margin-top: 18px;',

              // This will execute also every time you edit/double-click the widget.
              setup: function(widget) {
                // Set the Responsive check button, when editing widget.
                if (widget.element.data('responsive') != '') {
                  if (widget.element.data('responsive') == 'on') {
                    this.setValue('true');
                  }

                  else {
                    this.setValue('');
                  }
                }

                // Set the default value for new ones.
                else {
                  this.setValue('');
                }
              },
            }
          ]
        }
      ]
    }]
  };
});
