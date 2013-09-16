component {
	
	function init(){
		variables.diff_match_patch = application.serviceFactory.getBean('javaLoader').create("name.fraser.neil.plaintext.diff_match_patch");
		return this;
	}

	function compute(String text1, String text2, type ="diff_main") {
		var diffOb = evaluate('variables.diff_match_patch.#type#(arguments.text1,arguments.text2)');
		
		variables.diff_match_patch.diff_cleanupSemantic(diffOb);
		
		var returnStruct = {
			diff = diffOb,
			html =  variables.diff_match_patch.diff_prettyHTML(diffOb),
			text1 = variables.diff_match_patch.diff_text1(diffOb),
			text2 = variables.diff_match_patch.diff_text2(diffOb)
		};
			
		return returnStruct;
	}

	/*
	private function prettyText(diffs) {
	   var html = '';
	    for (var diff in arguments.diffs) {
	     
	      switch (diff.operation) {
		      case 'INSERT':
		        html=html & '<ins style="background:##e6ffe6;">' & diff.text & '</ins>';
		        break;
		      case 'DELETE':
		        html=html & '<del style="background:##ffe6e6;">' & diff.text & '</del>';
		        break;
		      case 'EQUAL':
		        html=html & '<span>' & diff.text & '</span>';
		        break;
		      }
	    }
	    return html;
  }
  */

}