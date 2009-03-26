<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfset createColdSpring('coldspring_aop.xml') />

<cfoutput>
<layout:layout section="aop">
<h1>Aspect-Oriented Programming with ColdSpring</h1>

<p>
	Aspect-Oriented Programming (AOP) may simultaneously be the <strong>most useful feature</strong> that ColdSpring offers and 
	the <strong>most difficult to understand</strong>. In order to explain why it is useful, we first need to explain what it 
	is. This section is a bit long, so bear with us. It's not an easy thing to explain.
</p>

<div class="featurebox">	
	<h3>What is AOP?</h3>
	<p>
		Many systems have behavior that <strong>applies across many different parts</strong> of the code. These may include logging, 
		security, failure handling, or persistence, and tend to cut across many groups of functional components.
	</p>
	<p>
		While they can be thought about and analyzed relatively separately from the basic functionality, programming them using 
		current approaches tends to result in these aspects being <strong>spread throughout the code</strong>. 
		The source code becomes a <strong>tangled mess</strong> of instructions for different purposes. 
		It also results in extensive <strong>duplication of logic</strong>.
	</p>
	<p>
		This "tangling" phenomenon is at the heart of much needless complexity in existing software systems. A number of 
		researchers have begun working on approaches to this problem that allow programmers to <strong>express each of a system's 
		aspects of concern in a separate and natural form</strong>, and then <strong>automatically combine those separate descriptions into 
		a final executable form</strong>. These approaches have been called aspect-oriented programming.
	</p>
</div>	

<p>
	That might have helped a little, but probably not enough. So keep that in your mind as we look at an example. 
	<strong>Consider logging</strong>. A common requirement for an application. And it might sound easy to create. 
	I could go into my code and into each method and add a call to a logging component, which will capture the name 
	of the method and the arguments that were passed into it. It might write them to a database or a log file, but 
	for this example let's avoid having to set up a database or open up log files and just say we're storing it in a 
	request-scope variable so that we can do something with it later:
</p>

<p>#getCodeSnippet('codesnippets/aop1.txt')#</p>	

<p>
	OK, not so bad. Maybe. But as we do this to more methods...
</p>

<p>#getCodeSnippet('codesnippets/aop2.txt')#</p>	

<p>
	That's getting ugly fast. What if we have 100 components with 10 methods each? We have to do this <strong>1000 times</strong>? 
	Manually replacing each method name in the logging call? And what if the logic changes and we want to capture the result 
	as well as the method name and arguments? If horror is sinking in, good. It should be.
</p>

<p>
	<strong>Logging is a classic cross-cutting concern</strong>. That means that it applies in a fairly generic way across all the
	different parts of our code. This is where AOP comes in. I can create a single, generic CFC and name it LoggingAdvice.
	In it, I can have logic that will log the desired information. It looks like this:
</p>

<p>#getCodeSnippet('components/LoggingAdvice.cfc')#</p>	

<p>
	Once in place, I can tell ColdSpring that I want this Logging Advice to be <strong>executed whenever a method
	is called on my original component</strong>. What ColdSpring will do is create what is known as an AOP Proxy, and my
	original component is known as a "proxied component". In essence, <strong>ColdSpring fakes out the rest of my application</strong>.
	Everything that asks for my original component actually gets back this AOP proxy. They never know that anything
	unusual is going on. To the rest of the application, <strong>the AOP proxy IS the original component</strong>.
</p>

<p>
	We won't get into the technical details of how this is done. Suffice to say that once it happens, we're
	free to run our Logging Advice or any other code we want to whenever anything tries to call the original
	component. You can see above that the Logging Advice stores the information it wants, then lets the
	method call proceed to the original component, and finally gets back the result from the original component
	and returns it. We can <strong>control exactly what happens before, during, and after the method call</strong>.
</p>

<p>
	If this sounds vaguely like it could be really, really powerful, it is. In this simple example, the XML
	configuration might look verbose, but if you imagine being able to apply the advice to dozens of methods
	at a time instead of three, the tradeoff is excellent. Here is the XML:
</p>

<p>#getCodeSnippet('config/coldspring_aop.xml', 'xml')#</p>	

<p>
	I'm creating a proxy for my LanguageService and stating that I want my LoggingAdvisor to be applied to it.
	The LoggingAdviser will be applied to all methods in my LanguageService because I used "*" for the "mapped
	names" property. (I could limit it by giving it a list of method names instead.) Whenever the Advisor finds
	a matching method name being called (in this case, any method name), it fires the LoggingAdvice.
</p>

<p>
	OK, this has been long and you probably want to see it actually work. So let's test things out by firing
	up ColdSpring and making some calls to our LanguageService. We'll show the results, as well as dump out
	the request-scoped logging data that is captured by the Advice. The code is:
</p>

<p>#getCodeSnippet('codesnippets/aop3.txt')#</p>	


<cfset languageService = beanFactory.getBean('languageService') />

<p>
Result for duplicate: #languageService.duplicateString('foo', 3)#<br />
<cfdump var="#request.logData#" label="Log data for duplicate"><br />	
</p>

<p>
Result for reverse: #languageService.reverseString('ColdSpring')#<br />
<cfdump var="#request.logData#" label="Log data for reverse"><br />	
</p>

<p>
Result for capitalize: #languageService.capitalizeString('Dependency Injection')#<br />
<cfdump var="#request.logData#" label="Log data for capitalize"><br />	
</p>

<p>
	It worked like a charm! The <strong>LoggingAdvice has been transparently and automatically applied</strong> to all of 
	the methods in my LanguageService. And I <strong>never even had to touch the LanguageService</strong> itself to do it.
	ColdSpring handled all the magic of creating the AOP Proxy for my LanguageService, and firing the
	Advice when I called methods on the LanguageService.
</p>

<div class="featurebox">	
	<h3>If Your Brain Hurts...</h3>
	<p>
		That's OK. Depending on your background and experience, this may take some time to sink in. AOP is a really
		powerful idea but it is also rather unintuitive. For now, just absorb what you've seen so far. And if
		you're up for it, consider how AOP could be very useful for things like enforcing security,
		translating data (say into JSON, or to Flex), and much more.
	</p>
</div>	


</layout:layout>
</cfoutput>