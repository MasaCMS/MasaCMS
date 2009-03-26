<circuit access="public">

<prefuseaction>
</prefuseaction>
	
<fuseaction name="list">
<invoke object="application.pluginManager" methodcall="getSitePlugins(attributes.siteid)" returnVariable="request.rslist" />
<do action="vPlugins.list" contentvariable="fusebox.layout"/>
</fuseaction> 
		
<postfuseaction>
<do action="layout.display"/>
</postfuseaction>

</circuit>