component extends='mura.cfobject' {
 
  function onRenderStart(m) {
    arguments.m.addToHTMLFootQueue('<script #m.getMuraJSDeferredString()# src="/core/modules/v1/gatedasset/assets/js/module.js"></script>');
  }
 
  function onGatedAssetSuccess(m) {
    var gatedkey = 'GATED_' & rereplace(event.get('formid'),"-","","all");
    cfcookie(
      name = '#gatedkey#',
      value = "#now()#",
      expires = 365,
      httpOnly = false
    );
  }

}
