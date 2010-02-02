<cfcomponent><cfscript>

  function init(items) {
    $items = items;
    return this;
  }

  function getItems() {
    return $items;
  }

</cfscript></cfcomponent>