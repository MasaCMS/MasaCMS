<!---    
    * Title: badword.cfm
    * Author: Douglas Brown
    * Date: 12/14/2001
    * Questions or comments: dbrown@socal.rr.com
    * Usage: This tag can be used in any form submittal, where the use of profanity is not desired
      Place the tag in the your processing page before doing your insert of form variables.
    * Parameters: The use of the tag is quite simple, see below
    
    <CF_BADWORD
        FORMFIELDS="field1,field2,field3" /Comma Delimeted list of form field names.
        BADWORDS="badword1,badword2,badword3" /Comma Delimeted list of bad words.
        REPLACEMENTSTRING="yourString"> /What string value you want the badwords replaced with.
//--->
<!---Declare our variables and set their values to the attributes specified in the tag.//--->
<cfset replacementString = attributes.replacementString>
<cfset formfields = attributes.formfields>
<cfset badwords = attributes.badwords>
<!---Replace the "," delimeted list of bad words with a "|" delimeted list//--->
<cfset badwords = reReplaceNoCase(badwords, ",", "|", "ALL")>

<cfoutput>
    <!---Loop through formfields element and set the value accordingly//--->
    <cfloop index="i" list="#formfields#">
        <cfset formfields = form[i]>
        <!---If our formfields value is "" set it's value to NULL//--->
        <cfif formfields IS "">
            <cfset form[i] = "NULL">
        <cfelse>
            <cfset form[i] = reReplaceNoCase(form[i], badwords, attributes.replacementString, "ALL")>
        </cfif>
    </cfloop>
</cfoutput>