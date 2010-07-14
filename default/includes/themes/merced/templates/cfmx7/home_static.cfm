<cfoutput>
<cfset renderer.loadjslib()>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!--- SUGGESTED LANGUAGE ATTRIBUTES - xml:lang="en" lang="en" --->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="description" content="#request.contentBean.getmetadesc()#" />
	<meta name="keywords" content="#request.contentBean.getmetakeywords()#" />
	<cfif request.contentBean.getCredits() neq ""><meta name="author" content="#request.contentbean.getCredits()#" /></cfif>
	<meta name="generator" content="Mura CMS #application.configBean.getVersion()#" />
	<!--- <meta name="robots" content="noindex, nofollow" /> ---><!--- use this to discourage search engines from indexing your site. (can be useful if developing on a live server for example) Delete if not needed. --->
	<title>#request.contentBean.getTitle()# - #renderer.getSite().getSite()#</title>

	<link rel="icon" href="#event.getSite().getAssetPath()#/images/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#event.getSite().getAssetPath()#/images/favicon.ico" type="image/x-icon" />

	<link rel="stylesheet" href="#event.getSite().getAssetPath()#/css/default.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#themePath#/css/typography.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#themePath#/css/site.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#event.getSite().getAssetPath()#/css/print.css" type="text/css" media="print" />
	
	<cfinclude template="inc/ie_conditional_includes.cfm" />

	<cfset rs=application.feedManager.getFeeds(request.siteID,'Local',true,true) />
	<cfloop query="rs">
	<link rel="alternate" type="application/rss+xml" title="#renderer.getSite().getSite()# - #rs.name#" href="#XMLFormat('http://#listFirst(cgi.http_host,":")##application.configBean.getContext()#/tasks/feed/?feedID=#rs.feedID#')#" />
	</cfloop>

</head>
	
<body id="#renderer.gettopid()#" class="home">
<div id="container" class="#renderer.CreateCSSid(request.contentBean.getMenuTitle())#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<div id="primary" class="content">
			<!--- #renderer.dspBody(body=request.contentBean.getbody(),pageTitle='',crumbList=0,showMetaImage=0)# ---><!--- OPTIONAL --->
			<!-- Begin Slideshow -->
			<!-- This can be re-created in Mura using the Local Index Slideshow Object and a Component for the "Features" -->
			<!--- #renderer.dspObjects(2)# --->
		<div class="svSlideshow svSyndLocal svFeed svIndex clearfix" id="sysSlideshow">
	        <div class="svSlides">
	          <dl class="first hasImage">
	            <dt class="releaseDate">June 1, 2009</dt>
	            <dt><a href="">How do I recreate this home page in Mura?</a></dt>
	            <dd class="image"> <a href="" title="How do I recreate this home page in Mura?"><img src="#themePath#/images/sample/slide.jpg" alt="How do I recreate this home page in Mura?"/></a> </dd>
	            <dd class="summary">
	              <p>Recreating this home page in Mura is fairly easy. Follow these
	                steps, and you'll be up and running in no time.</p>
	              <span class="readMore"><a href="" >Read More</a></span> </dd>
	          </dl>
	          <dl class="hasImage">
	            <dt class="releaseDate">June 2, 2009</dt>
	            <dt><a href="">Step 1: Assign the Correct Template</a></dt>
	            <dd class="image"> <a href="" title="Step 1: Assign the Correct Template"><img src="#themePath#/images/sample/slide.jpg" alt="Step 1: Assign the Correct Template"/></a> </dd>
	            <dd class="summary">
	              <p>The template used is aptly named home.cfm. To make sure you
	                are using the correct template, edit the home page and select
	                home.cfm from the &quot;Layout Template&quot; dropdown in the &quot;Advanced&quot; Tab.</p>
	              <span class="readMore"><a href="" >Read More</a></span> </dd>
	          </dl>
	          <dl class="hasImage">
	            <dt class="releaseDate">June 3, 2009</dt>
	            <dt><a href="">Step 2: Create Local Indexes</a></dt>
	            <dd class="image"> <a href="" title="Step 2: Create Local Indexes"><img src="#themePath#/images/sample/slide.jpg" alt="Step 2: Create Local Indexes"/></a> </dd>
	            <dd class="summary">
	              <p>The majority of content on the homepage is created via Local
	                Indexes, a way to output custom navigation based on very specific
	                criteria such as Release Date, Most Commented, Highest Rated,
	                etc. The slideshow and sidebar content is made up of 3 Local
	                Indexes. Create these in &quot;Content Collections.&quot;</p>
	              <span class="readMore"><a href="" >Read More</a></span> </dd>
	          </dl>
	          <dl class="hasImage">
	            <dt class="releaseDate">June 3, 2009</dt>
	            <dt><a href="">Step 3: Create a "Features" Component</a></dt>
	            <dd class="image"> <a href="" title="Step 3: Create a &quot;Features&quot; Component"><img src="#themePath#/images/sample/slide.jpg" alt="Step 3: Create a &quot;Features&quot; Component"/></a> </dd>
	            <dd class="summary">
	              <p>The &quot;Features&quot; content in the three columns below
	                is static content that can be copied out of home_static.cfm.
	                Once copied, create a new &quot;Component&quot; called &quot;Features&quot; and
	                paste in the copied content as HTML source. Toggle source view
	                using the top left button in the editor.</p>
	              <span class="readMore"><a href="" >Read More</a></span> </dd>
	          </dl>
	          <dl class="last hasImage">
	            <dt class="releaseDate">June 4, 2009</dt>
	            <dt><a href="">Step 4: Add Content Objects to the Page</a></dt>
	            <dd class="image"> <a href="" title="Step 4: Add Content Objects to the Page"><img src="#themePath#/images/sample/slide.jpg" alt="Step 4: Add Content Objects to the Page"/></a> </dd>
	            <dd class="summary">
	              <p>Place your Local Indexes into Display Regions by editing the
	                home page and selecting the &quot;Content Objects&quot; tab.
	                Use the dropdown menu to select your Local Indexes, then use
	                the arrow buttons to move them to the appropriate regions. Hit &quot;Publish&quot; and
	                you're done!</p>
	              <span class="readMore"><a href="" >Read More</a></span> </dd>
	          </dl>
	        </div>
	     </div>
			<!-- End Slideshow -->
			
			<!-- Begin Features -->
		<div id="features">
        <dl class="hasImage first">
          <dt> <a href="">Sans Pica Ultra</a></dt>
          <dd class="image"><a href=""><img alt="" src="#themePath#/images/sample/feature.jpg" /></a> </dd>
          <dd class="summary">
            <p>Descender counter california job case clarendon hyphen kerning
              pair pica cap asterisk typophile, display clarendon thicks display
              bitmap.</p>
            <span class="readMore"><a href="">Read More</a></span></dd>
        </dl>
        <dl class="hasImage">
          <dt> <a href="">Humanist Stroke</a></dt>
          <dd class="image"> <a href=""><img alt="" src="#themePath#/images/sample/feature.jpg" /></a> </dd>
          <dd class="summary">
            <p>Descender counter california job case clarendon hyphen kerning
              pair pica cap asterisk typophile, display clarendon thicks display
              bitmap.</p>
            <span class="readMore"><a href="">Read More</a></span></dd>
        </dl>
        <dl class="hasImage last">
          <dt> <a href="">Ascender Dunc</a></dt>
          <dd class="image"> <a href=""><img alt="" src="#themePath#/images/sample/feature.jpg" /></a> </dd>
          <dd class="summary">
            <p>Descender counter california job case clarendon hyphen kerning
              pair pica cap asterisk typophile, display clarendon thicks display
              bitmap.</p>
            <span class="readMore"><a href="">Read More</a></span></dd>
        </dl>
      </div>
		<!-- End Features -->
		
		</div>
		<div id="right" class="sidebar">
		<!-- Place Local Indexes Here -->
		<!--- #renderer.dspObjects(3)# --->
		<div class="svSyndLocal svFeed svIndex clearfix" id="sysMostRecent">
        <h3>Most Recent</h3>
        <dl class="first">
          <dt class="releaseDate">June 4, 2009</dt>
          <dt><a href="">Nostrud exerci tation ullamco</a></dt>
          <dd class="summary">
            <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
            <span class="readMore"><a href="" >Read More</a></span> </dd>
        </dl>
        <dl class="last">
          <dt class="releaseDate">June 3, 2009</dt>
          <dt><a href="">Nostrud exerci tation ullamco</a></dt>
          <dd class="summary">
            <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
            <span class="readMore"><a href="" >Read More</a></span> </dd>
        </dl>
      </div>
      <div class="svSyndLocal svFeed svIndex clearfix" id="sysHighestRated">
        <h3>Highest Rated</h3>
        <dl class="first">
          <dt><a href="">Nostrud exerci tation ullamco</a></dt>
          <dd class="summary">
            <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
            <span class="readMore"><a href="" >Read More</a></span> </dd>
          <dd class="credits">By John Doe</dd>
          <dd class="tags"> Tags: <a href="">Dolor</a>, <a href="">Sit Amet</a></dd>
          <dd class="rating four">Rating: <span>4.0 stars</span></dd>
        </dl>
        <dl class="hasImage">
          <dt class="releaseDate">June 11, 2009</dt>
          <dt><a href="">Duis autem vel eum iriure dolor in hendrerit</a></dt>
          <dd class="image"> <a href="" title="Duis autem vel eum iriure dolor in hendrerit"></a> </dd>
          <dd class="credits">By John Doe</dd>
          <dd class="tags"> Tags: <a href="">Ipsum</a>, <a href="">Dolor</a>, <a href="">Amet</a>, <a href="">Ipsum</a></dd>
          <dd class="rating three">Rating: <span>3.0 stars</span></dd>
        </dl>
        <dl class="last hasImage">
          <dt><a href="">Quis nostrud exerci tation ullam</a></dt>
          <dd class="summary">
            <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed
              diam nonummy nibh euismod tincidunt ut laoreet dolore.</p>
            <span class="readMore"><a href="" >Read More</a></span> </dd>
          <dd class="credits">By John Doe</dd>
          <dd class="tags"> Tags: <a href="">Lorem</a>, <a href="">Dolor</a></dd>
          <dd class="rating two">Rating: <span>2.0 stars</span></dd>
        </dl>
      </div>

		</div>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
	<!--- These are included dynamically in the normal home.cfm template but need to be here to load appropriately in this static version --->
	<script src="#event.getSite().getAssetPath()#/includes/display_objects/feedslideshow/js/slideshow.jquery.js" type="text/javascript"></script>
	<script src="#event.getSite().getAssetPath()#/includes/display_objects/feedslideshow/js/jquery.cycle.js" type="text/javascript"></script>
</body>
</html>
</cfoutput>