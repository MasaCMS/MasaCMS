<cfsilent>
    <cfset rc.contentBean=rc.$.getBean('content').loadBy(remoteid=rc.remoteid)>
    <cfset rc.contentBean.set(rc)>
</cfsilent>
<cfif isDefined('rc.saveTargeting')>
    <cfif rc.contentBean.getIsNew()>
        <cfset rc.contentBean.set(rc).save()>
    </cfif>
    <cfset rc.contentBean.getVariationTargeting().setInitJS(rc.initjs).save()>
    <cfinclude template="dsp_close_compact_display.cfm">
<cfelse>
<cfinclude template="js.cfm">
<cfoutput>

<div class="mura-header">
	<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.custominitjs')#</h1>
</div> <!-- /.mura-header -->

<div class="alert alert-error">
    WARNING: For advanced user only.
</div>

<form action="./" method="post">
<div class="block block-constrain">
	<div class="block block-bordered">
		<div class="block-content">
            <div class="mura-control-group">
    			<label>
    				Initalization JS
    			</label>
    			<textarea name="initjs" id="initjs" rows="10">#esapiEncode('html',rc.contentBean.getVariationTargeting().getInitJS())#</textarea>
    		</div>
    		<div class="form-actions">
    			<button class="btn" id="updateBtn"><i class="mi-check-circle"></i>Update</button>
            </div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
	<div class="">
		<p>Example:</p>
		<pre>Mura('SELECTOR').addClass('mxp-editable')</pre>
	</div><br/>
</div> <!-- /.block-constrain -->
<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
<input type="hidden" name="remoteurl" value="#esapiEncode('html_attr',rc.remoteurl)#">
<input type="hidden" name="remoteid" value="#esapiEncode('html_attr',rc.remoteid)#">
<input type="hidden" name="title" value="#esapiEncode('html_attr',rc.title)#">
<input type="hidden" name="parentid" value="00000000000000000000000000000000099">
<input type="hidden" name="moduleid" value="00000000000000000000000000000000099">
<input type="hidden" name="type" value="Variation">
<input type="hidden" name="compactDisplay" value="true">
<input type="hidden" name="contentid" value="#esapiEncode('html_attr',rc.contentBean.getContentID())#">
<input type="hidden" name="muraAction" value="carch.variationTargeting">
<input type="hidden" name="saveTargeting" value="true">
</form>
</cfoutput>
<script type="text/javascript">
jQuery(document).ready(function(){
    if (top.location != self.location) {
        if(jQuery("#ProxyIFrame").length){
            jQuery("#ProxyIFrame").load(
                function(){
                    frontEndProxy.post({cmd:'setWidth',width:'standard'});
                }
            );
        } else {
            frontEndProxy.post({cmd:'setWidth',width:'standard'});
        }
    }
});
</script>
</cfif>
