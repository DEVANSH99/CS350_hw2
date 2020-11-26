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

%APPLY TESTCASE 9
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
	      [apply ident(q) [literal(2) ident(x)]]
	      [apply ident(q) [ident(y) literal(2)]]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]
%APPLY TESTCASE 10
declare Test10
Test10 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [var ident(q)   [bind ident(x) [procP [ident(x1)] [
							   [bind ident(x1) ident(q)]
							   [nop]
							  ]
			     ]
	      ]
	    ]
	    [nop]
	   ]
	  ]
	  [apply ident(x) [literal(5)]]
	 ]
	]

%APPLY TESTCASE 11
declare Test11
Test11 = [var ident(x)
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
	      [apply ident(q) [literal(5) ident(y)]]
	      [apply ident(q) [literal(2) ident(x)]]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	 ]

%APPLY TESTCASE 12
declare Test12
Test12 = [var ident(x)
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
	      [apply ident(q) [ident(x) ident(y)]]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	 ]

{RunTest Test12}


%APPLY TESTCASE 13
declare Test13
Test13 = [var ident(x)
	 [
	  [var ident(y)
	   [
	    [
	     var ident(z)
	     [
	      [bind ident(x) [record literal(a) [[literal(feature1) ident(10)]]]]
	      [match ident(x) [record literal(a) [[literal(feature1) ident(y)]]] [bind ident(z) ident(y)] [bind ident(z) literal(20)]]
	      [nop]
	     ]
	    ]
	    [nop]
	   ]
	  ]
	  [nop]
	 ]
	]

{RunTest Test13}
