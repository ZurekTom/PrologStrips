oper([p1,p2],[],[p3],[p1]).
oper([p2],[],[p3],[]).
oper([p3],[],[p4],[]).
oper([p3],[],[p1,p4],[]).
goal([p4],[]).


union([], L, L).
union([Head|L1tail], L2, L3) :-
        memberchk(Head, L2),
        !,
        union(L1tail, L2, L3).
union([Head|L1tail], L2, [Head|L3tail]) :-
        union(L1tail, L2, L3tail).

subtract([], _, []).
subtract([Head|Tail], L2, L3) :-
        memberchk(Head, L2),
        !,
        subtract(Tail, L2, L3).
subtract([Head|Tail1], L2, [Head|Tail3]) :-
        subtract(Tail1, L2, Tail3).

isMember(X,[X|_]).
isMember(X,[_|T]):- isMember(X,T).

commonel(X,[X|_]).
commonel(X,[_|T]):-commonel(X,T).

in([],_).
in([H|T],L):- in(T,L), isMember(H,L).

satisfied(X):- goal(Z,T), in(Z,X), \+ commonel(X,T).
move(X,Y):-oper(Xp,Xn,Zp,Zn), in(Xp,X), \+ commonel(X,Xn), subtract(X,Zn,Xdel), union(Xdel,Zp,Y), \+in(Y,X).

plan(X,[X]):- satisfied(X).
plan(X,Y):- move(X,Z), plan(Z,Y).

proposition(p1).
proposition(p2).
proposition(p3).
proposition(p4).
agentValue(valueP,2).
agentValue(valueQ,1).
agentValueProp(p1,valueP,1).
agentValueProp(p1,valueQ,2).
agentValueProp(p2,valueP,2).
agentValueProp(p2,valueQ,2).
agentValueProp(p3,valueP,2).
agentValueProp(p3,valueQ,3).
agentValueProp(p4,valueP,3).
agentValueProp(p4,valueQ,1).

notpassValue(X,Val):- agentValueProp(X,Val,Wp),agentValue(Val,Wa), >(Wa,Wp).
propBaseClean(X):- proposition(X), \+ notpassValue(X,_).

ethical(L):-findall(X,propBaseClean(X),L).

ethMove(X,Y):-ethOper(Xp,Xn,Zp,Zn), in(Xp,X), \+ commonel(X,Xn), subtract(X,Zn,Xdel), union(Xdel,Zp,Y), \+in(Y,X).
ethOper(Xp,Xn,Zp,Zn):- oper(Xp,Xn,Zp,Zn), ethical(E), in(Zp,E).

ethPlan(X,[X]):- satisfied(X).
ethPlan(X,Y):- ethMove(X,Z), ethPlan(Z,Y).
