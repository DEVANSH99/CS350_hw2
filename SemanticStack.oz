\insert 'SingleAssignmentStore.oz'
\insert 'Unify.oz'

declare SemanticStack GetName FV InsertIfNew GetFVfromRec InsertIfNew Remove Union SubtList IsEq

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
   [] [bind ident(X) [procP IdentXs S]] then 
      local Curr in
         Curr = {Dictionary.get SAS Env.X}
         {Dictionary.put SAS Env.X ec(value: ([procP IdentXs S],{FV S}) es: Curr.es)}  %procP is a temp name till sir makes the change
      end
   [] [bind Exp1 Exp2] then {Unify Exp1 Exp2 Env}
   [] H|T then {SemanticStack H Env} {SemanticStack T Env}
   else skip
   end
end

fun {FV S}
   case S
   of skip then nil
   [] ident(X) then [ident(X)]
   [] [record L Xs] then {GetFVfromRec Xs}
   [] [var ident(X) S1] then {Remove ident(X) {FV S1}}
   [] [bind Exp1 Exp2] then {Union {FV Exp1} {FV Exp2}}
   [] [match ident(X) P S1 S2] then {Union [ident(X)] {Union {SubtList {FV S1} {FV P}} {FV S2}}}
   [] [procP IdentXs S1] then {SubtList {FV S1} IdentXs} %procP is a temp name till sir makes the change
   [] H|T then {Union {FV H} {FV T}}
   else skip
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
   {List.filter Xs {IsEq X}}
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
   [] H|T then {Sub {Remove H Xs} T}
   end
end

fun {IsEq A}
   fun {$ B}
      A \= B
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
