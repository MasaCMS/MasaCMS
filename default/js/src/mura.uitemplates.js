mura.templates['form']=function(context) {
	var item=new window.mura.UI( context );
	context.html = "<div id='test1'></div>";
	$(context.targetEl).html( mura.templates.content(context));
	$("#test1").html("Hello I am here!");
}
