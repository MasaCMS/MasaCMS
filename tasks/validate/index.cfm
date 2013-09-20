<cfscript>
	writeOutput(new mura.json().jsonencode(
		new mura.bean.bean()
			.set(deserializeJSON(form.data))
			.setValidations(deserializeJSON(form.validations))
			.validate()
			.getErrors()
	));
</cfscript>