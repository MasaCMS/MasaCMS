<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfif not listFindNoCase("Folder,Gallery",variables.$.content('type'))>
	<cfsilent>
		<cfif not isNumeric(variables.$.event('rate'))>
			<cfset variables.$.event('rate',0)>
		</cfif>

		<cfset variables.$.event('raterID',variables.$.getPersonalizationID()) />
		<cfif listFind(variables.$.event('doaction'),"saveRate") and variables.$.event('raterID') neq ''>
			<cfset variables.myRate=variables.$.getBean('raterManager').saveRate(
			variables.$.content('contentID'),
			variables.$.event('siteID'),
			variables.$.event('raterID'),
			variables.$.event('rate')) />
		<cfelse>
			<cfset variables.myRate = variables.$.getBean('raterManager').readRate(
			variables.$.content('contentID'),
			variables.$.content('siteID'),
			variables.$.event('raterID')) />
		</cfif>
		<cfset variables.rsRating=variables.$.getBean('raterManager').getAvgRating(variables.$.content('contentID'),variables.$.content('siteID')) />
	</cfsilent>
	<cfoutput>
		<script>
			$(function(){
				mura.loader()
					.loadcss("#variables.$.siteConfig('AssetPath')#/includes/display_objects/rater/css/rater.min.css")
					.loadjs("#variables.$.siteConfig('AssetPath')#/includes/display_objects/rater/js/rater-jquery.min.js"
							,"#variables.$.siteConfig('AssetPath')#/includes/display_objects/rater/js/rater.min.js",
							function(){
								initRatings('rater1');
								$("##svRatings").show();
							});
			});
		</script>
		<div id="svRatings" class="mura-ratings #this.raterObjectWrapperClass#" style="display:none">	
			<!--- Rater --->
			<div id="rateIt" class="#this.raterWrapperClass#">
				<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('rater.ratethis')#</#variables.$.getHeaderTag('subHead1')#>				
				<form name="rater1" id="rater1" method="post" action="">
					<input type="hidden" id="rate" name="rate" value="##">
					<input type="hidden" id="userID" name="userID" value="#variables.$.event('raterID')#">
					<input type="hidden" id="loginURL" name="loginURL" value="#variables.$.siteConfig('loginURL')#&returnURL=#URLencodedFormat(variables.$.getCurrentURL(true,'doaction=saveRate&rate='))#">
					<input type="hidden" id="siteID" name="siteID" value="#variables.$.event('siteID')#">
					<input type="hidden" id="contentID" name="contentID" value="#variables.$.content('contentID')#">
					<input type="hidden" id="formID" name="formID" value="rater1">
					<fieldset>
						<label for="rater1_rater_input0radio1"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio1" value="1" class="stars" <cfif variables.myRate.getRate() eq 1>checked</cfif> >Not at All</label>
						<label for="rater1_rater_input0radio2"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio2" value="2" class="stars"  <cfif variables.myRate.getRate() eq 2>checked</cfif>>Somewhat</label>
						<label for="rater1_rater_input0radio3"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio3" value="3" class="stars" <cfif variables.myRate.getRate() eq 3>checked</cfif>>Moderately</label>
						<label for="rater1_rater_input0radio4"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio4" value="4" class="stars" <cfif variables.myRate.getRate() eq 4>checked</cfif> >Highly</label>
						<label for="rater1_rater_input0radio5"><input type="radio" name="rater1_rater_input0" id="rater1_rater_input0radio5" value="5" class="stars" <cfif variables.myRate.getRate() eq 5>checked</cfif>>Very Highly</label>
						<!---<input type="submit" value="rate it" class="submit">--->
					</fieldset>
				</form>									
			</div>
			<!--- Average Rating --->
			<div id="avgrating" class="#this.avgRatingWrapperClass#">
				<cfif variables.rsRating.theCount gt 0>
					<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('rater.avgrating')# (<span id="numvotes">#variables.rsRating.theCount# <cfif variables.rsRating.theCount neq 1>#variables.$.rbKey('rater.votes')#<cfelse>#variables.$.rbKey('rater.vote')#</cfif></span>)</#variables.$.getHeaderTag('subHead1')#>
					<div id="avgratingstars" class="ratestars #variables.$.getBean('raterManager').getStarText(variables.rsRating.theAvg)#<!--- #replace(variables.rsRating.theAvg(),".","")# --->"><cfif isNumeric(variables.rsRating.theAvg)>#variables.rsRating.theAvg#<cfelse>0</cfif></div>
				</cfif>
			</div>
		</div>		
	</cfoutput>
</cfif>