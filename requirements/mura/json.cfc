/*
Serialize and deserialize JSON data into native ColdFusion objects
http://www.epiphantastic.com/cfjson/

Authors: Jehiah Czebotar (jehiah@gmail.com)
         Thomas Messier  (thomas@epiphantastic.com)

Version: 1.9 February 20, 2008
*/
/**
 * deprecated
 */
component displayname="JSON" output="No" hint="deprecated" {

	public function init() output=false {
		return this;
	}

	/**
	 * Converts data frm JSON to CF format
	 */
	remote function jsonencode(required any data) output=false {
		return encode(arguments.data);
	}

	/**
	 * Converts data frm JSON to CF format
	 */
	remote function jsondecode(required string data) output=false {
		return decode(arguments.data);
	}

	/**
	 * Converts data frm JSON to CF format
	 */
	remote function decode(required string data) output=false {
		//  DECLARE VARIABLES
		var ar = ArrayNew(1);
		var st = StructNew();
		var dataType = "";
		var inQuotes = false;
		var startPos = 1;
		var nestingLevel = 0;
		var dataSize = 0;
		var i = 1;
		var skipIncrement = false;
		var j = 0;
		var char = "";
		var dataStr = "";
		var structVal = "";
		var structKey = "";
		var colonPos = "";
		var qRows = 0;
		var qCol = "";
		var qData = "";
		var curCharIndex = "";
		var curChar = "";
		var result = "";
		var unescapeVals = "\\,\"",\/,\b,\t,\n,\f,\r";
		var unescapeToVals = "\,"",/,#Chr(8)#,#Chr(9)#,#Chr(10)#,#Chr(12)#,#Chr(13)#";
		var unescapeVals2 = '\,",/,b,t,n,f,r';
		var unescapetoVals2 = '\,",/,#Chr(8)#,#Chr(9)#,#Chr(10)#,#Chr(12)#,#Chr(13)#';
		var dJSONString = "";
		var pos=0;
		var _data = Trim(arguments.data);
		//  NUMBER
		if ( IsNumeric(_data) ) {
			return _data;
			//  NULL
		} else if ( _data == "null" ) {
			return "";
			//  BOOLEAN
		} else if ( ListFindNoCase("true,false", _data) ) {
			return _data;
			//  EMPTY STRING
		} else if ( _data == "''" || _data == '""' ) {
			return "";
			//  STRING
		} else if ( ReFind('^"[^\\"]*(?:\\.[^\\"]*)*"$', _data) == 1 || ReFind("^'[^\\']*(?:\\.[^\\']*)*'$", _data) == 1 ) {
			_data = mid(_data, 2, Len(_data)-2);
			/*  If there are any \b, \t, \n, \f, and \r, do extra processing
				(required because ReplaceList() won't work with those) */
			if ( Find("\b", _data) || Find("\t", _data) || Find("\n", _data) || Find("\f", _data) || Find("\r", _data) ) {
				curCharIndex = 0;
				curChar =  "";
				dJSONString = createObject("java", "java.lang.StringBuffer").init("");
				while ( true ) {
					curCharIndex = curCharIndex + 1;
					if ( curCharIndex > len(_data) ) {
						break;
					} else {
						curChar = mid(_data, curCharIndex, 1);
						if ( curChar == "\" ) {
							curCharIndex = curCharIndex + 1;
							curChar = mid(_data, curCharIndex,1);
							pos = listFind(unescapeVals2, curChar);
							if ( pos ) {
								dJSONString.append(ListGetAt(unescapetoVals2, pos));
							} else {
								dJSONString.append("\" & curChar);
							}
						} else {
							dJSONString.append(curChar);
						}
					}
				}
				return dJSONString.toString();
			} else {
				return ReplaceList(_data, unescapeVals, unescapeToVals);
			}
			//  ARRAY, STRUCT, OR QUERY
		} else if ( ( Left(_data, 1) == "[" && Right(_data, 1) == "]" )
			OR ( Left(_data, 1) == "{" && Right(_data, 1) == "}" ) ) {
			//  Store the data type we're dealing with
			if ( Left(_data, 1) == "[" && Right(_data, 1) == "]" ) {
				dataType = "array";
			} else if ( ReFindNoCase('^\{"recordcount":[0-9]+,"columnlist":"[^"]+","data":\{("[^"]+":\[[^]]*\],?)+\}\}$', _data, 0) == 1 ) {
				dataType = "query";
			} else {
				dataType = "struct";
			}
			//  Remove the brackets
			_data = Trim( Mid(_data, 2, Len(_data)-2) );
			//  Deal with empty array/struct
			if ( Len(_data) == 0 ) {
				if ( dataType == "array" ) {
					return ar;
				} else {
					return st;
				}
			}
			//  Loop through the string characters
			dataSize = Len(_data) + 1;
			while ( i <= dataSize ) {
				skipIncrement = false;
				//  Save current character
				char = Mid(_data, i, 1);
				//  If char is a quote, switch the quote status
				if ( char == '"' ) {
					inQuotes = !inQuotes;
					//  If char is escape character, skip the next character
				} else if ( char == "\" && inQuotes ) {
					i = i + 2;
					skipIncrement = true;
					//  If char is a comma and is not in quotes, or if end of string, deal with data
				} else if ( (char == "," && !inQuotes && nestingLevel == 0) || i == Len(_data)+1 ) {
					dataStr = Mid(_data, startPos, i-startPos);
					//  If data type is array, append data to the array
					if ( dataType == "array" ) {
						arrayappend( ar, decode(dataStr) );
						//  If data type is struct or query...
					} else if ( dataType == "struct" || dataType == "query" ) {
						dataStr = Mid(_data, startPos, i-startPos);
						colonPos = Find('":', dataStr);
						if ( colonPos ) {
							colonPos = colonPos + 1;
						} else {
							colonPos = Find(":", dataStr);
						}
						structKey = Trim( Mid(dataStr, 1, colonPos-1) );
						//  If needed, remove quotes from keys
						if ( Left(structKey, 1) == "'" || Left(structKey, 1) == '"' ) {
							structKey = Mid( structKey, 2, Len(structKey)-2 );
						}
						structVal = Mid( dataStr, colonPos+1, Len(dataStr)-colonPos );
						//  If struct, add to the structure
						if ( dataType == "struct" ) {
							StructInsert( st, structKey, decode(structVal) );
							//  If query, build the query
						} else {
							if ( structKey == "recordcount" ) {
								qRows = decode(structVal);
							} else if ( structKey == "columnlist" ) {
								st = QueryNew( decode(structVal) );
								if ( qRows ) {
									QueryAddRow(st, qRows);
								}
							} else if ( structKey == "data" ) {
								qData = decode(structVal);
								ar = StructKeyArray(qData);
								for ( j=1 ; j<=ArrayLen(ar) ; j++ ) {
									for ( qRows=1 ; qRows<=st.recordcount ; qRows++ ) {
										qCol = ar[j];
										QuerySetCell(st, qCol, qData[qCol][qRows], qRows);
									}
								}
							}
						}
					}
					startPos = i + 1;
					//  If starting a new array or struct, add to nesting level
				} else if ( "{[" CONTAINS char && !inQuotes ) {
					nestingLevel = nestingLevel + 1;
					//  If ending an array or struct, subtract from nesting level
				} else if ( "]}" CONTAINS char && !inQuotes ) {
					nestingLevel = nestingLevel - 1;
				}
				if ( !skipIncrement ) {
					i = i + 1;
				}
			}
			//  Return appropriate value based on data type
			if ( dataType == "array" ) {
				return ar;
			} else {
				return st;
			}
			//  INVALID JSON
		} else {
			throw( message="Invalid JSON", detail="The document you are trying to decode is not in valid JSON format" );
		}
	}
	//  CONVERTS DATA FROM CF TO JSON FORMAT

	public function encode(required any arg="") output=false {

		var i=0;
		var o="";
		var u="";
		var v="";
		var z="";
		var r="";
		if (isarray(arg))
		{
			o="";
			for (i=1;i lte arraylen(arg);i=i+1){
				try{
					v = jsonencode(arg[i]);
					if (o neq ""){
						o = o & ',';
					}
					o = o & v;
				}
				catch(Any ex){
					o=o;
				}
			}
			return '['& o &']';
		}
		if (isstruct(arg))
		{
			o = '';
			if (structisempty(arg)){
				return "{}";
			}
			z = StructKeyArray(arg);
			for (i=1;i lte arrayLen(z);i=i+1){
				try{
				v = jsonencode(structfind(arg,z[i]));
				}catch(Any err){WriteOutput("caught an error when trying to evaluate z[i] where i="& i &" it evals to "  & z[i] );}
				if (o neq ""){
					o = o & ",";
				}
				o = o & '"'& lcase(z[i]) & '":' & v;
			}
			return '{' & o & '}';
		}
		if (isobject(arg)){
	        return "unknown-obj";
		}
		if (issimplevalue(arg) and isnumeric(arg)){
			return ToString(arg);
		}
		if (issimplevalue(arg)){
			return '"' & JSStringFormat(ToString(arg)) & '"';
		}
		if (IsQuery(arg)){
			o = o & '"recordcount":' & arg.recordcount;
			o = o & ',"columnlist":'&jsonencode(arg.columnlist);
			// do the data [].column
			o = o & ',"data":{';
			// loop through the columns
			for (i=1;i lte listlen(arg.columnlist);i=i+1){
				v = '';
				// loop throw the records
				for (z=1;z lte arg.recordcount;z=z+1){
					if (v neq ""){
						v =v  & ",";
					}
					// encode this cell
					v = v & jsonencode(evaluate("arg." & listgetat(arg.columnlist,i) & "["& z & "]"));
				}
				// put this column in the output
				if (i neq 1){
					o = o & ",";
				}
				o = o & '"' & ucase(listgetat(arg.columnlist,i)) & '":[' & v & ']';
			}
			// close our data section
			o = o & '}';
			// put the query struct in the output
			return '{' & o & '}';
		}
		return "unknown";
	}

	/**
	 * I validate a JSON document against a JSON schema
	 */
	remote boolean function validate(string doc, string schema, string errorVar="jsonSchemaErrors", boolean stopOnError="true", any _doc, any _schema, string _item="root") output=true {
		//  These arguments are for internal use only
		var schemaRules = "";
		var jsonDoc = "";
		var i = 0;
		var key = "";
		var isValid = true;
		var msg = "";
		if ( StructKeyExists(arguments, "doc") ) {
			if ( FileExists(arguments.doc) ) {
				cffile( variable="arguments.doc", file=arguments.doc, action="READ" );
			}
			if ( FileExists(arguments.schema) ) {
				cffile( variable="arguments.schema", file=arguments.schema, action="READ" );
			}
			jsonDoc = decode(arguments.doc);
			schemaRules = decode(arguments.schema);
			request[arguments.errorVar] = ArrayNew(1);
		} else if ( StructKeyExists(arguments, "_doc") ) {
			jsonDoc = arguments._doc;
			schemaRules = arguments._schema;
		}
		//  See if the document matches the rules from the schema
		if ( schemaRules.type == "struct" ) {
			if ( !IsStruct(jsonDoc) ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# should be a struct");
				if ( arguments.stopOnError ) {
					return false;
				}
			} else {
				//  If specific keys are set to be required, check if they exist
				if ( StructKeyExists(schemaRules, "keys") ) {
					for ( i=1 ; i<=ArrayLen(schemaRules.keys) ; i++ ) {
						if ( !StructKeyExists(jsonDoc, schemaRules.keys[i]) ) {
							ArrayPrepend(request[arguments.errorVar], "#arguments._item# should have a key named #schemaRules.keys[i]#");
							if ( arguments.stopOnError ) {
								return false;
							}
						}
					}
				}
				//  Loop over all the keys for the structure and see if they are valid (if items key is specified) by recursing the validate function
				if ( StructKeyExists(schemaRules, "items") ) {
					for ( key in jsonDoc ) {
						if ( StructKeyExists(schemaRules.items, key) ) {
							isValid = validate(_doc=jsonDoc[key], _schema=schemaRules.items[key], _item="#arguments._item#['#key#']", errorVar=arguments.errorVar, stopOnError=arguments.stopOnError);
							if ( arguments.stopOnError && !isValid ) {
								return false;
							}
						}
					}
				}
			}
		} else if ( schemaRules.type == "array" ) {
			if ( !IsArray(jsonDoc) ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# should be an array");
				if ( arguments.stopOnError ) {
					return false;
				}
			} else {
				cfparam( default=0, name="schemaRules.minlength" );
				cfparam( default=9999999999, name="schemaRules.maxlength" );
				//  If there are length requirements for the array make sure they are valid
				if ( ArrayLen(jsonDoc) < schemaRules.minlength ) {
					ArrayPrepend(request[arguments.errorVar], "#arguments._item# == an array that should have at least #schemaRules.minlength# elements");
					if ( arguments.stopOnError ) {
						return false;
					}
				} else if ( ArrayLen(jsonDoc) > schemaRules.maxlength ) {
					ArrayPrepend(request[arguments.errorVar], "#arguments._item# == an array that should have at the most #schemaRules.maxlength# elements");
					if ( arguments.stopOnError ) {
						return false;
					}
				}
				//  Loop over the array elements and if there are rules for the array items recurse to enforce them
				if ( StructKeyExists(schemaRules, "items") ) {
					for ( i=1 ; i<=ArrayLen(jsonDoc) ; i++ ) {
						isValid = validate(_doc=jsonDoc[i], _schema=schemaRules.items, _item="#arguments._item#[#i#]", errorVar=arguments.errorVar, stopOnError=arguments.stopOnError);
						if ( arguments.stopOnError && !isValid ) {
							return false;
						}
					}
				}
			}
		} else if ( schemaRules.type == "number" ) {
			if ( !IsNumeric(jsonDoc) ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# should be numeric");
				if ( arguments.stopOnError ) {
					return false;
				}
			} else if ( StructKeyExists(schemaRules, "min") && jsonDoc < schemaRules.min ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# cannot be a number less than #schemaRules.min#");
				if ( arguments.stopOnError ) {
					return false;
				}
			} else if ( StructKeyExists(schemaRules, "max") && jsonDoc > schemaRules.max ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# cannot be a number greater than #schemaRules.max#");
				if ( arguments.stopOnError ) {
					return false;
				}
			}
		} else if ( schemaRules.type == "boolean" && ( !IsBoolean(jsonDoc) || ListFindNoCase("Yes,No", jsonDoc) || IsNumeric(jsonDoc) ) ) {
			ArrayPrepend(request[arguments.errorVar], "#arguments._item# should be a boolean");
			if ( arguments.stopOnError ) {
				return false;
			}
		} else if ( schemaRules.type == "date" ) {
			if ( !IsSimpleValue(jsonDoc) || !IsDate(jsonDoc)
					OR ( StructKeyExists(schemaRules, "mask") && CompareNoCase( jsonDoc, DateFormat(jsonDoc, schemaRules.mask) ) != 0 ) ) {
				if ( StructKeyExists(schemaRules, "mask") ) {
					msg = " in #schemaRules.mask# format";
				}
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# should be a date#msg#");
				if ( arguments.stopOnError ) {
					return false;
				}
			}
		} else if ( schemaRules.type == "string" ) {
			if ( !IsSimpleValue(jsonDoc) ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# should be a string");
				if ( arguments.stopOnError ) {
					return false;
				}
			} else if ( StructKeyExists(schemaRules, "minlength") && Len(jsonDoc) < schemaRules.minlength ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# should have a minimum length of #schemaRules.minlength#");
				if ( arguments.stopOnError ) {
					return false;
				}
			} else if ( StructKeyExists(schemaRules, "maxlength") && Len(jsonDoc) > schemaRules.maxlength ) {
				ArrayPrepend(request[arguments.errorVar], "#arguments._item# should have a maximum length of #schemaRules.maxlength#");
				if ( arguments.stopOnError ) {
					return false;
				}
			}
		}
		if ( ArrayLen(request[arguments.errorVar]) ) {
			return false;
		} else {
			return true;
		}
	}

}
