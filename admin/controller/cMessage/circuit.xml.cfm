<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
</prefuseaction>

<fuseaction name="noaccess">
<do action="vmessage.noaccess" contentvariable="fusebox.layout"/>
</fuseaction>
	

<postfuseaction>
<do action="layout.display"/>
</postfuseaction>

</circuit>