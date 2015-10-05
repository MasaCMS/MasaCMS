mura.templates={};
mura.templates['meta']=function(context){
  if(context.label){
    return "<h3>" + mura.escapeHTML(context.label) + "</h3>";
  } else {
    return '';
  }  
}
mura.templates['text']=function(context){
  if(context.text){
    return "<p>" + mura.escapeHTML(context.text) + "</p>";
  } else {
    return '<p>This text has not been configured.</p>';
  }  
}