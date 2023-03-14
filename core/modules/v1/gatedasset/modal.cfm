<cfif len(objectparams.formid)>
	<cfset local.formBean = $.getBean('content').loadBy( contentid=objectparams.formid ) />
	<cfset $.event('formBean',local.formBean)>
	<cfset variables.formOutput=application.pluginManager.renderEvent("onForm#local.formBean.getSubType()#BodyRender",variables.event)>
	<cfset safesubtype=ReReplace(local.formBean.getSubType(), "[^a-zA-Z0-9_]", "", "ALL")>
	<cfoutput>
	<cfif isJSON( local.formBean.getBody())>
		<cfset objectparams['objectid']=local.formBean.getContentID()>
		<cfset local.formJSON = deserializeJSON( local.formBean.getBody() )>
		<cfscript>
		objectParams['render'] = "client";
		objectParams['async'] = "true";
		objectParams['template'] = "form";

		objectParams.def=serializeJSON(local.formJSON);
	 	objectParams.label="";
		objectParams.filename=local.formBean.get('filename');
		objectParams.name=local.formBean.get('title');
		objectParams.responsemessage=local.formBean.get('responseMessage');

		objectParams['render'] = "client";
		objectParams['async'] = "true";
		objectParams['template'] = "form";
		</cfscript>

		<cfif len($.event('saveform'))>
			<cfset $.event('fields','')>

				<cfset objectParams.errors=$.getBean('dataCollectionBean')
					.set($.event().getAllValues())
					.submit($).getErrors()>

				<cfif not structCount(objectParams.errors)>
					<cfset $.announceEvent('onGatedAssetSuccess',$)>

					<cfset objectParams.responsemessage=$.renderEvent(eventName="onFormSubmitResponseRender",objectid=local.formBean.getContentID())>

					<cfif not len(objectParams.responsemessage)>
						<cfset objectParams.responsemessage=$.renderEvent(eventName="onSubmitResponseRender",objectid=local.formBean.getContentID())>
					</cfif>

					<cfif len($.event('redirect_url'))>
						<cfset $.event('redirect_url',variables.$.getBean('utility').sanitizeHref($.event('redirect_url')))>
						<cfif request.muraFrontEndRequest>
							<cflocation addtoken="false" url="#$.event('redirect_url')#">
						<cfelse>
							<cfset request.muraJSONRedirectURL=$.event('redirect_url')>
						</cfif>
					</cfif>

					<cfif not len(objectParams.responsemessage)>
						<cfset var responseMsg = objectParams.posttext>
						<cfset responseMsg = responseMsg & '<div><a id="action" class="btn btn-primary" href=' & objectParams.url & '>' & objectParams.buttonlabel & '</a></div>'>
						<cfset objectParams.responsemessage=responseMsg>
					</cfif>
				</cfif>

				<cfloop collection="#objectParams#" item="local.param">
					<cfif listLast(local.param,'_') eq 'attachment' and not isValid('uuid',objectParams[local.param])>
						<cfset structDelete(objectParams,local.param)>
					</cfif>
				</cfloop>
		<cfelseif len($.event('validateform'))>
			<cfparam name="objectparams.fields" default="">
				<cfset objectParams.errors=$.getBean('dataCollectionBean')
				.set($.event().getAllValues())
				.validate($,$.event('fields')).getErrors()>
		<cfelseif request.muraApiRequest>		
			<cfscript>
				if(not arguments.RenderingAsRegion){
					if(isdefined('local.formJSON.form.fields')) {
						for(b in local.formJSON.form.fields) {
							field=local.formJSON.form.fields[b];
							if(structKeyExists(field,'value')) {
								local.formJSON.form.fields[b].value=$.setDynamicContent(field.value);
							}

							if(isDefined('field.fieldtype.isdata') && field.fieldtype.isdata==1){
								local.formJSON.datasets['#field.datasetid#']=$.getBean('formBuilderManager').processDataset( $, local.formJSON.datasets['#field.datasetid#'] );
							}
						}
					}

					request.cffpJS=true;

					objectParams['def']=serializeJSON(local.formJSON);
					objectParams['ishuman']=$.dspObject_Include(thefile='form/dsp_form_protect.cfm');
				}

				if(!this.layoutmanager && local.formBean.getDisplayTitle() > 0){
					objectParams['label']=local.formBean.get('title');
				}

				objectParams['filename']=local.formBean.get('filename');
				objectParams['name']="local.formBean.get('title')";
				objectParams['responsemessage']=local.formBean.get('responseMessage');
			</cfscript>
		</cfif>
	<cfelse>
		objectParams['render'] = "server";
	</cfif>
	AAAAAAAAAAAA
	</cfoutput>
<cfelse>
	<cfoutput>
BBBBBBBBBBBBBBBBB
	#application.rbFactory.getKeyValue(session.rb,'modules.gatedasset.noformselected')#
</cfoutput>
</cfif>