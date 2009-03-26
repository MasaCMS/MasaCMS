<circuit access="internal">
	<prefuseaction>
		<set name="fusebox.ajax" value="" overwrite="false" />
		<set name="fusebox.layout" value="" overwrite="false" />
	</prefuseaction>
	<fuseaction name="display">
		<include template="template.cfm" required="true"/>
	</fuseaction>
	<fuseaction name="empty">
		<include template="empty.cfm" required="true"/>
	</fuseaction>
	<fuseaction name="jsonencode">
		<include template="jsonencode.cfm" required="true"/>
	</fuseaction>
	<fuseaction name="compact">
		<include template="compact.cfm" required="true"/>
	</fuseaction>
</circuit>
