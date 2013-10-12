<cfsilent>
<cfparam name="attributes.datetime" default="">
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
<cfparam name="session.localeHasDayParts" default="true">
<cfparam name="attributes.time" default="#attributes.datetime#">
<cfparam name="attributes.required" default="false">
<cfparam name="attributes.message" default="">
<cfparam name="attributes.break" default="false">
<cfparam name="attributes.dateclass" default="">

<cfset attributes.hourname="">
<cfset attributes.minutename="">
<cfset attributes.daypartname="">
</cfsilent>

<cfoutput>
<input type="text" class="datepicker #attributes.dateclass# span3 mura-datepicker#attributes.name#" value="#LSDateFormat(attributes.datetime,session.dateKeyFormat)#" maxlength="12"/><cfif attributes.break><br/></cfif>
<cf_timeselector attributecollection="#attributes#">
<input type="hidden" id="mura-#attributes.name#" name="#attributes.name#" value="#attributes.datetime#" data-required="#attributes.required#" data-required="#attributes.message#"/>
<script>
	$(function(){
		$('.mura-datepicker#attributes.name#').change(
			function(){
				parseDateTimeSelector('#attributes.name#');
			}
		);
	});
</script>
</cfoutput>


