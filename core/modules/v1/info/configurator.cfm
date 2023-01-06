 <!--- license goes here --->
<cfsilent>
	<cfparam name="objectParams.infolist" default="">
</cfsilent>
<cf_objectconfigurator params="#objectParams#">
<cfoutput>
	<div>
		<div class="mura-layout-row">
		<cfloop list="author:Author,credits:Credits,created:Created,releasedate:Release Date,lastupdate:Last Update" index="i">
			<cfset valobj = listToArray(i,":")>
			<cfset checked = ''>
			<cfif listContains(objectParams.infolist,valobj[1])>
				<cfset checked = 'checked'>
			</cfif>
			<div class="mura-control-group">
				<label class="mura-control-label">#valobj[2]#</label>
				<input type="checkbox" placeholder="Value" id="#valobj[1]#" name="#valobj[1]#" class="optlist" value="#valobj[1]#" #checked#/>
			</div>
		</cfloop>
		</div>
		<input type="hidden" class="objectParam" name="async" value="false">
		<input type="hidden" id="infolist" class="objectParam" name="infolist" value="">
	</div>
	<!--- Include global config object options --->
	<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">
	<script>
	$( document ).ready(function() {
		try {
			$( ".optlist" ).change(function() {
				var vallist = '';
				$( ".optlist" ).each(function() {
					var t = $(this);
					if(t.is(':checked')) {
						vallist += t.val() + ",";
					}
				});
				$("##infolist").val(vallist);
				$("##infolist").change();
				console.log("VALLIST",vallist);

			});
		}
		catch(e) {
			console.log("...");
		}
	});
	</script>
</cfoutput>
</cf_objectconfigurator>
