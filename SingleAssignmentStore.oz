\insert 'ProcessRecords.oz'

declare SAS AddToSAS RetrieveFromSAS BindRefToKeyInSAS BindValueToKeyInSAS
WeakSubstitute EqualExp MergeAllInSAS MergeIfEqual UpdateSAS PutValueInAllInSAS
RetrieveKeySASByValue GetName
PprintSAS

SAS = {Dictionary.new}

fun {GetName}
   {Length {Dictionary.keys SAS}} + 1
end

%Add a fresh variable to the SAS
proc {AddToSAS X}
   {Dictionary.put SAS X ec(value: nil es: [X])}
end

%Retrieve Key For A Value from the SAS
fun {RetrieveKeySASByValue X}
   case X
   of equivalence(_) then
      raise retrieveUnboundValue(X) end
   else
      skip
   end
   
   local
      fun {RetrieveAux X L}
	 case L
	 of nil then
	    local Name in
	       Name = {GetName}
	       {Dictionary.put SAS Name ec(value:X es:[Name])}
	       Name
	    end
	 [] H|T then
	    if {EqualExp X {RetrieveFromSAS H}} then
	       H
	    else
	       {RetrieveAux X T}
	    end
	 end
      end
   in
      {RetrieveAux X {Dictionary.keys SAS}}
   end
end


fun {RetrieveFromSAS X}
   local EC in
      EC = {Dictionary.get SAS X}
      if EC.value == nil then equivalence(X) else EC.value end
   end
end

fun {WeakSubstitute X}
  case X
  of equivalence(A) then {RetrieveFromSAS A}
  else X end
end

fun {EqualExp E1 E2}
   case E1
   of literal(A) then
      case E2
      of literal(!A) then
	 true
      else
	 false
      end % case E2
   [] equivalence(X) then
      case E2
      of equivalence(Y) then
	 local Ex in
	    Ex = {Dictionary.get SAS X}
	    {List.member Y Ex.es}
	 end
      else
	 false
      end % case E2
   [] record | L | Pairs1 then
      case E2
      of record | !L | Pairs2 then
	 local Canon1 Canon2 Vals in
	    Canon1 = {Canonize Pairs1.1}
	    Canon2 = {Canonize Pairs2.1}
	    if {Length Canon1} == {Length Canon2} then
	       Vals =
	       {List.zip Canon1 Canon2
		fun {$ X Y}
		   if X.1 == Y.1 then
		      {EqualExp {WeakSubstitute X.2.1} {WeakSubstitute Y.2.1}}
		   else
		      false
		   end   
		end
	       }
	       {FoldL Vals fun {$ X Y} {And X Y} end true}
	    else
	       false
	    end % if Length
	 end % local
      else 
	 false
      end % Case E2
   else
      false
   end % Case E1
end %fun

proc {MergeAllInSAS List}
   local
      proc {MergeAux A B}
	 case A
	 of nil then skip
	 [] H|T then
	    local Ex in
	       Ex = {Dictionary.get SAS H}
	       {Dictionary.put SAS H ec(value:Ex.value es:B)}
	    end
	    {MergeAux T B}
	 end %case A
      end % fun
   in
      {MergeAux List List}
   end %local
end

proc {MergeIfEqual Xs Ys}
   if Xs == Ys then
      skip
   else
      local Ex Ey in
	 Ex = {Dictionary.get SAS Xs}
	 Ey = {Dictionary.get SAS Ys}
	 if {List.member Xs Ey.es} then
	    skip
	 else
	    if {EqualExp {RetrieveFromSAS Xs} {RetrieveFromSAS Ys}} then
	       {MergeAllInSAS {Append Ex.es Ey.es}}
	    else
	       skip
	    end
	 end
      end
   end
end

proc {PutValueInAllInSAS Value List}
   local
      proc {PutAux A B}
	 case A
	 of nil then skip
	 [] H|T then
	    {Dictionary.put SAS H ec(value:Value es:B)}
	    {PutAux T B}
	 end %case A
      end % fun
   in
      {PutAux List List}
   end %local
end

proc {UpdateSAS}
   local
      proc {Outer Lo}
	 local
	    proc {Inner Xo Li}
	       case Li
	       of nil then skip
	       [] H|T then
		  {MergeIfEqual Xo H}
		  {Inner Xo T}
	       end
	    end
	 in
	    case Lo
	    of nil then skip
	    [] H|T then
	       {Inner H T}
	       {Outer T}
	    end %case Lo
	 end %local Inner
      end % proc outer
   in
      {Outer {Dictionary.keys SAS}}
   end % local outer
end

proc {BindRefToKeyInSAS X Y}
   local EX EY in
      EX = {Dictionary.get SAS X}
      EY = {Dictionary.get SAS Y}
      if {And EX.value == nil  EY.value == nil} then
	 if {List.member Y EX.es} then
	    skip
	 else
	    {PutValueInAllInSAS nil {Append EX.es EY.es}}
	 end % if {List.member }
      else
	 if EX.value \= nil then
	    raise notUndefined(X) end
	 end
	 if EY.value \= nil then
	    raise notUndefined(Y) end
	 end
      end % if Ex.value ==
   end % local EX EY
   {UpdateSAS}
   %Need to call Update SAS here also   
end % proc


proc {BindValueToKeyInSAS X E}
   local Ex Ek in
      case E
      of literal(_) then
	 Ex = {Dictionary.get SAS X}
	 if Ex.value == nil then
	    Ek = {Dictionary.get SAS {RetrieveKeySASByValue E}}
	    {PutValueInAllInSAS E Ex.es}
	    {MergeAllInSAS {Append Ek.es Ex.es}}
	 else
	    raise notUndefined(X) end 
	 end
      [] record | L | Pairs then
	 Ex = {Dictionary.get SAS X}
	 if Ex.value ==nil then
	    local Canon CanonSub Rec in
	       Canon = {Canonize Pairs.1}
	       %CanonSub = {Map Canon fun {$ X} {WeakSubstitute X.2.1}} 
	       %Rec = [record L CanonSub]
	       Rec = [record L Canon]
	       Ek = {Dictionary.get SAS {RetrieveKeySASByValue Rec}}
	       {PutValueInAllInSAS Rec Ex.es}
	       {MergeAllInSAS {Append Ek.es Ex.es}}
	    end
	 else
	    raise notUndefined(X) end
	 end
      end
   end
   % Update SAS
   {UpdateSAS}
end

proc {PprintSAS}
   local
      proc {P L}
	 case L
	 of nil then skip
	 [] H|T then
	    {Browse entry(k:H v:{Dictionary.get SAS H})}
	    {P T}
	 end
      end
   in
      {Browse '=========Printing SAS==========='}
      {P {Dictionary.keys SAS}}
      {Browse '================================'}
   end   
end
