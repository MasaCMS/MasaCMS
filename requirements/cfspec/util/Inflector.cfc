<cfcomponent output="false">

  <cffunction name="init" output="false">
    <cfset $plurals      = createObject("java", "java.util.ArrayList").init()>
    <cfset $singulars    = createObject("java", "java.util.ArrayList").init()>
    <cfset $uncountables = "">

    <cfset __loadDefaultInflections()>

    <cfreturn this>
  </cffunction>

  <cffunction name="plural" returntype="void" access="public" output="false">
    <cfargument name="rule"        type="string" required="true">
    <cfargument name="replacement" type="string" required="true">

    <cfset arrayPrepend($plurals, structCopy(arguments))>
  </cffunction>

  <cffunction name="singular" returntype="void" access="public" output="false">
    <cfargument name="rule"        type="string" required="true">
    <cfargument name="replacement" type="string" required="true">

    <cfset arrayPrepend($singulars, structCopy(arguments))>
  </cffunction>

  <cffunction name="irregular" returntype="void" access="public" output="false">
    <cfargument name="singularWord" type="string" required="true">
    <cfargument name="pluralWord"   type="string" required="true">
    <cfset var singularLeft  = "">
    <cfset var singularRight = "">
    <cfset var pluralLeft    = "">
    <cfset var pluralRight   = "">

    <cfif len(arguments.singularWord) gt 1>
      <cfset singularLeft = left(arguments.singularWord, 1)>
      <cfset singularRight = right(arguments.singularWord, len(arguments.singularWord) - 1)>
    <cfelse>
      <cfset singularLeft = arguments.singularWord>
    </cfif>

    <cfif len(arguments.pluralWord) gt 1>
      <cfset pluralLeft = left(arguments.pluralWord, 1)>
      <cfset pluralRight = right(arguments.pluralWord, len(arguments.pluralWord) - 1)>
    <cfelse>
      <cfset pluralLeft = arguments.pluralWord>
    </cfif>

    <cfset plural("(#singularLeft#)#singularRight#$", "\1#pluralRight#")>
    <cfset singular("(#pluralLeft#)#pluralRight#$", "\1#singularRight#")>
  </cffunction>

  <cffunction name="uncountable" returntype="void" access="public" output="false">
    <cfargument name="words" type="string" required="true">

    <cfset $uncountables = listAppend($uncountables, arguments.words)>
  </cffunction>

  <cffunction name="plurals" returntype="array" access="public" output="false">
    <cfreturn $plurals>
  </cffunction>

  <cffunction name="singulars" returntype="array" access="public" output="false">
    <cfreturn $singulars>
  </cffunction>

  <cffunction name="isUncountable" returntype="boolean" access="public" output="false">
    <cfargument name="word" type="string" required="true">

    <cfreturn listFindNoCase($uncountables, arguments.word)>
  </cffunction>

  <cffunction name="__loadDefaultInflections" returntype="void" access="private" output="false">
    <cfset plural("$", "s")>
    <cfset plural("s$", "s")>
    <cfset plural("(ax|test)is$", "\1es")>
    <cfset plural("(octop|vir)us$", "\1i")>
    <cfset plural("(alias|status)$", "\1es")>
    <cfset plural("(bu)s$", "\1ses")>
    <cfset plural("(buffal|tomat)o$", "\1oes")>
    <cfset plural("([ti])um$", "\1a")>
    <cfset plural("sis$", "ses")>
    <cfset plural("(?:([^f])fe|([lr])f)$", "\1\2ves")>
    <cfset plural("(hive)$", "\1s")>
    <cfset plural("([^aeiouy]|qu)y$", "\1ies")>
    <cfset plural("(x|ch|ss|sh)$", "\1es")>
    <cfset plural("(matr|vert|ind)ix|ex$", "\1ices")>
    <cfset plural("([m|l])ouse$", "\1ice")>
    <cfset plural("^(ox)$", "\1en")>
    <cfset plural("(quiz)$", "\1zes")>

    <cfset singular("s$", "")>
    <cfset singular("(n)ews$", "\1ews")>
    <cfset singular("([ti])a$", "\1um")>
    <cfset singular("((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$", "\1\2sis")>
    <cfset singular("(^analy)ses$", "\1sis")>
    <cfset singular("([^f])ves$", "\1fe")>
    <cfset singular("(hive)s$", "\1")>
    <cfset singular("(tive)s$", "\1")>
    <cfset singular("([lr])ves$", "\1f")>
    <cfset singular("([^aeiouy]|qu)ies$", "\1y")>
    <cfset singular("(s)eries$", "\1eries")>
    <cfset singular("(m)ovies$", "\1ovie")>
    <cfset singular("(x|ch|ss|sh)es$", "\1")>
    <cfset singular("([m|l])ice$", "\1ouse")>
    <cfset singular("(bus)es$", "\1")>
    <cfset singular("(o)es$", "\1")>
    <cfset singular("(shoe)s$", "\1")>
    <cfset singular("(cris|ax|test)es$", "\1is")>
    <cfset singular("(octop|vir)i$", "\1us")>
    <cfset singular("(alias|status)es$", "\1")>
    <cfset singular("^(ox)en", "\1")>
    <cfset singular("(vert|ind)ices$", "\1ex")>
    <cfset singular("(matr)ices$", "\1ix")>
    <cfset singular("(quiz)zes$", "\1")>

    <cfset irregular("person", "people")>
    <cfset irregular("man", "men")>
    <cfset irregular("child", "children")>
    <cfset irregular("sex", "sexes")>
    <cfset irregular("move", "moves")>

    <cfset uncountable("equipment,information,rice,money,species,series,fish,sheep")>
  </cffunction>

  <cffunction name="pluralize" returntype="string" access="public" output="false">
    <cfargument name="word" type="string" required="true">
    <cfset var result = arguments.word>
    <cfset var pairs  = "">
    <cfset var pair   = "">
    <cfset var i      = "">

    <cfif len(trim(arguments.word)) and not isUncountable(arguments.word)>
      <cfset pairs = plurals()>
      <cfloop index="i" from="1" to="#arrayLen(pairs)#">
        <cfset pair = pairs[i]>
        <cfif reFindNoCase(pair.rule, arguments.word)>
          <cfset result = reReplaceNoCase(arguments.word, pair.rule, pair.replacement)>
          <cfbreak>
        </cfif>
      </cfloop>
    </cfif>

    <cfreturn result>
  </cffunction>

</cfcomponent>