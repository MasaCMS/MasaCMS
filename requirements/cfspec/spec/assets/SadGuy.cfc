<cfcomponent output="false"><cfscript>

  function isHappy() {
    return false;
  }

  function isInMood(mood, level) {
    return mood == 'sad' and level < 10;
  }

</cfscript></cfcomponent>