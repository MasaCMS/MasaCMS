component extends="mura.bean.bean" hint="This provides content display interval functionality" {

    property name="type" datatype="string" default="daily";
    property name="every" datatype="integer" default="1";
    property name="repeats" datatype="integer" default="1";
    property name="allDay" datatype="integer" default="1";
    property name="end" datatype="string" default="";
    property name="endOn" datatype="date";
    property name="endAfter" datatype="integer" default="1";
    property name="daysofweek" datatype="string" default="";
    property name="detectConflicts" datatype="integer" default="0";
    property name="detectSpan" datatype="integer" default="12";
    property name="timezone" datatype="string";

    function init(){
            super.init(argumentCollection=arguments);
            set('timezone',CreateObject("java", "java.util.TimeZone").getDefault().getID());
            return this;
    }

    function setContent(content){
        variables.content=arguments.content;
        return this;
    }

    function save(){
        variables.content.setDisplayInterval(this);
        return this;
    }

    function type(type){
        set('type',arguments.type);
        return this;
    }

    function repeats(repeats){
        if(isBoolean(arguments.repeats)){
            if(arguments.repeats){
                set('repeats',1);
            } else {
                set('repeats',0);
            }
        } else {
            set('repeats',1);
            set('type',arguments.repeats);
        }
        return repeats;
    }

    function every(every){
        set('every',arguments.every);
        return this;
    }

    function allDay(allDay){
        if(arguments.allDay){
            set('allDay',1);
        } else {
            set('allDay',0);
        }

        return this;
    }

    function endOn(endOn){
        set('end','on');
        set('endOn',arguments.endOn);
        return this;
    }

    function setEndOn(endOn){
        variables.instance.endOn=parseDateArg(arguments.endOn);
        return this;
    }

    function endAfter(endAfter){
        set('end','after');
        set('endafter',arguments.endAfter);
        return this;

    }

    function daysofweek(daysofweek){
        set('daysofweek',arguments.daysofweek);
        return this;
    }

    function detectConflicts(detectConflicts){
        if(arguments.detectConflicts){
            set('detectConflicts',1);
        } else {
            set('detectConflicts',0);
        }
            return this;
        }

    function detectSpan(detectSpan){
        set('detectSpan',arguments.detectSpan);
        return this;
    }

    function timezone(timezone){
        set('timezone',arguments.timezone);
        return this;
    }

}
