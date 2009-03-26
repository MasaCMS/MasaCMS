<cfheader name="Expires" value="#getHttpTimeString(now()-1)#">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Cache-control" value="no-cache, no-store, must-revalidate">

<cffunction name="myDump" access="private" output="true" returnType="void">
	<cfargument name="dumptitle" type="string" required="yes" />
	<cfargument name="dumpvar" type="any" required="yes" />
	<cfif lcase(dumptitle) contains "error message" and isSimpleVAlue(dumpvar) and trim(dumpvar) eq "">
		<cfreturn />
	<cfelse>
		<h3>Dumping:  #dumptitle#</h3>
		<cfdump var="#dumpvar#" />
		<cfreturn />
	</cfif>
</cffunction>

<cffunction name="testHeader" access="private" output="true" returnType="void">
	<cfargument name="testNum" type="any" required="yes">
	<cfargument name="testDescription" type="string" required="no">
	
	<cfoutput>
	<cfif lcase(server.coldfusion.productname) neq "bluedragon">
		<cfflush interval="50"/>
	</cfif>
	<h1 style="border-bottom: 5px solid black;">Test ###testNum#</h1>
	<cfif isDefined("testDescription")><p>#testDescription#</p></cfif>
	</cfoutput>
	<cfreturn />
</cffunction>

<cffunction name="displayResultImage" output="true" returnType="void">
	<cfargument name="image" type="String" required="yes">
	<cfoutput><p><img src="testOutput/#prefix##image#"></p></cfoutput>
	<cfreturn />
</cffunction>

<!--- 10 minute request timeout, these tests can take a while --->
<cfsetting requesttimeout="600">
<!--- change this to test with another image --->
<cfparam name="srcImage" default="">
<cfif not fileExists(expandPath("./#srcImage#"))>
	<cfset srcImage = "">
</cfif>
<h1>imageCFC Test Suite</h1>
<p>THREE images are included with this test suite.  feather.png, normal.jpg and type_custom.jpg.  type_custom.jpg returns an image type of TYPE_CUSTOM in all versions of Coldfusion 6.1 and beyond.</p>
<ul>
<li>Run tests with <a href="test-cases.cfm?srcImage=normal.jpg">normal.jpg</a></li>
<li>Run tests with <a href="test-cases.cfm?srcImage=type_custom.jpg">type_custom.jpg</a></li>
<li>Run tests with <a href="test-cases.cfm?srcImage=feather.png">feather.png</a></li>
</ul>
<cfif srcImage neq "">
<cfset prefix = reReplaceNoCase(srcImage,"\W","","ALL")>

<p><a href="<cfoutput>#srcImage#</cfoutput>" target="_blank">View Original Image</a></p>
<cfscript>
	imagecfc = createObject("component","image");
	imagecfc.setOption("throwOnError","No");

	// get image info (also tests readImage)
	testHeader(1,"call setOption() method");
	try {
		test1 = imagecfc.setOption("throwOnError", "Yes");
		mydump("test1", "test one completed, no results returned (this is normal)");
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(2,"call getOptions() method");
	try {
		test2 = imagecfc.getOption("defaultJpegCompression");
		mydump("test2", test2);
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(3,"call getImageInfo() method");
	try {
		test3 = imagecfc.getImageInfo("","#ExpandPath(".")#/#srcImage#");
		mydump("test3", test3);
		// mydump("test3","dump for this test commented out unless needed.")
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(4,"call scaleWidth() method");
	try {
		test4 = imagecfc.scaleWidth("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test4.jpg", 200);
		if (test4.errorMessage neq "") {
			mydump("test4 error message", test4.errorMessage);
		} else {
			displayResultImage("test4.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(5,"call scaleHeight() method");
	try {
		test5 = imagecfc.scaleHeight("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test5.jpg", 200);
		if (test5.errorMessage neq "") {
			mydump("test5 error message", test5.errorMessage);
		} else {
			displayResultImage("test5.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader("6a","call resize() method, standard resize");
	try {
		// standard resize
		test6a = imagecfc.resize("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test6a.jpg", 200, 200);
		if (test6a.errorMessage neq "") {
			mydump("test6a error message", test6a.errorMessage);
		} else {
			displayResultImage("test6a.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader("6b","call resize() method with preserve aspect ratio");
	try {
		// with preserve aspect ratio on
		test6b = imagecfc.resize("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test6b.jpg", 200, 200, true);
		if (test6b.errorMessage neq "") {
			mydump("test6b error message", test6b.errorMessage);
		} else {
			displayResultImage("test6b.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader("6c","call resize() method with crop to exact");
	try {
		// with crop to exact
		test6c = imagecfc.resize("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test6c.jpg", 200, 200, true, true);
		if (test6c.errorMessage neq "") {
			mydump("test6c error message", test6c.errorMessage);
		} else {
			displayResultImage("test6c.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(7,"call crop() method");
	try {
		test7 = imagecfc.crop("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test7.jpg", 20, 20, 50, 50);
		if (test7.errorMessage neq "") {
			mydump("test7 error message", test7.errorMessage);
		} else {
			displayResultImage("test7.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(8,"call watermark() method");
	try {
		test8 = imagecfc.watermark("","", "#ExpandPath(".")#/#srcImage#", "#ExpandPath(".")#/testOutput/#prefix#test7.jpg", 0.5, 50, 50, "#ExpandPath(".")#/testOutput/#prefix#test8.jpg");
		if (test8.errorMessage neq "") {
			mydump("test8 error message", test8.errorMessage);
		} else {
			displayResultImage("test8.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader("9a","call addText() method with internal font");
	try {
		fontDetails = StructNew();
		// for "built in" fonts
		fontDetails.fontname = "Monospaced"; // or "Serif" or "SansSerif"
		fontDetails.style = "font.BOLD";
		// for truetype font
		// fontDetails.fontFile = "#expandPath(".")/comicbd.ttf";
		fontDetails.color = "white";
		fontDetails.size = 30;
	
		test9a = imagecfc.addText("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test9a.jpg", 20, 20, fontDetails, "ImageCFC Test");
		if (test9a.errorMessage neq "") {
			mydump("test9a error message", test9a.errorMessage);
		} else {
			displayResultImage("test9a.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader("9b","call addText() method with external font file");
	try {
		fontDetails = StructNew();
		// for "built in" fonts
		// fontDetails.fontname = "Monospaced"; // or "Serif" or "SansSerif"
		// fontDetails.style = "font.BOLD";
		// for truetype font
		fontDetails.fontFile = "#expandPath(".")#/comicbd.ttf";
		fontDetails.color = "white";
		fontDetails.size = 30;
	
		test9b = imagecfc.addText("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test9b.jpg", 20, 20, fontDetails, "ImageCFC Test");
		if (test9b.errorMessage neq "") {
			mydump("test9b error message", test9b.errorMessage);
		} else {
			displayResultImage("test9b.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(10,"call flipHorizontal() method");
	try {
		test10 = imagecfc.flipHorizontal("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test10.jpg");
		if (test10.errorMessage neq "") {
			mydump("test10 error message", test10.errorMessage);
		} else {
			displayResultImage("test10.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(11,"call flipVertical() method");
	try {
		test11 = imagecfc.flipVertical("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test11.jpg");
		if (test11.errorMessage neq "") {
			mydump("test11 error message", test11.errorMessage);
		} else {
			displayResultImage("test11.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(12,"call rotate() method");
	try {
		test12 = imagecfc.rotate("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test12.jpg", 90);
		if (test12.errorMessage neq "") {
			mydump("test12 error message", test12.errorMessage);
		} else {
			displayResultImage("test12.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(13,"call filterFastBlur() method");
	try {
		test13 = imagecfc.filterFastBlur("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test13.jpg", 2, 2);
		if (test13.errorMessage neq "") {
			mydump("test13 error message", test13.errorMessage);
		} else {
			displayResultImage("test13.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(14,"call filterSharpen() method");
	try {
		test14 = imagecfc.filterSharpen("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test14.jpg");
		if (test14.errorMessage neq "") {
			mydump("test14 error message", test14.errorMessage);
		} else {
			displayResultImage("test14.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
	testHeader(15,"call filterPosterize() method");
	try {
		test15 = imagecfc.filterPosterize("","#ExpandPath(".")#/#srcImage#","#ExpandPath(".")#/testOutput/#prefix#test15.jpg", 8);
		if (test15.errorMessage neq "") {
			mydump("test15 error message", test15.errorMessage);
		} else {
			displayResultImage("test15.jpg");
		}
	} catch(Any e) {
		mydump("Test Failed",e);
	}
</cfscript>

<h1>END OF TESTS</h1>
<script language="javascript">
	alert('Tests are complete.');
</script>
</cfif>
