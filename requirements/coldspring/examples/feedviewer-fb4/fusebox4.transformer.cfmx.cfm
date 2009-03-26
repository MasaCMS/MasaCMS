<cfsilent>
<!---
Fusebox Software License
Version 1.0

Copyright (c) 2003, 2004, 2005 The Fusebox Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form or otherwise encrypted form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The end-user documentation included with the redistribution, if any, must include the following acknowledgment:

"This product includes software developed by the Fusebox Corporation (http://www.fusebox.org/)."

Alternately, this acknowledgment may appear in the software itself, if and wherever such third-party acknowledgments normally appear.

4. The names "Fusebox" and "Fusebox Corporation" must not be used to endorse or promote products derived from this software without prior written (non-electronic) permission. For written permission, please contact fusebox@fusebox.org.

5. Products derived from this software may not be called "Fusebox", nor may "Fusebox" appear in their name, without prior written (non-electronic) permission of the Fusebox Corporation. For written permission, please contact fusebox@fusebox.org.

If one or more of the above conditions are violated, then this license is immediately revoked and can be re-instated only upon prior written authorization of the Fusebox Corporation.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE FUSEBOX CORPORATION OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-------------------------------------------------------------------------------

This software consists of voluntary contributions made by many individuals on behalf of the Fusebox Corporation. For more information on Fusebox, please see <http://www.fusebox.org/>.

--->

<!--- which version of the transformer is this? --->
<cfset myFusebox.version.transformer = "4.1.0" />

<cfif myFusebox.version.runtime NEQ myFusebox.version.transformer>
	<cfthrow type="fusebox.versionMismatchException"
		message="The transformer is not the same version as the runtime" />
</cfif>
<cfscript>
  // ok ready to start work on the actual fuseaction

  /* BEGIN: THIS IS THE PREPROCESS PLUGIN SECTION */
  fb_.phase = "preProcess";
  for (fb_.i = 1; fb_.i LTE arrayLen(application.fusebox.pluginphases[fb_.phase]); fb_.i = fb_.i + 1) {
    // pass in this Plugin's parameters
    for (fb_.j = 1; fb_.j LTE arrayLen(application.fusebox.pluginphases[fb_.phase][fb_.i].parameters); fb_.j = fb_.j + 1) {
      fb_.name = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.name;
      fb_.value = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.value;
      fb_.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
      fb_.temp=structNew();
      fb_.temp.xmlName = "set";
      fb_.temp.circuit = "";
      fb_.temp.fuseaction = "";
      fb_.temp.phase = fb_.phase;
      fb_.temp.xmlAttributes = structNew();
      fb_.temp.xmlAttributes['name'] = "myFusebox.plugins.#fb_.plugin#.parameters.#fb_.name#";
      fb_.temp.xmlAttributes['value'] = fb_.value;
      arrayAppend(fb_.fuseQ, fb_.temp);
    }
    // and the Plugin itself
    fb_.temp=StructNew();
    fb_.temp.xmlName = "plugin";
    fb_.temp.circuit = myFusebox.thisCircuit;
    fb_.temp.fuseaction = myFusebox.thisFuseaction;
    fb_.temp.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i];
    fb_.temp.phase = fb_.phase;
    fb_.temp.xmlAttributes = structNew();
    fb_.temp.xmlAttributes['name'] = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
    arrayAppend(fb_.fuseQ, fb_.temp);
  }
  /* END: THIS IS THE PREPROCESS PLUGIN SECTION */

  /* let's get started working on the fuseaction */
  /* first add in all the preprocess fuseactions */
  fb_.phase = "preprocessFuseactions";

  fb_.xnPreprocessFA = application.fusebox.globalfuseactions.preprocess.xml.xmlChildren;

  for (fb_.i = 1; fb_.i LTE arraylen(fb_.xnPreprocessFA); fb_.i = fb_.i + 1) {
    // only calls to fuseactions via a <fuseaction action=""/>  (formerly only a <do> which has been deprecated!) are allowed here and it must have a fully qualified fuseaction
    if (fb_.xnPreprocessFA[fb_.i].xmlName EQ "fuseaction" OR fb_.xnPreprocessFA[fb_.i].xmlName EQ "do") {
      if (StructKeyExists(fb_.xnPreprocessFA[fb_.i].xmlAttributes, "action") AND
          ListLen(fb_.xnPreprocessFA[fb_.i].xmlAttributes['action'], '.') GTE 2) {
        fb_.temp=structNew();
        fb_.temp.xmlName = "do";
        fb_.temp.circuit = ListFirst(fb_.xnPreprocessFA[fb_.i].xmlAttributes['action'], '.');
        fb_.temp.fuseaction = ListLast(fb_.xnPreprocessFA[fb_.i].xmlAttributes['action'], '.');
        fb_.temp.phase = fb_.phase;
        fb_.temp.xmlAttributes = structNew();
        for (fb_.anItem in fb_.xnPreprocessFA[fb_.i].xmlAttributes) {
          fb_.temp.xmlAttributes[fb_.anItem] = fb_.xnPreprocessFA[fb_.i].xmlAttributes[fb_.anItem];
        }
        arrayAppend(fb_.fuseQ, fb_.temp);
      }
    }
  }

  /* now add the actual fuseaction which is the target of this page request */
  fb_.phase = "requestedFuseaction";
  fb_.temp=structNew();
  fb_.temp.xmlName = "do";
  fb_.temp.circuit = myFusebox.thisCircuit;
  fb_.temp.fuseaction = myFusebox.thisFuseaction;
  fb_.temp.phase = fb_.phase;
  fb_.temp.xmlAttributes = structNew();
  fb_.temp.xmlAttributes['action'] = "#myFusebox.originalCircuit#.#myFusebox.originalFuseaction#";
  arrayAppend(fb_.fuseQ, fb_.temp);

  /* finally add in all the postprocess fuseactions */
  fb_.phase = "postprocessFuseactions";
  fb_.xnPostprocessFA = application.fusebox.globalfuseactions.postprocess.xml.xmlChildren;

  for (fb_.i = 1; fb_.i LTE arraylen(fb_.xnPostprocessFA); fb_.i = fb_.i + 1) {
    // only calls to fuseactions via a <do> are allowed here and it must have a fully qualified fuseaction
    if (fb_.xnPostprocessFA[fb_.i].xmlName EQ "fuseaction" OR fb_.xnPostprocessFA[fb_.i].xmlName EQ "do") {
      if (StructKeyExists(fb_.xnPostprocessFA[fb_.i].xmlAttributes, "action") AND
          ListLen(fb_.xnPostprocessFA[fb_.i].xmlAttributes['action'], '.') GTE 2) {
        fb_.temp=structNew();
        fb_.temp.xmlName = "do";
        fb_.temp.circuit = ListFirst(fb_.xnPostprocessFA[fb_.i].xmlAttributes['action'], '.');
        fb_.temp.fuseaction = ListLast(fb_.xnPostprocessFA[fb_.i].xmlAttributes['action'], '.');
        fb_.temp.phase = fb_.phase;
        fb_.temp.xmlAttributes = structNew();
        for (fb_.anItem in fb_.xnPostprocessFA[fb_.i].xmlAttributes) {
          fb_.temp.xmlAttributes[fb_.anItem] = fb_.xnPostprocessFA[fb_.i].xmlAttributes[fb_.anItem];
        }
        arrayAppend(fb_.fuseQ, fb_.temp);
      }
    }
  }

  /* be sure to reset the myFusebox.thisCircuit to that of the originalCircuit */
  fb_.temp=structNew();
  fb_.temp.xmlName = "set";
  fb_.temp.circuit = myFusebox.originalCircuit;
  fb_.temp.fuseaction = myFusebox.originalFuseaction;
  fb_.temp.phase = fb_.phase;
  fb_.temp.xmlAttributes = structNew();
  fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
  fb_.temp.xmlAttributes['value'] = myFusebox.originalCircuit;
  arrayAppend(fb_.fuseQ, fb_.temp);

  /* be sure to reset the myFusebox.thisFuseaction to that of the originalFuseaction */
  fb_.temp=structNew();
  fb_.temp.xmlName = "set";
  fb_.temp.circuit = myFusebox.originalCircuit;
  fb_.temp.fuseaction = myFusebox.originalFuseaction;
  fb_.temp.phase = fb_.phase;
  fb_.temp.xmlAttributes = structNew();
  fb_.temp.xmlAttributes['name'] = "myFusebox.thisFuseaction";
  fb_.temp.xmlAttributes['value'] = myFusebox.originalFuseaction;
  arrayAppend(fb_.fuseQ, fb_.temp);

  /* BEGIN: THIS IS THE POSTPROCESS PLUGIN SECTION */
  fb_.phase = "postProcess";

  for (fb_.i = 1; fb_.i LTE arrayLen(application.fusebox.pluginphases[fb_.phase]); fb_.i = fb_.i + 1) {
    // pass in this Plugin's parameters
    for (fb_.j = 1; fb_.j LTE arrayLen(application.fusebox.pluginphases[fb_.phase][fb_.i].parameters); fb_.j = fb_.j + 1) {
      fb_.name = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.name;
      fb_.value = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.value;
      fb_.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
      fb_.temp=structNew();
      fb_.temp.xmlName = "set";
      fb_.temp.circuit = "";
      fb_.temp.fuseaction = "";
      fb_.temp.phase = fb_.phase;
      fb_.temp.xmlAttributes = structNew();
      fb_.temp.xmlAttributes['name'] = "myFusebox.plugins.#fb_.plugin#.parameters.#fb_.name#";
      fb_.temp.xmlAttributes['value'] = fb_.value;
      arrayAppend(fb_.fuseQ, fb_.temp);
    }
    // and the Plugin itself
    fb_.temp=StructNew();
    fb_.temp.xmlName = "plugin";
    fb_.temp.circuit = myFusebox.thisCircuit;
    fb_.temp.fuseaction = myFusebox.thisFuseaction;
    fb_.temp.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i];
    fb_.temp.phase = fb_.phase;
    fb_.temp.xmlAttributes = structNew();
    fb_.temp.xmlAttributes['name'] = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
    arrayAppend(fb_.fuseQ, fb_.temp);
  }
  /* END: THIS IS THE POSTPROCESS PLUGIN SECTION */

  /* BEGIN: THIS IS THE processError PLUGIN SECTION */
  fb_.phase = "processError";

  for (fb_.i = 1; fb_.i LTE arrayLen(application.fusebox.pluginphases[fb_.phase]); fb_.i = fb_.i + 1) {
    // pass in this Plugin's parameters
    for (fb_.j = 1; fb_.j LTE arrayLen(application.fusebox.pluginphases[fb_.phase][fb_.i].parameters); fb_.j = fb_.j + 1) {
      fb_.name = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.name;
      fb_.value = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.value;
      fb_.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
      fb_.temp=structNew();
      fb_.temp.xmlName = "set";
      fb_.temp.circuit = "";
      fb_.temp.fuseaction = "";
      fb_.temp.phase = fb_.phase;
      fb_.temp.xmlAttributes = structNew();
      fb_.temp.xmlAttributes['name'] = "myFusebox.plugins.#fb_.plugin#.parameters.#fb_.name#";
      fb_.temp.xmlAttributes['value'] = fb_.value;
      arrayAppend(fb_.fuseQ, fb_.temp);
    }
    // and the Plugin itself
    fb_.temp=StructNew();
    fb_.temp.xmlName = "errorHandler";
    fb_.temp.circuit = myFusebox.thisCircuit;
    fb_.temp.fuseaction = myFusebox.thisFuseaction;
    fb_.temp.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i];
    fb_.temp.phase = fb_.phase;
    fb_.temp.xmlAttributes = structNew();
    fb_.temp.xmlAttributes['name'] = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
    arrayAppend(fb_.fuseQ, fb_.temp);
  }
  /* END: THIS IS THE processError PLUGIN SECTION */
</cfscript>

<!--- now loop thru fb_.fuseQ and see if there are any <do>s to process or other special transformations such as <if> or <loop> --->
<cfset fb_.doMore = TRUE>
<cfloop condition="fb_.doMore IS TRUE">
	<cfset fb_.pointer = 1>
	<cfloop from="1" to="#arrayLen(fb_.fuseQ)#" index="fb_.pointer">
    <cfscript>
      fb_.doMore = FALSE;
      fb_.phase = "requestedFuseaction";
    </cfscript>

		<cfif fb_.fuseQ[fb_.pointer].xmlName EQ "do">
      <cfscript>
        fb_.doMore = TRUE;

        fb_.aFuseaction = fb_.fuseQ[fb_.pointer].xmlAttributes["action"];
        if (ListLen(fb_.aFuseaction, '.') EQ 1) {
          // assume no circuit means current circuit
          myFusebox.thisCircuit = fb_.fuseQ[fb_.pointer].circuit;
          myFusebox.thisFuseaction = ListFirst(fb_.aFuseaction, '.');
        }
        else {
          // parse new FA
          myFusebox.thisCircuit    = ListFirst(fb_.aFuseaction, '.');
          myFusebox.thisFuseaction = ListLast(fb_.aFuseaction, '.');
        }
      </cfscript>

			<!--- catch any last minute problems with non-existant circuits --->
			<cfif NOT IsDefined("application.fusebox.circuits.#myFusebox.thisCircuit#")>
				<cfthrow type="fusebox.undefinedCircuit" message="undefined Circuit" detail="You specified a Circuit of #myFusebox.thisCircuit# which is not defined.">
			</cfif>
			<!--- catch any last minute problems with non-existant or overloaded fuseactions --->
			<!---<cfset fb_.xnAccess = xmlSearch(application.fusebox.circuits[myFusebox.thisCircuit].xml, "//circuit/fuseaction[@name='#fuseaction#']")>--->
			<cfset fb_.xnFuseactionCount = xmlSearch(application.fusebox.circuits[myFusebox.thisCircuit].xml, "//circuit/fuseaction[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='#lcase(myFusebox.thisFuseaction)#']")>
			<cfif arrayLen(fb_.xnFuseactionCount) EQ 0>
				<cfthrow type="fusebox.undefinedFuseaction" message="undefined Fuseaction" detail="You referenced a fuseaction, #myFusebox.thisFuseaction#, which does not exist in the circuit #myFusebox.thisCircuit#.">
			</cfif>
			<cfif arrayLen(fb_.xnFuseactionCount) GT 1>
				<cfthrow type="fusebox.overloadedFuseaction" message="overloaded Fuseaction" detail="You referenced a fuseaction, #myFusebox.thisFuseaction#, which has been defined multiple times in circuit #myFusebox.thisCircuit#. Fusebox does not allow overloaded methods.">
			</cfif>

			<!--- check this fuseaction's access permissions --->
			<cfset fb_.access = application.fusebox.circuits[myFusebox.thisCircuit].fuseactions[myFusebox.thisFuseaction].access>
			<cfif fb_.access EQ "private" and myFusebox.thisCircuit NEQ fb_.fuseQ[fb_.pointer].circuit>
				<cfthrow type="fusebox.invalidAccessModifier" message="invalid access modifier" detail="The fuseaction '#myFusebox.thisCircuit#.#myFusebox.thisFuseaction#' has an access modifier of private and can only be called from within its own circuit. Use an access modifier of internal or public to make it available outside its immediate circuit.">
			</cfif>

      <cfscript>
        // set the value of myFusebox.thisCircuit
        // (both here and at the end of the parsing of this <do> so that we always return to the right value of myFusebox.thisCircuit)
        fb_.temp=structNew();
        fb_.temp.xmlName = "set";
        fb_.temp.circuit = myFusebox.thisCircuit;
        fb_.temp.fuseaction = myFusebox.thisFuseaction;
        fb_.temp.phase = fb_.phase;
        fb_.temp.xmlAttributes = structNew();
        fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
        fb_.temp.xmlAttributes['value'] = myFusebox.thisCircuit;
        ArrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
        fb_.pointer = fb_.pointer + 1;

        // set the value of myFusebox.thisFuseaction
        // (both here and at the end of the parsing of this <do> so that we always return to the right value of myFusebox.thisFuseaction)
        fb_.temp=structNew();
        fb_.temp.xmlName = "set";
        fb_.temp.circuit = myFusebox.thisCircuit;
        fb_.temp.fuseaction = myFusebox.thisFuseaction;
        fb_.temp.phase = fb_.phase;
        fb_.temp.xmlAttributes = structNew();
        fb_.temp.xmlAttributes['name'] = "myFusebox.thisFuseaction";
        fb_.temp.xmlAttributes['value'] = myFusebox.thisFuseaction;
        ArrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
        fb_.pointer = fb_.pointer + 1;

        // if this fuseaction has an exceptionHandler then insert space-holders for opening and closing <CFTRY></CFTRY> tags
        if (arrayLen(application.fusebox.pluginphases['fuseactionException']) GT 0) {
          fb_.temp=structNew();
          fb_.temp.xmlName = "beginExceptionHandler";
          fb_.temp.circuit = myFusebox.thisCircuit;
          fb_.temp.fuseaction = myFusebox.thisFuseaction;
          fb_.temp.phase = fb_.phase;
          fb_.temp.xmlAttributes = structNew();
          fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
          fb_.temp.xmlAttributes['value'] = myFusebox.thisCircuit;
          ArrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
          fb_.pointer = fb_.pointer + 1;
        }

        /* BEGIN: THIS IS THE PREFUSEACTION PLUGIN SECTION */
        fb_.phase = "preFuseaction";
        for (fb_.i = 1; fb_.i LTE arrayLen(application.fusebox.pluginphases[fb_.phase]); fb_.i = fb_.i + 1) {

          // pass in this Plugin's parameters
          for (fb_.j = 1; fb_.j LTE arrayLen(application.fusebox.pluginphases[fb_.phase][fb_.i].parameters); fb_.j = fb_.j + 1) {
            fb_.name = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.name;
            fb_.value = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.value;
            fb_.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
            fb_.temp=structNew();
            fb_.temp.xmlName = "set";
            fb_.temp.circuit = myFusebox.thisCircuit;
            fb_.temp.fuseaction = myFusebox.thisFuseaction;
            fb_.temp.phase = fb_.phase;
            fb_.temp.xmlAttributes = structNew();
            fb_.temp.xmlAttributes['name'] = "myFusebox.plugins.#fb_.plugin#.parameters.#fb_.name#";
            fb_.temp.xmlAttributes['value'] = fb_.value;
            arrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
            fb_.pointer = fb_.pointer + 1;
          }
          // and the Plugin itself
          fb_.temp=StructNew();
          fb_.temp.xmlName = "plugin";
          fb_.temp.circuit = myFusebox.thisCircuit;
          fb_.temp.fuseaction = myFusebox.thisFuseaction;
          fb_.temp.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i];
          fb_.temp.phase = fb_.phase;
          fb_.temp.xmlAttributes = structNew();
          fb_.temp.xmlAttributes['name'] = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
          arrayInsertAt(fb_.fuseQ, fb_.pointer, fb_.temp);
          fb_.pointer = fb_.pointer + 1;
        }
        /* END: THIS IS THE PREFUSEACTION PLUGIN SECTION */

        // determine what this fuseaction's code is meant to do
        // note this means (any preFuseaction fuseactions) + this Fuseaction + (any postFuseaction fuseactions)
        fb_.CircuitXML = application.fusebox.circuits[myFusebox.thisCircuit].xml;
        fb_.phase = "requestedFuseaction";

        // first handle any preFuseaction fuseactions
        fb_.xnPreFA = arrayNew(1);
        fb_.xnAnyPreFA = application.fusebox.circuits[myFusebox.thisCircuit].prefuseaction.xml;

        if (arrayLen(fb_.xnAnyPreFA) OR application.fusebox.circuits[myFusebox.thisCircuit].prefuseaction.callsuper) {
          if (application.fusebox.circuits[myFusebox.thisCircuit].prefuseaction.callsuper) {
            // the circuit's super must be called first
            fb_.xnPreFA = arrayNew(1);
            // loop over the circuitTrace for this circuit
            for (fb_.k = 1; fb_.k LTE arrayLen(application.fusebox.circuits[myFusebox.thisCircuit].circuitTrace); fb_.k = fb_.k + 1) {
              fb_.aCircuit = application.fusebox.circuits[myFusebox.thisCircuit].circuitTrace[fb_.k];
              // grab aCircuit's common super code
              fb_.xnSuperPreFA = application.fusebox.circuits[fb_.aCircuit].prefuseaction.xml;
              // loop through any prefuseaction tags
              // loop thru each entry from the super and prepend it
              for (fb_.i = arraylen(fb_.xnSuperPreFA); fb_.i GTE 1 ; fb_.i = fb_.i - 1) {
                for (fb_.j = arrayLen(fb_.xnSuperPreFA[fb_.i].xmlChildren); fb_.j GTE 1; fb_.j = fb_.j - 1) {
					// remember that any <include> needs to know its local circuit as an attribute
				  if( fb_.xnSuperPreFA[ fb_.i ].xmlChildren[ fb_.j ].xmlName IS "include" ) {
						fb_.xnSuperPreFA[ fb_.i ].xmlChildren[ fb_.j ].xmlAttributes[ 'circuit' ] = fb_.aCircuit;
				  }

                  // some special handling for do's
                  if (fb_.xnSuperPreFA[fb_.i].xmlChildren[fb_.j].xmlName EQ "do") {
                    if (ListLen(fb_.xnSuperPreFA[fb_.i].xmlChildren[fb_.j].xmlAttributes['action'], '.') EQ 1) {
                      // remember that any <do> might have only a fuseaction specified and only imply its local circuit do clarify all <do>s with explicit circuits
                      fb_.xnSuperPreFA[fb_.i].xmlChildren[fb_.j].xmlAttributes['action'] = fb_.aCircuit & "." & fb_.xnSuperPreFA[fb_.i].xmlChildren[fb_.j].xmlAttributes['action'];
                    }
                  }
                  // prepend it to what came from the child circuit
                  arrayPrepend(fb_.xnPreFA, duplicate(fb_.xnSuperPreFA[fb_.i].xmlChildren[fb_.j]));
                }

                // see if it calls *its* super; if not, then break out of this loop
                if (NOT application.fusebox.circuits[fb_.aCircuit].prefuseaction.callsuper) {
                  break;
                }
              }
              // make sure right value for myFusebox.thisCircuit is set
              fb_.temp=structNew();
              fb_.temp.xmlName = "set";
              fb_.temp.circuit = myFusebox.thisCircuit;
              fb_.temp.fuseaction = myFusebox.thisFuseaction;
              fb_.temp.phase = fb_.phase;
              fb_.temp.xmlAttributes = structNew();
              fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
              fb_.temp.xmlAttributes['value'] = fb_.aCircuit;
              arrayPrepend(fb_.xnPreFA, fb_.temp);
            }
            // since prefuseaction calls to super would have overwritten the myFusebox.thisCircuit we need to reset it again
            fb_.temp=structNew();
            fb_.temp.xmlName = "set";
            fb_.temp.circuit = myFusebox.thisCircuit;
            fb_.temp.fuseaction = myFusebox.thisFuseaction;
            fb_.temp.phase = fb_.phase;
            fb_.temp.xmlAttributes = structNew();
            fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
            fb_.temp.xmlAttributes['value'] = myFusebox.thisCircuit;
            arrayAppend(fb_.xnPreFA, fb_.temp);
            // since prefuseaction calls to super would have overwritten the myFusebox.thisFuseaction we need to reset it again
            fb_.temp=structNew();
            fb_.temp.xmlName = "set";
            fb_.temp.circuit = myFusebox.thisCircuit;
            fb_.temp.fuseaction = myFusebox.thisFuseaction;
            fb_.temp.phase = fb_.phase;
            fb_.temp.xmlAttributes = structNew();
            fb_.temp.xmlAttributes['name'] = "myFusebox.thisFuseaction";
            fb_.temp.xmlAttributes['value'] = myFusebox.thisFuseaction;
            arrayAppend(fb_.xnPreFA, fb_.temp);
          }
          else {
            fb_.xnPreFA = application.fusebox.circuits[myFusebox.thisCircuit].prefuseaction.xml.xmlChildren;
          }
        }

        /* second handle the actual fuseaction */
        fb_.xnThisFA = application.fusebox.circuits[myFusebox.thisCircuit].fuseactions[myFusebox.thisFuseaction].xml.xmlChildren;

        /* last handle any postFuseaction fuseactions */
        fb_.xnPostFA = arrayNew(1);
        fb_.xnAnyPostFA = application.fusebox.circuits[myFusebox.thisCircuit].postfuseaction.xml;

        if (arrayLen(fb_.xnAnyPostFA) OR application.fusebox.circuits[myFusebox.thisCircuit].postfuseaction.callsuper) {
          if (application.fusebox.circuits[myFusebox.thisCircuit].postfuseaction.callsuper) {
            // the circuit's super must be called *last*
            fb_.xnPostFA = arrayNew(1);
            // loop over the circuitTrace for this circuit
            for (fb_.k = 1; fb_.k LTE arrayLen(application.fusebox.circuits[myFusebox.thisCircuit].circuitTrace); fb_.k = fb_.k + 1) {
              fb_.aCircuit = application.fusebox.circuits[myFusebox.thisCircuit].circuitTrace[fb_.k];
              // grab aCircuit's common super code
              fb_.xnSuperPostFA = application.fusebox.circuits[fb_.aCircuit].postfuseaction.xml;
              // make sure right value for myFusebox.thisCircuit is set
              fb_.temp=structNew();
              fb_.temp.xmlName = "set";
              fb_.temp.circuit = myFusebox.thisCircuit;
              fb_.temp.fuseaction = myFusebox.thisFuseaction;
              fb_.temp.phase = fb_.phase;
              fb_.temp.xmlAttributes = structNew();
              fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
              fb_.temp.xmlAttributes['value'] = fb_.aCircuit;
              arrayAppend(fb_.xnPostFA, fb_.temp);
              // loop thru each entry from the super and append it
              for (fb_.i = 1; fb_.i LTE arrayLen(fb_.xnSuperPostFA); fb_.i = fb_.i + 1) {
                for (fb_.j = 1; fb_.j LTE arrayLen(fb_.xnSuperPostFA[1].xmlChildren); fb_.j = fb_.j + 1) {
					// remember that any <include> needs to know its local circuit as an attribute
				 	 	if( fb_.xnSuperPostFA[ fb_.i ].xmlChildren[ fb_.j ].xmlName IS "include" ) {
						fb_.xnSuperPostFA[ fb_.i ].xmlChildren[ fb_.j ].xmlAttributes[ 'circuit' ] = fb_.aCircuit;
				  	 	}
                  // remember that any <do> might have only a fuseaction specified and only imply its local circuit do clarify all <do>s with explicit circuits
                  if ((fb_.xnSuperPostFA[fb_.i].xmlChildren[fb_.j].xmlName EQ "do") AND
                      (ListLen(fb_.xnSuperPostFA[fb_.i].xmlChildren[fb_.j].xmlAttributes['action'], '.') EQ 1)) {
                    fb_.xnSuperPostFA[fb_.i].xmlChildren[fb_.j].xmlAttributes['action'] = fb_.aCircuit & "." & fb_.xnSuperPostFA[fb_.i].xmlChildren[fb_.j].xmlAttributes['action'];
                  }
                  // append it to what came from the child circuit
                  arrayAppend(fb_.xnPostFA, duplicate(fb_.xnSuperPostFA[fb_.i].xmlChildren[fb_.j]));
                }
              }

			  		// see if it calls *its* super; if not, then break out of this loop
			  		if (NOT application.fusebox.circuits[fb_.aCircuit].postfuseaction.callsuper) {
						break;
			  		}

            }

            // since postfuseaction calls to super would have overwritten the myFusebox.thisCircuit we need to reset it again
            fb_.temp=structNew();
            fb_.temp.xmlName = "set";
            fb_.temp.circuit = myFusebox.thisCircuit;
            fb_.temp.fuseaction = myFusebox.thisFuseaction;
            fb_.temp.phase = fb_.phase;
            fb_.temp.xmlAttributes = structNew();
            fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
            fb_.temp.xmlAttributes['value'] = myFusebox.thisCircuit;
            arrayAppend(fb_.xnPostFA, fb_.temp);

            // since postfuseaction calls to super would have overwritten the myFusebox.thisFuseaction we need to reset it again
            fb_.temp=structNew();
            fb_.temp.xmlName = "set";
            fb_.temp.circuit = myFusebox.thisCircuit;
            fb_.temp.fuseaction = myFusebox.thisFuseaction;
            fb_.temp.phase = fb_.phase;
            fb_.temp.xmlAttributes = structNew();
            fb_.temp.xmlAttributes['name'] = "myFusebox.thisFuseaction";
            fb_.temp.xmlAttributes['value'] = myFusebox.thisFuseaction;
            arrayAppend(fb_.xnPostFA, fb_.temp);
          }
          else {
            fb_.xnPostFA = application.fusebox.circuits[myFusebox.thisCircuit].postfuseaction.xml.xmlChildren;
          }
        }

        // now assemble all these together
        fb_.xnFA = arrayNew(1);
        for (fb_.i = 1; fb_.i LTE arrayLen(fb_.xnPreFA); fb_.i = fb_.i + 1) {
          arrayAppend(fb_.xnFA, duplicate(fb_.xnPreFA[fb_.i]));
        }
        for (fb_.i = 1; fb_.i LTE arrayLen(fb_.xnThisFA); fb_.i = fb_.i + 1) {
          arrayAppend(fb_.xnFA, duplicate(fb_.xnThisFA[fb_.i]));
        }
        for (fb_.i = 1; fb_.i LTE arrayLen(fb_.xnPostFA); fb_.i = fb_.i + 1) {
          arrayAppend(fb_.xnFA, duplicate(fb_.xnPostFA[fb_.i]));
        }

		 // if we don't have any verbs to execute for the fuseaction, we can skip this section
    	if (arrayLen(fb_.xnFA) GT 0) {

	        fb_.position = fb_.pointer;
	        fb_.conditionpointer = 0;
	        fb_.looppointer = 0;
	        fb_.contentpointer = 0;

	        for (fb_.j = 1; fb_.j LTE arrayLen(fb_.xnFA); fb_.j = fb_.j + 1) {
	          fb_.position = fb_.pointer-1 + fb_.j;

	          // special handling for an <if> because its children have to be included
	          if (fb_.xnFA[fb_.j].xmlName EQ "if") {
	            // handle the opening of the conditional
	            fb_.temp=StructNew();
	            fb_.temp.circuit = myFusebox.thisCircuit;
	            fb_.temp.fuseaction = myFusebox.thisFuseaction;
	            fb_.temp.phase = fb_.phase;
	            fb_.temp.xmlName = "conditional";
	            fb_.temp.xmlAttributes = StructNew();
	            fb_.temp.xmlAttributes['mode'] = "begin";
	            for (fb_.anItem in fb_.xnFA[fb_.j].xmlAttributes) {
	              fb_.temp.xmlAttributes[fb_.anItem] = fb_.xnFA[fb_.j].xmlAttributes[fb_.anItem];
	            }
							// fixed FB4.03 loop+if bug
	            //arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer, fb_.temp);
	            arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer + fb_.looppointer, fb_.temp);

	            // insert all the statements when conditional is TRUE
	            for (fb_.m = 1; fb_.m LTE arraylen(fb_.xnFA[fb_.j].xmlChildren); fb_.m = fb_.m + 1) {
	              if (fb_.xnFA[fb_.j].xmlChildren[fb_.m].xmlName EQ "true") {
	                fb_.Conditional = fb_.xnFA[fb_.j].xmlChildren[fb_.m].xmlChildren;
	                for (fb_.k = 1; fb_.k LTE arrayLen(fb_.Conditional); fb_.k = fb_.k + 1) {
	                  fb_.conditionpointer = fb_.conditionpointer + 1;
	                  fb_.tempChild=StructNew();
	                  fb_.tempChild.circuit = myFusebox.thisCircuit;
	                  fb_.tempChild.fuseaction = myFusebox.thisFuseaction;
	                  fb_.tempChild.phase = fb_.phase;
	                  fb_.tempChild.xmlName = fb_.Conditional[fb_.k].xmlName;
	                  fb_.tempChild.Attributes = StructNew();
	                  for (fb_.anItem in fb_.Conditional[fb_.k].xmlAttributes) {
	                    fb_.tempChild.xmlAttributes[fb_.anItem] = fb_.Conditional[fb_.k].xmlAttributes[fb_.anItem];
	                  }
									  // the circuit name is required for all include verbs
									  if (fb_.tempChild.xmlName EQ "include" AND NOT structKeyExists(fb_.tempChild.xmlAttributes, "circuit")) {
									  	fb_.tempChild.xmlAttributes['circuit'] = myFusebox.thisCircuit;
									  }
										// fixed FB4.03 loop+if bug
										//arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer, fb_.tempChild);
	                  arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer + fb_.looppointer, fb_.tempChild);
	                }
	              }
	            }

	            // handle the alternate of the conditional
	            fb_.conditionpointer = fb_.conditionpointer + 1;
	            fb_.temp=StructNew();
	            fb_.temp.circuit = myFusebox.thisCircuit;
	            fb_.temp.fuseaction = myFusebox.thisFuseaction;
	            fb_.temp.phase = fb_.phase;
	            fb_.temp.xmlName = "conditional";
	            fb_.temp.xmlAttributes = StructNew();
	            fb_.temp.xmlAttributes['mode'] = "else";
							// fixed FB4.03 loop+if bug
							//arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer, duplicate(fb_.temp));
	            arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer + fb_.looppointer, fb_.temp);

	            // insert all the statements when conditional is FALSE
	            for (fb_.m = 1; fb_.m LTE arraylen(fb_.xnFA[fb_.j].xmlChildren); fb_.m = fb_.m + 1) {
	              if (fb_.xnFA[fb_.j].xmlChildren[fb_.m].xmlName EQ "false") {
	                fb_.Conditional = fb_.xnFA[fb_.j].xmlChildren[fb_.m].xmlChildren;
	                for (fb_.k = 1; fb_.k LTE arrayLen(fb_.Conditional); fb_.k = fb_.k + 1) {
	                  fb_.conditionpointer = fb_.conditionpointer + 1;
	                  fb_.tempChild=StructNew();
	                  fb_.tempChild.circuit = myFusebox.thisCircuit;
	                  fb_.tempChild.fuseaction = myFusebox.thisFuseaction;
	                  fb_.tempChild.phase = fb_.phase;
	                  fb_.tempChild.xmlName = fb_.Conditional[fb_.k].xmlName;
	                  fb_.tempChild.Attributes = StructNew();
	                  for (fb_.anItem in fb_.Conditional[fb_.k].xmlAttributes) {
	                    fb_.tempChild.xmlAttributes[fb_.anItem] = fb_.Conditional[fb_.k].xmlAttributes[fb_.anItem];
	                  }
									  // the circuit name is required for all include verbs
									  if (fb_.tempChild.xmlName EQ "include" AND NOT structKeyExists(fb_.tempChild.xmlAttributes, "circuit")) {
									  	fb_.tempChild.xmlAttributes['circuit'] = myFusebox.thisCircuit;
									  }
										// fixed FB4.03 loop+if bug
										//arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer, fb_.tempChild);
	                  arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer + fb_.looppointer, fb_.tempChild);
	                }
	              }
	            }

	            // handle the closing of the conditional
	            fb_.conditionpointer = fb_.conditionpointer + 1;
	            fb_.temp=StructNew();
	            fb_.temp.circuit = myFusebox.thisCircuit;
	            fb_.temp.fuseaction = myFusebox.thisFuseaction;
	            fb_.temp.phase = fb_.phase;
	            fb_.temp.xmlName = "conditional";
	            fb_.temp.xmlAttributes = StructNew();
	            fb_.temp.xmlAttributes['mode'] = "end";
							// fixed FB4.03 loop+if bug
							//arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer, fb_.temp);
	            arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer + fb_.looppointer, fb_.temp);
	          }
	          // special handling for a <loop> because its children have to be included
	          else if (fb_.xnFA[fb_.j].xmlName EQ "loop") {
	            // handle the opening of the loop
	            fb_.temp=StructNew();
	            fb_.temp.circuit = myFusebox.thisCircuit;
	            fb_.temp.fuseaction = myFusebox.thisFuseaction;
	            fb_.temp.phase = fb_.phase;
	            fb_.temp.xmlName = "loop";
	            fb_.temp.xmlAttributes = StructNew();
	            fb_.temp.xmlAttributes['mode'] = "begin";
	            for (fb_.anItem in fb_.xnFA[fb_.j].xmlAttributes) {
	              fb_.temp.xmlAttributes[fb_.anItem] = fb_.xnFA[fb_.j].xmlAttributes[fb_.anItem];
	            }
							// fixed FB4.03 loop+if bug
	            //arrayInsertAt(fb_.fuseQ, fb_.position + fb_.looppointer, fb_.temp);
	            arrayInsertAt(fb_.fuseQ, fb_.position + fb_.looppointer + fb_.conditionpointer, fb_.temp);

	            // insert all the statements within the loop
	            fb_.Loop = fb_.xnFA[fb_.j].xmlChildren;
	            for (fb_.k = 1; fb_.k LTE arraylen(fb_.Loop); fb_.k = fb_.k + 1) {
	              fb_.looppointer = fb_.looppointer + 1;
	              fb_.tempChild=StructNew();
	              fb_.tempChild.circuit = myFusebox.thisCircuit;
	              fb_.tempChild.fuseaction = myFusebox.thisFuseaction;
	              fb_.tempChild.phase = fb_.phase;
	              fb_.tempChild.xmlName = fb_.Loop[fb_.k].xmlName;
	              fb_.tempChild.Attributes = StructNew();
	              for (fb_.anItem in fb_.Loop[fb_.k].xmlAttributes) {
	                fb_.tempChild.xmlAttributes[fb_.anItem] = fb_.Loop[fb_.k].xmlAttributes[fb_.anItem];
	              }
							  // the circuit name is required for all include verbs
							  if (fb_.tempChild.xmlName EQ "include" AND NOT structKeyExists(fb_.tempChild.xmlAttributes, "circuit")) {
								fb_.tempChild.xmlAttributes['circuit'] = myFusebox.thisCircuit;
							  }
								// fixed FB4.03 loop+if bug
								//arrayInsertAt(fb_.fuseQ, fb_.position + fb_.looppointer, fb_.tempChild);
	              arrayInsertAt(fb_.fuseQ, fb_.position + fb_.looppointer + fb_.conditionpointer, fb_.tempChild);
	            }

	            // handle the closing of the loop
	            fb_.looppointer = fb_.looppointer + 1;
	            fb_.temp=StructNew();
	            fb_.temp.circuit = myFusebox.thisCircuit;
	            fb_.temp.fuseaction = myFusebox.thisFuseaction;
	            fb_.temp.phase = fb_.phase;
	            fb_.temp.xmlName = "loop";
	            fb_.temp.xmlAttributes = StructNew();
	            fb_.temp.xmlAttributes['mode'] = "end";
							// fixed FB4.03 loop+if bug
							//arrayInsertAt(fb_.fuseQ, fb_.position + fb_.looppointer, fb_.temp);
	            arrayInsertAt(fb_.fuseQ, fb_.position + fb_.looppointer + fb_.conditionpointer, fb_.temp);
	          }
	          else {
	            // anything other than a <if> or <loop>
	            fb_.temp=StructNew();
	            fb_.temp.circuit = myFusebox.thisCircuit;
	            fb_.temp.fuseaction = myFusebox.thisFuseaction;
	            fb_.temp.phase = fb_.phase;
	            fb_.temp.xmlName = fb_.xnFA[fb_.j].xmlName;
	            fb_.temp.xmlAttributes = StructNew();
	            for (fb_.anItem in fb_.xnFA[fb_.j].xmlAttributes) {
	              fb_.temp.xmlAttributes[fb_.anItem] = fb_.xnFA[fb_.j].xmlAttributes[fb_.anItem];
	            }
				// if it's an include and doesn't already have a circuit attribute then make sure it has a "circuit" attribute
				if (fb_.xnFA[fb_.j].xmlName EQ "include") {
				  if (NOT StructKeyExists(fb_.temp.xmlAttributes, 'circuit')){
					  fb_.temp.xmlAttributes['circuit'] = myFusebox.thisCircuit;
				  }
				}
	            arrayInsertAt(fb_.fuseQ, fb_.position + fb_.conditionpointer + fb_.looppointer , fb_.temp);
	          }
	        }

	        fb_.position = fb_.position + fb_.conditionpointer + fb_.looppointer;

	        // this is where a begin/end tag for contentvariables via a <do> would be put
	        fb_.contentpointer = 0;

	        if (structKeyExists(fb_.fuseQ[fb_.position+1].xmlAttributes, "contentvariable")) {
	          fb_.temp=StructNew();
	          fb_.temp.circuit = myFusebox.thisCircuit;
	          fb_.temp.fuseaction = myFusebox.thisFuseaction;
	          fb_.temp.phase = fb_.phase;
	          fb_.temp.xmlName = "contentvariable";
	          fb_.temp.xmlAttributes = StructNew();
	          fb_.temp.xmlAttributes['contentvariable'] = fb_.fuseQ[fb_.position+1].xmlAttributes['contentvariable'];
	          fb_.temp.xmlAttributes['mode'] = "begin";
	          if (structKeyExists(fb_.fuseQ[fb_.position+1].xmlAttributes, 'append')) {
	            fb_.temp.xmlAttributes['append'] = fb_.fuseQ[fb_.position+1].xmlAttributes['append'];
	          }
	          else {
	            fb_.temp.xmlAttributes['append'] = "false";
	          }
	          if (structKeyExists(fb_.fuseQ[fb_.position+1].xmlAttributes, 'prepend')) {
	            fb_.temp.xmlAttributes['prepend'] = fb_.fuseQ[fb_.position+1].xmlAttributes['prepend'];
	          }
	          else {
	            fb_.temp.xmlAttributes['prepend'] = "false";
	          }						
	          if (structKeyExists(fb_.fuseQ[fb_.position+1].xmlAttributes, 'overwrite')) {
	            fb_.temp.xmlAttributes['overwrite'] = fb_.fuseQ[fb_.position+1].xmlAttributes['overwrite'];
	          }
	          else {
	            fb_.temp.xmlAttributes['overwrite'] = "true";
	          }
	          arrayInsertAt(fb_.fuseQ, fb_.pointer, duplicate(fb_.temp));

	          fb_.temp.xmlAttributes['mode'] = "end";
	          arrayInsertAt(fb_.fuseQ, fb_.position+2, fb_.temp);
	          fb_.contentpointer = 2;
	        }

			fb_.pointer = fb_.position + 1 + fb_.contentpointer;
    	} // end of skip for verbless fuseaction

        // BEGIN: THIS IS THE POSTFUSEACTION PLUGIN SECTION
        fb_.phase = "postFuseaction";
        for (fb_.i = 1; fb_.i LTE arrayLen(application.fusebox.pluginphases[fb_.phase]); fb_.i = fb_.i + 1) {

          // pass in this Plugin's parameters
          for (fb_.j = 1; fb_.j LTE arrayLen(application.fusebox.pluginphases[fb_.phase][fb_.i].parameters); fb_.j = fb_.j + 1) {
            fb_.name = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.name;
            fb_.value = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.value;
            fb_.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
            fb_.temp=structNew();
            fb_.temp.xmlName = "set";
            fb_.temp.circuit = myFusebox.thisCircuit;
            fb_.temp.fuseaction = myFusebox.thisFuseaction;
            fb_.temp.phase = fb_.phase;
            fb_.temp.xmlAttributes = structNew();
            fb_.temp.xmlAttributes['name'] = "myFusebox.plugins.#fb_.plugin#.parameters.#fb_.name#";
            fb_.temp.xmlAttributes['value'] = fb_.value;
            arrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
            fb_.pointer = fb_.pointer + 1;
          }
          // and the Plugin itself
          fb_.temp=StructNew();
          fb_.temp.xmlName = "plugin";
          fb_.temp.circuit = myFusebox.thisCircuit;
          fb_.temp.fuseaction = myFusebox.thisFuseaction;
          fb_.temp.phase = fb_.phase;
          fb_.temp.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i];
          fb_.temp.xmlAttributes = structNew();
          fb_.temp.xmlAttributes['name'] = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
          arrayInsertAt(fb_.fuseQ, fb_.pointer, fb_.temp);
          fb_.pointer = fb_.pointer + 1;
        }
        // END: THIS IS THE POSTFUSEACTION PLUGIN SECTION

        /* BEGIN: THIS IS THE fuseactionException PLUGIN SECTION */
        fb_.phase = "fuseactionException";
        for (fb_.i = 1; fb_.i LTE arrayLen(application.fusebox.pluginphases[fb_.phase]); fb_.i = fb_.i + 1) {

          // pass in this Plugin's parameters
          for (fb_.j = 1; fb_.j LTE arrayLen(application.fusebox.pluginphases[fb_.phase][fb_.i].parameters); fb_.j = fb_.j + 1) {
            fb_.name = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.name;
            fb_.value = application.fusebox.pluginphases[fb_.phase][fb_.i].parameters[fb_.j].xmlAttributes.value;
            fb_.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
            fb_.temp=structNew();
            fb_.temp.circuit = myFusebox.thisCircuit;
            fb_.temp.fuseaction = myFusebox.thisFuseaction;
            fb_.temp.phase = fb_.phase;
            fb_.temp.xmlName = "set";
            fb_.temp.xmlAttributes = structNew();
            fb_.temp.xmlAttributes['name'] = "myFusebox.plugins.#fb_.plugin#.parameters.#fb_.name#";
            fb_.temp.xmlAttributes['value'] = fb_.value;
            arrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
            fb_.pointer = fb_.pointer + 1;
          }
          // and the Plugin itself
          fb_.temp=StructNew();
          fb_.temp.xmlName = "exceptionHandler";
          fb_.temp.circuit = myFusebox.thisCircuit;
          fb_.temp.fuseaction = myFusebox.thisFuseaction;
          fb_.temp.phase = fb_.phase;
          fb_.temp.plugin = application.fusebox.pluginphases[fb_.phase][fb_.i];
          fb_.temp.xmlAttributes = structNew();
          fb_.temp.xmlAttributes['name'] = application.fusebox.pluginphases[fb_.phase][fb_.i].name;
          arrayInsertAt(fb_.fuseQ, fb_.pointer, fb_.temp);
          fb_.pointer = fb_.pointer + 1;
        }
        /* END: THIS IS THE fuseactionException PLUGIN SECTION */

        // if this fuseaction has an exceptionHandler then insert space-holders for opening and closing <CFTRY></CFTRY> tags
        // we also did this when first parsing this <do>
        if (arrayLen(application.fusebox.pluginphases['fuseactionException']) GT 0) {
          fb_.temp=structNew();
          fb_.temp.xmlName = "endExceptionHandler";
          fb_.temp.circuit = myFusebox.thisCircuit;
          fb_.temp.fuseaction = myFusebox.thisFuseaction;
          fb_.temp.phase = fb_.phase;
          fb_.temp.xmlAttributes = structNew();
          fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
          fb_.temp.xmlAttributes['value'] = myFusebox.thisCircuit;
          arrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
          fb_.pointer = fb_.pointer + 1;
        }

        // set the value of myFusebox.thisFuseaction
        // (this was also done at the beginning of the parsing of this <do> so that we always return to the right value of myFusebox.thisFuseaction)
        fb_.temp=structNew();
        fb_.temp.xmlName = "set";
        fb_.temp.circuit = fb_.fuseQ[fb_.pointer].circuit;
        fb_.temp.fuseaction = fb_.fuseQ[fb_.pointer].fuseaction;
        fb_.temp.phase = fb_.phase;
        fb_.temp.xmlAttributes = structNew();
        fb_.temp.xmlAttributes['name'] = "myFusebox.thisFuseaction";
        fb_.temp.xmlAttributes['value'] = fb_.fuseQ[fb_.pointer].fuseaction;
        arrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
        fb_.pointer = fb_.pointer + 1;

        // set the value of myFusebox.thisCircuit
        // (this was also done at the beginning of the parsing of this <do> so that we always return to the right value of myFusebox.thisCircuit)
        fb_.temp=structNew();
        fb_.temp.xmlName = "set";
        fb_.temp.circuit = fb_.fuseQ[fb_.pointer].circuit;
        fb_.temp.fuseaction = fb_.fuseQ[fb_.pointer].fuseaction;
        fb_.temp.phase = fb_.phase;
        fb_.temp.xmlAttributes = structNew();
        fb_.temp.xmlAttributes['name'] = "myFusebox.thisCircuit";
        fb_.temp.xmlAttributes['value'] = fb_.fuseQ[fb_.pointer].circuit;
        arrayInsertAt( fb_.fuseQ, fb_.pointer, fb_.temp);
        fb_.pointer = fb_.pointer + 1;

        // we're done substituting for this "do", so we kill it off
        arrayDeleteAt(fb_.fuseQ, fb_.pointer);
      </cfscript>

			<cfbreak>
		</cfif>

	</cfloop>
</cfloop>


</cfsilent>
