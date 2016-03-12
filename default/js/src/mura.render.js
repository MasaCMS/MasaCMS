mura.render={};
mura.render['form']=function(context) {
	var item = new window.mura.UI( context );
	var ident = "mura-form-" + context.objectid;
	var data = {};

	context.formEl = "#" + ident;

	context.html = "<div id='"+ident+"'></div>";

	$(context.targetEl).html( mura.templates.content(context) );

	if (item.settings.view == 'form') {
		window.mura.get(
			window.mura.apiEndpoint + '/' + window.mura.siteid + '/content/' + context.objectid
			 + '?fields=body&ishuman=true'
		).then(function(data) {
			this.data = data;
//		 	formJSON = JSON.parse( data.data.body );
			item.getForm();
		});
	}
	else {
		item.getList();
	}

}
