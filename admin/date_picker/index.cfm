<!---
|| BEGIN FUSEDOC ||
	
|| Properties ||
Name: 
Author: John Crocker (john@netadvances.co.uk
Template Created: 18-07-2002
Last Updated: 

|| Responsibilities ||
Lazarus contentServer Sitemap
|| URL ||


|| END FUSEDOC ||--->

<!----------------------------
|| BEGIN FUSEBOX APPLICATION ||
------------------------------>

<!--- Global parameters --->
<!---<cfoutput>#URLList#</cfoutput>  --->

<!--- Default Action --->
<cfparam name="URL.action" default="showmonth">

<!--- Variable Include --->
<cfinclude template="myGlobals.cfm">

<!--- Some Default Vars --->
<cfswitch expression = "#URL.action#">
<cfcase value="select">
  <cfinclude template="act_dp_selectdate.cfm">
</cfcase>
<cfcase value="showmonth">
<cfinclude template="dsp_dp_showmonth.cfm">
</cfcase>
<cfdefaultcase>
</cfdefaultcase>
</cfswitch>










