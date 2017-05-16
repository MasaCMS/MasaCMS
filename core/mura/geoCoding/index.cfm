<!---
	Author       : Raymond Camden 
	--->
<cfset oGeo = createObject("component", "googlegeocode")>

<cfparam name="form.address" default="">
<!--- This is my Google API key. You can get it here: http://code.google.com/apis/maps/signup.html
	This is the one I signed up for Lucee --->
<cfset key = "ABQIAAAAz4xmsSrdMgouNCysOe_oOBSp0ls6l3zzZJBJLLvUdL5iIGn5bxRrvpnv5r2FjPee49Jkd1k5G2nfaw">

<cfif len(trim(form.address))>
	<body onload="load()" onunload="GUnload()">
<cfelse>
	<body>
</cfif>

<h2>Google Geocode Demo</h2>

<cfoutput>
<p>
<form action="index.cfm" method="post">
Enter an address: <input type="text" name="address" value="#HTMLEditFormat(form.address)#"> <input type="submit" value="Geocode!">
</form>
</p>
</cfoutput>

<cfif len(trim(form.address))>
	<!--- Here I call the geoCode Google API to retrieve the Longitude and latitude of an address 
		it returns floating point numbers that can be inserted into the address table like the one I have 
		attached --->
	<cfset result = oGeo.geocode(key,trim(form.address))>
	
	<cfdump var="#result#" label="Geocode Information">

	<cfif structKeyExists(result, "latitude") and structKeyExists(result, "longitude")>
	<cfoutput>	
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=#key#" type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
       map.setCenter(new GLatLng(<cfoutput>#result.latitude#,#result.longitude#</cfoutput>), 15);
	   map.addControl(new GSmallMapControl());
		map.addControl(new GMapTypeControl());

	    var point = new GLatLng(<cfoutput>#result.latitude#,#result.longitude#</cfoutput>);
		map.addOverlay(new GMarker(point));
       }
    }
    //]]>
    </script>
    
    <div id="map" style="width: 500px; height: 300px"></div>	
	</cfoutput>
	</cfif>
</cfif>

</body>

