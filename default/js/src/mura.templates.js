mura.templates={};
mura.templates['meta']=function(context){
  if(context.label){
    return "<h3>" + mura.escapeHTML(context.label) + "</h3>";
  } else {
    return '';
  }  
}
mura.templates['text']=function(context){
  var str='<div class="mura-meta">';
  str+=mura.templates['meta'](context);
  str+='</div><div class="mura-content">'; 
  if(context.text){
     str+="<p>" + mura.escapeHTML(context.text) + "</p>";
  } else {
     str+='<p>This text has not been configured.</p>';
  }  
  str+='</div>';

  return str;
}