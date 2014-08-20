<cfif not len(rc.chainID)>
  <cfset rc.chainID=createUUID()>
</cfif>  
<cfset chain=$.getBean('approvalChain').loadBy(chainid=rc.chainID)/>
<cfoutput>
<cfif not len(rc.chainid)>
	<h1>#application.rbFactory.getKeyValue(session.rb,"approvalchains.addapprovalchain")#</h1>
<cfelse>
	<h1>#application.rbFactory.getKeyValue(session.rb,"approvalchains.editapprovalchain")#</h1>
</cfif>

<cfinclude template="dsp_secondary_menu.cfm">

<cfif not structIsEmpty(chain.getErrors())>
    <div class="alert alert-error">#application.utility.displayErrors(chain.getErrors())#</div>
</cfif>

<form class="fieldset-wrap" novalidate="novalidate" action="./?muraAction=cchain.save" method="post" name="form1" onsubmit="return validateForm(this);">
<div class="fieldset">
<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'approvalchains.name')#
  </label>
  <div class="controls">
  <input name="name" type="text" class="span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'approvalchains.namerequired')#" value="#esapiEncode('html_attr',chain.getName())#" maxlength="50">
   </div>
</div>

<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'approvalchains.description')#
  </label>
  <div class="controls">
  <textarea name="description" class="span12" rows="6">#esapiEncode('html',chain.getDescription())#</textarea>
  </div>
</div>

<div class="control-group" id="availableGroups">
	<div class="alert alert-info">
		<p>The first group in the chain will be the first group to actually <em>approve</em> the content after it's been submitted.
		<strong>All content creators can send for approval without having to be in the chain.</strong></p>
	</div>
  <label class="control-label">
    <span class="span6">#application.rbFactory.getKeyValue(session.rb,'approvalchains.groupsavailable')#</span> <span class="span6">#application.rbFactory.getKeyValue(session.rb,'approvalchains.groupselected')#</span>
  </label>

  <div id="sortableGroups" class="controls">
    <p class="dragMsg">
      <span class="dragFrom span6">#application.rbFactory.getKeyValue(session.rb,'approvalchains.dragfrom')#&hellip;</span><span class="span6">&hellip;#application.rbFactory.getKeyValue(session.rb,'approvalchains.dragto')#</span>
    </p>              
          
    <ul id="groupAvailableListSort" class="groupDisplayListSortOptions">
      <cfset it=chain.getAvailableGroupsIterator()>
      <cfloop condition="it.hasNext()">
        <cfset item=it.next()>
        <li class="ui-state-default">
          #esapiEncode('html',item.getGroupName())#
          <input name="availableID" type="hidden" value="#item.getUserID()#">
        </li>
      </cfloop>
    </ul>
                        
    <ol id="groupAssignmentListSort" class="groupDisplayListSortOptions">  
      <cfset it=chain.getMembershipsIterator()>
      <cfloop condition="it.hasNext()">
        <cfset item=it.next()>
        <li class="ui-state-highlight">
          #esapiEncode('html',item.getGroup().getGroupName())#
          <input name="groupID" type="hidden" value="#item.getGroupID()#">
        </li>
      </cfloop>
    </ol>   
    <script>
      $(function(){
          chainManager.setGroupMembershipSort();
        });
    </script>
  </div>
</div>
<div class="form-actions">
  <cfif rc.chainID eq ''>
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'approvalchains.add')#" />
  <cfelse>
    <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'approvalchains.delete')#" onclick="confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'approvalchains.deleteconfirm'))#','./?muraAction=cchain.delete&chainID=#chain.getchainID()#&siteid=#esapiEncode('url',chain.getSiteID())#')" /> 
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'save');" value="#application.rbFactory.getKeyValue(session.rb,'approvalchains.update')#" />
  </cfif>
  <input type="hidden" name="siteid" value="#chain.getSiteID()#">
  <input type=hidden name="chainID" value="#chain.getchainID()#">
  #rc.$.renderCSRFTokens(context=chain.getchainID(),format="form")#
</div>
</form>
<cfinclude template="js.cfm">
</cfoutput>
