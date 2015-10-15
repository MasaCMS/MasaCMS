<cfoutput>
<div id="nav-module-specific" class="btn-group">
	<a class="btn" onclick="history.go(-1);"><i class="icon-circle-arrow-left"></i>  #application.rbFactory.getKeyValue(session.rb,'collections.back')#
	</a>
</div>

<div class="fieldset">
	<div id="selectRelatedContent"><!--- target for ajax ---></div>
	<div id="selectedRelatedContent" class="control-group">
	</div>
	<input id="relatedContentSetData" type="hidden" name="relatedContentSetData" value="" />	
</div>
<script>
$(function(){
	siteManager.loadRelatedContentSets('#esapiEncode(rc.contentBean.getContentID())#','#esapiEncode(rc.contentBean.getContentHistID())#','#esapiEncode(rc.contentBean.getType())#','#esapiEncode(rc.contentBean.getSubType())#','#esapiEncode(rc.contentBean.getSiteID())#');
});
</cfoutput>