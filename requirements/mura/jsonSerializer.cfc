component
	output = false
	hint = "I provide a way to serialize complext ColdFusion data values as case-sensitive JavaScript Object Notation (JSON) strings."
	{

	// I return the initialized component.
	public any function init() {

		// Every key is added to the full key list - used for one-time key serialization.
		fullKeyList = {};

		// Every key is added to the hint list so that we don't have to switch on the lists.
		fullHintList = {};

		// These key lists determine special data serialization.
		stringKeyList = {};
		booleanKeyList = {};
		integerKeyList = {};
		floatKeyList = {};
		dateKeyList = {};

		// These keys will NOT be used in serialization (ie. the key/value pairs will not be
		// added to the serialized output).
		blockedKeyList = {};

		// Return the initialized component.
		return( this );

	}


	// ---
	// PUBLIC METHODS.
	// ---


	// I define the given key without a type. This is here to provide key-casing without caring 
	// about why type of data convertion takes place. Returns serializer.
	public any function asAny( required string key ) {

		return( defineKey( fullKeyList, key, "any" ) );

	}


	// I define the given key as a boolean. Returns serializer.
	public any function asBoolean( required string key ) {

		return( defineKey( booleanKeyList, key, "boolean" ) );

	}


	// I define the given key as a date. Returns serializer.
	public any function asDate( required string key ) {

		return( defineKey( dateKeyList, key, "date" ) );

	}

	// I define the given key as a date. Returns serializer.
	public any function asUTCDate( required string key ) {

		return( defineKey( dateKeyList, key, "utcdate" ) );

	}


	// I define the given key as a float / decimal. Returns serializer.
	public any function asFloat( required string key ) {

		return( defineKey( floatKeyList, key, "float" ) );

	}


	// I define the given key as an integer. Returns serializer.
	public any function asInteger( required string key ) {

		return( defineKey( integerKeyList, key, "integer" ) );

	}


	// I define the given key as a string. Returns serializer.
	public any function asString( required string key ) {

		return( defineKey( stringKeyList, key, "string" ) );

	}


	// I define the key as one that should not be included in the serialized response.
	public any function exclude( required string key ) {

		blockedKeyList[ key ] = true;

		return( this );

	}


	/**
	* I serialize the given input as JavaScript Object Notation (JSON) using the case-sensitive
	* values defined in the key-list.
	* 
	* @output false
	*/
	public string function serialize( required any input ) {

		// Write the serialized value to the output buffer.
		savecontent variable = "local.serializedInput" {

			serializeInput( input, "any" );

		}

		return( serializedInput );

	}


	// ---
	// PRIVATE METHODS.
	// ---


	// I define the given key withihn the given key list.
	private any function defineKey(
		required struct keyList,
		required string key,
		required string hint
		) {

		if ( structKeyExists( fullKeyList, key ) ) {

			return this;
			
			throw( 
				type = "DuplicateKey",
				message = "The key [#key#] has already been defined within the serializer.",
				detail = "The current key list is: #structKeyList( fullKeyList, ', ' )#"
			);

		}

		// Add to the appropriate data-type lists. This one is used for existence checking.
		keyList[ key ] = key;

		// Add all keys to the full key list as well. This one is used to store the serialzation
		// of the key so that it doesn't have to be recalculated each time the object is serialized.
		fullKeyList[ key ] = serializeJson( key );

		// If we have a specific type, then add the hint to the full hint list as well. This will 
		// allow us to quickly look up the pass-through data type hint during serialization.
		// --
		// NOTE: The reason we don't want to pass through "any" is that we want parent types to be
		// able to "fall through" during the object traversal. If we added "any" to the type list, 
		// then it would always overwrite the parent data type.
		if ( hint != "any" ) {

			fullHintList[ key ] = hint;
			
		}

		// Return this reference for method chaining.
		return( this );

	}


	// I walk the given object, writing the serialized value to the output (which is expected to 
	// be a content buffer).
	// ---
	// NOTE: THIS METHOD IS HUGE - this is on purpose. Since serialization is a rather intense 
	// process, I am trying to cut out as much overhead as possible. In this case, we're cutting 
	// out extra stack space by inlining and duplicating a lot of functionality. This is being done 
	// at the COST of clarity and non-repetative code.
	private void function serializeInput(
		required any input,
		required string hint
		) {

		// Serialize the data base on the type of input. We are organizing this in terms of the 
		// most commonly-used values first. The anticipation is that the vast majority of data 
		// types will be simple values. 
		if ( isSimpleValue( input ) ) {

			if ( ( hint == "string" ) || ( hint == "any" ) ) {

				// If the string appears to be numeric, then we have to prefix it to make sure 
				// ColdFusion doesn't accidentally convert it to a number.
				if ( isNumeric( input ) ) {

					writeOutput( """" & input & """" );

				} else {

					writeOutput( serializeJson( input ) );

				}

			} else if ( ( hint == "boolean" ) && isBoolean( input ) ) {

				writeOutput( input ? "true" : "false" );

			} else if ( ( ( hint == "integer" ) || ( hint == "float" ) ) && isNumeric( input ) ) {

				writeOutput( input );

			} else if ( ( ( hint == "integer" ) || ( hint == "float" ) ) && isBoolean( input ) ) {

				writeOutput( input ? "1" : "0" );

			} else if ( ( hint == "date" ) && ( isDate( input ) || isNumericDate( input ) ) ) {

				writeOutput( """" & dateFormat( input, "yyyy-mm-dd" ) & "T" & timeFormat( input, "HH:mm:ss" ) & """" );

			} else if ( ( hint == "utcdate" ) && ( isDate( input ) || isNumericDate( input ) ) ) {

				// Write the date in ISO 8601 time string format. We're going to assume that the 
				// date is already in the dezired timezone. 
				input=DateConvert('local2utc',input);
				writeOutput( """" & dateFormat( input, "yyyy-mm-dd" ) & "T" & timeFormat( input, "HH:mm:ss.l" ) & "Z""" );

			} else {

				writeOutput( serializeJson( input ) );

			}

			return;

		} // END: isSimpleValue().


		// I'm expecting the struct to be the next most common data type since it will likely be 
		// the container for the majority of data values.
		if ( isStruct( input ) ) {

			writeOutput( "{" );

			var isFirst = true;

			for ( var key in input ) {

				// Skip any black-listed keys.
				if ( structKeyExists( blockedKeyList, key ) ) {

					continue;

				}

				// Handle the item delimiter.
				if ( isFirst ) {

					isFirst = false;

				} else {

					writeOutput( "," );

				}

				// Ensure that the given key can be referenced on the full-key list. This way,
				// the subsequent logic will be easier.
				if ( ! structKeyExists( fullKeyList, key ) ) {

					asAny( lcase( key ) );

				}

				writeOutput( fullKeyList[ key ] & ":" );

				// Pass in the most appropriate data-type hint based on the parent key.
				if ( structKeyExists( fullHintList, key ) ) {

					serializeInput( input[ key ], fullHintList[ key ] );

				// If the given key is unknown, just pass through the most recent hint as 
				// it may be defining the type for an entire sturcture.
				} else {
					if(isNull(input[ key ])){
						writeOutput( "null" );
					} else {
						serializeInput( input[ key ], hint );
					}

				}

			}

			writeOutput( "}" );

			return;

		} // END: isStruct().


		if ( isArray( input ) ) {

			writeOutput( "[" );

			var isFirst = true;

			// Handle the item delimiter.
			for ( var value in input ) {

				if ( isFirst ) {

					isFirst = false;

				} else {

					writeOutput( "," );

				}

				// Since we don't have a key to go off of, pass-through the most recent hint.
				serializeInput( value, hint );

			}

			writeOutput( "]" );

			return;

		} // END: isArray().


		// When we serialize a query, we're going to treat it like an array of structs.
		if ( isQuery( input ) ) {

			var keys = listToArray( input.columnList );

			// Make sure each column is defined as a known key - makes the subsequent logic easier.
			for ( var key in keys ) {

				if ( ! structKeyExists( fullKeyList, key ) ) {

					asAny( lcase( key ) );

				}

			}

			writeOutput( "[" );

			// Serialize each row of the query as a struct.
			for ( var i = 1 ; i <= input.recordCount ; i++ ) {

				// Handle the row delimiter.
				if ( i > 1 ) {

					writeOutput( "," );

				}

				writeOutput( "{" );

				var isFirst = true;

				for ( var key in keys ) {

					// Skip any black-listed keys.
					if ( structKeyExists( blockedKeyList, key ) ) {

						continue;

					}

					// Handle the item delimiter (in the current row).
					if ( isFirst ) {

						isFirst = false;

					} else {

						writeOutput( "," );

					}

					writeOutput( fullKeyList[ key ] & ":" );

					// Pass in the most appropriate data-type hint based on the parent key.
					if ( structKeyExists( fullHintList, key ) ) {

						serializeInput( input[ key ][ i ], fullHintList[ key ] );

					// If the given key is unknown, just pass through the most recent hint as 
					// it may be defining the type for an entire sturcture.
					} else {

						serializeInput( input[ key ][ i ], hint );

					}

				} // END: Key list.

				writeOutput( "}" );

			} // END: Row list.

			writeOutput( "]" );
			
			return;

		} // END: isQuery().


		// If we made it this far, we were given a data type that we're not actively supporting.
		// As such, we just have to hand this off to the native serializer.
		writeOutput( serializeJson( input ) );

	}

}