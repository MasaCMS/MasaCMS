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
  <script>
        function generateToken(){
            actionModal(function(){
                $('##action-modal').remove();
                mura.generateOAuthToken('client_credentials',$('##clientid').val(),$('##clientsecret').val()).then(function(data){
                    $('##token-container').html('<div class="alert alert-info"><span><strong>access_token:</strong> ' + data['access_token'] +'</p><p><strong>expires_in:</strong> ' + data['expires_in'] + '</span></div>');
                });
            });
        }
    </script>
  <div class="nav-module-specific btn-group">
      <a class="btn" href="./?muraAction=cwebservice.list&siteid=&#esapiEncode('url',rc.siteid)#"><i class="mi-arrow-circle-left"></i>  Back to Web Services</a>
      <cfif rc.bean.exists() and rc.bean.getGrantType() eq 'client_credentials'><a class="btn conditional client_credentials" href="##" onclick="generateToken();return false;"><i class="mi-key"></i> Generate Access Token</a></cfif>
  </div>
</div> <!-- /.mura-header -->

<cfif not structIsEmpty(rc.bean.getErrors())>
  <div class="alert alert-error"><span>#application.utility.displayErrors(rc.bean.getErrors())#</span></div>
</cfif>

<cfif not rc.$.siteConfig('useSSL')>
      <div class="alert alert-error"><span>IMPORTANT: When using web services in production this site should be set to use SSL (HTTPS).</span></div>
</cfif>

<form novalidate="novalidate" action="./?muraAction=cwebservice.save" method="post" name="form1" onsubmit="return validateForm(this);">
<div class="block block-constrain">
    <div class="block block-bordered">
      <div class="block-content">


        <span id="token-container"></span>
      <div class="mura-control-group">
          <label>Name</label>
          <input name="name" type="text" required="true" message="The Name attribute is required." value="#esapiEncode('html_attr',rc.bean.getName())#" maxlength="50">
      </div>
      <div class="mura-control-group">
          <label>Description</label>
          <textarea name="description" rows="6">#esapiEncode('html',rc.bean.getDescription())#</textarea>
      </div>

      <div class="mura-control-group">
          <label>Authorization Mode</label>
              <select name="granttype">
                  <option value="basic" <cfif rc.bean.getGrantType() eq 'basic'> selected</cfif>>Basic</option>
                  <option value="client_credentials"<cfif rc.bean.getGrantType() eq 'client_credentials'> selected</cfif>>OAuth2 (client_credentials)</option>
                  <option value="authorization_code"<cfif rc.bean.getGrantType() eq 'authorization_code'> selected</cfif>>OAuth2 (authorization_code)</option>
                  <option value="implicit"<cfif rc.bean.getGrantType() eq 'implicit'> selected</cfif>>OAuth2 (implicit)</option>
                  <option value="password"<cfif rc.bean.getGrantType() eq 'password'> selected</cfif>>OAuth2 (password)</option>
              </select>
      </div>

      <div class="mura-control-group conditional basic client_credentials">
          <label>Connected Account</label>
              <cfset users=$.getBean('userFeed').setSiteID(rc.siteid).setIsPublic(0).setSortBy('lname').getIterator()>
              <select name="userid">
                  <option value="">-- Select Account --</option>
                  <cfloop condition="users.hasNext()">
                      <cfset user=users.next()>
                      <option value="#user.getUserID()#"<cfif user.getUserID() eq rc.bean.getUserID()> selected</cfif>>#esapiEncode('html',user.getFullname())#</option>
                  </cfloop>
              </select>
      </div>

      <div class="mura-control-group conditional authorization_code implicit" style="block:none">
          <label>Redirect_URI</label>
          <textarea name="redirectURL" rows="5">#esapiEncode('html',rc.bean.getRedirectURL())#</textarea>
      </div>

        <cfif rc.bean.exists()>
            <div class="mura-control-group">
                <label>Endpoint</label>
                <div>
                    <a href="#rc.$.siteConfig().getApi('json','v1').getEndpoint(mode='rest')#" target="_blank">#rc.$.siteConfig().getApi('json','v1').getEndpoint(mode='rest')#</a>
                </div>
            </div>
            <div class="mura-control-group conditional client_credentials authorization_code implicit password">
                <label>OAuth Endpoint</label>
                <div>
                    <a href="#rc.$.siteConfig().getApi('json','v1').getEndpoint(mode='rest')#/oauth2" target="_blank">#rc.$.siteConfig().getApi('json','v1').getEndpoint(mode='rest')#/oauth2</a>
                </div>
            </div>
            <div class="mura-control-group conditional basic">
                <label>Username</label>
                <div>
                    #rc.bean.getClientID()#
                </div>
            </div>
            <div class="mura-control-group conditional basic">
                <label>Password</label>
                <div>
                    #rc.bean.getClientSecret()#
                </div>
            </div>
            <div class="mura-control-group conditional basic">
                <label>Basic Authentication Header</label>
                <div>
                    Authorization: Basic #ToBase64(rc.bean.getClientID() & ":" & rc.bean.getClientSecret())#
                </div>
            </div>
            <div class="mura-control-group conditional client_credentials authorization_code implicit password">
                <label>client_id</label>
                <div>
                    #rc.bean.getClientID()#
                </div>
            </div>
            <div class="mura-control-group conditional client_credentials password authorization_code implicit">
                <label>client_secret</label>
                <div>
                    #rc.bean.getClientSecret()#
                </div>
            </div>
            <div class="mura-control-group conditional client_credentials">
                <label>Example Usage of</label>
                <div>
                    <a href="#rc.$.siteConfig().getApi('json','v1').getEndpoint(mode='rest')#/oauth2?grant_type=client_credentials&client_id=#rc.bean.getClientID()#&client_secret=#rc.bean.getClientSecret()#" target="_blank">#rc.$.siteConfig().getApi('json','v1').getEndpoint(mode='rest')#/oauth2?grant_type=client_credentials&client_id=#rc.bean.getClientID()#&client_secret#rc.bean.getClientSecret()#</a>
                </div>
            </div>
        </cfif>

      <div class="mura-actions">
        <div class="form-actions">
          <cfif not rc.bean.exists()>
            <button class="btn mura-primary" type="button" onclick="submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i> Add</button>
          <cfelse>
            <button class="btn" type="button" onclick="confirmDialog('Delete Web Service?','./?muraAction=cwebservice.delete&clientid=#rc.bean.getclientid()#&siteid=#esapiEncode('url',rc.bean.getSiteID())##rc.$.renderCSRFTokens(context=rc.bean.getClientID(),format="url")#');"><i class="mi-trash"></i> Delete</button>
            <button class="btn mura-primary" type="button" onclick="submitForm(document.forms.form1,'save');"><i class="mi-check-circle"></i> Update</button>
          </cfif>
          <input type="hidden" id="siteid" name="siteid" value="#rc.bean.getSiteID()#">
          <input type=hidden id="clientid" name="clientid" value="#rc.bean.getclientid()#">
          <input type=hidden id="clientsecret" name="clientsecret" value="#rc.bean.getclientSecret()#">
          #rc.$.renderCSRFTokens(context=rc.bean.getclientid(),format="form")#
        </div>
      </div>


    </div> <!-- /.block-content -->
  </div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->
</form>

<script>
      $(function(){
          $('select[name="granttype"]').change(function(){
              $(".conditional").hide();
              $("." + $(this).val()).show();
          }).trigger('change');
      })
</script>
</cfoutput>
