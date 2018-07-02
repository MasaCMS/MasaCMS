/*
   Copyright 2007 Paul Marcotte

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   Iterator.cfc (.3)
   [2007-05-31] Added Apache license.
				Fixed bug in currentRow method.
				Dropped cfscript blocks in favour of tags in all methods but queryRowToStruct().
   [2007-05-27] Added end() method.
				Renamed rewind() to reset().
				Acknowlegement to Aaron Roberson for suggesting currentRow() method and other enhancements.
   [2007-05-10]	Initial Release.
				Acknowlegement to Peter Bell for the "Iterating Business Object" concept that Iterator seeks to provide as a composite.
 */
/**
 * This provide core iterating functionality
 */
component extends="mura.cfobject" displayname="Iterator" output="false" hint="This provide core iterating functionality" {
	variables.maxRecordsPerPage=1000;
	variables.recordTranslator="";
	variables.iteratorID="";
	variables.feed="";
	variables.recordIDField="id";
	variables.pageQueries=structNew();

	public function init() output=false {
		variables.recordIndex = 0;
		variables._recordcount = 0;
		variables.pageIndex = 1;
		variables.iteratorID="i" & hash(createUUID());
		return THIS;
	}

	public function setFeed(feed) output=false {
		variables.feed=arguments.feed;
		return this;
	}

	public function getFeed() output=false {
		return variables.feed;
	}

	public function hasFeed() output=false {
		return isObject(variables.feed);
	}

	public function getIteratorID() output=false {
		return variables.iteratorID;
	}

	public function currentIndex() output=false {
		return variables.recordIndex;
	}

	public function getCurrentIndex() output=false {
		return currentIndex();
	}

	public function setCurrentIndex(currentIndex) output=false {
		setStartRow(arguments.currentIndex);
		return this;
	}

	public function getRecordIndex() output=false {
		return variables.recordIndex;
	}

	public function getRecordIdField() output=false {
		return variables.recordIDField;
	}

	public function getPageIDList() output=false {
		var idList="";
		var i="";
		if ( getRecordCount() ) {
			if ( isArray(variables.records) ) {
				for ( i in variables.records ) {
					idList=listAppend(idList,i[getRecordIDField()]);
				}
			} else {
				for ( i=getFirstRecordOnPageIndex() ; i<=getLastRecordOnPageIndex() ; i++ ) {
					idList=listAppend(idList,variables.records[getRecordIDField()][i]);
				}
			}
		}
		return idList;
	}

	public function getFirstRecordOnPageIndex() output=false {
		var first = ((variables.pageIndex-1) * variables.maxRecordsPerPage);
		if ( first > getRecordCount() ) {
			return 1;
		} else {
			return first+1;
		}
	}

	public function getLastRecordOnPageIndex() output=false {
		var last=(((variables.pageIndex-1) * variables.maxRecordsPerPage) + variables.maxRecordsPerPage);
		if ( last > getRecordCount() ) {
			last=getRecordCount();
		}
		return last;
	}

	public function setStartRow(startRow) output=false {
		if ( getRecordCount() ) {
			if ( variables.maxRecordsPerPage != 1 ) {
				setPage(Ceiling(arguments.startRow/variables.maxRecordsPerPage));
			} else {
				setPage(arguments.startRow);
			}
			/*
				startrow in an iterator means it's queued to be next
				so the recordIndex should be set to the one before
			*/
			if ( arguments.startRow ) {
				arguments.startRow=arguments.startRow-1;
			}
			if ( variables.recordIndex != arguments.startRow && arguments.startRow < getRecordCount() ) {
				variables.recordIndex=arguments.startRow;
			}
		} else {
			variables.recordIndex=0;
			setPage(1);
		}
		return this;
	}

	public function currentRow() output=false {
		return variables.recordIndex;
	}

	public boolean function hasNext() output=false {
		return currentIndex() < getRecordCount() && currentIndex() < (getPageIndex() *  variables.maxRecordsPerPage );
	}

	public function peek() output=false {
		return packageRecord( currentIndex() + 1);
	}

	public function next() output=false {
		variables.recordIndex = currentIndex() + 1;
		return packageRecord();
	}

	public boolean function hasPrevious() output=false {
		return (currentIndex() > (((variables.pageIndex-1) * variables.maxRecordsPerPage) + 1));
	}

	public function previous() output=false {
		variables.recordIndex = currentIndex() - 1;
		return packageRecord();
	}

	public function packageRecord(recordIndex="#currentIndex()#") output=false {
		if ( isQuery(variables.records) ) {
			return queryRowToStruct(variables.records,arguments.recordIndex);
		} else if ( isArray(variables.records) ) {
			return variables.records[arguments.recordIndex];
		} else {
			throw( message="The records have not been set." );
		}
	}

	public function reset() output=false {
		variables.recordIndex = 0;
		return this;
	}

	public function end() output=false {
		variables.recordIndex = getRecordCount() + 1;
		return this;
	}

	public function pageCount() output=false {
		var pageCount = 1;
		if ( structKeyExists(variables,"maxRecordsPerPage") ) {
			pageCount = Ceiling(getRecordCount()/variables.maxRecordsPerPage);
		}
		return pageCount;
	}

	public function getPageCount() output=false {
		return pageCount();
	}

	/**
	 * For Lucee compatibility use getRecordCount()
	 */
	public function recordCount() output=false {
		return getRecordCount();
	}

	public function getRecordCount() output=false {
		return variables._recordCount;
	}

	public function getPageIndex() output=false {
		return variables.pageIndex;
	}

	public function setPage(pageIndex) output=false {
		setPageIndex(arguments.pageIndex);
		return this;
	}

	public function setPageIndex(required numeric pageIndex) output=false {
		variables.pageIndex = arguments.pageIndex;
		variables.recordIndex = ((variables.pageIndex-1) * variables.maxRecordsPerPage);
		if ( variables.recordIndex > getRecordCount() ) {
			variables.recordIndex=0;
			variables.pageIndex=1;
		}
		return this;
	}

	public function setItemsPerPage(itemsPerPage) output=false {
		setNextN(nextN=arguments.itemsPerPage);
		return this;
	}

	public function getItemsPerPage() output=false {
		return variables.maxRecordsPerPage;
	}

	public function setNextN(nextN) output=false {
		if ( isNumeric(arguments.nextN) && arguments.nextN ) {
			variables.maxRecordsPerPage=arguments.nextN;
		} else {
			variables.maxRecordsPerPage=getRecordCount();
		}
		return this;
	}

	public function getNextN() output=false {
		return variables.maxRecordsPerPage;
	}

	public function setArray(required any array, numeric maxRecordsPerPage) output=false {
		variables.records = arguments.array;
		variables._recordcount=arrayLen(arguments.array);
		if ( structKeyExists(arguments,"maxRecordsPerPage") && isNumeric(arguments.maxRecordsPerPage) ) {
			variables.maxRecordsPerPage = arguments.maxRecordsPerPage;
		} else {
			variables.maxRecordsPerPage = arrayLen(variables.records);
		}
		return this;
	}

	public function getArray() output=false {
		var array=arrayNew(1);
		var i=1;
		var qi=0;
		if ( isArray(variables.records) ) {
			return variables.records;
		} else if ( isQuery(variables.records) ) {

			if(variables.records.recordcount){
				for(qi=1;qi <= variables.records.recordcount;qi++){
						arrayAppend(array,queryRowToStruct(variables.records,qi));
				}
			}

			return array;
		} else {
			throw( message="The records have not been set." );
		}
	}

	public function setQuery(required query rs, numeric maxRecordsPerPage) output=false {
		variables.records = arguments.rs;
		variables._recordcount=rs.recordcount;
		if ( structKeyExists(arguments,"maxRecordsPerPage") && isNumeric(arguments.maxRecordsPerPage) && arguments.maxRecordsPerPage ) {
			variables.maxRecordsPerPage = arguments.maxRecordsPerPage;
		} else {
			variables.maxRecordsPerPage = getRecordCount();
		}
		return this;
	}

	public function getQuery() output=false {
		if ( isQuery(variables.records) ) {
			return variables.records;
		} else if ( isArray(variables.records) ) {
			return getBean("utility").arrayToQuery(variables.records);
		} else {
			throw( message="The records have not been set." );
		}
	}

	public struct function queryRowToStruct(required query qry) output=false {

		/**
			 * Makes a row of a query into a structure.
			 *
			 * @param query 	 The query to work with.
			 * @param row 	 Row number to check. Defaults to row 1.
			 * @return Returns a structure.
			 * @author Nathan Dintenfass (nathan@changemedia.com)
			 * @version 1, December 11, 2001
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(arguments.qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = arguments.qry[cols[ii]][row];
			}
			//return the struct
			return stReturn;
	}

	public function setPageQuery(required string queryName, queryObject="") output=false {
		variables.pageQueries["#arguments.queryName#"]=arguments.queryObject;
		return this;
	}

	public function getPageQuery(required string queryName) output=false {
		if ( structKeyExists(variables.pageQueries,"#arguments.queryName#") ) {
			return variables.pageQueries["#arguments.queryName#"];
		} else {
			return "";
		}
	}

	public function clearPageQueries() output=false {
		variables.pageQueries=structNew();
		return this;
	}


}
