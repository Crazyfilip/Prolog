% Author: Filip �ediv�
% Date: 8.4.2014

% Isomorfismus strom� v polynomi�ln�m �ase.
% Predik�t isomorfni(+G1, +G2) odpov� true v p��pad�, �e stromy jsou isomorfn� a v opa�n�, p��pad� false.
% Test isomorfnosti se p�evad� na testov�n� shody dvou kodov�n�.
% K�dov�n� stromu bude reprezentov�no seznamem.

% Graf bude reprezentov�n zp�sobem, jak� n�m byl reprezentovan na p�edn�ce.
% P�edpokladem je, �e vstupn� graf je strom a �e vrcholy a soused� jsou zad�ny jako uspo�ad�n� seznamy.

% Men�� stromy na testov�n� - izomorfn�

graf([a->[b,c],b->[a,d,e,f],c->[a],d->[b],e->[b],f->[b]]).
graf([a->[b,c,d,e],b->[a],c->[a],d->[a],e->[a,f],f->[e]]).

% V�t�� stromy na testov�n� - izomorfn�

graf([a->[c,d],b->[d],c->[a,e,f,g],d->[a,b,h],e->[c,i],f->[c],g->[c,j,k],h->[d,l,m],i->[e],j->[g,n,o],k->[g],l->[h],m->[h],n->[j],o->[j]]).
graf([a->[b,c,d],b->[a],c->[a],d->[a,e,f],e->[d,g,h,i],f->[d],g->[e,j],h->[e],i->[e,k],j->[g],k->[i,l,m],l->[k],m->[k,n,o],n->[m],o->[m]]).

% P��klad neizomorfn�ch strom� - r�zn� po�et vrchol�

graf([a->[b,c],b->[a,d,e,f],c->[a],d->[b],e->[b],f->[b]]).
graf([a->[b,c],b->[a,d],c->[a],d->[b]]).

% P��klad neizomorfn�ch strom� se stejn�m sk�re (Zde: 1,1,1,1,2,3,3)

graf([a->[c],b->[e],c->[a,d,f],d->[c,e],e->[b,d,g],f->[c],g->[e]]).
graf([a->[d],b->[c],c->[b,d,g],d->[a,c,e],e->[d,f],f->[e],g->[c]]).

isomorfni(Graf1,Graf2) :- nonvar(Graf1), nonvar(Graf2),
                          zakoduj(Graf1,Kod1),
                          zakoduj(Graf2,Kod2),!,
                          srovnej_kody(Kod1,Kod2).

% Predik�t seznam_listu (+G, -List) n�m vyd� seznam list� grafu G.

test_velikosti([_]) :- !, fail.
test_velikosti([_|_]).

seznam_listu(Graf,Seznam) :- seznam_listu(Graf,[],Seznam1),
                             reverse(Seznam1,Seznam).
seznam_listu([],Acc,Acc).
seznam_listu([_->Y|Dalsi],Acc,Seznam) :- test_velikosti(Y),
                                         !,
                                         seznam_listu(Dalsi,Acc,Seznam).
seznam_listu([X->_|Dalsi],Acc,Seznam) :- seznam_listu(Dalsi,[X|Acc],Seznam).

% Efektivn� (line�rn�) rozd�l

efek_rozdil(Sez,[],Sez).
efek_rozdil(Sez1,Sez2,Vysl) :- efek_rozdil(Sez1,Sez2,[],VyslX),
                               reverse(VyslX,Vysl).

efek_rozdil([],_,Acc,Acc).
efek_rozdil([H|T],[],Acc,Vysl) :- efek_rozdil(T,[],[H|Acc],Vysl).
efek_rozdil([H|T1],[H|T2],Acc,Vysl) :- efek_rozdil(T1,T2,Acc,Vysl).
efek_rozdil([V1|T1],[V2|T2],Acc,Vysl) :- V1 @< V2,
                                         efek_rozdil(T1,[V2|T2],[V1|Acc],Vysl).
efek_rozdil([V1|T1],[V2|T2],Acc,Vysl) :- V1 @> V2,
                                         efek_rozdil([V1|T1],T2,Acc,Vysl).
                                    
% Predik�t odeber_listy

odeber_listy(Graf1,Graf2) :- seznam_listu(Graf1,Seznam),
                             odeber_listy(Graf1,Seznam,GrafX),
                             reverse(GrafX,Graf2).

odeber_listy(Graf1,Seznam_listu,Graf2) :- odeber_listy(Graf1,Seznam_listu,Seznam_listu,GrafX),
                                          reverse(GrafX,Graf2).
odeber_listy([],_,[],_).
odeber_listy([V->Sous|Graf],Seznam_listu,[H|T],[V->New_Sous|GrafX]) :- H \== V,
                                                                       efek_rozdil(Sous,Seznam_listu,New_Sous),
                                                                       odeber_listy(Graf,Seznam_listu,[H|T],GrafX).
odeber_listy([V->_|Graf],Seznam_listu,[V|T],GrafX) :- odeber_listy(Graf,Seznam_listu,T,GrafX).

% Predik�t najdi_koren(+G, -Koreny) vyhled� ko�en(-y) stromu G. Ko�en nemus� b�t jednozna�n�, proto predik�t m��e vr�tit i dva vrcholy.

najdi_koren([V->[]],[V]).
najdi_koren([V1->[V2],V2->[V1]],[V1,V2]).
najdi_koren(Graf,Koreny) :- odeber_listy(Graf,New_graf),
                            najdi_koren(New_graf,Koreny).

% Predik�t mensi_kod(+Kod1, +Kod2, - Kod) vrac� lexikograficky men�� k�d.

mensi_kod(_,[],[]).
mensi_kod([],_,[]).
mensi_kod([H1|T1],[H2|_],[H1|T1]) :- H1 < H2.
mensi_kod([H1|_],[H2|T2],[H2|T2]) :- H1 > H2.
mensi_kod([H|T1],[H|T2],[H|Kod]) :- mensi_kod(T1,T2,Kod).

mensi_kod_por([],_).
mensi_kod_por([H|T1],[H|T2]) :- mensi_kod_por(T1,T2).
mensi_kod_por([H1|_],[H2|_]) :- H1 < H2.

% Predik�t srovnej_kody(K1,K2) porovn� jestli k�dy K1 a K2 jsou stejn�.

srovnej_kody([],[]).
srovnej_kody([H|K1],[H|K2]) :- srovnej_kody(K1,K2).

% sestav_kod , netypick� akumul�tor

zatrid(X,[Y|T],[Y|NT]) :- \+ mensi_kod_por(X,Y),
                          zatrid(X,T,NT).
zatrid(X,[Y|T],[X,Y|T]) :- mensi_kod_por(X,Y).
zatrid(X,[],[X]).

sestav_kod(Kody,[[0]|Kod]) :- sestav_kod(Kody,[[1]],Kod).
sestav_kod([],Acc,Acc).
sestav_kod([H|T],Acc,Kod) :- zatrid(H,Acc,NewAcc),
                             sestav_kod(T,NewAcc,Kod).

je_seznam([]).
je_seznam([_|T]) :- je_seznam(T).

rozbal_kod([],[]).
rozbal_kod([H|T],Kod) :- je_seznam(H), !,
                         rozbal_kod(H,Rozbaleny_H),
                         rozbal_kod(T,Rozbaleny_T),
                         append(Rozbaleny_H,Rozbaleny_T,Kod).
rozbal_kod([H|T],[H|T1]) :- rozbal_kod(T,T1).

% Predik�t zakoduj_syny(+ Synov�, + P�edek, +Seznam_kod�, - Kody_synu)

zakoduj_syny(Synove,Pred,Graf,Kody) :- zakoduj_syny(Synove,Pred,Graf,[],Kody).
zakoduj_syny([],_,_,Acc,Acc).
zakoduj_syny([H|T],Pred,Graf,Acc,Kody) :- zakoduj_korenovy(Graf,H,[Pred],KodH),
                                          zakoduj_syny(T,Pred,Graf,[KodH|Acc],Kody).

% Predik�t zakoduj_korenovy(+G, +Koreny, -Kod) vyd� kod pro ko�enov� strom (p��padn� lexikograficky men�� k�d, pokud strom m� dva ko�eny).

zakoduj_korenovy(Graf,[K],Kod) :- zakoduj_korenovy(Graf,K,[],Kod).
zakoduj_korenovy(Graf,[K1,K2],Kod) :- zakoduj_korenovy(Graf,[K1],Kod1),
                                      zakoduj_korenovy(Graf,[K2],Kod2),
                                      mensi_kod(Kod1,Kod2,Kod).
zakoduj_korenovy(Graf,Koren,Nav,Kod) :- member(Koren->Sousede,Graf),
                                        efek_rozdil(Sousede,Nav,Synove),
                                        pomocny_predikat(Synove,Koren,Graf,Kod).
pomocny_predikat([],_,_,[0,1]).
pomocny_predikat(Synove,Koren,Graf,Kod) :- zakoduj_syny(Synove,Koren,Graf,Kody_synu),
                                           sestav_kod(Kody_synu,KodX),
                                           rozbal_kod(KodX,Kod).

% Predik�t zakoduj(+G, -K) zak�du strom G a k�d vyd� pomoc� K.

zakoduj(G,Kod) :- najdi_koren(G,Koreny),
                  zakoduj_korenovy(G,Koreny,Kod).