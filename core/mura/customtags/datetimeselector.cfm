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
<cfparam name="attributes.datespanclass" default="span3">
<cfparam name="attributes.timeselectwrapper" default="false">
<cfset attributes.hourname="">
<cfset attributes.minutename="">
<cfset attributes.daypartname="">

<cfif isDate(attributes.datetime) and dateDiff('yyyy',now(),attributes.datetime) gt 50>
	<cfset attributes.datetime=''>
</cfif>

<cfscript>
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>

</cfsilent>

<cfoutput>
<input type="text" autocomplete="off" class="datepicker #esapiEncode('html_attr',attributes.dateclass)# #esapiEncode('html_attr',attributes.datespanclass)# mura-datepicker#esapiEncode('html_attr',attributes.name)#" value="#LSDateFormat(attributes.datetime,session.dateKeyFormat)#" maxlength="12" id="mura-datepicker-#esapiEncode('html_attr',attributes.name)#"/><cfif attributes.break><br/></cfif>
<cfif attributes.timeselectwrapper><div class="mura-timeselectwrapper"></cfif>
<cf_timeselector attributecollection="#attributes#">
<cfif attributes.timeselectwrapper></div></cfif>
<input type="hidden" id="mura-#esapiEncode('html_attr',attributes.name)#" name="#esapiEncode('html_attr',attributes.name)#" value="#esapiEncode('html_attr',attributes.datetime)#" data-required="#esapiEncode('html_attr',attributes.required)#" data-required="#esapiEncode('html_attr',attributes.message)#"/>
<script>
	$(function(){
		$('.mura-datepicker#esapiEncode('javascript',attributes.name)#').change(
			function(){
				parseDateTimeSelector('#esapiEncode('javascript',attributes.name)#');
			}
		);
	});
</script>
</cfoutput>
