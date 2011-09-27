<cfset strField = "" />
<cfsilent>
</cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</p>
	<cfloop from="1" to="#ArrayLen(dataset.datarecordorder)#" index="iiy">
		<cfset record = dataset.datarecords[dataset.datarecordorder[iiy]] />
		<input name="#field.name#" type="radio"<cfif record.isselected eq 1> CHECKED</cfif> value="#record.value#"><label>#record.label#</label>
	</cfloop>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#strField#
</cfoutput>

<!--- THIS IS THE MARKUP I NEED --->
<!---I'm using jQuery to add the data-role attributes to the dom in mobile.cfm --->
<!---<ul>
    <li>	
    		<p>Checkbox Group Title</p>
         	<input type="radio" name="radio-choice-1" id="radio-choice-1" value="choice-1" checked="checked" />
         	<label for="radio-choice-1">Cat</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-2" value="choice-2"  />
         	<label for="radio-choice-2">Dog</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-3" value="choice-3"  />
         	<label for="radio-choice-3">Hamster</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-4" value="choice-4"  />
         	<label for="radio-choice-4">Lizard</label>
    </li>
</ul>--->
