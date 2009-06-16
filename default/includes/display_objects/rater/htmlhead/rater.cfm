<cfset themepath=event.getSite().getThemeAssetPath() >
<cfoutput>
<script src="#event.getSite().getAssetPath()#/includes/display_objects/rater/js/rater.js" type="text/javascript"></script>
<link href="#event.getSite().getAssetPath()#/includes/display_objects/rater/css/rater.css" rel="stylesheet" type="text/css" />
<style>
.zero { background-image: url(#themepath#/images/rater/star_zero.png); }
.one { background-image: url(#themepath#/images/rater/star_one.png); }
.onehalf { background-image: url(#themepath#/images/rater/star_onehalf.png); }
.two { background-image: url(#themepath#/images/rater/star_two.png); }
.twohalf { background-image: url(#themepath#/images/rater/star_twohalf.png); }
.three { background-image: url(#themepath#/images/rater/star_three.png); }
.threehalf { background-image: url(#themepath#/images/rater/star_threehalf.png); }
.four { background-image: url(#themepath#/images/rater/star_four.png); }
.fourhalf { background-image: url(#themepath#/images/rater/star_fourhalf.png); }
.five  { background-image: url(#themepath#/images/rater/star_five.png); }

/* IE6 PNG fixes */
* html div.stars a { background: transparent url(#themepath#/images/rater/stars.gif) no-repeat; }
* html .zero { background-image: url(#themepath#/images/rater/star_zero.gif); }
* html .one { background-image: url(#themepath#/images/rater/star_one.gif); }
* html .onehalf { background-image: url(#themepath#/images/rater/star_onehalf.gif); }
* html .two { background-image: url(#themepath#/images/rater/star_two.gif); }
* html .twohalf { background-image: url(#themepath#/images/rater/star_twohalf.gif); }
* html .three { background-image: url(#themepath#/images/rater/star_three.gif); }
* html .threehalf { background-image: url(#themepath#/images/rater/star_threehalf.gif); }
* html .four { background-image: url(#themepath#/images/rater/star_four.gif); }
* html .fourhalf { background-image: url(#themepath#/images/rater/star_fourhalf.gif); }
* html .five  { background-image: url(#themepath#/images/rater/star_five.gif); }
</style>
</cfoutput>