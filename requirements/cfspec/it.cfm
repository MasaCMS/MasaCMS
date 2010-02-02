<cfsilent>

<cfif thisTag.executionMode eq "start">
  <cfset exitMethod = caller.__cfspecRunner.itStartTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
<cfelse>
  <cfset exitMethod = caller.__cfspecRunner.itEndTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
</cfif>

</cfsilent>