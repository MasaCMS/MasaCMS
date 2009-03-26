<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfoutput>
<layout:layout section="home">
<h1>Welcome to the ColdSpring Quickstart Guide</h1>
<span class="featurebox" style="float:right; clear:right; width: 250px; margin: 0px 0px 10px 10px;">
	<strong>What Is ColdSpring?</strong><br />ColdSpring is a Dependency Injection (DI) or Inversion of Control (IoC) framework for ColdFusion applications.
</span>
<span class="featurebox" style="float:right; clear: right; width: 250px; margin: 0px 0px 10px 10px;">
	<strong>What Is Dependency Injection?</strong><br />"Dependency Injection (DI) in Computer programming refers to the process of supplying an external dependency to a software component." 
	- Wikipedia
</span>
<p>
	<strong>You've successfully installed ColdSpring and have made it to the Quickstart Guide!</strong> So far we have the following sections. 
	Some of these may be sparsely populated but we will keep working on them as we continue development:
	<ul>
		<li><a href="index.cfm?page=intro">ColdSpring in 5 Minutes</a>: Get up and running in no time, with an understanding of what ColdSpring's Dependency Injection capabilities.</li>
		<li><a href="index.cfm?page=advanced">Advanced Dependency Injection</a>: Examples that show off some of the more advanced Dependency Injection capabilities of ColdSpring.</li>
		<li><a href="index.cfm?page=aop">Aspect-Oriented Programming Examples</a>: A description of what AOP is, and a look at how AOP can make many complex tasks easier.</li>
		<li><a href="index.cfm?page=remote">Remote Proxies</a>: Looks at how ColdSpring can automatically generate remote proxy components for web service, AJAX, and Flash Remoting requests.</li>
		<li><a href="index.cfm?page=extensions">Extensions</a>: Shows off some of the available extensions to the core ColdSpring framework to help with specific use cases.</li>
		<li><a href="index.cfm?page=resources">Resources</a>: A set of links to ColdSpring sites, discussion groups, and blog entries.</li>
	</ul>
</p>	

<p>
	Everything in this Quickstart is running real code as well. So feel free to have a look at the source code if the
	code examples don't show you everything you're interested in.
</p>
	
</layout:layout>
</cfoutput>