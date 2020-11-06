\insert 'SemanticStack.oz'

declare RunTest
Test0 Test1 Test2 Test3 Test4 Test5 Test6 Test7

%PREBINDING TESTCASE 0
Test0 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(x)
	     [
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 1
Test1 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(x)
	     [
	      [bind ident(x) ident(y)]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 2
Test2 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(x)
	     [
	      [bind ident(x) literal(2)]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 3
Test3 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(x)
	     [
	      [bind ident(x) ident(y)]
	      [bind ident(x) literal(2)]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 4
Test4 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(x)
	     [
	      [bind ident(x) literal(2)]
	      [bind ident(x) ident(y)]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 5
Test5 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(x)
	     [
	      [bind ident(x) [record literal(a) [[literal(feature1) ident(y)] [literal(featuren) literal(20)]]]]
	      [nop]
		     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 6
Test6 = [var ident(q)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(x)
	     [
	      [bind ident(x) literal(2)]
	      [bind ident(y) literal(2)]
	      [bind ident(q) literal(3)]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

proc {RunTest Case}
   {Dictionary.removeAll SAS}
   {SemanticStack Case {Dictionary.new}}
   {PprintSAS}
end

{RunTest Test6}
