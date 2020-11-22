\insert 'SemanticStack.oz'

declare RunTest

proc {RunTest Case}
   {Dictionary.removeAll SAS}
   {SemanticStack Case {Dictionary.new}}
   {PprintSAS}
end

%PREBINDING TESTCASE 0
declare Test0
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
declare Test1
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
declare Test2
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
declare Test3
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
declare Test4
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
declare Test5
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
declare Test6
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

%BINDING TESTCASE 7
declare Test7
Test7 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(z)
	     [
	      [bind ident(x) [record literal(a) [[literal(feature1) ident(y)] [literal(featuren) literal(20)]]]]
	      [bind ident(z) [record literal(a) [[literal(featuren) literal(20)] [literal(feature1) literal(1)]]]]
	      [bind ident(y) literal(1)]
	     % [bind ident(z)  [record literal(b) [[literal(feature1) ident(y)] [literal(featuren) literal(20)]]]]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 8
declare Test8
Test8 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(z)
	     [
	      [bind ident(x) [record literal(a) [[literal(feature1) ident(y)] [literal(featuren) ident(z)]]]]
	      [bind ident(x) [record literal(a) [[literal(featuren) literal(20)] [literal(feature1) literal(20)]]]]
	     [bind ident(y) literal(20)]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

%BINDING TESTCASE 9
declare Test9
Test9 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(q)
	     [
	      [bind ident(q) [procP [ident(x1) ident(x2)] [
							   [bind ident(x1) ident(x2)]
							   [nop]
							  ]
			     ]
	      ]
	      [apply ident(q) [ident(y) literal(2)]]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

{RunTest Test9}
