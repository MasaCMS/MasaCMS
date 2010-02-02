<cfcomponent><cfscript>

  function init(saying) {
    $saying = saying;
    return this;
  }

  function whatWouldSimonSay() {
    return $saying;
  }

</cfscript></cfcomponent>