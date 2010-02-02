<cfimport taglib="/cfspec" prefix="">

<describe hint="Throw">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Throw").init())>
    <cfset $target = $(createObject("component", "cfspec.spec.assets.Widget"))>
    <cfset expectations = createObject("component", "cfspec.lib.Expectations").__cfspecInit(__cfspecRunner, false)>
    <cfset $matcher.setRunner(__cfspecRunner)>
    <cfset $matcher.setExpectations(expectations)>
  </before>

  <it should="match when target throws an exception">
    <cfset $target.nonExistantMethod().shouldThrow()>
  </it>

  <it should="not match when target does not throw an exception">
    <cfset $target.getName().shouldNotThrow()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch($target.getName())>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to throw Any, got no exception")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch($target.getName())>
    <cfset $matcher.getNegativeFailureMessage().shouldMatch("expected not to throw Any, got no exception")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("throw Any")>
  </it>

  <describe hint="with various arguments (some intentional failures)">

    <it should="FAIL because no exception was thrown">
      <cfset $eval("$target.getName().shouldThrow()").shouldThrow("cfspec.fail")>
    </it>

    <it should="FAIL because no exception was thrown">
      <cfset $eval("$target.getName().shouldThrow('RecordNotSaved')").shouldThrow("cfspec.fail")>
    </it>

    <it should="PASS because an exception was thrown">
      <cfset $eval("$target.nonExistantMethod().shouldThrow()").shouldNotThrow()>
    </it>

    <it should="FAIL because the wrong type of exception was thrown">
      <cfset $eval("$target.nonExistantMethod().shouldThrow('RecordNotSaved')").shouldThrow("cfspec.fail")>
    </it>

    <it should="FAIL because the exception message doesn't match">
      <cfset $eval("$target.nonExistantMethod().shouldThrow('Application', 'zzzzz')").shouldThrow("cfspec.fail")>
    </it>

    <it should="FAIL because the exception detail doesn't match">
      <cfset $eval("$target.nonExistantMethod().shouldThrow('Application', 'nonExistantMethod', 'zzzzz')").shouldThrow("cfspec.fail")>
    </it>

    <it should="PASS because the exception matches the type">
      <cfset $eval("$target.nonExistantMethod().shouldThrow('Application')").shouldNotThrow()>
    </it>

    <it should="PASS because the exception matches the type and message">
      <cfset $eval("$target.nonExistantMethod().shouldThrow('Application', 'nonExistantMethod')").shouldNotThrow()>
    </it>

    <it should="PASS because the exception matches the type, message, and details">
      <cfset $eval("$target.nonExistantMethod().shouldThrow('Application', 'nonExistantMethod', 'Ensure that the method is defined')").shouldNotThrow()>
    </it>

    <it should="PASS because no exception was thrown">
      <cfset $eval("$target.getName().shouldNotThrow()").shouldNotThrow()>
    </it>

    <it should="PASS because no exception was thrown">
      <cfset $eval("$target.getName().shouldNotThrow('RecordNotSaved')").shouldNotThrow()>
    </it>

    <it should="FAIL because an exception was thrown">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow()").shouldThrow("cfspec.fail")>
    </it>

    <it should="RETHROW because the wrong type of exception was thrown">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('RecordNotSaved')").shouldThrow("Application", "The method nonExistantMethod was not found", "Ensure that the method is defined")>
    </it>

    <it should="PASS because the wrong type of exception was thrown, but is then caught">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('RecordNotSaved').shouldThrow()").shouldNotThrow()>
    </it>

    <it should="RETHROW because the exception message doesn't match">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('Application', 'zzzzz')").shouldThrow("Application", "The method nonExistantMethod was not found", "Ensure that the method is defined")>
    </it>

    <it should="PASS because the exception message doesn't match, but is then caught">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('Application', 'zzzzz').shouldThrow()").shouldNotThrow()>
    </it>

    <it should="RETHROW because the exception detail doesn't match">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('Application', 'nonExistantMethod', 'zzzzz')").shouldThrow("Application", "The method nonExistantMethod was not found", "Ensure that the method is defined")>
    </it>

    <it should="PASS because the exception detail doesn't match, but is then caught">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('Application', 'nonExistantMethod', 'zzzzz').shouldThrow()").shouldNotThrow()>
    </it>

    <it should="FAIL because the exception matches the type">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('Application')").shouldThrow("cfspec.fail")>
    </it>

    <it should="FAIL because the exception matches the type and message">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('Application', 'nonExistantMethod')").shouldThrow("cfspec.fail")>
    </it>

    <it should="FAIL because the exception matches the type, message, and details">
      <cfset $eval("$target.nonExistantMethod().shouldNotThrow('Application', 'nonExistantMethod', 'Ensure that the method is defined')").shouldThrow("cfspec.fail")>
    </it>

  </describe>

</describe>
