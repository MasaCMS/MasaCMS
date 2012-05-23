<cfset themepath=event.getSite().getThemeAssetPath() >
<cfoutput>
<script src="#event.getSite().getAssetPath()#/includes/display_objects/rater/js/rater.min.js" type="text/javascript"></script>
<link href="#event.getSite().getAssetPath()#/includes/display_objects/rater/css/rater.min.css" rel="stylesheet" type="text/css" />
</cfoutput>