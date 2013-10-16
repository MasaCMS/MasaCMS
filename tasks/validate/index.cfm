<cfscript>
	data=deserializeJSON(form.data);
	
	if(isDefined('data.bean') && isDefined('data.loadby')){
		writeOutput(new mura.json().jsonencode(
			application.serviceFactory
				.getBean(data.bean)
				.loadBy(data.loadby=data[data.loadby],siteid=data.siteid)
					.set(data)
					.validate()
					.getErrors()
		));
	} else {
		writeOutput(new mura.json().jsonencode(
			new mura.bean.bean()
				.set(deserializeJSON(form.data))
				.setValidations(deserializeJSON(form.validations))
				.validate()
				.getErrors()
		));
	}
</cfscript>