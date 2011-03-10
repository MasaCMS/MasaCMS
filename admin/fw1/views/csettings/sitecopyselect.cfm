<cfsavecontent variable="rc.layout">
<cfoutput>
<h2>Site Copy Tool</h2>
<!--- ><p class="notice">IMPORTANT: All content in the site that is being copied to will be replaced.</p> --->
<p class="notice">IMPORTANT: All content in the destination site ("To") will be deleted and replaced with the source site's ("From") content.</p>
<form action="index.cfm" onsubmit="if(validateForm(this)){jQuery('##actionButtons').hide();jQuery('##actionIndicator').show();return true;}else{return false;};">
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
<div class="clearfix" id="actionButtons">
<input type="submit" value="Copy">
</div>
<div id="actionIndicator" style="display: none;">
	<img class="loadProgress" src="#application.configBean.getContext()#/admin/images/progress_bar.gif">
</div>
</form>
</cfoutput>
</cfsavecontent>