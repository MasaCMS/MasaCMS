<cfset variables.themepath=variables.$.siteConfig('ThemeAssetPath') >
<cfoutput>
<script src="#variables.$.siteConfig('AssetPath')#/includes/display_objects/rater/js/rater.min.js" type="text/javascript"></script>
<link href="#variables.$.siteConfig('AssetPath')#/includes/display_objects/rater/css/rater.min.css" rel="stylesheet" type="text/css" />
</cfoutput>