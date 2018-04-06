/*  This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
/**
 * This provides plugin config xml custom settings functionality
 */
component extends="mura.bean.bean" output="false" hint="This provides plugin config xml custom settings functionality" {
	property name="name" type="string" default="" required="true";
	property name="hint" type="string" default="" required="true";
	property name="type" type="string" default="TextBox" required="true";
	property name="required" type="string" default="false" required="true";
	property name="validation" type="string" default="" required="true";
	property name="regex" type="string" default="" required="true";
	property name="message" type="string" default="" required="true";
	property name="label" type="string" default="" required="true";
	property name="settingValue" type="string" default="" required="true";
	property name="optionList" type="string" default="" required="true";
	property name="optionListLabel" type="string" default="" required="true";

	public function init() output=false {
		super.init(argumentCollection=arguments);
		variables.instance.name="";
		variables.instance.hint="";
		variables.instance.type="TextBox";
		variables.instance.required="false";
		variables.instance.validation="";
		variables.instance.regex="";
		variables.instance.message="";
		variables.instance.label="";
		variables.instance.settingValue="";
		variables.instance.optionList="";
		variables.instance.optionLabelList="";
		return this;
	}

	public function setConfigBean(configBean) output=false {
		variables.configBean=arguments.configBean;
		return this;
	}

	public function set(theXML, moduleID) output=false {
		var i="";

		for(i in ListToArray("name,type,hint,required,validation,regex,message,label,optionlist,optionlabellist")){
			if(structKeyExists(arguments.theXML,i)){
				evaluate("set#i#(arguments.theXML[i].xmlText)");
			} else if (structKeyExists(arguments.theXML.xmlAttributes,i)){
				evaluate("set#i#(arguments.theXML.xmlAttributes[i])");
			}
		}

		setModuleID(arguments.moduleID);
		loadSettingValue();
		return this;
	}

	public function getName() output=false {
		return variables.instance.name;
	}

	public function setName(String name) output=false {
		variables.instance.name = trim(arguments.name);
	}

	public function getModuleID() output=false {
		return variables.instance.ModuleID;
	}

	public function setModuleID(String ModuleID) output=false {
		variables.instance.ModuleID = trim(arguments.ModuleID);
	}

	public function getHint() output=false {
		return variables.instance.Hint;
	}

	public function setHint(String Hint) output=false {
		variables.instance.Hint = trim(arguments.Hint);
	}

	public function getType() output=false {
		return variables.instance.Type;
	}

	public function setType(String Type) output=false {
		variables.instance.Type = trim(arguments.Type);
	}

	public function getRequired() output=false {
		return variables.instance.Required;
	}

	public function setRequired(String Required) output=false {
		variables.instance.Required = trim(arguments.Required);
	}

	public function getValidation() output=false {
		return variables.instance.validation;
	}

	public function setValidation(String validation) output=false {
		variables.instance.validation = trim(arguments.validation);
	}

	public function getRegex() output=false {
		return variables.instance.Regex;
	}

	public function setRegex(String Regex) output=false {
		variables.instance.Regex = trim(arguments.Regex);
	}

	public function getMessage() output=false {
		return variables.instance.Message;
	}

	public function setMessage(String Message) output=false {
		variables.instance.Message = trim(arguments.Message);
	}

	public function getLabel() output=false {
		if ( len(variables.instance.Label) ) {
			return variables.instance.Label;
		} else {
			return variables.instance.name;
		}
	}

	public function setLabel(String Label) output=false {
		variables.instance.Label = trim(arguments.Label);
	}

	public function getSettingValue() output=false {
		return variables.instance.SettingValue;
	}

	public function setSettingValue(String SettingValue) output=false {
		variables.instance.SettingValue = trim(arguments.SettingValue);
	}

	public function getOptionList() output=false {
		return variables.instance.optionList;
	}

	public function setOptionList(String OptionList) output=false {
		variables.instance.OptionList = trim(arguments.OptionList);
	}

	public function getOptionLabelList() output=false {
		return variables.instance.OptionLabelList;
	}

	public function setOptionLabelList(String OptionLabelList) output=false {
		variables.instance.OptionLabelList = trim(arguments.OptionLabelList);
	}

	public function renderSetting(required theValue="useMuraDefault") output=false {
		var renderValue= arguments.theValue;
		var optionValue= "";
		var str="";
		var key=getName();
		var o=0;

		switch ( getType() ) {
			case  "Text":
			case  "TextBox":
				savecontent variable="str" {
						writeOutput("<input type=""text"" name=""#key#"" id=""#key#"" label=""#XMLFormat(getlabel())#"" value=""#HTMLEditFormat(renderValue)#"" required=""#getRequired()#""");
						if ( len(getvalidation()) ) {

							writeOutput("validate=""#getValidation()#""");
						}
						if ( getvalidation() == "Regex" ) {

							writeOutput("regex=""#getRegex()#""");
						}
						if ( len(getMessage()) ) {

							writeOutput("message=""#XMLFormat(getMessage())#""");
						}

						writeOutput("/>");
				}
				break;
			case  "TextArea":
				savecontent variable="str" {
						writeOutput("<textarea name=""#key#"" id=""#key#"" label=""#XMLFormat(getlabel())#"" required=""#getRequired()#""");
						if ( len(getMessage()) ) {

							writeOutput("message=""#XMLFormat(getMessage())#""");
						}

						writeOutput(">#HTMLEditFormat(renderValue)#</textarea>");
				}
				break;
			case  "Select":
			case  "SelectBox":
			case  "MultiSelectBox":

				savecontent variable="str" {
						writeOutput("<select name=""#key#"" id=""#key#"" label=""#XMLFormat(getlabel())#"" required=""#getRequired()#""");
						if ( len(getMessage()) ) {

							writeOutput("message=""#XMLFormat(getMessage())#""");
						}
						if ( getType() == "MultiSelectBox" ) {

							writeOutput("multiple");
						}

						writeOutput(">");
						if ( listLen(getOptionList(),'^') ) {
							for ( o=1 ; o<=listLen(getOptionList(),'^') ; o++ ) {
								optionValue=listGetAt(getOptionList(),o,'^');

								writeOutput("<option value=""#XMLFormat(optionValue)#""");
								if ( optionValue == renderValue || listFind(renderValue,optionValue) ) {

									writeOutput("selected");
								}

								writeOutput(">");
								if ( len(getOptionLabelList()) ) {

									writeOutput("#listGetAt(getOptionLabelList(),o,'^')#");
								} else {

									writeOutput("#optionValue#");
								}

								writeOutput("</option>");
							}
						}

						writeOutput("</select>");
				}
				break;
			case  "Radio":
			case  "RadioGroup":
				savecontent variable="str" {
						if ( listLen(getOptionList(),'^') ) {
							for ( o=1 ; o<=listLen(getOptionList(),'^') ; o++ ) {
								optionValue=listGetAt(getOptionList(),o,'^');

								writeOutput("<label class=""radio inline""><input type=""radio"" id=""#key#"" name=""#key#"" value=""#XMLFormat(optionValue)#""");
								if ( optionValue == renderValue ) {

									writeOutput("checked");
								}

								writeOutput("/>");
								if ( len(getOptionLabelList()) ) {

									writeOutput("#listGetAt(getOptionLabelList(),o,'^')#");
								} else {

									writeOutput("#optionValue#");
								}

								writeOutput("</label>");
							}

							writeOutput("</select>");
						}
				}
				break;
		}
		return str;
	}

	public function loadSettingValue() output=false {
		var rs="";

		var qs=new Query();
		qs.addParam(name="name",cfsqltype="cf_sql_varchar", value=getName());
		qs.addParam(name="moduleid",cfsqltype="cf_sql_varchar", value=getModuleID());

		rs=qs.execute(sql="select * from tpluginsettings where name= :name and moduleid= :moduleid").getResult();

		setSettingValue(rs.settingValue);
	}

}
