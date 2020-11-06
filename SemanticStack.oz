\insert 'SingleAssignmentStore.oz'
\insert 'Unify.oz'

declare SemanticStack GetName

fun {GetName X}
   {Length {Dictionary.keys SAS}}+1
end

proc {SemanticStack Stack Env}
   case Stack
   of nil then skip
   [] [nop] then
      {Browse {Dictionary.entries SAS}} {Browse {Dictionary.entries Env}}
   [] [var ident(X) S] then
      if {Dictionary.member Env X} then
	 local Env2 Name in
	    Env2={Dictionary.clone Env}
	    Name={GetName X}
	       {Dictionary.put Env2 X Name}
	    {AddToSAS Name}
	    {SemanticStack S Env2}
	 end %Local Env2 Name
      else
	 local Name in
	    Name={GetName X}
	    {AddToSAS Name}
	    {Dictionary.put Env X Name} {SemanticStack S Env} {Dictionary.remove Env X}
	 end % Local Name
      end % if 
   [] [bind Exp1 Exp2] then {Unify Exp1 Exp2 Env}
   [] H|T then {SemanticStack H Env} {SemanticStack T Env}
   else skip
   end
end

{Dictionary.removeAll SAS}

{SemanticStack
 [var ident(x)
  [
   [var ident(y)
    [
     [var ident(z)
      [
	%[bind ident(z)
	% [record literal(label)
	%  [[literal(f1) ident(x)] [literal(f2) ident(y)]]] ]
	%[bind ident(w)
	 %[record literal(label)
	  %[[literal(f1) literal(1)] [literal(f2) literal(2)]]] ]
       [bind ident(x) literal(1)]
       [bind ident(y) literal(2)]
       [nop]
      ]
     ]
     [nop]
    ]
   ]
   [nop]
  ]
 ] {Dictionary.new} }
 
 {PprintSAS}
