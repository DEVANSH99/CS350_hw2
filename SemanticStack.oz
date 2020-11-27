\insert 'SingleAssignmentStore.oz'
\insert 'Unify.oz'

declare SemanticStack FV InsertIfNew GetFVfromRec InsertIfNew Remove Union SubtList IsNotEq MatchExp UpdateEnvForMatch PairwiseUpdateEnv InsertInFVDict UpdateEnvApply

proc {SemanticStack Stack Env}
   case Stack
   of nil then skip
   [] [nop] then
      {Browse {Dictionary.entries SAS}}
   [] [var ident(X) S] then
      if {Dictionary.member Env X} then
	 local Env2 Name in
	    Env2={Dictionary.clone Env}
	    Name={GetName}
	       {Dictionary.put Env2 X Name}
	    {AddToSAS Name}
	    {SemanticStack S Env2}
	 end %Local Env2 Name
      else
	 local Name in
	    Name={GetName}
	    {AddToSAS Name}
	    {Dictionary.put Env X Name} {SemanticStack S Env} {Dictionary.remove Env X}
	 end % Local Name
      end % if 
   [] [bind ident(X) [procP IdentXs S]] then 
      local Curr FVDict FVs in
         FVDict = {Dictionary.new}
         FVs = {SubtList {FV S} IdentXs}
         {InsertInFVDict FVDict FVs Env}
         Curr = {Dictionary.get SAS Env.X}
         {Dictionary.put SAS Env.X ec(value: p(1: [procP IdentXs S] 2: FVDict) es: Curr.es)}  %procP change in syntax from hw file
      end
   [] [bind Exp1 Exp2] then {Unify Exp1 Exp2 Env}
   [] [match ident(X) P S1 S2] then
      local Env2 in
	 Env2={Dictionary.clone Env}
	 if {MatchExp {RetrieveFromSAS Env.X} P} then 
      {UpdateEnvForMatch Env2 {RetrieveFromSAS Env.X} P}
      {SemanticStack S1 Env2}
	 else {SemanticStack S2 Env}
	 end
      end
   [] [apply ident(F) IdentXs] then 		%IdentXs change in syntax from hw file
   		local Func Env2 in
   			Func={Dictionary.condGet SAS Env.F ~1}
   			if Func\=~1
   			then case Func.value 
   				 of p(1:[procP IdentYs S] 2:CE) then if {Length IdentXs}=={Length IdentYs}
   				 									 then Env2 = {Dictionary.clone CE}
   				 									 	  {UpdateEnvApply Env Env2 IdentYs IdentXs} 
   				 									 	  {SemanticStack S Env2}
   				 									 else raise notUndefined(F) end
   				 									 end
   				 else raise notUndefined(F) end
   				 end
   			else raise notUndefined(F) end
   			end
   		end 
   [] H|T then {SemanticStack H Env} {SemanticStack T Env}
   else skip
   end
end


fun {FV S}
   case S
   of nil then nil
   [] [nop] then nil
   [] ident(X) then [ident(X)]
   [] [record _ Xs] then {GetFVfromRec Xs}
   [] [var ident(X) S1] then {Remove ident(X) {FV S1}}
   [] [bind Exp1 Exp2] then {Union {FV Exp1} {FV Exp2}}
   [] [match ident(X) P S1 S2] then {Union [ident(X)] {Union {SubtList {FV S1} {FV P}} {FV S2}}}
   [] [procP IdentXs S1] then {SubtList {FV S1} IdentXs} %procP is a temp name till sir makes the change
   [] H|T then {Union {FV H} {FV T}}
   end
end

fun {GetFVfromRec Xs}
   case Xs
   of nil then nil
   [] H|T then {Union {FV H.2.1} {GetFVfromRec T}}
   end
end   

fun {InsertIfNew X Xs}
   if {List.member X Xs} then Xs else X|Xs end
end

fun {Remove X Xs}
   {List.filter Xs {IsNotEq X}}
end

fun {Union Xs Ys}
   case Ys
   of nil then Xs
   [] H|T then {Union {InsertIfNew H Xs} T}
   end
end

fun {SubtList Xs Ys}
   case Ys
   of nil then Xs
   [] H|T then {SubtList {Remove H Xs} T}
   end
end

fun {IsNotEq A}
   fun {$ B}
      A \= B
   end
end

fun {MatchExp E1 E2}
   case E1
   of literal(A) then
      case E2
      of literal(!A) then true
      else false % case of E2 being ident(A) has already been checked
      end % case E2
   [] equivalence(_) then false % case of E2 being ident(A) has already been checked
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
		   {Browse 1}
		   if X.1 == Y.1 then
		   	  {Browse 11}
		      if Y.2.1 == '_' then true 
		      else
			 case Y.2.1
			 of ident(_) then true
			 else 
			 {MatchExp {WeakSubstitute X.2.1} Y.2.1}
			 end
		      end
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
   end % Case E1
end %fun

proc {UpdateEnvApply Env1 Env2 Ys Xs}
	case Ys
	of nil then skip
	else case Ys.1
		 of ident(Q) then case Xs.1
	     				  of ident(P) then {Browse P} {Browse Q}{Dictionary.put Env2 Q Env1.P} {UpdateEnvApply Env1 Env2 Ys.2 Xs.2}
	     				  else local Name in
	    	  						Name = {GetName}
	    	  						{Browse Xs.1} {Browse ident(Q)}
	    	  						{AddToSAS Name}
	    	  						{Dictionary.put Env2 Q Name}
	    	  						{Unify ident(Q) Xs.1 Env2}
	    	  						{UpdateEnvApply Env1 Env2 Ys.2 Xs.2}
	    	  			  	   end
	    	  			  end
	     else raise notUndefined(Ys.1) end
	     end
	 end
end


proc {UpdateEnvForMatch Env E1 E2}
   case E1
   of literal(_) then
      case E2
      of ident(Y) then {Dictionary.put Env Y {RetrieveKeySASByValue E1}}
      else skip
      end
   [] equivalence(X) then
      case E2
      of ident(Y) then {Dictionary.put Env Y X}
      else skip
      end % case E2
   [] record | L | Pairs1 then
      case E2
      of record | !L | Pairs2 then
	 local Canon1 Canon2 in
	    Canon1 = {Canonize Pairs1.1}
	    Canon2 = {Canonize Pairs2.1}
	    {PairwiseUpdateEnv Env Canon1 Canon2}
	 end % local
      [] ident(Y) then {Dictionary.put Env Y {RetrieveKeySASByValue E1 }}
      else skip
      end % Case E2
   end % Case E1
end %fun

proc {PairwiseUpdateEnv Env Xs Ys}
   case Xs#Ys
   of nil#nil then skip
   [] (X|T1)#(Y|T2) then
      if Y.2.1 == '_' then skip
      else
	 {UpdateEnvForMatch Env {WeakSubstitute X.2.1} Y.2.1}
	 {PairwiseUpdateEnv Env T1 T2}
      end
   end
end

proc {InsertInFVDict FVDict FVs Env}
   case FVs
   of nil then skip
   [] ident(X)|T then
      {Dictionary.put FVDict X Env.X}
      {InsertInFVDict FVDict T Env}
   end
end

%{Dictionary.removeAll SAS}
%
%{SemanticStack
% [var ident(x)
%  [
%   [var ident(y)
%    [
%     [var ident(z)
%      [
%	%[bind ident(z)
%	% [record literal(label)
%	%  [[literal(f1) ident(x)] [literal(f2) ident(y)]]] ]
%	%[bind ident(w)
%	 %[record literal(label)
%	  %[[literal(f1) literal(1)] [literal(f2) literal(2)]]] ]
%       [bind ident(x) literal(1)]
%       [bind ident(y) literal(2)]
%       [nop]
%      ]
%     ]
%     [nop]
%    ]
%   ]
%   [nop]
%  ]
% ] {Dictionary.new} }
% 
% {PprintSAS}
