/*
	MOMENT.CFC
	-------------------
	Inspired by (but not a strict port of) moment.js: http://momentjs.com/
	With help from: @seancorfield, @ryanguill
	And contributions (witting or otherwise) from:
	 - Dan Switzer: https://github.com/CounterMarch/momentcfc/issues/5
	 - Ryan Heldt: http://www.ryanheldt.com/post.cfm/working-with-fuzzy-dates-and-times
	 - Ben Nadel: http://www.bennadel.com/blog/2501-converting-coldfusion-date-time-values-into-iso-8601-time-strings.htm
	 - Zack Pitts: http://stackoverflow.com/a/16309780/751
*/
component displayname="moment" {

	this.zone = '';
	this.time = '';
	this.utcTime = '';
	this.localTime = '';

	/*
		Call:
			new moment();
				-- for instance initalized to current time in current system TZ
			new moment( someTimeValue );
				-- for instance initialized to someTimeValue in current system TZ
			new moment( someTimeValue, someTZID )
				-- for instance initialized to someTimeValue in someTZID TZ
	*/
	public function init( time = now(), zone = getSystemTZ() ) {
		this.time = (time contains '{ts') ? time : parseDateTime( arguments.time );
		this.zone = zone;
		this.utc_conversion_offset = getTargetOffsetDiff( getSystemTZ(), zone, time );
		this.utcTime = TZtoUTC( arguments.time, arguments.zone );
		this.localTime = UTCtoTZ( this.utcTime, getSystemTZ() );
		return this;
	}

	//===========================================
	//MUTATORS
	//===========================================

	public function utc() hint="convert datetime to utc zone" {
		this.time = this.utcTime;
		this.zone = 'UTC';
		return this;
	}

	public function tz( required string zone ) hint="convert datetime to specified zone" {
		// this.utc_conversion_offset = getZoneCurrentOffset( arguments.zone ) * 1000;
		this.utc_conversion_offset = getTargetOffsetDiff( getSystemTZ(), this.zone, this.time );
		this.time = UTCtoTZ( this.utcTime, arguments.zone );
		this.zone = arguments.zone;
		return this;
	}

	public function add( required numeric amount, required string part ){
		part = canonicalizeDatePart( part, 'dateAdd' );
		this.time = dateAdd( part, amount, this.time );
		this.utcTime = TZtoUTC( this.time, this.zone );
		return this;
	}

	public function subtract( required numeric amount, required string part ){
		return add( -1 * amount, part );
	}

	public function startOf( required string part ){
		part = canonicalizeDatePart(part, "startOf");
		var dest = '';

		switch (part){
			case 'year':
				dest = createDateTime(year(this.localTime),1,1,0,0,0);
				break;
			case 'quarter':
				dest = createDateTime(year(this.localTime),(int((month(this.localTime)-1)/3)+1)*3-2,1,0,0,0);
				break;
			case 'month':
				dest = createDateTime(year(this.localTime),month(this.localTime),1,0,0,0);
				break;
			case 'week':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),0,0,0);
				dest = dateAdd("d", (dayOfWeek(dest)-1)*-1, dest);
				break;
			case 'day':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),0,0,0);
				break;
			case 'hour':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),hour(this.localTime),0,0);
				break;
			case 'minute':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),hour(this.localTime),minute(this.localTime),0);
				break;
			default:
				throw(message="Invalid date part value, expected one of: year, quarter, month, week, day, hour, minute; or one of their acceptable aliases (see dateTimeFormat docs)");
		}

		return init( dest, this.zone );
	}

	public function endOf(required string part) {
		part = canonicalizeDatePart(part, "startOf");

		var dest = '';
		switch (part){
			case 'year':
				dest = createDateTime(year(this.localTime),12,31,23,59,59);
				break;
			case 'quarter':
				dest = createDateTime(year(this.localTime),(int((month(this.localTime)-1)/3)+1)*3,1,23,59,59); //first day of last month of quarter (e.g. 12/1)
				dest = dateAdd('m', 1, dest); //first day of following month
				dest = dateAdd('d', -1, dest); //last day of last month of quarter
				break;
			case 'month':
				dest = createDateTime(year(this.localTime),month(this.localTime),1,23,59,59); //first day of month
				dest = dateAdd('m', 1, dest); //first day of following month
				dest = dateAdd('d', -1, dest); //last day of target month
				break;
			case 'week':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),23,59,59);
				dest = dateAdd("d", (7-dayOfWeek(dest)), dest);
				break;
			case 'day':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),23,59,59);
				break;
			case 'hour':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),hour(this.localTime),59,59);
				break;
			case 'minute':
				dest = createDateTime(year(this.localTime),month(this.localTime),day(this.localTime),hour(this.localTime),minute(this.localTime),59);
				break;
			default:
				throw(message="Invalid date part value, expected one of: year, quarter, month, week, day, hour, minute; or one of their acceptable aliases (see dateTimeFormat docs)");
		}

		return init( dest, this.zone );
	}

	//===========================================
	//STATICS
	//===========================================

	public moment function clone() hint="returns a new instance with the same time & zone" {
		return new moment( this.time, this.zone );
	}

	public moment function min( required moment a, required moment b ) hint="returns whichever moment came first" {
		if ( a.isBefore( b ) ){
			return a;
		}
		return b;
	}

	public moment function max( required moment a, required moment b ) hint="returns whichever moment came last" {
		if ( a.isAfter( b ) ){
			return a;
		}
		return b;
	}

	public numeric function diff( required moment b, part = 'seconds' ) hint="get the difference between the current date and the specified date" {
		part = canonicalizeDatePart( part, 'dateDiff' );
		if (part == 'L'){ //custom support for millisecond diffing... because adobe couldn't be bothered to support it themselves
			return b.epoch() - this.epoch();
		}
		return dateDiff( part, this.getDateTime(), b.getDateTime() );
	}

	public function getZoneCurrentOffset( required string zone ) hint="returns the offset in seconds (considering DST) of the specified zone" {
		return getTZ( arguments.zone ).getOffset( getSystemTimeMS() ) / 1000;
	}

	public string function getSystemTZ(){
		return createObject('java', 'java.util.TimeZone').getDefault().getId();
	}

	public struct function getZoneTable(){
		var list = createObject('java', 'java.util.TimeZone').getAvailableIDs();
		var data = {};
		for (tz in list){
			//display *CURRENT* offsets
			var ms = getTZ( tz ).getOffset( getSystemTimeMS() );
			data[ tz ] = readableOffset( ms );
		}
		return data;
	}

	public function getArbitraryTimeOffset( required time, required string zone ) hint="returns what the offset was at that specific moment"{
		var timezone = getTZ( zone );
		//can't use a moment for this math b/c it would cause infinite recursion: constructor uses this method
		var epic = createDateTime(1970, 1, 1, 0, 0, 0);
		var seconds = timezone.getOffset( javacast('long', dateDiff('s', epic, arguments.time)*1000) ) / 1000;
		return seconds;
	}

	//===========================================
	//TERMINATORS
	//===========================================

	public function format( required string mask ) hint="return datetime formatted with specified mask (dateTimeFormat mask rules)" {
		switch( mask ){
			case 'mysql':
				mask = 'yyyy-mm-dd HH:nn:ss';
				break;
			case 'iso8601':
			case 'mssql':
				return dateTimeFormat(this.time, 'yyyy-mm-dd') & 'T' & dateTimeFormat(this.time, 'HH:nn:ss') & 'Z';
			default:
				mask = mask;
		}

		return dateTimeFormat( this.localTime, mask, this.zone );
	}

	public function from( required moment compare ) hint="returns fuzzy-date string e.g. 2 hours ago" {
		var base = this.clone().utc();
		var L = this.min( base, compare.clone().utc() ).getDateTime();
		var R = this.max( base, compare.clone().utc() ).getDateTime();
		var diff = 0;
		//Seconds
		if (dateDiff('s', L, R) < 60){
			return 'Just now';
		}
		//Minutes
		diff = dateDiff('n', L, R);
		if (diff < 60){
			return diff & " minute#(diff gt 1 ? 's' : '')# ago";
		}
		//Hours
		diff = dateDiff('h', L, R);
		if (diff < 24){
			return diff & " hour#(diff gt 1 ? 's' : '')# ago";
		}
		//Days
		diff = dateDiff('d', L, R);
		if (diff < 7){
			return 'Last ' & dateTimeFormat(L, 'EEEE');
		}
		//Weeks
		diff = dateDiff('ww', L, R);
		if (diff == 1){
			return 'Last week';
		}else if (diff lte 4){
			return diff & ' weeks ago';
		}
		//Months/Years
		diff = dateDiff('m', L, R);
		if (diff < 12){
			return diff & " month#(diff gt 1 ? 's' : '')# ago";
		}else if (diff == 12){
			return 'Last year';
		}else{
			diff = dateDiff('yyyy', L, R);
			return diff & " year#(diff gt 1 ? 's' : '')# ago";
		}
	}

	public function fromNow() {
		var nnow = new moment().clone().utc();
		return from( nnow );
	}

	public function epoch() hint="returns the number of milliseconds since 1/1/1970 (local). Call .utc() first to get utc epoch" {
		/*
			It seems that we can't get CF to give us an actual UTC datetime object without using DateConvert(), which we
			can not rely on, because it depends on the system time being the local time converting from/to. Instead, we've
			devised a system of detecting the target time zone's offset and using it here (the only place it seems necessary)
			to return the expected epoch values.
		*/
		return this.clone().getDateTime().getTime() - this.utc_conversion_offset;
		var adjustment = (this.utc_conversion_offset > 0) ? -1 : 1;
		return this.clone().getDateTime().getTime();
		return this.clone().getDateTime().getTime() - (this.utc_conversion_offset * adjustment);
	}

	public function getDateTime() hint="return raw datetime object in current zone" {
		return this.time;
	}

	public string function getZone() hint="return the current zone" {
		return this.zone;
	}

	public numeric function getOffset() hint="returns the offset in seconds (considering DST) of the current moment" {
		return getArbitraryTimeOffset( this.time, this.zone );
	}

	public function year( newYear = '' ){
		if ( newYear == '' ){
			return getDatePart( 'year' );
		}else{
			return init(
				time: createDateTime( newYear, month(this.time), day(this.time), hour(this.time), minute(this.time), second(this.time) )
				,zone: this.zone
			);
		}
	}

	public function month( newMonth = '' ){
		if ( newMonth == '' ){
			return getDatePart( 'month' );
		}else{
			return init(
				time: createDateTime( year(this.time), newMonth, day(this.time), hour(this.time), minute(this.time), second(this.time) )
				,zone: this.zone
			);
		}
	}

	public function day( newDay = '' ){
		if ( newDay == '' ){
			return getDatePart( 'day' );
		}else{
			return init(
				time: createDateTime( year(this.time), month(this.time), newDay, hour(this.time), minute(this.time), second(this.time) )
				,zone: this.zone
			);
		}
	}

	public function hour( newHour = '' ){
		if ( newHour == '' ){
			return getDatePart( 'hour' );
		}else{
			return init(
				time: createDateTime( year(this.time), month(this.time), day(this.time), newHour, minute(this.time), second(this.time) )
				,zone: this.zone
			);
		}
	}

	public function minute( newMinute = '' ){
		if ( newMinute == '' ){
			return getDatePart( 'minute' );
		}else{
			return init(
				time: createDateTime( year(this.time), month(this.time), day(this.time), hour(this.time), newMinute, second(this.time) )
				,zone: this.zone
			);
		}
	}

	public function second( newSecond = '' ){
		if ( newSecond == '' ){
			return getDatePart( 'second' );
		}else{
			return init(
				time: createDateTime( year(this.time), month(this.time), day(this.time), hour(this.time), minute(this.time), newSecond )
				,zone: this.zone
			);
		}
	}

	//===========================================
	//QUERY
	//===========================================

	public boolean function isBefore( required moment compare, part = 'seconds' ) {
		part = canonicalizeDatePart( part, 'dateCompare' );
		return (dateCompare( this.time, compare.getDateTime(), part ) == -1);
	}

	public boolean function isSame( required moment compare, part = 'seconds' ) {
		part = canonicalizeDatePart( part, 'dateCompare' );
		return (dateCompare( this.time, compare.getDateTime(), part ) == 0);
	}

	public boolean function isAfter( required moment compare, part = 'seconds' ) {
		part = canonicalizeDatePart( part, 'dateCompare' );
		return (dateCompare( this.time, compare.getDateTime(), part ) == 1);
	}

	public boolean function isBetween( required moment a, required moment c, part = 'seconds' ) {
		part = canonicalizeDatePart( part, 'dateCompare' );
		return ( isBefore(c, part) && isAfter(a, part) );
	}

	public boolean function isDST() {
		var dt = createObject('java', 'java.util.Date').init( this.epoch() );
		return getTZ( this.zone ).inDayLightTime( dt );
	}

	//===========================================
	//INTERNAL HELPERS
	//===========================================

	private function getSystemTimeMS(){
		return createObject('java', 'java.lang.System').currentTimeMillis();
	}

	private function getTZ( id ){
		return createObject('java', 'java.util.TimeZone').getTimezone( id );
	}

	private function TZtoUTC( time, tz = getSystemTZ() ){
		var seconds = getArbitraryTimeOffset( time, tz );
		return dateAdd( 's', -1 * seconds, time );
	}

	private function UTCtoTZ( required time, required string tz ){
		var seconds = getArbitraryTimeOffset( time, tz );
		return dateAdd( 's', seconds, time );
	}

	private function readableOffset( offset ){
		var h = offset / 1000 / 60 / 60; //raw hours (decimal) offset
		var hh = fix( h ); //int hours
		var mm = ( hh == h ? ':00' : ':' & abs(round((h-hh)*60)) ); //hours modulo used to determine minutes
		var rep = ( h >= 0 ? '+' : '' ) & hh & mm;
		return rep;
	}

	private function canonicalizeDatePart( part, method = 'dateAdd' ){
		var isDateAdd = (lcase(method) == 'dateadd');
		var isDateDiff = (lcase(method) == 'datediff');
		var isDateCompare = (lcase(method) == 'datecompare');
		var isStartOf = (lcase(method) == 'startof');

		switch( lcase(arguments.part) ){
			case 'years':
			case 'year':
			case 'y':
				if (isStartOf) return 'year';
				return 'yyyy';
			case 'quarters':
			case 'quarter':
			case 'q':
				if (isStartOf) return 'quarter';
				if (!isDateCompare) return 'q';
				throw(message='DateCompare doesn''t support Quarter precision');
			case 'months':
			case 'month':
			case 'm':
				if (isStartOf) return 'month';
				return 'm';
			case 'weeks':
			case 'week':
			case 'w':
				if (isStartOf) return 'week';
				if (!isDateCompare) return 'ww';
				throw(message='DateCompare doesn''t support Week precision');
			case 'days':
			case 'day':
			case 'd':
				if (isStartOf) return 'day';
				return 'd';
			case 'weekdays':
			case 'weekday':
			case 'wd':
				if (!isDateCompare) return 'w';
				throw(message='DateCompare doesn''t support Weekday precision');
			case 'hours':
			case 'hour':
			case 'h':
				if (isStartOf) return 'hour';
				return 'h';
			case 'minutes':
			case 'minute':
			case 'n':
				if (isStartOf) return 'minute';
				return 'n';
			case 'seconds':
			case 'second':
			case 's':
				if (isStartOf) return 'second';
				return 's';
			case 'milliseconds':
			case 'millisecond':
			case 'ms':
				if (isStartOf) return 'millisecond';
				if (isDateAdd) return 'L';
				if (isDateDiff) return 'L'; //custom support for ms diffing is provided interally, because adobe sucks
				throw(message='#method# doesn''t support Millisecond precision');
		}
		throw(message='Unrecognized Date Part: `#part#`');
	}

	private function getTargetOffsetDiff( sourceTZ, destTZ, time ) hint="used to calculate what the custom offset should be, based on current target and new target"{
		var startOffset = getArbitraryTimeOffset( time, sourceTZ );
		var targetOffset = getArbitraryTimeOffset( time, destTZ );
		return (targetOffset - startOffset) * 1000;
	}

	private function getDatePart( datePart ){
		return val( format( canonicalizeDatePart( arguments.datePart ) ) );
	}

}
