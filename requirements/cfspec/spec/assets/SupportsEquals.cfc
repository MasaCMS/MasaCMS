<cfcomponent output="false"><cfscript>

  function init(data) {
    $data = data;
    return this;
  }

  function isEqualTo(obj) {
    return $data == obj.getData();
  }

  function inspect() {
    return htmlEditFormat("<SupportsEquals:#hash($data)#>");
  }

  function getData() {
    return $data;
  }

</cfscript></cfcomponent>