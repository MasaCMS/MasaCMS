<cfif not len(chainID)>
  <cfset chainID=createUUID()>
</cfif>  
<cfset chain=$.getBean('approvalChain').loadBy(chainid=chainID)/>
<cfoutput>
<cfif not len(chainid)>
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
  <input name="name" type="text" class="span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'approvalchains.namerequired')#" value="#HTMLEditFormat(chain.getName())#" maxlength="50">
   </div>
</div>

<div class="control-group">
  <label class="control-label">
    #application.rbFactory.getKeyValue(session.rb,'approvalchains.description')#
  </label>
  <div class="controls">
  <textarea name="description" class="span12" rows="6">#HTMLEditFormat(chain.getDescription())#</textarea>
  </div>
</div>

<div class="control-group" id="availableGroups">
  <label class="control-label">
    <span class="span6">Available Groups</span> <span class="span6">Selected Groups</span>
  </label>

  <div id="sortableGroups" class="controls">
    <p class="dragMsg">
      <span class="dragFrom span6">Drag Groups from Here&hellip;</span><span class="span6">&hellip;and Drop Them Here.</span>
    </p>              
          
    <ul id="groupAvailableListSort" class="groupDisplayListSortOptions">
      <cfset it=chain.getAvailableGroupsIterator()>
      <cfloop condition="it.hasNext()">
        <cfset item=it.next()>
        <li class="ui-state-default">
          #HTMLEditFormat(item.getGroupName())#
          <input name="availableID" type="hidden" value="#item.getUserID()#">
        </li>
      </cfloop>
    </ul>
                        
    <ul id="groupAssignmentListSort" class="groupDisplayListSortOptions">  
      <cfset it=chain.getMembershipsIterator()>
      <cfloop condition="it.hasNext()">
        <cfset item=it.next()>
        <li class="ui-state-highlight">
          #HTMLEditFormat(item.getGroup().getGroupName())#
          <input name="groupID" type="hidden" value="#item.getGroupID()#">
        </li>
      </cfloop>
    </ul>   
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
    <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'approvalchains.delete')#" onclick="confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'approvalchains.deleteconfirm'))#','./?muraAction=cchain.delete&chainID=#chain.getchainID()#&siteid=#URLEncodedFormat(chain.getSiteID())#')" /> 
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'save');" value="#application.rbFactory.getKeyValue(session.rb,'approvalchains.update')#" />
  </cfif>
  <input type="hidden" name="siteid" value="#chain.getSiteID()#">
  <input type=hidden name="chainID" value="#chain.getchainID()#">
</div>
</form>
<cfinclude template="js.cfm">
</cfoutput>
