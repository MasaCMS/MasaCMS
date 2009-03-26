<!--- Fusebox.org thanks Barney Boisvert for contributing this code --->
<cfscript>
/**
 * @param path		An absolute path to clean. (Required)
 * @return Returns a string. 
 *
 * I opted to not use the Java method for backwards compatibility,
 * and because we might need to do relative paths at some point.
 */
function fb_canonicalPath(path, delim) {
	var delimAtFront = left(path, 1) EQ delim;
	var delimAtEnd = right(path, 1) EQ delim;
	var dirArray = listToArray(path, "/\");
	var i = "";
	for (i = 1; i LTE arrayLen(dirArray); i = i + 1) { 
		// don't convert this loop to CFLOOP without thinking
		if (dirArray[i] EQ ".") {
			arrayDeleteAt(dirArray, i);
			i = i - 1;
		} else if (dirArray[i] EQ "..") {
			arrayDeleteAt(dirArray, i);
			if (i GT 1 and right(dirArray[i-1], 1) NEQ ":") {
				arrayDeleteAt(dirArray, i - 1);
				i = i - 1;
			}
			i = i - 1;
		}
	}
	return iif(delimAtFront, "delim", de("")) & arrayToList(dirArray, delim) & iif(delimAtEnd, "delim", de(""));
}
</cfscript>
