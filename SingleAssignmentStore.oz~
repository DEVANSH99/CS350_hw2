\insert 'ProcessRecords.oz'

declare SAS AddToSAS RetrieveFromSAS BindRefToKeyInSAS BindValueToKeyInSAS
WeakSubstitute EqualExp MergeAllInSAS MergeIfEqual UpdateSAS
PprintSAS

SAS = {Dictionary.new}

%Add a fresh variable to the SAS
proc {AddToSAS X}
   {Dictionary.put SAS X ec(value: nil es: [X])}
end

fun {RetrieveFromSAS X}
   local EC in
      EC = {Dictionary.get SAS X}
      if EC.value == nil then equivalence(X) else EC.value end
   end
end

proc {BindRefToKeyInSAS X Y}
   local EX EY in
      EX = {Dictionary.get SAS X}
      EY = {Dictionary.get SAS Y}
      if {And EX.value == nil  EY.value == nil} then
	 if {List.member Y EX.es} then
	    skip
	 else
	    {MergeAllInSAS nil {Append EX.es EY.es}}
%	    local SubsRefs in
%	       proc {SubsRefs Xs List}
%		  case Xs
%		  of nil then skip
%		  else
%		     {Dictionary.put SAS Xs.1 ec(value:nil es:List)}
%		     {SubsRefs Xs.2 List}
%		  end
%	       end
%	       {SubsRefs EX.es {Append EX.es EY.es}}
%	       {SubsRefs EY.es {Append EX.es EY.es}}
%	    end	% local
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

fun {WeakSubstitute X}
  case X
  of equivalence(A) then {RetrieveFromSAS A}
  else X end
end

proc {BindValueToKeyInSAS X E}
   local Ex in
      case E
      of literal(_) then
	 Ex = {Dictionary.get SAS X}
	 if Ex.value == nil
	 then
        {MergeAllInSAS E Ex.es}
	    %{Dictionary.put SAS X ec(value:E es:Ex.es)}
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
           {MergeAllInSAS Rec Ex.es}
	       %{Dictionary.put SAS X ec(value:Rec es:Ex.es)}
	    end
	 else
	    raise notUndefined(X) end
	 end
      end
   end
   % Update SAS
   {UpdateSAS}
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
	    if {Length Canon1} == {Length Canon2} then
	       Canon1 = {Canonize Pairs1.1}
	       Canon2 = {Canonize Pairs2.1}
	       Vals =
	       {List.zip Canon1 Canon2
		fun {$ X Y}
		   if X.1 == X.2 then
		      {EqualExp {WeakSubstitute X.2.1} {WeakSubstitute Y.2.1}}
		   else
		      false
		   end   
		end
	       }
	       {FoldL Vals fun {$ X Y} X==Y end true}
	    else
	       false
	    end % if Length
	 end % local
      else 
	 false
      end % Case E2
   end % Case E1
end %fun

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
	       {MergeAllInSAS Ex.value {Append Ex.es Ey.es}}
	    else
	       skip
	    end
	 end
      end
   end
end

proc {MergeAllInSAS Value List}
   local
      proc {MergeAux A B}
	 case A
	 of nil then skip
	 [] H|T then
	    local Ex in
	       Ex = {Dictionary.get SAS H}
	       {Dictionary.remove SAS H}
	       {Dictionary.put SAS H ec(value:Value es:B)}
	    end
	    {MergeAux T B}
	 end %case A
      end % fun
   in
      {MergeAux List List}
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

