mura.templates['form']=function(context) {
	var item=new window.mura.UI( context );
	var ident = "mura-form-" + context.objectid;

	context.formEl = "#" + ident;

	context.html = "<div id='"+ident+"'></div>";

	$(context.targetEl).html( mura.templates.content(context) );
//	$(context.formEl).html("Hello I am here!");

	console.log('ui settings');
	console.log(item.settings);

	if( item.settings.view == 'list')
		item.getList();
	else
		item.getForm();

}

mura.templates['datamanager']=function(context) {
	var item=new window.mura.DM( context );
	var ident = "app-container";
	console.log('going');
	
	context.formEl = "#" + ident;

	context.html = "<div id='"+ident+"'></div>";

	$(context.targetEl).html( mura.templates.content(context) );

//	$(context.formEl).html("Hello I am here!");

//	item.getForm();

}
