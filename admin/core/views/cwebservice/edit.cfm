<cfif not len(rc.clientid)>
  <cfset rc.clientid=createUUID()>
</cfif>

<cfif not isdefined('rc.bean') or not isObject(rc.bean)>
    <cfset rc.bean=$.getBean('oauthClient').loadBy(clientid=rc.clientid)/>
</cfif>
<cfoutput>


<div class="mura-header">
  <cfif not rc.bean.exists()>
	<h1>Add Web Service</h1>
  <cfelse>
	<h1>Edit Web Service</h1>
  </cfif>

</div> <!-- /.mura-header -->
<form novalidate="novalidate" action="./?muraAction=cwebservice.save" method="post" name="form1" onsubmit="return validateForm(this);">
<div class="block block-constrain">
    <div class="block block-bordered">
      <div class="block-content">

        <cfif not structIsEmpty(rc.bean.getErrors())>
          <div class="alert alert-error">#application.utility.displayErrors(rc.bean.getErrors())#</div>
        </cfif>


      <div class="mura-control-group">
          <label>
              Name
          </label>
          <div>
              <input name="name" type="text" required="true" message="The Name attribute is required." value="#esapiEncode('html_attr',rc.bean.getName())#" maxlength="50">
          </div>
      </div>
      <div class="mura-control-group">
          <label>
            Description
          </label>
          <div>
              <textarea name="description" rows="6">#esapiEncode('html',rc.bean.getDescription())#</textarea>
          </div>
      </div>

      <div class="mura-control-group">
          <label>
            Connected User
          </label>
          <div>
              <cfset users=$.getBean('userFeed').setSiteID(rc.siteid).setIsPublic(0).setSortBy('lname').getIterator()>

              <select name="userid">
                  <option value="">-- Select User --</option>
                  <cfloop condition="users.hasNext()">
                      <cfset user=users.next()>
                      <option value="#user.getUserID()#"<cfif user.getUserID() eq rc.bean.getUserID()> selected</cfif>>#esapiEncode('html',user.getFullname())#</option>
                  </cfloop>
              </select>
          </div>
      </div>

      <div class="mura-actions">
        <div class="form-actions">
          <cfif not rc.bean.exists()>
            <button class="btn mura-primary" type="button" onclick="submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i> Add</button>
          <cfelse>
            <button class="btn" type="button" onclick="confirmDialog('Delete Web Service/','./?muraAction=cwebservice.delete&clientid=#rc.bean.getclientid()#&siteid=#esapiEncode('url',rc.bean.getSiteID())##rc.$.renderCSRFTokens(context=rc.bean.getClientID(),format="url")#');"><i class="mi-trash"></i> Delete</button>
            <button class="btn mura-primary" type="button" onclick="submitForm(document.forms.form1,'save');"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'approvalchains.update')#</button>
          </cfif>
          <input type="hidden" name="siteid" value="#rc.bean.getSiteID()#">
          <input type=hidden name="clientid" value="#rc.bean.getclientid()#">
          #rc.$.renderCSRFTokens(context=rc.bean.getclientid(),format="form")#
        </div>
      </div>


    </div> <!-- /.block-content -->
  </div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->
</form>
</cfoutput>
