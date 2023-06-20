	/*

This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
component output="false" accessors="true" extends="mura.baseobject" hint="This provides validation to entities" {

	public struct function getValidationsByContext(required any object, string context="") {

		var contextValidations = {};
		var validationStruct = arguments.object.getValidations();

		// Loop over each proeprty in the validation struct looking for rule structures
		for(var property in validationStruct.properties) {

		// For each array full of rules for the property, loop over them and check for the context
			for(var r=1; r<=arrayLen(validationStruct.properties[property]); r++) {

			var rule = validationStruct.properties[property][r];

			// Verify that either context doesn't exist, or that the context passed in is in the list of contexts for this rule
			if(!structKeyExists(rule, "contexts") || listFindNoCase(rule.contexts, arguments.context)) {

					if(!structKeyExists(contextValidations, property)) {
						contextValidations[ property ] = [];
					}

					for(var constraint in rule) {
						if(constraint != "contexts" && constraint != "conditions") {
							var constraintDetails = {
								constraintType=constraint,
								constraintValue=rule[ constraint ]
							};
							if(structKeyExists(rule, "conditions")) {
								constraintDetails.conditions = rule.conditions;
							}
							if(structKeyExists(rule, "rbkey") and len(rule.rbkey)) {
								constraintDetails.rbkey = rule.rbkey;
							} else if(structKeyExists(rule, "message") and len(rule.message)) {
								constraintDetails.message = rule.message;
							}

							arrayAppend(contextValidations[ property ], constraintDetails);
						}
					}
				}
			}
		}

		return contextValidations;
	}



	public boolean function getConditionsMeetFlag( required any object, required string conditions) {

		var validationStruct = arguments.object.getValidations();

		var conditionsArray = listToArray(arguments.conditions);

		// Loop over each condition to check if it is true
		for(var x=1; x<=arrayLen(conditionsArray); x++) {

			var conditionName = conditionsArray[x];

			// Make sure that the condition is defined in the meta data
			if(structKeyExists(validationStruct, "conditions") && structKeyExists(validationStruct.conditions, conditionName)) {

				var allConditionConstraintsMeet = true;

				// Loop over each propertyIdentifier for this condition
				for(var conditionPropertyIdentifier in validationStruct.conditions[ conditionName ]) {

					// Loop over each constraint for the property identifier to validate the constraint
					for(var constraint in validationStruct.conditions[ conditionName ][ conditionPropertyIdentifier ]) {
						if(structKeyExists(variables, "validate_#constraint#") && !invokeMethod("validate_#constraint#", {object=arguments.object, propertyIdentifier=conditionPropertyIdentifier, constraintValue=validationStruct.conditions[ conditionName ][ conditionPropertyIdentifier ][ constraint ]})) {
							allConditionConstraintsMeet = false;
						}
					}
				}

				// If all constraints of this condition are meet, then we no that one condition is meet for this rule.
				if( allConditionConstraintsMeet ) {
					return true;
				}
			}
		}

		return false;
	}

	public any function getPopulatedPropertyValidationContext(required any object, required string propertyName, string context="") {

		var validationStruct = arguments.object.getValidations();

		if(structKeyExists(validationStruct, "populatedPropertyValidation") && structKeyExists(validationStruct.populatedPropertyValidation, arguments.propertyName)) {
			for(var v=1; v <= arrayLen(validationStruct.populatedPropertyValidation[arguments.propertyName]); v++) {
				var conditionsMeet = true;
				if(structKeyExists(validationStruct.populatedPropertyValidation[arguments.propertyName][v], "conditions")) {
					conditionsMeet = getConditionsMeetFlag(object=arguments.object, conditions=validationStruct.populatedPropertyValidation[arguments.propertyName][v].conditions);
				}
				if(conditionsMeet) {
					return validationStruct.populatedPropertyValidation[arguments.propertyName][v].validate;
				}
			}

		}

		return arguments.context;
	}

	public any function validate(required any object, string context="") {

		var errorsStruct={};

		// If the context was 'false' then we don't do any validation
		if(!isBoolean(arguments.context) || arguments.context) {
			// Get the valdiations for this context
			var contextValidations = getValidationsByContext(object=arguments.object, context=arguments.context);

			//writeDump(var=contextValidations,abort=true);

			// Loop over each property in the validations for this context
			for(var propertyIdentifier in contextValidations) {

				// First make sure that the proerty exists
				//if(arguments.object.hasProperty( propertyIdentifier )) {
					var requiredAttrs={};

					// Loop over each of the constraints for this given property looking for required attributes
					for(var c=1; c<=arrayLen(contextValidations[ propertyIdentifier ]); c++) {
						if(contextValidations[ propertyIdentifier ][c].constraintType == 'required'){
							requiredAttrs[propertyIdentifier]=true;
						}
					}

					// Loop over each of the constraints for this given property
					for(var c=1; c<=arrayLen(contextValidations[ propertyIdentifier ]); c++) {

						// Check that one of the conditions were meet if there were conditions for this constraint
						var conditionMeet = true;
						if(structKeyExists(contextValidations[ propertyIdentifier ][c], "conditions")) {
							conditionMeet = getConditionsMeetFlag( object=arguments.object, conditions=contextValidations[ propertyIdentifier ][ c ].conditions );
						}

						//Only validate if the property has a value when not required
						if(contextValidations[ propertyIdentifier ][c].constraintType != 'required'
							&& isSimpleValue(arguments.object.getValue(propertyIdentifier))
							&& !len(arguments.object.getValue(propertyIdentifier))
							&& !structKeyExists(requiredAttrs,propertyIdentifier)){
							conditionMeet=false;
						}

						// Now if a condition was meet we can actually test the individual validation rule
						if(conditionMeet) {
							validateConstraint(object=arguments.object, propertyIdentifier=propertyIdentifier, constraintDetails=contextValidations[ propertyIdentifier ][c], errorsStruct=errorsStruct, context=arguments.context);
						}
					}
				//}
			}
		}

		return errorsStruct;
	}


	public any function validateConstraint(required any object, required string propertyIdentifier, required struct constraintDetails, required any errorsStruct, required string context) {
		if(structKeyExists(variables, "validate_#arguments.constraintDetails.constraintType#")) {

			var isValid = invokeMethod("validate_#arguments.constraintDetails.constraintType#", {object=arguments.object, propertyIdentifier=arguments.propertyIdentifier, constraintValue=arguments.constraintDetails.constraintValue});

			if(!isValid) {
				if(structKeyExists(arguments.constraintDetails,'rbkey')){
					arguments.errorsStruct[arguments.propertyIdentifier]=getBean('settingsManager').getSite(arguments.object.getSiteID()).getRBFactory().getKey(arguments.constraintDetails.rbkey);
				} else if(structKeyExists(arguments.constraintDetails,'message')){
					arguments.errorsStruct[arguments.propertyIdentifier]=arguments.constraintDetails.message;
				} else {
					arguments.errorsStruct[arguments.propertyIdentifier]="The property named '#arguments.propertyIdentifier#' is not valid";
				}

				//writeDump(var=constraintDetails,abort=true);
			}
		}

	}


	// ================================== VALIDATION CONSTRAINT LOGIC ===========================================

	public boolean function validate_required(required any object, required string propertyIdentifier, boolean constraintValue=true) {


		if(constraintValue){
			var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
			if(!isNull(propertyValue) && (isObject(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue)) || (isStruct(propertyValue) && structCount(propertyValue)) || (isSimpleValue(propertyValue) && len(propertyValue)) || isNumeric(propertyValue) )) {
				return true;
			}

			return false;
		}

		return true;
	}

	public boolean function validate_dataType(required any object, required string propertyIdentifier, required any constraintValue) {

		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier, arguments.constraintValue);
		
		//Translate from db types to CF types
		if(arguments.constraintValue=='datetime'){
			arguments.constraintValue='date';
		} else if (listFindNoCase('varchar,char,text,longtext,mediumtext,clob,nvarchar',arguments.constraintValue)){
			arguments.constraintValue='string';
		} else if (listFindNoCase('tinyint,int,smallint',arguments.constraintValue)){
			arguments.constraintValue='integer';
		} else if (arguments.constraintValue=='double'){
			arguments.constraintValue='float';
		}

		if(listFindNoCase("any,array,binary,boolean,component,creditCard,date,time,email,eurodate,float,numeric,guid,integer,query,range,ssn,social_security_number,string,telephone,url,uuid,usdate,zipcode",arguments.constraintValue)) {
			if(isNull(propertyValue) || isValid(arguments.constraintValue, propertyValue) || (arguments.constraintValue == 'Date' && propertyValue == '')) {
				return true;
			} else {
				return false;
			}
		} else if (arguments.constraintValue == 'json'){
			if(isNull(propertyValue)) {
				return true;
			} else if(!isJSON(propertyValue)) {
				return false;
			} else {
				var val=deserializeJSON(propertyValue);
				if(isStruct(val) || isArray(val)) {
					return true;
				}
				return false;
			}
		} 

		return true;
	}

	public boolean function validate_format(required any object, required string propertyIdentifier, required any constraintValue) {

		return validate_dataType(argumentCollection=arguments);
	}

	public boolean function validate_minValue(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}

	public boolean function validate_maxValue(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}

	public boolean function validate_minLength(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(propertyValue) >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}

	public boolean function validate_maxLength(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(propertyValue) <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}

	public boolean function validate_minCollection(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) >= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) >= arguments.constraintValue)) {
			return true;
		}
		return false;
	}

	public boolean function validate_maxCollection(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) <= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) <= arguments.constraintValue)) {
			return true;
		}
		return false;
	}

	public boolean function validate_minList(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if((!isNull(propertyValue) && isSimpleValue(propertyValue) && listLen(propertyValue) >= arguments.constraintValue) || (isNull(propertyValue) && arguments.constraintValue == 0)) {
			return true;
		}
		return false;
	}

	public boolean function validate_maxList(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if((!isNull(propertyValue) && isSimpleValue(propertyValue) && listLen(propertyValue) <= arguments.constraintValue) || (isNull(propertyValue) && arguments.constraintValue == 0)) {
			return true;
		}
		return false;
	}

	public boolean function validate_method(required any object, required string propertyIdentifier, required string constraintValue) {
		// not safe for public validation
		//return arguments.object.invokeMethod(arguments.constraintValue);
	}

	public boolean function validate_lte(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(!isNull(propertyValue) && !isNull(arguments.constraintValue) && propertyValue <= arguments.constraintValue) {
			return true;
		}
		return false;
	}

	public boolean function validate_lt(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(!isNull(propertyValue) && !isNull(arguments.constraintValue) && propertyValue < arguments.constraintValue) {
			return true;
		}
		return false;
	}

	public boolean function validate_gte(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(!isNull(propertyValue) && !isNull(arguments.constraintValue) && propertyValue >= arguments.constraintValue) {
			return true;
		}
		return false;
	}

	public boolean function validate_gt(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(!isNull(propertyValue) && !isNull(arguments.constraintValue) && propertyValue > arguments.constraintValue) {
			return true;
		}
		return false;
	}

	public boolean function validate_eq(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(!isNull(propertyValue) && !isNull(arguments.constraintValue) && propertyValue == arguments.constraintValue) {
			return true;
		}
		return false;
	}

	public boolean function validate_neq(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(!isNull(propertyValue) && !isNull(arguments.constraintValue) && propertyValue != arguments.constraintValue) {
			return true;
		}
		return false;
	}

	public function getValueForValidation(required any object, required string propertyIdentifier , constraintValue='') {
		var validationContextId = arguments.object.get('validationContextId');
		if(len(validationContextId)){
			if(isDefined('request.muraValidationContext') 
				&& structKeyExists(request.muraValidationContext,'#validationContextId#')
				&& structKeyExists(request.muraValidationContext['#validationContextId#'],'#arguments.propertyIdentifier#')){

				if(arguments.constraintValue=='date'){
					return arguments.object.parseDateArg(request.muraValidationContext['#validationContextId#'][arguments.propertyIdentifier]);
				} else {
					return request.muraValidationContext['#validationContextId#'][arguments.propertyIdentifier];
				}
			} else if (arguments.object.hasProperty(arguments.propertyIdentifier)){
				return arguments.object.get(arguments.propertyIdentifier);
			} else {
				return '';
			}
		} else {
			return arguments.object.get(arguments.propertyIdentifier);
		}	
	}

	public boolean function validate_inList(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		if(!isNull(propertyValue) && listFindNoCase(arguments.constraintValue, propertyValue)) {
			return true;
		}
		return false;
	}

	public boolean function validate_regex(required any object, required string propertyIdentifier, required string constraintValue) {
		var fileManager=getBean('fileManager');
		if(fileManager.isPostedFile(arguments.propertyIdentifier)){
			var propertyValue = fileManager.getPostedClientFileName(arguments.propertyIdentifier);
		} else {
			var propertyValue = getValueForValidation(arguments.object,arguments.propertyIdentifier);
		}

		if(isNull(propertyValue) || isValid("regex", propertyValue, arguments.constraintValue)) {
			return true;
		}
		return false;
	}

}
