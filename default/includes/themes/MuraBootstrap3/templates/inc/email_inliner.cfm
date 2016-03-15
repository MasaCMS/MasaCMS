<cfif $.event('showInline') eq 1>
	<cfscript>
		ql = '';
		
		UTMsource = $.content('UTMsource');
		UTMmedium = $.content('UTMmedium');
		UTMcampaign = $.content('UTMcampaign');
		UTMcontent = $.content('UTMcontent');
		
		if( len(UTMsource) ){
			ql = trim(listAppend(ql,'utm_source=' & UTMsource));
		};
		if( len(UTMmedium) ){
			ql = trim(listAppend(ql,'utm_medium=' & UTMmedium));
		};
		if( len(UTMcampaign) ){
			ql = trim(listAppend(ql,'utm_campaign=' & UTMcampaign));
		};
		if( len(UTMcontent) ){
			ql = trim(listAppend(ql,'utm_content=' & UTMcontent));
		};
		
		lastItem = trim(listLast(ql));
	</cfscript>
	
	<cfsavecontent variable="qs"><cfoutput><cfloop list="#ql#" index="i">#trim(i)#<cfif not i eq lastItem>&</cfif></cfloop></cfoutput></cfsavecontent>
	
	<!--- <cfdump var="#trim(qs)#" abort=true> --->
    <cfset inlineContent=$.mxp.getInline(sourceHTML=$.content().getURL(complete=true),linkQueryString=trim(qs))>
    <!--- <cfdump var="#inlineContent#" abort=true> --->
    <cfoutput>
    <div style="padding:0 20px;">
	    <h2>UTM Variables</h2>
	    <p>
	       <strong>Marketing Program:</strong> <cfif len($.content('eProgramName'))>#esapiEncode('html',$.content('eProgramName'))#<cfelse>N/A</cfif><br>
		   <strong>Source:</strong> #esapiEncode('html',UTMsource)#<br>
		   <strong>Medium:</strong> #esapiEncode('html',UTMmedium)#<br>
		   <strong>Campaign:</strong> #esapiEncode('html',UTMcampaign)#<br>
		   <strong>Content:</strong> #esapiEncode('html',UTMcontent)#
	    </p> 
    </div>
    <div style="padding:0 20px;">
	    <h2>Generated HTML</h2>
	    <textarea style="width:100%;height:300px;">#inlineContent.inlinedHTML#</textarea>
    </div>
    
     <div style="padding:20px;">
	    <h2>Generated Text</h2>
	    <textarea style="width:100%;height:300px;">#inlineContent.inlinedText#</textarea>
    </div>
    </cfoutput>
</cfif>
