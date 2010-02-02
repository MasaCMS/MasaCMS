<cfcomponent><cfscript>

  function init(size) {
    $size = size;
    return this;
  }

  function size() {
    return $size;
  }

</cfscript></cfcomponent>