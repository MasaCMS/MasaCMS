<cfsilent>
<cfscript>
/**
 * Serialize native ColdFusion objects (simple values, arrays, structures, queries) into JSON format
 * http://json.org/
 * http://jehiah.com/projects/cfjson/
 *
 * @param object Native data to be serialized
 * @return Returns string with serialized data.
 * @author Jehiah Czebotar (jehiah@gmail.com)
 * @version 1.2, August 20, 2005
 */

function jsonencode(arg)
{
    var i=0;
	var o="";
	var u="";
	var v="";
	var z="";
	var r="";

	if (isarray(arg))
	{
		o="";
		for (i=1;i lte arraylen(arg);i=i+1){
			try{
				v = jsonencode(arg[i]);
				if (o neq ""){
					o = o & ',';
				}
				o = o & v;
			}
			catch(Any ex){
				o=o;
			}
		}
		return '['& o &']';
	}
	if (isstruct(arg))
	{
		o = '';
		if (structisempty(arg)){
			return "{null}";
		}
		z = StructKeyArray(arg);
		for (i=1;i lte arrayLen(z);i=i+1){
			try{
			v = jsonencode(evaluate("arg."&z[i]));
			}catch(Any err){WriteOutput("caught an error when trying to evaluate z[i] where i="& i &" it evals to "  & z[i] );}
			if (o neq ""){
				o = o & ",";
			}
			o = o & '"'& lcase(z[i]) & '":' & v;
		} 
		return '{' & o & '}';
	}
	if (isobject(arg)){
        return "unknown";
	}
	if (issimplevalue(arg) and isnumeric(arg)){
		return ToString(arg);
	}
	if (issimplevalue(arg)){
		return '"' & JSStringFormat(ToString(arg)) & '"';
	}
	if (IsQuery(arg)){
		o = o & '"RECORDCOUNT":' & arg.recordcount;
		o = o & ',"COLUMNLIST":'&jsonencode(arg.columnlist);
		// do the data [].column
		o = o & ',"DATA":{';
		// loop through the columns
		for (i=1;i lte listlen(arg.columnlist);i=i+1){
			v = '';
			// loop throw the records
			for (z=1;z lte arg.recordcount;z=z+1){
				if (v neq ""){
					v =v  & ",";
				}
				// encode this cell
				v = v & jsonencode(evaluate("arg." & listgetat(arg.columnlist,i) & "["& z & "]"));
			}
			// put this column in the output
			if (i neq 1){
				o = o & ",";
			}
			o = o & '"' & listgetat(arg.columnlist,i) & '":[' & v & ']';
		}
		// close our data section
		o = o & '}';
		// put the query struct in the output
		return '{' & o & '}';
	}
	return "unknown";
}
</cfscript></cfsilent>
<cfsetting enablecfoutputonly="yes">
<cfoutput>#jsonencode(fusebox.layout)#</cfoutput><cfsetting enablecfoutputonly="no">

