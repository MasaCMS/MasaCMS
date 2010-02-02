<cfimport taglib="/cfspec" prefix="">

<describe hint="EvalContext">

  <before>
    <cfset $context = $(createObject("component", "cfspec.lib.EvalContext"))>
    <cfset bindings = {}>
  </before>

  <it should="correctly evaluate a simple self-contained expression">
    <cfset $context.__cfspecEval(bindings, "1+1").shouldEqual(2)>
  </it>

  <it should="correctly evaluate an expression that relies on bound variables">
    <cfset bindings = { x=2, y=3, z=10 }>
    <cfset $context.__cfspecEval(bindings, "(x+y)*z").shouldEqual(50)>
  </it>

  <it should="save a bound variable back to the current context if it's changed by the expression">
    <cfset bindings.x = 2>
    <cfset $context.__cfspecEval(bindings, "x=x+1")>
    <cfset $(bindings.x).shouldEqual(3)>
  </it>

  <it should="save a new variable back to the current context if it's created by the expression">
    <cfset $context.__cfspecEval(bindings, "foo='bar'")>
    <cfset $(bindings.foo).shouldEqual("bar")>
  </it>

  <it should="not see a variable not passed as part of the binding">
    <cfset foo = "bar">
    <cfset $context.__cfspecEval(bindings, "foo").shouldThrow("Expression", "foo")>
  </it>

  <it should="not see any variables except '__cfspecEval' & 'this'">
    <cfset $context.__cfspecEval(bindings, "structCount(variables)").shouldEqual(2)>
  </it>

</describe>
