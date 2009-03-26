<!---
Description:  a random password generator
Date Created: 10-2-2002
Author: Bobby Hartsfield 
        bobby@acoderslife.com
--->		

<!---===========================EXAMPLE OF USE===========================--->
<!--- 
<CF_RANDOM_PASS LENGTH="10"          <!--- Number of cahracters to use in the password. Default is 6 --->
           CHARSET="AlphaNumeric"    <!--- Types of characters to use in the password Alph/Numeric/Alphanumeric. Default is Alphanumeric (letters and numbers) --->
		   UCASE="No"                <!--- Use Uppercase letters in the password?? default is YES --->
		   RETURNVARIABLE="pword">   <!--- Name of the variable to store the password in (default is RandomPassword)--->

<cfoutput>#pword#</cfoutput>
 --->

<cfif thistag.executionMode NEQ "start">
  <cfexit method="exittag" />
</cfif>

<!---=============================ATTRIBUTES==============================--->
<!--- default length of the password to be generated --->
<cfparam name="ATTRIBUTES.Length" default="6">

<!--- types of characters to use in the password (default Uppercase, Lowercase letters and 0-9 --->
<cfparam name="ATTRIBUTES.CharSet" default="alpanumeric">

<!--- name of the variable to store the generated password (default RandomPassword) --->
<cfparam name="ATTRIBUTES.ReturnVariable" default="RandomPassword">

<!--- yes/no  include uppercase characters in the password? (default yes)--->
<cfparam name="ATTRIBUTES.Ucase" default="yes">
<!---=====================================================================--->


<!---===========================ERROR HANDLING============================--->
<cfif NOT isnumeric(ATTRIBUTES.Length)>
 <cfthrow detail="The attribute <b>Length</b> must be a valid numeric value">
</cfif>

<!--- valid CharSets are handled as the defaultcase below --->

<!--- ATTRIBUTES.Ucase is only checked for as "YES" if it is NOT "YES" uppercase letters are simply not included
      no errors will be thrown no matter what you specify as this attribute--->
<!---=====================================================================--->


<!---========================LISTS OF CHARACTERS==========================--->
<cfset alphaLcase = "a|c|e|g|i|k|m|o|q|s|u|w|y|b|d|f|h|j|l|n|p|r|t|v|x|z">
<cfset alphaUcase = "A|C|E|G|I|K|M|O|Q|S|U|W|Y|B|D|F|H|J|L|N|P|R|T|V|X|Z">
<cfset numeric =    "0|2|4|6|8|9|7|5|3|1">
<!---=====================================================================--->

<!--- decide what cars to use in generating the password --->
<cfswitch expression="#ATTRIBUTES.CharSet#">

 <cfcase value="alpha">
  <cfset charlist = alphaLcase>
   <cfif ATTRIBUTES.UCase IS "Yes">
    <cfset charList = listappend(charlist, alphaUcase, "|")>
   </cfif>
 </cfcase>

 <cfcase value="alphanumeric">
  <cfset charlist = "#alphaLcase#|#numeric#">
   <cfif ATTRIBUTES.UCase IS "Yes">
    <cfset charList = listappend(charlist, alphaUcase, "|")>
   </cfif>  
 </cfcase>
 
 <cfcase value="numeric">
  <cfset charlist = numeric>
 </cfcase>
  
 <cfdefaultcase><cfthrow detail="Valid values of the attribute <b>CharSet</b> are Alpha, AlphaNumeric, and Numeric"> </cfdefaultcase> 
</cfswitch>

<cfparam name="ThisPass" default="">

<!--- each loop count gets one new character and adds it to the end of the password,
so loop from 1 to "the number set in the calling template in ATTRIBUTES.Length --->
<cfloop from="1" to="#ATTRIBUTES.Length#" index="i">

<!--- pick a random number between 1 and the length of the list of chars to use --->
 <cfset ThisNum = RandRange(1,listlen(charlist, "|"))>

<!--- get the character that is at the random numbers position in the list of characters ---> 
 <cfset ThisChar = ListGetAt(Charlist, ThisNum, "|")>

<!--- append the new random character to the password ---> 
 <cfset ThisPass = ListAppend(ThisPass, ThisChar, " ")>

</cfloop>

<cfset ThisPass = replace(ThisPass, " ", "", "ALL")>
<cfset "Caller.#ATTRIBUTES.ReturnVariable#" = ThisPass>