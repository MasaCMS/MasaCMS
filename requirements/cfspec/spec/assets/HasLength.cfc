<cfcomponent><cfscript>

  function init(size) {
    $size = size;
    return this;
  }

  function length() {
    return $size;
  }

</cfscript></cfcomponent>