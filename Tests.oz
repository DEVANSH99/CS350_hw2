%PREBINDING TESTCASE 0
\insert 'SemanticStack.oz'
{SemanticStack [var ident(x)
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
		] {Dictionary.new} }

%BINDING TESTCASE 1
\insert 'SemanticStack.oz'
{SemanticStack [var ident(x)
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
	       ] {Dictionary.new} }

%BINDING TESTCASE 2
\insert 'SemanticStack.oz'
{SemanticStack [var ident(x)
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
	       ] {Dictionary.new} }

%BINDING TESTCASE 3
\insert 'SemanticStack.oz'
{SemanticStack [var ident(x)
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
	       ] {Dictionary.new} }

%BINDING TESTCASE 4
\insert 'SemanticStack.oz'
{SemanticStack [var ident(x)
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
	       ] {Dictionary.new} }

%BINDING TESTCASE 5
\insert 'SemanticStack.oz'
{SemanticStack [var ident(x)
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
	       ] {Dictionary.new} }

%BINDING TESTCASE 6
\insert 'SemanticStack.oz'
{SemanticStack [var ident(q)
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
	       ] {Dictionary.new} }