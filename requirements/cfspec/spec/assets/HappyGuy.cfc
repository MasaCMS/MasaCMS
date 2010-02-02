<cfcomponent output="false"><cfscript>

  function isHappy() {
    return true;
  }
  
  function isInMood(mood, level) {
    return mood == 'happy' and level >= 10;
  }

</cfscript></cfcomponent>