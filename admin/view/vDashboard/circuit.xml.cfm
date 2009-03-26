<circuit access="internal">

<prefuseaction/>

<fuseaction name="main">
 <include template="dsp_main.cfm"/>
</fuseaction>

<fuseaction name="topReferers">
<include template="dsp_topReferers.cfm"/>
</fuseaction>

<fuseaction name="topRated">
<include template="dsp_topRated.cfm"/>
</fuseaction>

<fuseaction name="topSearches">
<include template="dsp_topSearches.cfm"/>
</fuseaction>

<fuseaction name="topContent">
<include template="dsp_topContent.cfm"/>
</fuseaction>

<fuseaction name="listSessions">
 <include template="dsp_listSessions.cfm"/>
</fuseaction>

<fuseaction name="viewSession">
 <include template="dsp_session.cfm"/>
</fuseaction>

<fuseaction name="sessionSearch">
 <include template="dsp_sessionSearch.cfm"/>
</fuseaction>

<fuseaction name="ajax">
<include template="ajax/dsp_javascript.cfm"/>
</fuseaction>

<fuseaction name="loadUserActivity">
 <include template="ajax/dsp_user_activity.cfm"/>
</fuseaction>

<fuseaction name="loadPopularContent">
 <include template="ajax/dsp_popular_content.cfm"/>
</fuseaction>

<fuseaction name="loadFormActivity">
 <include template="ajax/dsp_form_activity.cfm"/>
</fuseaction>

<fuseaction name="loadEmailActivity">
 <include template="ajax/dsp_email_activity.cfm"/>
</fuseaction>

</circuit>