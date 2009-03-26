<!--- 
Author: 		Bobby Hartsfield | bobby@acoderslife.com

Date: 			Sep 13, 2005

Description: 	bhcaptcha is my own solution to bots who scour the web for comment forms in an attempt to add their 
				useless links and absurd information to unsuspecting web sites. I'm sure you've seen web forms that
				contained randomly generated images containing strings. You hae to read the string and enter it into
				a text field to submit the form. Well, that is what BHCaptcha is. Only, BHCaptcha is 100% self CF code.
				There is no need for a thrid party image tag to generate the images for you. Read the documentation at
				http://acoderslife.com for more details.
--->

<cfif thistag.executionMode NEQ "start">
  <cfexit method="exittag" />
</cfif>

<cfparam name="attributes.datasource" default="">
<cfparam name="attributes.datasourcetype" default="">
<cfparam name="attributes.imgurl" default="">
<cfparam name="attributes.stringlength" default="5">
<cfparam name="attributes.imgheight" default="40">
<cfparam name="attributes.hiddenkey" default="oKey">
<cfparam name="attributes.keyfield" default="uKey">
<cfparam name="attributes.action" default="captcha">
<cfparam name="attributes.imgpath" default="">
<cfparam name="attributes.imgtype" default="gif">


<cfscript>
	// Put the attribute vars into easilt accessbile local vars (lazy? Maybe...)
	datasource		=   attributes.datasource;
	datasourcetype	=   attributes.datasourcetype;
	imgurl			=   attributes.imgurl;
	imgpath 		=   attributes.imgpath;
	strlen 			=   attributes.stringlength;
	imgheight 		=   val(attributes.imgheight);
	oKey 			=   attributes.hiddenkey;
	uKey 			=   attributes.keyfield;
	imgtype 		=   attributes.imgtype;
	action 			=   attributes.action;
	
	//Make sure action is a valid action
	if (action neq 'rename' and action neq 'initialize')
	{
		action = 'captcha';
	}
	
	// find out how long to make the string
	if (listlen(strlen) gt 1)
	{
		strlen = val(randrange(listfirst(strlen), listlast(strlen)));
	}
	else
	{
		strlen = val(strlen);
	}
</cfscript>


<!---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--->
<!--- SETUP PROCESS --->
<!---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--->
<cfif action is "initialize">

					<!--- make sure the ImgPath is valid --->
					<cfif not directoryexists(ImgPath)>
						<cfthrow detail="The directory '#ImgPath#' does not exist.">
					</cfif>
				
					<!--- also make sure the images are named correctly. We'll just check for a.gif and hope the rest correspnd --->
					<cfif fileexists(ImgPath & "\a.gif")>
					
					<!--- Now, attempt to drop the table (if we can drop, we can most likely create --->
					<cftry>
						<cfquery datasource="#datasource#">
						drop table tcaptcha
						</cfquery>
						<cfcatch type="any"></cfcatch>
					</cftry>
					
					<!--- now attempt to create the table --->
					<cfif datasourcetype is "Access">
				
						<cftry>
							<cfquery datasource="#datasource#" username="#attributes.username#" password="#attributes.password#">
							CREATE TABLE tbl_bhcaptcha
							(
							  LetterID	 	number primary key
							, Letter		text(1)
							, ImageFile		text(20)
							)
							</cfquery>
							<cfcatch type="any"></cfcatch>
						</cftry>
				
					<cfelseif datasourcetype is "SQLServer">
				
						<cftry>
							<cfquery datasource="#datasource#" username="#attributes.username#" password="#attributes.password#">
							CREATE TABLE tbl_bhcaptcha
							(
							  LetterID	 	number primary key
							, Letter		text(1)
							, ImageFile		text(20)
							)
							</cfquery>
							<cfcatch type="any"></cfcatch>
						</cftry>
				
					<cfelse>
						<cfthrow detail="Currently, 'Access' and 'SQLServer' are the only supported values of the initialize action.">
					</cfif>
				
					<!--- if we are this far, the datasource type was valid. Make sure the table exists and that its empty all in one shot.--->
					<cftry>
						<cfquery datasource="#datasource#" username="#attributes.username#" password="#attributes.password#">
						delete from tcaptcha
						</cfquery>
						<cfcatch type="any">
							<cfthrow detail="The table 'tbl_BHCaptcha' does not exist and this script was unable to create it. View the documentation to find out how to create the table manually.">
						</cfcatch>
					</cftry>
					
					<!--- if the script made it this far and 'halt' is false, the table is ready to go --->
						<!--- get a list of all images (#imgtype#) from the directory (#imgpath#) --->
						<cfdirectory directory="#imgpath#" filter="*.#imgtype#" name="imgs" />
						
						<!--- loop over the images, use their name minus the extension for the letter --->
						<!--- rename the image to a random name and add it along with its letter to the database --->
						<cfset i = 0>
						<cfset setStr = "">
						<cfloop query="imgs">
							<cfset i = i + 1>
							<!--- First, generate a random string to use for renaming the image file --->
							<!--- cf_randomp_pass is a free custom tag written by me (Bobby Hartsfield).If the tag
							is missing from the package you downloaded, you can get the source code from my site
							http://acoderslife.com under the ColdFusion the Downloads and/or Tutorials sections (or email me and I'll be glad
							to send you the tag)	--->
							<cf_random_pass length="10" charset="alphanumeric" ucase="no" returnvariable="newkey">
					
							<!--- now that the script has a random string, make sure it doent exist already--->
							<cfquery name="filecheck" datasource="#datasource#">
							select imagefile from tcaptcha
							where imagefile = '#newkey#.#imgtype#'
							</cfquery>
						
							<!--- if the string has been used, keep trying until it is unique --->
							<cfif filecheck.recordcount>
								<cfloop condition="filecheck.recordcount neq 0">
									<cf_random_pass length="10" charset="alphanumeric" ucase="no" returnvariable="newkey">
									<cfquery name="filecheck" datasource="#datasource#" username="#attributes.username#" password="#attributes.password#">
									select imagefile from tcaptcha
									where imagefile = '#newkey#.#imgtype#'
									</cfquery>
								</cfloop>
							</cfif>
					
							<!--- now #newkey# holds a random, unique string 10 characters long --->
							<!--- new key combned with .#imgtype# will be the name that is used to rename the image --->
							<cffile action="rename" source="#imgpath#\#name#" destination="#imgpath#\#newkey#.#imgtype#">
							
							<!--- Add the new image name (along with its letter) to the database --->
							<!--- incedently, each letter's letterid will correspond with that letter's position in the alphabet --->
							<cfquery datasource="#datasource#">
							insert into tcaptcha
							(letterid, letter, imagefile)
							values
							(#val(i)#, '#listfirst(name, ".")#', '#newkey#.#imgtype#')
							</cfquery>
							
							<!--- if #i# is 26, thats all the letters, break out just incase --->
							<cfif i gte 26>
								<cfbreak>
							</cfif>
						</cfloop>
					
						<!--- Ok, now just grab the records and display the images for visual confirmation that the process went ok --->
						<cfquery name="imgs2" datasource="#datasource#">
						select * from tcaptcha
						</cfquery>
					
						<cfloop query="imgs2">
							<cfset setStr = setStr & "<img src=""#imgurl#/#imagefile#"" height=""#imgheight#"">">
						</cfloop>
					
						<cfset caller.bhcaptcha.imgStr = setStr>
						<cfset caller.bhcaptcha.fFields = "">

					</cfif>

<cfelseif action is "rename">
<!---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--->
<!--- RENAMING PROCESS --->
<!---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--->
	
				<!--- get all of the images form the database along with their letters --->
				<cfquery name="imgs" datasource="#datasource#">
				select * from tcaptcha
				</cfquery>
				
				<cfset renStr = "">
				
				<!--- loop the images and individually rename them so we can keep them tied to their corresponding letters --->
				<cfloop query="imgs">
					<cf_random_pass length="10" charset="alphanumeric" ucase="no" returnvariable="newkey">
				
					<!--- now that we have a random string, make sure it doent exist --->
					<cfquery name="filecheck" datasource="#datasource#">
					select imagefile from tcaptcha
					where imagefile = '#newkey#.#imgtype#'
					</cfquery>
					
					<!--- if the string has been used, keep trying until it is unique --->
					<cfif filecheck.recordcount>
						<cfloop condition="filecheck.recordcount neq 0">
							<cf_random_pass length="10" charset="alphanumeric" ucase="no" returnvariable="newkey">
							<cfquery name="filecheck" datasource="#datasource#">
							select imagefile from tcaptcha
							where imagefile = '#newkey#.#imgtype#'
							</cfquery>
						</cfloop>
					</cfif>
				
					<!--- now #newkey# holds a random, unique string 10 characters long --->
					<!--- new key combned with .#imgtype# will be the name that is used to rename the image --->
					<cffile action="rename" source="#imgpath#\#imagefile#" destination="#imgpath#\#newkey#.#imgtype#">
					
					<!--- Add the new image name (along with its letter) to the database --->
					<!--- inedentally, each letter's letterid will correspond with that letter's position in the alphabet --->
					<cfquery datasource="#datasource#">
					update tcaptcha
					set imagefile = '#newkey#.#imgtype#'
					where letter = '#letter#'
					</cfquery>
					
					<cfset renStr = renStr & "<img src=""#imgurl#/#newkey#.#imgtype#"" height=""#imgheight#"">">
				</cfloop>
				
				<!--- now just output the new images for visual confirmation --->
				<cfset caller.bhcaptcha.imgStr = renStr>
				<cfset caller.bhcaptcha.fFields = "">

<cfelse>
<!---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--->
<!--- MAIN CAPTCHA IMAGE AND FORM FIELDS PROCESS --->
<!---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--->

				<!--- generate the string --->
				<cf_random_pass length="#strlen#" charset="alpha" ucase="no" returnvariable="bhcapkey">
				
				<!--- it seems faster to grab all of the records with one trip to the database than to grab a single record on multiple
				trips to the database. So im grabbing all and doing a QoQ for the single records (sorry 4.5 guys :) --->
				<cfquery name="allimgs" datasource="#datasource#" username="#attributes.username#" password="#attributes.password#">
				select letter, imagefile from tcaptcha
				order by letter
				</cfquery>
				<cfset key = bhcapkey>
				<cfset str = "">
				
				<cfloop from="1" to="#len(key)#" index="i">
					<cfsilent>
					<cfset thisletter = left(key, 1)>
					<!--- get the file for this letter --->
					<cfquery name="ti" dbtype="query">
					select imagefile from allimgs
					where letter = '#thisletter#'
					</cfquery>
					</cfsilent>
					<cfif ti.recordcount>
						<cfset str = str & "<img src=""#imgurl#/#ti.imagefile#"" height=""#imgheight#"">">
					</cfif>
					<cfif len(key) gt 1><cfset key = right(key, len(key)-1)></cfif>
				</cfloop>
				
				<cfset caller.bhcaptcha.imgStr = str>
				<cfset caller.bhcaptcha.fFields = "<input type=""hidden"" name=""#oKey#"" value=""#hash(lcase(bhcapkey))#""><input type=""text"" class=""text"" message=""The 'Security Code' field is required."" required=""true"" name=""#uKey#"" size=""20"">">
				
				<!--- 
				On the action template for your form, compare the hash of the user's entry with the value in the hidden field 
				EG: 
				<cfif hash(form.userkey) is form.hiddenkey>
					SUCCESS!
				<cfelse>
					Failed
				</cfif>
				--->
</cfif>
