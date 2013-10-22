<cfscript>
	data=deserializeJSON(form.data);
	errors={};

	if(isDefined('form.validations')){
		structAppend(errors,new mura.bean.bean()
			.set(data)
			.setValidations(deserializeJSON(form.validations))
			.validate()
			.getErrors()
		);
	}

	if(isDefined('data.bean') && isDefined('data.loadby')){
		structAppend(errors,
			application.serviceFactory
			.getBean(data.bean)
			.loadBy(data.loadby=data[data.loadby],siteid=data.siteid)
			.set(data)
			.validate()
			.getErrors()
		);
	}

	writeOutput(new mura.json().jsonencode(errors));
	
</cfscript>