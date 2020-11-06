\insert 'SingleAssignmentStore.oz'

declare SemanticStack GetName

fun {GetName X List}
	if {Dictionary.member SAS X+List.1}
	then {GetName X List.2}
	else X+List.1
	end
end

proc {SemanticStack Stack Env}
   case Stack
   of nil then skip
   [] [nop] then skip 
   [] [var ident(X) S] then if {Dictionary.member Env X}
			    			then local Env2 in
				    				Env2={Dictionary.clone Env}
				    				local Name in
				    					Name={GetName X {List.number 1 1000 1} }
				    					{Dictionary.put Env2 X Name}
				    					{AddToSAS Name}
				    					{SemanticStack S Env2}
				    				end
								end
			    			else local Name in
			    					Name={GetName X {List.number 1 1000 1} }
			    					{AddToSAS Name}
			    					{Dictionary.put Env X Name} {SemanticStack S Env} {Dictionary.remove Env X}
			    				 end
			    			end
   [] H|T then {SemanticStack H Env} {SemanticStack T Env}
   else skip
   end
end

{SemanticStack [var ident(x)
		 [
		  [var ident(y)
		   [
		    [
		     var ident(x)
		     [nop]
		    ]
		    [nop]
		   ]
		  ]
		  [nop]
		 ]
] {Dictionary.new} }
