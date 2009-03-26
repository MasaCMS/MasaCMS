<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfoutput>
<layout:layout section="singletons">
<h1>Managing Singleton vs. Transient Objects with ColdSpring</h1>
<p>
	Objects in your applications will tend to come in two varieties: <strong>Singletons and Transients</strong>. It is important to
	understand the difference between these since <strong>they have a fairly significant impact</strong> on what kinds of
	CFCs ColdSpring will manage most effectively.
</p>

<div class="featurebox">	
	<h3>What is a Singleton CFC?</h3>
	<p>
		A Singleton is a CFC <strong>that is only instantiated one time during the lifetime of your application</strong>. In other words,
		only one instance of it will ever exist. Most commonly, these are CFCs that are kept in shared scopes like the 
		application scope. Since most of the time you will be creating the ColdSpring BeanFactory and storing it
		in the application scope, that means the beans that ColdSpring manages are also usually stored in the application
		scope.
	</p>
	<p>
		In practice, <strong>Singletons will be CFCs that have no state</strong>, or at least no state that changes. That means that
		any instance data in a Singleton CFC will be set up at creation time and then it won't change. Since
		many different requests can be using a Singleton at the same time (since it is in the application scope),
		the fact that the CFC has no state means that the CFC is thread-safe. So if multiple requests use the
		Singleton at the same time, <strong>there is no danger of race conditions</strong> where different threads step on each
		other's data. So in OO design pattern terminology, this typically means that CFCs like Services, Gateways, 
		Data Access Objects, and Factories will be Singletons.
	</p>
	<p>
		CFCs stored in the application scope are also very succeptible to race conditions caused when developers
		fail to properly declare method-local variables. <strong>You MUST use the "var" keyword</strong> to declare method-local
		variables in all of your methods. This is critical to do, <strong>whether you use ColdSpring or not</strong>. For a dedicated 
		explanation of this requirement, read through the blog entry by Brian Kotek called 
		<a href="http://www.briankotek.com/blog/index.cfm/2007/2/6/VarScoping-Private-and-Public-Data-in-CFCs" target="_blank">Var-Scoping,
		Private, and Public Data in CFCs</a>.
	</p>
</div>	

<div class="featurebox">	
	<h3>What is a Transient CFC?</h3>
	<p>
		CFCs that are <strong>not kept in shared scopes</strong> and that require <strong>separate instances to provide different behavior
		and data</strong> are known as "transient" or "per-request" CFCs. This is because they tend to get created,
		populated with their specific set of data, are used, and then go away when that request is over. In
		most cases, transient objects will represent Domain Objects. This means things like a User, or an Address,
		or a Product.
	</p>
	<p>
		Each instance of a Product has its own specific data because they need to represent
		different Products. So ProductA may represent a bike, but ProductB may represent a book. Clearly you
		can't use the same Product object to do both because a bike has a different name, price, etc. from a book.
		So the primary difference between a Transient and a Singleton is that <strong>there can be many instances of
		a Transient</strong>, but there is <strong>only one instance of a Singleton</strong>.
	</p>
</div>	

<p>
	So why do we need to discuss this difference? Because ColdSpring is really optimized to manage Singletons.
	<strong>It is not ideal for managing Transient CFCs</strong> for a number of reasons:
	<ul>
		<li>
			The steps that ColdSpring goes through to resolved dependencies <strong>adds processing overhead</strong>.
			For Singletons, this is not a big deal because you only pay the price one time, since the CFC
			is only created once. For Transients, where lots of instances are created all the time, this
			overhead can become an issue.
		</li>
		<li>
			Transient CFCs are often related to other Transients CFCs. Because these are often Domain Objects such
			as a User, <strong>the way Domain objects are modeled will be a problem</strong>. For example, a User might be related 
			to a number of other components: User may have an array of Permission objects. There is no way
			for ColdSpring to create this relationship because there is no way for it to know which Permissions
			to get for a given User.
		</li>
		<li>
			This leads into the next problem, which is that there is <strong>no way for ColdSpring to know how to
			populate your Domain Objects with data</strong>. It can't query the database for the properties for userID 27.
			At this point we're getting into the terrirory handled by Object-Relational Mapping (ORM) frameworks
			such as <a href="http://docs.transfer-orm.com/" target="_blank">Transfer</a> 
			or <a href="http://www.reactorframework.com/" target="_blank">Reactor</a>. These frameworks are
			specifically made to create Domain Objects for you. ColdSpring integrate perfectly well with these,
			but you must understand that they do fundamentally different things.
		</li>
		<li>
			And a final related note is that because ColdSpring calls the constructors on CFCs that it manages,
			it means that <strong>you have no control over how the objects are constructed</strong>. Again, for Singletons
			this is not an issue because they have no state, but for Domain Objects that may model many different
			varities of Products or Users, this can be a problem. There's no easy way for ColdSpring to pass
			radically different pieces of data into these Domain Objects.
		</li>
	</ul>
</p>

<p>
	So the bottom line is, <strong>use ColdSpring to manage your Singleton components</strong>, but <strong>use an ORM or your own custom
	Factory to manage your Transients/Domain Objects</strong>.
</p>


</layout:layout>
</cfoutput>