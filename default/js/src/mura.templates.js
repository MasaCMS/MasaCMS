mura.templates={};
mura.templates['meta']=function(context){

	if(context.label){
		return '<div class="mura-object-meta"><h3>' + mura.escapeHTML(context.label) + '</h3></div>';
	} else {
	    return '';
	}
}
mura.templates['content']=function(context){
	context.html=context.html || context.content || context.source || '';

  	return '<div class="mura-object-content">' + context.html + '</div>';
}
mura.templates['text']=function(context){
	context=context || {};
	context.source=context.source || '<p>This object has not been configured.</p>';
 	return context.source;
}
mura.templates['embed']=function(context){
	context=context || {};
	context.source=context.source || '<p>This object has not been configured.</p>';
 	return context.source;
}
