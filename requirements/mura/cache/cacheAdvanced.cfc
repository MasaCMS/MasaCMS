component extends="mura.cache.cacheAbstract" hint="This allows Mura to use core CFML caching" output="false" {

	public any function init(name,siteid) {
		lock name="creatingCache#arguments.name##arguments.siteid#" type="exclusive" timeout=10{
			if ( ListFindNoCase('Railo,Lucee',  server.coldfusion.productname) ) {
				variables.collection=new provider.cacheLucee(argumentCollection=arguments);
			} else {
				variables.collection=new provider.cacheAdobe(argumentCollection=arguments);
			}
			variables.map=variables.collection;
		}
		return this;
	}

	public any function set(key,context,timespan=1,idleTime=1) {

		variables.collection.put( getHashKey( arguments.key ), arguments.context, arguments.timespan, arguments.idleTime );

	}

	public any function get(key,context,timespan= CreateTimeSpan(1,0,0,0) ,idleTime=CreateTimeSpan(1,0,0,0)) {

		if ( !has( arguments.key ) && isDefined("arguments.context") ) {
			set( arguments.key, arguments.context,arguments.timespan,arguments.idleTime );
		}

		if ( !has( arguments.key ) && hasParent() && getParent().has( arguments.key ) ) {
			return getParent().get( arguments.key );
		}

		if ( has( arguments.key ) ) {
			return variables.collection.get(getHashKey( arguments.key ));
		}

		if ( isDefined("arguments.context") ) {
			return arguments.context;
		} else {
			throw(message="Context not found for '#arguments.key#'");
		}
	}

	public any function purge(key) {
		variables.collection.purge(getHashKey( arguments.key ));
	}

	public any function purgeAll() {
		variables.collection.purgeAll();
	}

	public any function getAll() {
		return variables.collection.getAll();
	}

	public any function has(key) {
		return variables.collection.has(getHashKey( arguments.key ) );
	}

	public any function getCollection() {
		return variables.collection;
	}


}
