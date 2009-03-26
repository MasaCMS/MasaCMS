<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfset createColdSpring('coldspring_intro.xml') />
<cfoutput>
<layout:layout section="intro">
<h1>ColdSpring in Five Minutes</h1>
<p>
	To demonstrate how ColdSpring works, <strong>let's start with a very simple example</strong>. 
	Let's say we have 3 CFCs: a UserService, a UserGateway, and a ConfigBean. 
	Here is the code for these, and you can find the actual CFCs in the quickstart/components folder:</p>
<p>

<div class="featurebox">
	<p>
		If you aren't familiar with Model-View-Controller (MVC) or object-oriented programming, <strong>don't worry</strong>.
		These are very simple CFCs with just one or two methods in them. The names don't really matter at this point.
		Just follow along since right now <strong>all we're doing is explaining what ColdSpring can do</strong>.
	</p>
</div>
			
<h2>UserService.cfc</h2>
<p>#getCodeSnippet('components/UserService.cfc')#</p>	

<h2>UserGateway.cfc</h2>
<p>#getCodeSnippet('components/UserGateway.cfc')#</p>	

<h2>ConfigBean.cfc</h2>
<p>#getCodeSnippet('components/ConfigBean.cfc')#</p>	

<p>
	As you might notice, the components are related to each other. In other words, <strong>they have dependencies on each other</strong>.
	The UserService needs the UserGateway, and the UserGateway needs the ConfigBean. It may be that UserService will make
	calls to the UserGateway to run some database queries. And it may be that the UserGateway makes calls to the ConfigBean
	to determine what datasource to use when it executes queries.
</p>

<p>
	Without something like ColdSpring, creating and configuring these components can be quite a chore. We'd have to do something
	like:
	#getCodeSnippet('codesnippets/manualcreation.txt')#	
</p>

<p>
	Notice that we have to <strong>create the CFCs in the right order</strong>, and that we have to <strong>manually pass the dependent
	components into each CFC</strong>. As you might imagine, in larger applications with lots of CFCs and lots of dependencies,
	this can turn into a nightmare pretty quickly. Luckily, we have ColdSpring to manage all of this for us!
</p>

<p>
	Instead of doing things manually, <strong>we can tell ColdSpring about our components and their dependencies</strong>. 
	This is typically done using an XML configuration file. Don't worry, just because it's XML doesn't mean it's a pain to use. 
	Here is a simple ColdSpring configuration file:
	#getCodeSnippet('config/coldspring_intro.xml', 'xml')#
</p>

<p>
	You can see that we're just defining our component paths and giving each one an identifier, called a 'bean ID'. The 
	'default-autowire="byName"' attribute tells ColdSpring to look at the setters in our CFCs and try to find a CFC whose bean ID 
	matches the setter. So if it sees setUserGateway(), ColdSpring looks for a bean named "userGateway". <strong>If it finds a match, 
	it sets it automatically!</strong>
</p>

<p>
	Once you have your ColdSpring XML written, all you have to do is create an instance of the ColdSpring factory. You specify
	the configuration file when you create ColdSpring. The code is very simple:
	#getCodeSnippet('codesnippets/createcoldspring.txt')#
</p>

<p>
	<strong>Now that we have an instance of the ColdSpring factory</strong>, we can ask it for our CFC instances. Our CFCs will be fully initialized,
	with all dependencies resolved, and ready for use! For example, if we call:
	#getCodeSnippet('codesnippets/getbean.txt')#
</p>

<p>
	You'll see three CFCs dumped using CFDump:
	<cfset userService = beanFactory.getBean('userService') />	
	<cfdump var="#userService#" />
</p>

<p>
	<cfset userGateway = userService.getUserGateway() />	
	<cfdump var="#userGateway#" />
</p>
<p>	
	<cfset configBean = userGateway.getConfigBean() />
	<cfdump var="#configBean#" />
</p>
<p />
<p>
	That's it! See, using ColdSpring is actually pretty easy. We <strong>defined our XML config file</strong>, <strong>created the ColdSpring factory</strong>,
	and <strong>ColdSpring did the rest</strong>. ColdSpring worries about creating the components in the correct order and resolving
	the dependencies between them. And we can get on with the fun part of coding: building applications!
</p>

</layout:layout>
</cfoutput>