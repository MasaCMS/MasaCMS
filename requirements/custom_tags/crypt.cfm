<cfsilent>
<!--- -->
	TAG:		crypt.cfm (cf_crypt)
	AUTHOR:		Bill Killillay (billk@activegroup.net)
	
	LICENSE:
		OSI Certified Open Source Software - see included license.txt
	
	DESCRIPTION:		
		See the included readme.txt for full description and use instructions.

	USAGE:
		See the included readme.txt for full usage and notes.
						
	REVISION HISTORY:	v 1.0		Aug 15, 2001		Original Release
	REVISION HISTORY:	v 1.5		Nov 25, 2001		Rewrote in CFScript, finally
	REVISION HISTORY:	v 1.5.1		Nov 28, 2001		Fixed a couple of small errors
--->
	<cfscript>
		// check for all our required incoming vars, and set our default returns
		doLogic = "False"; // set a flag that is false until we get all our required params
		if (not isDefined('attributes.action')) { // check for an action, if there is not one default to 'en'
			attributes.action = "en"; 
		}
		if (not isDefined('attributes.return')) { // check for a return var name, if none, defualt to 'crypt'
			attributes.return = "crypt"; 
		}
		// create our blank struct that will hold our results the struct elements as we test for the required elements
		setvariable("caller.#attributes.return#",structnew());
		setvariable("caller.#attributes.return#.value","");
		setvariable("caller.#attributes.return#.error", "False");
		if (not isDefined('attributes.string') or not len(trim(attributes.string))) { // check for string, and then some length to it
			errorMsg = "String is a required element!";
			setvariable("caller.#attributes.return#.value",errorMsg);
			setvariable("caller.#attributes.return#.error", "True");
			doLogic = "False";
			break;
		} else {
			// Rename sting to make it easier to read and work with
			string = attributes.string;
			setvariable("caller.#attributes.return#.string", string);
			doLogic = "True";
		}
		if (not isDefined('attributes.key') or not len(trim(attributes.key))) { // check for key, and then some length to it
			errorMsg = "Key is a required element!";
			setvariable("caller.#attributes.return#.value",errorMsg);
			setvariable("caller.#attributes.return#.error", "True");
			doLogic = "False";
			break;
		} else {
			// Rename key to make it easier to read and work with
			key = attributes.key;
			setvariable("caller.#attributes.return#.key",key);
			doLogic = "True";
		}

		// test doLogic, if it's true run it, if not we have returned enough based on above for the
		// user to debug and correct the problem.
		if (doLogic eq "True") {
			// Stream line everything down through one switch statement
			switch(attributes.action) {
				// Do our encryption stuff here.
				case("en"):
				
					// Calculate the checksum of the original message using the ASCII value for each character.
					stringCheckSum = 0;
					thisCharVal = 0;
					
					// loop over our incoming string and set our check sum
					loopCnt = len(string);
					for (cnt = 1; cnt lte loopCnt; cnt = cnt + 1) {
						thisCharVal = asc(mid(string, cnt, 1));
						stringCheckSum = stringCheckSum + thisCharVal;
					}
					
					// Add a leading 0 to the check sum if the check sum doesn't have an even number of characters. --->
					if (len(stringCheckSum) mod 2 is 1) {
						stringCheckSum = "0" & stringCheckSum;
					}
	
					// Now we'll modify the check sum by flipping the first and second halves.
					halfLen = len(stringCheckSum) \ 2;
					stringCheckSum = mid(stringCheckSum, halfLen + 1, halfLen) & mid(stringCheckSum, 1, halfLen);
					
					// Now lets set the "raw" default CF encrypted text.
					stringRaw = encrypt(string, key);
					
					// Now lets clean that raw string up a bit
					// This algorithm replaces each raw character with it's hex value, shifted 1 bit left and flipped.
					stringClean = "";
					loopCnt = len(stringRaw);
					for (cnt = 1; cnt lte loopCnt; cnt = cnt + 1) {
						// Get the hex value of the ASCII value of the character shifted 1 bit to the left.
						thisCharHex = formatbasen(bitshln(asc(mid(stringRaw, cnt, 1)), 1), 16);
						// Add a leading 0 if this Hex has only 1 chr
						if (len(thisCharHex) eq 1) {
							thisCharHex = "0" & thisCharHex;
						}
						// Flip the upper and lower nibbles of the bit.
						thisCharHexFlip = mid(thisCharHex,2,1) & mid(thisCharHex,1,1);
						// Add this new value to the "clean" encrypted string.
						stringClean = stringClean & ucase(thisCharHexFlip);
					}
					
					// Create the return variable with encrypted text and original checksum. The "J" is a non-obvious delimiter.
					value = stringCheckSum & "J" & stringClean;
					setvariable("caller.#attributes.return#.value", value);
				break;
				
				// This is our break between case statements //
				// just some space for me to catch my breath //
				
				// Do our decryption stuff here.
				case("de"):
					// Setup an error array to handle any errors, we will reference this on he other side when we are done.
					crypErrArry = arrayNew(1);
					
					// Check for the check sum J, if it's not there, append to our error array.
					if (findnocase("J", string, 1) is 0) {
						arrayAppend(crypErrArry, "No Check Sum");
						if (arraylen(crypErrArry) gte 1) {
							// set our loop count
							errorMsg = "";
							loopCnt = arraylen(crypErrArry);
							for (cnt = 1; cnt lte loopCnt; cnt = cnt + 1) {
								errorMsg = errorMsg & crypErrArry[1];
							}
							setvariable("caller.#attributes.return#.error", "true");
							setvariable("caller.#attributes.return#.errorType", errorMsg);
						}
						break;
					}
					// Check for the check sum J, if it's there lets clean and build our string again
					if (findnocase("J", string, 1) gte 1) {
						// Get the modified check sum from the string.
						stringCheckSum = mid(string, 1, (findnocase("J", string, 1) -1));
						// Re-create the actual check sum by flipping the first and second halves.
						halfLen = len(stringCheckSum)/ 2;
						stringCheckSum = mid(stringCheckSum, halfLen + 1, halfLen) & mid(stringCheckSum, 1, halfLen);
						// Now lets get the "clean" encrypted string.
						stringClean = right(string, len(string) - findnocase("J", string, 1));
					}
					// Lets double check our new string to make sure we have one, and that we have an even number in it.
					if (len(stringClean) is 0 or (len(stringClean) mod 2 is not 0)) {
						arrayAppend(crypErrArry, "Bad string.");
						if (arraylen(crypErrArry) gte 1) {
							// set our loop count
							errorMsg = "";
							loopCnt = arraylen(crypErrArry);
							for (cnt = 1; cnt lte loopCnt; cnt = cnt + 1) {
								errorMsg = errorMsg & crypErrArry[1];
							}
							setvariable("caller.#attributes.return#.error", "true");
							setvariable("caller.#attributes.return#.errorType", errorMsg);
						}
						break;
					}
					
					// Now lets break out our "raw" encryption from our "cleaned" version.
					stringRaw="";
					loopCnt = len(stringClean);
					for (cnt = 1; cnt lte loopCnt; cnt = cnt + 2) {
						// Get the hex value and flip it to re-create the actual hex value.
						thisCharHexFlip = mid(stringClean, cnt, 2);
						thisCharHex = mid(thisCharHexFlip, 2, 1) & mid(thisCharHexFlip, 1, 1);
						// Get the characater after converting to decimal and shifting right by 1 bit.
						thisChar = chr(bitshrn(inputbasen(thisCharHex, 16), 1));
						// Add this "raw" character to the "raw" encryption string.
						stringRaw = stringRaw & thisChar;
					}
					
					// Determine original value.
					original = decrypt(stringRaw, key);
					
					// Now we build a new check sum based on this string to match it to the original check sum
					originalCheckSum = 0;
					loopCnt = len(original);
					for (cnt = 1; cnt lte loopCnt; cnt = cnt + 1) {
						thisCharVal = asc(mid(original, cnt, 1));
						originalCheckSum = originalCheckSum + thisCharVal;
					}
					// Now lets test the two check sum's
					if (originalCheckSum neq stringCheckSum) {
						// If it fails we are array appending
						arrayAppend(crypErrArry, "Check sum failed!");
						if (arraylen(crypErrArry) gte 1) {
							// set our loop count
							errorMsg = "";
							loopCnt = arraylen(crypErrArry);
							for (cnt = 1; cnt lte loopCnt; cnt = cnt + 1) {
								errorMsg = errorMsg & crypErrArry[1];
							}
							setvariable("caller.#attributes.return#.error", "true");
							setvariable("caller.#attributes.return#.errorType", errorMsg);
						}
						break;
					}
					
					// Setup our return variable now
					setvariable("caller.#attributes.return#.value", original);
				break;
			}
		}
	</cfscript>
</cfsilent>
