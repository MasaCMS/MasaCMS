<!---	
	* Title: bad_word.cfm
	* Author: Douglas Brown
	* Date: 12/14/2001
	* Questions or comments: dbrown@socal.rr.com
	* Usage: This tag can be used in any form submittal, where the use of profanity is not desired
	  Place the tag in the your processing page before doing your insert of form variables.
	* Parameters: The use of the tag is quite simple, see below
	
	<CF_BAD_WORD
		FORMFIELDS="field1,field2,field3" /Comma Delimeted list of form field names.
		BADWORDS="badword1,badword2,badword3" /Comma Delimeted list of bad words.
		REPLACEMENTSTRING"yourString"> /What string value you want the badwords replaced with.
//--->	



<!---Declare our variables and set their values to the attributes specified in the tag.//--->
<CFSET replacementString = #attributes.replacementString#>
<CFSET formfields = #attributes.formfields#>
<CFSET badwords = #attributes.badwords#>
<!---Replace the "," delimeted list of bad words with a "|" delimeted list//--->
<CFSET badwords = #ReReplaceNoCase(badwords, "," , "|" , "ALL")#>


<CFOUTPUT>
<!---Loop through formfields element and set the value accordingly//--->
	<CFLOOP index="i" LIST="#formfields#">
		<CFSET #FORM_ELEMENT# = "FORM." & #i#>
		<CFSET formfields = #evaluate(FORM_ELEMENT)#>
		<!---If our formfields value is "" set it's value to NULL//--->
			<CFIF formfields IS "">
				<CFSET "CALLER.#i#" = "NULL">
			<CFELSE>
				<CFSET "CALLER.#i#"  =  REREplaceNoCase("#evaluate(FORM_ELEMENT)#",  "#badwords#",  "#attributes.replacementString#" ,  "ALL")>
			</CFIF>
	</CFLOOP>
</CFOUTPUT>

