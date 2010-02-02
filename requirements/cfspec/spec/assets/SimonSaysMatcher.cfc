<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function setArguments(expected) {
    _expected = expected;
  }

  function isMatch(target) {
    _actual = target.whatWouldSimonSay();
    return _actual == _expected;
  }

  function getFailureMessage() {
    return "expected Simon to say #inspect(_expected)#, but he said #inspect(_actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected Simon not to say #inspect(_expected)#, but he did";
  }

  function getDescription() {
    return "simon says #inspect(_expected)#";
  }

</cfscript></cfcomponent>