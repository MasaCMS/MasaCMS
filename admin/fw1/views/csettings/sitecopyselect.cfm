<cfsavecontent variable="rc.layout">
<cfoutput>
<h2>Site Copy Tool</h2>
<!--- ><p class="notice">IMPORTANT: All content in the site that is being copied to will be replaced.</p> --->
<p class="notice">IMPORTANT: All content in the destination site ("To") will be deleted and replaced with the source site's ("From") content.</p>
<form action="index.cfm" onsubmit="return validateForm(this);">
<dl class="oneColumn">
	<dt>From</dt>	
	<dd><select name="fromSiteID" required="true" message="The 'SOURCE' site is required.">
		<option value="">--Select Source Site--</option>
		<cfloop query="rc.rsSites">
			<option value="#rc.rsSites.siteid#">#rc.rsSites.site#</option>
		</cfloop>
		</select>
	</dd>
	<dt>To</dt>	
	<dd><select name="toSiteID" required="true" message="The 'DESTINATION' site is required.">
		<option value="">--Select Destination Site--</option>
		<cfloop query="rc.rsSites">
			<option value="#rc.rsSites.siteid#">#rc.rsSites.site#</option>
		</cfloop>
		</select>
	</dd>
</dl>
<input type="hidden" name="fuseaction" value="cSettings.sitecopy">
<input type="submit" value="Copy">
</form>
</cfoutput>
</cfsavecontent>