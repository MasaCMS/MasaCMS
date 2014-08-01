component extends="mura.cfobject" {
	
	remote function validate() returnformat='json' {

		param name="form.validations" default="{}";
		param name="form.data" default="{}";

		data=deserializeJSON(urlDecode(form.data));
		validations=deserializeJSON(urlDecode(form.validations));
		
		errors={};

		if(!structIsEmpty(validations)){

			structAppend(errors,new mura.bean.bean()
				.set(data)
				.setValidations(validations)
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
		
		
		return errors;	

	}

}