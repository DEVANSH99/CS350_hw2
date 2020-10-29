declare SAS AddToSAS RetriveFromSAS BindRefToKeyInSAS BindValueToKeyInSAS

SAS = {Dictionary.new}

proc {AddToSAS X}
   {Dictionary.put SAS X ec(value: nil es: [X])}
end

fun {RetriveFromSAS X}
   local EC in
      EC = {Dictionary.get SAS X}
      if EC.value == nil then X else EC.value end
   end
end

proc {BindRefToKeyInSAS X Y}
   local EX in
      local EY in
	 EX = {Dictionary.get SAS X}
	 EY = {Dictionary.get SAS Y}
	 if EX.value \= nil
	 then if EY.value \= nil
	      then if EX.value==EY.value
		   then skip
		   else raise
			   incompatibleTypes(X Y)
			end
		   end
	      else
		 {BindValueToKeyInSAS Y EX.value}
	      end
	 else if EY.value\=nil
	      then {BindValueToKeyInSAS X EY.value}
	      else if {List.member Y EX.es}
		   then skip
		   else local SubsRef in
		   			proc {SubsRefs Xs List}
   						case Xs
   						of nil then skip
   						else {Dictionary.put SAS Xs.1 ec(value: nil es:List)} {SubsRefs Xs.2 List}
   						end
					end
					{SubsRef EX.es {Append EX.es EY.es}} {SubsRef EY.es {Append EX.es EY.es}}
				end	
		   	end
	      end
	 end
      end
   end
end