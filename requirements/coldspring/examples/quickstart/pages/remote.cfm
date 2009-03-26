<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfset createColdSpring('coldspring_remote.xml') />
<cfset application.beanFactory = beanFactory />

<cfoutput>
<layout:layout section="remote">
<h1>Generating Remote Proxies with ColdSpring</h1>

<p>
	Another very useful feature that ColdSpring provides is the ability to automatically generate Remote Proxy 
	components. This can be very useful for exposing web services, Flash remoting, or AJAX functions for your
	web site in a granular way. Because <strong>you can specify what components are open for remote access, as well
	as which methods are exposed</strong>, you have a lot of flexibility.
</p>

<p>
	As you may have guessed by now, defining a Remote Proxy component is done in the XML configuration file.
	Let's say I want to allow remote access to my LanguageService's reverseString() and duplicateString() methods.
	Here is how we could do that:
</p>

<p>#getCodeSnippet('config/coldspring_remote.xml', 'xml')#</p>	

<p>
	The XML is fairly straightforward even though it is a bit verbose:
	<ul>
		<li>The remote bean is an instance of ColdSpring's RemoteFactoryBean.</li>
		<li>We specify 'lazy-init="false"' so that ColdSpring will generate the Remote Proxy as soon as
			the ColdSpring factory is created. Otherwise, if you leave it as the default (lazy-init="true") ColdSpring 
			waits for you to call getBean() to generate the Remote Proxy. Since we want our Remote Proxy to
			be ready right way, we'll set this to false so that it is created immediately.
		</li>
		<li>The target is the bean which will be proxied.</li>
		<li>The service name is the name of the CFC that ColdSpring will generate.</li>
		<li>Relative path is the location where ColdSpring will place the generated CFC.</li>
		<li>Remote method names is a list of method names that will allow remote access. Specifying '*' means all methods.</li>
		<li>The name of the application scope variable that holds the bean factory. In this case I've set it to 
			application.beanFactory.</li>
	</ul>
</p>

<p>
	That's really it. You can see that the remote proxy was created by 
	<a href="/coldspring/examples/quickstart/components/RemoteLanguageService.cfc?wsdl" target="_blank">clicking here to view the WSDL for it</a>.
</p>

<p>
	We can also test it by calling one of the methods as a web service:
</p>

<p>#getCodeSnippet('codesnippets/remote1.txt')#</p>

<cfinvoke 
	webservice="http://#cgi.server_name#:#cgi.server_port#/coldspring/examples/quickstart/components/RemoteLanguageService.cfc?wsdl" 
	method="reverseString" 
	returnvariable="remoteResult">
	<cfinvokeargument name="string" value="A Remote String!" />	
</cfinvoke>

<p>
	Remote Result: #remoteResult#
</p>

<p>
	To summarize, we told ColdSpring to generate a Remote Proxy for our LanguageService. Then we called the Remote Proxy
	as a web service and ran one of our newly-exposed remote methods. This is a very powerful technique since <strong>it allows
	you to granularly expose parts of your model for remote access</strong> without having to write the proxies yourself. 
</p>

<div class="featurebox">	
	<h3>What About AOP With Remote Proxies?</h3>
	<p>
		Some of you may already be asking "Can I use AOP with Remote Proxies?" The answer is yes! This is another
		reason that letting ColdSpring generate Remote Proxies for you is so powerful. This is where things
		like security, logging, or data translation with AOP can be especially useful. <strong>You can specify interceptors
		for Remote Proxies the same way you can for AOP Proxies</strong>. In fact, under the hood, a Remote Proxy is just
		a subtype of an AOP Proxy. To get you started, this is what it might look like. As you can see, it is very similar to
		the AOP example you've already seen. We're specifying the list of interceptors on the Remote Proxy the
		same way we did in the AOP example:
	</p>
	<p>#getCodeSnippet('codesnippets/remote2.txt', 'xml')#</p>	
</div>	

</layout:layout>
</cfoutput>