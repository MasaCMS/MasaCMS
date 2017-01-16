component 
	output = "false"
	hint = "I provide easy access to Java's HMAC security / crypto methods."
	{


	// I return an initialized component.
	function init(){

		// Store the MAC class definition so that its static methods can be accessed quickly.
		variables.macClass = createObject( "java", "javax.crypto.Mac" );

		// Return this object reference.
		return( this );

	}


	// ---
	// PUBLIC METHODS 
	// ---


	// I hash the given input using the MD5 encoding algorithm and the given secret key. By 
	// default, the hash is returned as a HEX-encoded string.
	function hmacMd5(
		String key,
		String input,
		String encoding = "hex"
		){

		// Hash the input using Hmac MD5.
		var authenticationCode = this._hashInputWithAlgorithmAndKey( "HmacMD5", key, input );

		// Return the authentication code in the appropriate encoding.
		return(
			this._encodeByteArray( authenticationCode, encoding )
		);

	}


	// I hash the given input using the Sha-1 encoding algorithm and the given secret key. By 
	// default, the hash is returned as a HEX-encoded string.
	function hmacSha1(
		String key,
		String input,
		String encoding = "hex"
		){

		// Hash the input using Hmac Sha-1.
		var authenticationCode = this._hashInputWithAlgorithmAndKey( "HmacSHA1", key, input );

		// Return the authentication code in the appropriate encoding.
		return(
			this._encodeByteArray( authenticationCode, encoding )
		);

	}


	// I hash the given input using the Sha-256 encoding algorithm and the given secret key. By 
	// default, the hash is returned as a HEX-encoded string.
	function hmacSha256(
		String key,
		String input,
		String encoding = "hex"
		){

		// Hash the input using Hmac Sha-256.
		var authenticationCode = this._hashInputWithAlgorithmAndKey( "HmacSHA256", key, input );

		// Return the authentication code in the appropriate encoding.
		return(
			this._encodeByteArray( authenticationCode, encoding )
		);

	}


	// ---
	// PRIVATE METHODS 
	// ---


	// I encode the byte array / binary value using the given encoding. The Hex-encoding is used
	// by default.
	function _encodeByteArray( 
		Any bytes, 
		String encoding = "hex"
		){

		// Normalize the encoding value.
		encoding = lcase( encoding );

		// Checking encoding algorithm. 
		if (encoding == "hex"){

			return(
				lcase( binaryEncode( bytes, "hex" ) )
			);

		} else if (encoding == "base64"){

			return(
				binaryEncode( bytes, "base64" )
			);

		} else if (encoding == "binary"){

			// No further encoding required.
			return( bytes );

		}

		// If we made it this far, the encoding was not recognized or is not yet supported.
		throw(
			type = "InvalidEncoding",
			message = "The requested encoding method [#encoding#] is not yet supported."
		);

	}


	// I return a MAC generator for the given key and algorithm.
	function _getMacInstance( String algorithm, String key ){

		// Create the specification for our secret key.
		var secretkeySpec = createObject( "java", "javax.crypto.spec.SecretKeySpec" ).init(
			toBinary( toBase64( key ) ),
			javaCast( "string", algorithm )
		);

		// Get an instance of our MAC generator for the given hashing algorithm. 
		var mac = variables.macClass.getInstance(
			javaCast( "string", algorithm )
		);

		// Initialize the Mac with our secret key spec.
		mac.init( secretkeySpec );

		// Return the initialized Mac generator.
		return( mac );

	}


	// I provide a generic method for creating an Hmac with various algorithms. The hash value
	// is returned as a binary value / byte array.
	function _hashInputWithAlgorithmAndKey( 
		String algorithm,
		String key,
		String input
		){

		// Create our MAC generator.
		var mac = this._getMacInstance( algorithm, key );

		// Hash the input.
		var hashedBytes = mac.doFinal(
			toBinary( toBase64( input ) )
		);

		return( hashedBytes );

	}


	function sha1(algorithm){
		var md = createObject('java','java.security.MessageDigest').getInstance("SHA-1");
		var password=createObject('java','java.lang.String').init(arguments.algorithm);
			md.update(password.getBytes());
	    var $hash = createObject('java','java.math.BigInteger').init(1, md.digest());

	    return $hash.toString(16);
	}

}