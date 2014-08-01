<cfsilent>
<cfparam name="attributes.time" default="">
<cfparam name="attributes.name" default="">
<cfparam name="attributes.defaulthour" default="0">
<cfparam name="attributes.defaultminute" default="0">
<cfparam name="attributes.hourname" default="#attributes.name#Hour">
<cfparam name="attributes.minutename" default="#attributes.name#Minute">
<cfparam name="attributes.daypartname" default="#attributes.name#DayPart">
<cfparam name="attributes.hourid" default="mura-#attributes.hourname#">
<cfparam name="attributes.minuteid" default="mura-#attributes.minutename#">
<cfparam name="attributes.daypartid" default="mura-#attributes.daypartname#">
<cfparam name="attributes.hourclass" default="time">
<cfparam name="attributes.minuteclass" default="time">
<cfparam name="attributes.daypartclass" default="time">
<cfparam name="arguments.mySession.localeHasDayParts" default="true">

<cfif lsIsdate(attributes.time)>
	<cfset attributes.defaulthour=hour(attributes.time)>
	<cfset attributes.defaultminute=minute(attributes.time)>
</cfif>

<cfscript>
	if(structKeyExists(server,'railo')){
		backportdir='';
		include "/mura/backport/cfbackport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#cfbackport.cfm";
	}
</cfscript>

</cfsilent>
<cfoutput>
	<cfif session.localeHasDayParts>
		<cfsilent>
			<cfif attributes.defaulthour gte 12>
				<cfif attributes.defaulthour gt 12>
					<cfset attributes.defaulthour=attributes.defaulthour-12>
				</cfif>
				<cfset attributes.daypart="PM">
			<cfelse>
				<cfif attributes.defaulthour eq 0>
					<cfset attributes.defaulthour=12>
				</cfif>
				<cfset attributes.daypart="AM">
			</cfif>	
		</cfsilent>
		<select id="#encodeForHTMLAttribute(attributes.hourid)#" class="#encodeForHTMLAttribute(attributes.hourclass)# mura-datepicker#encodeForHTMLAttribute(attributes.name)#" name="#encodeForHTMLAttribute(attributes.hourname)#"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif h eq attributes.defaulthour>selected</cfif>>#h#</option></cfloop></select>
	<cfelse>
		  <select  id="#encodeForHTMLAttribute(attributes.hourid)#" class="#encodeForHTMLAttribute(attributes.hourclass)# mura-datepicker#encodeForHTMLAttribute(attributes.name)#" name="#encodeForHTMLAttribute(attributes.hourname)#"><cfloop from="0" to="23" index="h"><option value="#h#" <cfif h eq attributes.defaulthour>selected</cfif>>#h#</option></cfloop></select>
	</cfif>

	<select id="#encodeForHTMLAttribute(attributes.minuteid)#" class="#encodeForHTMLAttribute(attributes.minuteclass)# mura-datepicker#encodeForHTMLAttribute(attributes.name)#" name="#encodeForHTMLAttribute(attributes.minutename)#"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif m eq attributes.defaultminute>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
	
	<cfif session.localeHasDayParts>
		<select id="#encodeForHTMLAttribute(attributes.daypartid)#" class="#encodeForHTMLAttribute(attributes.daypartclass)# mura-datepicker#encodeForHTMLAttribute(attributes.name)#" name="#encodeForHTMLAttribute(attributes.daypartname)#"><option value="AM">AM</option><option value="PM" <cfif attributes.daypart eq "PM">selected</cfif>>PM</option></select>
	</cfif>

</cfoutput>


