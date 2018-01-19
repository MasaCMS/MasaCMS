<cfsilent>
  <cfset rsSites=application.mura.getBean('settingsManager').getList()>
  <cfset entity=application.mura.getBean('entity').loadBy(name=rc.entityname)>
  <cfquery name="rsAssigned">
    select siteid from tcontent where moduleid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#entity.getEntityID()#">
  </cfquery>
</cfsilent>
<cfoutput>
<div class="mura-header">
  <h1>Site Assigments for "#esapiEncode('html',entity.getDisplayName())#"</h1>
  <div class="nav-module-specific btn-group">
    <a class="btn" href="##" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="mi-arrow-circle-left"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
  </div>

</div> <!-- /.mura-header -->

<div class="block block-constrain">
  <div class="block block-bordered">
    <div class="block-content">

      <form novalidate="novalidate" method="post" action="./?muraAction=scaffold.updateSites">
      <div class="mura-control-group">
        <label>Select sites that will have access to manage this entity</label>
        <div class="mura-control-group">
          <cfloop query="rsSites">
            <label class="checkbox"><input type="checkbox" value="#rsSites.siteID#" name="siteAssignID"<cfif listFind(valuelist(rsAssigned.siteID),rsSites.siteID)> checked</cfif>> #esapiEncode('html',rsSites.site)#</label>
          </cfloop>
        </div>
      </div>
      <div class="mura-actions">
        <div class="form-actions">
          <button type="submit" class="btn mura-primary"><i class="mi-check-circle"></i> Update</button>
          <input type="hidden" name="entityname" value="#esapiEncode('html_attr',rc.entityname)#">
          #rc.$.renderCSRFTokens(context=rc.entityname,format="form")#
        </div>
      </div>
    </form>

    </div> <!-- /.block-content -->
  </div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->
</cfoutput>
