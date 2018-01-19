component extends="mura.bean.beanORM" table="tentity" entityname="entity" orderby="name"{

  property name="entityid" fieldtype="id";
  property name="name" displayName="Name" fieldtype="index" datatype="varchar" length=250;
  property name="displayName" datatype="varchar" length=250 listview=true displayname="name";
  property name="dynamic" datatype="int" default="0";
  property name="scaffold" datatype="int" default="0";
  property name="bundleable" datatype="int" default="0";
  property name="code" datatype="longtext";
  property name="path" datatype="text";
  property name="created" fieldtype="index" datatype="datetime";
	property name="lastupdate" fieldtype="index" datatype="datetime";

  function save(){
    if(!len(variables.instance.displayName)){
      variables.instance.displayName=variables.instance.name;
    }

    super.save();
  }

  function setDynamic(dynamic){
    if(isBoolean(arguments.dynamic)){
      if(arguments.dynamic){
        variables.instance.dynamic=1;
      } else {
        variables.instance.dynamic=0;
      }
    }

    return this;
  }

  function getDynamic(){
    return variables.instance.dynamic;
  }

  function setScaffold(scaffold){
    if(isBoolean(arguments.scaffold)){
      if(arguments.scaffold){
        variables.instance.scaffold=1;
      } else {
        variables.instance.scaffold=0;
      }
    }

    return this;
  }

  function getScaffold(){
    return variables.instance.scaffold;
  }

  function setBundleable(bundleable){
    if(isBoolean(arguments.bundleable)){
      if(arguments.bundleable){
        variables.instance.bundleable=1;
      } else {
        variables.instance.bundleable=0;
      }
    }

    return this;
  }

  function getBundleable(){
    return variables.instance.bundleable;
  }

}
