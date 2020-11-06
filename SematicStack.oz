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


declare SAS AddToSAS RetriveFromSAS J
SAS = {Dictionary.new}

proc {AddToSAS X}
   {Dictionary.put SAS X ec(value: nil es: [X])}
end

fun {RetriveFromSAS X}
   local EC in
      EC = {Dictionary.get SAS X}
      if EC.value == nil then equivelance(X)
      else
	 	case EC.value
	 	of H|T then EC.value
	 	else literal(EC.value)
	 	end
      end   
   end
end
