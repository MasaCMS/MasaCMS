component extends='mura.cfobject' hint="This provides content calendar utility methods" {

  public any function setMuraScope(required muraScope) {
    variables.$ = arguments.muraScope;
    return this;
  }

  public any function fullCalendarFormat(required query data) {
    var serializer = new mura.jsonSerializer()
      .asString('id')
      .asString('url')
      .asBoolean('allDay')
      .asString('title')
      .asUTCDate('start')
      .asUTCDate('end');



    var qoq = new Query();
    qoq.setDBType('query');
    qoq.setAttributes(rs=arguments.data);
    qoq.setSQL('
      SELECT
        url as [url]
        , contentid as [id]
        , menutitle as [title]
        , displaystart as [start]
        , displaystop as [end]
        , allday as [allday]
      FROM rs
    ');

    local.rsQoQ = qoq.execute().getResult();

    return serializer.serialize(local.rsQoQ);
  }

  public any function getCalendarItems(
    calendarid='#variables.$.content('contentid')#'
    , start='#variables.$.event('year')#-#variables.$.event('month')#-1'
    , end=''
    , categoryid='#variables.$.event('categoryid')#'
    , tag='#variables.$.event('tag')#'
    , siteid='#variables.$.event('siteid')#'
    , returnFormat='query'
		, showNavOnly=0
		, showExcludeSearch=0
  ) {
    var tp = variables.$.initTracePoint('mura.content.contentCalendarUtilityBean.getCalendarItems');
    var local = {};
    var allowable=[];

    for(var i in listToArray(arguments.calendarid)){
      local.contentBean = variables.$.getBean('content').loadBy(contentid=i, siteid=arguments.siteid);

      local.applyPermFilter = variables.$.siteConfig('extranet') == 1
        && variables.$.getBean('permUtility').setRestriction(local.contentBean.getCrumbArray()).restrict == 1;

      if ( !(local.contentBean.getIsNew() || local.contentBean.getType() != 'Calendar') ) {
          arrayAppend(allowable,i);
      }
    }

    if ( !arrayLen(allowable) ) {
      return QueryNew('url,contentid,menutitle,displaystart,displaystop');
    }

    // Start Date
    if ( !IsDate(arguments.start) ) {
      arguments.start = CreateDate(Year(Now()), Month(Now()), 1);
    }

    // End Date
    if ( !IsDate(arguments.end) || ( IsDate(arguments.end) && Fix(arguments.end) < Fix(arguments.start) )  ) {
      arguments.end = CreateDate(Year(arguments.start), Month(arguments.start), DaysInMonth(arguments.start));
    }

    // start and end dates
    local.displaystart = DateFormat(arguments.start, 'yyyy-mm-dd');
    local.displaystop = DateFormat(arguments.end, 'yyyy-mm-dd');


    // the calendar feed
    local.feed = variables.$.getBean('feed')
      .setMaxItems(0) // get all records
      .setNextN(0) // no pagination
      .setSiteID(arguments.siteid)
			.setshowNavOnly(arguments.showNavOnly)
			.setshowExcludeSearch(arguments.showExcludeSearch)
      .addParam(
        relationship='AND'
        ,field='tcontent.parentid'
        ,condition=(arrayLen(allowable) > 1) ? 'IN': 'EQ'
        ,criteria=arrayToList(allowable)
      )
      // filter records with a displayStart date that is before the displayStop date
      .addParam(
        relationship='AND'
        ,field='tcontent.displaystart'
        ,condition='LTE'
        ,criteria=local.displaystop
      )
      // OPEN GROUPING
        // filter records with a displayStop date that occurs after the displayStart date
        // OR doesn't have one at all
        .addParam(relationship='andOpenGrouping')
          .addParam(
            field='tcontent.displaystop'
            ,condition='GTE'
            ,criteria=local.displaystart
          )
          .addParam(
            relationship='OR'
            ,field='tcontent.displaystop'
            ,criteria='null'
          )
        .addParam(relationship='closeGrouping');
      // CLOSE GROUPING

    // Filter on CategoryID
    if ( Len(arguments.categoryid) && IsValid('uuid', arguments.categoryid) ) {
      feed.setCategoryID(arguments.categoryid);
    }

    // Filter on Tags
    if ( Len(arguments.tag) ) {
      feed.addParam(
        relationship='AND'
        ,field='tcontenttags.tag'
        ,condition='CONTAINS'
        ,criteria=URLDecode(arguments.tag)
      );
    }

    // the recordset/query
    local.rs = local.feed.getQuery(from=local.displaystart, to=local.displaystop, applyPermFilter=local.applyPermFilter);

    // prepare to add URL column
    QueryAddColumn(local.rs, 'url', []);
    QueryAddColumn(local.rs, 'allday', []);

    for ( local.i=1; local.i<=local.rs.recordcount; local.i++ ) {
      // add URL to rs
      local.rs['url'][i] = variables.$.createHref(filename=local.rs['filename'][i],complete=1);
      // convert dates to UTC, then use browser's local tz settings to output the dates/times
      /*
      local.tempstart = DateConvert('local2utc', local.rs['displaystart'][i]);
      local.tempend = DateConvert('local2utc', local.rs['displaystop'][i]);
      local.rs['displaystart'][i] = isoDateTimeFormat(local.rs['displaystart'][i]);
      local.rs['displaystop'][i] = isoDateTimeFormat(local.rs['displaystop'][i]);
      */

      if(isDate(local.rs['displaystart'][i])
        && hour(local.rs['displaystart'][i])==0
        && minute(hour(local.rs['displaystart'][i]))==0
        && (
            !isDate(isDate(local.rs['displaystop'][i]))
            || (
                hour(local.rs['displaystart'][i])==23
                && minute(hour(local.rs['displaystart'][i]))==59
                )
            )
        ){
            local.rs['allday'][i]=1;
        } else {
            local.rs['allday'][i]=0;
        }
    }

    local.rs = filterCalendarItems(data=local.rs, maxItems=0);

    variables.$.commitTracePoint(tp);

    return arguments.returnFormat == 'iterator'
      ? variables.$.getBean('contentIterator').setQuery(local.rs)
      : local.rs;
  }

  public string function isoDateTimeFormat(date timestamp='#Now()#') {
    var dt = DateConvert('local2utc', arguments.timestamp);
    return DateFormat(dt, 'yyyy-mm-dd') & 'T' & TimeFormat(dt, 'HH:mm:ss.000') & 'Z';
  }

  public any function getDefaultDate() {
    var defaultDate = '';
    var defaultYear = IsNumeric(variables.$.event('year')) ? variables.$.event('year') : Year(Now());
    var defaultMonth = IsNumeric(variables.$.event('month')) ? variables.$.event('month') : Month(Now());
    var defaultDay = IsNumeric(variables.$.event('day')) ? variables.$.event('day') : Day(Now());

    try {
      defaultDate = DateFormat(CreateDate(defaultYear, defaultMonth, defaultDay), 'yyyy-mm-dd');
    } catch(any e) {
      defaultDate = DateFormat(Now(), 'yyyy-mm-dd');
    }

    return defaultDate;
  }

   public any function hasCustomDateParams() {
    return (isdefined('url.year') || isdefined('form.year'))
      || (isdefined('url.month') || isdefined('form.month'))
      || (isdefined('url.day') || isdefined('form.day'));
  }

  public any function filterCalendarItems(required query data, numeric maxItems=1000, string sortDirection='ASC') {
    var maxRows = !arguments.maxItems ? 100000 : arguments.maxItems;
    var qoq = new Query();
    qoq.setDBType('query');
    qoq.setAttributes(rs=arguments.data, maxRows=maxRows);
    qoq.setSQL('
      SELECT *
      FROM rs
      ORDER BY displaystart #arguments.sortDirection#
    ');
    return qoq.execute().getResult();
  }

}
