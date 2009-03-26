
<cfset myList = "apples,oranges,ties,beans,fries" />

<cfoutput>myList before resort: #myList#<br></cfoutput>

<cfset tiesIx = ListFindNoCase(myList,"oranges") />
<cfset myList = ListDeleteAt(myList,tiesIx) />
<cfset beansIx = ListFindNoCase(myList,"beans") />
<cfset myList = ListInsertAt(myList,beansIx,"oranges") />
		
<cfoutput>myList after resort: #myList#<br></cfoutput>