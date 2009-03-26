<circuit access="public">

<prefuseaction>
<set name="attributes.returnURL" value="" overwrite="false" />
</prefuseaction>

<fuseaction name="main">
	<if condition="isUserInRole('S2IsPrivate')">
		<true>
		<do action="home.redirect" />
		</true>
	</if>
<do action="vLogin.main" contentvariable="fusebox.layout" />
</fuseaction>

<fuseaction name="login">
<invoke object="application.loginManager" methodcall="login(attributes)"  />
</fuseaction>

<fuseaction name="failed" contentvariable="fusebox.layout">
<do action="vLogin.main" />
</fuseaction>

<fuseaction name="logout">
<invoke object="application.loginManager" methodcall="logout()"  />
<relocate url="index.cfm" addtoken="false"/>
</fuseaction>

<postfuseaction>
<do action="layout.display"/>
</postfuseaction>

</circuit>