declare
proc {SemanticStack Stack Env SAS}
   case Stack
   of nil then skip
   [] [nop] then skip %{Browse {Dictionary.entries Env}}
   [] [var ident(X) S] then if {Dictionary.member Env X}
			    then local Env2 in
				    Env2={Dictionary.clone Env}
				    {Dictionary.put Env2 X nil}
				    {SemanticStack S Env2 SAS}
				 end
			    else {Dictionary.put Env X nil} {SemanticStack S Env SAS} {Dictionary.remove Env X}
			    end
   [] H|T then {SemanticStack H Env SAS} {SemanticStack T Env SAS}
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
		] {Dictionary.new} nil}


