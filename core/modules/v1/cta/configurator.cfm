<cfsilent>
    <cfparam name="objectparams.scroll" default="0">
    <cfparam name="objectparams.delay" default="0">
    <cfparam name="objectparams.displays" default="0">
    <cfparam name="objectparams.visits" default="0">
    <cfparam name="objectparams.storage" default="session">
    <cfparam name="objectparams.resetinterval" default="month">
    <cfparam name="objectparams.resetqty" default="1">
    <cfparam name="objectparams.componentid" default="">
    <cfparam name="objectparams.formid" default="">

    <cfparam name="rc.isnew" default="false">

    <cfparam name="objectparams.type" default="drawer">
    <cfparam name="objectparams.anchorx" default="center">
    <cfparam name="objectparams.anchory" default="center">
    <cfparam name="objectparams.animate" default="ttb">
    <cfparam name="objectparams.animatespeed" default="fast">
    <cfparam name="objectparams.width" default="md">
    <cfparam name="objectparams.statsid" default="#createUUID()#">
    <cfparam name="objectparams.instanceclass" default="">

    <cfif not isnumeric(objectparams.scroll)>
        <cfset objectparams.scroll=0>
    </cfif>

    <cfif not isnumeric(objectparams.delay)>
        <cfset objectparams.delay=0>
    </cfif>

    <cfif not isnumeric(objectparams.displays)>
        <cfset objectparams.displays=0>
    </cfif>

    <cfif not isnumeric(objectparams.visits)>
        <cfset objectparams.visits=0>
    </cfif>

    <cfif not isnumeric(objectparams.resetqty)>
        <cfset objectparams.resetqty=1>
    </cfif>

    <cfif isDefined('objectparams.objectid') and isValid('uuid',objectparams.objectid)>
        <cfset objectUpdateType= $.getBean('content').loadBy(contentid=objectparams.objectid).getType()>
        <cfif objectUpdateType eq 'Component'>
            <cfset objectparams.componentid=objectparams.objectid>
        <cfelseif objectUpdateType eq 'Form'>
            <cfset objectparams.formid=objectparams.formid>
        </cfif>
        <cfset objectparams.objectid=''>
    </cfif>

	<cfset rc.rsComponents = application.contentManager.getComponentType(rc.siteid, 'Component')/>
	<cfset hasComponentModulePerm=rc.configuratormode neq 'backend' and rc.$.getBean('permUtility').getModulePerm('00000000000000000000000000000000003',rc.siteid)>

    <cfset rc.rsForms = application.contentManager.getComponentType(rc.siteid, 'Form')/>
    <cfset hasFormModulePerm=rc.configuratormode neq 'backend' and rc.$.getBean('permUtility').getModulePerm('00000000000000000000000000000000004',rc.siteid)>
</cfsilent>

<style>

.mura .mura-panel-group {
	clear: both;
	margin-bottom: 5px;
	margin-left: -18px;
	margin-right: -34px;
}

.mura body.configurator-wrapper #configuratorContainer .mura-panel-group .mura-panel {
	border: none;
	margin: 0;
	margin-bottom: 2px;
}

.mura .mura-panel-heading {
	background-color: #565656;
	padding: 0;
}

.mura .mura-panel-heading:hover {
	background-color: #6f6f6f;
	cursor: pointer;
}

.mura .mura-panel-title {
	color: #fff;
	font-size: 13px;
}

.mura .mura-panel-title a {
	display: block;
	color: inherit;
	padding: 10px 16px;
}

.mura .mura-panel-title a:hover,
.mura .mura-panel-title a:active,
.mura .mura-panel-title a:focus {
	color: inherit !important;
}

.mura body.configurator-wrapper #configuratorContainer .mura-panel-group .mura-panel .mura-panel-body {
	padding-top: 18px;
	padding-left: 18px;
	padding-right: 34px;
	margin-bottom: 2px;
}

</style>

<cfoutput>
<div class="mura-layout-row">


    <div class="mura-panel-group" id="configurator-panels" role="tablist" aria-multiselectable="true">

      <!--- panel 1 --->
      <div class="mura-panel panel">
        <div class="mura-panel-heading" role="tab" id="heading-1">
          <h4 class="mura-panel-title">
            <a role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-1" aria-expanded="true" aria-controls="panel-1">
              #application.rbFactory.getKeyValue(session.rb,'cta.what')#
            </a>
          </h4>
        </div>
        <div id="panel-1" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading-1">
          <div class="mura-panel-body">
            <div class="mura-control-group">
              <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectcomponent')#</label>
                    <select id="componentid" name="componentid" class="objectParam">
                        <option value="notconfigured">
                            #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectcomponent')#
                        </option>
                        <cfloop query="rc.rsComponents">
                            <cfset title=rc.rsComponents.menutitle>
                            <option <cfif objectparams.componentid eq rc.rsComponents.contentid>selected </cfif>title="#esapiEncode('html_attr',title)#" value="#rc.rsComponents.contentid#">
                                #esapiEncode('html',title)#
                            </option>
                        </cfloop>
                    </select>
                    <cfif hasComponentModulePerm>
                        <button class="btn" id="componentEditBtn"><i class="mi-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#</button>
                    </cfif>
                </div>
                <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectform')#</label>
                    <select id="formid" name="formid" class="objectParam">
                        <option value="notconfigured">
                            #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectform')#
                        </option>
                        <cfloop query="rc.rsForms">
                            <cfset title=rc.rsForms.menutitle>
                            <option <cfif objectparams.formid eq rc.rsForms.contentid>selected </cfif>title="#esapiEncode('html_attr',title)#" value="#rc.rsForms.contentid#">
                                #esapiEncode('html',title)#
                            </option>
                        </cfloop>
                    </select>
                    <cfif hasFormModulePerm>
                        <button class="btn" id="formEditBtn"><i class="mi-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#</button>
                    </cfif>
                </div>
            </div>
          </div>
        </div>
      </div> <!--- /end panel 1 --->

      <!--- panel 2 --->
      <div class="mura-panel panel">
        <div class="mura-panel-heading" role="tab" id="heading-2">
          <h4 class="mura-panel-title">
            <a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-2" aria-expanded="false" aria-controls="panel-2">
              #application.rbFactory.getKeyValue(session.rb,'cta.when')#
            </a>
          </h4>
        </div>
        <div id="panel-2" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-2">
          <div class="mura-panel-body">
            <div class="mura-control-group">
                <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.visitsbeforectaappears')#</label>
                    <input name="visits" type="number" class="objectParam" value="#esapiEncode('html_attr',objectparams.visits)#">
                </div>
                <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.ctaappearsforxvisits')#</label>
                    <input name="displays" type="number" class="objectParam" value="#esapiEncode('html_attr',objectparams.displays)#">
                </div>
                <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.displayctaafterxseconds')#</label>
                    <input name="delay" type="number" class="objectParam" value="#esapiEncode('html_attr',objectparams.delay)#">
                </div>
                <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.scroldepthbeforectaappears')# (<span id="scrolllabel"></span>)</label>
                    <input name="scroll" id="scroll" min="0" max="100" step="5" type="range" class="objectParam" value="#esapiEncode('html_attr',objectparams.scroll)#"><br/>
                </div>
                <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.ctawillrestartafter')#</label>
                    <select name="resetinterval" class="objectParam">
                        <cfset options=['Session','Day','Week','Month']>
                        <cfloop array="#options#" item="option">
                            <option value="#lcase(option)#"<cfif option eq objectparams.resetinterval> selected</cfif>>#option#</option>
                        </cfloop>
                    </select>
                </div>
            </div>
          </div>
        </div>
      </div> <!--- /end panel 2 --->

      <!--- panel 3 --->
      <div class="mura-panel panel">
        <div class="mura-panel-heading" role="tab" id="heading-3">
          <h4 class="mura-panel-title">
            <a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-3" aria-expanded="false" aria-controls="panel-3">
              #application.rbFactory.getKeyValue(session.rb,'cta.how')#
            </a>
          </h4>
        </div>
        <div id="panel-3" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-3">
          <div class="mura-panel-body">
            <div class="mura-control-group">

                <!--- Begin Rendering Options --->

                <div class="mura-control-group">
                    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.type')#</label>
                    <select id="type" name="type" class="objectParam">
                        <option value="drawer"<cfif "drawer" eq objectparams.type> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.drawer')#</option>
                        <option value="modal"<cfif "modal" eq objectparams.type> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.modal')#</option>
                        <option value="bar"<cfif "bar" eq objectparams.type> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.bar')#</option>
                        <option value="inline"<cfif "inline" eq objectparams.type> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.inline')#</option>
                    </select>
                </div>
                <!---
                <div class="mura-control-group">
                    <button class="btn" id="previewcta"><li class="mi-globe"></li> Preview</button>
                </div>
                --->
                <div id="modal-option-container" class="render-option-container" style="display:none">

                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.animate')#</label>
                        <select id="animate" name="animate">
                            <option value="ttb"<cfif 'ttb' eq objectparams.animate> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.toptobottom')#</option>
                            <option value="btt"<cfif 'btt' eq objectparams.animate> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.bottomtotop')#</option>
                        </select>
                    </div>

                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.animationspeed')#</label>
                        <select id="animatespeed" name="animatespeed">
                            <cfset options=['slow','medium','fast']>
                            <cfloop array="#options#" item="option">
                                <option value="#lcase(option)#"<cfif option eq objectparams.animatespeed> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.#option#')#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.width')#</label>
                        <select id="width" name="width">
                            <option value="sm"<cfif 'sm' eq objectparams.width> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.small')#</option>
                            <option value="md"<cfif 'md' eq objectparams.width> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.medium')#</option>
                            <option value="lg"<cfif 'lg' eq objectparams.width> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.large')#</option>
                        </select>
                    </div>

                    <input type="hidden" name="anchorx" value="center"/>
                    <input type="hidden" name="anchory" value="center"/>
                </div>

                <div id="drawer-option-container" class="render-option-container" style="display:none">

                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.horizontalalignment')#</label>
                        <select id="drawer-anchorx" name="anchorx">
                            <cfset options=['left','right']>
                            <cfloop array="#options#" item="option">
                                <option value="#lcase(option)#"<cfif option eq objectparams.anchorx or objectparams.anchorx eq 'center' and option eq 'right'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.#option#')#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.verticalalignment')#</label>
                        <select id="drawer-anchory" name="anchory">
                            <cfset options=['top','bottom']>
                            <cfloop array="#options#" item="option">
                                <option value="#lcase(option)#"<cfif option eq objectparams.anchory or objectparams.anchory eq 'center' and option eq 'bottom'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.#option#')#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.animationspeed')#</label>
                        <select name="animatespeed">
                            <cfset options=['slow','medium','fast']>
                            <cfloop array="#options#" item="option">
                                <option value="#lcase(option)#"<cfif option eq objectparams.animatespeed> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.#option#')#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.width')#</label>
                        <select name="width">
                            <option value="sm"<cfif 'sm' eq objectparams.width> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.small')#</option>
                            <option value="md"<cfif 'md' eq objectparams.width> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.medium')#</option>
                            <option value="lg"<cfif 'lg' eq objectparams.width> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.large')#</option>
                        </select>
                    </div>

                    <input type="hidden" id="bar-animate" name="animate" value=<cfif objectparams.animate eq 'left'>"rtl"<cfelse>"ltr"</cfif>/>

                </div>

                <div id="bar-option-container" class="render-option-container" style="display:none">


                    <div class="mura-control-group">
                        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'cta.animationspeed')#</label>
                        <select name="animatespeed">
                            <cfset options=['slow','medium','fast']>
                            <cfloop array="#options#" item="option">
                                <option value="#lcase(option)#"<cfif option eq objectparams.animatespeed> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'cta.#option#')#</option>
                            </cfloop>
                        </select>
                    </div>

                    <input type="hidden" id="bar-animate" name="animate" value=<cfif objectparams.animate eq 'top'>"ttb"<cfelse>"btt"</cfif>/>
                    <input type="hidden" name="anchorx" value="center"/>
                    <input type="hidden" name="anchory" value="bottom"/>
                    <input type="hidden" name="width" value="full"/>
                </div>
            </div>

	      <div class="mura-control-group">
					<label>
						#application.rbFactory.getKeyValue(session.rb,'collections.cssclass')#
					</label>
					<input name="instanceclass" class="objectParam" type="text" value="#esapiEncode('html_attr',objectparams.instanceclass)#" maxlength="255">
					</div>
          </div>
        </div>
      </div> <!--- /end panel 3 --->

     </div> <!--- /end mura-panel-group --->

</div>

<input name="objectid" class="objectParam" type="hidden" value=""/>
<input name="trim-params" class="objectParam" type="hidden" value="true"/>
<input name="queue" class="objectParam" type="hidden" value="false"/>
<input name="statsid" class="objectParam" type="hidden" value="#esapiEncode('html_attr',objectparams.statsid)#"/>
<input name="render" class="objectParam" type="hidden" value="client"/>
<input name="preview" type="hidden" value=""/>
<script>
    Mura(function(){

        var isnew=<cfif YesNoFormat(rc.isnew)>true<cfelse>false</cfif>;

        Mura('##scroll').on('change',function(){
            setScrollLabel();
        });

        function setScrollLabel(){
            Mura('##scrolllabel').html( (Mura('##scroll').val()) + "%"  );
        }

        jQuery('##type').on('change',function(){
            setRenderOptions();
        });

        jQuery('##drawer-anchorx').on('change',function(){
            if(Mura(this).val()=='left'){
                Mura('##drawer-animate').val('ltr');
            } else {
                Mura('##drawer-animate').val('rtl');
            }
        });

        jQuery('##bar-anchory').on('change',function(){
            if(Mura(this).val()=='top'){
                Mura('##bar-animate').val('ttb');
            } else {
                Mura('##bar-animate').val('btt');
            }
        });

        function setRenderOptions(){
            var type=Mura('##type').val();

            jQuery('.render-option-container')
                .hide()
                .find('.objectParam')
                .removeClass('objectParam');

            var container=jQuery('##' + type + '-option-container');

            container
                .show()
                .find('input, select')
                .addClass('objectParam')

            if(type=='bar'){
                container.find('select[name="anchory"]').val('bottom').trigger('change');
            } else if(type=='drawer'){
                container.find('select[name="padding"]').val('false').trigger('change');
                container.find('select[name="anchorx"]').val('right').trigger('change');
                container.find('select[name="anchory"]').val('bottom').trigger('change');
            }

            if(!isnew){
                Mura('input[name="preview"]').addClass('objectParam').val('true');
                updateDraft();
                Mura('input[name="preview"]').removeClass('objectParam').val('');
            }

            isnew=false;
        };

        setScrollLabel();
        setRenderOptions();

        Mura('##previewcta').on('click',
            function(){
                Mura('input[name="preview"]').addClass('objectParam').val('true');
                updateDraft();
                Mura('input[name="preview"]').removeClass('objectParam').val('');
            }
        );

        <cfif hasComponentModulePerm>
    		function setComponentEditOption(){
    			var val=Mura('##componentid').val();
    			if(val && val!='notconfigured'){
    		 		Mura('##componentEditBtn').html('<i class="mi-pencil"></i> Edit');
    		 	} else {
    		 		Mura('##componentEditBtn').html('<i class="mi-plus-circle"></i> Create New');
    		 	}
    		}

    		jQuery('##componentid').change(setComponentEditOption);

    		setComponentEditOption();

    		Mura('##componentEditBtn').click(function(){
    				frontEndProxy.post({
    					cmd:'openModal',
    					src:'?muraAction=cArch.editLive&contentId=' + Mura('##componentid').val()  + '&type=Component&siteId=#esapiEncode("javascript",rc.siteid)#&instanceid=#esapiEncode("javascript",rc.instanceid)#&compactDisplay=true'
    					}
    				);
    		})

        </cfif>
        <cfif hasFormModulePerm>
    		function setFormEditOption(){
    			var val=Mura('##formid').val();
    			if(val && val!='notconfigured'){
    		 		Mura('##formEditBtn').html('<i class="mi-pencil"></i> Edit');
    		 	} else {
    		 		Mura('##formEditBtn').html('<i class="mi-plus-circle"></i> Create New');
    		 	}
    		}

    		jQuery('##formid').change(setFormEditOption);

    		setFormEditOption();

    		Mura('##formEditBtn').click(function(){
    				frontEndProxy.post({
    					cmd:'openModal',
    					src:'?muraAction=cArch.editLive&contentId=' + Mura('##formid').val()  + '&type=Form&siteId=#esapiEncode("javascript",rc.siteid)#&instanceid=#esapiEncode("javascript",rc.instanceid)#&compactDisplay=true'
    					}
    				);
    		})

        </cfif>

				window.configuratorInited=true;
    });
</script>
</cfoutput>
